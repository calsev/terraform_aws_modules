import json
import typing

import boto3
import typer


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


def main(
    tag: list[str] = typer.Option(
        ["tf.workspace"],
        help="Filter out Lambda that matches any of these tags",
    ),
) -> None:
    list_untagged_lambdas(**locals())


if __name__ == "__main__":
    typer.run(main)
