package words.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import words.util.DBManager;

public class MemberDAO {

	Connection conn;
	PreparedStatement pstmt;
	ResultSet rs;
	Member result = new Member();
	
	Logger log = LoggerFactory.getLogger(MemberDAO.class);
	
	/**
	 * 아이디 중복 체크
	 * @param member_id
	 * @return
	 */
	public boolean chkIdExist(String member_id) {
		boolean idExist;
		
		conn = DBManager.getConnection();
		String sql = "select member_id from words_member where member_id = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,  member_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				idExist = true;
			}else {
				idExist = false;
			}
		}catch(SQLException e) {
			e.printStackTrace();
			log.info("Error Code : {}", e.getErrorCode());
			return false;
		}finally {
			try {
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		
		return idExist;
	}
	
	
	/** 
	 * 신규회원등록
	 * @param member
	 * @return
	 */
	public boolean addMember(Member member) {
		
		conn = DBManager.getConnection();
		String sql = "insert into words_member(member_id, passwd, nickname, email, date_created, birth_year) "
				+ "values(?,?,?,?,now(),?)";
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,  member.getMember_id());
			pstmt.setString(2, member.getPasswd());
			pstmt.setString(3,  member.getNickname());
			pstmt.setString(4, member.getEmail());
			pstmt.setInt(5, member.getBirth_year());
			pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
			log.info("Error Code : {}", e.getErrorCode());
			return false;
		}finally {
			try {
				pstmt.close();
				conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		
		log.info("member : {} created", member.getNickname());

		return true;
	}
	
	/** 
	 * 회원정보 변경
	 * @param member
	 * @return
	 */
	public boolean modifyMember(Member member) {
		
		conn = DBManager.getConnection();
		String sql = "update words_member "
				+ "set passwd=?, nickname=?, email=?, birth_year=? "
				+ "where member_id=?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member.getPasswd());
			pstmt.setString(2, member.getNickname());
			pstmt.setString(3, member.getEmail());
			pstmt.setInt(4, member.getBirth_year());
			pstmt.setString(5, member.getMember_id());
			pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
			log.info("Error Code : {}", e.getErrorCode());
			return false;
		}finally {
			try {
				pstmt.close();
				conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		
		log.info("Member info for ({}) modified.", member.getMember_id());

		return true;
	}
	
	
	/**
	 * 회원 로그인
	 * @param member_id
	 * @param passwd
	 * @return
	 */
	public Member login(String member_id) {
		
		conn = DBManager.getConnection();
		
		String sql;
		int new_member_level = 0;
		
		try {
			//회원 기본 정보 가져오기
			sql = "select member_id, passwd, can_make_question, member_level, nickname, email, birth_year from words_member where member_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
			
				result.setMember_id(member_id);
				result.setPasswd(rs.getString("passwd"));
				result.setCan_make_question(rs.getInt("can_make_question"));
				result.setNickname(rs.getString("nickname"));
				result.setEmail(rs.getString("email"));
				result.setBirth_year(rs.getInt("birth_year"));
				
				int member_level_from_member_table = rs.getInt("member_level");
				int member_level_from_wmws_table = chkMemberLevel(member_id);
				
				if(member_level_from_wmws_table == 0) {
					new_member_level = member_level_from_member_table;
				}else if(member_level_from_wmws_table == member_level_from_member_table){
					new_member_level = member_level_from_member_table;
				}else {
					new_member_level = member_level_from_wmws_table;
					setMemberLevel(member_id, member_level_from_wmws_table);
				}
				
				result.setMember_level(new_member_level);
			}
			
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) {
					rs.close();
				}
				pstmt.close();
				conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		
		log.info("member_id : {} logged in", member_id);

		return result;
	}
	
	/**
	 * 과거 문제풀이 이력에 따른 실시간 회원 레벨 산정
	 * @param member_id
	 * @return
	 */
	public int chkMemberLevel(String member_id) {
		
		double avgFinal = chkMemberAverage(member_id);

		int member_level = 0;
		
		if(avgFinal < 20) member_level = 1;
		else if(avgFinal < 30) member_level = 2;
		else if(avgFinal < 40) member_level = 3;
		else if(avgFinal < 50) member_level = 4;
		else if(avgFinal < 60) member_level = 5;
		else if(avgFinal < 70) member_level = 6;
		else if(avgFinal < 80) member_level = 7;
		else if(avgFinal < 90) member_level = 8;
		else member_level = 9;
		
		return member_level;
	}
	
	/**
	 * 과거 문제풀이 이력에 따른 실시간 회원 레벨 산정
	 * @param member_id
	 * @return
	 */
	public int chkMemberLevel(double avgFinal) {
		
		int member_level = 0;
				
		if(avgFinal < 20) member_level = 1;
		else if(avgFinal < 30) member_level = 2;
		else if(avgFinal < 40) member_level = 3;
		else if(avgFinal < 50) member_level = 4;
		else if(avgFinal < 60) member_level = 5;
		else if(avgFinal < 70) member_level = 6;
		else if(avgFinal < 80) member_level = 7;
		else if(avgFinal < 90) member_level = 8;
		else member_level = 9;
			
		return member_level;
	}
	
	/**
	 * 과거 문제풀이 이력에 따른 실시간 회원 평점 산정
	 * @param member_id
	 * @return
	 */
	public double chkMemberAverage(String member_id) {
		
		conn = DBManager.getConnection();
		String sql;
		
		//최종 평균값
		double avgFinal = 0;
		
		//평균계산에 사용하는 과거 이력 갯수
		int HISTORY_CNT = 100;
		
		//구간별 이력갯수
		int score_cnt = 0;
		
		//구간별 점수의 합
		double score_total = 0;
		
		//평균계산에 사용할 점수 갯수
		int score_cnt_total = 0;
		
		//평균계산에 사용할 점수의 합
		double sumTotal = 0;
		
		try {
			//30일이내 점수 이력 조회
			sql = "select score "
					+ "from member_word_history "
					+ "where (date_created >= (now() - interval 30 day)) "
					+ "and (member_id = ?) "
					+ "order by date_created desc limit 0,?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member_id);
			pstmt.setInt(2, HISTORY_CNT);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				score_total += rs.getDouble("score");
				score_cnt++;
			}
			
			if(score_cnt != 0) {
				sumTotal += score_total;
				score_cnt_total += score_cnt;
			}
			
			//이력이 100건이 안될 경우 31~60일 이력 조회
			if(score_cnt_total < HISTORY_CNT) {
				score_total = 0;
				score_cnt = 0;
						
				sql = "select score "
						+ "from member_word_history "
						+ "where ((date_created <= (now() - interval 31 day)) "
						+ "and (date_created >= (now() - interval 60 day))) "
						+ "and (member_id = ?) "
						+ "order by date_created desc limit 0,?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, member_id);
				pstmt.setInt(2, HISTORY_CNT - score_cnt_total);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					score_total += rs.getDouble("score");
					score_cnt++;
				}
				
				if(score_cnt != 0) {
					//31~60일 이력점수 합의 90%를 반영
					sumTotal += (score_total * 0.9);
					score_cnt_total += score_cnt;
				}
			}
			
			//이력이 100건이 안될 경우 61~90일 이력 조회
			if(score_cnt_total < HISTORY_CNT) {
				score_total = 0;
				score_cnt = 0;
				
				sql = "select score "
						+ "from member_word_history "
						+ "where ((date_created <= (now() - interval 61 day)) "
						+ "and (date_created >= (now() - interval 90 day))) "
						+ "and (member_id = ?) "
						+ "order by date_created desc limit 0,?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, member_id);
				pstmt.setInt(2, HISTORY_CNT - score_cnt_total);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					score_total += rs.getDouble("score");
					score_cnt++;
				}
				
				if(score_cnt != 0) {
					//31~60일 이력점수 합의 80%를 반영
					sumTotal += (score_total * 0.8);
					score_cnt_total += score_cnt;
				}
			}
			
			//이력이 100건이 안될 경우 91일 이전 이력 조회
			if(score_cnt_total < HISTORY_CNT) {
				score_total = 0;
				score_cnt = 0;
				
				sql = "select score "
						+ "from member_word_history "
						+ "where (date_created <= (now() - interval 91 day)) "
						+ "and (member_id = ?) "
						+ "order by date_created desc limit 0,?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, member_id);
				pstmt.setInt(2, HISTORY_CNT - score_cnt_total);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					score_total += rs.getDouble("score");
					score_cnt++;
				}
				
				if(score_cnt != 0) {
					//91일 이전 이력점수 합의 70%를 반영
					sumTotal = (score_total * 0.7);
					score_cnt_total += score_cnt;
				}
			}
			
			avgFinal = sumTotal / score_cnt_total;
			
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) {
					rs.close();
				}
				pstmt.close();
				conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		
		return avgFinal;
	}
	
	/**
	 * 신규 산정된 회원레벨을 회원 DB에 update
	 * @param member_id
	 * @param member_level
	 * @return
	 */
	public boolean setMemberLevel(String member_id, int member_level) {
		
		conn = DBManager.getConnection();
		String sql;
		int rows_updated = 0;
		
		try {
			sql = "UPDATE words_member set member_level = ? where member_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, member_level);
			pstmt.setString(2, member_id);
			rows_updated = pstmt.executeUpdate();
			
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(rs != null) {
					rs.close();
				}
				pstmt.close();
				conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		
		if (rows_updated == 0) {
			return false;
		}else {
			return true;
		}
	}
}
	
	