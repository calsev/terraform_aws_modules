#!/usr/bin/env bash
set -ex

curl -X POST --header 'Content-Type: application/json' -d '{"items": [{"test1": 1}, {"test2": 2}]}' -w '\n\n' https://api.example.com/dev/lambda
curl -X POST --header 'Content-Type: application/json' -d '{"items": [{"test1": 1}, {"test2": 2}]}' -w '\n\n' https://api.example.com/dev/sqs
curl -X POST --header 'Content-Type: application/json' -d '{"items": [{"test1": 1}, {"test2": 2}]}' -w '\n\n' https://api.example.com/dev/states
