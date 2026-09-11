# ⚖️ Step 9 — Create Application Load Balancer and Target Group

An **Application Load Balancer (ALB)** distributes incoming HTTP/HTTPS traffic across multiple application servers.

In this project, the ALB will be deployed across two public subnets:

```text
public-A
public-B
```

The ALB will forward application traffic to EC2 instances running in the private application subnets.

---

# 🎯 Objective

Create:

```text
Application Load Balancer:
HA-WebApp-ALB

Target Group:
WebServer-TG
```

Architecture:

```text
                         🌐 Internet
                              │
                              ▼
                     ┌─────────────────┐
                     │ HA-WebApp-ALB   │
                     │ Internet-facing │
                     └────────┬────────┘
                              │
                         HTTP :80
                              │
                              ▼
                     ┌─────────────────┐
                     │  WebServer-TG   │
                     └────────┬────────┘
                              │
                  ┌───────────┴───────────┐
                  │                       │
                  ▼                       ▼
             EC2-Web-1               EC2-Web-2
          Private-App-A            Private-App-B
```

---

# 🏷️ ALB Configuration

| Setting            | Value                     |
| ------------------ | ------------------------- |
| Load Balancer Type | Application Load Balancer |
| Name               | `HA-WebApp-ALB`           |
| Scheme             | Internet-facing           |
| VPC                | `AWS-Project-VPC`         |
| Subnet 1           | `public-A`                |
| Subnet 2           | `public-B`                |
| Security Group     | `ALB-SG`                  |
| Listener           | HTTP :80                  |

---

# ➕ Step 1 — Open Load Balancers

Go to:

```text id="4b8d0s"
AWS Management Console
        ↓
EC2
        ↓
Load Balancers
```

Click:

```text id="6x1m5j"
Create Load Balancer
```

Select:

```text id="8yt2jk"
Application Load Balancer
```

Click:

```text id="u0w2kf"
Create
```

---

# 🏷️ Step 2 — Configure Basic Load Balancer Settings

Enter:

```text id="b0i7ye"
Load balancer name:
HA-WebApp-ALB
```

For:

```text id="d5kh4e"
Scheme:
Internet-facing
```

An internet-facing ALB receives traffic from clients over the internet.

---

# 🌐 Step 3 — Configure Network Mapping

Under **Network mapping**, select:

```text id="8x3jke"
VPC:
AWS-Project-VPC
```

Select both public subnets:

```text id="q8o4y7"
Availability Zone:
ap-south-1a
Subnet:
public-A
```

and:

```text id="1sl2dr"
Availability Zone:
ap-south-1b
Subnet:
public-B
```

The ALB will therefore operate across two Availability Zones.

Architecture:

```text id="yn4r0v"
                 HA-WebApp-ALB
                       │
            ┌──────────┴──────────┐
            │                     │
            ▼                     ▼
         public-A             public-B
       ap-south-1a           ap-south-1b
```

---

# 🔒 Step 4 — Select Security Group

Under **Security groups**, select:

```text id="lq17we"
ALB-SG
```

The `ALB-SG` created earlier should allow:

```text id="g0j7ko"
HTTP  :80  → 0.0.0.0/0
HTTPS :443 → 0.0.0.0/0
```

For the initial HTTP-only test, port `80` is sufficient.

---

# 🎯 Step 5 — Create Target Group

Under **Listeners and routing**, configure the listener:

```text id="r7tq7p"
Protocol:
HTTP

Port:
80
```

Create a new target group.

Configure:

```text id="x5d7mt"
Target group name:
WebServer-TG

Target type:
Instances

Protocol:
HTTP

Port:
80
```

---

# 🏥 Step 6 — Configure Health Check

Configure:

```text id="0xk8q3"
Health check protocol:
HTTP

Health check path:
/
```

The ALB will periodically send requests to:

```text id="9f9d8f"
/ 
```

to determine whether an application instance is healthy.

Expected response:

```text id="5m0t3h"
HTTP 200 OK
```

A healthy instance can receive traffic.

An unhealthy instance is removed from normal load-balancing traffic until it becomes healthy again.

---

# 🔗 Step 7 — Register Targets

When the target group is created, you can register your application EC2 instances.

For example:

```text id="vq7c4u"
WebServer-TG
│
├── EC2-Web-1
│
└── EC2-Web-2
```

The EC2 instances should be running the Apache web server configured through the `WebServer-LT` User Data script.

The application port is:

```text id="y1v9nd"
HTTP :80
```

---

# 🔐 Important — App-SG Rule

The application EC2 instances should allow HTTP traffic from the ALB Security Group.

Configure `App-SG`:

