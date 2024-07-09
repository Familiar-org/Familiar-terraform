resource "aws_ecs_cluster" "name" {
  name = var.ecs_cluster_name

}

resource "aws_ecs_cluster_capacity_providers" "name" {
  cluster_name = aws_ecs_cluster.name
}

