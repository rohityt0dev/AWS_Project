# 🌐 Step 1 — Create an AWS VPC

This guide explains how to create a custom Virtual Private Cloud (VPC) using the **AWS Management Console**.

The VPC will use the CIDR block:

```text
10.0.0.0/16
```

---

## 🎯 Objective

Create a VPC with the following configuration:

| Setting   | Value              |
| --------- | ------------------ |
| VPC Name  | `AWS-Project-VPC`  |
| IPv4 CIDR | `10.0.0.0/16`      |
| IPv6 CIDR | No IPv6 CIDR block |
| Tenancy   | Default            |
| State     | Available          |

---

# 🚀 Step 1 — Open AWS VPC Console

Sign in to the **AWS Management Console**.

In the AWS Console search bar, search for:

```text
VPC
```

Open:

```text
VPC → Your VPCs
```

---

# ➕ Step 2 — Create VPC

Click:

```text
Create VPC
```

Under **Resources to create**, select:

```text
VPC only
```

Configure the VPC with the following values:

```text
Name tag:
AWS-Project-VPC

IPv4 CIDR:
10.0.0.0/16

IPv6 CIDR:
No IPv6 CIDR block

Tenancy:
Default
```

Your configuration should look like:

```text
┌─────────────────────────────────────┐
│          Create VPC                  │
├─────────────────────────────────────┤
│ Resources to create: VPC only       │
│                                     │
│ Name tag: AWS-Project-VPC           │
│ IPv4 CIDR: 10.0.0.0/16              │
│ IPv6 CIDR: No IPv6 CIDR block       │
│ Tenancy: Default                     │
└─────────────────────────────────────┘
```

Click:

```text
Create VPC
```

AWS will create the VPC.

---

# 🔍 Step 3 — Verify VPC

After the VPC is created, go to:

```text
VPC → Your VPCs
```

Find:

```text
AWS-Project-VPC
```

Verify the following:

```text
Name:
AWS-Project-VPC

IPv4 CIDR:
10.0.0.0/16

State:
Available
```

Expected result:

```text
AWS-Project-VPC
│
├── CIDR: 10.0.0.0/16
├── IPv6: None
├── Tenancy: Default
└── State: Available
```

---

