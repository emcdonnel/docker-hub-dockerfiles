FROM docker:latest

RUN apk update
RUN apk -Uuv add groff less python py-pip curl
RUN pip install awscli
RUN curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
RUN chmod +x /usr/local/bin/ecs-cli

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
