#
# Service
#
data "aws_iam_policy_document" "service" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "service" {
  name               = "${local.resource_prefix}-eb-service"
  assume_role_policy = data.aws_iam_policy_document.service.json
  tags               = local.common_tags
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = aws_iam_role.service.name
  policy_arn = local.prefer_legacy_service_policy ? "arn:${local.partition}:iam::aws:policy/service-role/AWSElasticBeanstalkService" : "arn:${local.partition}:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
}

#
# EC2
#
data "aws_iam_policy_document" "ec2" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }

  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_multi_container_docker" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role" "ec2" {
  name               = "${local.resource_prefix}-eb-ec2"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
  tags               = local.common_tags
}

resource "aws_iam_role_policy" "default" {
  name   = "${local.resource_prefix}-eb-default"
  role   = aws_iam_role.ec2.id
  policy = data.aws_iam_policy_document.extended.json
}

resource "aws_iam_role_policy_attachment" "web_tier" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "worker_tier" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "ssm_ec2" {
  role       = aws_iam_role.ec2.name
  policy_arn = local.prefer_legacy_ssm_policy ? "arn:${local.partition}:iam::aws:policy/service-role/AmazonEC2RoleforSSM" : "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "ssm_automation" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/service-role/AmazonSSMAutomationRole"

  lifecycle {
    create_before_destroy = true
  }
}

# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker.container.console.html
# http://docs.aws.amazon.com/AmazonECR/latest/userguide/ecr_managed_policies.html#AmazonEC2ContainerRegistryReadOnly
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:${local.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy_document" "default" {
  statement {
    actions = [
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetHealth",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:GetConsoleOutput",
      "ec2:AssociateAddress",
      "ec2:DescribeAddresses",
      "ec2:DescribeSecurityGroups",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeNotificationConfigurations",
    ]

    resources = ["*"]

    effect = "Allow"
  }

  statement {
    sid = "AllowOperations"

    actions = [
      "autoscaling:AttachInstances",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:DeleteLaunchConfiguration",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteScheduledAction",
      "autoscaling:DescribeAccountLimits",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeLoadBalancers",
      "autoscaling:DescribeNotificationConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeScheduledActions",
      "autoscaling:DetachInstances",
      "autoscaling:PutScheduledUpdateGroupAction",
      "autoscaling:ResumeProcesses",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:SetInstanceProtection",
      "autoscaling:SuspendProcesses",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
      "cloudwatch:PutMetricAlarm",
      "ec2:AssociateAddress",
      "ec2:AllocateAddress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DisassociateAddress",
      "ec2:ReleaseAddress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:TerminateInstances",
      "ecs:CreateCluster",
      "ecs:DeleteCluster",
      "ecs:DescribeClusters",
      "ecs:RegisterTaskDefinition",
      "elasticbeanstalk:*",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "iam:ListRoles",
      "logs:CreateLogGroup",
      "logs:PutRetentionPolicy",
      "rds:DescribeDBEngineVersions",
      "rds:DescribeDBInstances",
      "rds:DescribeOrderableDBInstanceOptions",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "sns:CreateTopic",
      "sns:GetTopicAttributes",
      "sns:ListSubscriptionsByTopic",
      "sns:Subscribe",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "codebuild:CreateProject",
      "codebuild:DeleteProject",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]

    effect = "Allow"
  }

  statement {
    sid = "AllowPassRole"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      aws_iam_role.ec2.arn,
      aws_iam_role.service.arn
    ]

    effect = "Allow"
  }

  statement {
    sid = "AllowS3OperationsOnElasticBeanstalkBuckets"

    actions = [
      "s3:*"
    ]

    resources = [
      #bridgecrew:skip=BC_AWS_IAM_57:Skipping "Ensure IAM policies does not allow write access without constraint"
      #bridgecrew:skip=BC_AWS_IAM_56:Skipping "Ensure IAM policies do not allow permissions management / resource exposure without constraint"
      #bridgecrew:skip=BC_AWS_IAM_55:Skipping "Ensure IAM policies do not allow data exfiltration"
      "arn:${local.partition}:s3:::*"
    ]

    effect = "Allow"
  }

  statement {
    sid = "AllowDeleteCloudwatchLogGroups"

    actions = [
      "logs:DeleteLogGroup"
    ]

    resources = [
      "arn:${local.partition}:logs:*:*:log-group:/aws/elasticbeanstalk*"
    ]

    effect = "Allow"
  }

  statement {
    sid = "AllowCloudformationOperationsOnElasticBeanstalkStacks"

    actions = [
      "cloudformation:*"
    ]

    resources = [
      "arn:${local.partition}:cloudformation:*:*:stack/awseb-*",
      "arn:${local.partition}:cloudformation:*:*:stack/eb-*"
    ]

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "extended" {
  source_policy_documents   = [data.aws_iam_policy_document.default.json]
  override_policy_documents = [""]
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${local.resource_prefix}-eb-ec2"
  role = aws_iam_role.ec2.name
  tags = local.common_tags
}
