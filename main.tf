# Configure the AWS provider with your AWS access and secret keys
provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

# Define the EC2 instance resource
resource "aws_instance" "example" {
  ami           = "ami-079db87dc4c10ac91" 
  instance_type = "t2.micro"
  tags = {
    Name = "MyEC2Instance"  # Replace with your desired instance name
  }
}

resource "aws_instance" "example1" {
  ami           = "ami-079db87dc4c10ac91" 
  instance_type = "t3.medium"
  tags = {
    Name = "Tagging-instance"  # Replace with your desired instance name
  }
}
