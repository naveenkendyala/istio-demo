package com.demo.resource;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.ProcessingException;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.demo.service.RecommendationService;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Path("/")
public class PreferenceResource {


    //Inbound Method for our Get Process
    @GET
    @Path("/preference")
    @Produces(MediaType.TEXT_PLAIN)
    public String getCustomer() {
        return "hello";

    }
}