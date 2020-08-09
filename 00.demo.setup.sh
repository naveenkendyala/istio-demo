## ------------------------------------------------------------------------------------------------------------------------------------------------
## 01. Install Operators : From the Web Console
## Starting with Red Hat OpenShift Service Mesh 1.1.4 requires Elastic Search, Jaeger and Kiali Operators before installing Service Mesh Operator
## Must have cluster admin privileges
## Select the installation to be stable channel and in all “namespaces"
  # Elastic Search 	: Red Hat [DO NOT Change the target namespaces]
  # Jaeger 		      : Red Hat [Install at the Cluster Level]
  # Kiali 			    : Red Hat [Install at the Cluster Level]
  # Service Mesh	  : Red Hat [Install at the Cluster Level]

## ------------------------------------------------------------------------------------------------------------------------------------------------
## 02. Install Control Plane in a separate project
  # Ensure you are in the  project "istio-demo" directory
  # https://docs.openshift.com/container-platform/4.3/service_mesh/service_mesh_install/preparing-ossm-installation.html
  # create istio-system project
  oc new-project istio-system

  # Install the insto-default 
  oc create -n istio-system -f installation/01.istio-installation.yaml

  # For customization; refer to the below
  # https://docs.openshift.com/container-platform/4.3/service_mesh/service_mesh_install/customizing-installation-ossm.html

  # Check on the service mesh control plane
  oc get smcp -n istio-system

## ------------------------------------------------------------------------------------------------------------------------------------------------
## 03. Add your projects to the Control Plane : ServiceMeshMemberRoll
## Option#01
  # Create a “ServiceMeshMember” in individual projects and reference that to the "ServiceMeshControlPlane"
## Option#02
  # One project can belong to only one ServiceMeshMemberRoll
  # Log Into the namespace where the ServiceMeshControlPlane is installed [Ex: Istio-system]
  # Create ServiceMeshMemberRoll named “default” in same project as “ServiceMeshControlPlane”
  oc create -n istio-system -f installation/02.servicemeshmemberroll-default.yaml
## ------------------------------------------------------------------------------------------------------------------------------------------------

## 04. SETUP DEMO

  # Create istio-demo project
  oc new-project istio-demo

  # Override (if needed) to run containers as root
  # oc adm policy add-scc-to-user anyuid -z default -n istio-demo


  # Change to the Custmer Project
  # Deploy Customer Pod
  oc apply -f src/main/deployments/ocp.jvm/01.deployment.yaml

  # Deploy Service
  oc apply -f src/main/deployments/ocp.jvm/02.service.yaml

  # Deploy Gateway for Incoming Traffic
  # A Gateway is an Entry point to the Cluster
  oc apply -f src/main/deployments/ocp.jvm/03.Gateway.yml


  # Deploy Virtual Service that ties the "Gateway" and the "Actual Service" Abstractions
  # Contains Rules for matching these patterns
  # More than one rule can be created if needed
  # A virtual service is a Kubernetes custom resource, which allows you to configure how the requests to services in the Service Mesh are routed.
  oc apply -f src/main/deployments/ocp.jvm/04.VirtualService.yml

  # Get Gateway Information
  # Istio Ingress Gateway is Exposed via a Route to the OpenShift. Get the information
  export GATEWAY_URL=$(oc get route istio-ingressgateway -n istio-system -o yaml | yq r - "spec.host")

  # Invoke the Istio Ingress Gateway Endpoint
  curl $GATEWAY_URL/customer

  # Change to the Preference Project
  # Deploy Preference Pod
  oc apply -f src/main/deployments/ocp.jvm/01.deployment.yaml

  # Deploy Preference Service
  oc apply -f src/main/deployments/ocp.jvm/02.service.yaml

  # Change to the Preference Project
  # Deploy Recommendation Pod : V1
  oc apply -f src/main/deployments/ocp.jvm/01.deployment-v1.yaml

  # Deploy Recommendation Service : V1
  oc apply -f src/main/deployments/ocp.jvm/02.service.yaml

  # Make Changes to Recommendation : For V2
  # Modifying the message
  # Deploy Recommendation Pod : V2
  oc apply -f src/main/deployments/ocp.jvm/03.deployment-v2.yaml

  # Change the replicas of V2 to 2 and showcase the routing
  oc scale --replicas=2 deployment/recommendation-v2 -n istio-demo

  # Scale it back to 1 instance
  oc scale --replicas=1 deployment/recommendation-v2 -n istio-demo

