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
