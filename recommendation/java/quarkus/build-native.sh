#/bin/bash
./mvnw clean package -Pnative -Dquarkus.profile=native -Dquarkus.native.container-build=true -Dquarkus.native.container-runtime=docker

echo "*****************************************************************************"
docker rmi istio-demo/recommendation:$1
docker rmi quay.io/naveenkendyala/istio-demo-recommendation:$1
docker build -f src/main/build/docker/Dockerfile.jvm -t istio-demo/recommendation:$1 .; 


echo "*****************************************************************************"
docker tag istio-demo/recommendation:$1 quay.io/naveenkendyala/istio-demo-recommendation:$1; 


echo "*****************************************************************************"
docker push quay.io/naveenkendyala/istio-demo-recommendation:$1
