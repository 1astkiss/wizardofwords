<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.json.*" %>

<!-- (새로이 만들어진)문제 하나를 담아두는 객체 -->
<jsp:useBean id="question" class="words.question.Question">
</jsp:useBean>

<%
	//quiz.jsp에서 념겨준 문제이력 데이타(json string)를 저장
	String question_string = request.getParameter("modify_question");
	System.out.println("question_string at jsp : " + question_string);
	
	// history_string이 null인 경우는 문제 화면 이외의 화면에서 접근한 경우임. 
	// 문제화면에서의 접근인 경우 문제풀이 이력 정보를  저장함
	if(question_string != null){
		
		// jason string을 jason array 객체로 변환
		JSONObject q = new JSONObject(question_string);
		question.setQuestion_id(q.getInt("question_id"));
		question.setWord(q.getString("word"));
		question.setSelection1(q.getString("selection1"));
		question.setSelection2(q.getString("selection2"));
		question.setSelection3(q.getString("selection3"));
		question.setSelection4(q.getString("selection4"));
		question.setAnswer(q.getInt("answer"));
		//pageContext.setAttribute("question", question);
		
		
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" 
content="width=device-width, initial-scale=1, maximum-scale=1, 
minimum-scale=1, user-scalable=no, target-densitydpi=medium-dpi">
<link rel="stylesheet" href="css/styles.css" type="text/css"
	media="screen" />
<script src="http://code.jquery.com/jquery-3.2.1.js"></script>
<title>Modify a question</title>
<style>
h2 {
	text-align:center;
	width: 100%;
	/*line-height: 50px;
	background: #333;
	color: #fff;
	*/
}

table {
	margin: auto;
}
</style>
<script>
$(function(){
	
	//문제의 정답을 radio button에 설정
	switch(${question.answer}){
		case 1:
			$('#radio1').attr("checked", "checked");
			break;
			
		case 2:
			$('#radio2').attr("checked", "checked");
			break;
			
		case 3:
			$('#radio3').attr("checked", "checked");
			break;
			
		case 4:
			$('#radio4').attr("checked", "checked");
			break;
			
	}
});
		
</script>
</head>
<body>
	<header>
		<h1>W<span class="tiny_font">izard </span>O<span class="tiny_font">f &nbsp;</span> W<span class="tiny_font">ords</span></h1>
	</header>

	<div>
		<hr>
		<h2>Add a new word here</h2>
		<hr>
		<form name="add_question" method="post"	action="words_control.jsp">
			<input type="hidden" name="action" value="modify">
			<table id="question_table">
				<tr>
					<td id="table_head" colspan="2"><textarea class="ta_word" name="word"
							placeholder="new word here...." required>${question.word}</textarea></td>
				</tr>
				<tr>
					<td class="select c1">( 1 )</td>
					<td><textarea name="selection1" class="ta_selection"
							placeholder="first selection here..." required>${question.selection1}</textarea>
					</td>
				</tr>
				<tr>
					<td class="select c2">( 2 )</td>
					<td><textarea name="selection2" class="ta_selection"
							placeholder="second selection here..." required>${question.selection2}</textarea></td>
				</tr>
				<tr>
					<td class="select c3">( 3 )</td>
					<td><textarea name="selection3" class="ta_selection"
							placeholder="third selection here..." required>${question.selection3}</textarea></td>
				</tr>
				<tr>
					<td class="select c4">( 4 )</td>
					<td><textarea name="selection4" class="ta_selection"
							placeholder="fourth selection here..." required>${question.selection4}</textarea></td>
				</tr>
				<tr>
					<td style="font-size:1.2em">Answer</td>
					<td><input id="radio1" type="radio" name="answer" value="1"><label for="radio1">(1)&nbsp; </label>
					<input id="radio2" type="radio" name="answer" value="2"><label for="radio2">(2)&nbsp;</label> 
					<input id="radio3" type="radio" name="answer" value="3"><label for="radio3">(3)&nbsp;</label> 
					<input id="radio4" type="radio" name="answer" value="4"><label for="radio4">(4)</label> </td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" value="Modify">
						<input type="hidden" name="question_id" value="${question.question_id}">
						<input type="button" value="Cancel" onclick="document.location.href='javascript:history.back()'" ></td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>