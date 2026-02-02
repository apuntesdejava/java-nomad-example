package com.apuntesdejava.nomadexample.resources;

import jakarta.json.Json;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Response;

import static jakarta.ws.rs.core.MediaType.APPLICATION_JSON;

@Path("hello")
@Produces(APPLICATION_JSON)
public class HelloResource {

    @GET
    public Response hello(){
        var response = Json.createObjectBuilder()
            .add("message","hello")
            .build();
        return Response.ok(response).build();
    }
}
