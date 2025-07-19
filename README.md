#mcp-infra
## Infrastructure Diagram (plain text)

CI/CD
└─ GitHub Actions (on push to main)
    └─ runs: `terraform apply` in `infra/`

Terraform (`infra/`)
└─ AWS Provider
    ├─ VPC (10.0.0.0/16)
    │   ├─ Public Subnets
    │   │   ├─ 10.0.1.0/24 (AZ1)
    │   │   └─ 10.0.2.0/24 (AZ2)
    │   └─ Private Subnets
    │       ├─ 10.0.101.0/24 (AZ1)
    │       └─ 10.0.102.0/24 (AZ2)
    ├─ Security Group (SSH, HTTP/80, HTTPS/443)
    ├─ ECR Repository (`mcp-app`)
    ├─ IAM Roles & Policies (Fargate task role, CloudWatch access)
    ├─ ECS Cluster (Fargate)
    │   └─ ECS Service → Task Definition → Container
    └─ CloudWatch
        ├─ Log Group (`/ecs/mcp`)
        └─ Metric Alarms (error rate, latency, etc.)


## Completed Steps

1. **Terraform setup**
   - Initialized Terraform in `infra/`
   - Configured AWS provider (`provider.tf`, `variables.tf`)

2. **Network provisioning**
   - VPC: 10.0.0.0/16 (`vpc.tf`)
   - Public subnets: 10.0.1.0/24, 10.0.2.0/24
   - Private subnets: 10.0.101.0/24, 10.0.102.0/24 (`subnets.tf`)

3. **Security group**
   - SSH locked to my IP
   - HTTP (80) & HTTPS (443) open to world
   - Dynamic IP fetch via `data.external.my_ip` (`security_groups.tf`)

4. **Next steps remaining**
   - Create ECR repository
   - Define ECS cluster & service
   - Set up CI/CD pipeline
   - Configure CloudWatch logging & alarms

