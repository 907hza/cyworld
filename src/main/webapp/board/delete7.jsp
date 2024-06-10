<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>  <%-- HttpUtil 과 Logger 를 new 객체 선언하지 않은 이유는 static 이기 때문이다--%>
<%@ page import="com.sist.web.dao.BoardDao7" %>
<%@ page import="com.sist.web.model.Board7" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.model.Paging7" %>
<%@ page import="com.sist.web.model.PagingConfig7" %> 

<%
	Logger logger = LogManager.getLogger("board/delete7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	// 쿼리스트링의 경우를 생각해서 전의 데이터 값을 가져와서 확인해준다
	String cookieUserId = CookieUtil.getValue(request, "U_ID");
	
	long boardN = HttpUtil.get(request,"boardN",(long)0);
	
	String msg = "";
	int success = 1;
	
	
	if(boardN > 0)
	{
		BoardDao7 boardDao7 = new BoardDao7();
		Board7 board7 = boardDao7.bSelect(boardN);
		
		if(board7 != null)
		{
			if(StringUtil.equals(cookieUserId, board7.getuId()))
			{
				if(boardDao7.boardDelete(boardN) > 0)
				{
					success = 0;
				}
				else
				{
					msg = "게ㅅi물 삭제 중 오류ㄱr 발생하였습ㄴiㄷr.";
				}
				
			}
			else
			{
				// 쿼리스트링의 경우를 항시 생각하고 적용해줘야한다
				msg = "로그인 ㅅr용ㅈr의 게시물Oi ㅇr닙ㄴiㄷr.";
			}
		}
		else
		{
			msg = "ㅎH당 게ㅅi물Oi 존ㅈHㅎrㅈi 않습ㄴiㄷr.";
		}
		
	}
	else
	{
		msg = "게ㅅi물 번호ㄱr 올ㅂr르ㅈi 않습ㄴiㄷr.";
	}
	
	
%>

<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="/resources/js/icia.common.js"></script>

<script>
	$(document).ready(function(){
		
<%
		if(success == 0)
		{
%>
			alert("게ㅅi물Oi 삭제되었습ㄴiㄷr.");
<%
		}
		else
		{
%>
			alert("<%=msg%>");
<%		}
%>
		location.href="/board/boardList.jsp";
	});
</script>
</head>
<body>

</body>
</html>