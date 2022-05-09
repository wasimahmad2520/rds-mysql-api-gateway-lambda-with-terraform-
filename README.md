# Terraform AWS VPC API Gateway Lambda RDS MySQL

### Terraform module for VPC, EC2, NACL, Security Group, IAM, SSH, AWS API Gateway, Lambda and RDS MySQL 
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)
![stability-stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)
![Commitizen-friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)

## Table of Contents
* [Features](#features)
* [Usage](#usage)
* [Deployment](#deployment)
* [Example](#example)

## Features
Terraform module which deploys a serverless HTTP endpoint in a vpc backed by AWS API Gateway, Lambda & RDS MySQL.
the RDS MySQL database is automated by using ec2.

 
***Attention***

Starting from version v1.1.7, this module targets Terraform v1.1.7+. If you are using Terraform <=v0.11 you must use up to version v1.1.7.

### API Gateway

This module is created with a single stage that is given as parameter.
The default path that is created is `/api/student`. This can be expanded upon as the API GW ID, resources and methods are exposed.
If you do not wish to have the default values, you can specify `api_gw_disable_resource_creation = true` and you can create the paths desired. 
Allows specification of Endpoint Configuration Type via variable `api_gw_endpoint_configuration_type` with `EDGE`, `REGIONAL` or `PRIVATE`. Defaults to `EDGE`


**Note** 

This results in having to create the final `aws_api_gateway_deployment` as well.


### Lambda

This module is created with full customization by user.
- Can use either local filename path `lambda_file_name` or remote S3 bucket configuration.
- Supports Lambda Layers
- Supports VPC

**Must** use either the local filename or S3 option as they are mutually exclusive. 
Exports S3 bucket to allow usage by multiple Lambda's but given `lambda_code_s3_bucket_use_existing=true` it will use existing S3 bucket provided in `lambda_code_s3_bucket_existing`.
- This module by default, if created allows accompanying Lambda access to `dynamodb:PutItem`, `dynamodb:DescribeTable`, `dynamodb:DeleteItem`, `dynamodb:GetItem`, `dynamodb:Scan`, `dynamodb:Query` all DynamoDB tables.


### MySQL

This module is optional. Lambda is created with R/W permission for MySQL to allow Lambda creation of tables or optionally to create them before-hand with this script.
- This module by default, if created allows accompanying Lambda access create, read, update and delete entries in mysql.


## Deployment
1. Run build process to generate Lambda ZIP file locally to match `lambda_zip_path` variable path
2. Provide all needed variables from `variables.tf` file or copy paste and change example below
3. Create/Select Terraform workspace before deployment
4. Run `terraform plan -var-file="<.tfvars file>` to check for any errors and see what will be built
5. Run `terraform apply -var-file="<.tfvars file>` to deploy infrastructure

