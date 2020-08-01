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
## Set Up JAX-RS Based Quarkus Project
## Add opentracing, smallrye, health check, rest client extensions
## Add Interface to the Preference using "Micro Profile"
## Register the PreferenceService
## Add BaggageHeaderFactory to setup addintional header properties to be transferred
## Register the Headers in Preference Service
## Add Jaeger Properties to the Quarkus Properties for the header properties propagation
## Add Exception handling for the Preference Service
## 

## ------------------------------------------------------------------------------------------------------------------------------------------------


## ------------------------------------------------------------------------------------------------------------------------------------------------

## ------------------------------------------------------------------------------------------------------------------------------------------------

## ------------------------------------------------------------------------------------------------------------------------------------------------

## ------------------------------------------------------------------------------------------------------------------------------------------------