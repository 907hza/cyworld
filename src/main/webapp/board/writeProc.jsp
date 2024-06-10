<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>  
<%@ page import="com.sist.web.dao.BoardDao" %>
<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>

<%
	Logger logger = LogManager.getLogger("/board/writeProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	boolean bSuccess = false;
	
	// 오류 메세지 관리할 변수
	String errorMsg = "";
	
	String bbsTitle = HttpUtil.get(request, "bbsTitle", "");
	String bbsContent = HttpUtil.get(request, "bbsContent", "");
	
	if(!StringUtil.isEmpty(bbsTitle) && !StringUtil.isEmpty(bbsContent))
	{	
		Board board = new Board();
		BoardDao boardDao = new BoardDao();
		
		board.setUserId(cookieUserId);
		board.setBbsTitle(bbsTitle);
		board.setBbsContent(bbsContent);
		
		if(boardDao.boardInsert(board) > 0) // 처리 건 수가 0건 이상이라 올바름
		{
			errorMsg = "게시물 등록이 완료되었습니다.";
			bSuccess = true;
		}
		else errorMsg = "게시물 등록 중 오류가 발생했습니다.";
	}
	else errorMsg = "게시물 등록시 필요한 값이 올바르지 않습니다.";
	
	
%>

<!DOCTYPE html>
<html>
<head>

<%@ include file="/include/head.jsp" %>

<script>
	$(document).ready(function(){
		
<%
	if(bSuccess == true)
	{
%>
		alert("<%=errorMsg %>");
		location.href="/board/list.jsp";
<%
	}
	else
	{
%>
		alert("<%=errorMsg %>");
		location.href="/board/write.jsp";
<%
	}
%>
	});
</script>

</head>
<body>

</body>
</html>