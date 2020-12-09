# cad3-rhodium

What resources are expected to get created after running Terragrunt command.

Rhodium API + Rhodium Worker Lambda Functions

Rhodium API will be in charge of running commands based off Slack bot requests such as starting or shutting down the project resources. An AWS API gateway will be configured to trigger the API Lambda function when the Slack API request is sent.

Rhodium Worker is in charge of checking the run time schedule of all the instances associated with project. The Lambda Function will run every minute to see if any instance is running past their assigned schedule and shut them down. This is a cost saving tool to prevent developers from accidentally keeping their aws instances running overnight. Developers can configure how long their instances should run the Rhodium worker will handle the rest.

Slack bot will need to be created after Rhodium gets deployed.


# common tf files description

Name | Description 
---  | ---
acm-certs.tf | acm cert config
api-gateway-domain.tf | Rhodium Domain information recorded here.
api.tf | AWS lambda permissions for Rhodium API.
dynamodb.tf | DynamoDB table configuration found here
main.tf |
outputs.tf | slack_events_endpoint and slack_interactive_components_endpoint URL is configured here.
secret_manager.tf | Rhodium secrets settings (none by default since you have to create the slack bot yourself)
variables.tf | Variable settings for Rhodium
versions.tf | Required Versions of plugins
worker.tf | AWS lambda permissions for Rhodium Worker.
