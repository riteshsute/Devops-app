module "ebs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.0"

  name = "devops-ebs-csi-driver"

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = {
    Project     = "DEVOPS"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}


resource "aws_iam_role" "ebs_csi_pod_identity_role" {
  name = "devops-ebs-csi-pod-identity"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = {
    Project     = "DEVOPS"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "ebs_csi_pod_identity_policy" {
  role = aws_iam_role.ebs_csi_pod_identity_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.25.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  endpoint_public_access  = true
  endpoint_private_access = true

  enable_irsa = true

  vpc_id = aws_vpc.devops_vpc.id
  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  enable_cluster_creator_admin_permissions = true

  addons = {
    coredns = {
      most_recent    = true
      before_compute = true
    }

    kube-proxy = {
      most_recent    = true
      before_compute = true
    }

    vpc-cni = {
      most_recent    = true
      before_compute = true
    }

    eks-pod-identity-agent = {
      most_recent    = true
      before_compute = true
    }

    aws-ebs-csi-driver = {
      most_recent    = true
      before_compute = true
      pod_identity_association = [
        {
          role_arn        = aws_iam_role.ebs_csi_pod_identity_role.arn
          service_account = "ebs-csi-controller-sa"
        }
      ]
    }
  }

  eks_managed_node_groups = {
    devops_nodes = {

      name = "devops-node-group"

      instance_types = [var.node_instance_type]

      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      subnet_ids = [
        aws_subnet.public_subnet_1.id,
        aws_subnet.public_subnet_2.id
      ]

      capacity_type = "ON_DEMAND"

      labels = {
        Environment = "dev"
        Project     = "DEVOPS"
      }

      tags = {
        Name = "devops-eks-node"
      }
    }
  }


  tags = {
    Project     = "DEVOPS"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}