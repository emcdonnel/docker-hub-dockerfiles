FROM docker:latest

RUN apk update && apk -Uuv add groff less curl
RUN apk -Uuv add --no-cache python3 py3-pip
RUN pip install awscli
RUN curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
RUN chmod +x /usr/local/bin/ecs-cli

ADD drupal_ecs_drush.sh /opt/drupal_ecs_drush.sh
RUN chmod +x /opt/drupal_ecs_drush.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
