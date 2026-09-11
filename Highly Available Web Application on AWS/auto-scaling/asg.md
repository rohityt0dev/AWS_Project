# 📈 Step 10 — Create an Auto Scaling Group

An **Auto Scaling Group (ASG)** automatically manages the number of EC2 instances running your application.

For this project, the Auto Scaling Group will:

* Launch EC2 instances using `WebServer-LT`
* Deploy instances across two private subnets
* Maintain a minimum of 2 instances
* Maintain a desired capacity of 2 instances
* Scale up to 4 instances when required
* Register instances with `WebServer-TG`
* Use ALB health checks to replace unhealthy instances
* Use CPU utilization for automatic scaling

---

# 🎯 Objective

Create:

```text
Auto Scaling Group:
WebServer-ASG
```

Configuration:

| Setting          | Value                   |
| ---------------- | ----------------------- |
| ASG Name         | `WebServer-ASG`         |
| Launch Template  | `WebServer-LT`          |
| VPC              | `AWS-Project-VPC`       |
| Private Subnet A | `Private-App-A`         |
| Private Subnet B | `Private-App-B`         |
| Desired Capacity | `2`                     |
| Minimum Capacity | `2`                     |
| Maximum Capacity | `4`                     |
| Load Balancer    | `HA-WebApp-ALB`         |
| Target Group     | `WebServer-TG`          |
| Health Check     | ELB                     |
| Scaling Policy   | Target Tracking         |
| Metric           | Average CPU Utilization |
| Target           | `50%`                   |

---

# 🏗️ Auto Scaling Architecture

```text
                         🌐 Internet
                              │
                              ▼
                    ┌──────────────────┐
                    │  HA-WebApp-ALB   │
                    │     ALB-SG       │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │  WebServer-TG    │
                    └────────┬─────────┘
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
                       WebServer-ASG
                             │
                       Target Tracking
                         CPU = 50%
```

---

# ➕ Step 1 — Open Auto Scaling Groups

Go to:

```text
AWS Management Console
        ↓
EC2
        ↓
Auto Scaling Groups
```

Click:

```text
Create Auto Scaling group
```

---

# 🏷️ Step 2 — Enter Auto Scaling Group Name

Enter:

```text
Name:
WebServer-ASG
```

---

# 🚀 Step 3 — Select Launch Template

Under **Launch Template**, select:

```text
WebServer-LT
```

Verify that the template contains:

```text
AMI:
Amazon Linux 2023

Instance Type:
t3.micro

Security Group:
App-SG

IAM Role:
EC2-WebServer-Role

User Data:
Apache HTTP Server
```

Click:

```text
Next
```

---

# 🌐 Step 4 — Configure Network

Select:

```text
VPC:
AWS-Project-VPC
```

For Availability Zones and subnets, select both private application subnets:

```text
Private-App-A
ap-south-1a
```

and:

```text
Private-App-B
ap-south-1b
```

The instances will therefore be distributed across two Availability Zones.

```text
AWS-Project-VPC
│
├── ap-south-1a
│   └── Private-App-A
│       └── EC2
│
└── ap-south-1b
    └── Private-App-B
        └── EC2
```

---

# ⚖️ Step 5 — Configure Load Balancing

Under **Load balancing**, choose:

```text
Attach to an existing load balancer
```

Select the existing load balancer:

```text
HA-WebApp-ALB
```

Select the target group:

```text
WebServer-TG
```

The resulting traffic flow is:

```text
Internet
   │
   ▼
HA-WebApp-ALB
   │
   ▼
WebServer-TG
   │
   ▼
WebServer-ASG
   │
   ├── EC2-Web-1
   │
   └── EC2-Web-2
```

---

# 🏥 Step 6 — Configure Health Checks

Enable:

```text
ELB health checks
```

The ASG will use the load balancer's health information to help determine whether instances are healthy.

This is important because an EC2 instance can be running while the application itself is not responding correctly.

Example:

```text
EC2 Instance
     │
     ▼
Apache
     │
     ▼
Health Check /
     │
     ▼
HTTP 200
     │
     ▼
Healthy
```

