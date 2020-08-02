package com.demo.controller;

import java.util.List;


import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;


import com.demo.entity.ToDo;
import com.demo.service.ToDoService;

import org.eclipse.microprofile.config.inject.ConfigProperty;

@Path("/")
public class ToDoResource {

    //Get the Version from Properties
    @ConfigProperty(name="custom.version.message")
    String versionMessage;


    @Inject
    ToDoService todoService;

    @GET
    @Path("/todos")
    @Produces(MediaType.APPLICATION_JSON)
    public List<ToDo> getToDos(){
        return todoService.listToDos();
    }

    //This method is for the Service Mesh Implementation
    @GET
    @Path("/recommendation")
    @Produces(MediaType.TEXT_PLAIN)
    public String getToDoString(){

        List<ToDo> list = todoService.listToDos();
        return versionMessage+ " : ["+list.get(0).getId()+" : "+list.get(0).getTask()+" : "+ list.get(0).getIsComplete()+"]";

    }    
}