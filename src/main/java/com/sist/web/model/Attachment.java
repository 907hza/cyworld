package com.sist.web.model;
import java.io.*;

public class Attachment implements Serializable
{
	private static final long serialVersionUID = 1L; 
	
	private static String aBoardtype;
	private static long aFileNum;
	private static long	boardN;
	private static String regDate;
	private static String aFilePath;
	private static String aFileName;
	private static String aFileSize;
	private static String aFileOrgname;
	private static String extension;
	private static long	diaryN;
	private static long	guestN;
	
	Attachment()
	{
		aBoardtype ="";
		aFileNum =0;
		boardN =0;
		regDate ="";
		aFilePath ="";
		aFileName ="";
		aFileSize ="";
		aFileOrgname ="";
		extension ="";
		diaryN =0;
		guestN =0;
	}

	public static String getaBoardtype() {
		return aBoardtype;
	}

	public static void setaBoardtype(String aBoardtype) {
		Attachment.aBoardtype = aBoardtype;
	}

	public static long getaFileNum() {
		return aFileNum;
	}

	public static void setaFileNum(long aFileNum) {
		Attachment.aFileNum = aFileNum;
	}

	public static long getBoardN() {
		return boardN;
	}

	public static void setBoardN(long boardN) {
		Attachment.boardN = boardN;
	}

	public static String getRegDate() {
		return regDate;
	}

	public static void setRegDate(String regDate) {
		Attachment.regDate = regDate;
	}

	public static String getaFilePath() {
		return aFilePath;
	}

	public static void setaFilePath(String aFilePath) {
		Attachment.aFilePath = aFilePath;
	}

	public static String getaFileName() {
		return aFileName;
	}

	public static void setaFileName(String aFileName) {
		Attachment.aFileName = aFileName;
	}

	public static String getaFileSize() {
		return aFileSize;
	}

	public static void setaFileSize(String aFileSize) {
		Attachment.aFileSize = aFileSize;
	}

	public static String getaFileOrgname() {
		return aFileOrgname;
	}

	public static void setaFileOrgname(String aFileOrgname) {
		Attachment.aFileOrgname = aFileOrgname;
	}

	public static String getExtension() {
		return extension;
	}

	public static void setExtension(String extension) {
		Attachment.extension = extension;
	}

	public static long getDiaryN() {
		return diaryN;
	}

	public static void setDiaryN(long diaryN) {
		Attachment.diaryN = diaryN;
	}

	public static long getGuestN() {
		return guestN;
	}

	public static void setGuestN(long guestN) {
		Attachment.guestN = guestN;
	}

}
