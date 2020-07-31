package com.demo.controller;

import java.util.List;


import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.demo.entity.ToDo;
import com.demo.service.ToDoService;

@Path("/")
public class ToDoResource {

    @Inject
    ToDoService todoService;

    @GET
    @Path("/todos")
    @Produces(MediaType.APPLICATION_JSON)
    public List<ToDo> getToDos(){
        return todoService.listToDos();
    }
    

    
    
}