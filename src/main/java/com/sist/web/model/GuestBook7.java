package com.sist.web.model;
import java.io.*;

public class GuestBook7 implements Serializable
{
	private static final long serialVersionUID = 1L;
	
    private long guestN;
    private String uId;
    private String uNickname;
    private String guestContent;
    private String regDate;
    
	public long getGuestN() {
		return guestN;
	}
	public void setGuestN(long guestN) {
		this.guestN = guestN;
	}
	public String getuId() {
		return uId;
	}
	public void setuId(String uId) {
		this.uId = uId;
	}
	public String getuNickname() {
		return uNickname;
	}
	public void setuNickname(String uNickname) {
		this.uNickname = uNickname;
	}
	public String getGuestContent() {
		return guestContent;
	}
	public void setGuestContent(String guestContent) {
		this.guestContent = guestContent;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
}
