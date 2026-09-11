# 🚀 Step 8 — Create an EC2 Launch Template

A **Launch Template** defines the configuration used to launch EC2 instances.

It is especially useful with **EC2 Auto Scaling**, because every new instance can be launched using the same:

* AMI
* Instance type
* Key pair
* Security Group
* IAM role
* Storage configuration
* User data script

For this project, we will create:

```text
Launch Template:
WebServer-LT
```

---

# 🎯 Objective

Create a Launch Template for the web application servers.

```text
                    WebServer-LT
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
        AMI        Instance Type     App-SG
  Amazon Linux 2023   t3.micro
          │
          ▼
      User Data
          │
          ▼
     Apache HTTPD
```

---

# 🖥️ Step 1 — Open Launch Templates

Go to:

```text
AWS Management Console
        ↓
EC2
        ↓
Launch Templates
```

Click:

```text
Create launch template
```

---

# 🏷️ Step 2 — Enter Launch Template Name

Configure:

```text
Name:
WebServer-LT
```
---

# 🐧 Step 3 — Select AMI

Under **Application and OS Images (AMI)**, select:

```text
Amazon Linux 2023
```

Use the appropriate current Amazon Linux 2023 AMI available in your AWS Region.

For this project:

```text
Operating System:
Amazon Linux 2023
```

---

# 💻 Step 4 — Select Instance Type

Choose:

```text
t3.micro
```

Configuration:

```text
Instance type:
t3.micro
```

> ⚠️ AWS pricing and Free Tier eligibility can vary by account type, region, and current AWS offers. Always check the pricing shown in your own AWS account before launching multiple instances.

---

# 🔑 Step 5 — Select Key Pair

Under **Key pair**, select an existing key pair.

For example:

```text
Key pair:
my-webserver-key
```

If you don't have one, click:

```text
Create new key pair
```

Download and securely store the private key.

Example:

```text
my-webserver-key.pem
```

### 🔐 Important

Never upload the `.pem` file to GitHub.

Add it to `.gitignore` if the project repository is on your local machine:

```text
*.pem
```

---

# 🔒 Step 6 — Configure Network Settings

For a Launch Template that will be used by an **Auto Scaling Group**, leave the subnet selection blank.

Configure the Security Group:

```text
Security Group:
EC2-SG
```

This is the application server Security Group created earlier.

### Why leave the subnet blank?

The **Auto Scaling Group** will determine where instances are launched.

For this project, instances can be distributed across:

```text
Private-App-A
Private-App-B
```

This helps provide Availability Zone redundancy.

Architecture:

```text
                 Auto Scaling Group
                         │
             ┌───────────┴───────────┐
             │                       │
             ▼                       ▼
       Private-App-A           Private-App-B
       ap-south-1a              ap-south-1b
             │                       │
             ▼                       ▼
         EC2-Web-1               EC2-Web-2
```

---

# 👤 Step 7 — Configure IAM Instance Profile

Under **Advanced details** or the IAM instance profile option, select:

```text
IAM instance profile:
EC2-WebServer-Role
```

This attaches the IAM role created earlier to each EC2 instance launched from this template.

Architecture:

```text
EC2 Instance
     │
     ▼
EC2-WebServer-Role
     │
     ├── S3
     │
     └── SNS
```

This allows the application to access permitted AWS resources without storing long-term AWS credentials on the EC2 instance.

---

# ⚙️ Step 8 — Configure User Data

Open:

```text
Advanced details
        ↓
User data
```

Paste:

```bash
#!/bin/bash

yum update -y
yum install -y httpd

systemctl start httpd
systemctl enable httpd

echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
```

---

# 📝 Step 9 — Review Configuration

Before creating the Launch Template, verify:

```text
Launch Template:
WebServer-LT

AMI:
Amazon Linux 2023

Instance Type:
t3.micro

Key Pair:
Your key pair

Security Group:
App-SG

IAM Role:
EC2-WebServer-Role

User Data:
Apache installation script

Subnet:
Not specified
```

---

# ➕ Step 10 — Create Launch Template

Click:

```text
Create launch template
```

AWS will create:

```text
WebServer-LT
```

---

# 🔍 Step 11 — Verify Launch Template

Go to:

```text
EC2
    ↓
Launch Templates
```

Find:

```text
WebServer-LT
```

Open the template and verify the configuration.

Expected:

```text
WebServer-LT
│
├── AMI
│   └── Amazon Linux 2023
│
├── Instance Type
│   └── t3.micro
│
├── Security Group
│   └── App-SG
│
├── IAM Role
│   └── EC2-WebServer-Role
│
├── User Data
│   └── Apache HTTP Server
│
└── Storage
    └── EBS Root Volume
```

---


