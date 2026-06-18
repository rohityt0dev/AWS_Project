import json

def lambda_handler(event, context):

    products = [
        {
            "id": 101,
            "name": "Laptop",
            "price": 1200
        },
        {
            "id": 102,
            "name": "Phone",
            "price": 800
        }
    ]

    return {
        "statusCode": 200,
        "body": json.dumps(products)
    }

