package com.diagram.controller;

import com.diagram.utils.EmailUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/sendCode")
public class SendCodeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String code = EmailUtil.sendCode(email);
        request.getSession().setAttribute("code", code);
        response.getWriter().write("ok");
    }
}