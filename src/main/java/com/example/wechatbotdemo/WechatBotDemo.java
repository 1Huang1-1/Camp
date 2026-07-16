package com.example.wechatbotdemo;

import com.openilink.ILinkClient;
import com.openilink.auth.LoginCallbacks;
import com.openilink.model.response.LoginResult;
import com.openilink.monitor.MonitorOptions;
import com.openilink.util.MessageHelper;

import java.util.concurrent.atomic.AtomicBoolean;

public class WechatBotDemo {
    public static void main(String[] args) {
        ILinkClient client = ILinkClient.builder()
                .token("")
                .build();

        // 扫码登录
        LoginResult result = client.loginWithQR(new LoginCallbacks() {
            @Override
            public void onQRCode(String url) {
                System.out.println("请扫码: " + url);
            }

            @Override
            public void onScanned() {
                System.out.println("已扫码，请在微信上确认...");
            }
        });

        if (!result.isConnected()) {
            System.err.println("登录失败");
            return;
        }
        System.out.println("已连接 BotID=" + result.getBotId());

        // 监听消息 & 自动回复
        AtomicBoolean stop = new AtomicBoolean(false);
        Runtime.getRuntime().addShutdownHook(new Thread(() -> stop.set(true)));

        client.monitor(msg -> {
            String text = MessageHelper.extractText(msg);
            if (text != null && !text.isEmpty()) {
                client.push(msg.getFromUserId(), "收到: " + text);
            }
        }, null, stop);
    }
}
