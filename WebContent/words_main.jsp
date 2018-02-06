<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>

<!-- JSTL을 사용하기 위한 처리 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!--  custom tag을 사용하기 위한 처리 -->
<%@ taglib tagdir="/WEB-INF/tags" prefix="words"%>

<%
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" 
content="width=device-width, initial-scale=1, maximum-scale=1, 
minimum-scale=1, user-scalable=no, target-densitydpi=medium-dpi">
<link rel="stylesheet" href="css/styles.css" type="text/css"
	media="screen" />
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
<link rel="icon" href="favicon.ico" type="image/x-icon">
<title>Wizard Of Words</title>
<script src="http://code.jquery.com/jquery-3.2.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>

</head>

<body>
	<header>
		<h1>W<span class="tiny_font">izard </span>O<span class="tiny_font">f &nbsp;</span> W<span class="tiny_font">ords</span></h1>
	</header>

	<nav>
		<div class="menu">
			<ul>
				<!-- <li><a href="#">Home &nbsp;&nbsp;</a></li> -->
				
				<!-- 
				custom tag 'login'사용 
				
				회원이 로그인하지 않은 상태일 경우
				. 아이디와 패스워드 입력폼 출력
				. 신규회원 가입 링크 제공
				
				회원이 로그인한 상태일 경우
				. 복습 링크 제공
				. 문제출제 권한이 있는 회원의 경우 문제출제 링크 제공
				. 회원정보 링크 제공
				. 로그아웃 버튼
				-->
				<words:login />
		</div>
	</nav>
	<div align="center">
		<br>
		
		<!-- 
		custom tag 'quiz' 사용
		. 회원이 로그인한 상태인 경우 : 퀴즈시작 링크 제공
		. 회원이 로그인하지 않은 상태일 경우 : Welcome Message 출력
		 -->
		<words:quiz />
	</div>
</body>
</html>

