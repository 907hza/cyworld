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
<%@ page import="java.util.*" %> 
<%@ page import="java.time.LocalDate" %>


<%
	Logger logger = LogManager.getLogger("board/diaryView7.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String cookieUserId = CookieUtil.getValue(request,"U_ID");
	
	long curPage = HttpUtil.get(request,"curPage",(long)1);
	
	List<Diary7> list = null;
	
	Board7 board7 = new Board7();
	BoardDao7 boardDao7 = new BoardDao7();
	long diaryN = HttpUtil.get(request, "diaryN", (long)1);
	Diary7 diary7 = boardDao7.dSelect(diaryN);
			
	long totalCount = 0; // 총 게시물 수
	
	Paging7 paging7 = null;
	
	totalCount = boardDao7.diaryTotal(diary7);
		
	if(totalCount > 0)
	{
		paging7 = new Paging7(totalCount, PagingConfig7.FIRST_NUM, PagingConfig7.LAST_NUM, curPage);
		
		board7.setStartRow(paging7.getStartRow());
		board7.setEndRow(paging7.getEndRow());
		list = boardDao7.cy_dSelect(diary7);
	}
	
	int dDay = 0;
%>

<!DOCTYPE html>
<html lang="ko">
  <head>
  <style>
  	a:-webkit-any-link {
  		color:olivedrab;
  	}
  </style>
    <meta charset="UTF-8" />
    <title>MINI HOMEPAGE</title>
    <link rel="stylesheet" href="/resources/css/layout.css" />
    <link rel="stylesheet" href="/resources/css/font.css" />
    <link rel="stylesheet" href="/resources/css/home.css" />
    <script src="https://kit.fontawesome.com/ab54b9d48d.js" crossorigin="anonymous"></script>
    <script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/icia.common.js"></script>
    
    <script>
    $(document).ready(function(){
		<%
		System.out.println("cookieUserId : "+cookieUserId);
		System.out.println("diary7.getuId() : "+diary7.getuId());
    			if(StringUtil.equals(cookieUserId, diary7.getuId()))
    			{
    	%>			
					$("#btnWrite").on("click",function(){
						document.bbsForm.diaryN.value  = "";
						document.bbsForm.action = "/board/dWrite7.jsp";
						document.bbsForm.submit();
					});	
    	<%
    			}
    		
    	%>
    	});
    </script>

  </head>
  <body>
    <div class="bookcover">
      <div class="bookdot">
        <div class="page">
			<%@ include file="/include/head7.jsp" %>
          <div class="content-container">
            <div class="header content-title">
                <div class="content-title-name">ㅅrOi 좋은 ㅆrOi월드</div>
            </div>
            <div class="box content-box" >
<%
	if(diary7 != null) // 보드 객체가 있을 때만 해당 페이지를 보여줄 것, 없으면 list.jsp 로 복귀
	{
%>
                <div class="calendar" style="font-size:12; display:inline-block; text-align:center; border:white;">
                   <div class="date-today">
                       <script>
	                        let today = new Date();   
	
	                        let year = today.getFullYear(); // 년도
	                        let month = today.getMonth() + 1;  // 월	                        
	                        
	                        document.write(year + '/' + month)
	                       
                        </script>
                    </div>
                  <%
                  
	                  LocalDate date = LocalDate.now();
	                  int year = date.getYear();
	                  int month = date.getMonthValue();
	                  int eE = 0;
	                  Calendar cal = Calendar.getInstance();
	                  cal.getActualMaximum(Calendar.DAY_OF_MONTH);// 해당 월의 마지막 날
	                  
				/*    1.연도를 4으로 균등하게 나눌 수 있는 경우 2단계로 이동합니다. 그렇지 않으면 5단계로 이동하세요.
	                  2.연도를 100으로 균등하게 나눌 수 있는 경우 3단계로 이동합니다. 그렇지 않으면 4단계로 이동하세요.
	                  3.연도를 400으로 균등하게 나눌 수 있는 경우 4단계로 이동합니다. 그렇지 않으면 5단계로 이동하세요.
	                  4.해당 연도는 윤년(366일)입니다.
	                  5.해당 연도는 윤년이 아닙니다(365일). */
	                  
	                  if(year%4 == 0) // 단순 윤년 구하기 위함
	                  {
	                	  if(year%100 == 0)
	                	  {
	                		  if(year%400 == 0)
	                		  {
	                			  eE = 29;
	                		  }
	                		  else eE = 28;
	                	  }
	                	  else eE = 28;
	                  }
	                  else eE = 28;
	                  
	                  if(month == 2)
	                  {
	                	  for(int d =1; d<=eE ; d++)
	                	  {
	               %>
		                	  <span class="date"><a href="javascript:void(0)" ><%=d %></a></span>
		                	  
		                      <% if(d==10 || d==20)
		                       {
		                      %>
		                  			<br>
		                  	 <%}
	                	  }
	              %>

	              <%
	              	  }
	              	  else  // 아닐 경우 자동적으로 해당 월의 마지막 날을 가져오는 함수 이용
					  {
					       for(int j=1 ; j<=cal.getActualMaximum(Calendar.DAY_OF_MONTH) ; j++) 
		                  {
		              %>
		                	  <span class="date"><a href="javascript:void(0)" ><%=j %></a></span>
		                	  
		                      <% if(j==10 || j==20)
		                       {
		                      %>
		                  			<br>
		                  	 <%}
	                 	  }
	              }%>

                    <div class="date-list">
  		<%
     	if(list != null && list.size() > 0)
     	{
     		long startNum = paging7.getStartNum();
     		
     		for(int i=0 ; i<list.size() ; i++)
     		{
     			Diary7 diary = list.get(i);
  		%>
                    </div>
                </div>
                <div class="diary-scrollbox">
                    <div class="diary" style="border:white">
                    <table>
                        <tr>
                        <td><div class="diary-date" style="font-size:12px; width:70px; heigth:70px;">
                        <%=diary.getRegDate() %>
                        </div></td>
                        <td><div class="diary-contents" style="font-size:13px; border:1px solid #EDEDF0; width:350px; heigth:200px; padding:15px;">
                        <%=diary.getdTitle() %><p><%=diary.getdContent() %></p></div> </td>
                        </div>
                        </tr>
        <%			 startNum--;
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
<% 
	}
%>
            </div>
            </div>
                    <div class="button-box">
                    <br><br>
                      <button style="color:white; background-color:olivedrab;"  id="btnWrite" class="diary-button font-neo">
                        <i class="fas fa-lock"></i> 비밀 일기 등록하기
                      </button>
                    </div>
        </div>

          <div class="menu-container">
          <%@ include file="/include/navigation7.jsp" %>

          </div>
        </div>
      </div>
    </div>
<form name="bbsForm" id="bbsForm" method="post">
	<input type="hidden" name="diaryN" value="" >
	<input type="hidden" name="curPage" value="<%=curPage %>">	
</form>
  </body>
</html>