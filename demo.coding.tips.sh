## ------------------------------------------------------------------------------------------------------------------------------------------------
## 01. SET-UP
## Local Code Setup
## Deploying Customer Application
## Run Jaeger locally
docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HTTP_PORT=9411 \
  -p 5775:5775/udp \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 14268:14268 \
  -p 14250:14250 \
  -p 9411:9411 \
  jaegertracing/all-in-one:1.18

## Jaeger can be accessed in the below URL
http://localhost:1668

## ------------------------------------------------------------------------------------------------------------------------------------------------
## Customer Project
## GOALS
 # Create Customer Endpoint
 # Invoke Preference Service
 # Ensure tracing parameters are passed
 # Handle Exceptions if Preference is not available

## Set Up JAX-RS Based Quarkus Project
mvn io.quarkus:quarkus-maven-plugin:1.3.4.Final-redhat-00004:create \
    -DprojectGroupId=com.demo \
    -DprojectArtifactId=customer \
    -DplatformGroupId=com.redhat.quarkus \
    -DplatformArtifactId=quarkus-universe-bom \
    -DplatformVersion=1.3.4.Final-redhat-00004 \
    -DclassName="com.demo.CustomerResource" \
    -Dpath="/customer"

## Disable code in the Test Folders or Comment the test cases out
## Extensions:
 # Add opentracing, smallrye, health check, rest client extensions
## Add Interface to the Preference using "Micro Profile"
 # Properties : Add MP interface URL
## Register the PreferenceService
## Add BaggageHeaderFactory to setup addintional header properties to be transferred
 # https://www.whoishostingthis.com/tools/user-agent/
 # The "user-agent" header is added to OpenTracing baggage in the Customer service
 # From there it is automatically propagated to all downstream services
 # To enable automatic baggage propagation all intermediate services have to be instrumented with OpenTracing
 # The baggage header for user agent has following form baggage-user-agent: <value>.
## Register the Headers in Preference Service
## Add Jaeger Properties to the Quarkus Properties for the header properties propagation
## Add Exception handling for the Preference Service
## Build Project

## ------------------------------------------------------------------------------------------------------------------------------------------------

## ------------------------------------------------------------------------------------------------------------------------------------------------

## ------------------------------------------------------------------------------------------------------------------------------------------------

## ------------------------------------------------------------------------------------------------------------------------------------------------

## ------------------------------------------------------------------------------------------------------------------------------------------------