```text id="j5n2xw"
Inbound Rule:

Type:
HTTP

Port:
80

Source:
ALB-SG
```

Do **not** normally configure:

```text id="f5r0bc"
HTTP :80
Source: 0.0.0.0/0
```

on the private application EC2 instances.

The intended traffic flow is:

```text id="2h1l4p"
Internet
   │
   ▼
HA-WebApp-ALB
   │
   │ HTTP :80
   ▼
App-SG
   │
   ▼
EC2
```

---

# ➕ Step 8 — Create the Load Balancer

Review the configuration:

```text id="t8p2r1"
Name:
HA-WebApp-ALB

Scheme:
Internet-facing

VPC:
AWS-Project-VPC

Subnets:
public-A
public-B

Security Group:
ALB-SG

Listener:
HTTP :80

Target Group:
WebServer-TG
```

Click:

```text id="0e3zj4"
Create load balancer
```

AWS will begin provisioning the ALB.

---

# ⏳ Step 9 — Wait for the ALB

After creation, the Load Balancer may initially show:

```text id="q9x2b6"
Provisioning
```

Wait until the state becomes:

```text id="m5k2az"
Active
```

---

# 🔍 Step 10 — Verify the ALB

Go to:

```text id="m4y0fj"
EC2
    ↓
Load Balancers
```

Select:

```text id="9p2m2d"
HA-WebApp-ALB
```

Verify:

```text id="f5u3b2"
Name:
HA-WebApp-ALB

Type:
Application Load Balancer

Scheme:
Internet-facing

State:
Active

VPC:
AWS-Project-VPC
```

Verify the Availability Zones:

```text id="5q0z8p"
ap-south-1a → public-A

ap-south-1b → public-B
```

---

# 🏥 Verify Target Group Health

Go to:

```text id="0v3a2r"
EC2
    ↓
Target Groups
    ↓
WebServer-TG
    ↓
Targets
```

Check the registered instances.

Expected:

```text id="4r3n9h"
EC2-Web-1 → Healthy
EC2-Web-2 → Healthy
```

If an instance shows:

```text id="3a4m9f"
Unhealthy
```

check:

* Apache is running.
* EC2 is listening on port `80`.
* `App-SG` allows HTTP from `ALB-SG`.
* The target is registered with the correct port.
* The health check path `/` returns successfully.
* The EC2 instance has the expected application installed.

---

# 🌐 Test the Application

After the ALB becomes active, copy its **DNS name**.

It will look similar to:

```text id="2h7s1c"
HA-WebApp-ALB-xxxxxxxx.ap-south-1.elb.amazonaws.com
```

Open the DNS name in a web browser:

```text id="y0g5v6"
http://HA-WebApp-ALB-xxxxxxxx.ap-south-1.elb.amazonaws.com
```

You should see:

```text id="5k2x1a"
Hello from <hostname>
```

The hostname comes from the User Data script in your Launch Template.

---

# 🔄 How Load Balancing Works

Suppose you have two healthy EC2 instances:

```text id="k3d4m8"
EC2-Web-1
10.0.10.x

EC2-Web-2
10.0.11.x
```

The ALB distributes incoming requests between healthy targets.

Conceptually:

```text id="5u8x3e"
                    🌐 Users
                       │
                       ▼
                HA-WebApp-ALB
                       │
              ┌────────┴────────┐
              │                 │
              ▼                 ▼
          EC2-Web-1         EC2-Web-2
              │                 │
         Private-App-A      Private-App-B
```

This improves availability and allows the application to scale horizontally.

---

# 🏥 Health Check Flow

The ALB continuously checks the targets:

```text id="j2g4k5"
HA-WebApp-ALB
       │
       │ GET /
       ▼
   EC2-Web-1
       │
       │ HTTP 200
       ▼
    Healthy
```

If the instance stops responding correctly:

```text id="v5w2s8"
HA-WebApp-ALB
       │
       │ Health Check
       ▼
   EC2-Web-1
       │
       ✕
   Unhealthy
       │
       ▼
ALB stops sending
normal traffic
```

---

# 🏗️ Complete ALB Architecture

```text id="d3n7t8"
                         🌐 Internet
                              │
                              │ HTTP :80
                              ▼
                  ┌──────────────────────┐
                  │    HA-WebApp-ALB     │
                  │   Internet-facing    │
                  │      ALB-SG          │
                  └──────────┬───────────┘
                             │
                         HTTP :80
                             │
                             ▼
                    ┌─────────────────┐
                    │  WebServer-TG   │
                    │ Health Check /  │
                    └────────┬────────┘
                             │
                  ┌──────────┴──────────┐
                  │                     │
                  ▼                     ▼
           Private-App-A          Private-App-B
           ap-south-1a             ap-south-1b
                  │                     │
                  ▼                     ▼
              EC2-Web-1             EC2-Web-2
                  │                     │
                  └──────────┬──────────┘
                             │
                          App-SG
```

