## ------------------------------------------------------------------------------------------------------------------------------------------------
## 01. Install Operators : From the Web Console
## Starting with Red Hat OpenShift Service Mesh 1.1.4 requires Elastic Search, Jaeger and Kiali Operators before installing Service Mesh Operator
## Must have cluster admin privileges
## Select the installation to be stable channel and in all “namespaces"
  # Elastic Search 	: Red Hat
  # Jaeger 		      : Red Hat
  # Kiali 			    : Red Hat
  # Service Mesh	  : Red Hat

## ------------------------------------------------------------------------------------------------------------------------------------------------
## 02. Install Control Plane in a separate project
  # https://docs.openshift.com/container-platform/4.3/service_mesh/service_mesh_install/preparing-ossm-installation.html
  # create istio-system project
  oc new-project istio-system

  # Install the insto-default 
  oc create -n istio-system -f 01.istio-installation.yaml

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
  oc create -n istio-system -f 02.servicemeshmemberroll-default.yaml
## ------------------------------------------------------------------------------------------------------------------------------------------------

## 04. SETUP DEMO

  # Create istio-demo project
  oc new-project istio-demo

  # Override (if needed) to run containers as root
  # oc adm policy add-scc-to-user anyuid -z default -n istio-demo

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
  oc apply -f src/main/deployments/ocp.jvm/04.VirtualService.yml

  # Get Gateway Information
  # Istio Ingress Gateway is Exposed via a Route to the OpenShift. Get the information
  export GATEWAY_URL=$(oc get route istio-ingressgateway -n istio-system -o yaml | yq r - "spec.host")

  # Invoke the Istio Ingress Gateway Endpoint
  curl $GATEWAY_URL/customer

  # Deploy Preference Pod
  oc apply -f src/main/deployments/ocp.jvm/01.deployment.yaml

  # Deploy Preference Service
  oc apply -f src/main/deployments/ocp.jvm/02.service.yaml

  # Deploy Recommendation Pod : V1
  oc apply -f src/main/deployments/ocp.jvm/01.deployment.yaml

  # Deploy Recommendation Service : V1
  oc apply -f src/main/deployments/ocp.jvm/02.service.yaml

  # Make Changes to Recommendation : For V2
  # Modifying the message and adding a timeout
  # Deploy



## ------------------------------------------------------------------------------------------------------------------------------------------------


## ------------------------------------------------------------------------------------------------------------------------------------------------
## ------------------------------------------------------------------------------------------------------------------------------------------------
## ------------------------------------------------------------------------------------------------------------------------------------------------
## ------------------------------------------------------------------------------------------------------------------------------------------------
## ------------------------------------------------------------------------------------------------------------------------------------------------
