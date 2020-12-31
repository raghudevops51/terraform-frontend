bucket  = "rb-b51-dev"
key     = "nginx/dev/terraform.tfstate"
ENV     = "dev"
INSTANCE_TYPE = "t3.small"
KEY_NAME      = "devops"
BACKEND_COMPONENTS = ["catalogue", "cart", "shipping", "payment", "user"]