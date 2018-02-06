<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="UTF-8" %>
<%@ page import="words.question.*, words.member.*, java.util.*, java.lang.*, org.json.*, javax.swing.JOptionPane" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 문제이력DB에 Access하는 객체 -->
<jsp:useBean id="mwh_dao" class="words.question.MemberWordHistoryDAO"/>

<!-- 문제DB에 Access하는 객체 -->
<jsp:useBean id="questions_dao" class="words.question.QuestionsDAO" />

<jsp:useBean id="mdao" class="words.member.MemberDAO" />

<!-- (새로이 만들어진)문제 하나를 담아두는 객체 -->
<jsp:useBean id="question" class="words.question.Question">
	<!-- 새로운 문제출제 페이지에서 넘어온 데이타를 question 객체에 저장 -->
	<jsp:setProperty name="question" property="*" />
</jsp:useBean>

<%
	/*************************************************
	기본 변수 정의
	*************************************************/
	
	// 홈 url
	String home = "words_main.jsp";

	// 문제이력 DB로 보내기 위한 회원별 문제풀이 이력을 임시로 저장해두는 객체
	ArrayList<MemberWordHistory> word_history = new ArrayList<MemberWordHistory>();
	
	// DB에서 가져온 문제들을 저장
	LinkedList<Question> questionDAO_result = new LinkedList<Question>();
	
	// 컨트롤러페이지를 요청하는 페이지에서 넘겨주는 action 값
	String action = request.getParameter("action");

	// 컨트롤러페이지를 요청하는 페이지에서 넘겨주는 renew_score 값
	String renew_score = request.getParameter("renew_score");
	
	renew_score = renew_score == null ? "" : renew_score;
	
	// 로그인 성공후 session에 저장해둔 회원 아이디와 회원 레벨을 가져와서 저장
	// getAttribute()의 리턴값이 객체이므로 toString()메소드를 사용
	String member_id = session.getAttribute("member_id").toString();
	int member_level= Integer.parseInt(session.getAttribute("member_level").toString());
	
	// quiz.jsp에서 념겨준 문제이력 데이타(json string)를 저장
	String history_string = request.getParameter("history_array");
	
	// history_string이 null인 경우는 문제 화면 이외의 화면에서 접근한 경우임. 
	// 문제화면에서의 접근인 경우 문제풀이 이력 정보를  저장함
	if(history_string != null){
		
		// jason string을 jason array 객체로 변환
		JSONArray history_json = new JSONArray(history_string);
	
	
		// jason array에 담긴 이력정보를 하나씩 꺼내어 List객체에 저장
		for(int i=0; i < history_json.length(); i++){
			
			JSONObject e = history_json.getJSONObject(i);
			MemberWordHistory mwh = new MemberWordHistory();
			mwh.setMember_id(e.getString("member_id"));
			mwh.setMember_level(e.getInt("member_level"));
			mwh.setQuestion_id(e.getInt("question_id"));
			mwh.setCount_tried(e.getInt("count_tried"));
			mwh.setWeight(e.getDouble("weight"));
			mwh.setScore(e.getDouble("score"));
			
			// 회원이력저장 ArrayList에 MemberWordHistory객체를 추가 
			word_history.add(mwh);
		}
	}
	
	// 컨트롤러에 요청하는 action의 구분에 따른 처리
	switch(action){
	
	// 문제 수정을 요청한 경우
	case "modify":
		System.out.println("modify");
		
		// 문제DB를 update
		if (questions_dao.modifyQuestion(question)) {
			// 수정이 성공하면 성공 페이지로 이동
			pageContext.forward("modify_question_success.jsp");
		} else {
			throw new Exception("문제 수정 오류!!");
		}
		
		break;
		
	// 최근에 틀린문제 복습을 요청한 경우
	case "missed":
		
		// 새로운 문제를 가져오기 전에 기존의 문제들을 비움
		questionDAO_result.clear();
		
		// 요청할 문제의 수
		int missed_cnt = 20;
		
		// 문제를 가져와서 ArrayList<Qeustion>에 저장
		questionDAO_result = questions_dao.getQuestion(member_id, member_level, missed_cnt);
			
		if(questionDAO_result.size() == 0){
			pageContext.forward(home);		
			//JOptionPane.showMessageDialog(null, "not enough questions for you");
			System.out.println("not enough questions for you");
			return;
		}
		// DB에서 가져온 문제들을 request 객체에 담음 (quiz.jsp로 보내기 위해)
		request.setAttribute("questions", questionDAO_result);
		
		// 문제 출제 페이지로 이동
		pageContext.forward("quiz_missed.jsp");
		
		break;
	
	// 문제 출제를 요청한 경우	
	case "quiz":
		
		// 저장해야할 문제이력이 있는 경우
		if(word_history.size() > 0){
			
			// 문제이력을 저장
			if(mwh_dao.addMemberWordHistory(word_history)){
				
				// 저장이 완료된 이력정보 ArrayList를 비움
				word_history.clear();
				
				// update된 이력정보를 바탕으로 신규 member_level 산정
				int newMemberLevel = mdao.chkMemberLevel(member_id);
				
				//신규 member_level 산정에 실패한 경우
				if(newMemberLevel == 0){
					
					//신규 member_level 산정에 성공한 경우	
				}else if(mdao.setMemberLevel(member_id, newMemberLevel)){
					//session객체의 member_level update
					session.setAttribute("member_level", newMemberLevel);
				}
			}
			
		}
		
		// 새로운 문제를 가져오기 전에 기존의 문제들을 비움
		questionDAO_result.clear();
		
		// 문제를 가져와서 ArrayList<Qeustion>에 저장
		questionDAO_result = questions_dao.getQuestion(member_id, member_level);
			
		if(questionDAO_result.size() == 0){
			pageContext.forward(home);		
			//JOptionPane.showMessageDialog(null, "not enough questions for you");
			System.out.println("not enough questions for you");
			return;
		}
		
		// DB에서 가져온 문제들을 request 객체에 담음 (quiz.jsp로 보내기 위해)
		request.setAttribute("questions", questionDAO_result);
		
		// 문제 출제 페이지로 이동
		pageContext.forward("quiz.jsp");
		
		break;
	
	// 메인화면으로	
	case "home":
		
		// 저장해야할 문제이력이 있는 경우 (quiz.jsp에서 온 경우)
		if(word_history.size() > 0){
					
			// 문제이력을 저장
			if(mwh_dao.addMemberWordHistory(word_history)){
			
				// 저장이 완료된 이력정보 ArrayList를 비움
				word_history.clear();
				
				// update된 이력정보를 바탕으로 신규 member_level 산정
				int newMemberLevel = mdao.chkMemberLevel(member_id);
				
				//신규 member_level 산정에 실패한 경우
				if(newMemberLevel == 0){
					
					//신규 member_level 산정에 성공한 경우	
				}else if(mdao.setMemberLevel(member_id, newMemberLevel)){
					//session객체의 member_level update
					session.setAttribute("member_level", newMemberLevel);
				}
			}
			
		}
		
		// 점수 재계산이 필요한 경우에만 재계산해서 session에 저장
		if(renew_score.equals("yes")){
			// session에서 member_id를 가져와서 점수와 레벨 확인후 session에 저장
			double member_avg_dbl = mdao.chkMemberAverage(member_id);
			String member_average = String.format("%.2f", member_avg_dbl);
			member_level = mdao.chkMemberLevel(member_avg_dbl);
			session.setAttribute("member_average", member_average);
			session.setAttribute("member_level", member_level);
		}
		// 시작페이지로 이동
		pageContext.forward(home);
		break;
		
	// 새로운 문제 등록 요청
	case "add":
		// Question객체의 문제 작성자 아이디 설정
		question.setCreator_id(member_id);
		
		// 문제DB에 Question객체를 저장
		if (questions_dao.newQuestion(question)) {
			
			// 저장이 성공하면 다음문제 출제를 위하여 문제 출제 페이지로 이동
			response.sendRedirect("add_question.jsp");
		} else {
			throw new Exception("문제 등록 오류!!");
		}
		
		break;
		
	}
	
%>