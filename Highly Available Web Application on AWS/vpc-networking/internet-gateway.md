# 🌐 Step 3 — Create and Attach an Internet Gateway

An **Internet Gateway (IGW)** allows resources in a VPC to communicate with the public internet.

In this step, we will:

1. Create an Internet Gateway.
2. Name it `HA-WebApp-IGW`.
3. Attach it to `AWS-Project-VPC`.
4. Verify the attachment.

---

# 🎯 Objective

Create the following Internet Gateway:

| Setting               | Value             |
| --------------------- | ----------------- |
| Internet Gateway Name | `HA-WebApp-IGW`   |
| VPC                   | `AWS-Project-VPC` |
| State                 | Attached          |

Architecture:

```text
                    Internet
                       │
                       │
                ┌──────▼──────┐
                │   Internet  │
                │   Gateway   │
                │ HA-WebApp-IGW│
                └──────┬──────┘
                       │
                       │
              ┌────────▼────────┐
              │ AWS-Project-VPC │
              │  10.0.0.0/16   │
              └─────────────────┘
```

---

# ➕ Step 1 — Open Internet Gateways

Go to:

```text
AWS Management Console
        ↓
VPC
        ↓
Internet gateways
```

Click:

```text
Create internet gateway
```

---

# 🏷️ Step 2 — Enter Name

Enter:

```text
Name:
HA-WebApp-IGW
```

Click:

```text
Create internet gateway
```

AWS will create the Internet Gateway.

At this point, the gateway exists but is **not yet attached to the VPC**.

---

# 🔗 Step 3 — Attach to VPC

Select:

```text
HA-WebApp-IGW
```

Choose:

```text
Actions
    ↓
Attach to a VPC
```

Under **Available VPCs**, select:

```text
AWS-Project-VPC
```

Click:

```text
Attach internet gateway
```

---

# 🔍 Step 4 — Verify

Go to:

```text
VPC
    ↓
Internet gateways
```

Select:

```text
HA-WebApp-IGW
```

Verify:

```text
Internet Gateway:
HA-WebApp-IGW

State:
Attached

VPC:
AWS-Project-VPC
```

Expected result:

```text
HA-WebApp-IGW
│
├── State: Attached
│
└── VPC: AWS-Project-VPC
          │
          └── CIDR: 10.0.0.0/16
```

---

# 🧠 Important Concept

Creating an Internet Gateway alone does **not** make a subnet public.

For a subnet to have internet connectivity, the subnet's route table must contain a default route:

```text
0.0.0.0/0
        ↓
Internet Gateway
```
