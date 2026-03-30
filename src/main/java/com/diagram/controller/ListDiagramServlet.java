package com.diagram.controller;

import com.diagram.dao.DiagramDao;
import com.diagram.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/listDiagram")
public class ListDiagramServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.getWriter().write("[]");
            return;
        }

        String json = new DiagramDao().getDiagramListByUserId(user.getId());
        if (json == null || json.isEmpty()) {
            json = "[]";
        }
        response.getWriter().write(json);
    }
}