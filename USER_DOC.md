# User Documentation

## Services Provided
This infrastructure provides a fully functional, secure web stack consisting of three main services:
*   **NGINX:** Acts as the secure entrypoint to the network, handling HTTPS traffic using TLSv1.2/TLSv1.3.
*   **WordPress:** A complete content management system powered by PHP-FPM.
*   **MariaDB:** A relational database management system storing the website's content and user data.

## Starting and Stopping the Project
*   **To start the project:** Open a terminal at the root of the repository and run `make` (or `make up`).
*   **To stop the project:** Run `make down` to safely halt the containers.
*   **To clean up the project:** Run `make clean` or `make fclean` to stop containers and remove generated images and networks.

## Accessing the Application
*   **Website:** Open a web browser and navigate to `https://snazzal.42.fr`. Note: Because the TLS certificate is self-signed, you may need to accept a browser security warning.
*   **Administration Panel:** Navigate to `https://snazzal.42.fr/wp-admin` to access the WordPress dashboard.

## Managing Credentials
All sensitive credentials, API keys, and passwords are not stored in the public repository. They are located locally on the host machine in the `srcs/.env` file or within the local `secrets/` directory (which is ignored by Git)[cite: 1, 2]. 

## Checking Service Status
To verify that the services are running correctly, execute the following command from the `srcs/` directory:
```bash
docker compose ps