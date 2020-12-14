<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>
<script type="text/javascript">

	$(function() {

		$(document).ready(function(){
			//접수, 승인반려일 경우만 문서를 작성가능, 승인요청 버튼도 관리

			fnReportList('ifrReport', $('#hidDocId').val(), '00440','P_RC_NO='+$("#hidRcNo").val());
		});
	});

</script>

<form id="itivOutsetForm" name="itivOutsetForm" method="post">
	<input type="hidden" id="hidRcNo"	name="hidRcNo" 	value="${rcNo}">
	<input type="hidden" id="hidDocId"	name="hidDocId"	value="${docId}">
	<input type="hidden" id="docId"		value="${docId}">
	<div class="popup_body">
		<!--테이블 시작 -->
    	<div class="com_box mb_30">
      		<div class="tb_01_box">
	  			<table class="tb_03">
					<colgroup>
						<col width="150px">
						<col width="">
		  			</colgroup>
		  			<tbody>
			  			<tr>
				  			<th>접수번호</th>
				  			<td>${rcNo}</td>
			  			</tr>
		  			</tbody>
			  	</table>
			</div>
		</div>
		<!-- report관련 iframe -->
		<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="360px"></iframe>
	</div>
</form>
