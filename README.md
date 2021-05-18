# DNS URL Shortener

This is a toy example of an URL Shortener using a DNS Server as the key-value store.

Inspired by [A URL shortener with an interesting storage backend](https://ols.wtf/2021/05/17/url-shortener.html).

## Description

One can make use of the TXT DNS record to store information in the server. One kind of information that you can store is a URL. So, creating the `buffer.short` TXT record on my domain `brunocalza.me` with the content a full URL path like `https://brunocalza.me/how-buffer-pool-works-an-implementation-in-go/`, one can create an URL Shortener service that does a DNS TXT Lookup on `buffer.short.brunocalza.me`, gets the full URL and does a redirect.

## Demo

Access `short.brunocalza.me/buffer` in the browser.

## DNS Lookup

`dig buffer.short.brunocalza.me TXT +short`

## Full code

```golang
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
```
