<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 	uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" 	uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" 	uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>
<script type="text/javascript">

	$(function() {

		$(document).ready(function(){

            fnReportList('ifrReport', $('#docId').val(), '00456','P_RC_NO='+$("#hidRcNo").val(), $("#fileId").val());
		  
          	/* 	
		    if( "F" != $("#rcSeCd").val() && ( "02103" != $("#hidProgrsSttusCd").val() || "02104" != $("#hidProgrsSttusCd").val() ) ){
				//서식분류 00456 - 사건인지/결정
				fnReportList('ifrReport', $('#docId').val(), '00456','P_RC_NO='+$("#hidRcNo").val());
			} 
		   	*/
			
			
			/* 
			 * 20200715  범죄인지보고 오픈시 사건번호 생성처리 프로세스 중지

			if( "F" == $("#rcSeCd").val() && "00381" == $("#hidCaseEndSeChangeCd").val()  && ("" == $("#hidCaseNo").val()||null == $("#hidCaseNo").val()) ){
				var param = {
						"rcNo" : $("#hidRcNo").val()
			    	, "rcSeCd" : $("#rcSeCd").val()
			 , "progrsSttusCd" : $("#hidProgrsSttusCd").val()
			    , "changeSeCd" : "F"
			, "changeProgrsCd" : "02131"
			  , "confmJobSeCd" : "01383"
			      , "sanctnId" : $("#hidSanctnId").val()
					};

				var processAfterGet = function(data) {

					if( data == "0" ){
						alert("신청이 완료되었습니다.");
						//parent.crmnlRecognitionPopup.hide();
						parent.fnMoveGridPage("/rc/getCaseListAjax/", "frmList", parent.caseGridId, $("#hidPage", parent.document.body).val() );
					} else {
						alert("신청 중 오류가 발생하였습니다.");
					}
				};
				
				Ajax.getJson('<c:url value='/rc/updateCaseSttusToGetCaseNo/'/>', param, processAfterGet);

			}

 */
		});

		//범죄인지보고 버튼 클릭
		$("#btnConfmRequest").click(function(){

		 	var possibleSttusCd = "";

			if( "F" == $("#rcSeCd").val() ){

				/* 기존 임시사건 내사사건 처리 validate
				if( "T" == $("#rcSeCd").val() ){
					possibleSttusCd = "02111";
				} else if( "I" ==$("#rcSeCd").val() ){
					possibleSttusCd = "02113";
				}
				*/

				//범죄인지보고가 가능한 진행상태 - 임시종결 :02111 / 내사종결 :02113 / 사건구분변경반려 : 02132 / 사건삭제 반려 : 02143
				if( "00381" == $("#hidCaseEndSeChangeCd").val() ){

					var rowCnt = ifrReport.AUIGrid.getRowCount("#grid_list");
					var checkDoc007Cnt = 0;
					var checkDoc008Cnt = 0;
					var formatId = "";
					var fileNm = "";

					if( rowCnt > 0 ){

						for( var i = 0; i < rowCnt; i++ ){
							formatId = ifrReport.AUIGrid.getCellValue("#grid_list", i, "FORMAT_ID");
							  fileNm = ifrReport.AUIGrid.getCellValue("#grid_list", i, "FILE_NM");
						}
					}


					if( checkDoc008Cnt < 1 ){
						alert("범죄인지보고서를 작성하지 않았습니다.\n작성 후 다시 진행해주세요");
						return false;
					}

					if( checkDoc007Cnt < 1 ){
						alert("범죄인지서를 확인하지 않았습니다.\n확인 후 다시 진행해주세요");
						return false;
					}

					if(confirm("범죄인지보고를 완료하시겠습니까?")){

						var param = {
								"rcNo" : $("#hidRcNo").val()
					    	, "rcSeCd" : $("#rcSeCd").val()
					 , "progrsSttusCd" : $("#hidProgrsSttusCd").val()
					    , "changeSeCd" : "F"
					, "changeProgrsCd" : "02131"
					  , "confmJobSeCd" : "01383"
					      , "sanctnId" : $("#hidSanctnId").val()
							};

						var processAfterGet = function(data) {

							if( data == "0" ){
								alert("신청이 완료되었습니다.");
								parent.crmnlRecognitionPopup.hide();
								parent.fnMoveGridPage("/rc/getCaseListAjax/", "frmList", parent.caseGridId, $("#hidPage", parent.document.body).val() );
							} else {
								alert("신청 중 오류가 발생하였습니다.");
							}
						};
						Ajax.getJson('<c:url value='/rc/updateCaseSttusToGetCaseNo/'/>', param, processAfterGet);
					} else {
						alert("취소되었습니다.");
					}


				} else {
					alert("범죄인지보고는 사건종결 후 진행이 가능합니다.\n확인 후 다시 진행해주세요.");
				}

			} else {

			}
		});
	});

