<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="/resources/js/icia.common.js"></script>
  <link rel="stylesheet" href="/resources/css/diary.css" />
  <link rel="stylesheet" href="/resources/css/font.css" />
  <link rel="stylesheet" href="/resources/css/picture.css" />
  <link rel="stylesheet" href="/resources/css/home.css" />
  <link rel="stylesheet" href="/resources/css/layout.css" />
   <link rel="stylesheet" href="/resources/css/guestbook.css" />
  
  
 
<html>
<head>
	<style>
	body {
    background-image: url('https://cdn.inflearn.com/public/files/posts/38f50939-dbdc-4b1c-b4f8-72144342026f/%EB%B0%B0%EA%B2%BD.png');
	background-size: 800px;  
    position: fixed;
    left: 0;
    top: 0;
    right: 0;
    bottom: 0;
    font-size: 16px;
  
    /** 기본 폰트 설정 */
    font-family: "Noto Sans KR", sans-serif;
  }
		.menu-button button {
    width: 80px;
    text-align: left;
    margin-bottom: 0.9rem;
    font-size: 0.8rem;
    font-family: "NeoDunggeunmo";
    padding: 0.4rem;
    background-color: #3B87AB;
    color: white;
    border-radius: 0 5px 5px 0;
    border: 1px solid grey;
    cursor: pointer;
}
</style>
</head>
<body>
          <div class="menu-container">
            <div class="menu-button">
              <a href="#"><button id="homeBtn">홈</button></a>
              <a href="#"><button id="boardBtn">게ㅅi판</button></a>
        <%if(!StringUtil.isEmpty(CookieUtil.getValue(request,"U_ID")))
		  { %>
              <a href="#"><button id="diaryBtn">ㄷrOi어ㄹi</button></a>
        <%} %>
              <a href="#"><button id="gestBtn">방명록</button></a>
		<%if(!StringUtil.isEmpty(CookieUtil.getValue(request,"U_ID")))
		  { %>
		      <a href="#"><button id="modiInfoBtn">정보수정</button></a>
              <a href="#"><button id="logOutBtn">로그Or웃</button></a>
		<%} %>
            </div>
          </div>
          
	<script>
		$(document).ready(function(){
			$("#homeBtn").on("click",function(){
				location.href="list7.jsp";
			});
			
			$("#boardBtn").on("click",function(){
				location.href="/board/boardList.jsp";
			});
			
			$("#diaryBtn").on("click",function(){
				location.href="/board/diaryView7.jsp";
			});
			
			$("#gestBtn").on("click",function(){
				location.href="/board/guestBookView7.jsp";
			});
			
			$("#logOutBtn").on("click",function(){
				location.href="/loginOut7.jsp";
			});
			
			$("#modiInfoBtn").on("click",function(){
				location.href="/user/userUpdateForm7.jsp";
			})
		});
	</script>
</body>
</html>