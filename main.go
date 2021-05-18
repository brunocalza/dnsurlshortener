package main

import (
	"context"
	"log"
	"net"
	"net/http"
	"strings"
)

const defaultPort = ":8080"
const domainName = "short.brunocalza.me"
const httpRedirect = 302

func main() {
	http.HandleFunc("/", handleRequest)
	http.ListenAndServe(defaultPort, nil)
}

func handleRequest(w http.ResponseWriter, r *http.Request) {
	shortName := strings.TrimPrefix(r.URL.Path, "/")
	dnsName := shortName + "." + domainName

	resolver := net.DefaultResolver
	response, err := resolver.LookupTXT(context.TODO(), dnsName)
	if err != nil || len(response) == 0 {
		log.Print(err)
		w.Write([]byte("Error in DNS lookup\n"))
		return
	}
	http.Redirect(w, r, response[0], httpRedirect)
}
