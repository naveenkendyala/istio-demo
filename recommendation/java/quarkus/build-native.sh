#/bin/bash
./mvnw clean package -Pnative -Dquarkus.profile=native -Dquarkus.native.container-build=true -Dquarkus.native.container-runtime=docker

echo "*****************************************************************************"
docker rmi istio-demo/recommendation:v3
docker rmi quay.io/naveenkendyala/istio-demo-recommendation:v3
docker build -f src/main/build/docker/Dockerfile.native -t istio-demo/recommendation:v3 .; 

echo "*****************************************************************************"
docker tag istio-demo/recommendation:v2 quay.io/naveenkendyala/istio-demo-recommendation:v3; 

echo "*****************************************************************************"
docker push quay.io/naveenkendyala/istio-demo-recommendation:v3
