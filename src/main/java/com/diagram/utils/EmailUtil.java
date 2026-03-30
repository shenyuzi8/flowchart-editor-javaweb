package com.diagram.utils;
import java.util.Random;

public class EmailUtil {
    public static String sendCode(String to) {
        String code = String.format("%06d", new Random().nextInt(999999));
        System.out.println("邮箱验证码：" + code + " 接收邮箱：" + to);
        return code;
    }
}