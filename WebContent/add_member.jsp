<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="utf-8" %>
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
		$('#add_member_btn').click(function(){
			var member_id = $('input[name="member_id"]').val();
			var password = $('input[name="passwd"]').val();
			
			if(member_id.length < 8 || member_id.length > 12){
				alert("아이디는 8자이상 12자 이하이어야 합니다");
				event.preventDefault();
			}else if(!isAlphaOrNumber(member_id)){
				alert("아이디는 영어소문자와 숫자만 가능합니다");
				event.preventDefault();
			}else if(password.length < 6 || password.length > 12){
				alert("비밀번호는 6자이상 12자 이하이어야 합니다");
				event.preventDefault();
			}
		});
		
	});
	
	function isAlphaOrNumber(str){
		//var lowerAlphaOrNumber = ;
		if(/^[a-z0-9]+$/.test(str)){
			return true;
		}else{
			return false;
		}
	}
</script>
</head>
<body>
	<header>
		<h1>W<span class="tiny_font">izard </span>O<span class="tiny_font">f</span>&nbsp; W<span class="tiny_font">ords</span></h1>
	</header>
	<hr>
	<H2>회원가입</h2>
	<hr>
	<form method="post" action="member_control.jsp?action=add">
		<table id="new_member_table">
			<tr>
				<td>ID</td>
				<td><input type="text" name="member_id" size="13" required placeholder="8~12자(영어소문자, 숫자만)"></td>
			</tr>
			<tr>
				<td>Password</td>
				<td><input type="password" name="passwd" size="13" required placeholder="6~12자"></td>
			</tr>
			<tr>
				<td>Name</td>
				<td><input type="text" name="nickname" size="30" placeholder="실명 혹은 영어 이름(nickname)" required></td>
			</tr>
			<tr>
				<td>e-mail</td>
				<td><input type="email" name="email" size="10" placeholder="email" ></td>
			</tr>
			<tr>
				<td>출생년도</td>
				<td><input type="number" name="birth_year" min="1900" max="2030" step="1" value="2001" required></td>
			</tr>
			<tr>
				<td colspan="2"><input id="add_member_btn" type="submit" value="회원등록"></form>
				<form id="cancel_add_member" method='post' action='words_main.jsp'>
					<input type="submit" value="등록취소"></td>
				</form>
			</tr>
		</table>
</body>
</html>