---

# 🔐 Security Architecture

The Security Groups should work together:

```text id="0u4p0d"
Internet
   │
   │ :80 / :443
   ▼
┌───────────┐
│  ALB-SG   │
└─────┬─────┘
      │
      │ :80
      ▼
┌───────────┐
│  App-SG   │
│ Source:   │
│  ALB-SG   │
└─────┬─────┘
      │
      ▼
   EC2 App
```

This prevents direct public access to the application servers.

---

# 📊 Component Summary

| Component          | Name              | Configuration     |
| ------------------ | ----------------- | ----------------- |
| VPC                | `AWS-Project-VPC` | `10.0.0.0/16`     |
| Public Subnet      | `public-A`        | `ap-south-1a`     |
| Public Subnet      | `public-B`        | `ap-south-1b`     |
| ALB                | `HA-WebApp-ALB`   | Internet-facing   |
| ALB Security Group | `ALB-SG`          | HTTP/HTTPS        |
| Target Group       | `WebServer-TG`    | HTTP :80          |
| App Security Group | `App-SG`          | Traffic from ALB  |
| Launch Template    | `WebServer-LT`    | Amazon Linux 2023 |
| Application        | Apache HTTPD      | Port 80           |

---

# ⚠️ Important Notes

### ALB must use at least two Availability Zones

For this project:

```text
ap-south-1a
ap-south-1b
```

This provides better Availability Zone resilience.

### ALB should use public subnets

Because this is an:

```text
Internet-facing ALB
```

we place it in:

```text
public-A
public-B
```

### Application instances stay private

The EC2 application instances should be launched in:

```text
Private-App-A
Private-App-B
```

and should not require public IP addresses.

---

# 💡 Why Use an ALB?

Without an ALB:

```text
Internet
   │
   ├──────────► EC2-1
   │
   └──────────► EC2-2
```

Users need to know the individual server addresses.

With an ALB:

```text
Internet
   │
   ▼
   ALB
   │
   ├──► EC2-1
   │
   └──► EC2-2
```

The ALB provides:

* Load distribution
* Health checks
* High availability
* A single application endpoint
* Integration with Auto Scaling
* TLS/HTTPS termination

---

# ✅ Verification Checklist

### Application Load Balancer

* [ ] `HA-WebApp-ALB` created
* [ ] Type is Application Load Balancer
* [ ] Scheme is Internet-facing
* [ ] VPC is `AWS-Project-VPC`
* [ ] `public-A` selected
* [ ] `public-B` selected
* [ ] `ALB-SG` attached
* [ ] HTTP listener on port `80`
* [ ] ALB state is `Active`

### Target Group

* [ ] `WebServer-TG` created
* [ ] Target type is `Instances`
* [ ] Protocol is HTTP
* [ ] Port is `80`
* [ ] Health check path is `/`
* [ ] EC2 instances registered
* [ ] Targets show `Healthy`

### Application Security

* [ ] `App-SG` allows HTTP from `ALB-SG`
* [ ] EC2 instances do not need public IPv4 addresses
* [ ] Apache is running on EC2
* [ ] Application responds on port `80`

---

# 🚀 Next Step

The ALB and Target Group are now ready.

The next step is to create an **Auto Scaling Group (ASG)** using:

```text
WebServer-LT
```

The ASG will automatically maintain the desired number of application instances and distribute them across:

```text
Private-App-A
Private-App-B
```

Final flow:

```text id="n4s7w2"
Internet
   │
   ▼
HA-WebApp-ALB
   │
   ▼
WebServer-TG
   │
   ▼
Auto Scaling Group
   │
   ├── Private-App-A → EC2
   │
   └── Private-App-B → EC2
```

```text id="f1v5e8"
Step 1  → VPC                    ✅
Step 2  → Subnets               ✅
Step 3  → Internet Gateway      ✅
Step 4  → NAT Gateway           ✅
Step 5  → Route Tables          ✅
Step 6  → Security Groups       ✅
Step 7  → IAM Role              ✅
Step 8  → Launch Template       ✅
Step 9  → ALB + Target Group    ✅
Step 10 → Auto Scaling Group    ⏭️
```

---

## 📁 GitHub File Structure

```text id="q8d5r4"
AWS-Highly-Available-Web-Application/
│
├── README.md
│
└── docs/
    │
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
        ├── launch-template.md
        └── alb-and-target-group.md   ← This file
```