### ------------------------------------------------------------------------------------------------------------------------------------------------
  # SIMPLE ROUTING DEMO

  # *** DESTINATION RULES ***
  # Destination rules are custom resources that define policies that apply to the traffic of a service
  # Using those traffic policies, you can configure the load balancing behavior to distribute traffic between the instances of a service.
  # Virtual services route traffic to a specific destination, and destination rules operate in the traffic routed to that destination.
  # The policies defined in destination rules are applied after the routing rules in the virtual services are evaluated
  # With destination rules you can define load balancing, connection limits, and outlier detection policies.
  # Load Balancing Traffic
  # With destination rules, you can specify the strategy used to distribute traffic between the instances of a service.
  # Round-robin   : Requests are sent to each service instance in turn.
  # Random        : Requests are sent to the service instances randomly.
  # Weighted      : Request are sent to the service instances according to a specific weight (percentage).
  # Least request : Requests are sent to the least busy service instances.

  # Lets Scale recommendation-v2 to 0 instance
  oc scale --replicas=0 deployment/recommendation-v2 -n istio-demo

  oc apply -f demo/01.traffic.control/01.blue.green.release/01.destination-rule-recommendation-v1-v2.yml

  # *** VIRTUAL SERVICE & Destination Rules
  # Route Traffic to the Version 2 of the Recommendation
  # === Show the Kiali Dashboard for the change in the icons
  oc apply -f demo/01.traffic.control/01.blue.green.release/03.virtual-service-recommendation-v1.yml
  
  # Lets Scale recommendation-v2 to 1 instance
  oc scale --replicas=1 deployment/recommendation-v2 -n istio-demo

  # *** REPLACE **** with the next one
  oc replace -f demo/01.traffic.control/01.blue.green.release/02.virtual-service-recommendation-v2.yml

  # DELETE THE Virtual Service
  # This should take the traffic back to V1 and V2
  # === Show the Kiali Dashboard for the change in the icons

  # Clean UP : Delete the Virtual Service & Destination Rule
  oc delete -f demo/01.traffic.control/01.blue.green.release/03.virtual-service-recommendation-v1.yml
  oc delete -f demo/01.traffic.control/01.blue.green.release/01.destination-rule-recommendation-v1-v2.yml
  

### ------------------------------------------------------------------------------------------------------------------------------------------------
  # CANARY RELEASES
  # Previous deployments did a 50% to 50% traffic or 100% traffic to one versions
  # How about we want to experiment on a certain traffic based on % volume

  # Scale it back to 0 instance
  oc scale --replicas=0 deployment/recommendation-v2 -n istio-demo

  oc apply -f demo/01.traffic.control/02.canary.release/01.destination-rule-recommendation-v1-v2.yml
  oc apply -f demo/01.traffic.control/02.canary.release/02.virtual-service-recommendation-v1.yml
  # Scale it back to 1 instance
  oc scale --replicas=1 deployment/recommendation-v2 -n istio-demo
  oc replace -f demo/01.traffic.control/02.canary.release/03.virtual-service-recommendation-v1_and_v2_90_10.yml
  oc replace -f demo/01.traffic.control/02.canary.release/04.virtual-service-recommendation-v1_and_v2_50_50.yml
  oc replace -f demo/01.traffic.control/02.canary.release/05.virtual-service-recommendation-v1_and_v2_0_100.yml

  # Clean UP : Delete Destiation Rule & Virtual Service
  oc delete -f demo/01.traffic.control/02.canary.release/05.virtual-service-recommendation-v1_and_v2_0_100.yml
  oc delete -f demo/01.traffic.control/02.canary.release/01.destination-rule-recommendation-v1-v2.yml

### ------------------------------------------------------------------------------------------------------------------------------------------------
  # USER-AGENT Release
  oc apply -f demo/01.traffic.control/03.user.agent.release/01.destination-rule-recommendation-v1-v2.yml
  oc apply -f demo/01.traffic.control/03.user.agent.release/02.virtual-service-recommendation-v1.yml

  # Set the Safari Users to go to Recommendation V2
  # Everyone else default to Recommendation V1
  oc replace -f demo/01.traffic.control/03.user.agent.release/03.virtual-service-safari-recommendation-v2.yml

  # Run CURL with  -A option to simulate user-agent
  # Alternatively run with Safari / Chrome
  curl -A Safari $GATEWAY_URL/customer;

  # One can modify the Rule to contain "Mobile" and we can target the services for specific frontends

  # CleanUp
  oc delete -f demo/01.traffic.control/03.user.agent.release/03.virtual-service-safari-recommendation-v2.yml
  oc delete -f demo/01.traffic.control/03.user.agent.release/01.destination-rule-recommendation-v1-v2.yml

