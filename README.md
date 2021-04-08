# mulesoft-apimanager-cicd


**SUMMARY**

This simple shell script is used to automate the API Manager UI using Anypoint Platform APIs. It provides the following functionality:

1.) Create an API Instance

2.) Update the API definition


**API MANAGER SHELL SCRIPT SPEC**
| Arguments | Index # | Description | Example |
|--|--|--|--|
|  << shell location >>| 0 | path to shell script location | ./apimanager.sh |
|USER_ID | 1 | Username making the request | Linabel |
|ANYPOINT_ORG_NAME|2|Anypoint Platform Username| Linabel |
|ANYPOINT_PASSWORD|3|Anypoint Platform Password| anypointpassword123 |
|ANYPOINT_ORG_NAME|4|Organization Name| CIA|
|ANYPOINT_ENV_NAME|5|Environment Name | Dev |
|ORGANIZATION_ID|6|Organization ID | 4fc848f1-f974-41da-b77e-00d2c35eda4f |
|ENVIRONMENT_ID|7|Environment ID | 234fesda-f506-5c32-asbds-89fs830fef |
|EXPORT_ZIP|8|API Export Zip File| /c:/git-repos/api-testing/export.zip|
|API_DEFINITION_JSON|9|API Definition Json File | /c:/git-repos/api-testing/apidefinition.json


**EXECUTION EXAMPLE:**

`./apimanager.sh Linabel Linabel anypointpassword123 CIA Dev 948574589sdf4-23s42-23f42-23423s423 234fesda-f506-5c32-asbds-89fs830fef /c:/git-repos/api-testing/export.zip /c:/git-repos/api-testing/apidefinition.json`

**API_DEFINITION_JSON EXAMPLE**

`{
  "endpoint": {
    "deploymentType": "CH",
    "isCloudHub": true,
    "muleVersion4OrAbove": true,
    "proxyUri": "http://0.0.0.0:8081/",
    "proxyTemplate": {
      "assetVersion": "2.0.0"
    },
    "referencesUserDomain": false,
    "responseTimeout": null,
    "type": "rest",
    "uri": "https://anypoint.mulesoft.com/mocking/api/v1/links/854b1bd6-0c09-4b8f-a75a-129d2e79c6d6/"
  },
  "instanceLabel": "testing-dev",
  "spec": {
    "assetId": "api-gateway-sample-rest-proxy",
    "groupId": "4fc848f1-f974-41da-b77e-00d2c35eda4f",
    "version": "2.0.0",
    "update": "no"
  }
}`


**EXPORT.ZIP EXAMPLE**
Make sure this json is .zip as when passing as an argument for shell execution


  `{
  "api": {
    "$self": {
      "name": "v1:15788422",
      "groupId": "4fc848f1-f974-41da-b77e-00d2c35eda4f",
      "assetId": "american-flights-api",
      "assetVersion": "1.0.1",
      "productVersion": "v1",
      "description": null,
      "tags": [],
      "order": 1,
      "providerId": null,
      "deprecated": false,
      "endpointUri": null,
      "instanceLabel": testing-dev
    }
  },
  "endpoint": {
    "$self": {
      "type": "rest",
      "uri": "https://anypoint.mulesoft.com/mocking/api/v1/links/854b1bd6-0c09-4b8f-a75a-129d2e79c6d6/",
      "proxyUri": "http://0.0.0.0:8081/",
      "isCloudHub": true,
      "deploymentType": "CH",
      "policiesVersion": null,
      "proxyTemplate": {
        "assetId": "api-gateway-sample-rest-proxy",
        "assetVersion": "2.0.0",
        "groupId": "org.mule.examples"
      },
      "referencesUserDomain": false,
      "responseTimeout": null,
      "muleVersion4OrAbove": true
    }
  }
}`


**ADD MORE ANYPOINT PLATFORM ENDPOINTS**

See API Manager API Specs here: https://anypoint.mulesoft.com/exchange/portals/anypoint-platform/f1e97bc6-315a-4490-82a7-23abe036327a.anypoint-platform/api-manager-api/
