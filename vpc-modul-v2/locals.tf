locals {
   env = {
      default = {
         instance_type  = "t2.micro"
         ami            = "ami-0ff8a91507f77f867"
         instance_count = 1
      }
      dev = {
         instance_type  = "t3.micro"
         ami            = "ami-02b972fec07f1e659"
      }
      qa = {
         instance_type  = "m5.2xlarge"
         ami            = "ami-00f0abdef923519b0"
         instance_count = 3
      }
      prod = {
         instance_type  = "c5.4xlarge"
         ami            = "ami-0422d936d535c63b1"
         instance_count = 6
      }
   }
   environmentvars = "${contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"}"
   workspace       = "${merge(local.env["default"], local.env[local.environmentvars])}"
}   