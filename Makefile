APP_NAME=notify-engine
DOCKER_IMAGE=$(APP_NAME):latest

.PHONY: build docker-build deploy-local clean

build:
	go build -o bin/$(APP_NAME) ./cmd/engine/main.go

docker-build:
	docker build -t $(DOCKER_IMAGE) -f deployments/docker/Dockerfile .

deploy-local:
	helm upgrade --install $(APP_NAME) ./deployments/helm/notify-chart --set image.repository=$(DOCKER_IMAGE)

test:
	go test ./...

clean:
	rm -rf bin/