import datetime
import json
import logging
import math
import os
import typing

import boto3

logging.basicConfig(
    format="%(asctime)s %(levelname)-8s %(message)s",
    level=logging.INFO,
)
logger = logging.getLogger("ri-purchaser")

DRY_RUN = os.environ.get("DRY_RUN", "0") != "0"
EMAIL_RECIPIENT = os.environ.get("EMAIL_RECIPIENT", "${email_recipient}")
EMAIL_SENDER = os.environ.get("EMAIL_SENDER", "${email_sender}")
INSTANCE_PLATFORM = os.environ.get("INSTANCE_PLATFORM", "${instance_platform}")
INSTANCE_TENANCY = os.environ.get("INSTANCE_TENANCY", "${instance_tenancy}")
INSTANCE_TYPE = os.environ.get("INSTANCE_TYPE", "${instance_type}")
MAX_TOTAL_INSTANCES = int(
    os.environ.get("MAX_TOTAL_INSTANCES", "${max_total_instances}")
)
OFFER_MAX_DURATION_DAYS = int(
    os.environ.get("OFFER_MAX_DURATION_DAYS", "${offer_max_duration_days}")
)
OFFER_MAX_HOURLY_PRICE = float(
    os.environ.get("OFFER_MAX_HOURLY_PRICE", "${offer_max_hourly_price}")
)


def get_monthly_new_reserved_instance_quota() -> int:
    quota_client = typing.cast(typing.Any, boto3.client("service-quotas"))
    response: typing.Any = quota_client.get_service_quota(
        ServiceCode="ec2",
        QuotaCode="L-D0B7243C",
    )
    monthly_quota_for_new_ri = int(response["Quota"]["Value"])
    logger.info(f"Monthly quota for new RI is {monthly_quota_for_new_ri}")
    return monthly_quota_for_new_ri


def calc_start_of_month() -> datetime.datetime:
    now = datetime.datetime.now(datetime.timezone.utc)
    start_of_month = datetime.datetime(
        now.year,
        now.month,
        1,
        tzinfo=datetime.timezone.utc,
    )
    return start_of_month


def get_existing_reserved_instances(
    ec2_client: typing.Any,
) -> tuple[int, int]:
    """Get count of existing RIs and those purchased this month."""
    response = ec2_client.describe_reserved_instances(
        Filters=[{"Name": "state", "Values": ["active", "payment-pending"]}],
    )
    reserved_instance_list = response["ReservedInstances"]

    num_current_active_ri = sum(
        ri["InstanceCount"]
        for ri in reserved_instance_list
        if ri["InstanceType"] == INSTANCE_TYPE
        and ri["InstanceTenancy"] == INSTANCE_TENANCY
    )
    start_of_month = calc_start_of_month()
    num_ri_purchased_this_month = sum(
        ri["InstanceCount"]
        for ri in reserved_instance_list
        if ri["InstanceType"] == INSTANCE_TYPE
        and ri["InstanceTenancy"] == INSTANCE_TENANCY
        and ri["Start"] >= start_of_month
    )

    logger.info(
        f"RIs purchased this month: {num_ri_purchased_this_month} / {num_current_active_ri} total"
    )
    return num_current_active_ri, num_ri_purchased_this_month


def get_all_ri_offerings(
    ec2_client: typing.Any,
) -> list[dict[str, typing.Any]]:
    response = ec2_client.describe_reserved_instances_offerings(
        Filters=[{"Name": "instance-tenancy", "Values": [INSTANCE_TENANCY]}],
        IncludeMarketplace=True,
        InstanceType=INSTANCE_TYPE,
        ProductDescription=INSTANCE_PLATFORM,
        OfferingClass="standard",
        OfferingType="No Upfront",
    )
    all_offers = response["ReservedInstancesOfferings"]
    filtered_offers = [
        offer
        for offer in all_offers
        if offer.get("CurrencyCode", "") == "USD" and offer.get("Scope", "") == "Region"
    ]
    logger.info(
        f"Filtered {len(filtered_offers)} Region-scope USD offers from {len(all_offers)} total offers"
    )
    return filtered_offers


def duration_days(
    offer: dict[str, typing.Any],
) -> int:
    return math.ceil(offer["Duration"] / (60 * 60 * 24))


