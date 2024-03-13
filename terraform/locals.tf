data "aws_partition" "current" {
}

locals {
  app_name = "planner-api"

  resource_prefix = "${var.project_name}-${var.environment}-${local.app_name}"
  partition       = data.aws_partition.current.partition
  # Whether to use AWSElasticBeanstalkService (deprecated) or AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy policy
  prefer_legacy_service_policy = true
  # Whether to use AmazonEC2RoleforSSM (will soon be deprecated) or AmazonSSMManagedInstanceCore policy
  prefer_legacy_ssm_policy = true

  db_name           = "${var.project_name}-${var.environment}-${local.app_name}"
  initial_url       = mongodbatlas_cluster.pc_planner.connection_strings[0].standard_srv
  stripped_url      = replace(local.initial_url, "mongodb+srv://", "")
  connection_string = "mongodb+srv://${var.mongodbatlas_planner_api_username}:${var.mongodbatlas_planner_api_password}@${local.stripped_url}/${local.db_name}?retryWrites=true&w=majority&appName=${local.db_name}"

  common_tags = {
    Project        = var.project_name
    AppName        = local.app_name
    Environment    = var.environment
    ManagedBy      = "Terraform"
    awsApplication = var.application_arn
  }
}
