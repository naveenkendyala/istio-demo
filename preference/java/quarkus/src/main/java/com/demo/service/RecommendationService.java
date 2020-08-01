package com.demo.service;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

import org.eclipse.microprofile.rest.client.annotation.RegisterClientHeaders;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;


@RegisterClientHeaders(BaggageHeadersFactory.class)
@RegisterRestClient
public interface RecommendationService {

    @Path("/recommendation")
    @GET
    @Produces("text/plain")
    public String getRecommendation();

}