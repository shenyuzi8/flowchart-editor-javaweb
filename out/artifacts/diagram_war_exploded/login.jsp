<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录</title>
</head>
<body>
<h2>邮箱登录</h2>
<form id="loginForm">
    邮箱：<input type="email" name="email" required><br>
    密码：<input type="password" name="password" required><br>
    <button type="submit">登录</button>
</form>
<a href="register.jsp">去注册</a>

<script>
    loginForm.onsubmit = async (e) => {
        e.preventDefault();
        let formData = new FormData(loginForm);
        let res = await fetch('/login', {method:'POST', body:formData});
        let text = await res.text();
        if(text==='success') location.href='editor.jsp';
        else alert('账号或密码错误');
    }
</script>
</body>
</html>