<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="utf-8" %>
	
<jsp:useBean id="mdao" class="words.member.MemberDAO" />
	
<%
	/* String member_id = (String)session.getAttribute("member_id");
	double member_average = mdao.chkMemberAverage(member_id);
	int member_level = mdao.chkMemberLevel(member_id);
	System.out.println("member_average : " + member_average);
	session.setAttribute("member_average", member_average);
	session.setAttribute("member_level", member_level); */

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
<title>Add a new member</title>
<style>
h2 {
	text-align : center;
}

table {
	margin: auto;
}

tr:last-child {
	text-align : center;
}

</style>
<script src="http://code.jquery.com/jquery-3.2.1.js"></script>
<script>
	$(function(){
		$('#modify_member_btn').click(function(){
			var current_password = $('input[name="passwd"]').val();
			var new_password1 = $('input[name="new_password1"]').val();
			var new_password2 = $('input[name="new_password2"]').val();
			var db_password = "${password}";
			
			if(current_password != "${password}"){
				alert("비밀번호가 틀립니다.");
				event.preventDefault();
			}else if(new_password1.length < 6 || new_password1.length > 12){
				alert("비밀번호는 6자이상 12자 이하이어야 합니다");
				event.preventDefault();
			}else if(new_password1 == current_password){
				alert("새 비밀번호가 기존과 같습니다");
				event.preventDefault();
			}else if(new_password1 != new_password2){
				alert("새로운 비밀번호를 다시 확인하세요...");
				event.preventDefault();
			}else{
				$('input[name="passwd"]').val(new_password1);
			}
		});
	});
</script>
</head>
<body>
	<header>
		<h1>W<span class="tiny_font">izard </span>O<span class="tiny_font">f</span>&nbsp; W<span class="tiny_font">ords</span></h1>
	</header>
	<hr>
	<H2>회원정보</h2>
	<hr>
	<form method="post" action="member_control.jsp?action=modify">
		<table id="new_member_table">
			<tr>
				<td>ID</td>
				<td><input type="text" size="13" placeholder="8~12자(영어소문자, 숫자만)" value='${member_id}' disabled>
				<input type="hidden" name="member_id" value='${member_id}' ></td>
			</tr>
			<tr>
				<td>Level</td>
				<td><input type="text" size="13" value='${member_level}' disabled>
			</tr>
			<tr>
				<td>Average</td>
				<td><input type="text" size="13" value='${member_average}' disabled id="member_average">
			</tr>
			<tr>
				<td>Password</td>
				<td><input type="password" name="passwd" size="13" required placeholder="현재 패스워드"></td>
			</tr>
			<tr>
				<td rowspan="2">New Password</td>
				<td><input type="password" name="new_password1" size="13" required placeholder="새 패스워드(6~12자)"></td>
			</tr>
			<tr>
				<td><input type="password" name="new_password2" size="13" required placeholder="새 패스워드(확인)"></td>
			</tr>
			<tr>
				<td>Name</td>
				<td><input type="text" name="nickname" size="30" placeholder="실명 혹은 영어 이름(nickname)" required value='${nickname}'></td>
			</tr>
			<tr>
				<td>e-mail</td>
				<td><input type="email" name="email" size="10" placeholder="email" value='${email}'></td>
			</tr>
			<tr>
				<td>출생년도</td>
				<td><input type="number" name="birth_year" min="1900" max="2030" step="1" required value='${birth_year}'></td>
			</tr>
			<tr>
				<td colspan="2"><input id="modify_member_btn" type="submit" value="정보변경"></form>
				<form id="cancel_add_member" method='post' action='words_main.jsp'>
					<input type="submit" value="변경취소"></td>
				</form>
			</tr>
		</table>
	
</body>
</html>