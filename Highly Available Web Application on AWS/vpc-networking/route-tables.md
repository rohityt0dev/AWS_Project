# 🛣️ Step 5 — Create and Configure Route Tables

Route tables control how network traffic moves between subnets and other network destinations.

In this step, we will create:

* 🟢 `public-RT` — for public subnets
* 🔒 `private-RT` — for private application subnets

The public route table will send internet traffic through the **Internet Gateway**, while the private route table will send outbound internet traffic through the **NAT Gateway**.

---

# 🎯 Objective

The final routing architecture will be:

```text
                         Internet
                            │
                            ▼
                    HA-WebApp-IGW
                            │
              ┌─────────────┴─────────────┐
              │                           │
         public-RT                    private-RT
              │                           │
        0.0.0.0/0 → IGW            0.0.0.0/0 → NATG
              │                           │
        ┌─────┴─────┐               ┌─────┴─────┐
        │           │               │           │
    public-A    public-B      Private-App-A  Private-App-B
```

---

# ➕ Step 1 — Create Public Route Table

Go to:

```text
AWS Management Console
        ↓
VPC
        ↓
Route Tables
```

Click:

```text
Create route table
```

Configure:

```text
Name:
public-RT

VPC:
AWS-Project-VPC
```

Click:

```text
Create route table
```

---

# 🌐 Step 2 — Add Internet Route

Select:

```text
public-RT
```

Go to:

```text
Routes
    ↓
Edit routes
    ↓
Add route
```

Configure:

```text
Destination:
0.0.0.0/0

Target:
Internet Gateway

HA-WebApp-IGW
```

Save the route.

### 📌 What does `0.0.0.0/0` mean?

```text
0.0.0.0/0
```

represents the default route for IPv4 traffic.

It means:

> Send traffic to any IPv4 destination that does not match a more specific route.

The public route therefore becomes:

```text
0.0.0.0/0
       ↓
HA-WebApp-IGW
```

---

# 🔗 Step 3 — Associate Public Subnets

Select:

```text
public-RT
```

Go to:

```text
Subnet associations
        ↓
Edit subnet associations
```

Select:

```text
public-A
public-B
```

Save the associations.

The final association should be:

```text
public-RT
    │
    ├── public-A
    │
    └── public-B
```

---

# 🔒 Step 4 — Create Private Route Table

Go to:

```text
VPC
    ↓
Route Tables
```

Click:

```text
Create route table
```

Configure:

```text
Name:
private-RT

VPC:
AWS-Project-VPC
```

Click:

```text
Create route table
```

---

# 🔄 Step 5 — Add NAT Route

Select:

```text
private-RT
```

Go to:

```text
Routes
    ↓
Edit routes
    ↓
Add route
```

Configure:

```text
Destination:
0.0.0.0/0

Target:
NAT Gateway

NATG
```

Save the route.

The private route table will now contain:

```text
0.0.0.0/0
      ↓
    NATG
```

---

# 🔗 Step 6 — Associate Private Subnets

Select:

```text
private-RT
```

Go to:

```text
Subnet associations
        ↓
Edit subnet associations
```

Select:

```text
Private-App-A
Private-App-B
```

Save the associations.

The final association should be:

```text
private-RT
    │
    ├── Private-App-A
    │
    └── Private-App-B
```

---

# 🧠 Understand the Traffic Flow

## 🟢 Public Subnet Traffic

Resources in the public subnets use:

```text
public-A / public-B
        │
        ▼
    public-RT
        │
        │ 0.0.0.0/0
        ▼
HA-WebApp-IGW
        │
        ▼
     Internet
```

---

## 🔵 Private Subnet Traffic

Resources in the private application subnets use:

```text
Private-App-A / Private-App-B
            │
            ▼
        private-RT
            │
            │ 0.0.0.0/0
            ▼
           NATG
            │
            ▼
     public-A subnet
            │
            ▼
     Internet Gateway
            │
            ▼
         Internet
```

This allows private resources to initiate outbound connections while they remain without public IPv4 addresses.

---

# 📊 Route Table Configuration

## 🟢 Public Route Table

