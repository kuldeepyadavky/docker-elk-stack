ARG ELK_STACK_VERSION
# This sets a build argument to specify the version
# of the ELK stack (like 8.8.0).

# https://www.docker.elastic.co/
FROM docker.elastic.co/elasticsearch/elasticsearch:${ELK_STACK_VERSION}
# This uses an official Elasticsearch Docker
# image based on the specified version.

ENTRYPOINT ["/entrypoint.sh"]
# This sets the default entrypoint for
# the container to the custom entrypoint.sh
# script, which manages user and role
# creation in Elasticsearch.
