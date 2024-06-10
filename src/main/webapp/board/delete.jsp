<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>  <%-- HttpUtil 과 Logger 를 new 객체 선언하지 않은 이유는 static 이기 때문이다--%>
<%@ page import="com.sist.web.dao.BoardDao" %>
<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.model.Paging" %>
<%@ page import="com.sist.web.model.BoardFileConfig" %> 

<%
	Logger logger = LogManager.getLogger("board/delete.jsp");
	HttpUtil.requestLogString(request, logger);
	
	// 쿼리스트링의 경우를 생각해서 전의 데이터 값을 가져와서 확인해준다
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	boolean bSuccess = false;
	String errorMsg = "";
	
	long bbsSeq = HttpUtil.get(request,"bbsSeq",(long)0);
	
	if(bbsSeq > 0) // 정상
	{
		BoardDao boardDao = new BoardDao();
		// 보드가 있는지 먼저 조회해서 있다면 삭제할 수 있도록 , 없다면 삭제 ㄴㄴ
		Board board = boardDao.boardSelect(bbsSeq);
		
		if(board != null) // 정상
		{
			if(StringUtil.equals(cookieUserId, board.getUserId()))
			{
				if(boardDao.boardDelete(bbsSeq) > 0)
				{
					bSuccess = true;
				}
				else
				{
					errorMsg = "게시물 삭제 중 오류가 발생하였습니다.";
				}
				
			}
			else
			{
				// 쿼리스트링의 경우를 항시 생각하고 적용해줘야한다
				errorMsg = "로그인 사용자의 게시물이 아닙니다.";
			}
		}
		else
		{
			errorMsg = "해당 게시글이 존재하지 않습니다.";
		}
	}
	else // 게시물 번호가 올바르지 않음
	{
		errorMsg = "게시물 번호가 올바르지 않습니다.";
	}
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
		alert("게시물이 삭제되었습니다.");
<%
	}
	else
	{
%>		
		alert("<%=errorMsg%>");
<%
	}
%>		
		// 게시물이 정상적으로 삭제되든, 게시물 삭제가 오류가 나든 무조건 리스트 페이지로 돌아가도록 할 것임
		// 굳이 원래 있던 전 페이지로 돌아갈 이유가 없기 때문에 > 삭제가 목적이었기 때문에 메인 리스트로 돌아갈 것임	
	location.href="/board/list.jsp";

	});
</script>

</head>
<body>
	
</body>
</html>