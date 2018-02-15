docker build -t httpd .

docker tag httpd sbpcs59/httpd:latest
docker push docker.io/sbpcs59/httpd:latest
