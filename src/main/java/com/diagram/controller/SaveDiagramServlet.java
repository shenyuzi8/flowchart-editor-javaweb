package com.diagram.controller;

import com.diagram.dao.DiagramDao;
import com.diagram.model.Diagram;
import com.diagram.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/saveDiagram")
public class SaveDiagramServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.getWriter().write("no_login");
            return;
        }

        String title = request.getParameter("title");
        String type = request.getParameter("type");
        String content = request.getParameter("content");

        DiagramDao dao = new DiagramDao();
        Diagram d = new Diagram(user.getId(), title, type, content);
        boolean ok = dao.save(d);
        response.getWriter().write(ok ? "success" : "fail");
    }
}