# AWS Project 1 – Static Website Hosting with Amazon S3 & CloudFront

## 📌 Project Overview

This project demonstrates how to host a static website using **Amazon S3** and deliver it globally through **Amazon CloudFront CDN**.

The website consists of simple HTML files stored in an S3 bucket and distributed worldwide using CloudFront for low latency and improved performance.

---

## 🏗️ Architecture



---

## 🚀 Technologies Used

* Amazon S3
* Amazon CloudFront
* HTML
* AWS IAM
* CDN (Content Delivery Network)

---

## 📂 Project Structure

```
aws-s3-cloudfront-static-website/
│
├── index.html
├── README.md
└── screenshots/
    ├── s3-bucket.png
    ├── cloudfront-distribution.png
    └── website-output.png
```

---

## 🌐 Website Code

### index.html

```html
<!DOCTYPE html>
<html>
<head>
    <title>AWS Project 1</title>
</head>
<body>
    <h1>Hello AWS!</h1>
    <p>My first AWS project.</p>
</body>
</html>
```

---

## ⚙️ Implementation Steps

### Step 1: Create Website Files

Create an `index.html` file on your local machine.

---

### Step 2: Create an S3 Bucket

1. Open AWS Console
2. Navigate to S3
3. Click **Create Bucket**
4. Enter a globally unique bucket name
5. Disable **Block All Public Access**
6. Create Bucket

---

### Step 3: Upload Website Files

1. Open the bucket
2. Click **Upload**
3. Upload `index.html`

---

### Step 4: Enable Static Website Hosting

1. Open Bucket
2. Go to **Properties**
3. Select **Static Website Hosting**
4. Enable Hosting
5. Enter:

```
Index Document: index.html
```

6. Save changes

AWS generates a Website Endpoint URL.

---

### Step 5: Configure Bucket Policy

Grant public read access using Bucket Policy.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::YOUR_BUCKET_NAME/*"
      ]
    }
  ]
}
```

Replace:

```
YOUR_BUCKET_NAME
```

with your bucket name.

---

### Step 6: Create CloudFront Distribution

1. Open CloudFront
2. Click **Create Distribution**
3. Select S3 Website Endpoint as Origin
4. Create Distribution
5. Wait for deployment

CloudFront provides:

```
https://xxxxxxxxxxxx.cloudfront.net
```

---

### Step 7: Verify Website

Open:

```
CloudFront Domain URL
```

Your static website should load successfully.

---

## 🔄 Cache Invalidation

When updating website content:

CloudFront → Distribution → Invalidations

Create Invalidation:

```
/*
```

This clears cached content from edge locations.

---

## 📸 Screenshots

Add screenshots of:

* S3 Bucket Creation
* Static Website Hosting Configuration
* Bucket Policy
* CloudFront Distribution
* Final Website Output

---

## 🎯 Skills Gained

* Amazon S3 Bucket Management
* Static Website Hosting
* S3 Bucket Policies
* CloudFront CDN Configuration
* Cache Invalidation
* Global Content Delivery
* AWS Networking Basics

---

## 📈 Key Learnings

* How S3 stores static website files
* Why bucket policies are required for public access
* How CloudFront improves website performance
* CDN architecture and edge locations
* Cache invalidation process

---

## 💰 AWS Cost

This project can be completed within the AWS Free Tier.

Services Used:

* Amazon S3
* Amazon CloudFront

Estimated Cost:

```
$0 (within Free Tier limits)
```

---

## 📚 Resume Description

Built and deployed a globally distributed static website using Amazon S3 and CloudFront, implementing CDN caching and cache invalidation to improve content delivery performance, availability, and scalability.

---

## 🔗 Future Enhancements

* Add Route 53 Custom Domain
* Enable HTTPS using ACM
* Automate Deployment using GitHub Actions
* Add Monitoring using CloudWatch
* Implement CI/CD Pipeline

---

## 👨‍💻 Author

Rohit Tambadkar

Aspiring DevOps Engineer

AWS | Linux | Docker | Kubernetes | Terraform | Jenkins
t
