## Infrastructure Diagram

Here’s the current Terraform-provisioned architecture:

```mermaid
graph LR
  subgraph CI/CD
    A["GitHub Actions\n(push to main)"] -->|terraform apply| B[Terraform]
  end

  subgraph AWS
    B --> VPC[VPC\n(10.0.0.0/16)]
    B --> ECR[ECR Repository]
    B --> IAM[IAM Roles & Policies]
    B --> ECS[ECS Cluster\n(Fargate)]
    B --> CW[CloudWatch]

    VPC --> Subnets[Public & Private Subnets]
    VPC --> SG[Security Group]

    ECS --> TaskDef[ECS Task Definition]
    TaskDef --> Service[ECS Service]
    Service --> Subnets
    Service --> SG
    Service --> CWLogGroup[Log Group]

    CW --> CWLogGroup
    CW --> Alarms[Metric Alarms]
  end

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

