package com.diagram.controller;

import com.diagram.dao.DiagramDao;
import com.diagram.model.Diagram;
import com.diagram.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/loadDiagramById")
public class LoadDiagramByIdServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"未登录\"}");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"缺少ID\"}");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"ID格式错误\"}");
            return;
        }

        Diagram d = new DiagramDao().getDiagramById(id);
        // 验证用户权限和内容有效性
        if (d != null && d.getUserId() == user.getId() && d.getContent() != null && !d.getContent().trim().isEmpty()) {
            // 手动拼接 JSON，转义特殊字符
            String title = escapeJson(d.getTitle());
            String content = escapeJson(d.getContent());
            String json = "{\"success\":true,\"title\":\"" + title + "\",\"content\":\"" + content + "\"}";
            response.getWriter().write(json);
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"流程图不存在或内容为空\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}