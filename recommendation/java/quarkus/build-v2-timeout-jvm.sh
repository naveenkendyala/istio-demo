#/bin/bash
# Pakage the Application
./mvnw clean package -Dquarkus-profile=jvm

# Clean up
echo "*****************************************************************************"
docker rmi istio-demo/recommendation:v2-timeout
docker rmi quay.io/naveenkendyala/istio-demo-recommendation:v2-timeout

# Build, Tag and Push
echo "*****************************************************************************"
docker build -f src/main/build/docker/Dockerfile.jvm -t istio-demo/recommendation:v2-timeout .; 
docker tag istio-demo/recommendation:v2-timeout quay.io/naveenkendyala/istio-demo-recommendation:v2-timeout; 
docker push quay.io/naveenkendyala/istio-demo-recommendation:v2-timeout
