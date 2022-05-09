resource "aws_db_subnet_group" "prod_mariadb" {
    name = "prod-mariadb"
    subnet_ids = [var.vpc.private_subnets[0],var.vpc.private_subnets[1]]
}


resource "aws_db_instance" "db_instance" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "student"
  username             = "wasimahmad"
  password             = "wasimahmad"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  identifier = "prod-mariadb"
  db_subnet_group_name = aws_db_subnet_group.prod_mariadb.name
  vpc_security_group_ids = [var.vpc_sgr.id]

  /* security_group_ids= [var.vpc_sgr.id]
  vpc_id= var.vpc.vpc_id */
   /* provisioner "local-exec" {
    command = "mysql --host=${self.address} --port=${self.port} --user=${self.username} --password=${self.password} < ./schema.sql"
    } */
}

