FROM solr:8.2

ADD .docksal/etc/solr /opt/solr/server/solr/mycores

ENTRYPOINT ["docker-entrypoint.sh", "solr-precreate", "a"]
