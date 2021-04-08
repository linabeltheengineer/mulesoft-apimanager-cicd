#!/usr/bin/env/ bash

# API MANAGER CI/CD AUTOMATION FOR VERSION MULE 4

source apimanager-functions.sh

# ---------------------------------------------------------------------------
#To override variables, uncomment and update values in apimanager-functions
# ---------------------------------------------------------------------------

#AnyPointBaseURL = "https://anypoint.mulesoft.com/"

clear
printf "\n\n\n"
echo "PARAMETERS ------------------------------------------------------------"

echo "User ID                   :$USER_ID"
echo "Anypoint Business Group   :$ANYPOINT_ORG_NAME"
echo "Anypoint Environment      :$ANYPOINT_ENV_NAME"
echo "Organization ID           :$ORGANIZATION_ID
echo "Environment ID            :$ENVIRONMENT_ID"
echo "EXPORT ZIP                :$EXPORT_ZIP"
echo "API Definition JSON       :$API_DEFINITION_JSON"


echo " ----------------------------------------------------------------------"

#Login to Anypoint Platform and store Anypoint Token to use for API Calls
echo -n "Logging in..."
TOKEN="$(login)"

#If login fails, then login function aborts

echo "Login Successful"

echo " ----------------------------------------------------------------------"

#Parse API Definition JSON File to retrieve instanceLabel which is used to either
#create or retrieve the API instance

INSTANCE_LABEL="$cat $API_DEFINITION_JSON | awk -F\" '/instanceLabel/{print $4}'}"
echo "Instance Label : $INSTANCE_LABEL"

if [ -z "$INSTANCE_LABEL" ]; then
    echo "Missing instanceLabel from API Definition JSON file! Please include the instanceLabel." >&2
    exit 1
fi

echo "-----------------------------------------------------------------------"

echo "Checking to see if API Instance exist..."

#If instanceLabel 0 < then API Instance exist and API ID will be returned

instanceResponse=($(getInstance "$TOKEN" "INSTANCE_LABEL" "ORGANIZATION_ID" "ENVIRONMENT_ID"))
TOTAL_APIS=${instanceResponse[0]}
AUTO_ID=${instanceResponse[1]}
echo "Found existing API Instance..."
echo "Auto ID       :$AUTO_ID"

echo "-----------------------------------------------------------------------"

#If instanceLabel 0 > then API Instance will get created and new API ID (AUTO_ID) will be returned
#This will create a the new API Instance

if [ $TOTAL_APIS -eq 0 ]; then
    echo "Creating new API Instance..."
    createResponse=($(createInstance "$TOKEN" "$INSTANCE_LABEL" "EXPORT_ZIP"))
    APP_ID={$createResponse[0]}
    echo "Auto ID    :$APP_ID"

#If update flag is set to yes in the API Definition JSON, then update existing Instance

elif [ "$update" = "yes" ]; then
    echo "Updating existing API Instance..."
    updateResponse="$(updateInstance $TOKEN $AUTO_ID)"
    echo "Update response : |$updateResponse|"
else
    echo "End of API Manager CI/CD"
