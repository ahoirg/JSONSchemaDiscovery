# Use official Debian LTS version
FROM debian:bullseye-slim

# Set workspace
WORKDIR /usr/src/app

# Install Node.js LTS and required software
RUN apt-get update && apt-get install -y curl gnupg2 lsb-release wget git unzip build-essential make \
  && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y nodejs

# Install git-lfs to paper_empirical_evaluation.zip
RUN apt-get update && apt-get install -y git-lfs

# Install texlive to make report
RUN apt-get update && apt-get install -y --fix-missing texlive texlive-latex-extra texlive-latex-recommended texlive-fonts-extra 

# Add GPG key of MongoDB and add MongoDB repository
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add - \
    && echo "deb http://repo.mongodb.org/apt/debian bullseye/mongodb-org/5.0 main" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list \
    && apt-get update \
    && apt-get install -y mongodb-org \
    # Create the MongoDB data directory
    && mkdir -p /data/db

# Pull JSON files from GitHub repo and unzip the students.zip
RUN git clone https://github.com/ahoirg/Ordered-and-Unordered-Json-Data.git /usr/src/json-data \
    && ls -la /usr/src/json-data/ \
    && unzip /usr/src/json-data/students.zip -d /usr/src/json-data/

# Clone JSONSchemaDiscovery and install dependencies
RUN git lfs install \
    && git clone https://github.com/ahoirg/JSONSchemaExtractionTool.git /usr/src/app \
    && npm install \
    && npm install -f @types/ws@8.5.4

# Create directory for the report
RUN mkdir -p /usr/src/report

# Unzip the report into the directory
RUN unzip /usr/src/app/paper_empirical_evaluation.zip -d /usr/src/report

# Create Makefile
RUN echo 'report:' > /usr/src/report/Makefile \
    && echo '\tpdflatex main.tex' >> /usr/src/report/Makefile \
    && echo '\tbibtex main' >> /usr/src/report/Makefile \
    && echo '\tpdflatex main.tex' >> /usr/src/report/Makefile \
    && echo '\tpdflatex main.tex' >> /usr/src/report/Makefile \
    && echo 'clean:' >> /usr/src/report/Makefile \
    && echo '\trm -f main.aux main.bbl main.blg main.log main.out main.toc' >> /usr/src/report/Makefile

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
    && echo 'bash smoke.sh' >> start.sh \
    && echo 'while true; do sleep 1000; done' >> start.sh \
    && chmod +x start.sh

# Create script to import JSON data into MongoDB
RUN echo '#!/bin/bash' > import_json.sh \
    && echo 'for file in /usr/src/json-data/students/*.json; do' >> import_json.sh \
    && echo '    collection_name=$(basename "$file" .json)' >> import_json.sh \
    && echo '    mongoimport --db jsonschemadiscovery --collection "$collection_name" --file "$file"' >> import_json.sh \
    && echo 'done' >> import_json.sh \
    && chmod +x import_json.sh

# Create smoke.sh script
RUN echo '#!/bin/bash' > /usr/src/app/smoke.sh \
    && echo 'echo "Node.js Version:"' >> /usr/src/app/smoke.sh \
    && echo 'node --version' >> /usr/src/app/smoke.sh \
    && echo 'echo "MongoDB Version:"' >> /usr/src/app/smoke.sh \
    && echo 'mongod --version' >> /usr/src/app/smoke.sh \
    && echo 'echo "Checking MongoDB collection..."' >> /usr/src/app/smoke.sh \
    && echo 'if mongo jsonschemadiscovery --eval "db.getCollectionNames().includes(\"students_orj\")" | grep true; then' >> /usr/src/app/smoke.sh \
    && echo '    echo "DB OKAY! Container is ready for use."' >> /usr/src/app/smoke.sh \
    && echo 'else' >> /usr/src/app/smoke.sh \
    && echo '    echo "DB FAIL"' >> /usr/src/app/smoke.sh \
    && echo 'fi' >> /usr/src/app/smoke.sh \
    && chmod +x /usr/src/app/smoke.sh


# Set start.sh script as launch command
ENTRYPOINT ["./start.sh"]