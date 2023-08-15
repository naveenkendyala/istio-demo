#/bin/bash
#Quarkus Version
VERSION=v2

./mvnw clean package -Dquarkus-profile=jvm

# Clean up
echo "*****************************************************************************"
podman rmi istio-demo/customer:${VERSION}
podman rmi quay.io/naveenkendyala/istio-demo-customer:${VERSION}

# Build, Tag and Push
echo "*****************************************************************************"
podman build --no-cache --layers=false -f src/main/build/docker/Dockerfile.jvm -t istio-demo/customer:${VERSION} .; 
podman tag istio-demo/customer:${VERSION} quay.io/naveenkendyala/istio-demo-customer:${VERSION}; 
podman push quay.io/naveenkendyala/istio-demo-customer:${VERSION}