### ------------------------------------------------------------------------------------------------------------------------------------------------
  # TRAFFIC MIRRORING
  # Continue to Serve Customers on a Specific Version but mirror the traffic to another version internally
  oc apply -f demo/01.traffic.control/04.traffic.mirroring/01.destination-rule-recommendation-v1-v2.yml
  oc apply -f demo/01.traffic.control/04.traffic.mirroring/02.virtual-service-recommendation-v1-mirror-v2.yml

  #CleanUP
  oc delete -f demo/01.traffic.control/04.traffic.mirroring/02.virtual-service-recommendation-v1-mirror-v2.yml
  oc delete -f demo/01.traffic.control/04.traffic.mirroring/01.destination-rule-recommendation-v1-v2.yml  

### ------------------------------------------------------------------------------------------------------------------------------------------------
  # RETRY
  # ISTIO does automatic retry of the requests if the service fails
  # The interval between retries (25ms+) is variable and determined automatically by Istio, preventing the called service from being overwhelmed with requests
  # The default retry behavior for HTTP requests is to retry twice before returning the error
  # To not overwhelm, one can define the retries and the time between the retries
  # Go to Recommendation V2 Terminal and execute the below command
  curl localhost:8080/misbehave

  # Show the Responses from V1
  # Show the Requests getting registered for V2 as well

  # Changing the default retries
  #oc apply -f demo/02.resiliency/01.retry/01.destination-rule-recommendation-v1-v2.yml
  #oc apply -f demo/02.resiliency/01.retry/02.virtual-service-recommendation-retry.yml  

  #oc delete -f demo/02.resiliency/01.retry/02.virtual-service-recommendation-retry.yml
  #oc delete -f demo/02.resiliency/01.retry/01.destination-rule-recommendation-v1-v2.yml

### ------------------------------------------------------------------------------------------------------------------------------------------------
  # TIMEOUT
  # Set the new timeout image for Recommendation V2
  oc set image deployment/recommendation-v2 recommendation=quay.io/naveenkendyala/istio-demo-recommendation:v2-timeout

  # Create a Virtual Service that will ignore
  oc apply -f demo/02.resiliency/02.timeout/01.virtual-service-recommendation-timeout.yml

  # Remove the Virtual Service
  oc delete -f demo/02.resiliency/02.timeout/01.virtual-service-recommendation-timeout.yml

  # Revert to the regular V2
  oc set image deployment/recommendation-v2 recommendation=quay.io/naveenkendyala/istio-demo-recommendation:v2

### ------------------------------------------------------------------------------------------------------------------------------------------------
  # CIRCUIT BREAKER
  # Send 40 Requests to Recommendation Service with Seige
  # 10 clients sending 4 concurrent requests each
  siege -r 10 -c 4 -v $GATEWAY_URL/customer

  # Go to Recommendation V2 Terminal and execute the below command
  # This should make all the messages going to Recommendation V2 fail
  curl localhost:8080/misbehave

  # Repeat : Send 40 Requests to Recommendation Service with Seige
  # 10 clients sending 4 concurrent requests each
  siege -r 10 -c 4 -v $GATEWAY_URL/customer

  oc apply -f demo/02.resiliency/03.circuit.breaker/01.destination-rule-recommendation-v1-v2.yml
  oc apply -f demo/02.resiliency/03.circuit.breaker/02.virtual-service-recommendation-v2.yml

  # Observe that the service did not fail
  # Circuit breaker and pool ejection are used to avoid reaching a failing pod for a specified amount of time
  # In this way when some consecutive errors are produced, the failing pod is ejected from eligible pods
  # Further requests are not sent anymore to that instance but to a healthy instance
  oc apply -f demo/02.resiliency/03.circuit.breaker/03.destination-rule-recommendation_cb_policy_version_v2.yml

  # 
  oc scale --replicas=2 deployment/recommendation-v2


### ------------------------------------------------------------------------------------------------------------------------------------------------
### ------------------------------------------------------------------------------------------------------------------------------------------------
### ------------------------------------------------------------------------------------------------------------------------------------------------
### ------------------------------------------------------------------------------------------------------------------------------------------------
