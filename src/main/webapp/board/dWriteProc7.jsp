<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>  
<%@ page import="com.sist.web.dao.BoardDao7" %>
<%@ page import="com.sist.web.model.Board7" %>
<%@ page import="com.sist.web.model.Diary7" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<!DOCTYPE html>
<html>
<head>

<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="/resources/js/icia.common.js"></script>
<script>
<%
	Logger logger = LogManager.getLogger("/board/writeProc7.jsp");
	HttpUtil.requestLogString(request,logger);
	
	String cookieUserId = CookieUtil.getValue(request, "U_ID");
	
	String dTitle = HttpUtil.get(request, "dTitle","");
	String dContent = HttpUtil.get(request, "dContent","");
	
	if(!StringUtil.isEmpty(dTitle) && !StringUtil.isEmpty(dContent))
	{
		Diary7 diary7 = new Diary7();
		
		BoardDao7 boardDao7 = new BoardDao7();
		
		diary7.setuId(cookieUserId);
		diary7.setdTitle(dTitle);
		diary7.setdContent(dContent);
		
		if(boardDao7.dInsert(diary7) > 0)
		{
%>
			alert("게ㅅi물 등록Oi 완료되었습ㄴiㄷr.");
			location.href="/board/diaryView7.jsp";
<%
		}
		else
		{
%>
			alert("게ㅅi물 등록 중 오류ㄱr 발생했습ㄴiㄷr.");
			location.href="/board/dWrite7.jsp";
<%
		}
	}
	else
	{
%>
		alert("게ㅅi물 등록에 필요한 값Oi 입력되ㅈi 않았습ㄴiㄷr.");
		location.href="/board/dWrite7.jsp";
<%
	}	
%>

</script>
</head>
<body>
</body>
</html>