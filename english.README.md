# # INE TCC System (Docker Version)

## Environment Variables
```
MYSQLDB_USER=root
MYSQLDB_ROOT_PASSWORD=password
MYSQLDB_DATABASE=projetos
JAVA_OPTS="-Dspring.profiles.active=dev"
SELF_SSL=yes
```
1. `MYSQLDB_USER`: User to connect to the database.
2. `MYSQLDB_ROOT_PASSWORD`: Password to connect to the database.
3. `MYSQLDB_DATABASE`: Defines the name of the database.
4. `JAVA_OPTS`: Defines which `.properties` file will be used. Use `prod` in production and `dev` in development.
5. `SELF_SSL`: **Do not use this variable in production**. Creates a self-signed SSL certificate for use in the local environment. The SSL certificate is necessary locally for effective communication with UFSC's Centralized Authentication System (CAS).

## Local Environment

### 1. Prerequisites
1. Have Docker installed on your machine. [Installation Link](https://docs.docker.com/get-docker/)
2. Have a backup of the TCC system database. Contact the professor responsible for the system.
3. Be connected to the UFSC VPN. [Tutorial Link](https://servicosti.sistemas.ufsc.br/publico/detalhes.xhtml?servico=112)
4. Create a local host named `projetostcc` pointing to `127.0.0.1`. [How to modify the hosts file on your machine?](https://docs.saninternet.com/arquivo-hosts)

### 2. Starting the Containers
1. In your terminal, navigate to the root of the project and run the command `docker-compose --profile dev up --build` (use the `-d` flag if you want to detach the logs from your terminal).
2. To enter a container, use the helper command `docker exec -it TCC-db bash`, for example, to access the database container.

### 3. Restoring the Backup
1. In the terminal, navigate to the directory where the downloaded backup is located, e.g., `cd ~/Downloads`.
2. Run the command `cat bk_sistema_tcc_20201027.sql | docker exec -i TCC-db /usr/bin/mysql --password=password projetos`.

**After completing steps 1 (prerequisites), 2 (starting containers), and 3 (restoring the backup), the application will be running. Note that steps 1 and 3 only need to be completed the first time.**

### 4. Handling Code Changes
The project does not handle automatic reloading well. **It is necessary to restart the containers.** Dependencies are cached, so this process should not take long.

### 5. Stopping and Restarting the Containers
Use the command `docker-compose --profile dev down` if you want to stop all running containers.

You can also use the command `docker restart <container_name>` to restart just one container if necessary.  
Use the command `docker restart TCC-app` to load changes in the code.

### 6. Diagnosing Common Issues
Section dedicated to documenting common problems and potential solutions for future reference by beginner developers.

**6.1 org.opensaml.SAMLException: UNAUTHORIZED_SERVICE:**  
Caused during authentication. Ensure you are connected to the UFSC VPN.

**6.2 Docker Logs:**  
Open the terminal and inspect the Docker logs with the command `docker logs TCC-app`.

**6.3 Tomcat Logs:**  
To inspect Tomcat logs directly, open the terminal and follow these steps:  
1. `docker exec -it TCC-app bash`  
2. `cd /usr/local/tomcat/logs`  
3. The two most useful log files in this directory are `catalina.log` and `localhost_access_log.txt`.  
Use the command `tail -F <file_name>` to inspect the desired log file.  
[Documentation about the tail command](https://guialinux.uniriotec.br/tail/)

## Production Environment

The production environment setup differs slightly from the local environment. Below are the main changes and instructions for configuring and running the application in production:

### 1. Differences in Environment Variables
- **`JAVA_OPTS`**:  
  In the production environment, the value of `JAVA_OPTS` should be updated to activate the production profile:  
  `JAVA_OPTS="-Dspring.profiles.active=prod"`. This value replaces `dev` used in the local environment.

### 2. Running the Containers
- **Docker Command for Production**:  
  In the production environment, Docker Compose should be executed with the `prod` profile. The command to start the containers in production is:

```bash
docker-compose --profile prod up --build
```

### 3. Configuring NFS for Static Files
The directory ./tcc-files, which contains static files, must be mapped to an external NFS (Network File System) in the production environment. This configuration ensures that files are stored outside the container, guaranteeing persistence and easy access to these data. The volume configuration in the docker-compose.yml file is already prepared for this, and SETIC should handle the appropriate mapping.
