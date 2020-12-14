<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/inc/header.jsp"/>

<style>
</style>

<script type="text/javascript" src="/js/rc.common.js"></script>
<script type="text/javascript">
	$(function() {

		$(document).ready(function(){

		});
	})
	function fnSave(){
		alert(123456777);
		//document.getElementById('addForm').submit();
		var processAfterGet = function(data) {
 			if(!fnIsEmpty(data.result)) {
 				if(data.result == "1") {
 					//새로고침 - 메인으로
 					alert("완료!!");
 				} else if (data.result == "-1") {
 					alert("오류");
 				}
 			}
	    };
		Ajax.getJson("<c:url value='/member/faceLoginAjax/'/>", "", processAfterGet);
		alert(456789);
	}
</script>

<form id="addForm" name="addForm">
	<table width="1000px" class="board" summary="" cellpadding="0" cellspacing="0" >
		<caption>게시판 템플릿 목록</caption>
		<colgroup>
		<col width="160px">
		<col width="px">
		<col width="160px">
		<col width="380px">
		</colgroup>

		<tr class="border_bottom_b">
			<th class="th_left" rowspan="2">증거자료<br>(화면캡처)<span class="star">*</span></th>
			<td colspan="3">
				<p class="dot">사용가능한 확장자 : <c:forEach var="format" items="${formatList}" varStatus="status">${format}<c:if test="${!status.last}">, </c:if></c:forEach></p>
				<input type="file" id="txtFile" name="txtFile" class="add_file" style="width:350px;">
				<div id="fileList" class="file"></div>
			</td>
		</tr>
	</table>

	<p class="btn_area">
		<input type="button" value="저장" class="btn" onclick="fnSave();">
	</p>
</form>

