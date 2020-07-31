package com.demo.entity;

import javax.persistence.Entity;
import javax.persistence.Id;


@Entity
public class ToDo {

    @Id
    private String id;
    private String task;
    private String isComplete;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTask() {
        return task;
    }

    public void setTask(String task) {
        this.task = task;
    }

    public String getIsComplete() {
        return isComplete;
    }

    public void setIsComplete(String isComplete) {
        this.isComplete = isComplete;
    }

   
}