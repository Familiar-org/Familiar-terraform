resource "aws_ecs_cluster" "backend" {
  name = var.ecs_cluster_name
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
  assume_role_policy = data.aws_iam_policy_document.backend_node_assume
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
  instance_type          = var.node_instance_type
  vpc_security_group_ids = [var.ecs_node_sg_id]

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
  min_size                  = var.min_asg_size
  max_size                  = var.max_asg_size
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

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = [aws_ecs_capacity_provider.main.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    base              = 1
    weight            = 100
  }
}


# ECR

resource "aws_ecr_repository" "backend" {
  name                 = "${var.prefix}-"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

