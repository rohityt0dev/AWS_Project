import json

def lambda_handler(event, context):

    body = json.loads(event["body"])

    name = body["name"]
    email = body["email"]
    message = body["message"]

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Contact received",
            "name": name
        })
    }

