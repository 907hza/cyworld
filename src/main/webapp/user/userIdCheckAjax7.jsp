<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao7" %>
<%@ page import="com.sist.web.model.User7" %>
<%@ page import="com.sist.common.util.StringUtil" %>

<%
	Logger logger = LogManager.getLogger("userIdCheckAjax7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String uId = HttpUtil.get(request, "uId");
	
	if(!StringUtil.isEmpty(uId))
	{
		UserDao7 userDao7 = new UserDao7();
		
		if(userDao7.uIdSelectCount(uId) <= 0)
		{
			response.getWriter().write("{\"flag\":0}");
		}
		else
		{
			response.getWriter().write("{\"flag\":1}");
		}
	}
	else
	{
		response.getWriter().write("{\"flag\":-1}");
	}
%>