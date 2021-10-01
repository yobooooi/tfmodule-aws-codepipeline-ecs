{
  "name": "${container_name}",
  "image": "${image}:latest",
  "memoryReservation": ${reserved_task_memory},
  "portMappings": [
    {
      "containerPort": ${container_port},
      "hostPort": ${host_port}
    }
  ],
  "environment": [
    %{ for name, value in environment_vars }{
      "name": "${name}",
      "value": "${value}"
    },
    %{ endfor }{
      "name": "AWS_DEFAULT_REGION",
      "value": "eu-west-1"
    }
  ],
  "secrets": [
    %{ for name, value in secrets }{
      "name": "${name}",
      "valueFrom": "${value}"
    },
    %{ endfor }{
      "name": "DATA_DOG_DEV_API_KEY",
      "valueFrom": "arn:aws:ssm:eu-west-1:834366213304:parameter/data-dog/dev/API_KEY"
    }
  ],
  "networkMode": "bridge",
  "essential": true,
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "${log_group}",
      "awslogs-region": "${aws_region}",
      "awslogs-stream-prefix": "${service_name}"
    }
  }
}