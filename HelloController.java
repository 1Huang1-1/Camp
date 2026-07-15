package com.example.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    private static final Logger log = LoggerFactory.getLogger(HelloController.class);

    @GetMapping("/hello")
    public String hello(@RequestParam(defaultValue = "锁哥") String name) {
        log.info("Received hello request with name: {}", name);
        String greeting = "Hello, " + name + "！这是我给你搭的 Spring Boot 项目 😄";
        log.debug("Response: {}", greeting);
        return greeting;
    }

    @GetMapping("/")
    public String index() {
        log.info("Root endpoint accessed");
        return "Spring Boot 项目启动成功！试试访问 /hello?name=一一";
    }
}
