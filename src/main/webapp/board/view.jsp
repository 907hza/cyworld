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
	Logger logger = LogManager.getLogger("board/view.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "USER_ID");
	
	long bbsSeq = HttpUtil.get(request, "bbsSeq", (long)0);
	String searchType = HttpUtil.get(request,"searchType","");
	String searchValue = HttpUtil.get(request,"searchValue","");
	long curPage = HttpUtil.get(request,"curPage",(long)1);
	
	BoardDao boardDao = new BoardDao();
	Board board = boardDao.boardSelect(bbsSeq); // request 받은 값 넣어주면 됨
	
	// 2 조회 수 증가
	if(board != null)
	{
		boardDao.boardReadCntPlus(bbsSeq); // 메소드만 호출해주면 됨
	}
	
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
	if(board == null) // 쿼리스트링으로 없는 게시물 번호를 치고들어오는 경우 : 에러 페이지 대신 리스트 페이지로 돌아가도록 해준다
	{
%>
		alert("조회하신 게시물이 존재하지 않습니다.");
		document.bbsForm.action = "/board/list.jsp";
		document.bbsForm.submit();
<%
	}
	else
	{
%>
		$("#btnList").on("click",function(){
		document.bbsForm.action = "/board/list.jsp"; // 1 리스트로 돌아갔을때 조회수가 올라가있어야한다
		document.bbsForm.submit();
		});
		
<%
		if(StringUtil.equals(cookieUserId, board.getUserId())) // 수정, 삭제 버튼 눌렀을 시
		{
%>
			$("#btnUpdate").on("click",function(){ // 수정 버튼
				document.bbsForm.action = "/board/update.jsp";
				document.bbsForm.submit();
			});
			
			$("#btnDelete").on("click",function(){ // 삭제 버튼
				if(confirm("게시물을 삭제하시겠습니까?") == true)
				{
					document.bbsForm.action = "/board/delete.jsp";
					document.bbsForm.submit();
				}	
			});		
<%
		}
	}
%>
});
</script>
</head>

<%
	if(board != null) // 보드 객체가 있을 때만 해당 페이지를 보여줄 것, 없으면 list.jsp 로 복귀
	{
%>
		<body>
		<%@ include file="/include/navigation.jsp" %>
		<div class="container">
		   <h2>게시물 보기</h2>
		   <div class="row" style="margin-right:0; margin-left:0;">
		      <table class="table">
		         <thead>
		            <tr class="table-active">
		               <th scope="col" style="width:60%">
		                  <%=board.getBbsTitle() %><br/>
		                  <%=board.getBbsName() %>&nbsp;&nbsp;&nbsp;
		                  <a href="mailto:<%=board.getBbsEmail() %>" style="color:#828282;"><%=board.getBbsName() %></a>
		                  <!-- 앞에 mailto 로 되어있는 링크는 메일 주소를 연동시킨 속성이다 -->
		                     
		               </th>
		               <th scope="col" style="width:40%" class="text-right">
		                  조회 : <%=StringUtil.toNumberFormat(board.getBbsReadCnt()) %><br/> 
		                  <%=board.getRegDate() %>
		               </th>
		            </tr>
		         </thead>
		         <tbody>
		            <tr>
		               <td colspan="2"><pre><%=StringUtil.replace(HttpUtil.filter(board.getBbsContent()), "\n", "<br />")  %></pre></td> 
		               <!-- 글 내용에 포함된 엔터는 html 에서 먹히지 않는다
		               그래서 따로 <br> 태그를 생성해줘야한다 -->        <!--  \n 을 <br> 태그로 바꿔주는 메소드와 필터 활용 -->
		            </tr>
		         </tbody>
		         <tfoot>
		         <tr>
		               <td colspan="2"></td>
		           </tr>
		         </tfoot>
		      </table>
		   </div>
		   
		   <button type="button" id="btnList" class="btn btn-secondary">리스트</button>

<%
	if(StringUtil.equals(cookieUserId, board.getUserId())) // 쓴 사람과 로그인한 사람이 같은 경우에만 수정, 삭제 버튼을 보여주기 위해서
	{
%>		
		   <button type="button" id="btnUpdate" class="btn btn-secondary">수정</button>
		   <button type="button" id="btnDelete" class="btn btn-secondary">삭제</button>
<%
	}
%>		   
		   <br/>
		   <br/>
		</div>
<%
	}
%>
	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="bbsSeq" value="<%=bbsSeq %>" />
		<input type="hidden" name="searchType" value="<%=searchType %>" />
		<input type="hidden" name="searchValue" value="<%=searchValue %>" />
		<input type="hidden" name="curPage" value="<%=curPage %>" />
	</form>

</body>
</html>