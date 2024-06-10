<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao7" %>
<%@ page import="com.sist.web.model.User7" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<%
	Logger logger = LogManager.getLogger("userUpdateForm7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	User7 user7 = null;
	String cookieUserId = CookieUtil.getValue(request,"U_ID");
	
	if(!StringUtil.isEmpty(cookieUserId))
	{
		UserDao7 userDao7 = new UserDao7();
		user7 = userDao7.uSelect(cookieUserId);
		
		if(user7 == null)
		{
			CookieUtil.deleteCookie(request, response, "/", "U_ID");
			response.sendRedirect("/");
		}
		else
		{
			if(!StringUtil.equals(user7.getStatus(),"Y"))
			{
				CookieUtil.deleteCookie(request, response, "/", "U_ID");
				user7 = null;
				response.sendRedirect("/");
			}
		}
	}
	
	if(user7 != null)
	{
%>
<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>♧ 회원가입 ♣︎</title>

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
    integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

  <style>
    body {
      min-height: 100vh;
  	  
	background-image: url('https://cdn.inflearn.com/public/files/posts/38f50939-dbdc-4b1c-b4f8-72144342026f/%EB%B0%B0%EA%B2%BD.png');
	background-image: no-repeat; /*배경 이미지 반복 안 함 */
	background-size: 100% 100%;
    }

    .input-form {
      max-width: 680px;

      margin-top: 80px;
      padding: 32px;

      background: #fff;
      -webkit-border-radius: 10px;
      -moz-border-radius: 10px;
      border-radius: 10px;
      -webkit-box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
      -moz-box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
      box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
    }
    .btn-primary {
    color : white;
    background-color: orange;
    border-color: orange;
}
  </style>
  
  <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
  
  <script>
	$(document).ready(function(){
		
		$("#uName").focus();
		
		$("#btnReg").on("click",function(){
			
			// 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
			var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
			// 닉네임 정규식
			var nickCheck =  /^[가-힣a-zA-Z]{2,8}$/;
			// 전화번호 정규식
			var phoneCheck = /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{3,4}$/;
			// 이메일 정규식
			var emailCheck = /^[a-z0-9\.\-_]+@([a-z0-9\-]+\.)+[a-z]{2,6}$/;
			// 생년월일 정규식
			var birthCheck = /^[0-9]{8}$/;
			
			if($.trim($("#uNickName").val()).length <= 0)
			{
				alert("별명을 입력ㅎH주세요.");
				$("#uNickName").val("");
				$("uNickName").focus();
				return;
			}
			
			if(!nickCheck.test($("#uNickName").val()))
			{
				alert("별명은 2-8 ㅈrㄹi의 영문, 한글, 숫자로만 입력ㄱr능합ㄴiㄷr.");
				$("#uNickName").val("");
				$("uNickName").focus();
				return;
			}
			
			if($.trim($("#uBirth").val()).length <= 0)
			{
				alert("생년월일을 입력ㅎH주세요.");
				$("#uBirth").val("");
				$("#uBirth").focus();
				return;
			}
			
			if(!birthCheck.test($("#uBirth").val()))
			{
				alert("생년월일 형식Oi 올ㅂr르ㅈi 않습ㄴiㄷr. ㄷrㅅi 입력ㅎH주세요.");
			}
			
			if($.trim($("#uEmail").val()).length <= 0)
			{
				alert("Oi메일을 입력ㅎH주세요.");
				$("#uEmail").val("");
				$("#uEmail").focus();
				return;
			}
			
			if(!emailCheck.test($("#uEmail").val()))
			{
				alert("Oi메일 형식Oi 올ㅂr르ㅈi 않습ㄴiㄷr. ㅈH 입력ㅎH주세요.");
				$("#uEmail").val("");
				$("#uEmail").focus();
				return;
			}
			
			if($.trim($("#uPhone").val()).length <= 0)
			{
				alert("전화번호를 입력ㅎH주세요.");
				$("#uPhone").val("");
				$("#uPhone").focus();
				return;
			}
			
			if(!phoneCheck.test($("#uPhone").val()))
			{
				alert("전화번호 형식Oi 올ㅂr르ㅈi 않습ㄴiㄷr. ㄷrㅅi 입력ㅎH주세요.");
				$("#uPhone").val("");
				$("#uPhone").focus();
				return;
			}
			
			if($.trim($("#uPassword").val()).length <= 0)
			{
				alert("ㅂi밀번호를 입력ㅎH주세요.");
				$("#uPassword").val("");
				$("#uPassword").focus();
				return;
			}
			
			if(!idPwCheck.test($("#uPassword").val()))
			{
				alert("ㅂi밀번호는 4-12 자리의 영문, 숫자로만 입력ㄱr능합ㄴiㄷr.");
				$("#uPassword").val("");
				$("#uPassword").focus();
				return;
			}
			
			if($("#uPassword").val() != $("#uPassword2").val())
			{
				alert("ㅂi밀번호ㄱr 동일ㅎrㅈi 않습ㄴiㄷr.");
				$("#uPassword2").val("");
				$("#uPassword2").focus();
				return;
			}
			document.bbsForm.submit();
		});	
	});  
  </script>
</head>

<body>
  <div class="container">
    <div class="input-form-backgroud row">
      <div class="input-form col-md-12 mx-auto">
        <h4 class="mb-3"> 회원 정보 수정 🌰 </h4>
       
        <form class="validation-form"  name="bbsForm" id="bbsForm" method="post" action="/user/userProc7.jsp">

          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="name" >Oi름</label>
              <div class="form-control"><%=user7.getuName() %></div>
            </div>
            <div class="col-md-6 mb-3">
              <label for="nickname">별명</label>
              <input type="text" class="form-control" id="uNickName" name="uNickname" value="<%=user7.getuNickname()%>">
              <div class="invalid-feedback">
              </div>
            </div>
          </div>

        <div class="mb-3">
            <label for="uBirth">생년월일</label>
            <input type="text" class="form-control" id="uBirth" name="uBirth" value="<%=user7.getuBirth()%>">
            <div class="invalid-feedback">
        </div>
            
          <div class="mb-3">
          <br >
            <label for="email">Oi메일</label>
            <input type="email" class="form-control" id="uEmail" name="uEmail" value="<%=user7.getuEmail() %>" >
            <div class="invalid-feedback">
          
            </div>
          </div>
          <div class="mb-3">
            <label for="uPhone">전화번호</label>
            <input type="text" class="form-control" id="uPhone" name="uPhone" value="<%=user7.getuPhone() %>" >
            <div class="invalid-feedback">
              
            </div>
          </div>
 
          </div>
          <div class="row">
            <div class="col-md-8 mb-3">
              <label for="root">성별</label>
              <select class="custom-select d-block w-100" id="uGender" name="uGender">
                <option value="<%=user7.getuGender()%>"></option>
                <option selected>M</option>
                <option>W</option>
              </select>
              <div class="invalid-feedback">
              </div>
            </div>
          </div>
          
           <div class="row">
            <div class="col-md-6 mb-3">
              <label for="uId">OrOiㄷi</label>
              <div class="form-control"><%=user7.getuId() %></div>
              <span id="checkCheck" ></span>
            </div>
           
            </div> 
		
         <div class="mb-3">
         <br />
            <label for="password">ㅂi밀번호</label>
            <input type="password" class="form-control" id="uPassword" name="uPassword" value="<%=user7.getuPassword() %>" required>
            <div class="invalid-feedback">
            </div>
          </div>
          
          <div class="mb-3">
            <label for="passwordCheck">ㅂi밀번호 확인</label>
            <input type="password" class="form-control" id="uPassword2" value="<%=user7.getuPassword() %>" required>
            <div class="invalid-feedback">
            </div>
          </div>
          <input type="hidden" id="uName" name="uName" value="<%=user7.getuName()%>"/>
          <input type="hidden" id="uId" name="uId" value="<%=user7.getuId()%>" />
            </form>
          
          <hr class="mb-4">
          
          <div class="mb-4"></div>
          <button class="btn btn-primary btn-lg btn-block" id="btnReg" name="btnReg">수정 완료</button>
      </div>
    </div>
    <footer class="my-3 text-center text-small">
      <p class="mb-1">&copy; 2021 YD</p>
    </footer>
  </div>
</body>
</html>
<%
	}
%>