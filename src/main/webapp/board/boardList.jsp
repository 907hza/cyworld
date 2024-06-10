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
	Logger logger = LogManager.getLogger("/board/boardList.jsp");
	HttpUtil.requestLogString(request, logger);
	
	String searchType = HttpUtil.get(request,"searchType",""); // 조회항목
	String searchValue = HttpUtil.get(request,"searchValue",""); // 조회 값

	long curPage = HttpUtil.get(request, "curPage",(long)1); // 현재 페이지

	long totalCount = 0; // 총 게시물 수
	
	List<Board7> list = null;
	
	Paging7 paging7 = null;
	
	Board7 board7 = new Board7();
	BoardDao7 boardDao7 = new BoardDao7();
	
	if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
	{
		if(StringUtil.equals(searchType,"1"))
			board7.setuNickname(searchValue);
		
		if(StringUtil.equals(searchType,"2"))
			board7.setbTitle(searchValue);
		
		if(StringUtil.equals(searchType,"3"))
			board7.setbContent(searchValue);
	}
	else
	{
		searchType = "";
		searchValue = "";
	}
	
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
<html>
<head>

<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
<script type="text/javascript" src="/resources/js/icia.common.js"></script>
<script>
	$(document).ready(function(){
		
		$("#_searchType").on("click",function(){
			$("#_searchValue").val("");
		});
		
		$("#btnSearch").on("click",function(){
			if($("#_searchType").val() != "")
			{
				if($.trim($("#_searchValue").val()) == "")
				{
					alert("조회ㅎr실 조회값을 입력ㅎr세요.");
					$("#_searchValue").val("");
					$("#_searchValue").focus();
					return;
				}
			}
			
			document.bbsForm.boardN.value = "";
			document.bbsForm.searchType.value = $("#_searchType").val();
			document.bbsForm.searchValue.value = $("#_searchValue").val();
			
			document.bbsForm.curPage = "";
			document.bbsForm.action = "/board/boardList.jsp";
			
			document.bbsForm.submit();
		});
		
		$("#btnWrite").on("click",function(){
			document.bbsForm.boardN.value  = "";
			document.bbsForm.action = "/board/write7.jsp";
			document.bbsForm.submit();
		});
	});
	
	function fn_view(boardN)
	{
		document.bbsForm.boardN.value = boardN;
		document.bbsForm.action = "/board/boardView7.jsp";
		document.bbsForm.submit();
	}
	function fn_list(curPage) // 지역변수라 신경 ㄴㄴ
	{
		document.bbsForm.boardN.value = "";
		document.bbsForm.curPage.value = curPage;
		document.bbsForm.action = "/board/boardList.jsp"; // 현재 페이지 번호만 바꾸어서 접속
		document.bbsForm.submit();
	}
	
	
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
            <div class="box content-box">
              
              <div class="news-flex-box">
                <div class="news-box">
                <div class="box-title">게ㅅi판 글 조회</div>
                  <div class="news-row">
                  <select name="_searchType" id="_searchType" class="dropdown-title" style="width:auto;" >
            <option value="">조회 항목</option>
            
            <option value="1"    <%if(StringUtil.equals(searchType, "1")){ %>selected<%}%>>작성ㅈr</option>
            <option value="2"   <%if(StringUtil.equals(searchType, "2")){ %>selected<%} %>>제목</option>
            <option value="3" <%if(StringUtil.equals(searchType, "3")){%>selected<%}%>>ㄴH용</option>
            
         </select> &nbsp;
         <input type="text" name="_searchValue" id="_searchValue" value="<%=searchValue%>" class="form-control mx-1" maxlength="20" style="width:auto;ime-mode:active;" placeholder="조회값을 입력하세요." />
          &nbsp;<button type="button" id="btnSearch" class="menu-button">조회</button>
              
            </div>
            <div class="box content-box">
            <table class="table table-hover" >
            <thread>
            <th class="text-center" style="width:10%">번호</th>
            <th class="text-center" style="width:60%">제목</th>
            <th class="text-center" style="width:20%">작성자</th>
            <th class="text-center" style="width:10%">조회수</th>
            </thread>
            <tbody>
            
            </tbody>
         <%
         	if(list != null && list.size() > 0)
         	{
         		long startNum = paging7.getStartNum();
         		
         		for(int i=0 ; i<list.size() ; i++)
         		{
         			Board7 board = list.get(i);
         %>

         <tr>
         <td style="text-align: center;" ><%=startNum %></td>
         <td style="text-align: center;"><a href="javascript:void(0)" onclick="fn_view(<%=board.getBoardN()%>)"><%=board.getbTitle() %></a></td>
         <td class="test-center" ><%=board.getuNickname() %></td>
         <td class="test-center"><%=StringUtil.toNumberFormat(board.getBoardReadCnt()) %></td>
         </tr>
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
                  <div class="menu-row">
                  </div>
                  <div class="menu-row">
                    <div class="menu-item"><span class="menu-num"></span></div>
                  </div>
                
              </div>
                              <div class="box-title" style="text-align: center; border-bottom: 1px solid white;" >    		   
              
            <%
				if(paging7 != null)
				{
					if(paging7.getPrevBlockPage() > 0)
					{
			%>
						<button type="button" style="float: center;" class="page-link" href="javascript:void(0)" onclick="fn_list(<%=paging7.getPrevBlockPage()%>)">Oi전 페Oiㅈi</button>
			<%
					}
					
					for(long i=paging7.getStartPage() ; i<=paging7.getEndPage() ; i++)
					{
						if(paging7.getCurPage() != i)
						{
			%>
							<button type="button" style="float: center;" href="javascript:void(0)" onclick="fn_list(<%=i %>)"><%=i %></button>
			<%
						}
						else
						{
			%>
							<button type="button" style="float: center;" href="javascript:void(0)" style="cursor:default;"><%=i %></button>
			<%	
						}
					}
					
					if(paging7.getNextBlockPage() > 0)
					{
			%>
						<button type="button" style="float: center;" class="page-link" href="javascript:void(0)" onclick="fn_list(<%=paging7.getNextBlockPage() %>)">ㄷr음 페Oiㅈi</button>
			<%
					}
				}
            %>
                </div>
                
              
            </div>
            
             <button type="button" style="color:white; background-color:olivedrab;" id="btnWrite" class="diary-button font-neo">
             <i class="fas fa-lock"></i>글쓰ㄱi</button>
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
	<input type="hidden" name="boardN" value="">
	<input type="hidden" name="searchType" value="<%=searchType %>">
	<input type="hidden" name="searchValue" value="<%=searchValue %>">
	<input type="hidden" name="curPage" value="<%=curPage %>">	
</form>
    
  </body>
</html>