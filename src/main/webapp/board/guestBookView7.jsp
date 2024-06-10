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
	Logger logger = LogManager.getLogger("board/guestBookView7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request, "U_ID");
	
	long curPage = HttpUtil.get(request,"curPage",(long)1);
	long boardN = HttpUtil.get(request, "boardN", (long)1);
	long guestN = HttpUtil.get(request, "guestN", (long)1);

		
	List<GuestBook7> list = null;
	
	Board7 board7 = new Board7();
	BoardDao7 boardDao7 = new BoardDao7();
	GuestBook7 guestBook7 = boardDao7.gSelect(guestN);
	
	list = boardDao7.cy_gSelect(guestBook7);
		
	long totalCount = 0; // 총 게시물 수
	
	Paging7 paging7 = null;
	
	totalCount = boardDao7.guestTotal(guestBook7);
	
	if(totalCount > 0)
	{
		paging7 = new Paging7(totalCount, PagingConfig7.FIRST_NUM, PagingConfig7.LAST_NUM, curPage);
		
		list = boardDao7.cy_gSelect(guestBook7);
	}
%>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>MINI HOMEPAGE</title>
    <link rel="stylesheet" href="/resources/css/layout.css" />
    <link rel="stylesheet" href="/resources/css/font.css" />
    <link rel="stylesheet" href="/resources/css/guestbook.css" />
    <script src="https://kit.fontawesome.com/ab54b9d48d.js" crossorigin="anonymous"></script>
    <script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/icia.common.js"></script>
	
	<script>
		$(document).ready(function(){

			$("#btnDelete").on("click",function(){
				
				if($.trim($("#deleteN").val()) == "" )
				{
					alert("삭제할 방명록의 번호를 작성ㅎH주세요.");
					$("#deleteN").val("")
				}

				if(confirm("ㅎH당 방명록을 삭제ㅎrㅅi겠나요?") == true)
				{
					document.bbsForm.action = "/board/gDelete7.jsp";
					document.bbsForm.submit();
				}

			});

		});
	</script>
  </head>
  <body>
<%
	if(guestBook7 != null) // 보드 객체가 있을 때만 해당 페이지를 보여줄 것, 없으면 list.jsp 로 복귀
	{
%>
    <div class="bookcover">
      <div class="bookdot">
        <div class="page">
			<%@ include file="/include/head7.jsp" %>

          <div class="content-container">
            <div class="header content-title">
                <div class="content-title-name">ㅅrOi 좋은 ㅆrOi월드</div>
                
            </div>
            <div class="box content-box">
                <div class="guestbook-scrollbox">

  		<%
     	if(list != null && list.size() > 0)
     	{
     		long startNum = paging7.getStartNum();
     		
     		for(int i=0 ; i<list.size() ; i++)
     		{
     			GuestBook7 guestBook = list.get(i);
  		%>                
	                    <div class="guestbook-box">
	                        <div class="guestbook-title">No. <%=guestBook.getGuestN() %> &nbsp;
	                            <span style = "color :#5c3ccf"><%=guestBook.getuNickname() %></span> &nbsp;
	                            <i class="fas fa-home"></i> &nbsp; &nbsp;
	                        <div class="guestbook-date"> <%=guestBook.getRegDate() %></div> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
	                        </div>
	                        <div class="guestbook-contents">
	                            <div class="guestbook-image background-1">
	                           <%
	                           		if(guestBook.getGuestN() %2 == 0)
	                           		{
	                           %> 
	                                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3fAmrINLoV6gdrTn4MLRlTh9iwWKTDxpGsg&usqp=CAU" alt="프로필 사진" />
	                            <%
	                           		}
	                           		else
	                           		{
	                            %>
	                            	<img src="data:image/jpeg;base64,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" alt="프로필 사진" />
	                            <%
	                           		}
	                            %>
	                            </div>
	                            <div class="guestbook-text">
	                                <p><%=guestBook.getGuestContent() %></p>
	                            </div>
	                        </div>
	                    </div>

        <%
        			startNum--;
     		}
     	}
         else
        {
          %>
          		<tr><td colspan="5">조회ㅎr신 항목Oi 존ㅈHㅎrㅈi 않습ㄴiㄷr.</td></tr>
          <%
       	}
          %>
            </table>
            	                    
                </div>  
            </div>
        </div>
        <div class="menu-container">
            <div class="menu-button">
            <%@ include file="/include/navigation7.jsp" %>
            </div>
          </div>
    </script>
<% 
	}
%>
<form name="bbsForm" id="bbsform" method="post">
	<input type="hidden" id="guestN" name="guestN" value="<%=guestN%>">
	<input type="hidden" id="boardN" name="boardN" value="<%=boardN%>">
	<input type="hidden" id="curPage" name="curPage" value="<%=curPage %>" >
</form>
</body>
</html>