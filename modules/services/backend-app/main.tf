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


### :arrow_down: Example ###

resource "aws_iam_role" "backend_node" {
  name        = "Ecs_Backend_Node_Role"
  assume_role_policy = data.aws_iam_policy_document.backend_node_assume
}

# policy 생성 필요

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

# ssm paramter 로 퍼블릭 이미지 가져올 수 있음
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
      echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config;
    EOF
  )
}
