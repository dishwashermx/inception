NAME = inception

SRC_DIR = srcs
COMPOSE = docker-compose -f $(SRC_DIR)/docker-compose.yml

all: up

prepare_dirs:
	@mkdir -p /home/ghwa/data/mariadb
	@mkdir -p /home/ghwa/data/wordpress

up: prepare_dirs
	@$(COMPOSE) up -d --build

down:
	@$(COMPOSE) down

re: fclean all

clean:
	@$(COMPOSE) down --volumes

fclean: clean
	@sudo rm -rf /home/ghwa/data/mariadb/*
	@sudo rm -rf /home/ghwa/data/wordpress/*

ps:
	@docker ps

logs:
	@$(COMPOSE) logs -f

.PHONY: all up down re clean fclean ps logs prepare_dirs
