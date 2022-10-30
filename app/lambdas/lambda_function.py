import json
import logging

def lambda_handler(event, context):
    log = logging.getLogger()
    print(event)



    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "Region ": event['body']
        })
    }