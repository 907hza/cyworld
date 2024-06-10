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
	Logger logger = LogManager.getLogger("board/updateProc7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "U_ID");
	
	int success = 0;
	String msg = "";
	
	// 수정이 완료되면 해당 수정 글을 보게 하기 위하여 view 생성에 필요한 데이터들을 가져와준다
	long boardN = HttpUtil.get(request, "boardN", (long)0);
	String searchType = HttpUtil.get(request, "searchType","");
	String searchValue = HttpUtil.get(request, "searchValue","");
	long curPage = HttpUtil.get(request,"curPage",(long)1);
	
	String bTitle = HttpUtil.get(request,"bTitle","");
	String bContent = HttpUtil.get(request,"bContent","");
	
	// 다이렉트로 치고 들어올 경우를 대비해서 예외 처리
	if(boardN > 0 && !StringUtil.isEmpty(bTitle) && !StringUtil.isEmpty(bContent))
	{
		BoardDao7 boardDao7 = new BoardDao7();
		Board7 board7 = boardDao7.bSelect(boardN);
		
		if(board7 != null)
		{
			if(StringUtil.equals(cookieUserId, board7.getuId()))
			{
				board7.setBoardN(boardN);
				board7.setbTitle(bTitle);
				board7.setbContent(bContent);
				
				if(boardDao7.boardUpdate(board7) > 0 )
				{
					success = 1;
				}
				else
				{
					msg = "게ㅅi물 수정 중 오류ㄱr 발생했습ㄴiㄷr.";
				}
			}
			else
			{
				msg = "ㅅr용ㅈr 정보ㄱr 일ㅊiㅎrㅈi 않습ㄴiㄷr.";
			}
		}
		else
		{
			msg = "게ㅅi물Oi 존ㅈHㅎrㅈi 않습ㄴiㄷr.";
		}
	}
	else
	{
		msg = "게ㅅi물 수정 값Oi 올ㅂr르ㅈi 않습ㄴiㄷr.";
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
		if(success == 1)
		{
%>
			// 정상적으로 처리되는 경우
			alert("게ㅅi물Oi 수정되었습ㄴiㄷr.");
			// 정상적으로 처리되면 내가 수정한 페이지를 볼 수 있도록 view.jsp 로 이동하도록 하는데
			// 그 안에 리스트 버튼이 있기 때문에 폼을 생성해서 전 페이지의 값을 가지고 갈 수 있도록 한다
			document.bbsForm.action = "/board/boardView7.jsp";
			document.bbsForm.submit();
<%
		}
		else
		{
%>		
			// 오류 처리 >> 예 ) boardN 가 없는 경우
			alert("<%=msg%>");
			location.href = "/board/boardList.jsp";
<%
		}
%>
	});
</script>
</head>
<body>
	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="boardN" value="<%=boardN %>" />
		<input type="hidden" name="searchType" value="<%=searchType %>" />
		<input type="hidden" name="searchValue" value="<%=searchValue %>" />
		<input type="hidden" name="curPage" value="<%=curPage %>" />
	</form>
</body>
</html>