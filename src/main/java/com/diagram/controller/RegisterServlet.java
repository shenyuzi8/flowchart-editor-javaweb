package com.diagram.controller;

import com.diagram.dao.UserDao;
import com.diagram.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String code = request.getParameter("code");
        String sessionCode = (String) request.getSession().getAttribute("code");

        System.out.println("前端验证码：" + code);
        System.out.println("session验证码：" + sessionCode);

        if (code == null || sessionCode == null || !code.equals(sessionCode)) {
            response.getWriter().write("code_err");
            return;
        }

        UserDao userDao = new UserDao();
        boolean ok = userDao.register(new User(email, password));

        System.out.println("注册结果：" + ok);

        if (ok) {
            // 注册成功，自动登录：查询刚刚注册的用户并存入 session
            User newUser = userDao.login(email, password);
            if (newUser != null) {
                request.getSession().setAttribute("user", newUser);
            }
            response.getWriter().write("success");
        } else {
            response.getWriter().write("fail");
        }
    }
}