COMPOSE_FILE = build/docker-compose.yml

server:
	@docker exec -it network-security-server /bin/bash

client:
	@docker exec -it network-security-client /bin/bash

run:
	@echo "Client and Server are running"
	@GOOS=linux GOARCH=amd64 go build -o ./build/http ./cmd/http.go
	@docker compose -f ${COMPOSE_FILE} up -d --build

clean:
	@echo "Client and Server are stopped"
	@docker compose -f ${COMPOSE_FILE} down
	@docker compose -f ${COMPOSE_FILE} rm -f

.PHONY: client server clean run stop build