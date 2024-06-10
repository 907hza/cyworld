<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao7" %>
<%@ page import="com.sist.web.model.User7" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<%
	Logger logger = LogManager.getLogger("userProc7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String msg = "";
	String redirect = "";
	
	String uName = HttpUtil.get(request,"uName");
	String uPhone = HttpUtil.get(request,"uPhone");
    String uEmail = HttpUtil.get(request,"uEmail");
    String uBirth = HttpUtil.get(request,"uBirth");
    String uGender = HttpUtil.get(request,"uGender");
    String uNickname = HttpUtil.get(request,"uNickname");
    String uId = HttpUtil.get(request,"uId");
	String uPassword = HttpUtil.get(request, "uPassword");
	String cookieUserId = CookieUtil.getValue(request,"U_ID"); 
	
	UserDao7 userDao7 = new UserDao7();
	
	if(StringUtil.isEmpty(cookieUserId)) // 쿠키가 비워져있다면 회원가입을 하는 것이고, 있다면 회원 정보 수정을 하는 것
	{ // 회원가입
		if(!StringUtil.isEmpty(uName) && !StringUtil.isEmpty(uPhone) && !StringUtil.isEmpty(uEmail) && 
		 !StringUtil.isEmpty(uBirth) && !StringUtil.isEmpty(uGender) && !StringUtil.isEmpty(uNickname) && 
		 !StringUtil.isEmpty(uId) && !StringUtil.isEmpty(uPassword))
		{
			if(userDao7.uIdSelectCount(uId) > 0)
			{
				msg = "ㅅr용ㅈr OrOiㄷiㄱr 중복 발생했습ㄴiㄷr.";
				redirect = "/user/userRegForm7.jsp";
			}
			else
			{
				User7 user7 = new User7();
				
				user7.setuName(uName);
				user7.setuPhone(uPhone);
				user7.setuEmail(uEmail);
				user7.setuBirth(uBirth);
				user7.setuGender(uGender);
				user7.setuNickname(uNickname);
				user7.setuId(uId);
				user7.setuPassword(uPassword);
				user7.setStatus("Y");
				
				if(userDao7.uInsert(user7) > 0) // Insert 성공하면 0보다 큰 값을 반환한다
				{
					msg = "회원가입 성공-⭐︎★";
					redirect = "/";
				}
				else
				{
					msg = "회원ㄱr입 중 오류ㄱr 발생했습ㄴiㄷr.";
					redirect = "/user/userRegForm7.jsp";
				}
			}
		}
		else
		{
			msg = "회원가입 정보ㄱr 올ㅂr르ㅈi 않습ㄴiㄷr.";
			redirect = "/user/userRegForm7.jsp";
		}
	}
	else // 회원정보 수정할 때
	{
		User7 user7 = userDao7.uSelect(cookieUserId); // 해당 아이디를 가지고 있는 회원의 정보를 가져와서 
		System.out.println("1111111111111111111111111");
		System.out.println(user7.getuId()+","+ uId);
		System.out.println("22222222222222222222222222"); 
		if(user7 != null)
		{
			if(StringUtil.equals(user7.getStatus(), "Y") && StringUtil.equals(user7.getuId(), uId))
			{	
/* 			System.out.println("1111111111111111111111111");
				System.out.println(uName+","+uPhone+","+uEmail+","+uBirth+","+uGender+","+uNickname+","+uId+","+uPassword);
				System.out.println("22222222222222222222222222"); */
				
				if(!StringUtil.isEmpty(uName) && !StringUtil.isEmpty(uPhone) && !StringUtil.isEmpty(uEmail) && 
				   !StringUtil.isEmpty(uBirth) && !StringUtil.isEmpty(uNickname) && !StringUtil.isEmpty(uGender)
				   && !StringUtil.isEmpty(uId) && !StringUtil.isEmpty(uPassword))
				{
					user7.setuName(uName);
					user7.setuPhone(uPhone);
					user7.setuEmail(uEmail);
					user7.setuBirth(uBirth);
					user7.setuGender(uGender);
					user7.setuNickname(uNickname);
					user7.setuId(uId);
					user7.setuPassword(uPassword);
					
					if(userDao7.uUpdate(user7) > 0)
					{
						msg = "회원 정보 수정 성공-⭐︎★";
						redirect = "/board/list7.jsp";
					}
					else
					{
						msg = "회원정보 수정 중 오류ㄱr 발생했습ㄴiㄷr.";
						redirect = "/user/userUpdateForm7.jsp";
					}
				}
				else
				{
					msg = "입력되ㅈi 않은 칸Oi 존ㅈH합ㄴiㄷr.";
					redirect = "/user/userUpdateForm7.jsp";
				}
			}
			else
			{
				CookieUtil.deleteCookie(request, response, "/", "U_ID");
				msg = "정ㅈi된 ㅅr용ㅈr입ㄴiㄷr.";
				redirect = "/";
			}
		}
		else
		{
			CookieUtil.deleteCookie(request, response, "/", "U_ID");
			msg = "확인 불ㄱr능한 ㅅr용ㅈr 입ㄴiㄷr.";
			redirect = "/";
		}
	}

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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