#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37
# Scale it back to 0 instance
read -p $'\e[32m[STEP-00] : Change to istio-demo project \e[0m'
oc project istio-demo

read -p $'\e[32m[STEP-01] : Lets Start with Recommendation V2 with 0 Instances \e[0m: '
oc scale --replicas=0 deployment/recommendation-v2 -n istio-demo

read -p $'\e[32m[STEP-02] : Apply Destination Rule and Virtual Service Definitions \e[0m: '
oc apply -f demo/02.resiliency/01.retry/01.destination-rule-recommendation-v1-v2.yml
oc apply -f demo/02.resiliency/01.retry/02.virtual-service-recommendation-retry.yml

# Scale it back to 1 instance
read -p $'\e[32m[STEP-03] : Lets Test this out and see if the service is retrying \e[0m: '
# oc scale --replicas=1 deployment/recommendation-v2 -n istio-demo

read -p $'\e[32m[STEP-04] :  Delete the Virtual Service and Destination Rule \e[0m: '
# Clean UP : Delete Destiation Rule & Virtual Service
oc delete -f demo/02.resiliency/01.retry/01.destination-rule-recommendation-v1-v2.yml
oc delete -f demo/02.resiliency/01.retry/02.virtual-service-recommendation-retry.yml