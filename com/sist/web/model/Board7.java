package com.sist.web.model;
import java.io.*;
import com.sist.web.model.User7;
import com.sist.web.dao.UserDao7;


public class Board7 implements Serializable
{
	private static final long serialVersionUID = 1L;
	
    private long boardN;
    private String uId;
    private long boardReadCnt;
    private long aFileNum;
    private String bPrivate;
    private String bTitle;
    private String bContent;
    private String regDate;
    private String uNickname;
    private long startRow;
    private long endRow;
    
    public Board7()
    {
    	
    	boardN =0;
        uId ="";
        boardReadCnt =0;
        aFileNum =0;
        bPrivate ="";
        bTitle ="";
        bContent ="";
        regDate ="";
        uNickname = "";
        startRow =0;
        endRow =0;
    }
    
    
	public String getuNickname() {
		return uNickname;
	}


	public void setuNickname(String uNickname) {
		this.uNickname = uNickname;
	}


	public long getBoardN() {
		return boardN;
	}
	public void setBoardN(long boardN) {
		this.boardN = boardN;
	}
	public String getuId() {
		return uId;
	}
	public void setuId(String uId) {
		this.uId = uId;
	}

	public long getBoardReadCnt() {
		return boardReadCnt;
	}
	public void setBoardReadCnt(long boardReadCnt) {
		this.boardReadCnt = boardReadCnt;
	}
	public long getaFileNum() {
		return aFileNum;
	}
	public void setaFileNum(long aFileNum) {
		this.aFileNum = aFileNum;
	}
	public String getbPrivate() {
		return bPrivate;
	}
	public void setbPrivate(String bPrivate) {
		this.bPrivate = bPrivate;
	}
	public String getbTitle() {
		return bTitle;
	}
	public void setbTitle(String bTitle) {
		this.bTitle = bTitle;
	}
	public String getbContent() {
		return bContent;
	}
	public void setbContent(String bContent) {
		this.bContent = bContent;
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
