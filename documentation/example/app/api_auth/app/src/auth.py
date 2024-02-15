import json


def return_value(is_authorized: bool) -> dict:
    return {"isAuthorized": is_authorized}


def main(event, context):
    headers = event.get("headers", {})
    if not headers:
        print(f"Invalid event, no headers:\n{json.dumps(event, indent='')}")
        return return_value(False)

    token = headers.get("authorization", "")  # Header keys are lower case in the event
    if not token:
        print(f"Invalid headers, no authorization:\n{json.dumps(headers, indent='')}")
        return return_value(False)

    return return_value(token == "SuperSecretToken")
