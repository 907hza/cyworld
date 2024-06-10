package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.common.util.StringUtil;
import com.sist.web.db.DBManager;
import com.sist.web.model.Board;

public class BoardDao 
{
	private static Logger logger = LogManager.getLogger(BoardDao.class);
	
	// 게시물 리스트 조회
	public List<Board> boardList(Board search)
	{
		List<Board> list = new ArrayList<Board>();
		// List 는 인터페이스
		// ArrayList 는 구현부, 구현부에서 제공하는 메소드를 통해서 실행해야하기에 arrayList 로 생성
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("SELECT * ");
		sql.append(" FROM( ");
		sql.append("       SELECT ROWNUM RNUM, ");
		sql.append("              BBS_SEQ, ");
		sql.append("              USER_ID, ");
		sql.append("              USER_NAME, ");
		sql.append("              USER_EMAIL, ");
		sql.append("              BBS_PWD, ");
		sql.append("              BBS_TITLE, ");
		sql.append("              BBS_CONTENT, ");
		sql.append("              BBS_READ_CNT, ");
		sql.append("              REG_DATE ");
		sql.append("         FROM( ");
		sql.append("             SELECT A.BBS_SEQ BBS_SEQ, ");
		sql.append("                    A.USER_ID USER_ID, ");
		sql.append("                    NVL(B.USER_NAME,'') USER_NAME, ");
		sql.append("                    NVL(B.USER_EMAIL,'') USER_EMAIL, ");
		sql.append("                    NVL(A.BBS_PWD,'') BBS_PWD, ");
		sql.append("                    NVL(A.BBS_TITLE,'') BBS_TITLE, ");
		sql.append("                    NVL(A.BBS_CONTENT,'') BBS_CONTENT, ");
		sql.append("                    NVL(A.BBS_READ_CNT,0) BBS_READ_CNT, ");
		sql.append("                    NVL(TO_CHAR(A.REG_DATE, 'YYYY.MM.DD HH24:MI:SS'),'') REG_DATE ");
		sql.append("              FROM TBL_BOARD A, TBL_USER B "); // 이름이랑 이메일의경우, 회원탈퇴했을경우 데이터가 안맞을 수도 있어서 조인해줘야한다
		sql.append("             WHERE A.USER_ID = B.USER_ID ");
		
		// 조회항목에 따라서 조회내용을 맞추어 세팅 , (작성자 - UserId 와 같은)
		if(search != null)
		{ // 만약 비워져있다면 검색하지 않는 것이기 때문에 >> 검색하려면 조회하는 곳이 비워져있지 않아야함
			if(!StringUtil.isEmpty(search.getBbsName())) // bbs 의 값이 비워져있지 않다면
				sql.append("              AND B.USER_NAME LIKE '%' || ? || '%' ");
			
			if(!StringUtil.isEmpty(search.getBbsTitle())) 
				sql.append("              AND A.BBS_TITLE LIKE '%' || ? || '%' ");	
			
			if(!StringUtil.isEmpty(search.getBbsContent())) 
				sql.append("              AND DBMS_LOB.INSTR(A.BBS_CONTENT,?) > 0 ");
		}
		
		sql.append("            ORDER BY A.BBS_SEQ DESC))" );
		
		if(search != null)
		{
			sql.append("WHERE RNUM >= ? ");
			sql.append("  AND RNUM <= ? ");
		}
			
		
		try
		{
			int idx = 0; // 순차적으로 컬럼 순서 지정해주기 위한 변수
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			if(search != null) // 위 이프문에 있는 컬럼 순서와 동일해야함 idx 값을 주기 때문에
			{
				// 해당되는 (작성자|글제목|글내용) 꺼를 컬럼 값으로 지정해서 나타내기 위해서 if 문 활용
				if(!StringUtil.isEmpty(search.getBbsName())) // 한번에 선택할 수 있는 위치에 존재하면 else if 가능 , 각각 존재하면 각각 if
					pstmt.setString(++idx, search.getBbsName()); // 해당 변수 타입에 맞는 타입으로 set-
				
				if(!StringUtil.isEmpty(search.getBbsTitle()))
					pstmt.setString(++idx, search.getBbsTitle());
				
				if(!StringUtil.isEmpty(search.getBbsContent()))
					pstmt.setString(++idx, search.getBbsContent());
					
				
				pstmt.setLong(++idx, search.getStartRow());
				pstmt.setLong(++idx, search.getEndRow());
			}
			
			// 페이징 처리를 위해서 count
			
			logger.debug("=========================================================================");
			logger.debug("sql : " + sql.toString()); // 확인용
			logger.debug("=========================================================================");
			
			// if 문으로 뭐를 조회할건지 걸러낸 후에 쿼리문 가져오는 executeQuery 실행
			rs = pstmt.executeQuery(); // 얘 실행하기 전에 로그찍어야 어디서 오류났는지 알 수 있음
			
			while(rs.next()) // 값이 없을 때까지 true 리턴
			{
				Board board = new Board(); // 와일 문 돌리면서 나오는 값들 보드 객체에 저장해줄 것
				// 하나의 보드로 조회해서 값을 보드 자체 하나로 가져오기 때문에 보드 객체 선언
				
				board.setBbsSeq(rs.getLong("BBS_SEQ")); // Board.java 에서 선언한 변수 타입으로 get-
				board.setUserId(rs.getString("USER_ID")); // 어떤 메소드(를 통한 변수에) 어떤 타입으로 값을 저장할지 지정
				board.setBbsName(rs.getString("USER_NAME"));
				board.setBbsEmail(rs.getString("USER_EMAIL"));
				board.setBbsPwd(rs.getString("BBS_PWD"));
				board.setBbsTitle(rs.getString("BBS_TITLE"));
				board.setBbsContent(rs.getString("BBS_CONTENT"));
				board.setBbsReadCnt(rs.getInt("BBS_READ_CNT"));
				board.setRegDate(rs.getString("REG_DATE"));
				
				list.add(board);
			}
			
		}
		catch(Exception e)
		{
			logger.error("[BoardDao] boardList SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
			// 각 객체를 얻는 순서의 반대 순서로 닫아줘야함
		}
		
		
		return list;
	}
	
	//  -- total count 가져오기 -- 총 게시물 갯수 > 페이징 처리하기 위해서
	public long boardTotalCount(Board search)
	{
		long totalCount = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	 SELECT COUNT(A.BBS_SEQ) TOTAL_COUNT ");
		sql.append("	   FROM TBL_BOARD A, TBL_USER B ");
		sql.append("	  WHERE A.USER_ID = B.USER_ID ");
		
		if(search != null)
		{
			if(!StringUtil.isEmpty(search.getBbsName()))
				sql.append("	    AND B.USER_NAME LIKE '%' || ? || '%' ");
			
			if(!StringUtil.isEmpty(search.getBbsTitle()))
				sql.append("	    AND A.BBS_TITLE LIKE '%' || ? || '%' ");
			
			if(!StringUtil.isEmpty(search.getBbsContent()))
				sql.append("	    AND DBMS_LOB.INSTR(A.BBS_CONTENT, ?) > 0 ");
		}

		
		try
		{
			int idx = 0;
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			if(search != null)
			{
				if(!StringUtil.isEmpty(search.getBbsName()))
					pstmt.setString(++idx, search.getBbsName());
				
				if(!StringUtil.isEmpty(search.getBbsTitle()))
					pstmt.setString(++idx, search.getBbsTitle());
				
				if(!StringUtil.isEmpty(search.getBbsContent()))
					pstmt.setString(++idx, search.getBbsContent());
			}
			logger.debug("=========================================================================");
			logger.debug("count : " + sql.toString()); // 확인용
			logger.debug("=========================================================================");
			rs = pstmt.executeQuery();
			
			if(rs.next())
				totalCount = rs.getLong("TOTAL_COUNT");
		}
		catch(Exception e)
		{
			logger.error("[BoardDao] boardTotalCount SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
		

		
		return totalCount;
	}
	
	// 게시물 등록
	public int boardInsert(Board board)
	{
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	INSERT INTO TBL_BOARD ");
		sql.append("	(BBS_SEQ, USER_ID, BBS_NAME, BBS_EMAIL, BBS_PWD, BBS_TITLE, BBS_CONTENT, BBS_READ_CNT, REG_DATE) ");
		sql.append("	VALUES ");
		sql.append("	(?,?,?,?,?,?,?,0,SYSDATE) ");
		
		try
		{
			int idx = 0;
			long bbsSeq = 0;
			
			conn = DBManager.getConnection();
			
			bbsSeq = newBbsSeq(conn);
			board.setBbsSeq(bbsSeq);
			
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(++idx, board.getBbsSeq());
			pstmt.setString(++idx, board.getUserId());
			pstmt.setString(++idx, board.getBbsName());
			pstmt.setString(++idx, board.getBbsEmail());
			pstmt.setString(++idx, board.getBbsPwd());
			pstmt.setString(++idx, board.getBbsTitle());
			pstmt.setString(++idx, board.getBbsContent());
			
			count = pstmt.executeUpdate();
			
			
			
		}
		catch(Exception e)
		{
			logger.error("[BoardDao] boardInsert SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	// 시퀀스 조회
	private long newBbsSeq(Connection conn) // 커넥션 객체를 따로 정의하지 않아도 된다는 것 > 얘를 호출하기 전에 생성한 해당 메소드에서 사용할 수 있다
	{
		long bbsSeq = 0;
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	SELECT SEQ_BOARD_SEQ.NEXTVAL ");
		sql.append("	  FROM DUAL ");
		
		try
		{
			pstmt = conn.prepareStatement(sql.toString()); 
			// 이미 호출하는 곳에서 커넥션 객체 생성되어있기에 바로 pstmt
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				bbsSeq = rs.getLong(1); // sele
			}
		}
		catch(Exception e)
		{
			logger.error("[BoardDao] newBbsSeq SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt); 
			// 여기서는 커넥션 객체 닫으면 안됨 : 해당 메소드를 사용하는 곳에서 값을 가져오려고 하다가 닫아버려서 값을 가져오지 못하기 때문에
		}
		
		return bbsSeq;
	}
	
	// 게시물 조회
	public Board boardSelect(long bbsSeq) 
	{
		Board board = null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	 SELECT A.BBS_SEQ, ");
		sql.append("	        A.USER_ID, ");
		sql.append("	        NVL(B.USER_NAME,'') AS USER_NAME, ");
		sql.append("	        NVL(B.USER_EMAIL,'') AS USER_EMAIL, ");
		sql.append("	        NVL(A.BBS_PWD,'') AS BBS_PWD, ");
		sql.append("	        NVL(A.BBS_TITLE,'') AS BBS_TITLE, ");
		sql.append("	        NVL(A.BBS_CONTENT,'') AS BBS_CONTENT, ");
		sql.append("	        NVL(A.BBS_READ_CNT,0) AS BBS_READ_CNT, ");
		sql.append("	        NVL(TO_CHAR(A.REG_DATE,'yyyy.mm.dd hh24:mi:ss'),'') AS REG_DATE ");
		sql.append("	  FROM TBL_BOARD A, TBL_USER B ");
		sql.append("	 WHERE A.BBS_SEQ = ? ");
		sql.append("	   AND A.USER_ID = B.USER_ID ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			pstmt.setLong(1, bbsSeq);			
			
			rs = pstmt.executeQuery();
			
			if(rs.next())
			{
				board = new Board();
				
				board.setBbsSeq(rs.getLong("BBS_SEQ"));
			    board.setUserId(rs.getString("USER_ID"));
			    board.setBbsName(rs.getString("USER_NAME"));
			    board.setBbsEmail(rs.getString("USER_EMAIL"));    
			    board.setBbsPwd(rs.getString("BBS_PWD"));    
			    board.setBbsTitle(rs.getString("BBS_TITLE"));    
			    board.setBbsContent(rs.getString("BBS_CONTENT"));    
			    board.setBbsReadCnt(rs.getInt("BBS_READ_CNT"));    
			    board.setRegDate(rs.getString("REG_DATE"));  
			}
		}
		catch(Exception e)
		{
			logger.error("[BoardDao] boardSelect SQLException", e);
		}
		finally
		{
			DBManager.close(rs, pstmt, conn);
		}
   
		return board;
	}
	
	// 게시글 조회 수 증가
	public int boardReadCntPlus(long bbsSeq)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		sql.append("	UPDATE TBL_BOARD ");
		sql.append("	   SET BBS_READ_CNT = BBS_READ_CNT + 1 ");
		sql.append("	 WHERE BBS_SEQ = ? ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setLong(1, bbsSeq); // ? 에 대한 컬럼 값 삽입
			
			count = pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			logger.error("[BoardDao] boardReadCntPlus SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}
	
	// 게시물 삭제
	public int boardDelete(long bbsSeq)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
				
		sql.append("		   DELETE FROM TBL_BOARD ");
		sql.append("		    WHERE BBS_SEQ = ? ");
		
		try
		{
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			pstmt.setLong(1, bbsSeq);
			
			// 조회하는거면 next() 를 사용하는데 수정, 삭제, 삽입은 조회한 걸 가져오는게 아니기 때문에 필요없당
			count = pstmt.executeUpdate();
		}
		catch(Exception e)
		{
			logger.error("[BoardDao] boardDelete SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		return count;
	}
	
	// 게시물 수정
	public int boardUpdate(Board board)
	{
		int count = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sql = new StringBuilder();
		
		
		sql.append("UPDATE TBL_BOARD ");
		sql.append("   SET BBS_TITLE = ?, ");
		sql.append("      BBS_CONTENT = ? ");
		sql.append("WHERE BBS_SEQ = ? "); 
		
		try
		{
			int idx = 0;
			
			conn = DBManager.getConnection();
			pstmt = conn.prepareStatement(sql.toString());
			
			// ? 에 들어갈 데이터
			pstmt.setString(++idx, board.getBbsTitle());
			pstmt.setString(++idx, board.getBbsContent());
			pstmt.setLong(++idx, board.getBbsSeq());
			
			count = pstmt.executeUpdate();
			
		}
		catch(Exception e)
		{
			logger.error("[BoardDao] boardUpdate SQLException", e);
		}
		finally
		{
			DBManager.close(pstmt, conn);
		}
		
		return count;
	}

}
