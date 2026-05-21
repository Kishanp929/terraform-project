import json
import boto3
import os

sfn = boto3.client("stepfunctions")
STATE_MACHINE_ARN = os.environ["STATE_MACHINE_ARN"]

def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")

    response = sfn.start_execution(
        stateMachineArn=STATE_MACHINE_ARN,
        input=json.dumps({
            "source": "lambda-trigger",
            "event": str(event)
        })
    )

    print(f"Started execution: {response['executionArn']}")
    return {
        "statusCode": 200,
        "executionArn": response["executionArn"]
    }