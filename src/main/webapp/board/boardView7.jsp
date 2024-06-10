<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.util.HttpUtil" %>  <%-- HttpUtil 과 Logger 를 new 객체 선언하지 않은 이유는 static 이기 때문이다--%>
<%@ page import="com.sist.web.dao.BoardDao7" %>
<%@ page import="com.sist.web.model.Attachment" %>
<%@ page import="com.sist.web.model.Board7" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.model.Paging7" %>
<%@ page import="com.sist.web.model.PagingConfig7" %> 

<%
	Logger logger = LogManager.getLogger("/board/boardView7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "U_ID");
	
	long boardN = HttpUtil.get(request, "boardN", (long)0);
	String searchType = HttpUtil.get(request, "searchType", "");
	String searchValue = HttpUtil.get(request, "searchValue", "");
	long curPage = HttpUtil.get(request, "curPage", (long)1);
	
	BoardDao7 boardDao7 = new BoardDao7();
	Board7 board7 = boardDao7.bSelect(boardN);
	
	// 조회 수 증가 기능
	if(board7 != null)
	{
		boardDao7.boardReadCntPP(boardN); 
	}
%>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>MINI HOMEPAGE</title>
    <script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/icia.common.js"></script>
    <script>
    $(document).ready(function(){
    <%
    	if(board7 == null)
    	{
    %>
    		alert("조회ㅎr신 게ㅅi물Oi 존ㅈHㅎrㅈi않습ㄴiㄷr.");
    		document.bbsForm.action = "/board/boardList.jsp";
    		document.bbsForm.submit();
    <%		
    	}
    	else
    	{
    %>
    		$("#btnList").on("click",function(){
    			document.bbsForm.action = "/board/boardList.jsp";
    			document.bbsForm.submit();
    		})
    <%
    		if(StringUtil.equals(cookieUserId, board7.getuId()))
    		{
    %>
    			$("#btnUpdate").on("click",function(){
    				document.bbsForm.action = "/board/update7.jsp";
    				document.bbsForm.submit();
    			})
    			
    			$("#btnDelete").on("click",function(){
    				if(confirm("ㅎH당 게ㅅi물을 삭제ㅎrㅅi겠나요?") == true)
    				{
        				document.bbsForm.action = "/board/delete7.jsp";
        				document.bbsForm.submit();
    				}
    			});
    <%
    		}
    	}
    %>   
    });
    </script>
    <link rel="stylesheet" href="/resources/css/layout.css" />
    <link rel="stylesheet" href="/resources/css/font.css" />
    <link rel="stylesheet" href="/resources/css/home.css" />
  </head>
  <%
  	if(board7 != null)
  	{
  %>
  <body>
    <div class="bookcover">
      <div class="bookdot">
        <div class="page">
			<%@ include file="/include/head7.jsp" %>

          <div class="content-container">
            <div class="header content-title">
              <div class="content-title-name">ㅅrOi 좋은 ㅆrOi월드</div>
            </div>
            <div class="box content-box">
                <div class="content-photo">
           <%
           		
           %>
                <div class="photo-title font-neo"><%=board7.getbTitle() %></div>
                <div class="photo-image">
                    <img
                    class="photo-image-img"
            <%
                if(board7.getBoardN()%2 == 0)
                {
            %>
                    src="https://search.pstatic.net/common/?src=http%3A%2F%2Fimgnews.naver.net%2Fimage%2F003%2F2012%2F09%2F25%2FNISI20120925_0007084934_web_59_20120925154416.jpg&type=a340"
                    alt="사진첩 이미지"
                    style="width: 100%;"
            <%
                }
                else
                {
            %>
            		src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTER8_mSEmK1r3OGLk0to3QdOx4FILWUILlrw&usqp=CAU"
                    alt="사진첩 이미지"
                    style="width: 100%;"
            <%
                }
            %>
            
                    /><%=board7.getbContent() %>
                    
                    <br>
                    
    <%
		if(StringUtil.equals(cookieUserId, board7.getuId())) // 쓴 사람과 로그인한 사람이 같은 경우에만 수정, 삭제 버튼을 보여주기 위해서
		{
	%>		
				<br><br>
			   <button type="button" id="btnDelete" style="float: right;" >삭제</button>
			   <button type="button" id="btnUpdate" style="float: right;" >수정</button>
			   <button type="button" id="btnList" style="float: rigth;" >리스트</button>
	<%
		}
	%>	
                </div>

            </div>
        </div>
          </div>
          <div class="menu-container">
            <div class="menu-button">
			
			<%@ include file="/include/navigation7.jsp" %>

            </div>
          </div>
        </div>
        
      </div>
    </div>
		</div>
<%
	}
%>
	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="boardN" value="<%=boardN %>" />
		<input type="hidden" name="searchType" value="<%=searchType %>" />
		<input type="hidden" name="searchValue" value="<%=searchValue %>" />
		<input type="hidden" name="curPage" value="<%=curPage %>" />

  </body>
</html>