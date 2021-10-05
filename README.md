## Purpose
The purpose of this module is to standardise the way we build kotlin based services. The key objectives of this module is to:
- [x] Use a standard buildspec template accross all services
- [x] Use AWS native tooling like CodePipline to build and deploy the service to all environments with a manaul gate between environments
- [x] Use Terraform to setup the infrasucture 
- [x] Document the process 
- [x] Deploys to Dev and creates ALB host header routing rules
- [ ] Deploys to Prd and creates ALB host header routing rules

At present, the module creates a CodeCommit repository and ECR registry, named `var.team`-`var.service`. These resources will respecitively store for source code and the built container. The module then creates a CodeBuild project, using the `buildspec.tpl` template as a `BuildSpec`. The build will use the CodeCommit as its source and the buildt container from the `DockerFile` will be stored in ECR. 

The module then creates an ECS Task Definition using the `taskdefinition.tpl` and creates an ECS Service on the ECS Dev Cluster which is targetted by the CodeDeploy stage in the CodePipeline. The container will then able able to be deployed. Lastly the `ALB Host Header Routes` are created on the respective load balancers. 
## Additional Reading
1. [O1KR3 - Standardize Builds and Deploys for Kotlin Based Services](https://technoponies.atlassian.net/browse/DEVOP-335) 
2. [ECS Task Definition Parameters](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html)
## Future Work
- [ ] Production still outstanding but can be easily reproduced using the already existing development code
- [ ] Refining IAM roles and Access to target AWS resources i.e. SSM Parameters and Secrets
- [ ] How to handle when containers require access to different AWS Resources i.e. DynamoDB and S3
- [ ] Adding Supprting Containers i.e. Datadog to TaskDefinitions
#### Variables

Variable | Description
------------ | -------------
`profile` | AWS Profile used to create the resoources 
`region` | Region in which to create the resources
`team` | Department or Owner of the resource
`environment` | Respective environment the resource is targetting i.e. dev or prod
`service` | The service name abbreviation of the service
`description` | A short description of the queue and it’s usage
`code_build_environment_vars` | Map of the Environment Variables needed for the CodeBuild Project
`subnet_id1, subnet_id2, subnet_id3` | Subnet(s) in which the ECS is deployed and where CodeBuild projects builds
`runtime_version` | Java Runtime Version that gets configured in the buildspec
`sns_approval_topic_arn` | The SNS topic where approval notifications are sent
`reserved_task_memory` | The soft limit (in MiB) of memory to reserve for the container
`container_port` | The port that the application in the container is published on
`ecs_healthcheck_endpoint` | Endpoint used to monitor the availability of the container
`host_port` | The port the container is mapped onto from the host. Can be left empty since these are Fargate containers
`vpc_id` | The VPC where resources are created
`ecs_cluster_name_dev` | Name of the ECS Development Cluster 
`dev_ecs_environment_vars` | Map of the Environment Variables needed for the dev ECS container
`dev_ecs_ssm_secrets` | Map of the SSM Parameter Store Secretes needed for the dev ECS container
`dev_container_desired_count` | Desired amount of containers for the dev ECS container


#### Module Usage 

```
module "eng_dev_wns_confirmed_glb_ppr_payment" {
  source   = "git@ci.payb.ee:3222/infrastructure/tfmodule-aws-codepipeline.git"
  
  ## General Module Vars ## 
  profile       = "globee"
  region        = "eu-west-1"
  service       = "pipeline-module-test"
  team          = "devops"
  description   = "test the module used to create kotlin pipeline"

  ## CodeBuild Environment Vars ##
  code_build_environment_vars = {
    BUILD_TEST01 = "test01"
    BUILD_TEST02 = "test02"
    BUILD_TEST03 = "test03"
  }

  ## General ECS Vars
  container_port = "8080"
  
  ## params for ecs DEV task ##
  dev_ecs_environment_vars = {
    TASK_ENV_01 = "test01"
    TASK_ENV_02 = "test02"
    TASK_ENV_03 = "test03"
  }

  dev_ecs_ssm_secrets = {
    SECRET_01 = "arn:aws:ssm:eu-west-1:834366213304:parameter/devops/pipeline-module-test-01"
    SECRET_02 = "arn:aws:ssm:eu-west-1:834366213304:parameter/devops/pipeline-module-test-02"
  }
}
```


#### Source Code Structure
```
├── alb.tf                            - alb resources and host header routing rules
├── codebuild.tf                      - codebuild project resource
├── codecommit.tf                     - codecommit resource
├── codepipeline.tf                   - codepipeline resource
├── data.tf                           - data sources for all templates and data sources used in the module
├── ecr.tf                            - definition for the ECR resource for the service
├── ecs-serices-dev.tf                - definition for all resources required to create the ECS dev resource
├── iam.tf                            - all IAM roles and policies required for module
├── locals.tf                         - local vars used as default tags for all resources
├── outputs.tf                        - outputs of ARNs for resources
├── provider.tf                       - terraform provider configuration
├── variables.tf                      - variable definitions, descriptions and defaults
├── templates                         
│    ├── buildspec.tpl                - buildspec template          
│    ├── codebuild_policy.tpl         - codebuild policy template
│    ├── codepipeline_policy.tpl      - codepipeline policy template
│    ├── ecs_execution_iam_policy.tpl - execuition policy template for ecs task and execution role
│    ├── service_assume_role.tpl      - template for creating service assume roles
│    └── taskdefinition.tpl           - task definition template
├── example
│    └── main.tf                      - Example of Module usage           
```
