<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%-- 이 페이지의 전제 조건은 로그인이 되어있는 상태 
회원 정보를 수정하기 위해서 로그인한 회원 정보와 쿠키값을 대조해보는 페이지--%>


<% // 그저 로그를 찍기 위한 객체 선언과 명령어
	Logger logger = LogManager.getLogger("userUpdateForm.jsp");
	HttpUtil.requestLogString(request, logger);
	
	// 유저 객체를 가져와서 쿠키 값이 있는지 확인
	User user = null; 
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	// 쿠키가 비어있지 않아야 회원이라는 것이기 때문에 쿠키가 비어있는지 확인
	if(!StringUtil.isEmpty(cookieUserId))
	{
		logger.debug("cookie user ID : "+cookieUserId); // 로그찍기
		
		UserDao userDao = new UserDao();
		user = userDao.userSelect(cookieUserId); // 로그인할 때와 동일하게 (재사용성)
		
		if(user == null) // 쿠키정보가 없는 애 (쿠키가 비어있지는 않지만 사용 중에 정지되거나, 다른 컴퓨터로 탈퇴한 경우)
		{
			// 정상 사용자가 아니라면 쿠키를 삭제하고 로그인 페이지로 이동
			CookieUtil.deleteCookie(request, response, "/", "USER_ID"); // 얘 삭제해줘
			// 메소드에서 "" 이 값이 현재 같은 폴더이기 때문에 / 를 추가해서 위 폴더로
			response.sendRedirect("/");	 // 페이지 이동
		}
		else
		{
			if(!StringUtil.equals(user.getStatus(),"Y")) // status 가 Y 가 아닌 사람들 거르기 > N 은 정지된 사용자
			{
				// 정지된 사용자니까 쿠키 날려
				CookieUtil.deleteCookie(request, response, "/", "USER_ID"); // 얘 삭제해줘
				user = null; // null 이 아닌 상태를 보여주기 위해서 null 로 세팅
				response.sendRedirect("/"); // 이 전 페이지로 돌아감
			}
		}	
	}
	
	if(user != null) // user 객체가 null 이 아닐때만 이 화면을 보여줄 것
	{	// 쿠키가 있는지 확인하면 됨
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/include/head.jsp" %>
<script>
$(document).ready(function(){ // jQuery 는 무조건 스타트 끊어줘야한다
	$("#btnUpdate").on("click",function(){
		// 영문 대소무자, 숫자로만 이루어진 4-12 자리 정규식
		var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
		// 공백 체크
		var emptCheck = /\s/g;
		
		if($.trim($("#userPwd1").val()).length <= 0)
		{
			alert("비밀번호를 입력하세요.");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}
		
		if(emptCheck.test($("#userPwd1").val()))
		{
			alert("비밀번호는 공백을 포함할 수 없습니다.");
			$("#userPwd1").focus();
			return;
		}
		
		if(!idPwCheck.test($("#userPwd1").val()))
		{
			alert("비밀번호는 영문 대소문자와 숫자로 4-12 자리로 입력하세요.");
			$("#userPwd1").focus();
			return;
		}
		
		if($("#userPwd").val() != $("#userPwd2").val())
		{
			alert("비밀번호가 일치하지 않습니다.");
			$("#userPwd2").focus();
			return;
		}
		
		$("#userPwd").val($("#userPwd1").val()); // val 안에 매개변수가 있으면 set 의 역할, 매개변수 없으면 get 의 의미
		
		if($.trim($("#userName").val()).length <= 0)
		{
			alert("사용자 이름을 입력하세요.");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}
		
		if($.trim($("#userEmail").val()).length <= 0)
		{
			alert("이메일을 입력해주세요.");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}
		
		if(!fn_validateEmail($("#userEmail").val()))
		{
			alert("사용자 이메일 형식이 올바르지 않습니다.");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}
		
		document.updateForm.submit();
	});
});

function fn_validateEmail(value) // 이메일 정규 표현식을 함수로 이용
{
   var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
   
   return emailReg.test(value);
}
</script>
</head>
<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
    <div class="row mt-5">
       <h1>회원정보수정</h1>
    </div>
    <div class="row mt-2">
        <div class="col-12">
            <form name="updateForm" id="updateForm" action="/user/userProc.jsp" method="post">
                <div class="form-group">
                    <label for="username">사용자 아이디</label>
                    <%=user.getUserId() %> <!-- 사용자 아이디를 나타내줌 > 우리 페이지는 아이디는 변경할 수 없기 때문에 -->
                </div>
                <div class="form-group">
                    <label for="username">비밀번호</label>
                    <input type="password" class="form-control" id="userPwd1" name="userPwd1" value="<%=user.getUserPwd() %>" placeholder="비밀번호" maxlength="12" />
                </div>
                <div class="form-group">
                    <label for="username">비밀번호 확인</label>
                    <input type="password" class="form-control" id="userPwd2" name="userPwd2" value="<%=user.getUserPwd() %>" placeholder="비밀번호 확인" maxlength="12" />
                </div>
                <div class="form-group">
                    <label for="username">사용자 이름</label>
                    <input type="text" class="form-control" id="userName" name="userName" value="<%=user.getUserName() %>" placeholder="사용자 이름" maxlength="15" />
                </div>
                <div class="form-group">
                    <label for="username">사용자 이메일</label>
                    <input type="text" class="form-control" id="userEmail" name="userEmail" value="<%=user.getUserEmail() %>" placeholder="사용자 이메일" maxlength="30" />
                </div>
				<input type="hidden" id="userId" name="userId" value="<%=user.getUserId() %>" />
				<input type="hidden" id="userPwd" name="userPwd" value="<%=user.getUserPwd() %>" /> 
                <button type="button" id="btnUpdate" class="btn btn-primary">수정</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
<%
	}
%>