def filter_ri_offerings_by_duration(
    ri_offering_list: list[dict[str, typing.Any]],
) -> list[dict[str, typing.Any]]:
    eligible_ri_offering_list = [
        offer
        for offer in ri_offering_list
        if duration_days(offer) < OFFER_MAX_DURATION_DAYS
    ]
    logger.info(
        "Found {} / {} offerings of length < {} days: {}".format(
            len(eligible_ri_offering_list),
            len(ri_offering_list),
            OFFER_MAX_DURATION_DAYS,
            [duration_days(offer) for offer in eligible_ri_offering_list],
        )
    )
    return eligible_ri_offering_list


def hourly_price(
    offer: dict[str, typing.Any],
) -> float:
    return (
        offer["RecurringCharges"][0]["Amount"]
        if len(offer["RecurringCharges"]) == 1
        else 999999.0
    )


def filter_ri_offerings_by_price(
    ri_offering_list: list[dict[str, typing.Any]],
) -> list[dict[str, typing.Any]]:
    eligible_ri_offering_list = [
        offer
        for offer in ri_offering_list
        if hourly_price(offer) < OFFER_MAX_HOURLY_PRICE
    ]
    logger.info(
        "Found {} / {} offerings at price < {}: {}".format(
            len(eligible_ri_offering_list),
            len(ri_offering_list),
            OFFER_MAX_HOURLY_PRICE,
            [hourly_price(offer) for offer in eligible_ri_offering_list],
        )
    )
    return eligible_ri_offering_list


def get_filtered_ri_offerings(
    ec2_client: typing.Any,
) -> list[dict[str, typing.Any]]:
    ri_offering_list = get_all_ri_offerings(ec2_client)
    ri_offering_list = filter_ri_offerings_by_duration(ri_offering_list)
    ri_offering_list = filter_ri_offerings_by_price(ri_offering_list)
    ri_offering_list = sorted(
        ri_offering_list, key=lambda o: (hourly_price(o), duration_days(o))
    )
    return ri_offering_list


def calculate_desired_purchase_count(
    num_current_active_ri: int,
    num_ri_purchased_this_month: int,
    monthly_quota_for_new_ri: int,
) -> int:
    """Calculate how many instances to purchase."""
    remaining_quota = monthly_quota_for_new_ri - num_ri_purchased_this_month
    remaining_capacity = MAX_TOTAL_INSTANCES - num_current_active_ri
    num_ri_to_purchase = min(remaining_quota, remaining_capacity)

    logger.info(
        f"Remaining quota for new RI: {remaining_quota} / {monthly_quota_for_new_ri}"
    )
    logger.info(
        f"Remaining cap for total RI: {remaining_capacity} / {MAX_TOTAL_INSTANCES}"
    )
    logger.info(f"RI to purchase: {num_ri_to_purchase}")

    return num_ri_to_purchase


def put_cloudwatch_metric(
    num_purchased: int,
    dry_run: bool = False,
) -> None:
    if not dry_run:
        cloudwatch_client = typing.cast(typing.Any, boto3.client("cloudwatch"))
        cloudwatch_client.put_metric_data(
            Namespace="RI-Purchaser",
            MetricData=[
                {
                    "MetricName": "RIPurchased",
                    "Dimensions": [
                        {"Name": "InstanceType", "Value": INSTANCE_TYPE},
                        {"Name": "Tenancy", "Value": INSTANCE_TENANCY},
                    ],
                    "Value": num_purchased,
                    "Unit": "Count",
                }
            ],
        )


def purchase_ri_offer(
    ec2_client: typing.Any,
    offer: dict[str, typing.Any],
    num_ri_to_purchase: int,
    dry_run: bool = False,
) -> dict[str, typing.Any]:
    count_to_purchase = min(offer.get("InstanceCount", 1), num_ri_to_purchase)
    purchased_ri = {
        "OfferId": offer["ReservedInstancesOfferingId"],
        "HourlyPrice": hourly_price(offer),
        "DurationDays": duration_days(offer),
        "Tenancy": offer.get("InstanceTenancy", ""),
        "AZ": offer.get("AvailabilityZone", "Region-wide"),
        "InstanceCount": count_to_purchase,
    }
    ec2_client.purchase_reserved_instances_offering(
        ReservedInstancesOfferingId=offer["ReservedInstancesOfferingId"],
        InstanceCount=count_to_purchase,
        DryRun=dry_run,
    )
    put_cloudwatch_metric(count_to_purchase, dry_run)
    return purchased_ri


