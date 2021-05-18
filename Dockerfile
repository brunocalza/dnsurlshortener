FROM scratch
ADD cmd/urlshortener /
CMD ["/urlshortener"]