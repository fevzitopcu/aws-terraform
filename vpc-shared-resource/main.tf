resource "aws_instance" "name" {
  instance_type = local.workspace["instance_type"]
  ami           = local.workspace["ami"]
  count         = local.workspace["instance_count"]
  
  key_name      = "Fevzi-KeyPair"


    tags = {
    Name        = "${var.project}-${terraform.workspace}-web-server"
    Team        = "${var.team-name}"
    Environment = "${var.environment}"
    Tenant      = "${var.tenant}"
    Workspace   = "${terraform.workspace}"
  }

}