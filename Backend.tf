terraform {
  backend "s3" {
    bucket         = "jenkins-buck.1"   
    key            = "my-terraform-environment/main"
    region         = "us-east-1"
    dynamodb_table = "jenkins-db2"
  }
}
