COMPOSE_FILE=docker-compose.yml

up:
	@docker compose -f ${COMPOSE_FILE} up -d

clean:
	@docker compose -f ${COMPOSE_FILE} down -v
	@docker compose -f ${COMPOSE_FILE} rm -f