<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>注册</title>
</head>
<body>
<h2>邮箱注册</h2>
<form id="regForm">
    邮箱：<input type="email" name="email" id="email" required><br>
    验证码：<input type="text" name="code" required>
    <button type="button" onclick="sendCode()">发送验证码</button><br>
    密码：<input type="password" name="password" required><br>
    <button type="submit">注册</button>
</form>

<script>
    async function sendCode(){
        let email = document.getElementById('email').value;
        let res = await fetch(`/register?action=sendCode&email=${email}`);
        let text = await res.text();
        alert(text==='success'?'发送成功':'发送失败');
    }
    regForm.onsubmit = async (e) => {
        e.preventDefault();
        let res = await fetch('/register', {method:'POST', body:new FormData(regForm)});
        let text = await res.text();
        if(text==='success'){alert('注册成功');location.href='login.jsp';}
        else if(text==='codeError') alert('验证码错误');
        else alert('注册失败');
    }
</script>
</body>
</html>