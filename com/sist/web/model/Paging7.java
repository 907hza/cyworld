package com.sist.web.model;

import java.io.Serializable;

// model 에 있는건 다 데이터로 쓰기 위한 변수들 선언하는 .java 들
public class Paging7 implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private long totalCount; // 총 게시물 수
	private long totalPage;  // 총 페이지 수
	private long startRow;   // 게시물 시작 : 오라클에서의 rownum
	private long endRow;     // 게시물 끝 : 오라클에서의 rownum
	private long listCount;  // 한 페이지의 게시물 수
	private long pageCount;  // 페이징 범위의 수
	private long curPage;    // 현재 페이지
	
	private long startPage;  // 시작 페이지 번호
	private long endPage;    // 종료 페이지 번호
	
	private long totalBlock; // 총 블럭 수
	private long curBlock;   // 현재 블럭
	
	private long prevBlockPage; // 이전 블럭 페이지
	private long nextBlockPage; // 다음 블럭 페이지
	
	private long startNum; // 시작 번호 (게시물 번호 적용할 변수 DESC)
	
	public Paging7(long totalCount, long listCount, long pageCount, long curPage) // 값 세팅을 위한 생성자 (매개변수 필수)
	{ // 페이징 처리를 위해 필요한 필수 값 : 전체 페이지 수, 한 페이지에서의 게시물 수, 페이징 범위의 수, 현재 페이지
		this.totalCount = totalCount;
		this.listCount = listCount;
		this.pageCount = pageCount;
		this.curPage = curPage;
		 
		// totalCount 가 0보다 크면 값을 다 세팅해줄 것
		if(totalCount > 0)
			pagingProc7(); // 전체 페이지 갯수가 1개이상 있으면 페이징 계산 프로세스를 이용해서 값을 설정해준다
	}

	public long getTotalCount() {
		return totalCount;
	}


	public void setTotalCount(long totalCount) {
		this.totalCount = totalCount;
	}


	public long getTotalPage() {
		return totalPage;
	}


	public void setTotalPage(long totalPage) {
		this.totalPage = totalPage;
	}


	public long getStartRow() {
		return startRow;
	}


	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}


	public long getEndRow() {
		return endRow;
	}


	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}


	public long getListCount() {
		return listCount;
	}


	public void setListCount(long listCount) {
		this.listCount = listCount;
	}


	public long getPageCount() {
		return pageCount;
	}


	public void setPageCount(long pageCount) {
		this.pageCount = pageCount;
	}


	public long getCurPage() {
		return curPage;
	}


	public void setCurPage(long curPage) {
		this.curPage = curPage;
	}


	public long getStartPage() {
		return startPage;
	}


	public void setStartPage(long startPage) {
		this.startPage = startPage;
	}


	public long getEndPage() {
		return endPage;
	}


	public void setEndPage(long endPage) {
		this.endPage = endPage;
	}


	public long getTotalBlock() {
		return totalBlock;
	}


	public void setTotalBlock(long totalBlock) {
		this.totalBlock = totalBlock;
	}


	public long getCurBlock() {
		return curBlock;
	}


	public void setCurBlock(long curBlock) {
		this.curBlock = curBlock;
	}


	public long getPrevBlockPage() {
		return prevBlockPage;
	}


	public void setPrevBlockPage(long prevBlockPage) {
		this.prevBlockPage = prevBlockPage;
	}


	public long getNextBlockPage() {
		return nextBlockPage;
	}


	public void setNextBlockPage(long nextBlockPage) {
		this.nextBlockPage = nextBlockPage;
	}


	public long getStartNum() {
		return startNum;
	}


	public void setStartNum(long startNum) {
		this.startNum = startNum;
	}


	// 페이징 계산 프로세스
	private void pagingProc7()
	{
		// 총 페이지 수를 구할 것
		totalPage = (long)Math.ceil((double)totalCount / listCount); 
		// ((double)totalCount / listCount) 가 실수이기 때문에 Math.ceil 올림 처리
		
		// 총 블럭 수 구할 것
		totalBlock = (long)Math.ceil((double)totalPage / pageCount);
		
		// 현재 블럭 구할 것
		curBlock = (long)Math.ceil((double)curPage / pageCount);
		
		// 시작 페이지 구할 것
		startPage = ((curBlock-1) * pageCount) + 1;
		
		// 끝 페이지 구할 것
		endPage = (startPage+pageCount) - 1;
		
		// 마지막 페이지 보정
		// : 총 페이지 보다 끝 페이지가 크다면 총 페이지를 마지막 페이지로 변환함
		if(endPage > totalPage)
		{
			endPage = totalPage; // 안맞는 경우가 있기에 보정
		}
		
		// 시작 rownum <오라클에서 사용할> 
		startRow = ((curPage-1) * listCount) + 1;
		
		// 끝 rownum <오라클에서 사용할>
		endRow = (startRow + listCount) - 1;
		
		// 게시물 시작 번호
		startNum = totalCount - ((curPage-1) * listCount);
		
		// 이전 블럭 페이지 번호
		if(curBlock > 1)
			prevBlockPage = startPage - 1;
		
		// 다음 블럭 페이지 번호
		if(curBlock < totalBlock)
			nextBlockPage = endPage + 1;
	}
}

