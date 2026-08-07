# Developer Documentation

## Setting up the Environment
1.  **Prerequisites:** Ensure Docker, Docker Compose, and Make are installed on your host machine.
2.  **Configuration:** Create a `.env` file inside the `srcs/` directory. This file must define the necessary variables (e.g., `DOMAIN_NAME=snazzal.42.fr`, database usernames, and passwords).
3.  **Secrets:** If utilizing Docker secrets, ensure your text files (e.g., `db_password.txt`) are placed in the local folder mapped by the docker-compose file, ensuring they are protected and ignored by `.gitignore`.

## Building and Launching
The entire build process is automated via the `Makefile` located at the root. 
*   Run `make` to build the required Docker images from the provided Dockerfiles and launch the containers.
*   The `docker-compose.yml` file is responsible for wiring the isolated networks and mounting the volumes.

## Relevant Management Commands
*   `docker compose -f srcs/docker-compose.yml up --build -d`: Rebuilds the images and starts the containers in detached mode.
*   `docker compose -f srcs/docker-compose.yml logs -f`: Tails the live logs for all running services to assist with debugging.
*   `docker exec -it <container_name> /bin/sh` (or `/bin/bash`): Opens an interactive shell inside a running container for inspection.

## Data Storage and Persistence
Data persistence is achieved using Docker Named Volumes, ensuring data survives container crashes or restarts.
*   **Database Volume:** The MariaDB data is stored in a volume mapped to `/home/snazzal/data/mariadb` on the host machine.
*   **Website Volume:** The WordPress core files and user uploads are stored in a volume mapped to `/home/snazzal/data/wordpress` on the host machine. 
*   **Verification:** You can verify where volumes are mounted by running `docker volume ls` followed by `docker volume inspect <volume_name>`.