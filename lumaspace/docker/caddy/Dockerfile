FROM caddy
COPY certs.local certs
COPY docker/caddy/caddy.json .
RUN ["caddy", "validate", "-config", "caddy.json"]

CMD ["caddy", "run", "-config", "caddy.json"]
