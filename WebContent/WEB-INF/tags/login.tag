<%@ tag pageEncoding="UTF-8" body-content="scriptless"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<!-- request객체나 session객체에 저장된 변수는 별도 처리 없이 표현언어로 접근 가능
		단, 표현언어는 java scriptlet 영역에서는 쓸 수 없음 -->

	<!-- 회원이 로그인한 상태인 경우 -->
<c:choose>
	<c:when test="${member_id != null }">
		<!--  틀린문제 복습페이지로 링크 -->
		<li><a href="words_control.jsp?action=missed"> 복습 &nbsp;&nbsp; </a></li>

		<!-- 출제권한이 있는 회원인 경우 문제출제 페이지 링크 활성화 -->
		<c:if test="${can_make_question == 1}">
			<li><a href="add_question.jsp"> 문제출제 &nbsp;&nbsp; </a></li>
		</c:if>

		<!--  로그아웃 링크 -->
		<li class="nav_menu_right">
			<form name="loginform" method="post" action="member_control.jsp">
				<input type="hidden" name="action" value="logout"> 
				<input type="submit" value="로그아웃" style="width:80px">
			</form>
		</li>
		
		<!--  회원정보 링크 -->
		<li class="nav_menu_right"><a href="manage_member_info.jsp">회원정보 </a></li></ul>
		<br><br>
		<h5 align="center"> Hi ${member_id}, you are level${member_level} and your score is ${member_average}</h5>
	</c:when>
	
	<c:otherwise>
		<!-- 신규회원 가입 페이지 링크 -->
		<li><a href="add_member.jsp">회원가입 &nbsp;&nbsp;</a></li>
		
		<!--  로그인 폼 : 아이디, 패스워드입력 -->
		<li class="nav_menu_right">
			<form name="loginform" method="post" action="member_control.jsp">
				<input type="hidden" name="action" value="login">
				<input type="text" name="member_id" placeholder="ID" >
				<input type="password" name="passwd" placeholder="password" >
				<input type="submit" value="로그인" style="width:60px">
			</form>
		</li></ul>
	</c:otherwise>
</c:choose>