</script>

<form id="caseRequestForm" name=caseRequestForm method="post">

	<input type="hidden" id="hidRcNo" 			name="hidRcNo" 			value="${rcNo}">		 <!-- 접수번호 -->
	<input type="hidden" id="hidCaseNo"			name="hidCaseNo" 		value="${caseInfo.CASE_NO}">		<!-- 문서ID -->
	<input type="hidden" id="rcSeCd"			name="rcSeCd" 			value="${rcSeCd}">		 <!-- 사건구분 -->
	<input type="hidden" id="hidProgrsSttusCd" 	name="hidProgrsSttusCd"	value="${progrsSttusCd}"><!-- 진행상태-->
	<input type="hidden" id="hidTmprNo" 		name="hidTmprNo" 		value="${caseInfo.TMPR_NO}">	<!-- 내사번호 -->
	<input type="hidden" id="hidSanctnId"		name="hidSanctnId" 		value="${caseInfo.SANCTN_ID}">	<!-- 결재ID -->
	<input type="hidden" id="docId"				name="docId" 			value="${caseInfo.DOC_ID}">		<!-- 문서ID -->
	<input type="hidden" id="hidCaseEndSeChangeCd"	name="hidCaseEndSeChangeCd" value="${caseInfo.CASE_END_SE_CHANGE_CD}">	<!-- 문서ID -->
	<input type="hidden" id="fileId"			name="fileId" 			value="${caseInfo.FILE_ID}">	<!-- fileId -->

	<div class="popup_body" style="padding-top: 10px;">
	<!--버튼 -->
	<!--
	<c:choose>
		<c:when test="${ '02103' eq progrsSttusCd && (null eq caseInfo.CASE_NO || '' eq caseInfo.CASE_NO) }" >
    	<div class="com_box  t_right">
			<div class="btn_box">
				<input type="button" id="btnConfmRequest" name="btnSave" value="범죄인지보고 작성완료" class="btn_st3 icon_n fl ">
    		</div>
		</div>
		</c:when>
		<c:otherwise>
		<div style="padding-bottom: 5px;">
		 	 ※범죄인지가 완료된 사건입니다
		</div>
		</c:otherwise>
	</c:choose>
	-->
		<!--//버튼  -->
		<!--테이블 시작 -->
		<div class="com_box mb_30">
      		<div class="tb_01_box">
	  			<table class="tb_03">
					<colgroup>
						<col width="150px">
						<col width="">
						<col width="150px">
						<col width="">
		  			</colgroup>
		  			<tbody>
			  			<tr class="h_40px">
							<th>접수번호</th>
				  			<td colspan="3">${rcNo}</td>
							<c:if test="${ null ne caseInfo.TMPR_NO && '' ne caseInfo.TMPR_NO }">
			  			</tr>
			  			<tr class="h_40px">
				  			<th>임시번호</th>
				  			<td colspan="3">${caseInfo.TMPR_NO}</td>
			  				</c:if>
			  				<c:if test="${ null ne caseInfo.ITIV_NO && '' ne caseInfo.ITIV_NO }">
			  			</tr>
		  				<tr class="h_40px">
				  			<th>내사번호</th>
				  			<td colspan="3">${caseInfo.ITIV_NO}</td>
			  				</c:if>
			  			</tr>
		  			</tbody>
			  	</table>
			</div>
		</div>

		<!-- report관련 iframe -->
		<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;"
			<c:choose>
			<c:when test="${ null ne caseInfo.TMPR_NO && '' ne caseInfo.TMPR_NO && null ne caseInfo.ITIV_NO && '' ne caseInfo.ITIV_NO }">
				height="370px"
			</c:when>
			<c:when test="${ (null ne caseInfo.TMPR_NO && '' ne caseInfo.TMPR_NO) || (null ne caseInfo.ITIV_NO && '' ne caseInfo.ITIV_NO) }">
				height="400px"
			</c:when>
			<c:otherwise>
				height="430px"
			</c:otherwise>
		</c:choose>></iframe>
	</div>
</form>
