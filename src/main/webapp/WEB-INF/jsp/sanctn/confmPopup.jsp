<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">	
	$(function() {
		$(document).ready(function(){
			
			if( $("#cnt").val() > 0 ){
				$("#divText").text("승인");
				$("#divReturn").css("display", "none");
			} else {
				$("#divText").text("승인/반려");
			}
		});
	})

	function fnClose(){
		parent.sanctnConfmPopup.hide();
	}

	function fnAdd(){
		
		if( fnFormValueCheck("addForm") ){
			if( confirm("승인/반려 처리를 진행하시겠습니까?") ){
				var iUrl = '<c:url value='/sanctn/confmAjax/'/>';
		 		var queryString =  $('#addForm').serialize();
		 		var processAfterGet = function(data) {
					if( data.result == "1" ){
						fnClose();
					} else {
						alert("처리중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
            }
		}
	}

</script>

<!--팝업박스 -->
<div class="popup_body">
	<form id="addForm" name="addForm" method="post">
		<input type="hidden" id="cate" 	name="cate"  value="${cate}">	
		<input type="hidden" id="chkId" name="chkId" value="${chkId}">	
		<input type="hidden" id="cnt" 	name="cnt" 	 value="${cnt}">	
		<!--테이블 시작 -->
		<div class="tb_01_box">
			<table class="tb_01">
				<col width="15%"/>
				<col width=""/>
				<tbody>
				<tr>
					<th><div id="divText"></div></th>
					<td>
						<div class='input_radio2 t_left' >
							<input class="to-labelauty-icon" type="radio" name="rdoSttusCd" value="${sttus_sanctn_compt}" <c:if test="${sttusCd eq sttus_sanctn_compt}">checked</c:if>/>승인
						</div>
						<div class='input_radio2 t_left' id="divReturn">
							<input class="to-labelauty-icon" type="radio" name="rdoSttusCd" value="${sttus_sanctn_return}" <c:if test="${sttusCd eq sttus_sanctn_return}">checked</c:if>/>반려
						</div>
					</td>
				</tr>
				<tr>
					<th>결정사유</th>
					<td>
						<textarea id="txtConfmDc" name="txtConfmDc" style="width:100%;height:150px;"></textarea>
					</td>
				</tr>
			</tbody>
			</table>
	
		</div>
		<div class="com_box  t_center mt_10">
			<div class="btn_box">
				<input type="button" id="btnUpdate" value="완료" class="btn_st2 icon_n" onclick="fnAdd();">
			</div>
		</div>
	</form>
<!--팝업박스 -->
</div>