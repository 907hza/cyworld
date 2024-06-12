<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>
<%@ page import="com.sist.web.util.CookieUtil" %>
<%@ page import="com.sist.web.dao.UserDao7" %>
<%@ page import="com.sist.web.model.User7" %>
<%@ page import="com.sist.web.dao.BoardDao7" %>
<%@ page import="com.sist.web.model.Board7" %>
<%@ page import="com.sist.web.model.Diary7" %>
<%@ page import="com.sist.web.model.GuestBook7" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.model.Paging7" %>
<%@ page import="com.sist.web.model.PagingConfig7" %>
<%@ page import="java.util.List" %> 

<%
	Logger logger = LogManager.getLogger("/board/list7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	long curPage = 1L;
	
	long totalCount = 0; // 총 게시물 수
	
	List<Board7> list = null;
	
	Paging7 paging7 = null;
	
	Board7 board7 = new Board7();
	BoardDao7 boardDao7 = new BoardDao7();
	Diary7 diary7 = new Diary7();
	GuestBook7 guestBook7 = new GuestBook7();
	
	totalCount = boardDao7.boardPaging(board7);
	
	if(totalCount > 0)
	{
		paging7 = new Paging7(totalCount, PagingConfig7.FIRST_NUM, PagingConfig7.LAST_NUM, curPage);
		
		board7.setStartRow(paging7.getStartRow());
		board7.setEndRow(paging7.getEndRow());
		
		list = boardDao7.cy_bSelect(board7);
	}
%>

<!DOCTYPE html>
<html lang="ko">
  <head>

    <meta charset="UTF-8" />
    <title>MINI HOMEPAGE</title>
    <link rel="stylesheet" href="/resources/css/layout.css" />
    <link rel="stylesheet" href="/resources/css/font.css" />
    <link rel="stylesheet" href="/resources/css/home.css" />

	<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/icia.common.js"></script>
	<script>
		
	$(document).ready(function(){
		
	});
		function fn_view(boardN)
		{
			document.bbsForm.boardN.value = boardN;
			document.bbsForm.action = "/board/boardView7.jsp";
			document.bbsForm.submit();
		}
				
	</script>
  </head>
  <body>
    <div class="bookcover">
      <div class="bookdot">
        <div class="page">
 
			<%@ include file="/include/head7.jsp" %>

          <div class="content-container" >
            <div class="header content-title" >
              <div class="content-title-name">ㅅrOi 좋은 ㅆrOi월드</div>
              
              <div class="content-title-url" >
              </div>
            </div>
            <div class="box content-box">
              <div class="box-title">Updated news</div>
              <div class="news-flex-box">
                <div class="news-box">
                  <div class="news-row"></div>
                  
         <%
         	if(list != null && list.size() > 0)
         	{
         		long startNum = paging7.getStartNum();
         		
         		for(int i=0 ; i<list.size()-5 ; i++)
         		{
         			Board7 board = list.get(i);
          %>

                   <div class="news-row">
                    <div class="news-category category-post">게시판</div>
                    <a href="javascript:void(0)" onclick="fn_view(<%=board.getBoardN() %>)" style="color:black; text-decoration: blue solid underline;" class="news-title"><%=board.getbTitle()%></a>
                  </div>  
          <%
          			startNum--;
         		}
         	}
         	else
         	{
          %>
          		<tr><td colspan="5"></td></tr>
          <%
         	}
          %> 		    
                  <div class="news-row">
                  </div>
                  <div class="news-row">
                  </div>
                </div>
                <div class="update-box">
                  <div class="menu-row">
                    <div class="menu-item">게시판<span class="menu-num"></span><%=boardDao7.boardTotal(board7) %></div>
                    <div class="menu-item">다이어리<span class="menu-num"></span><%=boardDao7.diaryTotal(diary7) %></div>
                  </div>
                  <div class="menu-row">
                    <div class="menu-item">방명록<span class="menu-num"></span><%=boardDao7.guestTotal(guestBook7) %></div>
                    <div class="menu-item"><span class="menu-num"></span></div>
                  </div>
                </div>
              </div>
              <div class="miniroom">
                <div class="box-title"></div>
                <div class="miniroom-gif-box">
                  <img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA0MTJfMjYx%2FMDAxNjQ5NzUxNTkxOTk2.DaafcgFNmOK6bkQ_sDACBJvAnfm_Mwc6pUPPtNFDoDMg.bAga14KbywhQ4En3YnSjGO5sU6gSNkADZc3AhGMnyMYg.JPEG.9497633%2FIMG_9011.JPG&type=sc960_832" style="max-width: 100%; height: 360px;"/>
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
  </body>
</html>