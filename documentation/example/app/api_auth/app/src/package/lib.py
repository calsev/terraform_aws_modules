import json
import urllib.parse
from typing import Optional

ORIGIN_DEFAULT = "https://auth-site.example.com"


def extract_allowed_origin(event: dict) -> str:
    headers = event.get("headers", {})
    if not headers:
        print(f"Invalid event, no headers:\n{json.dumps(event, indent='')}")
        return ORIGIN_DEFAULT

    # Header keys are lower case in the event
    referrer = headers.get("origin", headers.get("referer", ""))
    if not referrer:
        print(f"Invalid headers, no referer:\n{json.dumps(headers, indent='')}")
        return ORIGIN_DEFAULT

    referrer_parsed = urllib.parse.urlparse(referrer)
    if any(referrer_parsed.hostname == origin for origin in ["127.0.0.1", "localhost"]):
        # Echo allowed origin
        return f"{referrer_parsed.scheme}://{referrer_parsed.netloc}"
    return ORIGIN_DEFAULT


def basic_return_value(
    event: dict,
    body: Optional[dict] = None,
) -> dict:
    value = {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Credentials": True,
            "Access-Control-Allow-Headers": "Accept,Authorization,Content-Type",
            "Access-Control-Allow-Origin": extract_allowed_origin(event),
            "Access-Control-Allow-Methods": "GET,HEAD,OPTIONS,POST",
            "Content-type": "application/json",
        },
        "body": json.dumps(body or {}),
    }
    return value


def body_return_value(
    message: str,
    event: dict,
    body: Optional[dict] = None,
) -> dict:
    body = {
        "message": message,
        "event": event,
    }
    body.update(body or {})
    return basic_return_value(event, body)
