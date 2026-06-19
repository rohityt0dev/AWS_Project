Issue	Solution
Pipeline says "Connection failed"	Go to CodePipeline → Settings → Connections, check if your GitHub connection is active. You may need to re-authorize the GitHub app.
Build fails with "buildspec.yml not found"	Double-check the buildspec path in CodeBuild settings: AWS PROJECT/project09/portfolio-repo/buildspec.yml (case-sensitive!).
S3 deploy works but website shows old content	Ensure you added base-directory: "AWS PROJECT/project09/portfolio-repo" in your buildspec.yml. Without this, CodeBuild packages the entire repo (including the folder structure), and S3 ends up with a folder inside it, breaking the website.
Pipeline doesn't trigger on Git push	In the Source stage, make sure "Start the pipeline on source code change" is checked. Also, ensure your GitHub connection has the correct permissions for webhooks.