If an instance becomes unhealthy, the ASG can terminate and replace it according to its configuration.

---

# 📊 Step 7 — Configure Group Size

Configure:

```text
Desired capacity:
2

Minimum capacity:
2

Maximum capacity:
4
```

Your configuration:

```text
Minimum       Desired        Maximum
   2             2              4
   │             │              │
   ▼             ▼              ▼
  2 EC2        2 EC2           4 EC2
```

### What does this mean?

**Minimum = 2**

The ASG should maintain at least two instances.

**Desired = 2**

The initial desired number of instances is two.

**Maximum = 4**

The ASG can scale out to a maximum of four instances based on the scaling policy.

---

# 📈 Step 8 — Configure Scaling Policy

Select:

```text
Target tracking scaling policy
```

For the metric type, choose:

```text
Average CPU utilization
```

Set:

```text
Target value:
50%
```

Configuration:

```text
Scaling Policy:
Target Tracking

Metric:
Average CPU Utilization

Target:
50%
```

The ASG attempts to maintain the average CPU utilization of the group around the configured target.

---

# 🔄 How Target Tracking Works

Suppose the ASG currently has two instances:

```text
EC2-1 → CPU 80%
EC2-2 → CPU 75%
```

The average CPU utilization is high relative to the target.

The ASG can launch additional instances:

```text
Before:

EC2-1
EC2-2

        ↓

Scale Out

        ↓

EC2-1
EC2-2
EC2-3
```

If demand decreases, the ASG can scale in, subject to the minimum capacity:

```text
Before:

EC2-1
EC2-2
EC2-3
EC2-4

        ↓

Scale In

        ↓

EC2-1
EC2-2
```

The ASG will not normally go below:

```text
Minimum capacity = 2
```

---

# ⚠️ Important Clarification

A `50%` target does **not** mean:

> "If CPU goes above exactly 50%, immediately add one instance."

Target tracking is a control policy that attempts to keep the group's average CPU utilization around the configured target. AWS determines when and how much capacity to add or remove based on the policy and current conditions.

---

# 🏷️ Step 9 — Configure Instance Distribution

Because this is a highly available application, distribute instances across:

```text
ap-south-1a
ap-south-1b
```

Recommended placement:

```text
                WebServer-ASG
                      │
          ┌───────────┴───────────┐
          │                       │
          ▼                       ▼
    ap-south-1a              ap-south-1b
          │                       │
          ▼                       ▼
 Private-App-A              Private-App-B
          │                       │
          ▼                       ▼
       EC2-Web-1               EC2-Web-2
```

This reduces dependence on a single Availability Zone.

---

# ➕ Step 10 — Create Auto Scaling Group

Review the configuration:

```text
Name:
WebServer-ASG

Launch Template:
WebServer-LT

VPC:
AWS-Project-VPC

Subnets:
Private-App-A
Private-App-B

Load Balancer:
HA-WebApp-ALB

Target Group:
WebServer-TG

Health Check:
ELB

Desired:
2

Minimum:
2

Maximum:
4

Scaling:
Target Tracking

Metric:
Average CPU Utilization

Target:
50%
```

Click:

```text
Create Auto Scaling group
```

---

# ⏳ Step 11 — Wait for Instances

After creating the ASG, AWS should launch the desired number of instances.

Go to:

```text
EC2
    ↓
Auto Scaling Groups
    ↓
WebServer-ASG
```

Check:

```text
Desired capacity:
2

Running capacity:
2
```

Then go to:

```text
EC2
    ↓
Instances
```

You should see instances launched by the ASG.

---

# 🔍 Step 12 — Verify Target Group

Go to:

```text
EC2
    ↓
Target Groups
    ↓
WebServer-TG
    ↓
Targets
```

Expected:

```text
EC2-Web-1 → Healthy
EC2-Web-2 → Healthy
```

If both targets become healthy:

```text
WebServer-TG
│
├── EC2-Web-1 ✅ Healthy
└── EC2-Web-2 ✅ Healthy
```

