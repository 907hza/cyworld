<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>  <%-- HttpUtil 과 Logger 를 new 객체 선언하지 않은 이유는 static 이기 때문이다--%>
<%@ page import="com.sist.web.dao.BoardDao7" %>
<%@ page import="com.sist.web.dao.UserDao7" %>
<%@ page import="com.sist.web.model.Board7" %>
<%@ page import="com.sist.web.model.User7" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.model.Paging7" %>
<%@ page import="com.sist.web.model.PagingConfig7" %> 

<%
	Logger logger = LogManager.getLogger("/board/update7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "U_ID");
	
	// 삭제는 기본 메인 게시판 페이지로 이동하지만, 수정은 수정이 완료되면 원래 있던 페이지로 돌아가야한다
	long boardN = HttpUtil.get(request, "boardN" ,(long)0);
	String searchType = HttpUtil.get(request, "searchType","");
	String searchValue = HttpUtil.get(request, "searchValue","");
	long curPage = HttpUtil.get(request,"curPage",(long)1);
	
	BoardDao7 boardDao7 = new BoardDao7();
	Board7 board7 = boardDao7.bSelect(boardN);
	
	UserDao7 userDao7 = new UserDao7();
	User7 user7 = userDao7.uSelect(cookieUserId);
%>

<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="/resources/js/icia.common.js"></script>

<script>
$(document).ready(function(){
	
	<%
		if(board7 == null) // 게시글이 없는 상황
		{
	%>
			alert("게ㅅi물Oi 존ㅈHㅎrㅈi 않습니다.");
			location.href = "/board/boardList.jsp"; // 기본 메인 게시판 페이지로 이동
	<%
		}
		else // 게시물이 존재할 경우
		{
	%>
			$("#bTitle").focus();
			$("#btnList").on("click",function(){ // 리스트 버튼을 클릭했을 때
				
				 if(confirm("글 수정을 중단ㅎrㅅiㄴr요?")==true)
					{
						  document.bbsForm.action = "/board/boardList.jsp";
						  document.bbsForm.submit();
					}
			});
			
			// 수정 버튼은 제목과 내용에 값이 입력되었는지만 확인할 것
			$("#btnUpdate").on("click",function(){
				
				if($.trim($("#bTitle").val()).length <= 0)
				{
					alert("제목을 입력ㅎr세요.");
					$("#bTitle").val("");
					$("#bTitle").focus();
					return;
				}
				
				if($.trim($("#bContent").val()).length <= 0)
				{
					alert("ㄴH용을 입력ㅎr세요.");
					$("#bContent").val("");
					$("#bContent").focus();
					return;
				}
				
				if(confirm("입력ㅎr신 ㄴH용으로 수정ㅎrㅅi겠습ㄴi까?") == true)
					document.updateForm.action = "/board/updateProc7.jsp";
					document.updateForm.submit(); // 수정한 폼을 보내버려	
			});
	<%
		}
	%>
});
</script>
<style>
.page_wrap {
	text-align:center;
	font-size:0;
 }
.page_nation {
	display:inline-block;
}
.page_nation .none {
	display:none;
}
.page_nation a {
	display:block;
	margin:0 3px;
	float:left;
	border:1px solid #e6e6e6;
	width:28px;
	height:28px;
	line-height:28px;
	text-align:center;
	background-color:#fff;
	font-size:13px;
	color:#999999;
	text-decoration:none;
}
.page_nation .arrow {
	border:1px solid #ccc;
}
.page_nation .prev {
	background:#f8f8f8 url('img/page_prev.png') no-repeat center center;
	margin-right:7px;
}
.page_nation .next {
	background:#f8f8f8 url('img/page_next.png') no-repeat center center;
	margin-left:7px;
}
.page_nation a.active {
	background-color:#42454c;
	color:#fff;
	border:1px solid #42454c;
}
.test-center {
/* 수평 중앙 정렬하기 */
  text-align: center;
}
	.content-box {
    /* position: relative; */
}
.content-box {
    /* display: flex; */
    flex-direction: column;
    padding: 1rem;
    /* overflow: auto; */
}

.box {
    background-color: white;
    flex: 3;
    /* border-radius: 10px; */
    border: 1px solid #cdcdcd;
}
.content-box {
    /* position: relative; */
}
.content-box {
    /* display: flex; */
    flex-direction: column;
    padding: 1rem;
    /* overflow: auto; */
}
.box {
    background-color: white;
    flex: 3;
    /* border-radius: 10px; */
    border: 1px solid #cdcdcd;
}
user agent stylesheet
div {
    display: block;
}
a {
	color: black;
	text-decoration:none;
}
    .layout {
        width: 500px;
        margin: 0 auto;
        margin-top: 40px;
    }

    .layout > input, textarea {
    width: 100%;
    height: 10.25em;
    resize: none;

    }

    .layout > textarea{
           width: 100%;
    height: 6.25em;
    border: none;
    resize: none;
    }
    </style>
    <meta charset="UTF-8" />
    <title>MINI HOMEPAGE</title>
    <link rel="stylesheet" href="/resources/css/layout.css" />
    <link rel="stylesheet" href="/resources/css/font.css" />
    <link rel="stylesheet" href="/resources/css/home.css" />
  </head>

<%
	if(board7 != null) // 보드가 존재할 시 보여주는 화면
	{
%>
  <body>  
    <div class="bookcover">
      <div class="bookdot">
        <div class="page">
			<%@ include file="/include/navigation7.jsp" %>
          <div class="content-container">
            <div class="header content-title">
              <div class="content-title-name">ㅅrOi 좋은 ㅆrOi월드</div>
              <div class="content-title-url"></div>
            </div>
            <div class="box content-box" >
              
              <div class="news-flex-box">
                <div class="news-box">
                <div class="box-title">글 수정</div>
                  <div class="news-row">
		<div class="container">
		<br>
		<form name="updateForm" id="updateForm" post="method" action="/board/updateProc7.jsp">
        <input type="text" id="bTitle" name="bTitle" value="<%=board7.getbTitle() %>" placeholder="제목">
        &nbsp;&nbsp;&nbsp; [ 글쓴Oi : <%=user7.getuNickname() %> ]
        <br><br>
        <textarea name="bContent" id="bContent" placeholder="ㄴH용"><%=board7.getbContent() %></textarea>
        <br><br>
		이미지 파일&nbsp;<input type="file" multiple="multiple" name="imageFiles" >
		&nbsp;&nbsp;&nbsp;
		    <button type="button" id="btnUpdate" >저장</button>
            <button type="button" id="btnList" >리스트</button>
            
     	<input type="hidden" name="boardN" value="<%=boardN%>">
		<input type="hidden" name="searchType" value="<%= searchType %>">
		<input type="hidden" name="searchValue" value="<%= searchValue %>">
		<input type="hidden" name="curPage" value="<%= curPage %>">
        </form>
		
		<br>
		<br>
		</div>		
            </div>
                </div>
                  <div class="menu-row">
                </div>
              </div>
               <div class="box-title" style="text-align: center; border-bottom: 1px solid white;" >    		   
                </div>            
            </div>
            <br>
            <br>
          </div>
          <div class="menu-container">
            <div class="menu-button">
			
			<%@ include file="/include/navigation7.jsp" %>

            </div>
          </div>
        </div>
      </div>
    </div>
        
<form name="bbsForm" id="bbsForm" method="post">
	<input type="hidden" name="boardN" value="<%=boardN%>">
	<input type="hidden" name="searchType" value="<%= searchType %>">
	<input type="hidden" name="searchValue" value="<%= searchValue %>">
	<input type="hidden" name="curPage" value="<%= curPage %>">
	
</form>
<%
	}
%> 
  </body>
</html>