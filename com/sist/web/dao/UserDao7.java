package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;
import com.sist.web.model.User7;

public class UserDao7 // 사용자 조회, 입력, 생성
{
	private static Logger logger = LogManager.getLogger(UserDao7.class);
	
	// 사용자 조회
	public User7 uSelect(String uId)
	{
		User7 user7 = null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("		 SELECT U_NAME, U_PHONE,  NVL(U_EMAIL,'') U_EMAIL, ");
		sql.append("	        U_BIRTH, U_GENDER, U_NICKNAME, U_ID, U_PASSWORD ");
		sql.append("	        , REG_DATE, STATUS ");
		sql.append("	   FROM CY_USER ");
		sql.append("	  WHERE U_ID LIKE ? ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, uId);
			
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				user7 = new User7();
				
				user7.setuName(rs.getString("U_NAME"));
				user7.setuPhone(rs.getString("U_PHONE"));
				user7.setuEmail(rs.getString("U_EMAIL"));
				user7.setuBirth(rs.getString("U_BIRTH"));
				user7.setuGender(rs.getString("U_GENDER"));
				user7.setuNickname(rs.getString("U_NICKNAME"));
				user7.setuId(rs.getString("U_ID"));
				user7.setuPassword(rs.getString("U_PASSWORD"));
				user7.setRegDate(rs.getString("REG_DATE"));
				user7.setStatus(rs.getString("STATUS"));
				
			}
		}
		catch(Exception e)
		{
			logger.error("[UserDao7] uSelect SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		
		return user7;
	}
	
	// 아이디 중복 확인
	public int uIdSelectCount(String uId)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("  SELECT COUNT(U_ID) CNT");
		sql.append("    FROM CY_USER ");
		sql.append("   WHERE U_ID LIKE ? ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, uId);
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				count = rs.getInt("CNT");
			}
		}
		catch(Exception e)
		{
			logger.error("[UserDao7] uIdSelectCount SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		
		return count;
	}
	
	// 회원가입 완료한 회원 데이터에 저장
	public int uInsert(User7 user7)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("  INSERT INTO CY_USER ");
		sql.append("  VALUES (?,?,?,?,?,?,?,?,SYSDATE, 'Y') ");
		
		try
		{
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, user7.getuName());
			pstmt.setString(++idx, user7.getuPhone());
			pstmt.setString(++idx, user7.getuEmail());
			pstmt.setString(++idx, user7.getuBirth());
			pstmt.setString(++idx, user7.getuGender());
			pstmt.setString(++idx, user7.getuNickname());
			pstmt.setString(++idx, user7.getuId());
			pstmt.setString(++idx, user7.getuPassword());
			
			count = pstmt.executeUpdate();
			
		}
		catch(Exception e)
		{
			logger.error("[UserDao7] uInsert SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt,conn);
		}
		
		return count ;
	}
	
	public int uUpdate(User7 user7)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
				
		sql.append("	    UPDATE CY_USER ");
		sql.append("	       SET U_NAME = ?, ");
		sql.append("               U_PHONE = ?, ");
		sql.append("	           U_EMAIL = ?, ");
		sql.append("	           U_BIRTH = ?, ");
		sql.append("	           U_GENDER = ?, ");
		sql.append("	           U_NICKNAME = ?, ");
		sql.append("	           U_PASSWORD = ? ");
		sql.append("	     WHERE U_ID = ? ");
		
	    
		try
		{			
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, user7.getuName());
			pstmt.setString(++idx, user7.getuPhone());
			pstmt.setString(++idx, user7.getuEmail());
			pstmt.setString(++idx, user7.getuBirth());
			pstmt.setString(++idx, user7.getuGender());
			pstmt.setString(++idx, user7.getuNickname());
			pstmt.setString(++idx, user7.getuPassword());
			pstmt.setString(++idx, user7.getuId());
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			logger.error("[UserDao7] uUpdate SQLException",e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		return count;
	}
}
