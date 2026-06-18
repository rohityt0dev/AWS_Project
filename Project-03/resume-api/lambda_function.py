import json

contact_info = {
    "name": "Rohit Yashwant Tambadkar",
    "title": "DevOps Engineer | AWS · Terraform · Kubernetes · Docker",
    "email": "rohityt0@gmail.com",
    "phone": "+91 8208834440"
}

def lambda_handler(event, context):

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(contact_info)
    }

