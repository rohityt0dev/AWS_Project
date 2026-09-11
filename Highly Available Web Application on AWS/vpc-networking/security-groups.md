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
├── ALB-SG
│   └── Internet → ALB
│
└── App-SG
    └── ALB → Application EC2
```

Security architecture:

```text
                    🌐 Internet
                         │
                         │ HTTP/HTTPS
                         ▼
                  ┌─────────────┐
                  │    ALB-SG   │
                  │   Port 80   │
                  │  Port 443   │
                  └──────┬──────┘
                         │
                         │ Application Traffic
                         ▼
                  ┌─────────────┐
                  │    App-SG   │
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
ALB-SG

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
App-SG

Description:
Security group for application EC2 instances

VPC:
AWS-Project-VPC
```

---

# 🔒 Step 5 — Configure App-SG Inbound Rules

The application servers should **not** normally accept HTTP traffic directly from the entire internet.

Instead, allow application traffic from the **ALB-SG**.

For example, if the application listens on port `80`:

```text
Type:
HTTP

Protocol:
TCP

Port:
80

Source:
ALB-SG
```

The important part is:

```text
Source:
ALB-SG
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

# 🛡️ Security Group vs Network ACL

Security Groups and Network ACLs are different AWS networking controls.

| Feature        | Security Group         | Network ACL                |
| -------------- | ---------------------- | -------------------------- |
| Scope          | Resource/ENI           | Subnet                     |
| Stateful       | ✅ Yes                  | ❌ No                       |
| Rules          | Allow only             | Allow + Deny               |
| Return traffic | Automatically allowed  | Must be explicitly handled |
| Common use     | EC2/ALB access control | Subnet-level filtering     |

For this project, Security Groups will provide the primary resource-level access control.

---

# ⚠️ Important Security Rules

Follow these principles:

### 1. Avoid unrestricted SSH

❌ Avoid:

```text
TCP :22
0.0.0.0/0
```

Prefer:

```text
TCP :22
YOUR_IP/32
```

or use Session Manager.

### 2. Do not expose private EC2 instances directly

The application EC2 instances should normally receive traffic from:

```text
ALB-SG
```

rather than:

```text
0.0.0.0/0
```

### 3. Open only required ports

For example:

```text
80  → HTTP
443 → HTTPS
22  → SSH administration, if required
```

Do not open unnecessary ports.

---

# 🔍 Verify Security Groups

Go to:

```text
VPC
    ↓
Security Groups
```

Verify:

### ALB-SG

```text
Name:
ALB-SG

VPC:
AWS-Project-VPC

Inbound:
80  → 0.0.0.0/0
443 → 0.0.0.0/0
```

### App-SG

```text
Name:
App-SG

VPC:
AWS-Project-VPC

Inbound:
80 → ALB-SG
22 → YOUR_IP/32
```

---

# 📊 Final Security Group Design

```text
┌───────────────────────────────────────────────┐
│             AWS-Project-VPC                   │
│                                               │
│       🌐 Internet                             │
│            │                                  │
│            │ 80 / 443                        │
│            ▼                                  │
│       ┌───────────┐                           │
│       │   ALB-SG  │                           │
│       └─────┬─────┘                           │
│             │                                 │
│             │ 80                              │
│             ▼                                 │
│       ┌───────────┐                           │
│       │   App-SG  │                           │
│       └─────┬─────┘                           │
│             │                                 │
│             ▼                                 │
│       Application EC2                         │
│                                               │
└───────────────────────────────────────────────┘
```

---

# 🏗️ Complete Network Architecture So Far

After completing Steps 1–6:

```text
                             🌐 Internet
                                  │
                                  ▼
                         ┌────────────────┐
                         │ HA-WebApp-IGW  │
                         └───────┬────────┘
                                 │
              ┌──────────────────┴──────────────────┐
              │                                     │
              ▼                                     │
        ┌───────────┐                               │
        │ public-RT │                               │
        │ 0.0.0.0/0 │                               │
        │    → IGW  │                               │
        └─────┬─────┘                               │
              │                                     │
       ┌──────┴──────┐                              │
       │             │                              │
       ▼             ▼                              │
   public-A      public-B                           │
       │                                             │
       │ NATG                                       │
       ▼                                             │
     NATG ◄─────────────────────────────────────────┘
       │
       │
       ▼
 private-RT
       │
 ┌─────┴──────────┐
 │                │
 ▼                ▼
Private-App-A  Private-App-B
 │                │
 └───────┬────────┘
         │
         ▼
      App EC2
         │
      App-SG
         ▲
         │
       ALB-SG
         ▲
         │
        ALB
```

---

# ✅ Verification Checklist

### ALB-SG

* [ ] `ALB-SG` created
* [ ] Associated with `AWS-Project-VPC`
* [ ] HTTP port `80` allowed
* [ ] HTTPS port `443` allowed
* [ ] Internet source configured where appropriate

### App-SG

* [ ] `App-SG` created
* [ ] Associated with `AWS-Project-VPC`
* [ ] Application port allowed from `ALB-SG`
* [ ] SSH restricted to trusted IP if SSH is required
* [ ] No unnecessary ports exposed

---

# 🚀 Next Step

The networking foundation is now ready:

```text
Step 1 → VPC                    ✅
Step 2 → Subnets               ✅
Step 3 → Internet Gateway      ✅
Step 4 → NAT Gateway           ✅
Step 5 → Route Tables          ✅
Step 6 → Security Groups       ✅
```

Next, we can move to the compute and load-balancing layer:

```text
                    Application Layer
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
       Application Load Balancer   Target Group
              │                         │
              └────────────┬────────────┘
                           │
                           ▼
                    EC2 / Auto Scaling
```

---

## 📁 GitHub File

Save this documentation as:

```text
AWS-Highly-Available-Web-Application/
│
├── README.md
│
└── docs/
    └── networking/
        ├── vpc.md
        ├── subnets.md
        ├── internet-gateway.md
        ├── nat-gateway.md
        ├── route-tables.md
        └── security-groups.md   ← This file
```

