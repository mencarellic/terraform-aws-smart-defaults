module "my-test-bucket" {
  source = "./terraform-aws-s3"

  bucket = {
    name = "this-is-a-test-bucket"
  }
}