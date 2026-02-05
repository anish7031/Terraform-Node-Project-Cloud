module "node_app" {
  source          = "./Terraform-Node-Project-Cloud"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
  docker_image    = "519848832066.dkr.ecr.us-east-1.amazonaws.com/node-poc:latest"
}

resource "aws_ecs_service" "service" {
  name            = "node-service"
  cluster         = module.node_app.ecs_cluster_id
  task_definition = module.node_app.task_definition_arn
  desired_count   = 1

  network_configuration {
    security_groups = [module.node_app.ecs_sg_id]
    subnets         = module.node_app.private_subnets
  }

  load_balancer {
    target_group_arn = module.node_app.lb_target_group_arn
    container_name   = "node"
    container_port   = 3000
  }

}

