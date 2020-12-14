<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%
	pageContext.setAttribute("cr", "\r"); //Space
	pageContext.setAttribute("cn", "\n"); //Enter
	pageContext.setAttribute("crcn", "\r\n"); //Space, Enter
	pageContext.setAttribute("br", "<br/>"); //br 태그
%>
<!doctype html>
<html>
<head>
<title>알림설정</title>

<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>

<script type="text/javascript" src="/js/jquery-1.11.1.js"></script>
<script type="text/javascript" src="/js/jquery-ui.js"></script>
<script type="text/javascript" src="/js/jquery.blockUI.js"></script>

<script type="text/javascript" src="/js/cubox.js"></script>
<script type="text/javascript">	
	function fnClose(){
		self.close();
	}
</script>
</head>
<body>

<div id="" class="popuparea_result_01" role="">
	<p class="popup_head">
		<a href="javascript:fnClose();"><span class="btn_close">닫기</span></a>
		<h4>공지사항</h4>
	</p>

	<div id="wrap_popuptable">
		<div id="popup_tablestyle">
		 	<table width="750px" class="board" summary="" cellpadding="0" cellspacing="0" >
				<caption>게시판 템플릿 목록</caption>
				<colgroup>
				<col width="160px">
				<col width="px">
				<col width="160px">
				<col width="340px">
				</colgroup>
		
				<tr class="border_bottom_b">
					<th class="th_left">제목</th>
					<td colspan="3">
						${result.NTT_SJ}
					</td>
				</tr>
				<tr height="150" class="border_bottom_b">
					<th class="th_left">내용</th>
					<td colspan="3">
						<c:out escapeXml="false" value="${fn:replace(result.NTT_CN,crcn,br)}"/>
					</td>
				</tr>
				<tr class="border_bottom_b">
					<th class="th_left">첨부파일</th>
					<td  colspan="3">
					<iframe id="ifrFile" src="<c:url value='/file/fileListIframe/'/>?ifr_id=ifrFile&file_id=${result.FILE_ID}" scrolling="no" frameborder="0" width="100%" height="0px"></iframe>
					</td>
				</tr>
			</table>
		</div> 
	</div>
</div>
</form>
</body>
</html>
