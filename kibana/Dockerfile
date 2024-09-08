ARG ELK_STACK_VERSION
# This line defines a build argument ELK_STACK_VERSION that 
# specifies the version of the ELK stack you want to use. 
# You can set this to a specific version, like 8.8.0, when building 
# the Docker image to ensure compatibility with your Elasticsearch instance.


# https://www.docker.elastic.co/
FROM docker.elastic.co/kibana/kibana:${ELK_STACK_VERSION}
# This line sets the base image for your Kibana container
# to the official Kibana Docker image from Elastic's Docker
# registry. The ${ELK_STACK_VERSION} placeholder is
# replaced with the version defined in the ARG to ensure
# you are using the correct version of Kibana.


# Add your kibana plugins setup here
# Example: RUN kibana-plugin install <name|url>
# This commented-out line serves as a placeholder to 
# install any necessary Kibana plugins. You can 
# uncomment and modify this line to add specific 
# plugins that enhance Kibana's functionality 
# (e.g., third-party visualization tools, custom dashboards).