NAME        = inception
LOGIN       = snazzal
COMPOSE     = docker compose -f srcs/docker-compose.yml
DATA_DIR    = /home/$(LOGIN)/data


all: prepare up

# Create the host directories our named volumes are bind-backed by.
# Must exist BEFORE compose tries to mount them, or the container
# creation step fails with "no such file or directory".
prepare:
	mkdir -p $(DATA_DIR)/mariadb
	mkdir -p $(DATA_DIR)/wordpress

up: prepare
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

restart: down up

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

# Removes containers, networks, and images built by this project.
# Leaves host data intact so you don't lose your DB/site on a normal reset.
clean: down
	docker image rm -f mariadb nginx wordpress 2>/dev/null || true

# Full reset: also wipes the actual persisted data on the host.
# Use this to simulate a from-scratch evaluation run.
fclean: clean
	$(COMPOSE) down -v
	sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all prepare up down stop start restart clean fclean re logs ps
