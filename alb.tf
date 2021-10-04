
data "aws_alb" "loadbalancer_dev" {
  name="dev-load-balancer"
}

resource "aws_alb_target_group" "service_tg_dev" {
  name                 = "${var.service}-dev-tg"
  port                 = var.container_port
  protocol             = "HTTP"
  vpc_id               = data.aws_vpc.main.id
  target_type          = "ip"
  deregistration_delay = 10

  health_check {
    interval          = 15
    timeout           = 5
    healthy_threshold = 2
    path              = var.ecs_healthcheck_endpoint
    matcher           = "200"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "forward_to_tg" {
  listener_arn = "arn:aws:elasticloadbalancing:eu-west-1:834366213304:listener/app/dev-load-balancer/c31968f44d519593/b356827cbeae2ae9"

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service_tg_dev.arn
  }

  condition {
    source_ip {
      values = [
        "0.0.0.0/0"
      ]
    }
  }

  condition {
    host_header {
      values = ["${var.service}.dev.globee.com"]
    }
  }

}
