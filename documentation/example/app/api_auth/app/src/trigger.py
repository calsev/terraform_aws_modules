import json


def main(event: dict, context: dict) -> dict:
    # See https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-identity-pools-working-with-aws-lambda-triggers.html # noqa: E501
    request = event.get("request", {})
    if not request:
        print(f"Invalid event, no request:\n{json.dumps(list(event.keys()))}")
        raise ValueError("Event error, try again later")

    user_attributes = request.get("userAttributes", {})
    if not user_attributes:
        print(
            f"Invalid request, no userAttributes:\n{json.dumps(list(request.keys()))}"
        )
        raise ValueError("Request error, try again later")

    print(f"User attributes:\n{user_attributes}")  # Manipulate attributes here
    return event
