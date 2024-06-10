<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao7" %>
<%@ page import="com.sist.web.model.User7" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<%
	Logger logger = LogManager.getLogger("loginProc7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String msg = "";
	String redirect = "";

	String uId = HttpUtil.get(request,"uId");
	String uPassword = HttpUtil.get(request, "uPassword");
	String cookieUserId = CookieUtil.getValue(request,"U_ID"); 
	
	User7 user7 = null;
	UserDao7 userDao7 = new UserDao7();
	
	logger.debug("user Id : " + uId);
	logger.debug("userPwd : " + uPassword);
	logger.debug("cookieUserId : " + cookieUserId);
	
	if(StringUtil.isEmpty(cookieUserId))
	{
		if(!StringUtil.isEmpty(uId) && !StringUtil.isEmpty(uPassword))
		{
			user7 = userDao7.uSelect(uId);
			
			if(user7 != null)
			{
				if(StringUtil.equals(uPassword, user7.getuPassword()))
				{
					if(StringUtil.equals(user7.getStatus(),"Y"))
					{
						CookieUtil.addCookie(response,"/","U_ID",uId);
						msg = "Login 성공-⭐︎★";
						redirect = "/board/list7.jsp";
					}
					else
					{
						msg = "홈페Oiㅈi ㅅr용Oi 불가능한 회원입ㄴiㄷr.";
						redirect = "/";
					}
				}
				else
				{
					msg = "ㅂi밀번호ㄱr 일ㅊi하ㅈi 않습ㄴiㄷr.";
					redirect = "/";
				}
			}
			else
			{
				msg = "OrOiㄷiㄱr 존재ㅎrㅈi 않습ㄴiㄷr.";
				redirect = "/";
			}
		}
		else
		{
			msg = "입력 값Oi 부족합ㄴiㄷr.";
			redirect = "/";
		}
	}
	else
	{
		if(!StringUtil.isEmpty(uId)) // 쿠키 정보가 있을 경우
		{
			user7 = userDao7.uSelect(uId);
			
			if(user7 != null)
			{
				if(StringUtil.equals(uPassword, user7.getuPassword()))
				{
					if(StringUtil.equals(user7.getStatus(), "Y"))
					{
						if(!StringUtil.equals(cookieUserId,uId))
						{
							CookieUtil.deleteCookie(request, response, "U_ID");
							CookieUtil.addCookie(response,"U_ID",uId);
						}
						
						msg = "Login 성공-⭐︎★";
						redirect = "/board/list7.jsp";
					}
					else
					{
						CookieUtil.deleteCookie(request, response, "U_ID");
						msg = "홈페Oiㅈi ㅅr용Oi 불가능한 회원입ㄴiㄷr.";
						redirect = "/";
					}

				}
				else
				{
					msg = "ㅂi밀번호ㄱr 일ㅊi하ㅈi 않습ㄴiㄷr.";
					redirect = "/";
				}
			}
			else
			{
				msg = "OrOiㄷiㄱr 존재ㅎrㅈi 않습ㄴiㄷr.";
				redirect = "/";
			}
		}
		else
		{
			msg = "OrOiㄷiㄱr 입력되ㅈi 않았습ㄴiㄷr.";
			redirect = "/";
		}
	}
%>

<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>

<script>
	$(document).ready(function(){
		alert("<%=msg%>");
		location.href="<%=redirect%>";
	});
</script>

</head>
<body>

</body>
</html>