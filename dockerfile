# Use official Node.js image based on Debian LTS
FROM node:20.9.0-bullseye

# Set workspace
WORKDIR /usr/src/app

# Add GPG key of MongoDB and add MongoDB repository
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add - \
    && echo "deb http://repo.mongodb.org/apt/debian bullseye/mongodb-org/5.0 main" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list \
    && apt-get update \
    && apt-get install -y mongodb-org \
    && mkdir -p /data/db

# Pull JSON files from GitHub repo
RUN git clone https://github.com/ahoirg/Irregular-Json-Dataset.git /usr/src/json-data

# Clone JSONSchemaDiscovery
RUN git clone https://github.com/ahoirg/JSONSchemaDiscovery /usr/src/app \
    && npm install \
    && npm install -f @types/ws@8.5.4

# Open required ports for application and MongoDB
EXPOSE 27017 4200

# Create and set MongoDB configuration file
RUN echo "net:" > /etc/mongod.conf \
    && echo "  bindIp: 0.0.0.0" >> /etc/mongod.conf

# Create start.sh script
RUN echo '#!/bin/bash' > start.sh \
    && echo 'mongod --fork --config /etc/mongod.conf --logpath /var/log/mongod.log' >> start.sh \
    && echo 'mongo --eval "db.runCommand({ping: 1})"' >> start.sh \
    && echo 'bash import_json.sh' >> start.sh \
    && echo 'while true; do sleep 1000; done' >> start.sh \
    && chmod +x start.sh

# Create script to import JSON data into MongoDB
RUN echo '#!/bin/bash' > import_json.sh \
    && echo 'for file in /usr/src/json-data/students/*.json; do' >> import_json.sh \
    && echo '    collection_name=$(basename "$file" .json)' >> import_json.sh \
    && echo '    mongoimport --db jsonschemadiscovery --collection "$collection_name" --file "$file"' >> import_json.sh \
    && echo 'done' >> import_json.sh \
    && chmod +x import_json.sh

# Set start.sh script as launch command
ENTRYPOINT ["./start.sh"]