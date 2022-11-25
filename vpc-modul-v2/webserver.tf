resource "aws_instance" "web-server" {
  instance_type = local.workspace["instance_type"]
  ami           = local.workspace["ami"]
  
  key_name      = "Fevzi-KeyPair"

  subnet_id              = aws_subnet.public-subnets[0].id
  vpc_security_group_ids = [aws_security_group.vpc-security-group.id]

    tags = {
    Name        = "${var.project}-${terraform.workspace}-web-server"
    Team        = "${var.team-name}"
    Environment = "${var.environment}"
    Tenant      = "${var.tenant}"
    Workspace   = "${terraform.workspace}"
  }
}
