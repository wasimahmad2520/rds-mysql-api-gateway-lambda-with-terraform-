resource "aws_dynamodb_table" "table" {
  /* count                       = length(var.dynamodb_table_properties) */
  name                        = "advanced_student"
  billing_mode                = "PROVISIONED"
  /* read_capacity               = lookup(var.dynamodb_table_properties[count.index], "read_capacity", "1") */
  /* write_capacity              = lookup(var.dynamodb_table_properties[count.index], "write_capacity", "1") */
  read_capacity = 5
  write_capacity = 5
  /* hash_key                    = lookup(var.dynamodb_table_properties[count.index], "hash_key") */
  /* range_key                   = lookup(var.dynamodb_table_properties[count.index], "range_key", "") */
  /* stream_enabled              = lookup(var.dynamodb_table_properties[count.index], "stream_enabled", "") */
  /* stream_view_type            = lookup(var.dynamodb_table_properties[count.index], "stream_view_type", "") */
  /* attribute                   = var.dynamodb_table_attributes[count.index] */
  hash_key       = "id"
  /* range_key      = "roll_number" */

  attribute {
    name = "id"
    type = "S"
  }

/*  
  attribute {
    name = "roll_number"
    type = "N"
  } */


  /* local_secondary_index       = var.dynamodb_table_local_secondary_index[count.index] */
 global_secondary_index {
    name               = "id_index"
    hash_key           = "id"
    /* range_key          = "roll_number" */
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["id"]
  }


  /* global_secondary_index      = var.dynamodb_table_secondary_index[count.index] */
  /* ttl                         = var.dynamodb_table_ttl[count.index] */
   ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }
  tags                        = var.tags
}