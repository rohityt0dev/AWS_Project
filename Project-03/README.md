# Serverless REST APIs on AWS (Lambda + API Gateway)

A small collection of serverless REST APIs built with **AWS Lambda** and **API Gateway** — no servers to manage, no infrastructure to provision. Each API is a standalone Lambda function exposed through a REST endpoint.

This project was built as a hands-on DevOps/Cloud portfolio piece to demonstrate core AWS serverless concepts: Lambda functions, API Gateway resources/methods, JSON request/response handling, and stage-based deployments.

## Architecture

```
Client  --->  API Gateway (REST API)  --->  AWS Lambda  --->  JSON Response
```

Each API follows the same pattern:
1. A Lambda function (Python 3.12) contains the business logic.
2. API Gateway exposes that function via a resource (e.g. `/users`) and an HTTP method (GET/POST).
3. The API is deployed to a stage (`prod`), producing a public Invoke URL.

## APIs in this repo

| API | Method | Endpoint | Description |
|---|---|---|---|
| `user-api` | GET | `/users` | Returns a static list of users |
| `product-api` | GET | `/products` | Returns a static list of products |
| `contact-api` | POST | `/contact` | Accepts a contact form submission and returns a confirmation |
| `resume-api` | GET | `/resume` | Returns resume/contact info as JSON |

### Why POST for contact-api?

`GET` is for retrieving data; `POST` is for sending data to the server. Since a contact form submits new information (name, email, message), `POST` is the correct HTTP verb.

## Example: user-api

**Lambda function:**
```python
import json

def lambda_handler(event, context):
    users = [
        {"id": 1, "name": "John"},
        {"id": 2, "name": "Alice"}
    ]
    return {
        "statusCode": 200,
        "body": json.dumps(users)
    }
```

**Endpoint:**
```
GET https://owbif9z560.execute-api.ap-south-1.amazonaws.com/prod/users
```

## Example: contact-api

**Lambda function:**
```python
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
```

**Sample request body:**
```json
{
  "name": "Rohit",
  "email": "rohityt0@gmail.com",
  "message": "Hello AWS"
}
```

## How to deploy your own version

1. **Create the Lambda function**
   - AWS Console → Lambda → Create Function → Author from scratch
   - Runtime: Python 3.12
   - Paste the function code → Deploy

2. **Create the REST API**
   - AWS Console → API Gateway → Create API → REST API → Build
   - Name your API and create it

3. **Create a resource and method**
   - Create a resource (e.g. `/users`)
   - Add a method (GET or POST)
   - Integration type: Lambda Function → select your function → Save

4. **Deploy the API**
   - Actions → Deploy API → Stage name: `prod` → Deploy
   - Note the generated **Invoke URL**

5. **Test it**
   - GET endpoints: open the Invoke URL in a browser
   - POST endpoints: use the API Gateway "Test" tab.

## Tech stack

- **AWS Lambda** — Python 3.12 runtime
- **AWS API Gateway** — REST API, resource/method routing
- **JSON** — request/response payloads


## Author

**Rohit Yashwant Tambadkar**
DevOps Engineer | AWS · Terraform · Kubernetes · Docker
📧 rohityt0@gmail.com
📞 +91 8208834440


