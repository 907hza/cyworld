<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao" %>
<%@ page import="com.sist.web.model.User" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%
	//HTTP 로그
	Logger logger = LogManager.getLogger("userIdCheckAjax.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String userId = HttpUtil.get(request, "userId");
	
	if(!StringUtil.isEmpty(userId))
	{
		UserDao userDao = new UserDao(); 
		
		if(userDao.userIdSelectCount(userId) <= 0)
		{	//사용가능(아이디 미존재)
			response.getWriter().write("{\"flag\":0}");
		}
		else
		{	//중복(아이디가 이미 존재)
			response.getWriter().write("{\"flag\":1}");
		}
	}
	else
	{
		//아이디 값이 없는 경우
		response.getWriter().write("{\"flag\":-1}");
	}
%>