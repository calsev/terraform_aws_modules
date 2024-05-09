#!/usr/bin/env bash
set -ex

source script/.env

curl -X POST -H 'Content-Type: application/json' -d '{"items": [{"test1": 1}, {"test2": 2}]}' -w '\n\n' ${API_URL}/prd/anon

# This gets rejected
curl -X POST -H "Authorization: NotTheRightSecret" -H 'Content-Type: application/json' -d '{"items": [{"test1": 1}, {"test2": 2}]}' -w '\n\n' ${API_URL}/prd/auth-lambda

curl -X POST -H "Authorization: SuperSecretToken" -H 'Content-Type: application/json' -d '{"items": [{"test1": 1}, {"test2": 2}]}' -w '\n\n' ${API_URL}/prd/auth-lambda

TOKEN=$(aws cognito-idp initiate-auth \
    --client-id ${APP_CLIENT_ID} \
    --auth-flow USER_PASSWORD_AUTH \
    --auth-parameters USERNAME=${USER_EMAIL},PASSWORD=${USER_PASSWORD} \
    --query 'AuthenticationResult.AccessToken' \
    --output text)

echo -e "\n"

curl -X OPTIONS -w '\n\n' -i ${API_URL}/prd/auth-cognito

# This gets rejected
curl -X POST -H "Authorization: FakeTokenNotGonnaWork" -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Origin: http://localhost' -d '{"items": [{"test1": 1}, {"test2": 2}]}' -w '\n\n' ${API_URL}/prd/auth-cognito

curl -X POST -H "Authorization: ${TOKEN}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Origin: http://localhost' -d '{"items": [{"test1": 1}, {"test2": 2}]}' -w '\n\n' -i ${API_URL}/prd/auth-cognito

curl -X POST -H "Authorization: Bearer ${TOKEN}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H 'Origin: http://localhost' -d '{"items": [{"test1": 1}, {"test2": 2}]}' -w '\n\n' -i ${API_URL}/prd/auth-cognito
