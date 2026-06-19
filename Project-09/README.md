# CI/CD Pipeline with AWS

## Project Overview

This project demonstrates how to build a fully automated Continuous Integration and Continuous Deployment (CI/CD) pipeline on AWS. The pipeline automatically deploys website updates to an Amazon S3 static website whenever code changes are pushed to the GitHub repository.

### AWS Services Used

* AWS CodePipeline
* AWS CodeBuild
* Amazon S3
* AWS IAM
* GitHub

---

## Architecture

```text
Developer
    |
    v
GitHub Repository
    |
    v
AWS CodePipeline
    |
    v
AWS CodeBuild
    |
    v
Amazon S3 Static Website Hosting
    |
    v
Live Website
```

---

## Project Goal

Build an automated deployment pipeline that:

* Pulls source code from GitHub
* Builds the project using AWS CodeBuild
* Deploys website files to Amazon S3
* Automatically updates the live website whenever code changes are pushed

---

# Step 1: Create S3 Bucket for Website Hosting

1. Open AWS Console.
2. Navigate to **Amazon S3**.
3. Click **Create Bucket**.

Bucket Name:

```text
awswithrohit.in
```

4. Uncheck:

```text
Block all public access
```

5. Create the bucket.

6. Open the bucket.

7. Navigate to:

```text
Properties → Static Website Hosting
```

8. Enable hosting.

9. Set:

```text
Index document: index.html
```

10. Save changes.

### Website Endpoint

```text
http://awswithrohit.in.s3-website.ap-south-1.amazonaws.com
```

---

# Step 2: Create Website Files

## index.html

```html
<!DOCTYPE html>
<html>
<head>
    <title>CI/CD Demo</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Version 1</h1>
    <p>Deployed via CI/CD Pipeline!</p>
</body>
</html>
```

## style.css

```css
body {
    font-family: Arial, sans-serif;
    text-align: center;
    margin-top: 50px;
}
```

## buildspec.yml

```yaml
version: 0.2

phases:
  build:
    commands:
      - echo "Build completed on `date`"

artifacts:
  files:
    - '**/*'
```

Commit and push the files to GitHub.

---

# Step 3: Connect GitHub with AWS

1. Open AWS CodePipeline Console.
2. Click:

```text
Settings → Connections
```

3. Create a new connection.
4. Select:

```text
GitHub
```

5. Install AWS Connector App on GitHub.
6. Select your repository.
7. Create connection.

Example:

```text
github-connection
```

---

# Step 4: Create AWS CodeBuild Project

Navigate to:

```text
AWS CodeBuild → Create Build Project
```

### Configuration

Project Name:

```text
portfolio-build
```

Source:

```text
GitHub Repository
```

Branch:

```text
main
```

Environment:

```text
Managed Image
Amazon Linux 2
Standard Runtime
```

Buildspec:

```text
Use buildspec.yml from source repository
```

Create the build project.

---

## IAM Permission

Attach S3 access policy to the CodeBuild role:

```text
AmazonS3FullAccess
```

> Note: In production environments, use least-privilege IAM permissions.

---

# Step 5: Create AWS CodePipeline

Navigate to:

```text
AWS CodePipeline → Create Pipeline
```

Pipeline Name:

```text
portfolio-pipeline
```

### Source Stage

Provider:

```text
GitHub
```

Repository:

```text
portfolio-repo
```

Branch:

```text
main
```

### Build Stage

Provider:

```text
AWS CodeBuild
```

Project:

```text
portfolio-build
```

### Deploy Stage

Provider:

```text
Amazon S3
```

Bucket:

```text
awswithrohit.in
```

Create the pipeline.

---

# Testing the Pipeline

After pipeline creation:

1. CodePipeline automatically starts.
2. Monitor all stages.
3. Wait until all stages show:

```text
Succeeded
```

4. Open the S3 website endpoint.

Expected Output:

```text
Version 1
Deployed via CI/CD Pipeline!
```

---

# Trigger Automatic Deployment

Update:

```html
<h1>Version 1</h1>
```

To:

```html
<h1>Version 2</h1>
```

Commit and push:

```bash
git add .
git commit -m "Updated website to Version 2"
git push origin main
```

Pipeline automatically starts.

After successful deployment:

```text
Version 2
Deployed via CI/CD Pipeline!
```

will appear on the live website.

---

# Project Structure

```text
portfolio-repo/
│
├── index.html
├── style.css
├── buildspec.yml
└── README.md
```

---

# Key Learning Outcomes

* Continuous Integration (CI)
* Continuous Deployment (CD)
* AWS CodePipeline
* AWS CodeBuild
* Amazon S3 Static Website Hosting
* GitHub Integration
* IAM Roles and Permissions
* Automated Deployments

---

# Future Enhancements

* Deploy using CloudFront
* Add automated testing stage
* Infrastructure as Code using Terraform

---

## Author

**Rohit Tambadkar**

Aspiring DevOps Engineer | AWS | Terraform | Docker | Kubernetes | CI/CD

GitHub: https://github.com/rohityt0dev/portfolio-repo.git