the ALB can send application traffic to them.

---

# 🌐 Step 13 — Test the Application

Open:

```text
EC2
    ↓
Load Balancers
    ↓
HA-WebApp-ALB
```

Copy the ALB DNS name.

Open:

```text
http://<ALB-DNS-NAME>
```

You should see:

```text
Hello from <hostname>
```

Refresh the page multiple times.

Because the hostname is generated from the EC2 instance, you may see responses from different instances as the ALB distributes requests.

Example:

```text
Hello from ip-10-0-10-25...
```

and:

```text
Hello from ip-10-0-11-42...
```

This demonstrates that traffic is being served by multiple application instances.

---

# 🧪 Step 14 — Test Auto Scaling

You can test scaling by generating CPU load on the instances.

For a controlled learning environment, monitor:

```text
EC2
 ↓
Auto Scaling Groups
 ↓
WebServer-ASG
 ↓
Activity
```

Also check:

```text
CloudWatch
    ↓
Metrics
    ↓
EC2
```

Monitor:

```text
CPUUtilization
```

When the target tracking policy determines that additional capacity is required, the ASG can launch additional instances.

Remember that scaling is not necessarily instantaneous.

---

# 📈 Auto Scaling Flow

```text
                 User Traffic
                      │
                      ▼
                Application ALB
                      │
                      ▼
                 WebServer-TG
                      │
                      ▼
                WebServer-ASG
                      │
              Average CPU = 50%
                      │
            ┌─────────┴─────────┐
            │                   │
          Scale Out           Scale In
            │                   │
            ▼                   ▼
       Add instances       Remove instances
            │                   │
            └─────────┬─────────┘
                      ▼
                Desired Capacity
                   2 → 4
```

---

# 🏗️ Complete Application Architecture

```text
                             🌐 Internet
                                  │
                                  │ HTTP / HTTPS
                                  ▼
                    ┌────────────────────────┐
                    │    HA-WebApp-ALB       │
                    │       ALB-SG            │
                    └───────────┬────────────┘
                                │
                                │ HTTP :80
                                ▼
                    ┌────────────────────────┐
                    │     WebServer-TG        │
                    │    Health Check: /      │
                    └───────────┬────────────┘
                                │
                         WebServer-ASG
                                │
               ┌────────────────┴────────────────┐
               │                                 │
               ▼                                 ▼
        ┌──────────────┐                  ┌──────────────┐
        │ Private-App-A│                  │ Private-App-B│
        │ ap-south-1a  │                  │ ap-south-1b  │
        └──────┬───────┘                  └──────┬───────┘
               │                                 │
               ▼                                 ▼
          EC2-Web-1                         EC2-Web-2
               │                                 │
               └──────────────┬──────────────────┘
                              │
                           App-SG
                              │
                       EC2-WebServer-Role
                         │             │
                         ▼             ▼
                        S3            SNS
```

---

# 🔐 Security Architecture

The final traffic path should be:

```text
Internet
   │
   │ :80 / :443
   ▼
ALB
   │
   │ :80
   ▼
App-SG
   │
   ▼
Private EC2
```

The EC2 instances should not need public IPv4 addresses.

Outbound traffic from private instances can use:

```text
Private EC2
     │
     ▼
Private Route Table
     │
     ▼
NATG
     │
     ▼
Internet Gateway
     │
     ▼
Internet
```

---

# 📊 Auto Scaling Group Summary

| Configuration    | Value                   |
| ---------------- | ----------------------- |
| ASG Name         | `WebServer-ASG`         |
| Launch Template  | `WebServer-LT`          |
| VPC              | `AWS-Project-VPC`       |
| Subnet 1         | `Private-App-A`         |
| Subnet 2         | `Private-App-B`         |
| Desired Capacity | `2`                     |
| Minimum Capacity | `2`                     |
| Maximum Capacity | `4`                     |
| Load Balancer    | `HA-WebApp-ALB`         |
| Target Group     | `WebServer-TG`          |
| Health Check     | ELB                     |
| Scaling Policy   | Target Tracking         |
| Metric           | Average CPU Utilization |
| Target           | `50%`                   |

