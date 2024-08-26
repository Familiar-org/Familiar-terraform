# Local Variables
locals {
  lb_listener = {
    80 = "${aws_lb_target_group.backend_app_80.arn}",
    8080 = "${aws_lb_target_group.backend_app_8080.arn}"
  }

  ecs_service_load_balancer = {
    http = {
      container_name = "http",
      container_port = 80,
      target_group_arn = "${aws_lb_target_group.backend_app_80.arn}"
    },
    was = {
      container_name = "was",
      container_port = 8080,
      target_group_arn = "${aws_lb_target_group.backend_app_8080.arn}"
    }
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "backend" {
  name = "${var.prefix}-ecs-cluster-backend"
}

data "aws_iam_policy_document" "backend_node_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow" 
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "backend_node" {
  name        = "Ecs_Backend_Node_Role"
  assume_role_policy = data.aws_iam_policy_document.backend_node_assume.json
}

resource "aws_iam_role_policy_attachment" "backend_node" {
  role       = aws_iam_role.backend_node.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


resource "aws_iam_instance_profile" "backend_node" {
  name = "${var.prefix}-backend-node-instance-profile"
  role = aws_iam_role.backend_node.name
}


resource "aws_ecs_cluster_capacity_providers" "backend_node" {
  cluster_name = aws_ecs_cluster.backend.name
}

data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id" 
}

resource "aws_launch_template" "ecs_ec2" {
  name = "${var.prefix}-ecs-node-launch-template"
  image_id               = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type          = var.backend_node_instance_type
  vpc_security_group_ids = [aws_security_group.backend.id]

  iam_instance_profile { arn = aws_iam_instance_profile.backend_node.arn }
  monitoring { enabled = true }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${aws_ecs_cluster.backend.name} >> /etc/ecs/ecs.config;
    EOF
  )
}

resource "aws_autoscaling_group" "ecs" {
  name = "${var.prefix}-ecs-asg"
  vpc_zone_identifier       = var.pub_subnet_ids
  min_size                  = var.ecs_backend_min_asg_size
  max_size                  = var.ecs_backend_max_asg_size
  
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false

  launch_template {
    id      = aws_launch_template.ecs_ec2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-ecs-asg"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "backend" {
  name = "${var.prefix}-ecs-backend-capa-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }

  tags = {
    Name = "${var.prefix}-ecs-backend-capa-provider"
  }
}

resource "aws_ecs_cluster_capacity_providers" "backend_providers" {
  cluster_name       = aws_ecs_cluster.backend.name
  capacity_providers = [aws_ecs_capacity_provider.backend.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.backend.name
    base              = 1
    weight            = 100
  }
}

# ECS Task Role

data "aws_iam_policy_document" "ecs_task_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name        = "${var.prefix}-backend-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
}

resource "aws_iam_role" "ecs_exec_role" {
  name        = "${var.prefix}-backend-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_exec_role_policy" {
  role       = aws_iam_role.ecs_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# Task definition

resource "aws_ecs_task_definition" "backend" {
  family             = "backend-app"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_exec_role.arn
  network_mode       = "awsvpc"
  cpu                = 1024
  memory             = 2048
  requires_compatibilities = ["EC2"]

  container_definitions = jsonencode([{
    name         = "backend-app",
    image        = "${aws_ecr_repository.backend.repository_url}:latest",
    essential    = true,
    portMappings = [
        { containerPort = 80, hostPort = 80 },
        { containerPort = 8080, hostPort = 8080 }
      ],

    environment = [
    ],

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-region"        = "us-east-1",
        "awslogs-group"         = "${aws_cloudwatch_log_group.backend.name}",
        "awslogs-stream-prefix" = "${var.prefix}-backend-app"
      }
    }
  }])
}

# CloudFront Managed Prefix IP List

data "aws_ec2_managed_prefix_list" "cloudfront" {
 name = "com.amazonaws.global.cloudfront.origin-facing"
}

# Application Load Balancer

resource "aws_security_group" "backend" {
  name = "${var.prefix}-sg-backend-node"
  description = "Allow Web traffic from cloudfront"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [80, 8080]
    content {
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront.id]
    }
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_lb" "backend" {
  name               = "${var.prefix}-alb-backend"
  load_balancer_type = "application"
  subnets            = var.pub_subnet_ids
  security_groups    = [aws_security_group.backend.id]
}

resource "aws_lb_target_group" "backend_app_80" {
  name = "backend-app-80-80"
  vpc_id      = var.vpc_id
  protocol    = "HTTP"
  port        = 80
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/actuator/health"
    port                = 80
    matcher             = 200
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "backend_app_8080" {
  name = "backend-app-8080-8080"
  vpc_id      = var.vpc_id
  protocol    = "HTTP"
  port        = 8080
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/actuator/health"
    port                = 8080
    matcher             = 200
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "backend_app" {
  for_each = local.lb_listener
  
  load_balancer_arn = aws_lb.backend.id
  port              = each.key
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = each.value
  }
}

resource "aws_ecs_service" "backend_app" {
  name            = "${var.prefix}-backend-app"
  cluster         = aws_ecs_cluster.backend.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 2

  network_configuration {
    security_groups = [aws_security_group.backend]
    subnets         = var.pub_subnet_ids
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.backend.name
    base              = 1
    weight            = 100
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
  
  depends_on = [aws_lb_target_group.backend_app_80, aws_lb_target_group.backend_app_8080]

  dynamic "load_balancer" {
    for_each = local.ecs_service_load_balancer
    content {
      container_name = load_balancer.value["container_name"]
      container_port = load_balancer.value["container_port"]
      target_group_arn = load_balancer.value["target_group_arn"]
    }
  }
}


# CloudWatch Log Group

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/${var.prefix}/ecs/backend-app"
  retention_in_days = 14
}

# ECR

resource "aws_ecr_repository" "backend" {
  name                 = "${var.prefix}-repo-backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

