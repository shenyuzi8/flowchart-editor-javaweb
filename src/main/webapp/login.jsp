<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>流程图编辑器 - 登录</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2), 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 40px 32px;
            width: 100%;
            max-width: 420px;
            backdrop-filter: blur(2px);
            transition: transform 0.2s ease;
        }

        .login-card:hover {
            transform: translateY(-4px);
        }

        .logo {
            text-align: center;
            margin-bottom: 28px;
        }

        .logo h2 {
            font-size: 28px;
            color: #333;
            letter-spacing: 1px;
            font-weight: 600;
        }

        .logo p {
            color: #7f8c8d;
            font-size: 14px;
            margin-top: 8px;
        }

        .input-group {
            margin-bottom: 24px;
            position: relative;
        }

        .input-group label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #2c3e50;
            margin-bottom: 6px;
        }

        .input-group input {
            width: 100%;
            padding: 12px 16px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 12px;
            outline: none;
            transition: all 0.3s ease;
            background-color: #f9fafb;
        }

        .input-group input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            background-color: #fff;
        }

        .login-btn {
            width: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 8px;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        .login-btn:active {
            transform: translateY(0);
        }

        .extra-links {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            font-size: 14px;
        }

        .extra-links a {
            color: #667eea;
            text-decoration: none;
            transition: color 0.2s;
        }

        .extra-links a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        .divider {
            margin: 24px 0 16px;
            text-align: center;
            position: relative;
        }

        .divider::before,
        .divider::after {
            content: '';
            position: absolute;
            top: 50%;
            width: calc(50% - 60px);
            height: 1px;
            background-color: #e2e8f0;
        }

        .divider::before {
            left: 0;
        }

        .divider::after {
            right: 0;
        }

        .divider span {
            background-color: #fff;
            padding: 0 12px;
            color: #94a3b8;
            font-size: 13px;
        }

        .register-link {
            text-align: center;
            margin-top: 12px;
        }

        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }

        .footer {
            text-align: center;
            margin-top: 28px;
            font-size: 12px;
            color: #94a3b8;
        }

        @media (max-width: 480px) {
            .login-card {
                padding: 32px 24px;
            }
        }
    </style>
</head>
<body>
<div class="login-card">
    <div class="logo">
        <h2>📐 流程图编辑器</h2>
        <p>登录以同步云端流程图</p>
    </div>

    <form id="loginForm" onsubmit="return false;">
        <div class="input-group">
            <label>📧 邮箱</label>
            <input type="email" id="email" placeholder="请输入注册邮箱" autocomplete="email" required>
        </div>
        <div class="input-group">
            <label>🔒 密码</label>
            <input type="password" id="pwd" placeholder="请输入密码" autocomplete="current-password" required>
        </div>
        <button type="submit" class="login-btn" onclick="login()">登 录</button>
    </form>

    <div class="extra-links">
        <a href="#" id="forgotPwdLink">忘记密码？</a>
        <a href="register.jsp">还没有账号？去注册</a>
    </div>

    <div class="footer">
        ✨ 使用邮箱和密码登录
    </div>
</div>

<script>
    function login() {
        const email = document.getElementById("email").value.trim();
        const pwd = document.getElementById("pwd").value;

        // 简单前端校验
        if (!email) {
            alert("请输入邮箱地址");
            return;
        }
        if (!pwd) {
            alert("请输入密码");
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/login", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send("email=" + encodeURIComponent(email) + "&password=" + encodeURIComponent(pwd));
        xhr.onload = function() {
            if (xhr.responseText === "success") {
                location.href = "/";
            } else {
                alert("账号或密码错误");
            }
        };
        xhr.onerror = function() {
            alert("网络错误，请稍后重试");
        };
    }

    // 支持回车键提交
    document.getElementById("loginForm").addEventListener("keypress", function(e) {
        if (e.key === "Enter") {
            login();
        }
    });

    // 忘记密码的临时提示（根据实际后端实现可调整）
    document.getElementById("forgotPwdLink").addEventListener("click", function(e) {
        e.preventDefault();
        alert("请联系管理员重置密码。");
    });
</script>
</body>
</html>