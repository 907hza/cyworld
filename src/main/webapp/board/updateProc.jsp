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
	Logger logger = LogManager.getLogger("board/updateProc.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	boolean bSuccess = false;
	String errorMsg = "";
	
	// 수정이 완료되면 해당 수정 글을 보게 하기 위하여 view 생성에 필요한 데이터들을 가져와준다
	long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
	String searchType = HttpUtil.get(request, "searchType","");
	String searchValue = HttpUtil.get(request, "searchValue","");
	long curPage = HttpUtil.get(request,"curPage",(long)1);
	
	String bbsTitle = HttpUtil.get(request,"bbsTitle","");
	String bbsContent = HttpUtil.get(request,"bbsContent","");
	
	// 다이렉트로 치고 들어올 경우를 대비해서 예외 처리
	if(bbsSeq > 0 && !StringUtil.isEmpty(bbsTitle) && !StringUtil.isEmpty(bbsContent))
	{
		BoardDao boardDao = new BoardDao();
		Board board = boardDao.boardSelect(bbsSeq);
		
		if(board != null)
		{
			if(StringUtil.equals(cookieUserId, board.getUserId()))
			{
				board.setBbsSeq(bbsSeq);
				board.setBbsTitle(bbsTitle);
				board.setBbsContent(bbsContent);
				
				if(boardDao.boardUpdate(board) > 0)
				{
					bSuccess = true;
				}
				else
				{
					errorMsg = "게시물 수정 중 오류가 발생했습니다.";
				}
			}
			else
			{
				errorMsg = "사용자 정보가 일치하지 않습니다.";
			}
		}
		else
		{
			errorMsg = "게시물이 존재하지 않습니다.";
		}
	}
	else
	{
		errorMsg = "게시물 수정 값이 올바르지 않습니다.";
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
			// 정상적으로 처리되는 경우
			alert("게시물이 수정되었습니다.");
			// 정상적으로 처리되면 내가 수정한 페이지를 볼 수 있도록 view.jsp 로 이동하도록 하는데
			// 그 안에 리스트 버튼이 있기 때문에 폼을 생성해서 전 페이지의 값을 가지고 갈 수 있도록 한다
			document.bbsForm.action = "/board/view.jsp";
			document.bbsForm.submit();
<%
		}
		else
		{
%>		
			// 오류 처리 >> 예 ) bbsSeq 가 없는 경우
			alert("<%=errorMsg%>");
			location.href = "/board/list.jsp";
<%
		}
%>
		
	});
</script>
</head>
<body>
	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="bbsSeq" value="<%=bbsSeq %>" />
		<input type="hidden" name="searchType" value="<%=searchType %>" />
		<input type="hidden" name="searchValue" value="<%=searchValue %>" />
		<input type="hidden" name="curPage" value="<%=curPage %>" />
	</form>
</body>
</html>