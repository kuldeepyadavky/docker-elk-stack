ARG ELK_STACK_VERSION
# This line defines a build argument ELK_STACK_VERSION that 
# specifies the version of the ELK stack you want to use. 
# You can set this to a specific version, like 8.8.0, when building 
# the Docker image to ensure compatibility with your Elasticsearch instance.


# https://www.docker.elastic.co/
FROM docker.elastic.co/logstash/logstash:${ELK_STACK_VERSION}
# This line specifies the base image for your Logstash container,
# using the official Logstash Docker image from Elastic's Docker
# registry. The ${ELK_STACK_VERSION} placeholder is replaced
# with the version provided in the ARG, ensuring compatibility
# with your Elasticsearch and Kibana versions.



# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json
# This commented-out line is a placeholder for installing
# Logstash plugins. You can uncomment and modify it to
# install specific plugins that enhance Logstash's data
# processing capabilities (e.g., JSON filters, grok patterns).

