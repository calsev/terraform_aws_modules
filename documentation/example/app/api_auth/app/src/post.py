import package.lib as lib


def main(event: dict, context: dict) -> dict:
    return lib.body_return_value("Success", event)
