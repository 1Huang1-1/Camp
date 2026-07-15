package com.example.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 基于 SLF4J 的日志演示控制器。
 * <p>
 * 访问端点即可直观看到不同日志级别在控制台和 log 文件中的输出效果。
 * 日志文件位于项目根目录的 {@code logs/} 文件夹内。
 */
@RestController
public class LogDemoController {

    private static final Logger log = LoggerFactory.getLogger(LogDemoController.class);

    private int visitCount = 0;

    /**
     * 每级日志各输出一条。
     */
    @GetMapping("/log/demo")
    public String logDemo() {
        log.trace("这是一条 TRACE 日志 —— 级别最低，通常仅用于细粒度调试");
        log.debug("这是一条 DEBUG 日志 —— 开发期调试信息");
        log.info("这是一条 INFO 日志 —— 业务或系统关键节点");
        log.warn("这是一条 WARN 日志 —— 需要注意但不影响运行的问题");
        log.error("这是一条 ERROR 日志 —— 发生了错误");
        return "日志已输出，请查看控制台和 logs/ 目录下的日志文件";
    }

    /**
     * 模拟业务处理流程，展示真实场景下的日志运用。
     */
    @GetMapping("/log/process")
    public String simulateProcess(@RequestParam(defaultValue = "demo") String bizId) {
        log.info("=== 开始处理业务请求, bizId={} ===", bizId);

        try {
            // 阶段 1：校验
            log.debug("[校验阶段] 参数校验开始, bizId={}", bizId);
            if (bizId == null || bizId.isBlank()) {
                log.warn("[校验阶段] bizId 为空，使用默认值");
            }
            log.debug("[校验阶段] 校验通过");

            // 阶段 2：处理
            log.info("[处理阶段] 开始执行业务逻辑, bizId={}", bizId);
            visitCount++;
            log.debug("当前累计处理请求数: {}", visitCount);

            // 模拟耗时操作
            Thread.sleep(50);

            log.info("[处理阶段] 业务处理完成, bizId={}", bizId);

        } catch (Exception e) {
            log.error("[处理阶段] 业务处理异常, bizId={}", bizId, e);
            return "处理失败：" + e.getMessage();
        }

        log.info("=== 业务请求处理结束, bizId={} ===", bizId);
        return "处理完成，请查看日志";
    }

    /**
     * 返回当前的访问统计。
     */
    @GetMapping("/log/stats")
    public String stats() {
        log.debug("查询统计信息, 当前访问量={}", visitCount);
        return "当前累计处理请求数: " + visitCount;
    }
}