| Setting            | Value                  |
| ------------------ | ---------------------- |
| Name               | `public-RT`            |
| VPC                | `AWS-Project-VPC`      |
| Route              | `0.0.0.0/0`            |
| Target             | `HA-WebApp-IGW`        |
| Associated Subnets | `public-A`, `public-B` |

---

## 🔒 Private Route Table

| Setting            | Value                            |
| ------------------ | -------------------------------- |
| Name               | `private-RT`                     |
| VPC                | `AWS-Project-VPC`                |
| Route              | `0.0.0.0/0`                      |
| Target             | `NATG`                           |
| Associated Subnets | `Private-App-A`, `Private-App-B` |

---

# 🏗️ Current Network Architecture

After completing Steps 1–5, your network should look like this:

```text
                           🌐 Internet
                               │
                               ▼
                       ┌───────────────┐
                       │ HA-WebApp-IGW │
                       └───────┬───────┘
                               │
                ┌──────────────┴──────────────┐
                │                             │
                ▼                             │
          ┌───────────┐                       │
          │ public-RT │                       │
          │ 0.0.0.0/0│                       │
          │    → IGW  │                       │
          └─────┬─────┘                       │
                │                             │
          ┌─────┴─────┐                       │
          │           │                       │
          ▼           ▼                       │
      public-A    public-B                    │
          │           │                       │
          │        NAT Gateway ◄──────────────┘
          │           NATG
          │
          │
   ┌──────┴─────────────────────┐
   │                            │
   ▼                            ▼
Private-App-A              Private-App-B
   │                            │
   └──────────┬─────────────────┘
              │
              ▼
         private-RT
              │
              │ 0.0.0.0/0
              ▼
             NATG
```

> **Note:** The NAT Gateway is located in `public-A`, so private subnet traffic reaches the NAT Gateway through its route and then exits through the Internet Gateway.

---

# ⚠️ Important

Creating a route table does not automatically associate it with a subnet.

You must explicitly associate:

```text
public-RT
    → public-A
    → public-B
```

and:

```text
private-RT
    → Private-App-A
    → Private-App-B
```

Also remember:

* Public subnets → Internet Gateway
* Private subnets → NAT Gateway
* NAT Gateway → Internet Gateway
* Private application instances should normally not receive public IPv4 addresses

---

# 🔍 Verify Route Tables

Go to:

```text
VPC
    ↓
Route Tables
```

Verify `public-RT`:

```text
Name:
public-RT

VPC:
AWS-Project-VPC

Route:
0.0.0.0/0 → HA-WebApp-IGW

Subnets:
public-A
public-B
```

Verify `private-RT`:

```text
Name:
private-RT

VPC:
AWS-Project-VPC

Route:
0.0.0.0/0 → NATG

Subnets:
Private-App-A
Private-App-B
```

---

# ✅ Verification Checklist

### Public Route Table

* [ ] `public-RT` created
* [ ] Associated with `AWS-Project-VPC`
* [ ] `0.0.0.0/0` route added
* [ ] Default route targets `HA-WebApp-IGW`
* [ ] `public-A` associated
* [ ] `public-B` associated

### Private Route Table

* [ ] `private-RT` created
* [ ] Associated with `AWS-Project-VPC`
* [ ] `0.0.0.0/0` route added
* [ ] Default route targets `NATG`
* [ ] `Private-App-A` associated
* [ ] `Private-App-B` associated

---

# 🚀 Next Step

The next step is to create **Security Groups**.

We will create security rules for the web application while following the principle of allowing only the traffic that is required.

```text
Step 1 → Create VPC
          ↓
Step 2 → Create Subnets
          ↓
Step 3 → Internet Gateway
          ↓
Step 4 → NAT Gateway
          ↓
Step 5 → Route Tables ✅
          ↓
Step 6 → Security Groups
          ↓
Step 7 → EC2 / ALB / ASG
```

---

## 📁 GitHub File

Save this documentation as:

```text
docs/
└── networking/
    ├── vpc.md
    ├── subnets.md
    ├── internet-gateway.md
    ├── nat-gateway.md
    ├── route-tables.md       ← This file
    └── security-groups.md
```
