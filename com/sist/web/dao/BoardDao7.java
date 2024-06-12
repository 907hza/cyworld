package com.sist.web.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.util.CookieUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.db.DBManager;
import com.sist.web.model.Board7;
import com.sist.web.model.Diary7;
import com.sist.web.model.GuestBook7;
import com.sist.web.model.Attachment;

import com.sist.web.model.User7;
import com.sist.web.model.CyLike;



public class BoardDao7 
{
	private static Logger logger = LogManager.getLogger(BoardDao7.class);
	
	// 페이징 글 조회
	public List<Board7> cy_bSelect(Board7 board7)
	{	
		List<Board7> list = new ArrayList<Board7>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	SELECT *");
		sql.append("	FROM ");
		sql.append("	( ");
		sql.append("	    SELECT ROWNUM RNUM ,BOARD_N, U_ID, U_NICKNAME, U_PASSWORD, B_TITLE, B_CONTENT, BOARD_READ_CNT, REG_DATE ");
		sql.append("	      FROM ");
		sql.append("	      ( ");
		sql.append("       SELECT  B.BOARD_N BOARD_N, ");
		sql.append("	             U.U_ID U_ID, ");
		sql.append("	             U.U_NICKNAME U_NICKNAME, ");
		sql.append("	             U.U_PASSWORD U_PASSWORD, ");
		sql.append("	             B.B_TITLE B_TITLE, ");
		sql.append("	             B.B_CONTENT B_CONTENT, "); 
		sql.append("	             B.BOARD_READ_CNT BOARD_READ_CNT, ");
		sql.append("	             B.REG_DATE REG_DATE ");
		sql.append("	       FROM CY_BOARD B, CY_USER U ");
		sql.append("	      WHERE B.U_ID = U.U_ID ");
		
		if(board7 != null)
		{
			if(!StringUtil.isEmpty(board7.getuId()))
				sql.append("	        AND U.U_NICKNAME LIKE '%' || ? || '%' ");
			if(!StringUtil.isEmpty(board7.getbTitle()))
				sql.append("	        AND B.B_TITLE LIKE '%' || ? || '%' ");
			if(!StringUtil.isEmpty(board7.getbContent()))
				sql.append("	        AND B.B_CONTENT LIKE '%' || ? || '%' ");
		}

		sql.append("	      ORDER BY BOARD_N DESC ");
		sql.append("	      ) ");
		sql.append("	) ");
		
		if(board7 != null)
		{
			sql.append("	WHERE RNUM >= ? ");
			sql.append("	  AND RNUM <= ? ");
		}


		try
		{
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			if(board7 != null)
			{
				
				if(!StringUtil.isEmpty(board7.getuNickname()))
					pstmt.setString(++idx, board7.getuNickname());
				if(!StringUtil.isEmpty(board7.getbTitle()))
					pstmt.setString(++idx, board7.getbTitle());
				if(!StringUtil.isEmpty(board7.getbContent()))
					pstmt.setString(++idx, board7.getbContent());
				
				pstmt.setLong(++idx, board7.getStartRow());
				pstmt.setLong(++idx, board7.getEndRow());
			}
			
			logger.debug("=========================================================================");
			logger.debug("sql : " + sql.toString()); // 확인용
			logger.debug("=========================================================================");
			
			rs = pstmt.executeQuery();
			
			while(rs.next())
			{
				Board7 board = new Board7();

				board.setBoardN(rs.getLong("BOARD_N"));
				board.setuId(rs.getString("U_ID"));
				board.setuNickname(rs.getString("U_NICKNAME"));
				board.setbTitle(rs.getString("B_TITLE"));
				board.setbContent(rs.getString("B_CONTENT"));
				board.setBoardReadCnt(rs.getLong("BOARD_READ_CNT"));
				board.setRegDate(rs.getString("REG_DATE"));
				
				list.add(board);
			} // BOARD_N, U_ID, U_NICKNAME, U_PASSWORD, B_TITLE, B_CONTENT, BOARD_READ_CNT, REG_DATE
			
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] cy_bSelect SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}	
		
