<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 태그의 속성 정의 : 태그를 사용할때 속성값을 입력함 -->
<%@ attribute name="type" %>

<c:if test="${uid != null }">
	<c:choose>
		<c:when test="${type == 'msg' }">
			<input type="text" name="msg" maxlength="100">
		</c:when>
		<c:when test="${type == 'rmsg' }">
	 		댓글달기<input type="text" name="rmsg" maxlength="50" size="60">
		</c:when>
	</c:choose>
</c:if>

<c:if test="${uid == null }">
	<c:choose>
		<c:when test="${type == 'msg' }">
			<input type="text" name="msg" maxlength="100" disabled="disabled" value="작성하려면 로그인 하세요!!!">
		</c:when>
		<c:when test="${type == 'rmsg' }">
	 		댓글달기 : <input type="text" name="rmsg" maxlength="50" size="60" disabled="disabled" value="작성하려면 로그인 하세요!!!">
		</c:when>
	</c:choose>
</c:if>