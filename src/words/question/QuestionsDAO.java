package words.question;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedList;
import java.util.Random;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import words.member.MemberDAO;
import words.util.DBManager;

public class QuestionsDAO {

	Connection conn;
	PreparedStatement pstmt;
	Statement stmt;
	ResultSet rs = null;
	Logger log = LoggerFactory.getLogger(MemberDAO.class);
	
	//최종 출제 문제 갯수
	int NUM_OF_QUESTIONS = 9;
	
	//회원레벨과 동일한 문제수
	int SameLevelQuestions = NUM_OF_QUESTIONS * 2;

	//회원레벨보다 한레벨 위 문제수
	int OneLevelUpQuestions = (int)(NUM_OF_QUESTIONS * 2);
	
	//회원레벨보다 2레벨 위 문제수
	int TwoLevelUpQuestions = (int)(NUM_OF_QUESTIONS * 2);
	
	//레벨에 따른 문제 총수
	int TotalQuestionsByLevel = SameLevelQuestions + OneLevelUpQuestions+TwoLevelUpQuestions;
	
	//문제별 가중치 최소값
	int MIN_WEIGHT = 0;
	
	//문제별 가중치 최대값
	int MAX_WEIGHT = 100;
	
	//과거 오답문제 선정 갯수
	int NUM_OF_WRONG = NUM_OF_QUESTIONS * 2;
	
