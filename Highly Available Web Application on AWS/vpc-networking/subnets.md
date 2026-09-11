# 🖥️ Step 2 — Create AWS Subnets

In this step, we will create **four subnets** inside the `AWS-Project-VPC`.

The architecture will use two Availability Zones in the Mumbai Region:

* `ap-south-1a`
* `ap-south-1b`

We will create:

* 2 Public Subnets
* 2 Private Application Subnets

---

# 🎯 Objective

Create the following subnet architecture:

```text
AWS-Project-VPC
CIDR: 10.0.0.0/16
│
├── Availability Zone: ap-south-1a
│   │
│   ├── public-A
│   │   └── 10.0.1.0/24
│   │
│   └── Private-App-A
│       └── 10.0.10.0/24
│
└── Availability Zone: ap-south-1b
    │
    ├── public-B
    │   └── 10.0.2.0/24
    │
    └── Private-App-B
        └── 10.0.11.0/24
```

---

# 🖥️ Step 1 — Open Subnets

Go to:

```text
AWS Management Console
        ↓
VPC
        ↓
Subnets
```

Click:

```text
Create subnet
```

---

# 🟢 Step 2 — Create public-A

Select:

```text
VPC:
AWS-Project-VPC
```

Configure:

```text
Subnet name:
public-A

Availability Zone:
ap-south-1a

IPv4 subnet CIDR:
10.0.1.0/24
```

Click:

```text
Create subnet
```

### Configuration

| Setting           | Value         |
| ----------------- | ------------- |
| Subnet Name       | `public-A`    |
| Availability Zone | `ap-south-1a` |
| CIDR              | `10.0.1.0/24` |
| Type              | Public        |

---

# 🔵 Step 3 — Create Private-App-A

Select:

```text
VPC:
AWS-Project-VPC
```

Configure:

```text
Subnet name:
Private-App-A

Availability Zone:
ap-south-1a

IPv4 subnet CIDR:
10.0.10.0/24
```

Click:

```text
Create subnet
```

### Configuration

| Setting           | Value           |
| ----------------- | --------------- |
| Subnet Name       | `Private-App-A` |
| Availability Zone | `ap-south-1a`   |
| CIDR              | `10.0.10.0/24`  |
| Type              | Private         |

---

# 🟢 Step 4 — Create public-B

Select:

```text
VPC:
AWS-Project-VPC
```

Configure:

```text
Subnet name:
public-B

Availability Zone:
ap-south-1b

IPv4 subnet CIDR:
10.0.2.0/24
```

Click:

```text
Create subnet
```

### Configuration

| Setting           | Value         |
| ----------------- | ------------- |
| Subnet Name       | `public-B`    |
| Availability Zone | `ap-south-1b` |
| CIDR              | `10.0.2.0/24` |
| Type              | Public        |

---

# 🔵 Step 5 — Create Private-App-B

Select:

```text
VPC:
AWS-Project-VPC
```

Configure:

```text
Subnet name:
Private-App-B

Availability Zone:
ap-south-1b

IPv4 subnet CIDR:
10.0.11.0/24
```

Click:

```text
Create subnet
```

### Configuration

| Setting           | Value           |
| ----------------- | --------------- |
| Subnet Name       | `Private-App-B` |
| Availability Zone | `ap-south-1b`   |
| CIDR              | `10.0.11.0/24`  |
| Type              | Private         |

---

# 🌐 Step 6 — Enable Auto-Assign Public IPv4

A public subnet does not automatically become internet-accessible just because it is called "public."

For the public subnets:

```text
public-A
public-B
```

enable:

```text
Auto-assign public IPv4 address
```

### How to enable it

Go to:

```text
VPC
 ↓
Subnets
 ↓
Select public-A
 ↓
Actions
 ↓
Edit subnet settings
```

Enable:

```text
Enable auto-assign public IPv4 address
```

Save the changes.

Repeat the same process for:

```text
public-B
```

---

# 🔒 Private Subnets

For:

```text
Private-App-A
Private-App-B
```

normally keep:

```text
Auto-assign public IPv4 address:
Disabled
```

Application servers in these subnets can later access the internet through a **NAT Gateway**, while remaining without public IPv4 addresses.

---

# 🔍 Verify Subnets

Go to:

```text
VPC
 ↓
Subnets
```

You should now have:

```text
AWS-Project-VPC
│
├── 🟢 public-A
│   └── 10.0.1.0/24
│
├── 🔵 Private-App-A
│   └── 10.0.10.0/24
│
├── 🟢 public-B
│   └── 10.0.2.0/24
│
└── 🔵 Private-App-B
    └── 10.0.11.0/24
```

---

# 📊 Subnet Configuration

| Name               | Availability Zone | CIDR           | Public IPv4 |
| ------------------ | ----------------- | -------------- | ----------- |
| 🟢 `public-A`      | `ap-south-1a`     | `10.0.1.0/24`  | Enabled     |
| 🔵 `Private-App-A` | `ap-south-1a`     | `10.0.10.0/24` | Disabled    |
| 🟢 `public-B`      | `ap-south-1b`     | `10.0.2.0/24`  | Enabled     |
| 🔵 `Private-App-B` | `ap-south-1b`     | `10.0.11.0/24` | Disabled    |

---

# 🏗️ High Availability Design

The subnets are distributed across **two Availability Zones**:

```text
                 AWS-Project-VPC
                  10.0.0.0/16
                       │
          ┌────────────┴────────────┐
          │                         │
     ap-south-1a               ap-south-1b
          │                         │
     ┌────┴────┐               ┌────┴────┐
     │         │               │         │
  Public-A  Private-A       Public-B  Private-B
     │         │               │         │
10.0.1.0/24 10.0.10.0/24  10.0.2.0/24 10.0.11.0/24
```

Using multiple Availability Zones improves the architecture's resilience because application resources can be distributed across separate Availability Zones.

---
