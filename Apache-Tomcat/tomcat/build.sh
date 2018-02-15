docker build -t web .

docker tag web sbpcs59/web:latest
docker push sbpcs59/web:latest
