<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao7" %>
<%@ page import="com.sist.web.model.User7" %>
<%@ page import="com.sist.web.dao.BoardDao7" %>
<%@ page import="com.sist.web.model.Board7" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.model.Paging7" %>
<%@ page import="com.sist.web.model.PagingConfig7" %>

<%
	Logger logger = LogManager.getLogger("/board/dWrite.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String searchType = HttpUtil.get(request,"searchType",""); // 조회항목
	String searchValue = HttpUtil.get(request,"searchValue",""); // 조회 값

	long curPage = HttpUtil.get(request, "curPage",(long)1); // 현재 페이지

	String cookieUserId = CookieUtil.getValue(request, "U_ID");
	
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
		
		  $("#dTitle").focus();
		  
		  $("#btnList").on("click",function(){
			  document.bbsForm.action = "/board/diaryView7.jsp";
			  document.bbsForm.submit();
		  });
		  
		  $("#btnWrite").on("click",function(){
			  
			 if($.trim($("#dTitle").val()).length <= 0)
			{
				 alert("제목을 입력하세요.");
				 $("#dTitle").val("");
				 $("#dTitle").focus();
				 return;
			}
			 
			 if($.trim($("#dContent").val()).length <= 0)
			 {
				 alert("내용을 입력하세요.");
				 $("#dContent").val("");
				 $("#dContent").focus();
				 return;
			 }
			 
			 document.writeForm.submit();
			 
		  });
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
  <body>  
    <div class="bookcover">
      <div class="bookdot">
        <div class="page">
			<%@ include file="/include/head7.jsp" %>

          <div class="content-container">
            <div class="header content-title">
              <div class="content-title-name">ㅅrOi 좋은 ㅆrOi월드</div>
              <div class="content-title-url"></div>
            </div>
            <div class="box content-box" >
              
              <div class="news-flex-box">
                <div class="news-box">
                <div class="box-title">ㄷrOiOㅓㄹi 쓰ㄱi</div>
                  <div class="news-row">
		<div class="container">
		<br>
		<form name="writeForm" id="writeForm" action="/board/dWriteProc7.jsp" post="method">
        <input type="text" id="dTitle" name="dTitle" placeholder="제목">
        &nbsp;&nbsp;&nbsp; [ 글쓴Oi : <%=user7.getuNickname() %> ]
        <br><br>
        <textarea name="dContent" id="dContent" placeholder="ㄴH용"></textarea>
        <br><br>

		    <button type="button" id="btnWrite" >저장</button>
            <button type="button" id="btnList" >리스트</button>
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
	<input type="hidden" name="diaryN" value="">
	<input type="hidden" name="searchType" value="<%= searchType %>">
	<input type="hidden" name="searchValue" value="<%= searchValue %>">
	<input type="hidden" name="curPage" value="<%= curPage %>">
	
</form>
    
  </body>
</html>