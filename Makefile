build:
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o cmd/urlshortener

docker:
	docker build -t brunocalza/urlshortener .

run:
	docker run -p 8080:8080 -d --name urlshortener brunocalza/urlshortener

logs:
	docker logs $(docker ps -aqf "name=urlshortener")

