<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>


<!-- header start -->
<%@ include file="/include/head.jsp" %>
<!-- header end -->


<style>
body {
  /* padding-top: 40px; */
  padding-bottom: 40px;
  /* background-color: #eee; */
}

.form-signin {
  max-width: 330px;
  padding: 15px;
  margin: 0 auto;
}
.form-signin .form-signin-heading,
.form-signin .checkbox {
  margin-bottom: 10px;
}
.form-signin .checkbox {
  font-weight: 400;
}
.form-signin .form-control {
  position: relative;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  height: auto;
  padding: 10px;
  font-size: 16px;
}
.form-signin .form-control:focus {
  z-index: 2;
}
.form-signin input[type="text"] {
  margin-bottom: 5px;
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
}
.form-signin input[type="password"] {
  margin-bottom: 10px;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}
</style>

<script>
$(document).ready(function(){
	$("#userId").focus();
	
	$("#btnLogin").on("click",function(){
		fn_loginCheck();
	});
	
	$("#btnReg").on("click", function(){
		location.href = "/user/userRegForm.jsp";
	});
});

function fn_loginCheck()
{
	if($.trim($("#userId").val()).length <= 0)
	{
		alert("아이디를 입력하세요.");
		$("#userId").val("");
		$("#userId").focus();
		return;
	}
	
	if($.trim($("#userPwd").val()).length <= 0)
	{
		alert("비밀번호를 입력하세요.");
		$("#userPwd").val("");
		$("#userPwd").focus();
		return;
	}
	
	document.loginForm.submit();
}

</script>

</head>
<body>

<!-- navigation start -->
<%@ include file="/include/navigation.jsp" %>
<!-- navigation end -->



<div class="container">

	<form name="loginForm" id="loginForm" method="post" action="/loginProc.jsp" class="form-signin">
	    <h2 class="form-signin-heading m-b3">로그인</h2>
		<label for="userId" class="sr-only">아이디</label>
		<input type="text" id="userId" name="userId" class="form-control" maxlength="20" placeholder="아이디">
		<label for="userPwd" class="sr-only">비밀번호</label>
		<input type="password" id="userPwd" name="userPwd" class="form-control" maxlength="20" placeholder="비밀번호">
		  
		<button type="button" id="btnLogin" class="btn btn-lg btn-primary btn-block">로그인</button>
    	<button type="button" id="btnReg" class="btn btn-lg btn-primary btn-block" type="submit">회원가입</button>
	</form>
	
	
</div>
</body>
</html>