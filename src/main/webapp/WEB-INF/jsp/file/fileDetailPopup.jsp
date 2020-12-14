<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html>
<head>
<title>파일상세</title>

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
		<h4>파일 상세조회</h4>
	</p>

	<div id="wrap_popuptable">
		<div id="popup_tablestyle">
		 	<table width="950px" class="board" summary="" cellpadding="0" cellspacing="0" >
				<caption>게시판 템플릿 목록</caption>
				<colgroup>
					<col width="160px">
					<col width="px">
					<col width="160px">
					<col width="340px">
				</colgroup>
				<c:if test="${result.SYS_DIV eq '1'}">
				<tr>
					<th class="th_left">파일명</th>
					<td colspan="3">
						${result.FILE_DC}
					</td>
				</tr>
				<tr>
					<th class="th_left">원본 파일명</th>
					<td colspan="3">
						${result.FILE_NM}
					</td>
				</tr>
				<tr>
					<th class="th_left">저장된 파일명</th>
					<td>
						${result.SYS_FILE_NM}
					</td>
					<th class="th_left">파일용량</th>
					<td>
						<fmt:formatNumber value="${result.FILE_SIZE / 1024 / 1024}" pattern="0.00"/> mbyte(메가바이트)
					</td>
				</tr>
				</c:if>
				<tr>
					<th class="th_left">MD5 해시</th>
					<td colspan="3">
						${result.MD5_HASH}
					</td>
				</tr>
				<tr>
					<th class="th_left">MD5 1mb 해시</th>
					<td colspan="3">
						${result.MD5_PRTTN_HASH}
					</td>
				</tr>
				<tr>
					<th class="th_left">SHA256 해시</th>
					<td colspan="3">
						${result.SHA256_HASH}
					</td>
				</tr>
				<tr>
					<th class="th_left">SHA256 1mb 해시</th>
					<td colspan="3">
						${result.SHA256_PRTTN_HASH}
					</td>
				</tr>
				<tr>
					<th class="th_left">SHA1 해시</th>
					<td colspan="3">
						${result.SHA1_HASH}
					</td>
				</tr>
				<tr>
					<th class="th_left">SHA1 1mb 해시</th>
					<td colspan="3">
						${result.SHA1_PRTTN_HASH}
					</td>
				</tr>		
			</table>
			
			<c:if test="${result.ESNTL_ID != null}">
		 	<table width="950px" class="board" summary="" cellpadding="0" cellspacing="0" >
				<caption>게시판 템플릿 목록</caption>
				<colgroup>
					<col width="160px">
					<col width="px">
					<col width="160px">
					<col width="340px">
				</colgroup>
				<tr>
					<th class="th_left">관리번호</th>
					<td>
						${result.ESNTL_ID}
					</td>
					<th class="th_left">파일유형</th>
					<td>
					<c:choose>
						<c:when test="${result.FILE_TY eq 'V'}">
							동영상
						</c:when>
						<c:when test="${result.FILE_TY eq 'I'}">
							이미지
						</c:when>
					</c:choose>
					</td>
				</tr>
				<tr>
					<th class="th_left">전송일시</th>
					<td>
						${result.SNDNG_DT}
					</td>
					<th class="th_left">파일삭제여부</th>
					<td>
					<c:choose>
						<c:when test="${result.DELETE_AT eq 'Y'}">
							삭제완료
						</c:when>
						<c:otherwise>
							미삭제
						</c:otherwise>
					</c:choose>
					</td>
				</tr>
				<tr>
					<th class="th_left">고유 DNA 정보</th>
					<td colspan="3">
						${result.FILE_ESNTL_DNA}
					</td>
				</tr>
			</table>
			</c:if>
		</div> 
	</div>
</div>

</body>
</html>
