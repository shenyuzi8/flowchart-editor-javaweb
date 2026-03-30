package com.diagram.dao;

import com.diagram.model.Diagram;
import com.diagram.utils.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DiagramDao {

    // 保存流程图
    public boolean save(Diagram d) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "INSERT INTO diagram(user_id, title, type, content) VALUES(?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, d.getUserId());
            ps.setString(2, d.getTitle());
            ps.setString(3, d.getType());
            ps.setString(4, d.getContent());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 根据ID查询流程图（返回完整的 Diagram 对象，包含 id）
    public Diagram getDiagramById(int id) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT id, user_id, title, type, content FROM diagram WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Diagram d = new Diagram(
                        rs.getInt("user_id"),
                        rs.getString("title"),
                        rs.getString("type"),
                        rs.getString("content")
                );
                // 如果 Diagram 类有 setId 方法，可以设置 id
                // 这里假设 Diagram 类提供了 setId 方法，如果未提供则注释掉
                // d.setId(rs.getInt("id"));
                return d;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 查询当前用户的所有流程图（下拉框列表）
    public String getDiagramListByUserId(int userId) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT id, title FROM diagram WHERE user_id=? ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                String title = rs.getString("title");
                if (title == null) title = "未命名";
                title = title.replace("\\", "\\\\").replace("\"", "\\\"");

                json.append("{\"id\":")
                        .append(rs.getInt("id"))
                        .append(",\"title\":\"")
                        .append(title)
                        .append("\"}");
                first = false;
            }
            json.append("]");
            return json.toString();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "[]";
    }

    // 删除流程图（新增方法）
    public boolean deleteDiagramById(int id) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "DELETE FROM diagram WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}