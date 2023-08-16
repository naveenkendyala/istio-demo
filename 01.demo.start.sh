#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37
# Start the Demo
read -p $'\e[32m**** Lets Start the Demo **** \e[0m'

read -p $'\e[32m[STEP-01: Create the istio-demo project] \e[0m: '
# Create istio-demo project
oc new-project istio-demo
oc project istio-demo

# Override (if needed) to run containers as root
oc adm policy add-scc-to-user anyuid -z default -n istio-demo > /dev/null

read -p $'\e[32m[STEP-02: Deploy Customer Pods, Service] \e[0m: '
# Change to the Custmer Project
# Deploy Customer Pod
oc apply -f customer/java/quarkus/src/main/deployments/ocp.jvm/01.deployment.yaml

# Deploy Service
oc apply -f customer/java/quarkus/src/main/deployments/ocp.jvm/02.service.yaml

read -p $'\e[32m[STEP-03: Create Ingress Gateway and Virtual Service for Customer Pods] \e[0m: '
# Deploy Gateway for Incoming Traffic
# A Gateway is an Entry point to the Cluster
oc apply -f customer/java/quarkus/src/main/deployments/ocp.jvm/03.Gateway.yml

# Deploy Virtual Service that ties the "Gateway" and the "Actual Service" Abstractions
# Contains Rules for matching these patterns
# More than one rule can be created if needed
# A virtual service is a Kubernetes custom resource, which allows you to configure how the requests to services in the Service Mesh are routed.
oc apply -f customer/java/quarkus/src/main/deployments/ocp.jvm/04.VirtualService.yml

read -p $'\e[32m[STEP-04: export GATEWAY_URL=$(oc get route istio-ingressgateway -n istio-system -o yaml | yq ".spec.host")] \e[0m: '
# Get Gateway Information
# Istio Ingress Gateway is Exposed via a Route to the OpenShift. Get the information
export GATEWAY_URL=$(oc get route istio-ingressgateway -n istio-system -o yaml | yq ".spec.host")
echo "GATEWAY_URL=[http://"$GATEWAY_URL"]"

# Invoke the Istio Ingress Gateway Endpoint
#curl $GATEWAY_URL/customer


read -p $'\e[32m[STEP-05: Deploy Preference Pods, Service] \e[0m: '
# Change to the Preference Project
# Deploy Preference Pod
oc apply -f preference/java/quarkus/src/main/deployments/ocp.jvm/01.deployment.yaml

# Deploy Preference Service
oc apply -f preference/java/quarkus/src/main/deployments/ocp.jvm/02.service.yaml

read -p $'\e[32m[STEP-06: Deploy Recommendation Pods, Service - V1 Version] \e[0m: '
# Change to the Recommendation Project
# Deploy Recommendation Pod : V1
oc apply -f recommendation/java/quarkus/src/main/deployments/ocp.jvm/01.deployment-v1.yaml

# Deploy Recommendation Service : V1
oc apply -f recommendation/java/quarkus/src/main/deployments/ocp.jvm/02.service.yaml

read -p $'\e[32m[STEP-07: Deploy Recommendation Pods, Service - V2 Version] \e[0m: '
# Make Changes to Recommendation : For V2
# Modifying the message
# Deploy Recommendation Pod : V2
oc apply -f recommendation/java/quarkus/src/main/deployments/ocp.jvm/03.deployment-v2.yaml

# Change the replicas of V2 to 2 and showcase the routing
#oc scale --replicas=2 deployment/recommendation-v2 -n istio-demo

# Scale it back to 1 instance
#oc scale --replicas=1 deployment/recommendation-v2 -n istio-demo