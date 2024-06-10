<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 / 회원ㄱr입</title>
<style>
@import url("https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css");

* {
  box-sizing: border-box;
}
body {
  font-family: "Montserrat", sans-serif;
  margin: 0;
  padding: 0;
}
.wrapper {
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: #ebecf0;
  overflow: hidden;
}
.container {
  border-radius: 10px;
  box-shadow: -5px -5px 10px #fff, 5px 5px 10px #babebc;
  position: absolute;
  width: 768px;
  min-height: 480px;
  overflow: hidden;
}
form {
  background: #ebecf0;
  display: flex;
  flex-direction: column;
  padding: 0 50px;
  height: 100%;
  justify-content: center;
  align-items: center;
}
form input {
  background: #eee;
  padding: 16px;
  margin: 8px 0;
  width: 85%;
  border: 0;
  outline: none;
  border-radius: 20px;
  box-shadow: inset 7px 2px 10px #babebc, inset -5px -5px 12px #fff;
}
button {
  border-radius: 20px;
  border: none;
  outline: none;
  font-size: 12px;
  font-weight: bold;
  padding: 15px 45px;
  margin: 14px;
  letter-spacing: 1px;
  text-transform: uppercase;
  cursor: pointer;
  transition: transform 80ms ease-in;
}
.form_btn {
  box-shadow: -5px -5px 10px #fff, 5px 5px 8px #babebc;
}
.form_btn:active {
  box-shadow: inset 1px 1px 2px #babebc, inset -1px -1px 2px #fff;
}
.overlay_btn {
  background-color: #ff4b2b;
  color: #fff;
  box-shadow: -5px -5px 10px #ff6b3f, 5px 5px 8px #bf4b2b;
}
.sign-in-container {
  position: absolute;
  left: 0;
  width: 50%;
  height: 100%;
  transition: all 0.5s;
}
.sign-up-container {
  position: absolute;
  left: 0;
  width: 50%;
  height: 100%;
  opacity: 0;
  transition: all 0.5s;
}
.overlay-left {
  display: flex;
  flex-direction: column;
  padding: 0 50px;
  justify-content: center;
  align-items: center;
  position: absolute;
  right: 0;
  width: 50%;
  height: 100%;
  opacity: 0;
  background-color: #ff4b2b;
  color: #fff;
  transition: all 0.5s;
}
.overlay-right {
  display: flex;
  flex-direction: column;
  padding: 0 50px;
  justify-content: center;
  align-items: center;
  position: absolute;
  right: 0;
  width: 50%;
  height: 100%;
  background-color: #ff4b2b;
  color: #fff;
  transition: all 0.5s;
}
.container.right-panel-active .sign-in-container {
  transform: translateX(100%);
  opacity: 0;
}
.container.right-panel-active .sign-up-container {
  transform: translateX(100%);
  opacity: 1;
  z-index: 2;
}
.container.right-panel-active .overlay-right {
  transform: translateX(-100%);
  opacity: 0;
}
.container.right-panel-active .overlay-left {
  transform: translateX(-100%);
  opacity: 1;
  z-index: 2;
}
.social-links {
  margin: 20px 0;
}
form h1 {
  font-weight: bold;
  margin: 0;
  color: #000;
}

p {
  font-size: 16px;
  font-weight: bold;
  letter-spacing: 0.5px;
  margin: 20px 0 30px;
}
span {
  font-size: 12px;
  color: #000;
  letter-spacing: 0.5px;
  margin-bottom: 10px;
}
.social-links div {
  width: 40px;
  height: 40px;
  display: inline-flex;
  justify-content: center;
  align-items: center;
  margin: 0 5px;
  border-radius: 50%;
  box-shadow: -5px -5px 10px #fff, 5px 5px 8px #babebc;
  cursor: pointer;
}
.social-links a {
  color: #000;
}
.social-links div:active {
  box-shadow: inset 1px 1px 2px #babebc, inset -1px -1px 2px #fff;
}
.box {
  width:200px; height:130px; text-align:center; line-height:200px; border-radius:40px;
}
</style>

<script src="https://code.jquery.com/jquery-3.4.1.js"></script>

<script>

$(document).ready(function(){
	
	$("#signIn").on("click",function(){
		if($.trim($("#uId").val()).length <= 0)
		{
			alert("OrOiㄷi를 입력ㅎr세요.");
			$("#uId").val("");
			$("#uId").focus();
			return;
		}
		
		if($.trim($("#uPassword").val()).length <= 0)
		{
			alert("ㅂi밀번호를 입력ㅎr세요.");
			$("#uPassword").val("");
			$("#uPassword").focus();
			return;
		}
		
		document.loginForm.submit();
	});
	
	$("#signUp").on("click",function(){
		location.href="/user/userRegForm7.jsp";
	});
	
});

</script>

</head>
<body>
<div class="wrapper">
  <div class="container">
    <div class="sign-up-container">
      <form>
        <input type="text" placeholder="Name">
        <input type="text" placeholder="Email">
        <button class="form_btn">Sign Up</button>
      </form>
    </div>
    
    <div class="sign-in-container">
      <form name="loginForm" id="loginForm" method="post" action="/loginProc7.jsp">
        <h1>CY_WORLD</h1>
        <input type="text" id="uId" name="uId" placeholder="OrOiㄷi">
        <input type="password" id="uPassword" name="uPassword" placeholder="ㅂi밀번호">
        <button id="signIn" name="signIn" class="form_btn">로그인</button>
      </form>
    </div>
    
    <div class="overlay-container">
      <div class="overlay-right">
        <image class = "box" src="https://cdn.wolyo.co.kr/news/photo/202205/204860_95657_144.jpg" width="200" height="110">
        <br />
        <button id="signUp" name="signUp" class="overlay_btn">회원가입</button>
      </div>
    </div>
  </div>
</div>
</body>
</html>