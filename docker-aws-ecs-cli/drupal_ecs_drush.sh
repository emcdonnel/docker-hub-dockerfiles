#!/bin/sh

if [ "$1" = "--help" ]; then
  echo "     You are using the ECS Drush script to run drush commands on a ECS Cluster after Drupal deployment."
  echo "     The script uses ECS Run Task."
  echo "     You need the AWS CLI and ECS CLI plugins installed."
  echo "     Ensure that AWSCLI is configured."
  echo "     Docs:"
  echo "         AWSCLI: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html"
  echo "         ECS CLI: https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest"
  echo "     There are two ways to use this script:"
  echo "         Set enviroment variables before running the script"
  echo "             ECS_FAMILY - the ECS Family name"
  echo "             ECS_CLUSTER - the ECS Cluster name"
  echo "             CONTAINER_NAME - the ECS Container name"
  echo "         Provide the following argument when running the script"
  echo "             Frist argument - the ECS Family"
  echo "             Second argument - the ECS Cluster name"
  echo "             Third argument - the ECS Container name"
  exit 0
fi

if [ `command -v aws` ]; then
  echo "AWS CLI installed"
else
  echo "Install AWS CLI & try again"
  echo "Doc: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html"
  exit 1
fi

if [ `command -v ecs-cli` ]; then
  echo "ECS CLI plugin installed"
else
  echo "Install ECS CLI plugin & try again"
  echo "Download: https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest"
  exit 1
fi

if [[ -z "${ECS_FAMILY}" ]]; then
  if [ "$1" ]; then
    ECS_FAMILY="$1"
  else
    echo "Please provide the ECS Family or set enviroment variable ECS_FAMILY"
    exit 1
  fi
fi

if [[ -z "${ECS_CLUSTER}" ]]; then
  if [ "$2" ]; then
    ECS_CLUSTER="$2"
  else
    echo "Please provide the ECS Cluster or set enviroment variable ECS_CLUSTER"
    exit 1
  fi
fi

if [[ -z "${CONTAINER_NAME}" ]]; then
  if [ "$3" ]; then
    CONTAINER_NAME="$3"
  else
    echo "Please provide the ECS Container Name or set enviroment variable CONTAINER_NAME"
    exit 1
  fi
fi

echo "Running drush on ECS Cluster $ECS_CLUSTER | Family $ECS_FAMILY | Container $CONTAINER_NAME"

# Get active task definition
TASK_DEF=$(aws ecs list-task-definitions --status ACTIVE --family-prefix $ECS_FAMILY --output text --query "taskDefinitionArns[]")
echo "Using Active Task Definition: $TASK_DEF"

# Run drush cr and print logs from ECS task
CR_TASK_0=$(aws ecs run-task --cluster $ECS_CLUSTER --task-definition $TASK_DEF \
--launch-type EC2 --count 1 \
--overrides "{\"containerOverrides\":[{\"name\":\"${CONTAINER_NAME}\",\"command\":[\"drush\",\"cr\"]}]}" \
--output text --query "tasks[*].taskArn")
echo "drush cr: $CR_TASK_0"
aws ecs wait tasks-stopped --cluster $ECS_CLUSTER --tasks $CR_TASK_0
CR_TASK_0_ID=$(echo $CR_TASK_0 | awk '{split($0,a,"/"); print a[3]}')
echo "Logs for Task $CR_TASK_0_ID:"
ecs-cli logs --task-id $CR_TASK_0_ID --cluster $ECS_CLUSTER --task-def $TASK_DEF || true

# Run drush updb and print logs from ECS task
UPDB_TASK=$(aws ecs run-task --cluster $ECS_CLUSTER --task-definition $TASK_DEF \
--launch-type EC2 --count 1 \
--overrides "{\"containerOverrides\":[{\"name\":\"${CONTAINER_NAME}\",\"command\":[\"drush\",\"updb\",\"-y\"]}]}" \
--output text --query "tasks[*].taskArn")
echo "drush updb: $UPDB_TASK"
aws ecs wait tasks-stopped --cluster $ECS_CLUSTER --tasks $UPDB_TASK
UPDB_TASK_ID=$(echo $UPDB_TASK | awk '{split($0,a,"/"); print a[3]}')
echo "Logs for Task $UPDB_TASK_ID:"
ecs-cli logs --task-id $UPDB_TASK_ID --cluster $ECS_CLUSTER --task-def $TASK_DEF || true

# Run drush cr and print logs from ECS task
CR_TASK_1=$(aws ecs run-task --cluster $ECS_CLUSTER --task-definition $TASK_DEF \
--launch-type EC2 --count 1 \
--overrides "{\"containerOverrides\":[{\"name\":\"${CONTAINER_NAME}\",\"command\":[\"drush\",\"cr\"]}]}" \
--output text --query "tasks[*].taskArn")
echo "drush cr: $CR_TASK_1"
aws ecs wait tasks-stopped --cluster $ECS_CLUSTER --tasks $CR_TASK_1
CR_TASK_1_ID=$(echo $CR_TASK_1 | awk '{split($0,a,"/"); print a[3]}')
echo "Logs for Task $CR_TASK_1_ID:"
ecs-cli logs --task-id $CR_TASK_1_ID --cluster $ECS_CLUSTER --task-def $TASK_DEF || true

# Run drush cim and print logs from ECS task
CIM_TASK=$(aws ecs run-task --cluster $ECS_CLUSTER --task-definition $TASK_DEF \
--launch-type EC2 --count 1 \
--overrides "{\"containerOverrides\":[{\"name\":\"${CONTAINER_NAME}\",\"command\":[\"drush\",\"cim\",\"-y\"]}]}" \
--output text --query "tasks[*].taskArn")
echo "drush cim: $CIM_TASK"
aws ecs wait tasks-stopped --cluster $ECS_CLUSTER --tasks $CIM_TASK
CIM_TASK_ID=$(echo $CIM_TASK | awk '{split($0,a,"/"); print a[3]}')
echo "Logs for Task $CIM_TASK_ID:"
ecs-cli logs --task-id $CIM_TASK_ID --cluster $ECS_CLUSTER --task-def $TASK_DEF || true

# Run drush cr and print logs from ECS task
CR_TASK_2=$(aws ecs run-task --cluster $ECS_CLUSTER --task-definition $TASK_DEF \
--launch-type EC2 --count 1 \
--overrides "{\"containerOverrides\":[{\"name\":\"${CONTAINER_NAME}\",\"command\":[\"drush\",\"cr\"]}]}" \
--output text --query "tasks[*].taskArn")
echo "drush cr: $CR_TASK_2"
aws ecs wait tasks-stopped --cluster $ECS_CLUSTER --tasks $CR_TASK_2
CR_TASK_2_ID=$(echo $CR_TASK_2 | awk '{split($0,a,"/"); print a[3]}')
echo "Logs for Task $CR_TASK_2_ID:"
ecs-cli logs --task-id $CR_TASK_2_ID --cluster $ECS_CLUSTER --task-def $TASK_DEF || true
