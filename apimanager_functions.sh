#!/usr/bin/env bash

# -------------------------------------------------------
# See API Manager script arguments below.
# -------------------------------------------------------

USER_ID="$1"
ANYPOINT_USERNAME="$2"
ANYPOINT_PASSWORD="$3"
ANYPOINT_ORG_NAME="$4"
ANYPOINT_ENV_NAME="$5"
ORGANIZATION_ID="$6"
ENVIRONMENT_ID="$7"
EXPORT_ZIP="$8"
API_DEFINITION_JSON="9"

# -------------------------------------------------------
# See Global variables below.
# -------------------------------------------------------

REQUEST_HEADERS='Accept: */*'
DEFAULT_REQUEST_CONTENT_TYPE="Content-Type: application/json"
ZIP_REQUEST_CONTENT_TYPE="Content-Type: multipart/form-data"
HEADERS_FILES="Accept-Encoding: gzip, deflate, br"
ANYPOINT_BASE_URL="https://anypoint.mulesoft.com/"

# -------------------------------------------------------
# Anypoint Default Credentials
# -------------------------------------------------------
DEFAULT_USERNAME=$ANYPOINT_USERNAME
DEFAULT_PASSWORD=$ANYPOINT_PASSWORD

# -------------------------------------------------------
# Default Paths for API Manager endpoints
# -------------------------------------------------------
API_MANAGER_BASE_URL="$ANYPOINT_BASE_URL/apimanager/api/v1"
API_MANAGER_API_URI="$API_MANAGER_BASE_URL/organizations/$ORGANIZATION_ID/environments/$ENVIRONMENT_ID/apis"

# -------------------------------------------------------
# Login Variable
# -------------------------------------------------------

PAYLOAD_LOAD_LOGIN'{"'"username"'":"'$ANYPOINT_USERNAME'", "'"password"'":"'$ANYPOINT_PASSWORD'"}'

# -------------------------------------------------------
# Login to the Anypoint Platform
# -------------------------------------------------------

login() {
    local anypointLoginURI="$ANYPOINT_BASE_URL/accounts/login"
    local apiManagerLogin$(curl -X POST -k ""$anypointLoginURI" -H ""$REQUEST_HEADERS" -H "$DEFAULT_REQUEST_CONTENT_TYPE" -d "$PAYLOAD_LOAD_LOGIN")
    local token=$(echo $apiManagerLogin | awk -F\" /access_token/'{print $4}')

    #if token is NULL, then LOGIN fails and exists
    if [ -x $token ]; then
        echo "Failed to login: $apiManagerLogin" >&2
        exit 1
    fi

    echo "$token"

}

# -------------------------------------------------------
# Retrieve current API Instance from API Manager.
#   -instanceResponse=($(getInstance, $tokenHeader $instanceLabel))
#   -totalApis=${instanceResponse[0]}
#   -autoId=${instanceResponse[1]}
# -------------------------------------------------------

getInstance() {
    local token="$1"
    local instanceLabel = "$2"
    local orgId = "$3"
    local environmentId = "$4"
    local apiManagerInstanceLabelUri="$API_MANAGER_BASE_URL/organizations/$orgId/environments/$environmentId/apis?instanceLabel=$instanceLabel"
    local getInstance=$(curl -X GET -k "$apiManagerInstanceLabelUri" -H "Authorization: bearer $token" -H "REQUEST_HEADERS" -H "$DEFAULT_REQUEST_CONTENT_TYPE")
    local totalAPIs=$(echo "$getInstance" | awk -F"\"autodiscoveryInstanceName\":" '{print $2}'|awk -F: '{print $1}' | tr -d '"')
    local autoID=$(echo "$getInstance" | awk -F"\"apis\":" '{print $2}' | awk -F"\"id\":" '{print $2}' | awk -F, '{print $1}')
    local response=("totalAPIs" "$autoID")

    echo ${response[@]}
}

createInstance() {
    local token="$1"
    local instanceLabel = "$2"
    local fileZip = "$3"
    local createNewInstance=$(curl -X POST -k "$API_MANAGER_API_URI" -H "Authorization: bearer $token" -H "$REQUEST_HEADERS" -H "$FORM_REQUEST_CONTENT_TYPE" -H "$HEADER_FILES" -F "instanceLabel=$instanceLabel" -F "file=@fileZip")
    echo "New instance API response: $createNewInstance"
    local appId=$(echo "$createNewInstance" | awk -F"\"id\":" '{print $2}' | awk -F, '{print $1}')
    local versionCreate=$(echo "$createNewInstance" | awk -F"\"autodiscoveryInstance\":" '{print $2}' | awk -F":" '{print $1}' | tr -d '"')
    response=("$appId")

    echo ${response[@]}
}

updateInstance() {
    local token="$1"
    local autoId="$2"
    local apiManagerUpdateURI="$API_MANAGER_API_URI/$autoId"
    if [ ! -f "$API_DEFINITION_INPUT_FILE" ]; then
        echo "Cannot update instance in API Manager due to: " >&2
        echo "Missing api definition file, please ensure $API_DEFINITION_INPUT_FILE exists"  >&2
        echo ""
    else
        local apiManagerRequestTemplate="$(cat $API_DEFINITION_INPUT_FILE)"
        local updateInstance=$(curl -X PATCH -k "$apiManagerUpdateURI" -H "Authorization: bearer $token" -H "$REQUEST_HEADERS" -H "$DEFAULT_REQUEST_CONTENT_TYPE" -d "$apiManagerRequestTemplate")
        echo "$updateInstance"
    fi

}
