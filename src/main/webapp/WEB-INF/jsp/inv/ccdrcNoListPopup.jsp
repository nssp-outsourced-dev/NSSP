<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">
	function fnPick() {
		if(fnIsEmpty($("#selCcdrcNo").val())) {
			alert("압수번호를 선택하세요");
			return;
		}
		parent.ccdrNoListPop.hide();		
		/*
		var caseNo = $("#hidCaseNo", opener.document).val();
		opener.document.getElementById("form_detail").reset();
		//$("#form_detail", opener.document).reset();
		$("#hidCaseNo", opener.document).val(caseNo);
		$("#hidCcdrcNo", opener.document).val($("#selCcdrcNo").val());
		window.self.close();
		*/
	}
</script>

<body>
<div class="popup_body">
	<div class="popup_search_box mb_20">
		<div class="search_in">
			<div class="stitle w_80px ">압수번호</div>
			<div class="r_box">
				<select name="selCcdrcNo" id="selCcdrcNo" class="w_100p" style="width:150px">
					<c:forEach var="list" items="${ccdrcNoList}">
						<option value="${list.CCDRC_NO}|${list.DOC_ID}"><c:out value="${list.CCDRC_NO}" /></option>
					</c:forEach>
				</select>
			</div>
		</div>
	</div>
	<div class="com_box ">
		<div class="fr t_right">
			<input type="button" name="input_button" value="압수번호 선택" class="btn_st4 icon_n" onclick="fnPick();">
		</div>
	</div>
</div>
</body>
</html>
