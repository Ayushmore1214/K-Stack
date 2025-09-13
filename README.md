

# 3-Tier EKS Application on AWS

This project deploys a complete 3-tier web application onto a managed Kubernetes (EKS) cluster in AWS. The entire infrastructure is provisioned using Terraform.

## Architecture Overview

  * **Infrastructure:** AWS (VPC, EKS, RDS)
  * **Orchestration:** Terraform
  * **Application:** React Frontend, Node.js Backend
  * **Database:** PostgreSQL (AWS RDS)
  * **CI/CD:** GitHub Actions for building Docker images
  * **Access:** AWS Load Balancer  

## Prerequisites

1.  **AWS Account:** With appropriate IAM permissions.
2.  **AWS CLI:** Installed and configured (`aws configure`).
3.  **Terraform:** Installed locally.
4.  **kubectl:** Installed locally.
5.  **GitHub Repository:** A personal GitHub repo with the project code.

## Deployment Steps

### Step 1: Provision the Infrastructure

Navigate to the `terraform/` directory and run the following commands. This will build the VPC, EKS cluster, and RDS database. (This step takes \~20 minutes).

```
cd terraform
terraform init
terraform apply -auto-approve
```

### Step 2: Configure GitHub Actions

The `terraform apply` command will output an IAM Role ARN.

1.  Go to your GitHub repository's `Settings` \> `Secrets and variables` \> `Actions`.
2.  Create a new repository secret named `AWS_IAM_ROLE_ARN` and paste the ARN value.
3.  Go to the AWS IAM Console, find the new `github-actions-role`, and update its "Trust Policy" to allow your GitHub repository to use it.

### Step 3: Run the CI Pipeline

Make a small change to the application code (e.g., in `app/frontend/src/App.js`) and push the commit to your `main` branch.

```
git add .
git commit -m "feat: trigger initial build"
git push
```

This will build your Docker images and push them to ECR.

### Step 4: Deploy the Application

1.  **Configure kubectl:** Connect your terminal to your new EKS cluster.
    ```
    aws eks update-kubeconfig --region ap-south-1 --name titan-cluster
    ```
2.  **Get the new image tags:** Go to the successful GitHub Actions run and find the final image URLs from the "Print New Image Tags" step.
3.  **Update your manifests:** Manually update the `image:` tags in `manifests/02-backend.yaml` and `manifests/03-frontend.yaml` with the new URLs.
4.  **Create the Database Secret:** Get your new database password from Terraform and create the Kubernetes secret.
    ```
    # Get the password
    terraform output -raw db_password

    # Create the secret (paste the new password)
    kubectl create secret generic db-credentials \
      --from-literal=DB_HOST='...' \
      --from-literal=DB_USER='dbadmin' \
      --from-literal=DB_PASSWORD='PASTE_YOUR_NEW_PASSWORD_HERE' \
      --from-literal=DB_NAME=appdb \
      -n app
    ```
5.  **Launch the Application:**
    ```
    kubectl apply -f manifests/
    ```

### Step 5: Access Your Application

Find the public URL of your application's load balancer. (This can take 2-5 minutes to become available).

```
kubectl get ingress/app-ingress -n app
```

## Cleanup

To destroy all the AWS resources created by this project and avoid charges, run the following command from the `terraform/` directory:

```
terraform destroy -auto-approve
```
