<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ attribute name="mid"%>
<%@ attribute name="auid"%>
<%@ attribute name="curmsg"%>

<c:if test="${uid == auid }">
	<!-- 현재 사용자가 메시지의 작성자이면 삭제 버튼 활성화 -->
[<a
		href="words_control.jsp?action=delmsg&mid=${mid }&curmsg=${curmsg }&cnt=${cnt }&suid=${suid }">삭제</a>]
</c:if>


<c:if test="${uid != auid }">
	<!-- 현재 사용자가 메시지의 작성자가 아니면 좋아요 버튼 활성화 -->
[<a href="words_control.jsp?action=fav&mid=${mid }&curmsg=${curmsg }&cnt=${cnt }&suid=${suid }">좋아요</a>]
</c:if>
