#/bin/bash

# declaration of env. variables.
export LOCALSTACK_NAME="localstack"
export DATA_DIRECTORY="$(pwd)/data";
export POSTGRES_DATA_DIRECTORY="$DATA_DIRECTORY/postgres"
export KEYCLOAK_DATA_DIRECTORY="$DATA_DIRECTORY/keycloak"
export INIT_DATA_DIRECTORY="$(pwd)/init";

# SERVICES="" will start all services otherwise only the listed one will be used
SERVICES="postgres keycloak"

# declaration of functions
initDataDirectoryIfDoesntExist() 
{
  if [ ! -d $1 ]
  then
    if [ -z $2 ]
    then
      echo "Creation of directory $1"
      mkdir -p $1
    else
      echo "Creation of directory $1 (with init data: $2)"
      mkdir -p $1
      tar -xf $2 --directory $1
    fi
  fi
}

showUsage()
{
  echo "localstack-docker-compose"
  echo
  echo "Usage:"
  echo "  sh ./localstack.sh [COMMAND]"
  echo "  ./localstack.sh [COMMAND] (requires chmod +x ./localstack.sh)"
  echo 
  echo "Commands:"
  echo "  start         Init then start the localstack"
  echo "  status        Show localstack status"
  echo "  stop          Stop the localstack"
  echo "  restart       Stop then Start the localstack"
  echo
}

init()
{
  echo "Check data directories..."
  initDataDirectoryIfDoesntExist $POSTGRES_DATA_DIRECTORY
  initDataDirectoryIfDoesntExist $KEYCLOAK_DATA_DIRECTORY
  # Your custom init commands here
  # ...
}

start() 
{
  init
  echo "Start localstack ..."
  docker-compose -p $LOCALSTACK_NAME up -d --remove-orphans $SERVICES
}

status()
{
  docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" | grep $LOCALSTACK_NAME
}

stop()
{
  echo "Stop localstack ..."
  docker-compose -p $LOCALSTACK_NAME down
}

restart()
{
  echo "Restart localstack..."
  stop
  start
}

# main part of the script
case "$1" in
  "start")
  start
  ;;
  "status")
  status
  ;;
  "stop")
  stop
  ;;
  "restart")
  restart
  ;;
  *) 
  showUsage 
  ;;
esac