---

# 🧠 Key AWS Concepts

### Auto Scaling Group

Automatically manages EC2 capacity according to desired, minimum, maximum, health, and scaling-policy settings.

### Launch Template

Defines how new EC2 instances should be launched.

```text
WebServer-LT
      │
      ▼
EC2 configuration
```

### Target Group

Provides the set of targets that the ALB sends traffic to.

```text
WebServer-TG
      │
      ├── EC2
      └── EC2
```

### Target Tracking

Attempts to maintain a selected CloudWatch metric around a target value.

```text
Average CPU
     ↓
   50%
```

### ELB Health Check

Allows the load balancer to determine whether application targets are healthy.

---

# ⚠️ Troubleshooting

## Target is unhealthy

Check:

```bash
sudo systemctl status httpd
```

Check:

```bash
curl http://localhost
```

Check the Security Group:

```text
App-SG
    ↓
HTTP :80
    ↓
Source: ALB-SG
```

---

## EC2 cannot install Apache

If the EC2 instances are in private subnets, verify:

```text
Private-App-A/B
       ↓
private-RT
       ↓
NATG
       ↓
public-A
       ↓
HA-WebApp-IGW
       ↓
Internet
```

---

## Instances are not launching

Check:

* Launch Template configuration
* IAM permissions
* Subnet configuration
* Availability Zone availability
* Instance type availability
* Security Group
* ASG activity history
* EC2 service quotas

---

## ALB cannot reach EC2

Check:

```text
ALB-SG
   │
   │ HTTP :80
   ▼
App-SG
   │
   ▼
EC2
```

The `App-SG` inbound rule should reference `ALB-SG`.

---

# ✅ Verification Checklist

### Auto Scaling Group

* [ ] `WebServer-ASG` created
* [ ] `WebServer-LT` selected
* [ ] `AWS-Project-VPC` selected
* [ ] `Private-App-A` selected
* [ ] `Private-App-B` selected
* [ ] Desired capacity = `2`
* [ ] Minimum capacity = `2`
* [ ] Maximum capacity = `4`
* [ ] Existing ALB attached
* [ ] `WebServer-TG` configured
* [ ] ELB health checks enabled
* [ ] Target tracking enabled
* [ ] Average CPU utilization selected
* [ ] Target value = `50%`
* [ ] Two EC2 instances launched
* [ ] Targets are healthy
* [ ] ALB DNS successfully serves the application

---

# 🎉 Project Progress

Your highly available AWS web application now has:

```text
Step 1  → VPC                    ✅
Step 2  → Subnets               ✅
Step 3  → Internet Gateway      ✅
Step 4  → NAT Gateway           ✅
Step 5  → Route Tables          ✅
Step 6  → Security Groups       ✅
Step 7  → IAM Role              ✅
Step 8  → Launch Template       ✅
Step 9  → ALB + Target Group    ✅
Step 10 → Auto Scaling Group    ✅
```

The core application architecture is now:

```text
                         🌐 Internet
                              │
                              ▼
                    HA-WebApp-ALB
                              │
                              ▼
                       WebServer-TG
                              │
                              ▼
                       WebServer-ASG
                         /          \
                        /            \
                       ▼              ▼
                Private-App-A    Private-App-B
                    EC2               EC2
                       \              /
                        \            /
                         └────┬─────┘
                              │
                         EC2-WebServer-Role
                           │            │
                           ▼            ▼
                          S3           SNS
```

---

# 🚀 Next Step

The next step can be **CloudWatch Monitoring and SNS Notifications**.

We can configure monitoring for:

```text
EC2 CPU
ALB Requests
ALB Target Health
ASG Capacity
```

and send alerts through:

```text
CloudWatch
     │
     ▼
SNS Topic
     │
     ▼
Email Notification
```

This will complete another important part of the highly available production-style architecture.

---

## 📁 GitHub File Structure

```text
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
        ├── alb-and-target-group.md
        └── auto-scaling-group.md   ← This file
```
