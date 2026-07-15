package com.youkeda.exercise.demolog;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@Slf4j
@SpringBootApplication
public class DemoLogApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoLogApplication.class, args);
        // 打印不同等级测试日志
        log.info("==== SpringBoot项目启动成功 ====");
        log.info("普通业务信息日志");
        log.warn("警告级别日志示例");
        log.error("错误级别日志示例");
        System.out.println("Hello World");
    }

}
