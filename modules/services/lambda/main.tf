# First, we need a role to play with Lambda
/* resource "aws_iam_role" "iam_role_for_lambda" {
  name = "iam_role_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
} */

locals {
  s3_bucket                   = var.lambda_code_s3_bucket_use_existing ? var.lambda_code_s3_bucket_existing : join("", aws_s3_bucket.lambda_repo.*.bucket)
}

resource "aws_lambda_function" "lambda_file" {
  /* count                       = var.lambda_file_name == "defaultLambdaFile.zip" ? 0 : 1 */
  function_name               = var.lambda_function_name
  filename                    = var.lambda_file_name
  description                 = var.lambda_description
  runtime                     = var.lambda_runtime
  handler                     = var.lambda_handler
  role                        = var.lambda_role
  /* role    = "${aws_iam_role.iam_role_for_lambda.arn}" */
  timeout                     = var.lambda_timeout
  /* source_code_hash            = filebase(file(var.lambda_file_name)) */
  memory_size                 = var.lambda_memory_size
  /* layers                      = var.lambda_layers */

  /* vpc_config {
    security_group_ids        = var.lambda_vpc_security_group_ids
    subnet_ids                = var.lambda_vpc_subnet_ids
  }
*/
  environment {
    variables                 = var.environment_variables
  } 

  tags                        = var.tags
}


/* loading script from s3, for now we are loading from file */
resource "aws_lambda_function" "lambda_s3" {
  count                       = var.lambda_file_name == "defaultLambdaFile.zip" && (var.lambda_code_s3_bucket_existing != "defaultBucket" || var.lambda_code_s3_bucket_new != "defaultBucket") ? 1: 0
  function_name               = var.lambda_function_name
  description                 = var.lambda_description
  runtime                     = var.lambda_runtime
  handler                     = var.lambda_handler
  role                        = var.lambda_role
   /* role    = "${aws_iam_role.iam_role_for_lambda.arn}" */
  timeout                     = var.lambda_timeout
  /* source_code_hash            = aws_s3_bucket_object.lambda_dist.etag */
  source_code_hash= aws_s3_bucket_object.lambda_dist[count.index]
  s3_bucket                   = local.s3_bucket
  s3_key                      = var.lambda_code_s3_key
  memory_size                 = var.lambda_memory_size
  layers                      = var.lambda_layers

  vpc_config {
    security_group_ids        = var.lambda_vpc_security_group_ids
    subnet_ids                = var.lambda_vpc_subnet_ids
  }

  environment {
    variables                 = var.environment_variables
  }

  tags                        = var.tags
}

resource "aws_s3_bucket" "lambda_repo" {
  count                       = var.lambda_file_name == "defaultLambdaFile.zip" && var.lambda_code_s3_bucket_existing == "defaultBucket" && var.lambda_code_s3_bucket_new != "defaultBucket" ? 1 : 0
  bucket                      = var.lambda_code_s3_bucket_new
  /* region                      = var.region */
  acl                         = var.lambda_code_s3_bucket_visibility
  tags                        = var.tags
}

resource "aws_s3_bucket_object" "lambda_dist" {
  count                       = var.lambda_file_name == "defaultLambdaFile.zip" && (var.lambda_code_s3_bucket_existing != "defaultBucket" || var.lambda_code_s3_bucket_new != "defaultBucket") ? 1 : 0
  bucket                      = local.s3_bucket
  key                         = var.lambda_code_s3_key
  source                      = var.lambda_zip_path
  etag                        = md5(file(var.lambda_zip_path))
  storage_class               = var.lambda_code_s3_storage_class
}