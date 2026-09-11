# 🌐 Step 4 — Create a NAT Gateway

A **NAT Gateway** allows resources in a private subnet to access the internet for outbound connections while keeping those resources without public IPv4 addresses.

For this project, the NAT Gateway will be deployed in the **public-A subnet**.

---

# 📍 Important

A NAT Gateway should be created in a **public subnet**.

For this project:

```text id="h7k5fz"
NAT Gateway:
NATG

Subnet:
public-A
```

Architecture:

```text id="9p5x9j"
Private-App-A
     │
     │
     ▼
 Route Table
     │
     ▼
   NATG
     │
     ▼
 public-A
     │
     ▼
Internet Gateway
     │
     ▼
 Internet
```

---

# 🎯 Objective

Create the following NAT Gateway:

| Setting           | Value                |
| ----------------- | -------------------- |
| NAT Gateway Name  | `NATG`               |
| Subnet            | `public-A`           |
| Availability Zone | `ap-south-1a`        |
| Connectivity Type | Public               |
| Elastic IP        | Allocated Elastic IP |
| State             | Available            |

---

# ➕ Step 1 — Open NAT Gateways

Go to:

```text id="5n7xq4"
AWS Management Console
        ↓
VPC
        ↓
NAT gateways
```

Click:

```text id="2b3qcd"
Create NAT gateway
```

---

# 🏷️ Step 2 — Configure NAT Gateway

Configure the NAT Gateway as follows:

```text id="d7j4pz"
Name:
NATG

Subnet:
public-A

Connectivity type:
Public

Elastic IP:
Select the Elastic IP allocated earlier
```

The configuration should be:

```text id="q7h7lq"
NAT Gateway
│
├── Name: NATG
├── Subnet: public-A
├── Connectivity: Public
└── Elastic IP: Allocated EIP
```

Click:

```text id="g3z7ri"
Create NAT gateway
```

---

# ⏳ Step 3 — Wait for Available

After creation, the NAT Gateway will initially be in a provisioning state.

Go to:

```text id="8g6r0k"
VPC
    ↓
NAT gateways
```

Find:

```text id="m9h8jw"
NATG
```

Initially, the state may show:

```text id="2p8w3h"
Pending
```

Wait until the state changes to:

```text id="z5b1ny"
Available
```

> ⚠️ Do not configure the private route table until the NAT Gateway is successfully available.

---

# 🔍 Verify NAT Gateway

Go to:

```text id="e5a3xd"
VPC
    ↓
NAT gateways
```

Select:

```text id="1s5q0b"
NATG
```

Verify:

```text id="q7w3ek"
Name:
NATG

Subnet:
public-A

Connectivity type:
Public

Elastic IP:
Your allocated Elastic IP

State:
Available
```

---

# 📊 NAT Gateway Configuration

| Setting           | Configuration     |
| ----------------- | ----------------- |
| Name              | `NATG`            |
| VPC               | `AWS-Project-VPC` |
| Subnet            | `public-A`        |
| Availability Zone | `ap-south-1a`     |
| Connectivity      | Public            |
| Elastic IP        | Allocated EIP     |
| State             | `Available`       |

---
