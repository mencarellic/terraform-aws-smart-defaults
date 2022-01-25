module "s3_test" {
  source = "./terraform-aws-s3"

  bucket = {
    name = "test-bucket"
  }
}