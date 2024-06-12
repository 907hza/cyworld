package com.sist.web.model;
import java.io.*;

public class CyLike implements Serializable
{
	private static long serialVersionUID = 1L;
	
	private long boardN;
	private String uId;
	
	CyLike()
	{
		boardN = 0;
		uId = "";
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
}