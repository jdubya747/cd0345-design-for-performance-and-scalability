import json

def lambda_handler(event, context):
    print("SQS Message Received! Thanks!")

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }