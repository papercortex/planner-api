provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.15.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-papercortex"
    key    = "planner-api/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "mongodbatlas" {
  public_key  = var.mongodbatlas_public_key
  private_key = var.mongodbatlas_private_key
}


# module "vpc" {
#   source  = "cloudposse/vpc/aws"
#   version = "2.2.0"

#   namespace = local.namespace
#   stage     = local.stage
#   name      = local.name
#   tags      = local.common_tags

#   ipv4_primary_cidr_block = "172.16.0.0/16"
# }

# module "subnets" {
#   source  = "cloudposse/dynamic-subnets/aws"
#   version = "2.4.2"

#   namespace = local.namespace
#   stage     = local.stage
#   name      = local.name
#   tags      = local.common_tags

#   availability_zones   = var.availability_zones
#   vpc_id               = module.vpc.vpc_id
#   igw_id               = [module.vpc.igw_id]
#   ipv4_enabled         = true
#   ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
#   nat_gateway_enabled  = true
#   nat_instance_enabled = false
# }

# module "elastic_beanstalk_application" {
#   source  = "cloudposse/elastic-beanstalk-application/aws"
#   version = "0.12.0"

#   description = "PaperCortex planner-api service"

#   namespace = local.namespace
#   stage     = local.stage
#   name      = local.name
#   tags      = local.common_tags
# }

# module "elastic_beanstalk_environment" {
#   source  = "cloudposse/elastic-beanstalk-environment/aws"
#   version = "0.51.2"

#   description                = var.description
#   region                     = var.region
#   availability_zone_selector = var.availability_zone_selector
#   dns_zone_id                = var.dns_zone_id

#   wait_for_ready_timeout             = var.wait_for_ready_timeout
#   elastic_beanstalk_application_name = module.elastic_beanstalk_application.elastic_beanstalk_application_name
#   environment_type                   = var.environment_type
#   loadbalancer_type                  = var.loadbalancer_type
#   elb_scheme                         = var.elb_scheme
#   tier                               = var.tier
#   version_label                      = var.artifact_version
#   force_destroy                      = var.force_destroy

#   instance_type    = var.instance_type
#   root_volume_size = var.root_volume_size
#   root_volume_type = var.root_volume_type

#   autoscale_min             = var.autoscale_min
#   autoscale_max             = var.autoscale_max
#   autoscale_measure_name    = var.autoscale_measure_name
#   autoscale_statistic       = var.autoscale_statistic
#   autoscale_unit            = var.autoscale_unit
#   autoscale_lower_bound     = var.autoscale_lower_bound
#   autoscale_lower_increment = var.autoscale_lower_increment
#   autoscale_upper_bound     = var.autoscale_upper_bound
#   autoscale_upper_increment = var.autoscale_upper_increment

#   vpc_id                              = module.vpc.vpc_id
#   loadbalancer_subnets                = module.subnets.public_subnet_ids
#   loadbalancer_redirect_http_to_https = true
#   application_subnets                 = module.subnets.private_subnet_ids

#   allow_all_egress = true

#   additional_security_group_rules = [
#     {
#       type                     = "ingress"
#       from_port                = 0
#       to_port                  = 65535
#       protocol                 = "-1"
#       source_security_group_id = module.vpc.vpc_default_security_group_id
#       description              = "Allow all inbound traffic from trusted Security Groups"
#     }
#   ]

#   rolling_update_enabled  = var.rolling_update_enabled
#   rolling_update_type     = var.rolling_update_type
#   updating_min_in_service = var.updating_min_in_service
#   updating_max_batch      = var.updating_max_batch

#   healthcheck_url  = var.healthcheck_url
#   application_port = var.application_port

#   # https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
#   # https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
#   solution_stack_name = var.solution_stack_name

#   additional_settings = [{
#     name      = "SourceBundle"
#     namespace = "aws:elasticbeanstalk:application:version"
#     value     = "${aws_s3_bucket.app_artifacts.bucket}/${var.artifact_version}.zip"
#   }]

#   env_vars = var.env_vars

#   extended_ec2_policy_document = data.aws_iam_policy_document.minimal_s3_permissions.json
#   prefer_legacy_ssm_policy     = false
#   prefer_legacy_service_policy = false
#   scheduled_actions            = var.scheduled_actions

#   s3_bucket_versioning_enabled = var.s3_bucket_versioning_enabled
#   enable_loadbalancer_logs     = var.enable_loadbalancer_logs

#   namespace = local.namespace
#   stage     = local.stage
#   name      = local.name
#   tags      = local.common_tags
# }

# data "aws_iam_policy_document" "minimal_s3_permissions" {
#   statement {
#     sid = "AllowS3OperationsOnElasticBeanstalkBuckets"
#     actions = [
#       "s3:ListAllMyBuckets",
#       "s3:GetBucketLocation"
#     ]
#     resources = ["*"]
#   }
# }
