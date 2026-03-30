package com.diagram.dao;
import com.diagram.model.User;
import com.diagram.utils.DBUtil;
import java.sql.*;

public class UserDao {
    public User login(String email, String password) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM user WHERE email=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setEmail(rs.getString("email"));
                u.setPassword(rs.getString("password"));
                return u;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean register(User user) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "INSERT INTO user(email,password) VALUES(?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}