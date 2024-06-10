<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%
	Logger logger = LogManager.getLogger("logoutProc7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	if(CookieUtil.getCookie(request, "U_ID") != null )
		CookieUtil.deleteCookie(request, response, "U_ID");
	
	response.sendRedirect("/");
%>