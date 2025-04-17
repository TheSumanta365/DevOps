provider "aws" {  
  region = "us-east-1"  
}  

# VPC Creation 
resource "aws_vpc" "main" {  
  cidr_block = "10.0.0.0/16"  
  tags = {  
    Name = "Project-VPC"  
  }  
}  

#  Public Subnet Creation
resource "aws_subnet" "public" {  
  vpc_id     = aws_vpc.main.id  
  cidr_block = "10.0.1.0/24"  
  availability_zone = "us-east-1a"  
  tags = {  
    Name = "Public-Subnet"  
  }  
}  

# Creation of EC2 Instance  
resource "aws_instance" "web_server" {  
  ami           = "ami-07a6f770277670015" # (Amazon Linux 2) 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id  
  tags = {  
    Name = "Terraform-EC2"  
  }  
}  
 # S3 Bucket Creation
resource "aws_s3_bucket" "data_bucket" {  
  bucket = "terraform-bucket-17042025"   
  tags = {  
    Name = "Terraform-S3-Bucket"  
  }  
}  

# CloudWatch Alarm Creation(CPU Utilization)  
resource "aws_cloudwatch_metric_alarm" "high_cpu" {  
  alarm_name          = "EC2-High-CPU"  
  comparison_operator = "GreaterThanOrEqualToThreshold"  
  evaluation_periods  = "2"  
  metric_name         = "CPUUtilization"  
  namespace           = "AWS/EC2"  
  period              = "120"  
  statistic           = "Average"  
  threshold           = "70"  
  alarm_description   = "Alert if CPU > 70% for 2 periods"  
  dimensions = {  
    InstanceId = aws_instance.web_server.id  
  }  
}  