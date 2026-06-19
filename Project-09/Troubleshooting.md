## Troubleshooting

| Issue                                                      | Solution                                                                                                                                                                                                                                   |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Pipeline says **"Connection failed"**                      | Go to **CodePipeline → Settings → Connections** and verify that your GitHub connection is active. Re-authorize the GitHub app if required.                                                                                                 |
| Build fails with **"buildspec.yml not found"**             | Verify the Buildspec path in CodeBuild settings. Example: `AWS PROJECT/project09/portfolio-repo/buildspec.yml`. The path is case-sensitive.                                                                                                |
| S3 deployment succeeds but website still shows old content | Add `base-directory: "AWS PROJECT/project09/portfolio-repo"` in `buildspec.yml`. Without this, CodeBuild uploads the entire repository structure to S3, causing the website files to be placed inside a folder instead of the bucket root. |
| Pipeline does not trigger after Git push                   | Ensure **"Start the pipeline on source code change"** is enabled in the Source stage. Also verify that the GitHub connection has the necessary webhook permissions.                                                                        |
| Deployment stage fails                                     | Verify that the CodePipeline and CodeBuild IAM roles have permission to access the target S3 bucket.                                                                                                                                       |
| Website returns 404 error                                  | Confirm that `index.html` exists in the root of the S3 bucket and that Static Website Hosting is enabled.                                                                                                                                  |

---

## Best Practices

* Use IAM least-privilege permissions instead of `AmazonS3FullAccess` in production.
* Enable versioning on the S3 bucket.
* Use AWS CloudFront for better performance and caching.
* Store infrastructure as code using Terraform or AWS CloudFormation.
* Add automated testing before deployment.
* Configure monitoring and alerts using Amazon CloudWatch.

---

## Project Outcome

Successfully implemented a complete CI/CD pipeline using AWS services that automatically deploys website updates from GitHub to Amazon S3. Any code change pushed to the repository triggers the pipeline, builds the application, and deploys the latest version without manual intervention.
