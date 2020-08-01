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

## 04. Create demo project
## Create tutorial project & allow pods to be run as root
  # Create isttio-demo project
  oc new-project istio-demo

  # Override (if needed) to run containers as root
  # oc adm policy add-scc-to-user anyuid -z default -n istio-demo


## ------------------------------------------------------------------------------------------------------------------------------------------------
## ------------------------------------------------------------------------------------------------------------------------------------------------
## ------------------------------------------------------------------------------------------------------------------------------------------------
## ------------------------------------------------------------------------------------------------------------------------------------------------
## ------------------------------------------------------------------------------------------------------------------------------------------------
## ------------------------------------------------------------------------------------------------------------------------------------------------
