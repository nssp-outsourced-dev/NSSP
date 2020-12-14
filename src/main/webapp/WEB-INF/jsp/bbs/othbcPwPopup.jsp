<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">

var myGridID;
	
	$(document).ready(function(){
		$("#txtOthbcPw").focus();
	});

	function fnSelect() {
		parent.othbcPwPopup.hide();
	}

</script>

<!--팝업박스 -->
<div class="popup_body">
	<form id="addForm" name="addForm" method="post">
	<!--테이블 시작 -->
	<div class="tb_01_box">
		<table  class="tb_01">
			<col width="30%"/>
			<col width=""/>
			<tbody>
			<tr>
				<th>비공개 비밀번호</th>
				<td>
					<input type="password" id=txtOthbcPw name="txtOthbcPw" maxlength="20"  class="w_150px input_com " check="text" checkName="비밀글 비밀번호">
				</td>
			</tr>
		</tbody>
		</table>
	</div>
	<div class="com_box  t_center mt_10">
		<div class="btn_box">
			<input type="button" id="btnUpdate" value="완료" class="btn_st2 icon_n" onclick="fnSelect();">
		</div>
	</div>
	</form>
<!--팝업박스 -->
</div>