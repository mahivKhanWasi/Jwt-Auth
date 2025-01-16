package com.backend.backend.presenter.api;


import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
public class UserController {


    @GetMapping()
    public ResponseEntity<?> g(){
        return ResponseEntity.ok("Hi");
    }
}
