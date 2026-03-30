<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>流程图编辑器 - 注册</title>
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

        .register-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2), 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 40px 32px;
            width: 100%;
            max-width: 420px;
            backdrop-filter: blur(2px);
            transition: transform 0.2s ease;
        }

        .register-card:hover {
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

        .code-group {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .code-group input {
            flex: 1;
        }

        .code-btn {
            padding: 12px 16px;
            background: #e2e8f0;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 500;
            color: #4a5568;
            cursor: pointer;
            transition: all 0.2s;
            white-space: nowrap;
        }

        .code-btn:active {
            transform: scale(0.98);
        }

        .code-btn:disabled {
            background: #cbd5e0;
            cursor: not-allowed;
            opacity: 0.7;
        }

        .register-btn {
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

        .register-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        .register-btn:active {
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

        .footer {
            text-align: center;
            margin-top: 28px;
            font-size: 12px;
            color: #94a3b8;
        }

        @media (max-width: 480px) {
            .register-card {
                padding: 32px 24px;
            }
            .code-group {
                flex-wrap: wrap;
            }
            .code-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="register-card">
    <div class="logo">
        <h2>📐 流程图编辑器</h2>
        <p>创建新账号，云端同步流程图</p>
    </div>

    <form id="registerForm" onsubmit="return false;">
        <div class="input-group">
            <label>📧 邮箱</label>
            <input type="email" id="email" placeholder="请输入邮箱" autocomplete="email" required>
        </div>
        <div class="input-group">
            <label>🔒 密码</label>
            <input type="password" id="pwd" placeholder="请输入密码（至少6位）" autocomplete="new-password" required>
        </div>
        <div class="input-group">
            <label>📱 验证码</label>
            <div class="code-group">
                <input type="text" id="code" placeholder="请输入验证码" autocomplete="off" required>
                <button type="button" id="sendCodeBtn" class="code-btn" onclick="sendCode()">获取验证码</button>
            </div>
        </div>
        <button type="submit" class="register-btn" onclick="register()">注 册</button>
    </form>

    <div class="extra-links">
        <a href="login.jsp">← 返回登录</a>
        <a href="#" id="forgotPwdLink">忘记密码？</a>
    </div>

    <div class="footer">
        ✨ 注册后自动登录，云端保存流程图
    </div>
</div>

<script>
    // 倒计时相关变量
    let countdown = 0;
    let timer = null;

    function sendCode() {
        const email = document.getElementById("email").value.trim();
        if (!email) {
            alert("请先填写邮箱地址");
            return;
        }
        // 简单邮箱格式验证
        const emailPattern = /^[^\s@]+@([^\s@]+\.)+[^\s@]+$/;
        if (!emailPattern.test(email)) {
            alert("请输入有效的邮箱地址");
            return;
        }

        // 如果正在倒计时，禁止再次发送
        if (countdown > 0) {
            alert("请等待 " + countdown + " 秒后再试");
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/sendCode", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send("email=" + encodeURIComponent(email));
        xhr.onload = function() {
            if (xhr.responseText === "success" || xhr.status === 200) {
                alert("验证码已发送，请查看控制台或邮箱（若已配置）");
                // 开始倒计时
                countdown = 60;
                const btn = document.getElementById("sendCodeBtn");
                btn.disabled = true;
                timer = setInterval(function() {
                    if (countdown <= 0) {
                        clearInterval(timer);
                        btn.disabled = false;
                        btn.innerText = "获取验证码";
                    } else {
                        btn.innerText = "重新获取(" + countdown + "s)";
                        countdown--;
                    }
                }, 1000);
            } else {
                alert("发送失败，请稍后重试");
            }
        };
        xhr.onerror = function() {
            alert("网络错误，请稍后重试");
        };
    }

    function register() {
        const email = document.getElementById("email").value.trim();
        const pwd = document.getElementById("pwd").value;
        const code = document.getElementById("code").value.trim();

        if (!email) {
            alert("请输入邮箱");
            return;
        }
        const emailPattern = /^[^\s@]+@([^\s@]+\.)+[^\s@]+$/;
        if (!emailPattern.test(email)) {
            alert("请输入有效的邮箱地址");
            return;
        }
        if (!pwd) {
            alert("请输入密码");
            return;
        }
        if (pwd.length < 6) {
            alert("密码长度至少为6位");
            return;
        }
        if (!code) {
            alert("请输入验证码");
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/register", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send(
            "email=" + encodeURIComponent(email) +
            "&password=" + encodeURIComponent(pwd) +
            "&code=" + encodeURIComponent(code)
        );
        xhr.onload = function() {
            const resp = xhr.responseText;
            if (resp === "success") {
                alert("注册成功！正在自动登录...");
                // 注册成功且后端已自动登录，直接跳转到首页（流程图编辑器）
                location.href = "/";
            } else if (resp === "code_err") {
                alert("验证码错误！");
            } else {
                alert("注册失败！邮箱可能已存在或服务器错误");
            }
        };
        xhr.onerror = function() {
            alert("网络错误，请稍后重试");
        };
    }

    // 支持回车提交
    document.getElementById("registerForm").addEventListener("keypress", function(e) {
        if (e.key === "Enter") {
            register();
        }
    });

    // 忘记密码提示（可扩展为真正的找回功能）
    document.getElementById("forgotPwdLink").addEventListener("click", function(e) {
        e.preventDefault();
        alert("请联系管理员重置密码。");
    });
</script>
</body>
</html>