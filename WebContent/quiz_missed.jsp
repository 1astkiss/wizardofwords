<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*, words.question.Question"%>
<!-- JSTL을 사용하기 위한 처리 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- words_control.jsp에서 보내온 Question 객체 LinkedList (새로운 문제가 담겨 있음) -->
<jsp:useBean id="questions" class="java.util.LinkedList" scope="request" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" 
content="width=device-width, initial-scale=1, maximum-scale=1">
<title>Quiz Page</title>
<link rel="stylesheet" href="css/styles.css" type="text/css"
	media="screen" />

<script src="http://code.jquery.com/jquery-3.2.1.js"></script>
<script>
	window.onload = function() {
		
		// 퀴즈를 시작할때 첫번째 문제 load
		next_question();
	};

	// words_control.jsp에서 보내온 Question객체 LinkedList를 담아두기 위한 Array
	var q_array = new Array();
	
	// 현재 load된 문제
	var current_question;
	var tmp_question;
	var question_level = 0;
	
	// 정답 여부를 확인하기 위해 현재 load된 문제의 정답(DB에서 가져온 값)을 보관
	var current_answer;
	var tmp_answer;
	
	// 회원별 문제풀이 이력을 저장했다가 words_control.jsp로 보내기 위해 임시보관하는 Array
	var history_array = new Array();
	
	// 문제를 몇번만에 맞추었는가를 저장
	var count_tried = 0;
	
	// 문제 최대 시도 가능 횟수. 3이상은 점수 산정이 같으므로 최대값을 3으로 설정
	var MAX_TRY = 3;
	
	// 문제 푸는 시간 제한. 제한된 시간내에 답을 click해야 함. 시간내에 안하면 한번 click한 것으로 간주
	var TIME_LIMIT = 5;
	
	// 설정한 시간 제한 timer함수의 id
	var intervalId1;
	
	// 회원별 문제풀이 이력 Array를 words_control.jsp로 보내기 위해 Json String으로 변환한 값
	var json_string = "";

	// request객체에 저장되어 있는 LinkedList(DB에서 가져온 문제)의 문제 정보를 JavaScript 변수에 저장
	<c:forEach var="i" items="${questions}" begin="0" varStatus="status">
		
		// 개별 문제 정보 저장
		var question = {
			'question_id' : '${i.question_id}',
			'word' : '${i.word}',
			'answer' : '${i.answer}',
			'selection1' : '${i.selection1}',
			'selection2' : '${i.selection2}',
			'selection3' : '${i.selection3}',
			'selection4' : '${i.selection4}',
			'weight' : '${i.weight}',
		};
	
		// 개별 문제를 Array에 저장
		q_array.push(question);
	
	</c:forEach>

	
	/***************************************
	
	사용자가 다음 문제 버튼을 눌렀을 때 다음 문제를 출제하는 함수 
	
	****************************************/
	var next_question = function() {
		
		// 문제 시도 횟수를 초기화하고 화면에 표시
		count_tried = 0;
		$('#out_count').html(count_tried);
		
		// 감추었던 타이머를 화면에 표시
		$('#timer').removeClass('hide_element');

		
		// 문제가 하나도 안 남아 있으면 새로운 문제를 가져옴
		if (q_array.length <= 0) {
			
			// 문제이력을 넘겨주면서 words_control로 이동하는 버튼을 시행
			$('#more_question_button').click();
			
		} else { //문제가 남아 있으면 해당 문제를 화면에 load
			
			// 문제 번호의 선택 초기화 
			$('td a').removeClass('wrong_answer');
			$('td a').removeClass('right_answer');
			
			// q_array에서 다음 문제를 꺼내서 load
			current_question = q_array.shift();
			
			// 문제의 정답을 저장
			current_answer = Number(current_question.answer);
			
			// 선택지를 임시 Array에 저장
			var tmp_selection = [current_question.selection1, current_question.selection2, 
				current_question.selection3, current_question.selection4];
			
			// random index 저장을 위한 변수 선언
			var random_index1, random_index2, random_index3, random_index4;
			
			// 첫번째 random index 생성
			random_index1 = Math.floor(Math.random() * 4);
			
			do{
				// 두번째 random index 생성 (기존 번호와 중복시 다시 생성)
				random_index2 = Math.floor(Math.random() * 4);
			}while(random_index2 == random_index1);
			
			do{
				// 세번째 random index 생성 (기존 번호와 중복시 다시 생성)
				random_index3 = Math.floor(Math.random() * 4);
			}while(random_index3 == random_index1 || random_index3 == random_index2);
			
			do{
				// 네번째 random index 생성 (기존 번호와 중복시 다시 생성)
				random_index4 = Math.floor(Math.random() * 4);
			}while(random_index4 == random_index1 || random_index4 == random_index2
					|| random_index4 == random_index3);
			
			// 생성된 radom index들을 array에 저장
			var random_index = [random_index1, random_index2, random_index3, random_index4];
			
			// 변경된 답의 위치 저장
			current_answer = random_index[current_answer - 1] + 1;
			
			// random하게 변경된 선택지를 저장할 array
			var random_selection = [];
			
			// random하게 변경된 선택지를 저장
			for(var i = 0; i < tmp_selection.length; i++){
				random_selection[random_index[i]] = tmp_selection[i];
			}
			
			question_level = chkQuestionLevel(current_question.weight);

			// 현재 문제를 화면에 표시
			$('#q_level').html(question_level);
			$('#table_head').html(current_question.word);
			$('#s1').html(random_selection[0]);
			$('#s2').html(random_selection[1]);
			$('#s3').html(random_selection[2]);
			$('#s4').html(random_selection[3]);
			
			// 선택지를 눌러도 작동하도록 설정
			$('#s1, .c1').one('click', function(){
				check_answer(1);
			});
			
			$('#s2, .c2').one('click', function(){
				check_answer(2);
			});
			
			$('#s3, .c3').one('click', function(){
				check_answer(3);
			});
			
			$('#s4, .c4').one('click', function(){
				check_answer(4);
			});
			
			$('#timer').html(TIME_LIMIT);
			$('#time_info').html(TIME_LIMIT);
			$('#next_table').addClass('hide_element');

			// 시간제한을 화면에 표시
			count_down();
		}
	};
	
	/***************************************
	문제별 가중치를 입력하면 문제 level을 정해주는 함수
	
	****************************************/
	var chkQuestionLevel = function(weight) {
	
		var q_level = 0;
				
		if(weight < 20) q_level = 1;
		else if(weight < 30) q_level = 2;
		else if(weight < 40) q_level = 3;
		else if(weight < 50) q_level = 4;
		else if(weight < 60) q_level = 5;
		else if(weight < 70) q_level = 6;
		else if(weight < 80) q_level = 7;
		else if(weight < 90) q_level = 8;
		else q_level = 9;
			
		return q_level;
	};
	
	
	/***************************************
	
	다음의 경우 정답을 보여주고 문제 컨트롤을 활성화하는 함수
	1. 사용자가 정답을 click한 경우
	2. 최대 시도횟수에 도달한 경우
	
	****************************************/
	var mark_answer = function(answer){

		// 선택지를 눌러도 작동하도록 설정한 것을 초기화(초기화하지 않으면 지난번에 눌리지 않은 이벤트에 누적되게 됨)
		$('#s1, .c1').off('click');
		$('#s2, .c2').off('click');
		$('#s3, .c3').off('click');
		$('#s4, .c4').off('click');
		
		// 선택번호를 제외한 모든 선택번호 비활성화 
		switch (answer) {
		case 1:
			$('.c2>a, .c3>a, .c4>a').addClass('wrong_answer');
			$(".c1>a").addClass("right_answer");
			break;
		case 2:
			$('.c1>a, .c3>a, .c4>a').addClass('wrong_answer');
			$(".c2>a").addClass("right_answer");
			break;
		case 3:
			$('.c1>a, .c2>a, .c4>a').addClass('wrong_answer');
			$(".c3>a").addClass("right_answer");
			break;
		case 4:
			$('.c1>a, .c2>a, .c3>a').addClass('wrong_answer');
			$(".c4>a").addClass("right_answer");
			break;
		};
		
		
		// 다음문제 버튼, 퀴즈 더불러오기(숨김), 그만두기 버튼을 화면에 표시. 
		$('#next_table').removeClass('hide_element');
		$("#answer").html(current_answer);
			
		// 문제풀이가 끝났으므로 타이머를 감춤
		$('#timer').addClass('hide_element');
		
	};
	
	/***************************************
	
	문제시도 횟수를 증가시키는 함수
		
	****************************************/
	var increase_count_tried = function(){
		
		// 문제시도 횟수 증가
		count_tried++;
		$('#out_count').html(count_tried);
		
		// 문제시도 횟수가 최대 시도횟수에 도달한 경우
		if(count_tried >= MAX_TRY){
			
			// 타이머 정지
			clearInterval(intervalId1);
			
			// 문제시도 횟수 증가(0점 처리를 위해 시도횟수를 4로 세팅)
			count_tried++;
			
			// 문제 종료 및 정답 표시
			mark_answer(current_answer);
		}else{	
		}
	};
	
	
	/***************************************
	
	시간제한(타이머)을 표시하는 함수

	****************************************/
	var count_down = function(){
		
		var time_remain = TIME_LIMIT;
		$('#timer').html(time_remain);
		
		// 1초마다 남은 시간을 감소시킴
		intervalId1 = setInterval(function(){
			$('#timer').html(--time_remain);
			
			if(time_remain == 0){
				time_remain = TIME_LIMIT;
				increase_count_tried(); //제한시간이 경과하면 시도횟수 1증가
				$('#timer').html(time_remain);
			}
		}, 1000);
		
	};
	
	
	/***************************************
	
	  사용자가 답을 click하면 정답인지 확인하는 함수 
	
	****************************************/
	var check_answer = function(selected_answer) {

		//타이머 정지
		clearInterval(intervalId1);

 		
 
		//오답인 경우
		if (current_answer != selected_answer) {
			
			// 문제 시도 횟수를 1 증가하고 화면에 표시
			count_tried++;
			$('#out_count').html(count_tried);
			
			// 시도횟수가 시도 가능횟수를 초과하면 문제를 종료하고 정답을 표시
			if(count_tried >= MAX_TRY){
				
				count_tried++; // 0점 처리를 위해 시도횟수를 4로 세팅
				mark_answer(current_answer);
				
			}else{
				//선택한 답이 오답인 경우 선택한 답을 다시 선택하지 못하도록 처리
				switch (selected_answer) {
				case 1:
					$(".c1>a").addClass("wrong_answer");
					break;
				case 2:
					$(".c2>a").addClass("wrong_answer");
					break;
				case 3:
					$(".c3>a").addClass("wrong_answer");
					break;
				case 4:
					$(".c4>a").addClass("wrong_answer");
					break;
				};
				
				// 다음 시도가 시작되었으므로 타이머 재실행
				count_down();				
				
			}
		} else { //정답을 선택한 경우 
			// 문제 시도 횟수를 화면에 표시후 1 증가
			$('#out_count').html(count_tried);
			count_tried++;
			
			//정답을 표시하고 문제콘트롤을 활성화
			mark_answer(selected_answer);
		}
	};
	
