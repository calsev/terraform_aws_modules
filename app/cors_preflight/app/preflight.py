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
        return [item.strip() for item in raw.split(",") if item.strip()]
    except Exception:
        logger.exception(f"Failed to parse {env_name}, using default")
        return [item.strip() for item in default.split(",") if item.strip()]


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

ALLOWED_METHODS_UPPER = {method.upper() for method in ALLOWED_METHODS}


def _normalize_host_pattern(host: str) -> str:
    return host.strip().lower().rstrip(".")


def _split_allowed_hosts(
    hosts: list[str],
) -> tuple[set[str], set[str]]:
    exact_hosts: set[str] = set()
    wildcard_suffixes: set[str] = set()

    for host in hosts:
        normalized = _normalize_host_pattern(host)
        if not normalized:
            continue

        if normalized.startswith("*."):
            suffix = normalized[1:]  # keeps ".example.com"
            if len(suffix) > 1:
                wildcard_suffixes.add(suffix)
        else:
            exact_hosts.add(normalized)

    return exact_hosts, wildcard_suffixes


EXACT_ALLOWED_HOSTS, WILDCARD_ALLOWED_SUFFIXES = _split_allowed_hosts(ALLOWED_HOSTS)


def _hostname_allowed(hostname: str) -> bool:
    normalized = _normalize_host_pattern(hostname)

    if normalized in EXACT_ALLOWED_HOSTS:
        return True

    return any(normalized.endswith(suffix) for suffix in WILDCARD_ALLOWED_SUFFIXES)


def extract_allowed_origin(
    event: dict[str, typing.Any],
    headers: dict[str, typing.Any],
) -> str:
    if not headers:
        logger.info(f"Invalid event, no headers: {list(event.keys())}")
        return ORIGIN_DEFAULT

    origin: str | None = headers.get("origin")
    if not origin:
        logger.info("No Origin header, falling back to default origin")
        return ORIGIN_DEFAULT

    if origin == "null":
        logger.info("Null origin, falling back to default origin")
        return ORIGIN_DEFAULT

    parsed_url = urllib.parse.urlparse(origin)
    hostname = parsed_url.hostname
    scheme = parsed_url.scheme
    if not hostname or not scheme:
        logger.info(f"Origin parse failed ({origin}), falling back to default")
        return ORIGIN_DEFAULT

    if not _hostname_allowed(hostname):
        logger.info(
            f"Origin host {hostname} not in allowlist, falling back to default origin"
        )
        return ORIGIN_DEFAULT

    # Reconstruct origin from scheme + hostname + optional port
    try:
        port = parsed_url.port
    except ValueError:
        logger.info(f"Origin port parse failed ({origin}), falling back to default")
        return ORIGIN_DEFAULT
    port_part = f":{port}" if port else ""
    allowed_origin = f"{scheme}://{hostname}{port_part}"
    logger.info(f"Allowing origin {allowed_origin}")
    return allowed_origin


def security_headers() -> dict[str, str]:
    return {
        "Referrer-Policy": "strict-origin-when-cross-origin",
        "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
        "X-Content-Type-Options": "nosniff",
    }


def cors_headers(
    event: dict[str, typing.Any],
    headers: dict[str, typing.Any],
) -> dict[str, str]:
    # We do not mirror headers or method, opting for clarity rather than minimality
    req_method = str(headers.get("access-control-request-method", "")).strip()
    if req_method and req_method.upper() not in ALLOWED_METHODS_UPPER:
        logger.info(f"Requested method {req_method} not allowed")

    value = {
        **security_headers(),
        "Access-Control-Allow-Credentials": "true",
        "Access-Control-Allow-Headers": ",".join(ALLOWED_HEADERS),
        "Access-Control-Allow-Methods": ",".join(ALLOWED_METHODS),
        "Access-Control-Allow-Origin": extract_allowed_origin(event, headers),
        "Access-Control-Max-Age": str(MAX_AGE),
        "Content-Type": "application/json",
        "Vary": "Origin, Access-Control-Request-Headers, Access-Control-Request-Method",
    }
    return value


def status_code(
    headers: dict[str, typing.Any],
) -> int:
    # No Content is conventional for preflight, but not accepted for health check
    user_agent = headers.get("user-agent", "")
    is_health_check = user_agent.startswith("ELB-HealthChecker")
    value = 200 if is_health_check else 204
    return value


def preflight_response(
    event: dict[str, typing.Any],
    body: dict[str, typing.Any] | None = None,
) -> dict[str, typing.Any]:
    # For ALB→Lambda or APIGW v1
    # For APIGW v2 adjust slightly
    headers: dict[str, typing.Any] = event.get("headers", {}) or {}
    headers = {str(k).lower(): str(v) for k, v in headers.items() if v is not None}
    status = status_code(headers)
    response_headers = cors_headers(event, headers)
    value = {
        "statusCode": status,
        "statusDescription": f"{status} {'OK' if status == 200 else 'No Content'}",
        "isBase64Encoded": False,
        "headers": response_headers,
        # "multiValueHeaders": {k: [v] for k, v in response_headers.items()},
        "body": json.dumps(body or {}),
    }
    return value


def lambda_handler(
    event: dict[str, typing.Any],
    _context: typing.Any,
) -> dict[str, typing.Any]:
    logger.info("Preflight Lambda handler started")
    return preflight_response(event)
