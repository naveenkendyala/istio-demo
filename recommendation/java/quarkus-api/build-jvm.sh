#/bin/bash
./mvnw clean package -Dquarkus-profile=jvm

echo "*****************************************************************************"
docker rmi istio-demo/recommendation-api:v2
docker rmi quay.io/naveenkendyala/istio-demo-recommendation-api:v2
docker build -f src/main/build/docker/Dockerfile.jvm -t istio-demo/recommendation-api:v2 .; 

echo "*****************************************************************************"
docker tag istio-demo/recommendation-api:v2 quay.io/naveenkendyala/istio-demo-recommendation-api:v2; 

echo "*****************************************************************************"
docker push quay.io/naveenkendyala/istio-demo-recommendation-api:v2
