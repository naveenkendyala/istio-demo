#/bin/bash
# Pakage the Application
./mvnw clean package -Dquarkus-profile=jvm

# Clean up
echo "*****************************************************************************"
docker rmi istio-demo/preference:v1
docker rmi quay.io/naveenkendyala/istio-demo-preference:v1

# Build, Tag and Push
echo "*****************************************************************************"
docker build -f src/main/build/docker/Dockerfile.jvm -t istio-demo/preference:v1 .; 
docker tag istio-demo/preference:v1 quay.io/naveenkendyala/istio-demo-preference:v1; 
docker push quay.io/naveenkendyala/istio-demo-preference:v1
