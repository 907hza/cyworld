package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;
import com.sist.web.model.User;

// 사용자 조회, 삽입, 수정, 삭제 기능
public class UserDao 
{
	private static Logger logger = LogManager.getLogger(UserDao.class);
	// 전역변수로 사용하기 위해서

	//사용자 조회 
	public User userSelect(String userId)
	{
		User user = null; // 사용자 정보들 담긴 객체 선언
		Connection conn = null; // 드라이버 연결 객체 선언
		PreparedStatement pstmt = null; // SQL 실행 객체 선언
		ResultSet rs = null; // select 문의 결과를 저장하는 객체
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT USER_ID, ");
		sql.append("       NVL(USER_PWD, '') USER_PWD, ");
		sql.append("       NVL(USER_NAME, '') USER_NAME, ");
		sql.append("       NVL(USER_EMAIL, '') USER_EMAIL, ");
		sql.append("       NVL(STATUS, 'N') STATUS, ");
		sql.append("       NVL(TO_CHAR(REG_DATE, 'YYYY.MM.DD HH24:MI:SS'), '') REG_DATE ");
		sql.append("  FROM TBL_USER ");
		sql.append(" WHERE USER_ID = ? "); // 변수를 입력해서 쿼리가 여러 번 처리될 수 있도록(+보안상)
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(1, userId);
			
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				user = new User();
				
				user.setUserId(rs.getString("USER_ID"));
				user.setUserPwd(rs.getString("USER_PWD"));
				user.setUserName(rs.getString("USER_NAME"));
				user.setUserEmail(rs.getString("USER_EMAIL"));
				user.setStatus(rs.getString("STATUS"));
				user.setRegDate(rs.getString("REG_DATE"));
			}
		}
		catch(Exception e)
		{
			logger.error("[UserDao] userSelect SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn); // 사용하고 꼭 연결 통로 닫아줘야함
		}
		
		return user;
	}
	
	//아이디 존재 확인
	public int userIdSelectCount(String userId)
	{
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT COUNT(USER_ID) CNT ");
		sql.append("  FROM TBL_USER ");
		sql.append(" WHERE USER_ID = ? ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setString(1, userId); // userId 쿼리 resultset 으로 받기 위해서 필드명으로 접근
			
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				count = rs.getInt("CNT"); // CNT 컬럼의 반환 결과를 count 로 받음
			}
		}
		catch(Exception e)
		{
			logger.error("[UserDao] userIdSelectCount SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		
		return count;
	}
	
	//사용자 등록
	public int userInsert(User user)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("INSERT INTO TBL_USER ");
		// sql.append(" (USER_ID, USER_PWD, USER_NAME, USER_EMAIL, STATUS, REG_DATE) ");
		sql.append(" VALUES (?, ?, ?, ?, ?, SYSDATE) ");
		
		try
		{
			int idx = 0; // 순차적으로 컬럼 순서 지정해주기 위한 변수
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, user.getUserId());
			pstmt.setString(++idx, user.getUserPwd());
			pstmt.setString(++idx, user.getUserName());
			pstmt.setString(++idx, user.getUserEmail());
			pstmt.setString(++idx, user.getStatus());
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			logger.error("[UserDao] userInsert SQLExeption", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	//사용자 정보 수정
	public int userUpdate(User user)
	{
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	UPDATE TBL_USER ");
		sql.append("	   SET USER_PWD = ?, ");
		sql.append("	       USER_NAME = ?, ");
		sql.append("	       USER_EMAIL = ? ");
		sql.append("	 WHERE USER_ID = ? ");
		
		try
		{
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, user.getUserPwd());
			pstmt.setString(++idx, user.getUserName());
			pstmt.setString(++idx, user.getUserEmail());
			pstmt.setString(++idx, user.getUserId());
			
			count = pstmt.executeUpdate(); // executeUpdate 리턴 타입이 int 이기 때문에 카운트에 담아줌
			
		}
		catch(Exception e)
		{
			logger.error("[User Dao] userUpdate SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
			 
		return count;
	}

}







