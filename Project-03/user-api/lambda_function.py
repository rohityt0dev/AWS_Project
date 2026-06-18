import json

def lambda_handler(event, context):

    users = [
        {
            "id": 1,
            "name": "John"
        },
        {
            "id": 2,
            "name": "Alice"
        }
    ]

    return {
        "statusCode": 200,
        "body": json.dumps(users)
    }