def purchase_instances(
    ec2_client: typing.Any,
    eligible_offers: list[dict[str, typing.Any]],
    num_ri_to_purchase: int,
    dry_run: bool = False,
) -> list[dict[str, typing.Any]]:
    """Purchase reserved instances up to the purchase count."""
    purchased_ri_list: list[dict[str, typing.Any]] = []
    num_ri_purchased = 0
    logger.info(
        f"Purchasing up to {num_ri_to_purchase} RIs from {len(eligible_offers)} offers"
    )
    for offer in eligible_offers:
        if num_ri_purchased >= num_ri_to_purchase:
            break
        purchased_ri = purchase_ri_offer(
            ec2_client=ec2_client,
            offer=offer,
            num_ri_to_purchase=num_ri_to_purchase - num_ri_purchased,
            dry_run=dry_run,
        )
        num_ri_purchased += purchased_ri["InstanceCount"]
        purchased_ri_list.append(purchased_ri)
    logger.info(
        f"Successfully purchased {num_ri_purchased} RIs across {len(purchased_ri_list)} offers"
    )
    return purchased_ri_list


def send_notification_email(
    num_current_active_ri: int,
    num_ri_purchased_this_month: int,
    monthly_quota_for_new_ri: int,
    purchased_ri_list: list[dict[str, typing.Any]],
) -> None:
    email_body = "Reserved Instances purchased:\n\n"
    total_cost = 0

    for p in purchased_ri_list:
        daily_cost = hourly_price(p) * 24
        term_cost = daily_cost * p["DurationDays"]
        total_cost += term_cost

        email_body += (
            f"• Offer ID: {p['OfferId']}\n"
            f"  Tenancy: {p['Tenancy']}\n"
            f"  Duration: {p['DurationDays']} days\n"
            f"  Hourly Rate: $${hourly_price(p):.5f}\n"
            f"  Total Term Cost: $${term_cost:.2f}\n\n"
        )

    email_body += f"\nTotal purchase cost: $${total_cost:.2f}\n"
    email_body += f"Current RI count: {num_current_active_ri + len(purchased_ri_list)} / {MAX_TOTAL_INSTANCES}\n"
    email_body += "Monthly purchases: {} / {}\n".format(
        num_ri_purchased_this_month + len(purchased_ri_list),
        monthly_quota_for_new_ri,
    )
    ses_client = typing.cast(typing.Any, boto3.client("ses"))
    ses_client.send_email(
        Source=EMAIL_SENDER,
        Destination={"ToAddresses": [EMAIL_RECIPIENT]},
        Message={
            "Subject": {
                "Data": f"Reserved Instances Purchased - {len(purchased_ri_list)} new RIs"
            },
            "Body": {"Text": {"Data": email_body}},
        },
    )
    logger.info(f"Email sent to {EMAIL_RECIPIENT}")


def purchase_reserved_instances() -> list[dict[str, typing.Any]]:
    logger.info("Starting Reserved Instance (RI) purchase process")
    ec2_client = typing.cast(typing.Any, boto3.client("ec2"))
    num_current_active_ri, num_ri_purchased_this_month = (
        get_existing_reserved_instances(
            ec2_client,
        )
    )
    if num_current_active_ri >= MAX_TOTAL_INSTANCES:
        logger.info("Already at maximum capacity, no purchases needed.")
        return []

    monthly_quota_for_new_ri = get_monthly_new_reserved_instance_quota()
    num_ri_to_purchase = calculate_desired_purchase_count(
        num_current_active_ri=num_current_active_ri,
        num_ri_purchased_this_month=num_ri_purchased_this_month,
        monthly_quota_for_new_ri=monthly_quota_for_new_ri,
    )
    if num_ri_to_purchase <= 0:
        logger.info("No purchases possible at this time.")
        return []

    eligible_offers = get_filtered_ri_offerings(ec2_client)
    if not eligible_offers:
        logger.info("No eligible offerings found.")
        return []

    purchased_ri_list = purchase_instances(
        ec2_client=ec2_client,
        eligible_offers=eligible_offers,
        num_ri_to_purchase=num_ri_to_purchase,
        dry_run=DRY_RUN,
    )
    if purchased_ri_list:
        send_notification_email(
            num_current_active_ri=num_current_active_ri,
            num_ri_purchased_this_month=num_ri_purchased_this_month,
            monthly_quota_for_new_ri=monthly_quota_for_new_ri,
            purchased_ri_list=purchased_ri_list,
        )
    logger.info("Reserved Instance purchase process completed successfully")
    return purchased_ri_list


def lambda_handler(
    event: dict[str, typing.Any],
    context: dict[str, typing.Any],
) -> dict[str, typing.Any]:
    purchased_ri_list = purchase_reserved_instances()
    return {
        "statusCode": 200,
        "body": json.dumps({"success": True, "purchased": len(purchased_ri_list)}),
    }


if __name__ == "__main__":
    purchase_reserved_instances()
