package com.sist.web.model;

import java.io.Serializable; // 역직렬화를 위해 선언

public class Board implements Serializable
{
	private static final long serialVersionUID = 1L; 
	// 역직렬화를 위해서 기본적으로 가지고 있어야하는 값 (꼭 정의해야한다)
	
	private long bbsSeq; // 시퀀스번호
	private String userId;
	private String bbsName;
	private String bbsEmail;
	private String bbsPwd;
	private String bbsTitle;
	private String bbsContent;
	private int bbsReadCnt;
	private String regDate;
	
	// ROWNUM 에 사용할 시작과 끝 변수를 생성해준다
	// WHERE RNUM BETWEEN 1 AND 5; > 시작 : 1, 끝 : 5
	private long startRow;
	private long endRow;
	
	public Board()
	{ // 초기값 세팅했으니까 null 아님
		bbsSeq = 0;
		userId = "";
		bbsName = "";
		bbsEmail = "";
		bbsPwd = "";
		bbsTitle = "";
		bbsContent = "";
		bbsReadCnt = 0;
		regDate = "";
		
		startRow = 0;
		endRow = 0;
	}

	public long getBbsSeq() {
		return bbsSeq;
	}

	public void setBbsSeq(long bbsSeq) {
		this.bbsSeq = bbsSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getBbsName() {
		return bbsName;
	}

	public void setBbsName(String bbsName) {
		this.bbsName = bbsName;
	}

	public String getBbsEmail() {
		return bbsEmail;
	}

	public void setBbsEmail(String bbsEmail) {
		this.bbsEmail = bbsEmail;
	}

	public String getBbsPwd() {
		return bbsPwd;
	}

	public void setBbsPwd(String bbsPwd) {
		this.bbsPwd = bbsPwd;
	}

	public String getBbsTitle() {
		return bbsTitle;
	}

	public void setBbsTitle(String bbsTitle) {
		this.bbsTitle = bbsTitle;
	}

	public String getBbsContent() {
		return bbsContent;
	}

	public void setBbsContent(String bbsContent) {
		this.bbsContent = bbsContent;
	}

	public int getBbsReadCnt() {
		return bbsReadCnt;
	}

	public void setBbsReadCnt(int bbsReadCnt) {
		this.bbsReadCnt = bbsReadCnt;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
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
}
