package com.sist.web.model;
import java.io.*;

public class Diary7 implements Serializable
{
	private static final long serialVersionUID = 1L;
	
    private long diaryN;
    private String uId;
    private String dTitle;
    private String dContent;
    private String regDate;
    
	public long getDiaryN() {
		return diaryN;
	}
	public void setDiaryN(long diaryN) {
		this.diaryN = diaryN;
	}
	public String getuId() {
		return uId;
	}
	public void setuId(String uId) {
		this.uId = uId;
	}
	public String getdTitle() {
		return dTitle;
	}
	public void setdTitle(String dTitle) {
		this.dTitle = dTitle;
	}
	public String getdContent() {
		return dContent;
	}
	public void setdContent(String dContent) {
		this.dContent = dContent;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}	
}
