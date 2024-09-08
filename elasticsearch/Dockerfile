ARG ELK_STACK_VERSION
# This line defines a build argument named ELK_STACK_VERSION.
# This allows you to specify the version of the ELK stack 
# you want to use when building the Docker image. 
# For example, you can set this to 8.8.0 or any version you prefer.


# https://www.docker.elastic.co/
FROM docker.elastic.co/elasticsearch/elasticsearch:${ELK_STACK_VERSION}
# This line specifies the base image for your Elasticsearch container. 
# It uses the official Elasticsearch Docker image from Elastic's Docker 
# registry. The ${ELK_STACK_VERSION} placeholder will be replaced 
# by the version specified in the build argument, ensuring you are 
# using the correct version of Elasticsearch.


# Add your elasticsearch plugins setup here
# Example: RUN elasticsearch-plugin install analysis-icu