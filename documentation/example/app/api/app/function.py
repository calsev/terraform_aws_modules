import json

import package.lib as lib


def main(event, context):
    lib.do_nothing()
    body = {
        "message": "Success",
        "event": event,
    }
    response = {"statusCode": 200, "body": json.dumps(body)}
    return response
