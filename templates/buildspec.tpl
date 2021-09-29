# https://docs.aws.amazon.com/codebuild/latest/userguide/sample-runtime-versions.html
# https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
version: 0.2
env:
  variables:
    M2_HOME: "/root/.m2"

phases:
  install:
    runtime-versions:
      java: openjdk11
    commands:
      - java -version
  pre_build:
    commands:
      - java -version
      - echo logging in to ECR
      - aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${region}.amazonaws.com
      - REPOSITORY_URI=${repository_url}
      - IMAGE_TAG=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
  build:
    commands:
      - echo build started on $(date)
      - mvn -e -X clean install
      - echo building the docker image
      - docker build -t $REPOSITORY_URI:latest .
      - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
  post_build:
    commands:
      - echo build completed on $(date)
      - echo pushing the docker images
      - docker push $REPOSITORY_URI:latest
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - echo writing image definitions file for deployment
      - printf '[{"name":"${container_name}","imageUri":"%s"}]' $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json
    
artifacts:
  files: imagedefinitions.json

cache:
  paths:
    - '/root/.m2/**/*'