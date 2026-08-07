*This project has been created as part of the 42 curriculum by snazzal*

## Description
This project aims to broaden system administration knowledge by virtualizing several Docker images within a personal virtual machine. It involves setting up a small infrastructure composed of an NGINX web server, a WordPress site with PHP-FPM, and a MariaDB database, all orchestrated via Docker Compose.

### Project Description
This project avoids ready-made DockerHub images (excluding Alpine/Debian base images) to ensure a deep understanding of container creation. 

#### Virtual Machines vs Docker
Virtual Machines abstract hardware, running a full guest operating system on top of a hypervisor. Docker, conversely, abstracts the application layer, packaging the software and its dependencies into containers that share the host system's kernel. This makes Docker containers significantly lighter, faster to start, and less resource-intensive than VMs.

#### Secrets vs Environment Variables
Environment variables (`.env` files) are useful for configuring non-sensitive application settings (like domain names). However, they can be exposed in logs or system processes. Docker Secrets provide a more secure mechanism for handling highly sensitive data (like database passwords), storing them securely and mounting them in memory only for the containers that explicitly require them.

#### Docker Network vs Host Network
A Host Network removes network isolation, allowing the container to share the host's networking namespace directly. This project utilizes a custom Docker Network, which creates an isolated DNS resolution pool where containers can discover and communicate with each other securely, without exposing their internal ports (like 3306 for MariaDB or 9000 for PHP-FPM) to the outside world.

#### Docker Volumes vs Bind Mounts
Bind mounts map a specific file or directory from the host machine directly into a container, depending heavily on the host's directory structure. Docker Volumes, which are required for this project, are entirely managed by Docker. They provide a safer, more persistent, and cross-platform way to store data (like our database and website files) independent of the container's lifecycle.


## Instructions
1. **Host Configuration:** To ensure the domain routes correctly, add `127.0.0.1 snazzal.42.fr` to your `/etc/hosts` file.
2. **Data Directories:** Ensure the host machine directories `/home/snazzal/data/wordpress` and `/home/snazzal/data/mariadb` exist for volume mounting.
3. **Environment Variables:** Create a `.env` file in the `srcs` directory with your secure credentials.
4. **Execution:** Run `make` at the root of the repository to build the images and launch the containers.


## Resources
* [Docker Official Documentation](https://docs.docker.com/)
* [NGINX Documentation](https://nginx.org/en/docs/)
* [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
* **AI Usage:** AI was utilized to help structure these documentation files, review the architecture against the evaluation sheet, and refine the explanations of Docker concepts.
