import typing

import package.lib as lib


def main(
    event: dict[str, typing.Any], context: dict[str, typing.Any]
) -> dict[str, typing.Any]:
    return lib.basic_return_value(event)
