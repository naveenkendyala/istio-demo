package com.demo.service;

import java.util.List;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import javax.transaction.Transactional;

import com.demo.entity.ToDo;

@ApplicationScoped
public class ToDoService {

    @Inject
    EntityManager em;

    @Transactional
    public void upsertToDo(ToDo todo) {
        em.merge(todo);
    }

    @Transactional
    public List<ToDo> listToDos() {
        TypedQuery<ToDo> query = em.createQuery("SELECT t FROM ToDo t", ToDo.class);
        return query.getResultList();
    }

}