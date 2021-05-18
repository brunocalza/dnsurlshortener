PROGRAM_NAME = urlshortener

build:
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o cmd/$(PROGRAM_NAME)

docker:
	docker build -t brunocalza/$(PROGRAM_NAME) .

run:
	docker run -p 8080:8080 -d --name $(PROGRAM_NAME) brunocalza/$(PROGRAM_NAME)

logs:
	@docker logs $(shell docker ps -aqf "name=$(PROGRAM_NAME)")

