# 🔐 Step 7 — Create IAM Role for EC2

An **IAM Role** allows EC2 instances to securely access AWS services without storing long-term AWS access keys on the server.

For this project, the EC2 instances may need access to:

* 🪣 Amazon S3 — backup/static files
* 🔔 Amazon SNS — application alerts/notifications

We will create an IAM role named:

```text
EC2-WebServer-Role
```

---

# 🎯 Objective

Create an IAM role that can be attached to EC2 instances.

```text
EC2 Instance
     │
     │ IAM Role
     ▼
EC2-WebServer-Role
     │
     ├── S3
     │
     └── SNS
```

---

# ➕ Step 1 — Open IAM

Sign in to the **AWS Management Console**.

Search for:

```text
IAM
```

Open:

```text
AWS Console
    ↓
IAM
    ↓
Roles
```

Click:

```text
Create role
```

---

# 👤 Step 2 — Select Trusted Entity

Under **Trusted entity type**, select:

```text
AWS service
```

For the service or use case, select:

```text
EC2
```

This allows an EC2 instance to assume the role.

The trust relationship will conceptually be:

```text
EC2
 │
 │ AssumeRole
 ▼
EC2-WebServer-Role
```

Click:

```text
Next
```

---

# 🪣 Step 3 — Add S3 Permissions

Search for:

```text
AmazonS3ReadOnlyAccess
```

Select:

```text
AmazonS3ReadOnlyAccess
```

This allows the EC2 instance to read objects from S3.

### ⚠️ Production Recommendation

For a real production application, avoid giving access to every S3 bucket when the application only needs one bucket.

Instead, create a custom policy that allows access only to the required bucket.

For example:

```text
S3 Bucket:
ha-webapp-backup
```

Recommended permissions might be limited to the specific resources and actions the application actually needs.

---

# 🔔 Step 4 — Add SNS Permissions

Search for:

```text
AmazonSNSFullAccess
```

Select it if your learning project requires broad SNS permissions.

However, **`AmazonSNSFullAccess` is usually more permission than an EC2 application needs.**

For a production environment, create a custom policy that allows only the required SNS actions, such as publishing notifications to a specific SNS topic.

Example concept:

```text
EC2
 │
 ▼
SNS Topic
 │
 ▼
Email / Notification
```

---

# 🏷️ Step 5 — Name the IAM Role

Enter:

```text
Role name:
EC2-WebServer-Role
```

Add an optional description:

```text
IAM role for EC2 web servers to access required S3 and SNS resources.
```

Review the permissions.

Click:

```text
Create role
```

---

# 🔍 Step 6 — Verify the IAM Role

Go to:

```text
IAM
    ↓
Roles
```

Search for:

```text
EC2-WebServer-Role
```

Open the role.

Verify:

```text
Role name:
EC2-WebServer-Role

Trusted entity:
EC2

Permissions:
S3 access
SNS access
```

---

# 📊 IAM Role Configuration

| Setting        | Value                     |
| -------------- | ------------------------- |
| Role Name      | `EC2-WebServer-Role`      |
| Trusted Entity | AWS Service               |
| Use Case       | EC2                       |
| S3 Permission  | `AmazonS3ReadOnlyAccess`* |
| SNS Permission | `AmazonSNSFullAccess`*    |

* For production, prefer custom least-privilege policies.

---

# 🔐 Why Use an IAM Role?

Without an IAM role, someone might be tempted to configure AWS access keys directly on the EC2 server:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

This is not recommended.

Instead:

```text
                  AWS IAM
                     │
                     ▼
            EC2-WebServer-Role
                     │
             ┌───────┴───────┐
             │               │
             ▼               ▼
            S3              SNS
```

The EC2 instance receives temporary credentials through the AWS instance metadata/IAM role mechanism.

This avoids storing long-lived AWS credentials in application code or configuration files.

---

# 🛡️ Least Privilege

A good IAM design follows the principle of:

> Give a workload only the permissions it actually needs.

### ❌ Avoid unnecessarily broad permissions

```text
AmazonS3FullAccess
AmazonSNSFullAccess
```

when the application only needs a small subset of actions.

### ✅ Prefer

```text
Specific S3 bucket
        +
Required S3 actions

Specific SNS topic
        +
Required SNS actions
```

Example:

```text
EC2-WebServer-Role
│
├── S3
│   └── Read only
│       └── Specific bucket
│
└── SNS
    └── Publish
        └── Specific topic
```

This is a much stronger approach to discuss in an AWS Cloud Engineer interview.

---

# 🔗 Step 7 — Attach the Role to EC2

When launching an EC2 instance, under the IAM instance profile / IAM role selection, choose:

```text
EC2-WebServer-Role
```

Architecture:

```text
                 EC2 Instance
                      │
                      ▼
            EC2-WebServer-Role
                      │
             ┌────────┴────────┐
             │                 │
             ▼                 ▼
            S3                SNS
```

The role can also be attached to an existing EC2 instance through:

```text
EC2
 ↓
Instances
 ↓
Select Instance
 ↓
Actions
 ↓
Security
 ↓
Modify IAM role
```

Select:

```text
EC2-WebServer-Role
```

and update the role.

---

# 🧪 Step 8 — Test IAM Access

After attaching the role to an EC2 instance, connect to the instance.
