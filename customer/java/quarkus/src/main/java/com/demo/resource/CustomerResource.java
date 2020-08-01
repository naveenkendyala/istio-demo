package com.demo.resource;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.demo.service.PreferenceService;

import org.eclipse.microprofile.rest.client.inject.RestClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Path("/")
public class CustomerResource {

    //Create the output foramat
    private static final String RESPONSE_STRING_FORMAT = "Customer => %s\n";
    private final Logger logger = LoggerFactory.getLogger(getClass());


    //Inject the Rest Client
    @Inject
    @RestClient
    PreferenceService preferenceService;

    //Inbound Method for our Get Process
    @GET
    @Path("/customer")
    @Produces(MediaType.TEXT_PLAIN)
    public Response getCustomer() {
        try {

            //Get the Response From Preference Service Call
            String response = preferenceService.getPreference().trim();

            //Returning the Response From the Preferencxe Call
            return Response.ok(String.format(RESPONSE_STRING_FORMAT, response)).build();

        }catch(Exception pException){
            
            //Log the Exception Details
            logger.warn("Exception trying to get the response from preference service.", pException);

            //Format the Response to Include the Path and the Exception Details
            return Response
                    .status(Response.Status.SERVICE_UNAVAILABLE)
                    .entity(String.format(RESPONSE_STRING_FORMAT,pException.getCause().getClass().getSimpleName()+" ["+pException.getCause().getMessage()+"]"))
                    .build();
        }

        // } catch (WebApplicationException ex) {
        //     Response response = ex.getResponse();
        //     logger.warn("Non HTTP 20x trying to get the response from preference service: " + response.getStatus());
        //     return Response.status(Response.Status.SERVICE_UNAVAILABLE)
        //             .entity(String.format(RESPONSE_STRING_FORMAT,
        //                     String.format("Error: %d - %s", response.getStatus(), response.readEntity(String.class))))
        //             .build();
        // } catch (ProcessingException ex) {
        //     logger.warn("Exception trying to get the response from preference service.", ex);
        //     return Response.status(Response.Status.SERVICE_UNAVAILABLE).entity(String.format(RESPONSE_STRING_FORMAT,
        //             ex.getCause().getClass().getSimpleName() + ": " + ex.getCause().getMessage())).build();
        // }
    }
}