		return list;
	}
	
	// 다이어리 총 글 불러오기
	public List<Diary7> cy_dSelect(Diary7 diary7)
	{	
		List<Diary7> list = new ArrayList<Diary7>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	SELECT DIARY_N,U_ID, D_TITLE, UTL_RAW.CAST_TO_VARCHAR2(D_CONTENT), TO_CHAR(REG_DATE,'YYYY-MM-DD') REG_DATE");
		sql.append("	FROM DIARY ");
		sql.append("	ORDER BY DIARY_N DESC ");

		try
		{
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());

			logger.debug("=========================================================================");
			logger.debug("sql : " + sql.toString()); // 확인용
			logger.debug("=========================================================================");
			
			rs = pstmt.executeQuery();
			
			while(rs.next())
			{
				Diary7 diary = new Diary7();

				diary.setDiaryN(rs.getLong("DIARY_N"));
				diary.setuId(rs.getString("U_ID"));
				diary.setdTitle(rs.getString("D_TITLE"));
				diary.setdContent(rs.getString("UTL_RAW.CAST_TO_VARCHAR2(D_CONTENT)"));
				diary.setRegDate(rs.getString("REG_DATE"));
				
				list.add(diary);
			} 
		
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] cy_dSelect SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}	
		
		return list;
	}
	
	// 방명록 총 글 불러오기
	public List<GuestBook7> cy_gSelect(GuestBook7 guestBook7)
	{	
		List<GuestBook7> list = new ArrayList<GuestBook7>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	 SELECT GUEST_N, U_ID, U_NICKNAME, GUEST_CONTENT, REG_DATE ");
		sql.append("	   FROM GUEST_BOOK ");
		sql.append("	 ORDER BY GUEST_N DESC ");

		try
		{
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());

			logger.debug("=========================================================================");
			logger.debug("sql : " + sql.toString()); // 확인용
			logger.debug("=========================================================================");
			
			rs = pstmt.executeQuery();
			
			while(rs.next())
			{
				GuestBook7 guestBook = new GuestBook7();

				guestBook.setGuestN(rs.getLong("GUEST_N"));
				guestBook.setuId(rs.getString("U_ID"));
				guestBook.setuNickname(rs.getString("U_NICKNAME"));
				guestBook.setGuestContent(rs.getString("GUEST_CONTENT"));
				guestBook.setRegDate(rs.getString("REG_DATE"));
				
				list.add(guestBook);
			} 
		
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] cy_dSelect SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}	
		
		return list;
	}
	
	
	// 총 게시판 보드 갯수 가져오기
	public long boardTotal(Board7 board7)
	{
		long boardTotal = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	  SELECT COUNT(BOARD_N) CNT ");
		sql.append("	    FROM CY_BOARD ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				boardTotal = rs.getLong("CNT");
			}
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] boardTotal SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		
		return boardTotal;
	}
	
	// 다이어리 글 총 갯수
	public long diaryTotal(Diary7 diary7)
	{
		long diaryTotal = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	  SELECT COUNT(DIARY_N) CNT ");
		sql.append("	    FROM DIARY ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				diaryTotal = rs.getLong("CNT");
			}
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] boardTotal SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		
		return diaryTotal;
	}
	
	// 방명록 총 글 갯수
	public long guestTotal(GuestBook7 guestBook7)
	{
		long guestTotal = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	  SELECT COUNT(GUEST_N) CNT ");
		sql.append("	    FROM GUEST_BOOK ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				guestTotal = rs.getLong("CNT");
			}
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] boardTotal SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		
		return guestTotal;
	}
	
	// 페이징 처리를 위한 총 해당 게시물 갯수
	public long boardPaging(Board7 board7)
	{
		long totalCount = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("    SELECT COUNT(B.BOARD_N) CNT ");
		sql.append("      FROM CY_BOARD B, CY_USER U ");
		sql.append("     WHERE B.U_ID = U.U_ID ");
		
		if(board7 != null)
		{
			if(!StringUtil.isEmpty(board7.getuNickname()))
				sql.append("       AND U.U_NICKNAME LIKE '%' || ? || '%' ");
			if(!StringUtil.isEmpty(board7.getbTitle()))
				sql.append("       AND B.B_TITLE LIKE '%' || ? || '%' ");
			if(!StringUtil.isEmpty(board7.getbContent()))
				sql.append("       AND DBMS_LOB.INSTR(B.B_CONTENT, ?) > 0 ");
		}
		
		try
		{
			int idx = 0;
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			if(board7 != null)
			{
				if(!StringUtil.isEmpty(board7.getuNickname()))
					pstmt.setString(++idx, board7.getuNickname());
				if(!StringUtil.isEmpty(board7.getbTitle()))
					pstmt.setString(++idx, board7.getbTitle());
				if(!StringUtil.isEmpty(board7.getbContent()))
					pstmt.setString(++idx, board7.getbContent());
			}
			
			logger.debug("=========================================================================");
			logger.debug("count : " + sql.toString()); // 확인용
			logger.debug("=========================================================================");
			
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				totalCount = rs.getLong("CNT");
			}
			
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] boardPaging SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}	
		
		return totalCount;
	}
	
	// 시퀀스 조회
	private long newBoardN(Connection conn)
	{
		long boardN = 0;
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	SELECT SEQ_CY_BOARD_SEQ.NEXTVAL ");
		sql.append("	  FROM DUAL ");
		
		try
		{
			pstmt = conn.prepareStatement(sql.toString());
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				boardN = rs.getLong(1);
			}
			
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] newBoardN SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt);
		}
		return boardN;
	}
	
	// 게시판 글 조회
	public Board7 bSelect(long boardN)
	{
		Board7 board7 = null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("		SELECT B.BOARD_N BOARD_N,");
		sql.append("           U.U_ID U_ID, ");
		sql.append("	       U.U_NICKNAME U_NICKNAME, ");
		sql.append("	       B.BOARD_READ_CNT BOARD_READ_CNT, ");
		sql.append("	       B.B_TITLE B_TITLE, ");
		sql.append("	       B.B_CONTENT B_CONTENT, ");
		sql.append("	       NVL(TO_CHAR(B.REG_DATE,'YYYY-MM-DD'),'') REG_DATE ");
		sql.append("	  FROM CY_USER U, CY_BOARD B ");
		sql.append("	 WHERE U.U_ID = B.U_ID ");
		sql.append("	   AND BOARD_N = ? ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, boardN);
			
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				board7 = new Board7();
				
				board7.setBoardN(rs.getLong("BOARD_N"));
				board7.setuId(rs.getString("U_ID"));
				board7.setuNickname(rs.getString("U_NICKNAME"));
				board7.setBoardReadCnt(rs.getLong("BOARD_READ_CNT"));
				board7.setbTitle(rs.getString("B_TITLE"));
				board7.setbContent(rs.getString("B_CONTENT"));
				board7.setRegDate(rs.getString("REG_DATE"));
			}
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] bSelect SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		
		return board7;
	}
	
	
	// 다이어리 글 조회
	public Diary7 dSelect(long diaryN)
	{
		Diary7 diary7 = null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("		SELECT DIARY_N, U_ID, D_TITLE, UTL_RAW.CAST_TO_VARCHAR2(D_CONTENT), TO_CHAR(REG_DATE,'YYYY-MM-DD') ");
		sql.append("          FROM DIARY ");
		sql.append("         WHERE DIARY_N = ? ");
		
		//DIARY_N, U_ID, D_TITLE, UTL_RAW.CAST_TO_VARCHAR2(D_CONTENT), REG_DATE
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, diaryN);
			
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				diary7 = new Diary7();
				
				diary7.setDiaryN(rs.getLong("DIARY_N"));
				diary7.setuId(rs.getString("U_ID"));
				diary7.setdTitle(rs.getString("D_TITLE"));
				diary7.setdContent(rs.getString("UTL_RAW.CAST_TO_VARCHAR2(D_CONTENT)"));
				diary7.setRegDate(rs.getString("TO_CHAR(REG_DATE,'YYYY-MM-DD')"));
			}
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] dSelect SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		
		return diary7;
	}
	
	// 방명록 글 조회
	public GuestBook7 gSelect(long guestN)
	{
		GuestBook7 guestBook7 = null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("		SELECT GUEST_N, U_ID, U_NICKNAME, GUEST_CONTENT, REG_DATE ");
		sql.append("          FROM GUEST_BOOK ");
		sql.append("         WHERE GUEST_N = ? ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, guestN);
			
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				guestBook7 = new GuestBook7();
				
				guestBook7.setGuestN(rs.getLong("GUEST_N"));
				guestBook7.setuId(rs.getString("U_ID"));
				guestBook7.setuNickname(rs.getString("U_NICKNAME"));
				guestBook7.setGuestContent(rs.getString("GUEST_CONTENT"));
				guestBook7.setRegDate(rs.getString("REG_DATE"));
			}
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] dSelect SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		
		return guestBook7;
	}
	
	// 게시글 조회 수
	public int boardReadCntPP(long boardN)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	UPDATE CY_BOARD ");
		sql.append("	   SET BOARD_READ_CNT = BOARD_READ_CNT + 1 ");
		sql.append("	 WHERE BOARD_N = ? ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, boardN);
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] boardReadCntPP SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	// 게시물 삭제
	public int boardDelete(long boardN)
	{
		int count = 0 ;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	DELETE FROM CY_BOARD ");
		sql.append("	WHERE BOARD_N = ? ");
				
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, boardN);
			count = pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] boardDelete SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	// 게시물 수정
	public int boardUpdate(Board7 board7)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("       UPDATE CY_BOARD ");
		sql.append("          SET B_TITLE = ?, ");
		sql.append("              B_CONTENT = ? ");
		sql.append("        WHERE BOARD_N = ? ");
	        
		try
		{
			int idx = 0;
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, board7.getbTitle());
			pstmt.setString(++idx, board7.getbContent());
			pstmt.setLong(++idx, board7.getBoardN());
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] boardUpdate SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		return count;
	}
	
	// 게시물 등록
	public int bInsert(Board7 board7)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("INSERT INTO CY_BOARD ");
		sql.append("(BOARD_N, U_ID, BOARD_READ_CNT, A_FILE_NUM, B_PRIVATE, B_TITLE, B_CONTENT, REG_DATE) ");
		sql.append("VALUES ");
		sql.append("(SEQ_CY_BOARD_SEQ.NEXTVAL,?,0,?,'Y',?,?,SYSDATE) ");
		
		try
		{
			int idx = 0;
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, board7.getuId());
			pstmt.setLong(++idx, board7.getaFileNum());
			pstmt.setString(++idx, board7.getbTitle());
			pstmt.setString(++idx, board7.getbContent());
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] bInsert SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		return count;
	}
	
	// 다이어리 글 등록
	public int dInsert(Diary7 diary7)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("INSERT INTO DIARY (DIARY_N, U_ID, D_TITLE, D_CONTENT, REG_DATE) ");
		sql.append("VALUES ((SELECT NVL(MAX(DIARY_N), 0) + 1 FROM DIARY),?,?,UTL_RAW.CAST_TO_RAW(?),SYSDATE) ");
		
		try
		{
			int idx = 0;
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setString(++idx, diary7.getuId());
			pstmt.setString(++idx, diary7.getdTitle());
			pstmt.setString(++idx, diary7.getdContent());
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] dInsert SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		return count;
	}
	
	// 게시판 글 번호에 따른 첨부파일 불러오기
	public int attSelect(Attachment attachment)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	SELECT NVL(A_FILE_PATH,'') ");
		sql.append("	  FROM ATTACHMENT ");
		sql.append("	 WHERE BOARD_N = ? ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setLong(1, attachment.getBoardN());
			
			rs = pstmt.executeQuery();
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] attSelect SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		
		return count;
	}
	
	// 방명록 글 삭제
	public int gDelete(long guestN)
	{
		int count = 0 ;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	DELETE FROM GUEST_BOOK ");
		sql.append("	WHERE GUEST_N = ? ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, guestN);
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			logger.error("[BoardDao7] gDelete SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		
		
		return count;
	}
	
}
