
/* 
data "template_file" "lambda_dynamodb_policy" {
  count                                                 = var.dynamodb_tables_count > 0 ? 1 : 0
  template                                              = file("${path.module}/dynamodb-policy.json")
  vars                                                  = {
    policy_arn_list                                     = join(", ", formatlist("\"%s\"", var.dynamodb_arn_list))
    policy_action_list                                  = join(", ", formatlist("\"%s\"", var.dynamodb_policy_action_list))
  }
}


 */

/* resource "aws_iam_role_policy" "DynamoDB-Policy" {
  count                                                 = var.dynamodb_tables_count > 0 ? 1 : 0
  name                                                  = "${aws_iam_role.lambda-role.name}-Policy"
  role                                                  = aws_iam_role.lambda-role.id
  policy                                                = data.template_file.lambda_dynamodb_policy.rendered
  /* policy =                                                data.template_file.lambda_dynamodb_policy[count.index] */

/* } */ 


#LAMBDA
resource "aws_iam_role" "lambda-role" {
  /* name = "${var.lambda_name}-role" */
  assume_role_policy = file("${path.module}/lambda-role.json")
}


/* child 1:- to access dynamodb */ 
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda-role.id
  policy = file("${path.module}/new-dynamodb-policy.json")
}

/* child 2:- to be place in vpc */
resource "aws_iam_role_policy" "lambda_vpc_policy" {
  name = "lambda_vpc_policy"
  role = aws_iam_role.lambda-role.id
  policy = file("${path.module}/lambda-in-vpc-role.json")
}






data "template_file" "lambda_layer_policy" {
  count                                                 = length(var.lambda_layers) > 0 ? 1 : 0
  template                                              = file("${path.module}/dynamodb-policy.json")
  vars = {
    policy_arn_list                                     = join(
                                                            ", ",
                                                            formatlist(
                                                              "\"%s\"",
                                                              var.lambda_layers
                                                              ),
                                                            )
    policy_action_list                                  = join(
                                                            ", ",
                                                            formatlist(
                                                              "\"%s\"",
                                                              [
                                                                "lambda:GetLayerVersion"
                                                              ]
                                                              )
                                                            )
  }
}

resource "aws_iam_role_policy" "Layer-Policy" {
  count                                                 = length(var.lambda_layers) > 0 ? 1 : 0
  name                                                  = "${aws_iam_role.lambda-role.name}-Layer-Policy"
  role                                                  = aws_iam_role.lambda-role.id
  policy                                                = data.template_file.lambda_layer_policy[count.index]
}


#API GW
resource "aws_iam_role" "apigw-role" {
  /* name                                                  = "${var.api_gw_name}-role" */
  assume_role_policy                                    = file("${path.module}/apigw-role.json")
}

resource "aws_iam_role_policy_attachment" "Lambda-CloudWatch-Logs-ReadWrite" {
  policy_arn                                            = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role                                                  = aws_iam_role.lambda-role.name
}

resource "aws_iam_role_policy_attachment" "API-GW-CloudWatch-Logs-ReadWrite" {
  policy_arn                                            = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role                                                  = aws_iam_role.apigw-role.name
}