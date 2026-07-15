package com.example.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class DemoApplication {

	private static final Logger log = LoggerFactory.getLogger(DemoApplication.class);

	public static void main(String[] args) {
		ConfigurableApplicationContext context = SpringApplication.run(DemoApplication.class, args);
		String[] activeProfiles = context.getEnvironment().getActiveProfiles();
		String profiles = activeProfiles.length == 0 ? "default" : String.join(",", activeProfiles);
		log.info("Demo application is running normally. Active profiles: {}", profiles);
	}
}
