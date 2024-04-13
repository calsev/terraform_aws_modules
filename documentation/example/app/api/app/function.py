import json
import typing

import package.lib as lib


def main(
    event: dict[str, typing.Any], context: dict[str, typing.Any]
) -> dict[str, typing.Any]:
    lib.do_nothing()
    body = {
        "message": "Success",
        "event": event,
    }
    response = {"statusCode": 200, "body": json.dumps(body)}
    return response
