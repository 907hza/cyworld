<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<% // 쿼리스트링으로 들어올 경우를 감안해서 오류를 거르는 기능
	Logger logger = LogManager.getLogger("userProc.jsp"); // 지역변수로 사용하기 위해서
	HttpUtil.requestLogString(request, logger);
	// 최종적으로 회원가입이 행해지는 곳
	String msg = "";
	String redirectUrl = "";
	
	String userId = HttpUtil.get(request, "userId"); //  전 페이지에서 가져온 유저 아이디
	String userPwd = HttpUtil.get(request, "userPwd");
	String userName = HttpUtil.get(request, "userName");
	String userEmail = HttpUtil.get(request, "userEmail");
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	UserDao userDao = new UserDao(); // 사용자 조회를 위해서 유저다오 객체 선언
	
	if(StringUtil.isEmpty(cookieUserId))
	{
		//회원가입
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) &&
					!StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail))
		{
			if(userDao.userIdSelectCount(userId) > 0)
			{
				msg = "사용자 아이디가 중복 발생하였습니다.";
				redirectUrl = "/user/userRegForm.jsp";
			}
			else
			{
				//회원가입
				User user = new User();
				
				user.setUserId(userId);
				user.setUserPwd(userPwd);
				user.setUserName(userName);
				user.setUserEmail(userEmail);
				user.setStatus("Y");
				
				if(userDao.userInsert(user) > 0)
				{
					msg = "회원가입이 완료 되었습니다.";
					redirectUrl = "/";
				}
				else
				{
					msg = "회원가입 중 오류가 발생하였습니다.";
					redirectUrl = "/user/userRegForm.jsp";
				}
			}
		}
		else
		{
			msg = "회원가입정보가 올바르지 않습니다.";
			redirectUrl = "/user/userRegForm.jsp";
		}
	}
	else
	{
		// 회원정보 수정
		User user = userDao.userSelect(cookieUserId); //2. 얘 사용
		
		if(user != null) // 유저정보가 있는 경우
		{
			if(StringUtil.equals(user.getStatus(), "Y") && StringUtil.equals(user.getUserId(), userId))
			{ // user.getUserId() : 저장되어있는 아이디 정보 = cookieUserId, userId : 현재 로그인한 회원 아이디
			  // 로그인을 한 상태로 회원 정보 수정에 들어와서 쿼리 스트링으로 입력하고 들어왔을 수도 있기 때문에
			  // 정상 회원이기에 입력한 값들이 비어있지는 않은지 확인
			  
				  if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) 
					&& !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail))
				  { // 1.업데이트 문은 유저 객체를 받기 때문에 항목들을 객체에 담아서 줘야한다
					  user.setUserId(userId);
				  	  user.setUserPwd(userPwd);
				  	  user.setUserName(userName);
				  	  user.setUserEmail(userEmail); // 값 수정
				  	  
				  	  if(userDao.userUpdate(user) > 0) // 유저 객체의 주소값 넘겨줌
				  	  {
				  		  msg = "회원정보가 수정되었습니다.";
				  		  redirectUrl = "/user/userUpdateForm.jsp";
				  	  }
				  	  else // 오류
				  	  { 
				  		  msg = "회원정보 수정 중 오류가 발생했습니다.";
				  		  redirectUrl = "/user/userUpdateForm.jsp";
				  	  }
				  }
				  else
				  {
					  msg = "회원정보 중 입력되지 않은 칸이 존재합니다.";
					  redirectUrl = "/user/userUpdateForm.jsp";
				  }
				
			}
			else
			{
				CookieUtil.deleteCookie(request, response, "/" , "USER_ID");
				msg = "정지된 사용자 입니다.";
				redirectUrl = "/";
			}
		}
		else // 정보가 없는 경우
		{
			CookieUtil.deleteCookie(request, response, "/", "USER_ID");
			msg = "올바른 사용자가 아닙니다.";
			redirectUrl = "/"; // 로그인 페이지부터 다시 실행 (쿠키가 사라졌으니까)
		}
	}
%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/include/head.jsp" %>

<script>
$(document).ready(function(){
	alert("<%=msg%>");
	location.href = "<%=redirectUrl%>";
});
</script>

</head>
<body>

</body>
</html>