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
	Logger logger = LogManager.getLogger("/board/update.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	// 삭제는 기본 메인 게시판 페이지로 이동하지만, 수정은 수정이 완료되면 원래 있던 페이지로 돌아가야한다
	long bbsSeq = HttpUtil.get(request, "bbsSeq" ,(long)0);
	String searchType = HttpUtil.get(request, "searchType","");
	String searchValue = HttpUtil.get(request, "searchValue","");
	long curPage = HttpUtil.get(request,"curPage",(long)1);
	
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.boardSelect(bbsSeq);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/include/head.jsp" %>

<script>
$(document).ready(function(){
	
	<%
		if(board == null) // 게시글이 없는 상황
		{
	%>
			alert("게시물이 존재하지 않습니다.");
			location.href = "/board/list.jsp"; // 기본 메인 게시판 페이지로 이동
	<%
		}
		else // 게시물이 존재할 경우
		{
	%>
			$("#bbsTitle").focus();
			$("#btnList").on("click",function(){ // 리스트 버튼을 클릭했을 때
				
				document.bbsForm.action = "/board/list.jsp"; // 폼을 보내서 리스트 페이지로 이동 (이전에 있던 페이지)
				document.bbsForm.submit();
			});
			
			// 수정 버튼은 제목과 내용에 값이 입력되었는지만 확인할 것
			$("#btnUpdate").on("click",function(){
				
				if($.trim($("#bbsTitle").val()).length <= 0)
				{
					alert("제목을 입력하세요.");
					$("#bbsTitle").val("");
					$("#bbsTitle").focus();
					return;
				}
				
				if($.trim($("#bbsContent").val()).length <= 0)
				{
					alert("내용을 입력하세요.");
					$("#bbsContent").val("");
					$("#bbsContent").focus();
					return;
				}
				
				if(confirm("입력하신 내용으로 수정하시겠습니까?") == true)
					document.updateForm.action = "/board/updateProc.jsp";
					document.updateForm.submit(); // 수정한 폼을 보내버려	
			});
	<%
		}
	%>
});

</script>
</head>
<body>

<%
	if(board != null) // 보드가 존재할 시 보여주는 화면
	{
%>
		<%@ include file="/include/navigation.jsp" %>
		
		<div class="container">
		   <h2>게시물 수정</h2>
		   <form name="updateForm" id="updateForm" action="/board/updateProc.jsp" method="post">
		      <input type="text" name="bbsName" id="bbsName" maxlength="20" value="<%=board.getBbsName() %>" style="ime-mode:active;" value="이름" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly />
		      <input type="text" name="bbsEmail" id="bbsEmail" maxlength="30" value="<%=board.getBbsEmail() %>"  style="ime-mode:inactive;" value="이메일" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly />
		      <input type="text" name="bbsTitle" id="bbsTitle" maxlength="100" style="ime-mode:active;" value="<%=board.getBbsTitle() %>" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
		      <div class="form-group">
		         <textarea class="form-control" rows="10" name="bbsContent" id="bbsContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required><%=board.getBbsContent() %></textarea>
		      </div>
		      <input type="hidden" name="bbsSeq" value="<%=bbsSeq%>"/>
		      <input type="hidden" name="searchType" value="<%=searchType%> " />
		      <input type="hidden" name="searchValue" value="<%=searchValue%> " />
		      <input type="hidden" name="curPage" value="<%=curPage%> " />
		   </form>
		   
		   <div class="form-group row">
		      <div class="col-sm-12">
		         <button type="button" id="btnUpdate" class="btn btn-primary" title="수정">수정</button>
		         <button type="button" id="btnList" class="btn btn-secondary" title="리스트">리스트</button>
		      </div>
		   </div>
		</div>
		
		<!-- 리스트 버튼용 -->
		<!-- 필요한 데이터만 post 하기 위해서 따로 폼 생성한 것 -->
		<form name="bbsForm" id = "bbsForm" method="post" >
			  <input type="hidden" name="bbsSeq" value="<%=bbsSeq%>"/>
		      <input type="hidden" name="searchType" value="<%=searchType%> " />
		      <input type="hidden" name="searchValue" value="<%=searchValue%> " />
		      <input type="hidden" name="curPage" value="<%=curPage%> " />
		</form>
<%
	}
%>

</body>
</html>