<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!doctype html>
<html>
<head>
<title>코드 조회</title>

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

<form id="frmList" name="frmList" method="post">
<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
<div id="" class="popuparea_result_01" role="">
	<p class="popup_head">
		<a href="javascript:fnClose();"><span class="btn_close">닫기</span></a>
		<h4>이미지 조회</h4>
	</p>

	<div id="wrap_popuptable">
		<div id="popup_tablestyle">
			<table summary="" cellpadding="0" cellspacing="0" width="1100px">
			<caption>게시판 템플릿 목록</caption>
			<colgroup>
				<col style="width:550px;">
				<col style="width:550px;">
			</colgroup>
			<tbody>
			<c:if test="${fn:length(result) == 0}">
				<tr><td class="td_c" colspan="2">조회된 결과가 없습니다.</td></tr>
			</c:if>
			<tr>
			<c:forEach var="list" items="${result}" varStatus="status">
				<td class="td_line">
					<img src="<c:url value='/file/getImageBinary/'/>?file_id=${list.FILE_ID}&file_sn=${list.FILE_SN}" width="500px" height="400px">
					<div class="file">${list.FILE_DC}</p>
				</td>
				<c:if test="${(status.count % 2) == 0}">
					</tr>
					<tr>
				</c:if>
			</c:forEach>
			</tr>
			</tbody>
			</table>
		</div> 
	</div>
</div>
</form>
</body>
</html>