<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.Logger" %>
<%@ page import="com.sist.web.util.HttpUtil" %>  <%-- HttpUtil 과 Logger 를 new 객체 선언하지 않은 이유는 static 이기 때문이다--%>
<%@ page import="com.sist.web.dao.BoardDao" %>
<%@ page import="com.sist.web.model.Board" %>
<%@ page import="com.sist.common.util.StringUtil" %>
<%@ page import="com.sist.web.model.Paging" %>
<%@ page import="com.sist.web.model.BoardFileConfig" %> 
<%--BoardFileConfig 은 static 이 아니지만 안에 들어있는 변수들이 final 상수밖에 없기 때문에 객체 선언을 하지 않아도 된다--%>


<%-- 로그인하지 않은 사람도 게시판의 글을 볼 수 있으며 글쓰기는 회원만 가능하다 --%>
<%
			// TIP  뭐부터 봐야하는지 : 화면부터 본다 > 만약 게시판을 분석하려고 할 때
			// 화면에서 게시판을 눌러서 URL 에 찍히는 해당 jsp 부터 들어가서 보면 된다
			// 그 후 임포트 확인하지 말고 소스 하나씩 보다가 모르겠으면 디버깅용으로 System.out.println을 찍어보면 된다
	
	// 로그찍기용
	Logger logger = LogManager.getLogger("/board/list.jsp");
	HttpUtil.requestLogString(request, logger);
	
	// 조회 항목 (1 : 작성자, 2 : 제목, 3 : 내용 > 우리가 아래에서 설정한 값)
	// 요청값이 없다면 기본 "" 설정
	String searchType = HttpUtil.get(request, "searchType", "");
	
	// 조회 값
	// 요청 값이 없다면 기본 "" 설정
	String searchValue = HttpUtil.get(request, "searchValue" ,"");
	
	// 현재 페이지
	long curPage = HttpUtil.get(request, "curPage", (long)1); // 맨 뒤는 없을 때의 기본값 // 값 세팅
	
	// 총 게시물 수
	long totalCount = 0;
	
	// 게시물 리스트
	List<Board> list = null; 
	
	
	// 페이징 객체
	Paging paging = null;
	// 인스턴스로만 있기 때문에 객체 생성해서 메모리 주소를 할당받아야한다
	
	Board search = new Board();
	BoardDao boardDao = new BoardDao();
	
	if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) // 조회항목과 조회값 둘다 있는 경우
	{
		if(StringUtil.equals(searchType, "1")) // 작성자조회
		{
			search.setBbsName(searchValue);
		}
		else if(StringUtil.equals(searchType, "2")) // 제목 조회
		{
			search.setBbsTitle(searchValue);
		}
		else if(StringUtil.equals(searchType, "3")) // 내용 조회
		{
			search.setBbsContent(searchValue);
		}
	}
	else
	{
		searchType = ""; // 하나라도 비어있으면 둘다 공백처리
		searchValue = "";
	}
	
	totalCount = boardDao.boardTotalCount(search);  // 객체 하나에 담아서 보냄
	// totalCount 를 Paging 객체에 넣어줘야하기 때문에 total 후 Pagigng 객체 생성
	logger.debug("==================================");
	logger.debug("게시판 총 게시물 수 : " + totalCount);
	logger.debug("==================================");
	
	if(totalCount > 0)
	{
		paging = new Paging(totalCount, BoardFileConfig.LIST_COUNT, BoardFileConfig.PAGE_COUNT, curPage);
		
		search.setStartRow(paging.getStartRow());
		search.setEndRow(paging.getEndRow());
		
		list = boardDao.boardList(search);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/include/head.jsp" %>
<script>
	$(document).ready(function() { // 페이지가 로딩되면 자동으로 시작하는 함수
		
		$("#_searchType").change(function(){ // 조회목록이 변경됐을때 안의 항목이 자동으로 변환됨 : change > 조회 내용을 날려줌
			$("#_searchValue").val("");
		});
    	
		$("#btnSearch").on("click", function(){ // 조회 버튼 눌렀을 때
			
			if($("#_searchType").val() != "")
			{
				if($.trim($("#_searchValue").val()) == "")
				{
					alert("조회항목 선택시 조회값을 입력하세요.");
					$("#_searchValue").val("");
					$("#_searchValue").focus();
					return;
				}
			}
			
			document.bbsForm.bbsSeq.value = ""; // 조회항목이 바뀌었을때 조회되는 게시글 수가 초기화되도록 > 브라우저에서 실행 : 프론트
			document.bbsForm.searchType.value = $("#_searchType").val(); 
			document.bbsForm.searchValue.value = $("#_searchValue").val();
			// 글을 클릭하고 리스트로 돌아갔을때 그 전 화면으로 돌아가기 위해서 조회항목과 조회값을 가지고 가는 것
			// "" 처리를 안했다는 것은 그 값을 유지시킨채 form 에 저장해두는 것
			document.bbsForm.curPage = "";
			document.bbsForm.action = "/board/list.jsp"; // 현재 페이지 조회항목만 바꾸어서 접속
			document.bbsForm.submit();
		});
		
		$("#btnWrite").on("click",function(){ // 글쓰기 버튼 눌렀을 때 
			document.bbsForm.bbsSeq.value = ""; // action 에서 안쓰는 값이면 초기화처리해줘야한다
			document.bbsForm.action = "/board/write.jsp";
			document.bbsForm.submit();
		});
		
	});
	
	
	function fn_list(curPage) // 지역변수라 신경 ㄴㄴ
	{
		document.bbsForm.bbsSeq.value = "";
		document.bbsForm.curPage.value = curPage;
		document.bbsForm.action = "/board/list.jsp"; // 현재 페이지 번호만 바꾸어서 접속
		document.bbsForm.submit();
	}
	
	function fn_view(bbsSeq) // 유일성을 통해 해당 보드의 상세 정보를 가지고 올 것
	{
		document.bbsForm.bbsSeq.value = bbsSeq;
		document.bbsForm.action = "/board/view.jsp";
		document.bbsForm.submit();
	}

</script>
</head>

<body>
<%@ include file="/include/navigation.jsp" %>
<div class="container">
   
   <div class="d-flex">
      <div style="width:50%;">
         <h2>게시판</h2>
      </div>
      <div class="ml-auto input-group" style="width:50%;">
         <select name="_searchType" id="_searchType" class="custom-select" style="width:auto;">
            <option value="">조회 항목</option>
            <option value="1" <%if(StringUtil.equals(searchType, "1")){%> selected <%}%> >작성자</option>
            <option value="2" <%if(StringUtil.equals(searchType, "2")){%> selected <%}%> >제목</option>
            <option value="3" <%if(StringUtil.equals(searchType, "3")){%> selected <%}%> >내용</option>
         </select>
         <input type="text" name="_searchValue" id="_searchValue" value="<%=searchValue %>" class="form-control mx-1" maxlength="20" style="width:auto;ime-mode:active;" placeholder="조회값을 입력하세요." />
         <button type="button" id="btnSearch" class="btn btn-secondary mb-3 mx-1">조회</button>
      </div>
    </div>
    
   <table class="table table-hover">
      <thead>
      <tr style="background-color: #dee2e6;">
         <th scope="col" class="text-center" style="width:10%">번호</th>
         <th scope="col" class="text-center" style="width:45%">제목</th>
         <th scope="col" class="text-center" style="width:10%">작성자</th>
         <th scope="col" class="text-center" style="width:25%">날짜</th>
         <th scope="col" class="text-center" style="width:10%">조회수</th>
      </tr>
      </thead>
      <tbody>
<%
	if(list != null && list.size() > 0)
	{
		long startNum = paging.getStartNum();
		
		for(int i=0 ; i<list.size() ; i++)
		{
			Board board = list.get(i); // 보드객체의 시작 주소를 board 에 하나씩 담아줌
%>      
      <tr> <!-- list 객체가 있는 경우에만 보여줄 것 -->
         <td class="text-center"><%=startNum%></td> 
         <%-- fn_view 에 보고 싶은 글을 클릭했을때 bbsSeq 만 가지고 가면 된다 > 유일성 > 해당 글의 상세 글 내용과 여러가지 확인 가능--%>
         <td><a href="javascript:void(0)" onclick="fn_view(<%=board.getBbsSeq()%>)"><%=board.getBbsTitle() %></a></td>
         <td class="text-center"><%=board.getBbsName() %></td>
         <td class="text-center"><%=board.getRegDate() %></td>
         <td class="text-center"><%=StringUtil.toNumberFormat(board.getBbsReadCnt()) %></td> 
         <!-- 숫자 세자리마다 따옴표 붙어주는 용도의 StringUtil.toNumberFormat 메소드 -->
      </tr>
<%
			startNum--; //  글 번호 순서 DESC
		}
	}
	else
	{
%>
		<tr><td colspan="5">조회하신 항목이 존재하지 않습니다.</td></tr>
<%
	}
%>  
      </tbody>
      <tfoot>
      <tr>
            <td colspan="5"></td>
        </tr>
      </tfoot>
   </table>
   <nav>
      <ul class="pagination justify-content-center">
      
    <%
      	if(paging != null) // 페이징이 널과 같지 않을 때 보여줄 것
      	{	
      		if(paging.getPrevBlockPage() > 0) // 이전블럭과 다음블럭은 보여줄지 말지만 체크해주면 된다
      		{
    %>			
        		 <!-- li class="page-item"><a class="page-link" href="">처음</a></li -->         
         		<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(<%=paging.getPrevBlockPage()%>)">이전블럭</a></li>
    <% 
      		}
        	for(long i=paging.getStartPage() ; i<=paging.getEndPage() ; i++) // 시작페이지부터 끝 페이지까지 ++
        	{
        		if(paging.getCurPage() != i) // 다른 페이지 : 현재 페이지가 i 값과 같지 않다면
        		{
    %>
  			       <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(<%=i%>)"><%=i %></a></li> 
  			       <!-- href 속성 값에 javascript:void(0) 을 지정하는 것은 링크 기능을 무효화시키는 것
  			            void 연산자가 undefind 값을 리턴하게 되는데 이런 경우 아무런 동작을 할 수 없게 된다
  			            void() 안에 아무 숫자나 아무 영문자 사용해도 되지만, 일반적으로는 0 을 넣는다 -->
	<%
        		}
        		else // 같은 페이지 : 현재 페이지가 i 값과 동일하다면
        		{
	%>
    		       <li class="page-item active"><a class="page-link" href="javascript:void(0)" style="cursor:default;"><%=i %></a></li> <!-- 현재 페이지 --> 
    <%
        		}
        	}
        	
        	if(paging.getNextBlockPage() > 0)
        	{
    %>
        		 <li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_list(<%=paging.getNextBlockPage()%>)">다음블럭</a></li>
    <%
        	}
      	}
    %>
      </ul>
   </nav>
   
   <button type="button" id="btnWrite" class="btn btn-secondary mb-3">글쓰기</button>
   
   <!-- form 태그 만든 이유 : input type 이 hidden 으로만 구성된 폼은 request 용도 -->
   <!-- 위에 폼태그가 없어서 post 방식으로 넘길 수 없음
        request 할때 필요한 데이터를 담아서 보내기 위해서 form 따로 생성
        게시판 전체를 보내지 않기 위해서 >> 필요한 값들만 보내주려고 생성한 폼 
        ++ >> 글쓰기용, 페이지 번호 눌렀을 때용 등등 여러 기능들로 나누어서 폼 여러개를 생성할수도 있음 -->
   <form name="bbsForm" id="bbsForm" method="post"> <!--  값 담아서 submit 하기 위한 용도 -->
   		<input type="hidden" name="bbsSeq" value="" />
   		<input type="hidden" name="searchType" value="<%=searchType %>" />
   		<input type="hidden" name="searchValue" value="<%=searchValue %>" />
   		<input type="hidden" name="curPage" value="<%=curPage %>" />
   </form>
   
</div>
</body>
</html>