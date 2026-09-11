# 🔐 Step 6 — Create Security Groups

**Security Groups (SGs)** act as virtual firewalls for AWS resources such as EC2 instances and Load Balancers.

In this project, we will use separate security groups for the **Application Load Balancer** and **EC2 application servers**.

This follows a basic security principle:

> Allow only the traffic that is required.

---

# 🎯 Objective

Create the following Security Groups:

```text
AWS-Project-VPC
│
├── SG-ALB
│   └── Internet → ALB
│
└── EC2-SG
    └── ALB → Application EC2
```

Security architecture:

```text
                    🌐 Internet
                         │
                         │ HTTP/HTTPS
                         ▼
                  ┌─────────────┐
                  │    SG-ALB   │
                  │   Port 80   │
                  │  Port 443   │
                  └──────┬──────┘
                         │
                         │ Application Traffic
                         ▼
                  ┌─────────────┐
                  │    EC2-SG   │
                  │ Application │
                  │    Port     │
                  └──────┬──────┘
                         │
                         ▼
                    EC2 Instances
```

---

# 🖥️ Step 1 — Open Security Groups

Go to:

```text
AWS Management Console
        ↓
VPC
        ↓
Security Groups
```

Click:

```text
Create security group
```

---

# 🟢 Step 2 — Create ALB Security Group

The Application Load Balancer needs to accept traffic from users on the internet.

Configure:

```text
Security group name:
SG-ALB

Description:
Security group for Application Load Balancer

VPC:
AWS-Project-VPC
```

---

# 🌐 Step 3 — Configure ALB Inbound Rules

Under **Inbound rules**, add:

### HTTP

```text
Type:
HTTP

Protocol:
TCP

Port:
80

Source:
0.0.0.0/0
```

### HTTPS

```text
Type:
HTTPS

Protocol:
TCP

Port:
443

Source:
0.0.0.0/0
```

Configuration:

| Type  | Protocol | Port | Source      |
| ----- | -------- | ---: | ----------- |
| HTTP  | TCP      |   80 | `0.0.0.0/0` |
| HTTPS | TCP      |  443 | `0.0.0.0/0` |

Click:

```text
Create security group
```

---

# 🔵 Step 4 — Create Application Security Group

Create another Security Group for the application EC2 instances.

Configure:

```text
Security group name:
EC2-SG

Description:
Security group for application EC2 instances

VPC:
AWS-Project-VPC
```

---

# 🔒 Step 5 — Configure SG-ALB Inbound Rules

The application servers should **not** normally accept HTTP traffic directly from the entire internet.

Instead, allow application traffic from the **SG-ALB**.

For example, if the application listens on port `80`:

```text
Type:
HTTP

Protocol:
TCP

Port:
80

Source:
SG-ALB
```

The important part is:

```text
Source:
SG-ALB
```

rather than:

```text
0.0.0.0/0
```

This means only resources associated with the ALB Security Group can initiate traffic to the application port.

---

# 🔑 Step 6 — Configure SSH Access

SSH access may be required for administration and troubleshooting.

For SSH:

```text
Type:
SSH

Protocol:
TCP

Port:
22
```

### ⚠️ Do not normally use:

```text
Source:
0.0.0.0/0
```

for SSH in a production environment.

Instead, restrict SSH to your trusted IP address:

```text
Source:
YOUR_PUBLIC_IP/32
```

Example:

```text
203.0.113.10/32
```

> Replace the example IP with your actual trusted public IP. Do not use this documentation example as a real address.

For production environments, consider using **AWS Systems Manager Session Manager** instead of exposing SSH to the internet.

---

# 📊 Security Group Configuration

## 🟢 ALB-SG

| Type  | Port | Source      | Purpose            |
| ----- | ---: | ----------- | ------------------ |
| HTTP  |   80 | `0.0.0.0/0` | Public web traffic |
| HTTPS |  443 | `0.0.0.0/0` | Secure web traffic |

Architecture:

```text
Internet
   │
   ├── HTTP :80
   │
   └── HTTPS :443
           │
           ▼
        ALB-SG
```

---

## 🔵 App-SG

| Type | Port | Source       | Purpose             |
| ---- | ---: | ------------ | ------------------- |
| HTTP |   80 | `ALB-SG`     | Application traffic |
| SSH  |   22 | `YOUR_IP/32` | Administration      |

Architecture:

```text
ALB
 │
 │ TCP :80
 ▼
App-SG
 │
 ▼
EC2
```

---

# 🚫 Step 7 — Configure Outbound Rules

By default, a newly created Security Group commonly has an outbound rule allowing traffic to:

```text
0.0.0.0/0
```

For this learning project, you can leave the default outbound rule initially.

Example:

| Type        | Protocol | Destination |
| ----------- | -------- | ----------- |
| All traffic | All      | `0.0.0.0/0` |

Later, for a production environment, outbound access can be restricted according to the application's actual requirements.

---

# 🧠 Security Group Architecture

The recommended traffic flow is:

```text
                         🌐 Internet
                              │
                              │ :80 / :443
                              ▼
                    ┌─────────────────┐
                    │      ALB-SG     │
                    │  HTTP :80       │
                    │  HTTPS :443     │
                    └────────┬────────┘
                             │
                             │ :80
                             ▼
                    ┌─────────────────┐
                    │      App-SG     │
                    │ Source: ALB-SG  │
                    └────────┬────────┘
                             │
                             ▼
                      ┌─────────────┐
                      │ Application │
                      │    EC2      │
                      └─────────────┘
```

---

# 🔐 Why Use Separate Security Groups?

Using separate Security Groups provides better control.

### Without separate Security Groups

```text
Internet
   │
   └──────────────► EC2
```

The EC2 server could potentially be exposed directly to the internet.

### With separate Security Groups

```text
Internet
   │
   ▼
ALB
   │
   ▼
EC2
```

Only the required traffic reaches the application servers.

---