	//신규문제 선정 갯수
	int NUM_OF_NEW = NUM_OF_QUESTIONS * 2;
	

	
	/**
	 * 매개변수로 넘겨받은 회원아이디를 바탕으로 회원별 맞춤 문제를 선정하여 return
	 * @param member_id
	 * @return
	 */
	public LinkedList<Question> getQuestion(String member_id, int member_level) {
		conn = DBManager.getConnection();
		String sql;
		
		//최종출제의 대상이 되는 문제 pool을 저장해 두는 List
		LinkedList<Question> tmp_questions = new LinkedList<Question>();
		
		// 문제 pool 추출을 위한 오답문제 pool을 저장해 두는 List
		LinkedList<Question> tmp_wrong_questions = new LinkedList<Question>();
		
		// 문제 pool 추출을 위한 신규등록 문제 pool을 저장해 두는 List
		LinkedList<Question> tmp_new_questions = new LinkedList<Question>();
		
		//최종선정된 문제들을 저장하는 List
		LinkedList<Question> questions = new LinkedList<Question>();
		LinkedList<Question> questions_final = new LinkedList<Question>();
		
		
		//난수 처리를 위한 변수들
		Random rand = new Random();
		int randomInt = 0;

		try {
			//회원레벨과 같은 레벨 문제를 random하게 추출
			sql = "SELECT word, selection1, selection2, selection3, selection4, answer, weight, question_id "
					+ "FROM questions "
					+ "WHERE weight >= ? AND weight < ? "
					+ "ORDER BY rand() limit 0,?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, member_level * 10);
			pstmt.setInt(2, (member_level + 1) * 10);
			pstmt.setInt(3, SameLevelQuestions);
			rs = pstmt.executeQuery();

			// 위에서 조회한 문제별로 Question object를 생성하여 LinkedList에 추가
			while (rs.next()) {
				Question question = new Question();
				
				question.setWord(rs.getString("word"));
				question.setSelection1(rs.getString("selection1"));
				question.setSelection2(rs.getString("selection2"));
				question.setSelection3(rs.getString("selection3"));
				question.setSelection4(rs.getString("selection4"));
				question.setAnswer(rs.getInt("answer"));
				question.setWeight(rs.getDouble("weight"));
				question.setQuestion_id(rs.getInt("question_id"));
				
				// Question객체를 LinkedList에 추가
				tmp_questions.add(question);
			}

			
			//회원레벨보다 1레벨 위 문제를 random하게 추출
			sql = "SELECT word, selection1, selection2, selection3, selection4, answer, weight, question_id "
					+ "FROM questions "
					+ "WHERE weight >= ? AND weight < ? "
					+ "ORDER BY rand() limit 0,?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, (member_level + 1) * 10);
			pstmt.setInt(2, (member_level + 2) * 10);
			pstmt.setInt(3, OneLevelUpQuestions);
			rs = pstmt.executeQuery();

			// 위에서 조회한 문제별로 Question object를 생성하여 LinkedList에 추가
			while (rs.next()) {
				Question question = new Question();
				
				question.setWord(rs.getString("word"));
				question.setSelection1(rs.getString("selection1"));
				question.setSelection2(rs.getString("selection2"));
				question.setSelection3(rs.getString("selection3"));
				question.setSelection4(rs.getString("selection4"));
				question.setAnswer(rs.getInt("answer"));
				question.setWeight(rs.getDouble("weight"));
				question.setQuestion_id(rs.getInt("question_id"));
				
				// Question객체를 LinkedList에 추가
				tmp_questions.add(question);
			}

			//회원레벨보다 2레벨 위 문제를 random하게 추출
			sql = "SELECT word, selection1, selection2, selection3, selection4, answer, weight, question_id "
					+ "FROM questions "
					+ "WHERE weight >= ? AND weight < ? "
					+ "ORDER BY rand() limit 0,?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, (member_level + 2) * 10);
			pstmt.setInt(2, (member_level + 3) * 10);
			pstmt.setInt(3, TwoLevelUpQuestions);
			rs = pstmt.executeQuery();

			// 위에서 조회한 문제별로 Question object를 생성하여 LinkedList에 추가
			while (rs.next()) {
				Question question = new Question();
				
				question.setWord(rs.getString("word"));
				question.setSelection1(rs.getString("selection1"));
				question.setSelection2(rs.getString("selection2"));
				question.setSelection3(rs.getString("selection3"));
				question.setSelection4(rs.getString("selection4"));
				question.setAnswer(rs.getInt("answer"));
				question.setWeight(rs.getDouble("weight"));
				question.setQuestion_id(rs.getInt("question_id"));
				
				// Question객체를 LinkedList에 추가
				tmp_questions.add(question);
			}

			//회원레벨(동일, 1, 2레벨 위)에 따른 문제 추출 갯수가 출제 목표 수보다 적을 경우 레벨에 관계없이 random하게 추출
			if(tmp_questions.size() < TotalQuestionsByLevel) {
				sql = "SELECT word, selection1, selection2, selection3, selection4, answer, weight, question_id "
						+ "FROM questions "
						+ "WHERE weight >= ? AND weight < ? "
						+ "ORDER BY rand() limit 0,?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, MIN_WEIGHT);
				pstmt.setInt(2, MAX_WEIGHT);
				pstmt.setInt(3, TotalQuestionsByLevel - tmp_questions.size());
				rs = pstmt.executeQuery();

				// 위에서 조회한 문제별로 Question object를 생성하여 LinkedList에 추가
				while (rs.next()) {
					Question question = new Question();
					
					question.setWord(rs.getString("word"));
					question.setSelection1(rs.getString("selection1"));
					question.setSelection2(rs.getString("selection2"));
					question.setSelection3(rs.getString("selection3"));
					question.setSelection4(rs.getString("selection4"));
					question.setAnswer(rs.getInt("answer"));
					question.setWeight(rs.getDouble("weight"));
					question.setQuestion_id(rs.getInt("question_id"));
					
					// Question객체를 LinkedList에 추가
					tmp_questions.add(question);
				}
			}

			//최근에 틀린(1차시도 오답) 문제를 오답 출제수의 3배수만큼 추출한 후 그 중에서 random하게 추출
			sql = "SELECT " + 
					"        `mwh`.`question_id` AS `question_id`," + 
					"        `q`.`word` AS `word`,\n" + 
					"        `q`.`selection1` AS `selection1`," + 
					"        `q`.`selection2` AS `selection2`," + 
					"        `q`.`selection3` AS `selection3`," + 
					"        `q`.`selection4` AS `selection4`," + 
					"        `q`.`answer` AS `answer`," + 
					"        `q`.`weight` AS `weight`" + 
					"    FROM " + 
					"        (`member_word_history` `mwh` " + 
					"        JOIN `questions` `q` ON ((`mwh`.`question_id` = `q`.`question_id`))) " + 
					"    WHERE " + 
					"        (`mwh`.`count_tried` > 1) "
					+ "AND `mwh`.`member_id` = ? "
					+ "AND (select weight from questions where question_id = `mwh`.`question_id`) < ? "
					+ "ORDER BY `mwh`.`date_created` limit 0,?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, member_id);
			// 오답문제중 회원레벨보다 한레벨 위 문제만 선택되도록 설정
			pstmt.setDouble(2, (member_level + 2) * 10);
			pstmt.setInt(3, NUM_OF_WRONG * 3);
			rs = pstmt.executeQuery();

			// 위에서 조회한 문제별로 Question object를 생성하여 LinkedList에 추가
			while (rs.next()) {
				Question question = new Question();
				
				question.setWord(rs.getString("word"));
				question.setSelection1(rs.getString("selection1"));
				question.setSelection2(rs.getString("selection2"));
				question.setSelection3(rs.getString("selection3"));
				question.setSelection4(rs.getString("selection4"));
				question.setAnswer(rs.getInt("answer"));
				question.setWeight(rs.getDouble("weight"));
				question.setQuestion_id(rs.getInt("question_id"));
				
				// Question객체를 LinkedList에 추가
				tmp_wrong_questions.add(question);
			}
			
			//tmp_wrong_questions.size()가 0일 경우 난수발생에서 에러가 발생하기때문...
			if(tmp_wrong_questions.size() != 0) {
				//3배수로 추출된 오답 문제중 random하게 추출
				for(int i = 0; i < NUM_OF_WRONG; i++) {
					
					//난수 생성
					randomInt = rand.nextInt(tmp_wrong_questions.size());
					
					//3배수 문제중 선정된 문제를 문제 pool에 등록
					tmp_questions.add(tmp_wrong_questions.get(randomInt));
					
					//선정된 문제를 pool에서 삭제
					tmp_wrong_questions.remove(randomInt);
					
					//3배수로 추출한 문제가 오답문제수보다 적을 경우 loop 종료
					if(tmp_wrong_questions.size()==0) {
						break;
					}
				}
			}
			
			//최근에 출제된 문제를 3배수로 추출 
			sql = "SELECT word, selection1, selection2, selection3, selection4, answer, weight, question_id "
					+ "FROM questions "
					+ "ORDER BY date_created limit 0,?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, NUM_OF_NEW * 3);
			rs = pstmt.executeQuery();

			// 위에서 조회한 문제별로 Question object를 생성하여 LinkedList에 추가
			while (rs.next()) {
				Question question = new Question();
				
				question.setWord(rs.getString("word"));
				question.setSelection1(rs.getString("selection1"));
				question.setSelection2(rs.getString("selection2"));
				question.setSelection3(rs.getString("selection3"));
				question.setSelection4(rs.getString("selection4"));
				question.setAnswer(rs.getInt("answer"));
				question.setWeight(rs.getDouble("weight"));
				question.setQuestion_id(rs.getInt("question_id"));
				
				// Question객체를 LinkedList에 추가
				tmp_new_questions.add(question);
				
			}

			//tmp_new_questions.size()가 0일 경우 난수발생에서 에러가 발생하기때문...
			if(tmp_new_questions.size() != 0) {
				//3배수로 추출된 오답 문제중 random하게 추출
				for(int i = 0; i < NUM_OF_NEW; i++) {
					
					//난수 생성
					randomInt = rand.nextInt(tmp_new_questions.size());
					
					//3배수 문제중 선정된 문제를 문제 pool에 등록
					tmp_questions.add(tmp_new_questions.get(randomInt));
					
					//선정된 문제를 pool에서 삭제
					tmp_new_questions.remove(randomInt);
					
					//3배수로 추출한 문제가 오답문제수보다 적을 경우 loop 종료
					if(tmp_new_questions.size()==0) {
						break;
					}
				}
			}
			
			
			//tmp_questions.size()가 0일 경우 난수발생에서 에러가 발생하기때문...
			if(tmp_questions.size() != 0) {

				Question tmp_question = new Question();
				boolean duplication = false;
				int tmp_question_id;
				System.out.println("tmp_questions size : " + tmp_questions.size());
				
				//최종 문제를 random하게 선정
				loop1:
				for(int i = 0; i < NUM_OF_QUESTIONS; ) {
					
					//난수 생성
					randomInt = rand.nextInt(tmp_questions.size());
					
					tmp_question = tmp_questions.get(randomInt);
					
					tmp_question_id = tmp_question.getQuestion_id();
					
					loop2:
					for(int j = 0; j < questions.size(); j++) {
						if(questions.get(j).getQuestion_id() == tmp_question_id) {
							duplication = true;
							break loop2;
						}else {
							duplication = false;
						}
					}
					
					// 중복된 문제를 거른 후 문제 선정
					if(duplication){
						//선정된 문제를 pool에서 삭제
						tmp_questions.remove(randomInt);
					}else {
						//문제pool에서 선정된 문제를 최종 출제 문제 List에 저장
						questions.add(tmp_question);
						
						//선정된 문제를 pool에서 삭제
						tmp_questions.remove(randomInt);
						
						i++;
						
					}
					
					//문제 pool수가 선정 목표보다 적을 경우 loop 종료
					if(tmp_questions.size() == 0) {
						break loop1;
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println(e.getErrorCode());
		} finally {
			try {
				// 자원 정리
				if (rs != null) {
					rs.close();
				}

				if (pstmt != null) {
					pstmt.close();
				}

				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				System.out.println(e.getErrorCode());
			}
		}

		log.info("{} questions selected for quiz", questions.size());
		
		// 줄바꿈 문자로 인한 오류 문제 해결
		for(int i=0; i < questions.size(); i++) {
			Question q = questions.get(i);
			String word = q.getWord();
			String selection1 = q.getSelection1();
			String selection2 = q.getSelection2();
			String selection3 = q.getSelection3();
			String selection4 = q.getSelection4();
			word = word.replaceAll("[\\n]", "<br>");
			selection1 = selection1.replaceAll("[\\n]", "<br>");
			selection2 = selection2.replaceAll("[\\n]", "<br>");
			selection3 = selection3.replaceAll("[\\n]", "<br>");
			selection4 = selection4.replaceAll("[\\n]", "<br>");
			q.setWord(word);
			q.setSelection1(selection1);
			q.setSelection2(selection2);
			q.setSelection3(selection3);
			q.setSelection4(selection4);
			questions_final.add(q);
			
		}
		
		// LinkedList 객체를 return
		return questions_final;
	}

	/**
	 * 매개변수로 넘겨받은 회원아이디를 바탕으로 회원별 최근 틀린 문제를 선정하여 return
	 * @param member_id
	 * @return
	 */
	public LinkedList<Question> getQuestion(String member_id, int member_level, int missed_cnt) {
		conn = DBManager.getConnection();
		String sql;
		
		//최종출제의 대상이 되는 문제 pool을 저장해 두는 List
		LinkedList<Question> tmp_questions = new LinkedList<Question>();
		
		// 문제 pool 추출을 위한 오답문제 pool을 저장해 두는 List
		LinkedList<Question> tmp_wrong_questions = new LinkedList<Question>();
		
		//최종선정된 문제들을 저장하는 List
		LinkedList<Question> questions = new LinkedList<Question>();
		
		//난수 처리를 위한 변수들
		Random rand = new Random();
		int randomInt = 0;

		try {
			//최근에 틀린(1차시도 오답) 문제를 추출
			sql = "SELECT " + 
					"        `mwh`.`question_id` AS `question_id`," + 
					"        `q`.`word` AS `word`,\n" + 
					"        `q`.`selection1` AS `selection1`," + 
					"        `q`.`selection2` AS `selection2`," + 
					"        `q`.`selection3` AS `selection3`," + 
					"        `q`.`selection4` AS `selection4`," + 
					"        `q`.`answer` AS `answer`," + 
					"        `q`.`weight` AS `weight`" + 
					"    FROM " + 
					"        (`member_word_history` `mwh` " + 
					"        JOIN `questions` `q` ON ((`mwh`.`question_id` = `q`.`question_id`))) " + 
					"    WHERE " + 
					"        (`mwh`.`count_tried` > 1) "
					+ "AND `mwh`.`member_id` = ?"
					+ "ORDER BY `mwh`.`date_created` limit 0,?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, member_id);
			pstmt.setInt(2, missed_cnt);
			rs = pstmt.executeQuery();

			// 위에서 조회한 문제별로 Question object를 생성하여 LinkedList에 추가
			while (rs.next()) {
				Question question = new Question();
				
				question.setWord(rs.getString("word"));
				question.setSelection1(rs.getString("selection1"));
				question.setSelection2(rs.getString("selection2"));
				question.setSelection3(rs.getString("selection3"));
				question.setSelection4(rs.getString("selection4"));
				question.setAnswer(rs.getInt("answer"));
				question.setWeight(rs.getDouble("weight"));
				question.setQuestion_id(rs.getInt("question_id"));
				
				// Question객체를 LinkedList에 추가
				tmp_wrong_questions.add(question);
			}
			
			//tmp_wrong_questions.size()가 0일 경우 난수발생에서 에러가 발생하기때문...
			if(tmp_wrong_questions.size() != 0) {
				//3배수로 추출된 오답 문제중 random하게 추출
				for(int i = 0; i < missed_cnt; i++) {
					
					//난수 생성
					randomInt = rand.nextInt(tmp_wrong_questions.size());
					
					//3배수 문제중 선정된 문제를 문제 pool에 등록
					tmp_questions.add(tmp_wrong_questions.get(randomInt));
					
					//선정된 문제를 pool에서 삭제
					tmp_wrong_questions.remove(randomInt);
					
					//3배수로 추출한 문제가 오답문제수보다 적을 경우 loop 종료
					if(tmp_wrong_questions.size()==0) {
						break;
					}
				}
			}
			
			//tmp_questions.size()가 0일 경우 난수발생에서 에러가 발생하기때문...
			if(tmp_questions.size() != 0) {
				//최종 문제를 random하게 선정
				for(int i = 0; i < missed_cnt; i++) {
					
					//난수 생성
					randomInt = rand.nextInt(tmp_questions.size());
					
					//문제pool에서 선정된 문제를 최종 출제 문제 List에 저장
					questions.add(tmp_questions.get(randomInt));
					
					//선정된 문제를 pool에서 삭제
					tmp_questions.remove(randomInt);
					
					//문제 pool수가 선정 목표보다 적을 경우 loop 종료
					if(tmp_questions.size()==0) {
						break;
					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println(e.getErrorCode());
		} finally {
			try {
				// 자원 정리
				if (rs != null) {
					rs.close();
				}

				if (pstmt != null) {
					pstmt.close();
				}

				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
				System.out.println(e.getErrorCode());
			}
		}

		log.info("{} missed questions selected to study again", questions.size());

		// LinkedList 객체를 return
		return questions;
	}
	
	/**
	 * 신규 문제 등록
	 * 
	 * @param question
	 * @return
	 */
	 public boolean newQuestion(Question question) {

		conn = DBManager.getConnection();
		String sql;

		try {
			sql = "insert into questions(date_created, creator_id, word, selection1, selection2, selection3, selection4, answer)"
					+ " values(now(),?,?,?,?,?,?,?)";
			// query문 작성
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, question.getCreator_id());
			pstmt.setString(2, question.getWord());
			pstmt.setString(3, question.getSelection1());
			pstmt.setString(4, question.getSelection2());
			pstmt.setString(5, question.getSelection3());
			pstmt.setString(6, question.getSelection4());
			pstmt.setInt(7, question.getAnswer());
			
			// 문제등록
			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println(e.getErrorCode());
			return false;
		} finally {
			try {
				// 자원 정리
				if (pstmt != null) {
					pstmt.close();
				}

				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		log.info("A new question for ({}) was added", question.getWord());

		return true;
	}
	
	
	/**
	 * 문제 수정
	 * 
	 * @param question
	 * @return
	 */
	 public boolean modifyQuestion(Question question) {

		conn = DBManager.getConnection();
		String sql;

		try {
			sql = "update questions set word=?, selection1=?, selection2=?, selection3=?, selection4=?, answer=?"
					+ " where question_id=?";
			// query문 작성
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, question.getWord());
			pstmt.setString(2, question.getSelection1());
			pstmt.setString(3, question.getSelection2());
			pstmt.setString(4, question.getSelection3());
			pstmt.setString(5, question.getSelection4());
			pstmt.setInt(6, question.getAnswer());
			pstmt.setInt(7, question.getQuestion_id());
			
			// 문제수정
			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println(e.getErrorCode());
			return false;
		} finally {
			try {
				// 자원 정리
				if (pstmt != null) {
					pstmt.close();
				}

				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

		log.info("Question id : {} was modified", question.getQuestion_id());

		return true;
	}

}

