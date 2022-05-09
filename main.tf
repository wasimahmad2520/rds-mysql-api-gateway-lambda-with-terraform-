

#required otherwise circular dependency between IAM and Lambda
locals {
  /* lambda_function_name                  = "${var.project}-${var.lambda_function_name}-${terraform.workspace}" */
lambda_function_name                  = var.lambda_function_name

  dynamodb_tables_count                 = length(var.dynamodb_table_properties)
}

/* provier and region */
provider "aws" {
  region     = "${var.region}"
}


/* Create networking */
module "networking" {
  source    = "./modules/services/networking"
  namespace = var.namespace
}


/* Create NACL */
module "nacl" {
  source    = "./modules/global/nacl"
  namespace = var.namespace
  vpc=  module.networking.vpc
}


/* Create SGR */
module "sgr" {
  source    = "./modules/global/sgr"
  namespace = var.namespace
  vpc=  module.networking.vpc
}


/* Create SSH Key */
module "ssh-key" {
  source    = "./modules/global/ssh-key"
  namespace = var.namespace
}

/* RDS */

module "rds" {
  source    = "./modules/services/rds"
  namespace = var.namespace
  region = var.region
  vpc                                   = module.networking.vpc
  vpc_sgr=module.sgr.vpc_sgr
}

/* Create Ec2 Instances */
module "ec2" {
  source     = "./modules/services/ec2"
  namespace  = var.namespace
  vpc        = module.networking.vpc
  sg_pub_id  = module.networking.sg_pub_id
  sg_priv_id = module.networking.sg_priv_id
  key_name   = module.ssh-key.key_name
  rds=module.rds.rds
}








/* lamdba module */
module "lambda" {
  source                                = "./modules/services/lambda"
  vpc                                   = module.networking.vpc
  sgr_dmz                               = module.sgr.vpc_sgr
  #Setup
  region                                = var.region
  lambda_function_name                  = local.lambda_function_name
  lambda_description                    = var.lambda_description
  lambda_runtime                        = var.lambda_runtime
  lambda_handler                        = var.lambda_handler
  lambda_timeout                        = var.lambda_timeout
  lambda_file_name                      = "script.zip"
  lambda_code_s3_bucket_existing        = var.lambda_code_s3_bucket_existing
  lambda_code_s3_bucket_new             = var.lambda_code_s3_bucket_new
  lambda_code_s3_bucket_use_existing    = var.lambda_code_s3_bucket_use_existing
  lambda_code_s3_key                    = var.lambda_code_s3_key
  lambda_code_s3_storage_class          = var.lambda_code_s3_storage_class
  lambda_code_s3_bucket_visibility      = var.lambda_code_s3_bucket_visibility
  lambda_zip_path                       = var.lambda_zip_path
  lambda_memory_size                    = var.lambda_memory_size
  lambda_vpc_security_group_ids         = var.lambda_vpc_security_group_ids
  lambda_vpc_subnet_ids                 = var.lambda_vpc_subnet_ids
  lambda_layers                         = var.lambda_layers

  #Internal
  lambda_role                           = module.iam.lambda_role_arn

  #Environment variables
  environment_variables                 = var.environment_variables

  #Tags
  tags                                  = var.tags
}


/* API Gateway module */
module "apigw" {
  source                                = "./modules/services/api-gateway"

  #Setup
  api_gw_name                           = "${var.project}-API-Gateway-${terraform.workspace}"
  api_gw_disable_resource_creation      = var.api_gw_disable_resource_creation
  api_gw_endpoint_configuration_type    = var.api_gw_endpoint_configuration_type
  stage_name                            = terraform.workspace
  method                                = var.api_gw_method
  lambda_arn                            = module.lambda.lambda_arn
  region                                = var.region
  lambda_name                           = module.lambda.lambda_name
  dependency_list                       = var.api_gw_dependency_list
}



/* dynamodb module */
/* module "dynamodb" {
  source                                = "./modules/services/dynamodb"

  #Setup
  dynamodb_table_properties             = var.dynamodb_table_properties
  dynamodb_table_attributes             = var.dynamodb_table_attributes
  dynamodb_table_local_secondary_index  = var.dynamodb_table_local_secondary_index
  dynamodb_table_secondary_index        = var.dynamodb_table_secondary_index
  dynamodb_table_ttl                    = var.dynamodb_table_ttl

  #Tags
  tags                                  = var.tags
} */


/* IAM Module */
module "iam" {
  source = "./modules/global/iam"

  #Setup
  lambda_name                           = local.lambda_function_name
  lambda_layers                         = var.lambda_layers
  api_gw_name                           = module.apigw.api_gw_name
  api_gw_id                             = module.apigw.api_gw_id
  /* dynamodb_arn_list                     = module.dynamodb.dynamodb_table_arns
  dynamodb_policy_action_list           = var.dynamodb_policy_action_list
  dynamodb_tables_count                 = local.dynamodb_tables_count */
}