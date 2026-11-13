#!/usr/bin/env bash
# Create or delete one user in an AWS Managed Microsoft AD, for terraform_data in this module.
#
#   user.sh create   Create the user if missing, then set its password from the secret
#   user.sh delete   Delete the user if it (and its directory) still exist
#
# Arguments come from the environment (AWS_REGION, DIRECTORY_ID, USER_NAME, and for create
# PASSWORD_SECRET_ID plus optional EMAIL_ADDRESS, GIVEN_NAME, SURNAME), so the password never
# reaches a command line. Both actions are safe to repeat.
set -euo pipefail

action=${1:?usage: user.sh create|delete}
: "${AWS_REGION:?}" "${DIRECTORY_ID:?}" "${USER_NAME:?}"
export AWS_REGION AWS_PAGER=""

# Prints present or absent; fails on any other error
user_state() {
  local err
  if err=$(aws ds-data describe-user --directory-id "$DIRECTORY_ID" --sam-account-name "$USER_NAME" 2>&1 >/dev/null); then
    echo present
  elif grep -q ResourceNotFoundException <<<"$err"; then
    echo absent
  else
    echo "$err" >&2
    return 1
  fi
}

directory_exists() {
  local err
  if err=$(aws ds describe-directories --directory-ids "$DIRECTORY_ID" 2>&1 >/dev/null); then
    return 0
  elif grep -q EntityDoesNotExistException <<<"$err"; then
    return 1
  fi
  echo "$err" >&2
  exit 1
}

# Enabling data access takes a few minutes after the directory is created. The directory's
# stack enables it, so only Enabling can still become Enabled; any other status fails now.
wait_for_data_access() {
  local status
  for _ in $(seq 90); do
    status=$(aws ds describe-directory-data-access --directory-id "$DIRECTORY_ID" --query DataAccessStatus --output text)
    case $status in
    Enabled) return 0 ;;
    Enabling) echo "Directory data access for $DIRECTORY_ID is $status; waiting" ;;
    *)
      echo "Directory data access for $DIRECTORY_ID is $status, not Enabled; enable it in the directory's stack" >&2
      return 1
      ;;
    esac
    sleep 10
  done
  echo "Directory data access for $DIRECTORY_ID did not become Enabled" >&2
  return 1
}

create() {
  : "${PASSWORD_SECRET_ID:?}"
  wait_for_data_access
  local state
  state=$(user_state)
  if [ "$state" = absent ]; then
    local args=(--directory-id "$DIRECTORY_ID" --sam-account-name "$USER_NAME")
    [ -n "${EMAIL_ADDRESS:-}" ] && args+=(--email-address "$EMAIL_ADDRESS")
    [ -n "${GIVEN_NAME:-}" ] && args+=(--given-name "$GIVEN_NAME")
    [ -n "${SURNAME:-}" ] && args+=(--surname "$SURNAME")
    aws ds-data create-user "${args[@]}" >/dev/null
    echo "Created user $USER_NAME in $DIRECTORY_ID"
  else
    echo "User $USER_NAME already exists in $DIRECTORY_ID"
  fi
  # A user created by API is disabled until it has a password; setting one enables it
  # Global, not local: the EXIT trap runs after this function returns
  request=$(mktemp)
  trap 'rm -f "$request"' EXIT
  aws secretsmanager get-secret-value --secret-id "$PASSWORD_SECRET_ID" --query SecretString --output text |
    python3 -c 'import json, os, sys
json.dump({"DirectoryId": os.environ["DIRECTORY_ID"], "UserName": os.environ["USER_NAME"], "NewPassword": json.load(sys.stdin)["password"]}, sys.stdout)' >"$request"
  aws ds reset-user-password --cli-input-json "file://$request"
  echo "Set the password of $USER_NAME from its secret"
}

delete() {
  if ! directory_exists; then
    echo "Directory $DIRECTORY_ID is gone, and $USER_NAME with it"
    return 0
  fi
  local state
  state=$(user_state)
  if [ "$state" = present ]; then
    aws ds-data delete-user --directory-id "$DIRECTORY_ID" --sam-account-name "$USER_NAME"
    echo "Deleted user $USER_NAME from $DIRECTORY_ID"
  else
    echo "User $USER_NAME is already gone from $DIRECTORY_ID"
  fi
}

case $action in
create) create ;;
delete) delete ;;
*)
  echo "usage: user.sh create|delete" >&2
  exit 2
  ;;
esac
