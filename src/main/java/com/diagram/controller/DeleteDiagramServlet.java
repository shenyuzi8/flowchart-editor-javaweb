package com.diagram.controller;

import com.diagram.dao.DiagramDao;
import com.diagram.model.Diagram;
import com.diagram.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/deleteDiagram")
public class DeleteDiagramServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.getWriter().write("未登录");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.getWriter().write("缺少ID");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.getWriter().write("ID格式错误");
            return;
        }

        DiagramDao dao = new DiagramDao();
        Diagram d = dao.getDiagramById(id);
        if (d == null) {
            response.getWriter().write("流程图不存在");
            return;
        }
        if (d.getUserId() != user.getId()) {
            response.getWriter().write("无权限删除");
            return;
        }

        boolean success = dao.deleteDiagramById(id);
        if (success) {
            response.getWriter().write("success");
        } else {
            response.getWriter().write("删除失败");
        }
    }
}