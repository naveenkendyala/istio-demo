# create istio-system project
read -p $'\e[31m [STEP-01] : Create istio-system project \e[0m: ' 
oc new-project istio-system

# Install the istio-default 
read -p $'\e[31m [STEP-02] : Install Istio and dependencies \e[0m: '
oc create -n istio-system -f installation/01.istio-installation.yaml

# Add istio-demo project
read -p $'\e[31m [STEP-03] : Add projects \e[0m: '
oc create -n istio-system -f installation/02.servicemeshmemberroll-default.yaml 