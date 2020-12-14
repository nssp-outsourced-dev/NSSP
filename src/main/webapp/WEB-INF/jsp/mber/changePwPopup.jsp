<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">

var myGridID;
	
	$(document).ready(function(){
        $('#txtUserPw').keyup(function () {
        	fnUserPwKeyup("txtUserPw", "divUserPw", "hidUserPw");
        });
	});

	function fnClose(){
		self.close();
	}


	function fnUpdate(){
		if(fnFormValueCheck("addForm")){
			if(!($('#hidUserPw').val() == "0")){
				alert("비밀번호를 정확하게 입력하세요.");
				return;
			}
			if(confirm("비밀번호를 변경하시겠습니까?")){
				var iUrl = '<c:url value='/member/changePwAjax/'/>';
		 		var queryString =  $('#addForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						alert("변경되었습니다.");
						self.close();
					}else if(data.result == "-3"){
		        		//이전 비밀번호 불일치
						alert("현재 비밀번호가 일치하지 않습니다.");
						$("#txtUserExPw").val("");
						$("#txtUserPw").val("");
						$("#divUserPw").html("");
						$("#hidUserPw").val("");
					}else if(data.result == "-4"){
		        		//이전, 변경 비밀번호 동일
						alert("신규 비밀번호는 현재 비밀번호와 동일할 수 없습니다.");
						$("#txtUserExPw").val("");
						$("#txtUserPw").val("");
						$("#divUserPw").html("");
						$("#hidUserPw").val("");
					}else{
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
			}
		}
	}
	
</script>

<!--팝업박스 -->
<div class="popup_body">
	<div class="title_s_st3 mt_10"><img src="/img/icon_error.png" alt=""/>  * 는 필수정보로서 반드시 입력하여야 합니다.</div>

	<form id="addForm" name="addForm" method="post">
	<!--테이블 시작 -->
	<div class="tb_01_box">
		<table  class="tb_01">
			<col width="30%"/>
			<col width=""/>
			<tbody>
			<tr>
				<th>현재 비밀번호<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<input type="password" id=txtUserExPw name="txtUserExPw" maxlength="20"  class="w_150px input_com " check="text" checkName="현재 비밀번호">
				</td>
			</tr>
			<tr>
				<th>신규 비밀번호<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<input type="hidden" id="hidUserPw" name="hidUserRePw" value="1">	
					<input type="password" id="txtUserPw" name="txtUserPw" maxlength="20" class="w_150px input_com " check="text" checkName="신규 비밀번호">
					<div id="divUserPw" style="display:inline;"></div>
				</td>
			</tr>
		</tbody>
		</table>
	</div>
	<div class="com_box  t_center mt_10">
		<div class="btn_box">
			<input type="button" id="btnUpdate" value="수정" class="btn_st2 icon_n" onclick="fnUpdate();">
		</div>
	</div>
	</form>
<!--팝업박스 -->
</div>