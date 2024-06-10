<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<%
	Logger logger = LogManager.getLogger("loginProc.jsp");
	
	HttpUtil.requestLogString(request, logger);
	
	String userId = HttpUtil.get(request, "userId");
	String userPwd = HttpUtil.get(request, "userPwd");
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	String msg = "";
	String redirectUrl = "";
	
	User user = null;
	UserDao userDao = new UserDao();
	
	logger.debug("user Id : " + userId);
	logger.debug("userPwd : " + userPwd);
	logger.debug("cookieUserId : " + cookieUserId);
	
	if(StringUtil.isEmpty(cookieUserId))
	{	//로그인이 안되어 있을 경우
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))
		{
			user = userDao.userSelect(userId);
			
			if(user != null)
			{
				if(StringUtil.equals(userPwd, user.getUserPwd()))
				{
					if(StringUtil.equals(user.getStatus(), "Y"))
					{
						CookieUtil.addCookie(response, "/", "USER_ID", userId);
						// addCookie("","",-1) "" 은 현재 나의 위치
						msg = "로그인 성공";
						redirectUrl = "/board/list.jsp";		//게시판 메인으로 이동 해야함.
					}
					else
					{
						msg = "정지된 사용자 입니다.";
						redirectUrl = "/";
					}
				}
				else
				{
					msg = "비밀번호가 일치하지 않습니다.";
					redirectUrl = "/";
				}
			}
			else
			{
				msg = "아이디가 존재하지 않습니다.";
				redirectUrl = "/";
			}
		}
		else
		{
			//아이디나 비밀번호가 입력되지 않은 경우
			msg = "아이디나 비밀번호가 입력되지 않았습니다.";
			redirectUrl = "/";
		}
	}
	else
	{
		//쿠키정보가 있을 경우
		logger.debug("쿠키 정보가 있을 경우................");
		
		if(!StringUtil.isEmpty(userId))
		{
			user = userDao.userSelect(userId);
			
			if(user != null)
			{
				if(StringUtil.equals(userPwd, user.getUserPwd()))
				{
					if(StringUtil.equals(user.getStatus(), "Y"))
					{
						if(!StringUtil.equals(cookieUserId, userId))
						{
							CookieUtil.deleteCookie(request, response, "USER_ID");
							CookieUtil.addCookie(response, "USER_ID", userId);
						}

						msg = "우리사용자 입니다.";
						redirectUrl = "/board/list.jsp";						
					}	
					else
					{
						CookieUtil.deleteCookie(request, response, "USER_ID");
						msg = "정지된 사용자 입니다.";
						redirectUrl = "/";
					}
				}
				else
				{
					CookieUtil.deleteCookie(request, response, "USER_ID");
					msg = "비밀번호가 잘못되었습니다.";
					redirectUrl = "/";
				}					
			}
			else
			{
				CookieUtil.deleteCookie(request, response, "USER_ID");
				msg = "우리 사용자가 아닙니다.";
				redirectUrl = "/";
			}
		}
		else
		{
			CookieUtil.deleteCookie(request, response, "USER_ID");
			msg = "사용자 아이디 입력이 잘못되었습니다.";
			redirectUrl = "/";
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