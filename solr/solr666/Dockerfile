FROM solr:6.6.6

RUN mkdir /opt/solr/server/solr/mycores/a
ADD .docksal/etc/solr/a /opt/solr/server/solr/mycores/a

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["solr-foreground"]
