package com.demo.resource;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.demo.service.RecommendationService;

import org.eclipse.microprofile.rest.client.inject.RestClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Path("/")
public class PreferenceResource {

    private static final String RESPONSE_STRING_FORMAT = "Preference => %s\n";
    private final Logger logger = LoggerFactory.getLogger(getClass());


    @Inject
    @RestClient
    RecommendationService recommendationService;

    
    // Inbound Method for our Get Process
    @GET
    @Path("/preference")
    @Produces(MediaType.TEXT_PLAIN)
    public Response getPreference() {

        try {
            // Get the Reponse and Send
            String response = recommendationService.getRecommendation();
            return Response.ok(String.format(RESPONSE_STRING_FORMAT, response)).build();
            
        } catch (WebApplicationException ex) {

            //This exception is caused when the service is present but the application behind the service is not running
            //This is the Top level Exception for JAX-RS Applications
            Response response = ex.getResponse();
            logger.warn("Non HTTP 20x trying to get the response from Recommendation Service: " + response.getStatus());

            return Response.status(Response.Status.SERVICE_UNAVAILABLE)
                    .entity(String.format(RESPONSE_STRING_FORMAT,
                            String.format("Error: %d - %s", response.getStatus(), response.readEntity(String.class))))
                    .build();

        } catch (Exception pException) {

            //Log the Exception Details
            logger.warn("Exception trying to get the response from Recommendation Service.", pException);


            //Format the Response to Include the Path and the Exception Details
            return Response
                    .status(Response.Status.SERVICE_UNAVAILABLE)
                    .entity(String.format(RESPONSE_STRING_FORMAT,pException.getCause().getClass().getSimpleName()+" ["+pException.getCause().getMessage()+"]"))
                    .build();
        }
    }
}