import argparse
import json
import typing

import boto3


def list_all_lambdas(
    lambda_client: typing.Any,
) -> typing.Generator[dict[str, str], None, None]:
    paginator = lambda_client.get_paginator("list_functions")
    for page in paginator.paginate():
        for function in page["Functions"]:
            yield {
                "arn": function["FunctionArn"],
                "name": function["FunctionName"],
            }


def is_not_tagged(
    lambda_client: typing.Any,
    tag_filter_set: set[str],
    function_data: dict[str, str],
) -> bool:
    tags = lambda_client.list_tags(Resource=function_data["arn"])["Tags"]
    return len(tag_filter_set.intersection(set(tags))) == 0


def list_untagged_lambdas(
    tag: list[str],
) -> None:
    tag_filter_set = set(tag)
    lambda_client = typing.cast(typing.Any, boto3.client("lambda"))
    untagged: dict[str, str] = {
        function_data["name"]: function_data["arn"]
        for function_data in list_all_lambdas(lambda_client)
        if is_not_tagged(lambda_client, tag_filter_set, function_data)
    }
    print(json.dumps(untagged))


def main() -> None:
    # argparse (stdlib) rather than typer so this runs in any python (e.g. the
    # drift-detection CodeBuild plan environment, which has no third-party deps).
    parser = argparse.ArgumentParser(
        description="List Lambda functions not matching any of the given tags",
    )
    parser.add_argument(
        "--tag",
        action="append",
        help="Filter out Lambda that matches any of these tags (repeatable)",
    )
    args = parser.parse_args()
    list_untagged_lambdas(tag=args.tag or ["tf.workspace"])


if __name__ == "__main__":
    main()
