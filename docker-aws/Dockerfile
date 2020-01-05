FROM docker:latest

RUN apk update
RUN apk -Uuv add groff less python py-pip zip git
RUN pip install awscli

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
