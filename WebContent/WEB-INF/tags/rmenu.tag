<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="rid" %>
<%@ attribute name="ruid" %>
<%@ attribute name="curmsg" %>

<!-- 현재 사용자 id와 댓글 작성자 id가 같으면 댓글 삭제 버튼 활성화 -->
<c:if test="${uid == ruid }">
[<a href="words_control.jsp?action=delreply&rid=${rid }&curmsg=${curmsg }cnt=${cnt}&suid=${suid }">삭제</a>]
</c:if>