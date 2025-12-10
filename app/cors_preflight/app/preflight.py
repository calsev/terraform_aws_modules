import json
import logging
import os
import typing
import urllib.parse

logger = logging.getLogger("preflight")
logger.setLevel(logging.INFO)


def _load_env_list(
    env_name: str,
    default: str,
) -> list[str]:
    raw = os.environ.get(env_name, default)
    try:
        value = raw.split(",")
        if isinstance(value, list):
            return [str(v) for v in value]
        logger.warning(f"Env {env_name} is not a list, using default")
    except Exception:
        logger.exception(f"Failed to parse {env_name}, using default")
    return raw.split(",")


ALLOWED_HEADERS = _load_env_list(
    "ALLOWED_HEADERS",
    "${allowed_headers}",
)
ALLOWED_HOSTS = _load_env_list(
    "ALLOWED_HOSTS",
    "${allowed_hosts}",
)
ALLOWED_METHODS = _load_env_list(
    "ALLOWED_METHODS",
    "${allowed_methods}",
)
MAX_AGE = int(
    os.environ.get(
        "MAX_AGE",
        "${max_age}",
    )
)
ORIGIN_DEFAULT = os.environ.get(
    "ORIGIN_DEFAULT",
    "${origin_default}",
)


def extract_allowed_origin(
    event: dict[str, typing.Any],
    headers: dict[str, typing.Any],
) -> str:
    if not headers:
        logger.info(
            f"Invalid event, no headers:\n{json.dumps(obj=list(event.keys()), indent='')}"
        )
        return ORIGIN_DEFAULT

    origin = headers.get("origin")
    if not origin:
        logger.info("No Origin header, falling back to default origin")
        return ORIGIN_DEFAULT

    if origin == "null":
        logger.info("Null origin, falling back to default origin")
        return ORIGIN_DEFAULT

    parsed_url = urllib.parse.urlparse(origin)
    hostname = parsed_url.hostname
    if not hostname:
        logger.info(f"Origin parse failed ({origin}), falling back to default")
        return ORIGIN_DEFAULT

    if hostname not in ALLOWED_HOSTS:
        logger.info(f"Origin host {hostname} not in allowlist, falling back to default")
        return ORIGIN_DEFAULT

    # Reconstruct origin from scheme + hostname + optional port
    port_part = f":{parsed_url.port}" if parsed_url.port else ""
    allowed_origin = f"{parsed_url.scheme}://{hostname}{port_part}"
    logger.info(f"Allowing origin {allowed_origin}")
    return allowed_origin


def cors_headers(
    event: dict[str, typing.Any],
    headers: dict[str, typing.Any],
) -> dict[str, str]:
    # Optionally tailor allowed methods/headers to the request
    req_method = headers.get("access-control-request-method", "")
    req_headers_raw = headers.get("access-control-request-headers", "")
    req_headers = (
        [h.strip() for h in req_headers_raw.split(",") if h.strip()]
        if req_headers_raw
        else []
    )

    if req_method and req_method.upper() not in (m.upper() for m in ALLOWED_METHODS):
        logger.info(f"Requested method {req_method} not allowed")
        # Could 405 here instead; keeping 2XX but not listing the method is also valid

    # Echo back intersection of requested headers and allowed headers
    allowed_header_set = {h.lower() for h in ALLOWED_HEADERS}
    effective_headers = [
        h for h in req_headers if h.lower() in allowed_header_set
    ] or ALLOWED_HEADERS

    value = {
        "Access-Control-Allow-Credentials": "true",
        "Access-Control-Allow-Headers": ",".join(effective_headers),
        "Access-Control-Allow-Origin": extract_allowed_origin(event, headers),
        "Access-Control-Allow-Methods": ",".join(ALLOWED_METHODS),
        "Access-Control-Max-Age": str(MAX_AGE),
        "Content-Type": "application/json",
        "Vary": "Origin, Access-Control-Request-Headers, Access-Control-Request-Method",
    }
    return value


def preflight_response(
    event: dict[str, typing.Any],
    body: dict[str, typing.Any] | None = None,
) -> dict[str, typing.Any]:
    # For ALB→Lambda or APIGW v1
    # For APIGW v2 adjust slightly
    headers = event.get("headers", {})
    # Normalize header keys to lowercase defensively
    headers = {k.lower(): v for k, v in headers.items() if v is not None}
    user_agent = headers.get("user-agent", "")
    headers = cors_headers(event, headers)
    value = {
        # No Content is conventional for preflight
        "statusCode": 200 if user_agent.startswith("ELB-HealthChecker") else 204,
        "statusDescription": "204 No Content",
        "isBase64Encoded": False,
        "headers": headers,
        # "multiValueHeaders": {k: [v] for k, v in headers.items()},
        "body": json.dumps(body or {}),
    }
    return value


def lambda_handler(
    event: dict[str, typing.Any],
    context: dict[str, typing.Any],
) -> dict[str, typing.Any]:
    logger.info("Preflight Lambda handler started")
    return preflight_response(event)
