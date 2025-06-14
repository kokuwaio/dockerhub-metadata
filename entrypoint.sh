#!/usr/bin/env bash
set -eu;

##
## validate inputs
##

if [[ -z "${PLUGIN_USERNAME:-}" ]]; then
	echo "Missing username."
	exit 1
fi
if [[ -z "${PLUGIN_PASSWORD:-}" ]]; then
	echo "Missing password."
	exit 1
fi
if [[ -z "${PLUGIN_REPOSITORY:-}" ]]; then
	echo "Missing repository."
	exit 1
fi
if [[ -z "${PLUGIN_DESCRIPTION_SHORT:-}" ]]; then
	echo "Missing description-short."
	exit 1
fi
PLUGIN_DESCRIPTION_FILE="${PLUGIN_DESCRIPTION_FILE:-README.md}"
if [[ ! -f "$PLUGIN_DESCRIPTION_FILE" ]]; then
	echo "File $PLUGIN_DESCRIPTION_FILE not found."
	exit 1
fi

##
## Login to get token
##

echo '> Login'
TOKEN=$(curl https://hub.docker.com/v2/users/login \
	--fail --silent --show-error \
	--header "Content-Type: application/json" \
	--data "{\"username\":\"$PLUGIN_USERNAME\",\"password\":\"$PLUGIN_PASSWORD\"}\"" | jq -r .token)
TOKEN_SOURCE=$(echo "$TOKEN" | jq -R 'split(".")|.[1]|@base64d|fromjson|.source.type')
if [[ "$TOKEN_SOURCE" == "pat" ]]; then
	echo "Updating with personal access token does not work."
	return 1
fi
if [[ "$TOKEN_SOURCE" != "pwd" ]]; then
	echo "Warning: Not using password but '$TOKEN_SOURCE', updating metadata may not work,"
fi

##
## Update repository
##

echo '> Update categories'
BODY="["
if [[ -n "${PLUGIN_CATEGORIES:-}" ]]; then
	for CATEGORY in ${PLUGIN_CATEGORIES//,/ }; do
		BODY="$BODY{\"slug\":\"$CATEGORY\",\"name\":\"$CATEGORY\"},"
	done
	BODY="${BODY%?}"
fi
curl -XPATCH "https://hub.docker.com/v2/repositories/$PLUGIN_REPOSITORY/categories" \
	--fail --silent --show-error \
	--header "Authorization: JWT $TOKEN" \
	--header "Content-Type: application/json" \
	--data "$BODY]}"

echo '> Update description'
FULL=$(cat "$PLUGIN_DESCRIPTION_FILE")
BODY=$(jq --null-input --arg short "$PLUGIN_DESCRIPTION_SHORT" --arg full "$FULL" '{"description":$short,"full_description":$full}')
RESPONSE=$(curl -XPATCH "https://hub.docker.com/v2/repositories/$PLUGIN_REPOSITORY" \
	--fail --silent --show-error \
	--header "Authorization: JWT $TOKEN" \
	--header "Content-Type: application/json" \
	--data "$BODY")

echo
echo "Repository updated: https://hub.docker.com/r/$PLUGIN_REPOSITORY"
echo
echo "Repsones:"
echo "$RESPONSE"
