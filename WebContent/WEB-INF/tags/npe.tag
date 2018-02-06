<%@ tag pageEncoding="UTF-8" body-content="scriptless"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<!-- request객체나 session객체에 저장된 변수는 별도 처리 없이 표현언어로 접근 가능
		단, 표현언어는 java 스크립트릿 영역에서는 쓸 수 없음 -->

<c:choose>
	<c:when test="${pageContext.errorData.throwable == 'java.lang.NullPointerException' }">
		<p>아이디가 존재하지 않습니다.</p>
	</c:when>
	
	<c:otherwise>
		<p>관리자(bettertoday@gmail.com)에게 문의주세요.<br> 빠른 시일내에 해결하겠습니다.
			<br><br>${now} </p>
		<p>
			요청 실패 URI: ${pageContext.errorData.requestURI }<br> 상태코드:
			${pageContext.errorData.statusCode}<br> 예외유형:
			${pageContext.errorData.throwable}<br>
	</c:otherwise>
</c:choose>
