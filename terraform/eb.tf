resource "aws_elastic_beanstalk_application" "default" {
  name        = local.resource_prefix
  description = "Elastic Beanstalk Application for ${local.resource_prefix}"
  tags        = local.common_tags

  # dynamic "appversion_lifecycle" {
  #   for_each = local.appversion_lifecycle_service_role_arn != "" ? ["true"] : []
  #   content {
  #     service_role          = local.appversion_lifecycle_service_role_arn
  #     max_count             = local.appversion_lifecycle_max_count
  #     max_age_in_days       = local.appversion_lifecycle_max_age_in_days
  #     delete_source_from_s3 = var.appversion_lifecycle_delete_source_from_s3
  #   }
  # }
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = var.artifact_version
  application = "papercortex-prod-planner-api"
  description = "Version 0.0.0 of the planner-api application"
  bucket      = "papercortex-prod-planner-api-artifacts"
  key         = "${var.artifact_version}.zip"
}

#
# Full list of options:
# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkmanagedactionsplatformupdate
#
resource "aws_elastic_beanstalk_environment" "default" {
  name                = local.resource_prefix
  application         = aws_elastic_beanstalk_application.default.name
  description         = "Elastic Beanstalk Environment for ${local.resource_prefix}"
  tier                = "WebServer"
  solution_stack_name = "64bit Amazon Linux 2023 v6.1.1 running Node.js 20 "
  version_label       = aws_elastic_beanstalk_application_version.default.name
  tags                = local.common_tags

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2.name
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.service.name
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t2.micro"
    resource  = ""
  }

  ###=========================== Autoscale trigger ========================== ###

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = "Average"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = 20
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerBreachScaleIncrement"
    value     = -1
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = 80
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperBreachScaleIncrement"
    value     = 1
    resource  = ""
  }

  # Add environment variables if provided
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MONGODB_URI"
    value     = local.connection_string
  }

  dynamic "setting" {
    for_each = var.env_vars
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
      resource  = ""
    }
  }
}

