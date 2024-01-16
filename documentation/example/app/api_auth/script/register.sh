#!/usr/bin/env bash
set -ex

source script/.env

aws cognito-idp sign-up \
  --client-id ${APP_CLIENT_ID} \
  --username ${USER_EMAIL} \
  --password ${USER_PASSWORD}

aws cognito-idp admin-confirm-sign-up \
  --user-pool-id ${USER_POOL_ID} \
  --username ${USER_EMAIL}
