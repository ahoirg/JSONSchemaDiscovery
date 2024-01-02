# JSON Schema Extraction Tool

The JSON Schema Extraction Tool efficiently and accurately extracts schemas from JSON and Extended JSON Document Collections, achieving 100% accuracy in rapidly determining the schema of JSON data within MongoDB collections.

The JSON Schema Extraction Tool was developed based on the innovative approach introduced in the paper "An Approach for Schema Extraction of JSON and Extended JSON Document Collections".  

The project is continued from the last commit of the JSONSchemaDiscovery project.

You can use this project locally on your machine or test it with the provided sample data using our Dockerfile for a Docker container setup. Below, you will find instructions for both local and container usage.

---

## Table of Contents
- [1.1 Docker Container Usage Instructions](#11-docker-container-usage-instructions)
- [1.2 Local Usage Instructions](#12-local-usage-instructions)
- [2. Using the Project](#2-using-the-project)
- [3. Create the Report](#3-create-the-report)

---

## 1.1) Docker Container Usage Instructions

To utilize the JSON Schema Extraction Tool in a Docker container, follow these simple steps:

1. **Clone the Project**: Begin by cloning the repository using `git clone`, or simply download the Dockerfile directly to your machine.

2. **Initialize Docker**: Ensure that Docker is running on your system. If not, start Docker from your system's applications.

3. **Build the Docker Image**:
   - Navigate to the directory where the Dockerfile is located.
   - Open a terminal in this directory.
   - Execute the command:
     ```
     docker build -t json-schema-extraction-tool .
     ```
     - **Note**: The building process might take some time, particularly due to the installation of the Texlive library, which is necessary for compiling reports written in LaTeX.
4. **Verify the Docker Image**:
   - After building, verify the image with `docker images`
   - You should see something like:
     ```
     REPOSITORY                    TAG       IMAGE ID       CREATED         SIZE
     json-schema-extraction-tool   latest    9299519dfb43   6 minutes ago   4.86GB
     ```
5. **Run the Docker Container**:
   - Use the command:
     ```
     docker run -m 5g --cpus=3 -p 27017:27017 -p 4200:4200 json-schema-extraction-tool .
     ```
     
     - `-m` sets the memory limit (e.g., 5GB).
     - `--cpus` specifies the number of CPUs to use.
   - For lighter usage or if not conducting experiments as described in the "RepEng Project: Empirical Evaluation of JSON Schema Extraction from MongoDB Collections" paper, you can simply use `docker run -p 27017:27017 -p 4200:4200 json-schema-extraction-tool .`
   - MongoDB runs on port 27017 inside the container. The `-p 27017:27017` maps this port for external access. Change the first `27017` if this port is already in use on your machine.
   - The JSONSchemaExtractionTool application runs on port 4200 inside the container. The `-p 4200:4200` maps this port for external access. Change the first `4200` if this port is already in use on your machine.
6. **Expected Output**:
   - Upon successful execution, your terminal should display the following results:

     ```
     Node.js Version:
     v16.20.2
     MongoDB Version:
     db version v5.0.23
     Build Info: {
         "version": "5.0.23",
         "gitVersion": "3367195a14d0ba2734d2ba2719294fb974ad0834",
         "openSSLVersion": "OpenSSL 1.1.1w  11 Sep 2023",
         "modules": [],
         "allocator": "tcmalloc",
         "environment": {
             "distmod": "debian11",
             "distarch": "x86_64",
             "target_arch": "x86_64"
         }
     }
     Checking MongoDB collection...
     true
     DB OKAY! Container is ready for use.
     ```
7. **Access the Container's Shell**:
    - Avoid closing the terminal running your Docker container.
    - Run the command `docker ps` to list all running containers.
    - Look for the container running the JSON Schema Extraction Tool. You will see an output similar to:
       ```
      CONTAINER ID   IMAGE                         COMMAND          CREATED          STATUS          PORTS                                              NAMES
      54b5e0d86a73   json-schema-extraction-tool   "./start.sh ."   53 minutes ago   Up 53 minutes   0.0.0.0:4200->4200/tcp, 0.0.0.0:27017->27017/tcp   affectionate_payne
       ```
     - Use the command replacing {container_Id} with your actual container ID (e.g., 54b5e0d86a73):
       ```
       docker exec -it {container_Id} /bin/bash 
       ``` 
     - After executing this command, you should be inside the container's shell, indicated by a prompt like root@54b5e0d86a73:/usr/src/app#.

      This allows you to interact with the Docker container directly through the command line.
8. **Start and Access the Application**:
   - In the Docker container's terminal, execute the command: 
      ```
      npm run dev
      ```
      - Note: After the step 7, the Docker terminal will open directly at /usr/src/app. If you have changed the directory, make sure to navigate back to /usr/src/app before running the command.
   - This will start the JSON Schema Extraction Tool within the container.
   - Open a web browser on your local machine and navigate to `http://localhost:4200/`
   - This should load the user interface of the JSON Schema Extraction Tool, allowing you to interact with it.
9. **Optional: Checking the Database**:
   This step is optional. If you wish to inspect the database within the Docker container, you can do so using either MongoDB Compass on your local machine or the mongo shell inside the container.
   - If MongoDB Compass is installed on your local machine, you can connect to the database at `mongodb://localhost:27017`
   - To use the mongo shell within the Docker container, enter the command mongo in the container's shell ("root@54b5e0d86a73:/usr/src/app# mongo")
      mongo shell commands: , "show dbs", "use jsonschemadiscovery", "show collections"

   You can learn how to use the project by continuing in the **2)Using The Project** section.

---

## 1.2) Local Usage Instructions
1. **What you need installed to run this project**
   * [NodeJS](http://nodejs.org)
   * [Mongo DB](https://www.mongodb.org)

2) **Install all dependencies**: After clone the repo to your local machine, in project's folder:
- Install global dependencies:
    * [Angular CLI](https://cli.angular.io/) `npm install -g @angular/cli`
    * [Typescript](https://www.typescriptlang.org/) `npm install -g typescript`

- Install project dependencies running:
     ```
     npm install
     ```
3) **Start the Application**: Run the command for a dev server
      ```
      npm run dev
      ```
      - Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.
      - 
4) **Optional: Checking the Database**:
   This step is optional. If you wish to inspect the database, you can use MongoDB Compass on your local machine or you can use the mongo shell.
   - If MongoDB Compass is installed on your local machine, you can connect to the database at `mongodb://localhost:27017`
   - To use the mongo shell, enter the mongo shell with the command : ` mongo `
      mongo shell commands: , "show dbs", "use jsonschemadiscovery", "show collections"

You can learn how to use the project by continuing in the **2)Using The Project** section.

---

## 2) Using the Project

When you open `http://localhost:4200/` in your browser, you will be greeted with a login screen.

### Registration and Login
- If you do not have an account, you can create one by clicking the "Register Me" button.
- Register by providing your name, email, and password to connect to the system.

### First Trial
- To try your first JSON extraction, click on the plus (+) button inside the red circle located at the bottom right corner of the screen.
- This process will lead you through a series of three screens:
  1. Connection
  2. Authentication
  3. Ready
     
### Connection
- In the Connection section, you will enter the database information.
- If you are running the project inside Docker, you do not need to change any values except for the Collection name. The necessary information is set to default in the code.
- For the Collection name field, you can try any of the following databases in the container: `students_dif_value`, `students_orj`, `students_shuffled`, `students_shuffled_dif_items`.
- It is recommended to use the `students_shuffled` database.

### Authentication
- **If you are running the project within a Docker container,** there is no need to change anything in this section.
- Otherwise, you will need to enter the required information to connect to your database.

### Ready
- The final screen is "Ready". You can initiate the process by clicking the "Extract JsonSchema" button.
- The duration of the process varies depending on the size and state of the collection. When the process is complete, an alert will appear on the screen.
- You can wait for the process to complete by switching to the WORKSPACE screen from the left menu.

 **Important Note**
- Due to specifics in the core code, there are instances where the alert may not appear even after the process has finished. In such cases, it's recommended to manually refresh the page every 2 minutes to check the status.

### Checking Results and Downloading the JSON Schema

- In the Workspace screen, if you see a blue checkmark, it indicates that the process is complete.
- You can view the details of the completed process by clicking on the eye icon next to the relevant task.
- Additionally, you have the option to download the JSON schema.
- The detail window also provides a button that show insights into the time consumed at each stage of the JSON extraction process.

---

## 3) Create the Report

### 3.1) Create the Report Using Docker Container
- While the Docker container is running, connect to the container with the following command:
```
docker exec -it {container_Id} /bin/bash
```
- Navigate to the path /usr/src/report where the LaTeX code for the report is located:
```
cd /usr/src/report
```
- Create the report with the following command:
```
make report
```
After the report is created, a temporary file will be generated. To delete these files, you can use the command:
```
make clean
```
-The make report command will create a new report each time it's run. You can make changes to the LaTeX code to generate new reports as needed.
Note: You can open a terminal on your machine and use the following command to copy the report to your machine:
```
docker cp {container_id}:/usr/src/report/main.pdf .
```

### 3.2) Create the Report Without Using Docker Container

You can upload the LaTeX code to websites like [overleaf](https://www.overleaf.com/), or you can install applications like [MiKTeX](https://miktex.org)  on your machine to create the report.