</script>

<style>
form{
	display: inline;
}
</style>
</head>

<body>
	<header>
		<h1>W<span class="tiny_font">izard </span>O<span class="tiny_font">f &nbsp;</span> W<span class="tiny_font">ords</span></h1>
	</header>

	<div align="center">
		<hr>
		<h2>(복습모드) <span id="time_info"></span>초내에 답하세요</h2>
		<hr>
		<table id="question_table">
			<tr>
				<td id="" align="center">L<span id="q_level"></span></td>
				<td id="table_head">'${question.word}'</td>
			</tr>
			<tr>
				<td class="select c1"><a>1</a></td>
				<td id="s1" class="selectword">${question.selection1 }</td>
			</tr>
			<tr>
				<td class="select c2"><a>2</a></td>
				<td id="s2" class="selectword">${question.selection2 }</td>
			</tr>
			<tr>
				<td class="select c3"><a>3</a></td>
				<td id="s3" class="selectword">${question.selection3 }</td>
			</tr>
			<tr>
				<td class="select c4"><a>4</a></td>
				<td id="s4" class="selectword">${question.selection4 }</td>
			</tr>
		</table>
		
		<h1 style="margin:0.2em;">Out Count : <span id='out_count'>0</span></h1>
				
		<H1 id='timer' style="margin:0.2em;"></H1>

		<table id='next_table'>
			<tr id='next_quiz'>
				<td align='center' valign='middle' height='30'>정답은 <span id="answer"></span>번 입니다!!!</td>
				</tr>
			<tr>
				<td>
					<input class='quiz_control' type='button' value='다음문제' onclick='next_question()'>
		
					<form class='hide_element' method='post' action='words_control.jsp?action=quiz'>
						<input type='submit' value='퀴즈더' id='more_question_button'>
					</form>
		
					<form method='post' action='words_control.jsp?action=home'>
						<input class='quiz_control' type='submit' value='퀴즈그만' id='quit_button'>
					</form>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>