<%@ tag pageEncoding="UTF-8" body-content="scriptless"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 문제 수정 권한이 있는 사용자의 경우 문제수정 버튼 활성화 -->
<c:if test="${can_make_question == 1}">
	<form method = "post" action="modify_question.jsp">
		<input type='hidden' name='modify_question' value='' id='modify_question'>
		<input type='submit' value='문제수정' id='modify_q_btn'>
	</form>
</c:if>
