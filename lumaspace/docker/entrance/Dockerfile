FROM python:3.10

COPY docker/entrance/index.html .
COPY certs.local/space.cert.p12 .
COPY certs.local/space.cert.pem .

CMD ["python3", "-m", "http.server", "80"]
