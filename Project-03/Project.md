# 🚀 Serverless REST API using AWS Lambda & API Gateway

## ❓ What is this project?

This project demonstrates how to build a **Serverless REST API** using AWS Lambda and API Gateway without managing any servers.

The API receives HTTP requests, executes backend logic inside Lambda, and returns responses to users.

---

## ❓ What problem does this project solve?

Traditional applications require:

* Managing servers
* Installing software
* Scaling infrastructure
* Applying security patches

This project eliminates those responsibilities by using AWS Serverless services.

---

## ❓ How does the architecture work?

```text
Client
   |
   v
API Gateway
   |
   v
AWS Lambda
   |
   v
Response
```

### Flow

1. User sends a request.
2. API Gateway receives the request.
3. Lambda executes the business logic.
4. Lambda returns a response.
5. API Gateway sends the response back to the user.

---

## ❓ Why use AWS Lambda?

AWS Lambda allows developers to run code without managing servers.

Benefits:

* No server administration
* Automatic scaling
* High availability
* Pay only when used
* Faster development

---

## ❓ Why use API Gateway?

API Gateway acts as the front door of the application.

Responsibilities:

* Receive HTTP requests
* Trigger Lambda functions
* Handle routing
* Return responses to clients
* Support authentication and throttling

---

## ❓ What AWS services are used?

| Service           | Purpose             |
| ----------------- | ------------------- |
| AWS Lambda        | Backend logic       |
| API Gateway       | REST API endpoints  |
| DynamoDB (Future) | Database storage    |

---

## ❓ Why not use an EC2 server?

| Feature      | EC2 Server         | AWS Lambda         |
| ------------ | ------------------ | ------------------ |
| Cost         | Pay even when idle | Pay only when used |
| Scaling      | Manual             | Automatic          |
| Maintenance  | Required           | None               |
| OS Updates   | Required           | AWS Managed        |
| Availability | Self Managed       | Built In           |

---

## ❓ How does automatic scaling work?

If:

* 10 users send requests → 10 Lambda executions
* 1,000 users send requests → Lambda automatically scales
* 10,000 users send requests → Lambda continues scaling

No manual intervention is required.

---

## ❓ What is the cost advantage?

Traditional servers run 24/7.

Lambda charges only for:

* Number of requests
* Execution duration

No traffic = almost no cost.

This makes Lambda ideal for learning projects and startups.

---

## ❓ What API endpoint is implemented?

### Request

```http
GET /users
```

### Response

```json
[
  {
    "id": 1,
    "name": "John"
  },
  {
    "id": 2,
    "name": "Alice"
  }
]
```


## ❓ How can this project be improved?

### Step 1: Add DynamoDB

Store data permanently.

```python
response = dynamodb.scan(
    TableName='Users'
)
```

---

### Step 2: Add Path Parameters

Example:

```http
GET /users/1
```

Access the ID:

```python
user_id = event["pathParameters"]["id"]
```

---

### Step 3: Add Environment Variables

Store:

* Table names
* API keys
* Configuration values

instead of hardcoding them.

---

## ❓ When should Serverless APIs be used?

Use Lambda + API Gateway when:

✅ Traffic is unpredictable

✅ Automatic scaling is required

✅ Low operational overhead is desired

✅ Fast development is needed

✅ Infrastructure costs should be minimized

---

## ❓ When should Serverless APIs NOT be used?

Avoid Lambda when:

❌ Long-running workloads exceed Lambda limits

❌ Ultra-low latency is required

❌ Full operating system control is needed

In those cases:

* Amazon EC2
* Docker Containers
* Kubernetes

may be better choices.

---

## ❓ What did I learn from this project?

* AWS Lambda
* API Gateway
* REST APIs
* Serverless Architecture
* AWS Best Practices

---

## ❓ Who built this project?

**Rohit Tambadkar**

Aspiring DevOps & Cloud Engineer

Skills:
AWS | Linux |

---

## 📝 Blog

Read the detailed project article here:

[Serverless REST API using AWS Lambda & API Gateway](https://your-blog-url.com)

⭐ If you like this project, give it a star on GitHub.
