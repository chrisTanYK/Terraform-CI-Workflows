# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Create Public Subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

# Create Public Subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# Create Security Group
resource "aws_security_group" "ecs_security_group" {
  name        = "ecs_security_group"
  description = "Allow all inbound traffic on ports 5001 and 5002"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5002
    to_port     = 5002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-security-group"
  }
}

# Attach Security Group to ECS Task Definitions
resource "aws_security_group_rule" "ecs_task_sg_rule" {
  type              = "ingress"
  from_port         = 5001
  to_port           = 5001
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_task_sg_rule_2" {
  type              = "ingress"
  from_port         = 5002
  to_port           = 5002
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# ECS Task Definitions (Updated to use the created Security Group)
resource "aws_ecs_task_definition" "s3_service" {
  family                   = "s3-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_configuration {
    assign_public_ip = true
    subnets          = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups  = [aws_security_group.ecs_security_group.id]
  }

  container_definitions = jsonencode([{
    name      = "s3-service"
    image     = aws_ecr_repository.s3_service.repository_url
    essential = true
    portMappings = [
      {
        containerPort = 5001
        hostPort      = 5001
      }
    ],
    environment = [
      { name = "AWS_REGION", value = var.aws_region },
      { name = "BUCKET_NAME", value = var.s3_bucket_name }
    ]
  }])
}

resource "aws_ecs_task_definition" "sqs_service" {
  family                   = "sqs-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_configuration {
    assign_public_ip = true
    subnets          = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups  = [aws_security_group.ecs_security_group.id]
  }

  container_definitions = jsonencode([{
    name      = "sqs-service"
    image     = aws_ecr_repository.sqs_service.repository_url
    essential = true
    portMappings = [
      {
        containerPort = 5002
        hostPort      = 5002
      }
    ],
    environment = [
      { name = "AWS_REGION", value = var.aws_region },
      { name = "QUEUE_URL", value = aws_sqs_queue.this.id }
    ]
  }])
}
