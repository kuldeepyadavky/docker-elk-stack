
# Dockerized ELK Stack

## Overview

This repository contains Docker configurations and setup scripts for deploying the ELK stack (Elasticsearch, Logstash, and Kibana) using Docker Compose. The setup includes predefined users, roles, and configurations for an optimized and secure deployment.

## Folder Structure

```
docker-elk/
│
├── .env                     # Environment file for storing environment variables
├── .env.example             # Example of the environment file for reference
├── .gitignore               # Git file for specifying untracked files to ignore
├── README.md                # Documentation file for the project
├── docker-compose.yml       # Docker Compose file for orchestrating services
│
├── elasticsearch/           # Directory for Elasticsearch setup
│   ├── Dockerfile           # Dockerfile for building Elasticsearch image
│   ├── jvm.options          # JVM options for Elasticsearch
│   └── config/              # Configuration directory for Elasticsearch
│       └── elasticsearch.yml # Elasticsearch configuration file
│
├── kibana/                  # Directory for Kibana setup
│   ├── Dockerfile           # Dockerfile for building Kibana image
│   └── config/              # Configuration directory for Kibana
│       └── kibana.yml       # Kibana configuration file
│
├── logstash/                # Directory for Logstash setup
│   ├── Dockerfile           # Dockerfile for building Logstash image
│   ├── jvm.options          # JVM options for Logstash
│   ├── config/              # Configuration directory for Logstash
│   │   └── logstash.yml     # Logstash configuration file
│   └── pipeline/            # Directory for Logstash pipeline
│       └── logstash.conf    # Pipeline configuration for Logstash
│
└── setup/                   # Directory for additional setup or initialization scripts
    ├── Dockerfile           # Dockerfile for the setup service
    ├── entrypoint.sh        # Entry point script for initializing services
    ├── lib.sh               # Library script with shared functions
    └── roles/               # Directory containing role definitions for users
        ├── filebeat_writer.json    # Role definition for Filebeat writer
        ├── heartbeat_writer.json   # Role definition for Heartbeat writer
        ├── logstash_writer.json    # Role definition for Logstash writer
        └── metricbeat_writer.json  # Role definition for Metricbeat writer
```

## Getting Started


### Prerequisites

Ensure you have Docker and Docker Compose installed on your machine.

- Docker: [Install Docker](https://docs.docker.com/get-docker/)
- Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/)

### Clone the repository:
  ```sh
    git clone https://github.com/kuldeepyadavky/docker-elk-stack
    cd docker-elk-stack
  ```


### Running the ELK Stack

1. **Initialize Elasticsearch Users and Roles:**
   Run the setup service to create necessary users and roles:
   ```bash
   docker-compose up setup

2. **Start the ELK Stack:**
   Once the setup completes without errors, start the ELK stack components:
   ```bash
   docker-compose up

### Testing and Verification
1. **Check Logs:**
   Monitor logs for each service to ensure they are running correctly:
   ```bash
   docker-compose logs -f elasticsearch
   docker-compose logs -f kibana
   docker-compose logs -f logstash

2. **Verify Health:**
   Monitor logs for each service to ensure they are running correctly:
   ```bash
   # Check Elasticsearch health (append user details)
   curl -f http://localhost:9200/_cluster/health?wait_for_status=yellow&timeout=50s || echo "Health check failed"

   # Check Kibana health
   curl -f http://localhost:5601 || echo "Health check failed"

   # Check Logstash health
   curl -f http://localhost:9600/_node/pipelines || echo "Health check failed"

### Configuration
   Update environment variables in the .env file to configure passwords, cluster name, and other settings.
   Modify service-specific configuration files in their respective directories.