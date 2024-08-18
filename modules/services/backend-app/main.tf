resource "aws_ecs_cluster" "backend" {
  name = var.ecs_cluster_name
}


data "aws_iam_policy_document" "ecs_node_policy" {
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
  assume_role_policy = data.aws_iam_policy_document.ecs_node_doc.json
}

# policy 생성 필요

resource "aws_iam_role_policy_attachment" "backend_node" {
  role       = aws_iam_role.backend_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


resource "aws_iam_instance_profile" "ecs_node" {
  name_prefix = "demo-ecs-node-profile"
  role = aws_iam_role.backend_node
}


resource "aws_ecs_cluster_capacity_providers" "b" {
  cluster_name = aws_ecs_cluster.name
}

# ssm paramter 로 퍼블릭 이미지 가져올 수 있음
data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id" 
}


resource "aws_launch_template" "ecs_ec2" {
  name_prefix            = "demo-ecs-ec2-"
  image_id               = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ecs_node_sg.id]

  iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }
  monitoring { enabled = true }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config;
    EOF
  )
}
