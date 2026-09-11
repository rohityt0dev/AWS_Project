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

Optional description:

```text
Launch template for highly available web application servers.
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
App-SG
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

# 🧠 User Data Explanation

The script automatically runs when a new EC2 instance launches.

### Update packages

```bash
yum update -y
```

Updates installed packages.

### Install Apache

```bash
yum install -y httpd
```

Installs the Apache HTTP server.

### Start Apache

```bash
systemctl start httpd
```

Starts the web server immediately.

### Enable Apache

```bash
systemctl enable httpd
```

Configures Apache to start automatically after a reboot.

### Create the web page

```bash
echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
```

Creates a simple web page containing the EC2 hostname.

Example:

```text
Hello from ip-10-0-10-25.ap-south-1.compute.internal
```

This is useful for testing whether traffic is being distributed between multiple EC2 instances.

---

# 💾 Step 9 — Configure Storage

Under **Storage**, keep the default configuration unless your application requires additional storage.

Example:

```text
Root Volume:
EBS

Device:
/

Size:
Default
```

> ⚠️ Storage pricing and Free Tier allowances depend on your AWS account and current AWS offer. Verify the current limits in your account before provisioning resources.

---

# 🏷️ Step 10 — Add Tags

Tags are recommended for organizing AWS resources.

You can add:

```text
Key:
Project

Value:
HA-WebApp
```

Another useful tag:

```text
Key:
Environment

Value:
Production
```

Or for a learning environment:

```text
Key:
Environment

Value:
Dev
```

---

# 📝 Step 11 — Review Configuration

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

# ➕ Step 12 — Create Launch Template

Click:

```text
Create launch template
```

AWS will create:

```text
WebServer-LT
```

---

# 🔍 Step 13 — Verify Launch Template

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

# 🧪 Test the User Data

After an EC2 instance is launched using this template, Apache should be running automatically.

On the instance, verify:

```bash
systemctl status httpd
```

Expected:

```text
Active: active (running)
```

Check the web page locally:

```bash
curl http://localhost
```

Expected output will contain:

```text
Hello from <hostname>
```

---

# 🛠️ Troubleshooting User Data

If Apache does not start, check the cloud-init logs:

```bash
sudo cat /var/log/cloud-init-output.log
```

You can also check:

```bash
sudo systemctl status httpd
```

And:

```bash
sudo journalctl -u httpd
```

Common issues include:

* User data script errors
* Package installation failures
* Security Group rules
* Route table configuration
* Instance having no outbound connectivity

For private EC2 instances, remember that package installation requires outbound connectivity through the **NAT Gateway**.

---

# 🏗️ Launch Template Architecture

```text
                    WebServer-LT
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
 Amazon Linux 2023    t3.micro          App-SG
        │                                 │
        ▼                                 ▼
    User Data                         EC2-WebServer
        │                              Role
        ▼                                 │
     Apache                         ┌─────┴─────┐
        │                           │           │
        ▼                           ▼           ▼
   Web Application                  S3          SNS
```

---

# 🌐 Complete Application Flow

The Launch Template will eventually be used by an Auto Scaling Group.

The complete application architecture will look like:

```text
                         🌐 Internet
                              │
                              ▼
                    Application Load
                       Balancer
                         │
                       ALB-SG
                         │
                ┌────────┴────────┐
                │                 │
                ▼                 ▼
          Private-App-A      Private-App-B
                │                 │
                ▼                 ▼
             EC2-Web-1         EC2-Web-2
                │                 │
                └────────┬────────┘
                         │
                  App-SG / IAM Role
                         │
                  ┌──────┴──────┐
                  ▼             ▼
                 S3            SNS
```

---

# 🔐 Security Considerations

The Launch Template should follow these security practices:

### ❌ Do not store AWS credentials

Do not put this inside User Data:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

Use:

```text
EC2-WebServer-Role
```

instead.

### ❌ Don't expose application EC2 directly

The EC2 instances should use:

```text
App-SG
```

with application traffic allowed from:

```text
ALB-SG
```

### 🔑 Restrict SSH

If SSH is required:

```text
TCP :22
Source: YOUR_IP/32
```

Avoid:

```text
TCP :22
Source: 0.0.0.0/0
```

---

# 📊 Launch Template Summary

| Configuration   | Value                          |
| --------------- | ------------------------------ |
| Launch Template | `WebServer-LT`                 |
| AMI             | Amazon Linux 2023              |
| Instance Type   | `t3.micro`                     |
| Security Group  | `App-SG`                       |
| IAM Role        | `EC2-WebServer-Role`           |
| Key Pair        | Your key pair                  |
| Subnet          | Selected by Auto Scaling Group |
| Web Server      | Apache HTTPD                   |
| User Data       | Enabled                        |
| Root Storage    | Default EBS                    |

---

# ✅ Verification Checklist

* [ ] Launch Template created
* [ ] Name is `WebServer-LT`
* [ ] Amazon Linux 2023 selected
* [ ] `t3.micro` selected
* [ ] Key pair configured
* [ ] `App-SG` selected
* [ ] `EC2-WebServer-Role` selected
* [ ] User Data script added
* [ ] Apache installation configured
* [ ] Root EBS volume configured
* [ ] No AWS credentials stored in User Data
* [ ] Launch Template successfully created

---

# 🚀 Next Step

The Launch Template is now ready.

Next, create an **Auto Scaling Group (ASG)** using `WebServer-LT`.

```text
Step 1 → Create VPC
          ↓
Step 2 → Create Subnets
          ↓
Step 3 → Internet Gateway
          ↓
Step 4 → NAT Gateway
          ↓
Step 5 → Route Tables
          ↓
Step 6 → Security Groups
          ↓
Step 7 → IAM Role
          ↓
Step 8 → Launch Template ✅
          ↓
Step 9 → Auto Scaling Group
          ↓
Step 10 → Target Group
          ↓
Step 11 → Application Load Balancer
```

---

## 📁 GitHub File Structure

Recommended structure:

```text
AWS-Highly-Available-Web-Application/
│
├── README.md
│
└── docs/
    ├── networking/
    │   ├── vpc.md
    │   ├── subnets.md
    │   ├── internet-gateway.md
    │   ├── nat-gateway.md
    │   ├── route-tables.md
    │   └── security-groups.md
    │
    ├── security/
    │   └── iam-role.md
    │
    └── compute/
        └── launch-template.md   ← This file
```
