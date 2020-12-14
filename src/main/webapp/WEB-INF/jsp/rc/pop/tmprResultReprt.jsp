<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>
<script type="text/javascript">

	$(function() {

		$(document).ready(function(){

			//접수, 승인반려일 경우만 문서를 작성가능, 승인요청 버튼도 관리
			fnReportList('ifrReport', $('#hidTmprResultDocId').val(), '00431','P_RC_NO='+$('#hidRcNo').val(), $("#hidTmprResultFildId").val());

			/*
			if( "T" == $("#hidRcSeCd").val() && ( "02103" == $("#hidProgrsSttusCd").val() || "02132" == $("#hidProgrsSttusCd").val()|| "02143" == $("#hidProgrsSttusCd").val()) ){
				alert(1);
				//작성용
				fnReportList('ifrReport', $('"#hidTmprResultDocId"').val(), '00431','P_RC_NO='+$("#hidRcNo").val());
			} else {
				alert(2);
				//조회용
				fnReportListView('ifrReport', $('#hidTmprResultDocId').val());
			}
			*/
		});


		/* Checkbox change event */
		$('input[name="rdoCaseEndSeChangeCd"]').change(function() {
		        var value = $(this).val();              // value

		        if( "00381" == value ){
		        	$("#selTmprEndDspsCd").val("00601").prop("selected", true);
		        	$("#selTmprEndDspsCd").attr("disabled","disabled");
		        } else {
		        	$("#selTmprEndDspsCd").removeAttr("disabled");
		        }
		});


		$("#btnConfmRequest").click(function(){

			if( "" == $("#selTmprEndDspsCd option:selected").val() ){
				alert("임시 종결 처분 코드를 선택해주세요");
				$("#selTmprEndDspsCd").focus();
				return false;
			}

			
			//임시사건 종결인 경우 사건결과보고서 작성확인
			var rowCnt = ifrReport.AUIGrid.getRowCount("#grid_list");
			var checkDoc202Cnt = 0; //사건결과보고서 유뮤 확인
			var formatId = "";
			var   fileNm = "";

			if( rowCnt > 0 ){
				for( var i = 0; i < rowCnt; i++ ){
					formatId = ifrReport.AUIGrid.getCellValue("#grid_list", i, "FORMAT_ID");
					  fileNm = ifrReport.AUIGrid.getCellValue("#grid_list", i, "FILE_NM");

					//임시 사건결과보고서
					if( "00000000000000000202" == formatId ){
						if( null != fileNm && String(fileNm).length > 0 ){
							checkDoc202Cnt++;
						}
					}
				}//end for
			}

			if( checkDoc202Cnt < 1 ){
				alert("사건결과보고서를 작성하지 않았습니다.\n작성 후 다시 진행해주세요");
				return false;
			}

			$("#selTmprEndDspsCd").removeAttr("disabled");

			var processAfterGet = function(data) {

				if( data > 0 ){
					alert("임시결과보고가 완료되었습니다.");
					parent.tmprResultReprtPopup.hide();

					parent.fnMoveGridPage("/rc/getCaseListAjax/", "frmList", parent.caseGridId, $("#hidPage", parent.document.body).val());
				}
			}

			Ajax.getJson("<c:url value='/rc/reprtConfmRequestAjax/'/>", $('#tmprResultForm').serialize(), processAfterGet);
		});
	});


</script>

<form id="tmprResultForm" name=tmprResultForm method="post">

	<input type="hidden" id="hidRcNo" 			  name="hidRcNo" 			 value="${rcNo}">
	<input type="hidden" id="hidTmprNo" 		  name="hidTmprNo" 			 value="${tmprNo}">
	<input type="hidden" id="hidProgrsSttusCd" 	  name="hidProgrsSttusCd" 	 value="${progrsSttusCd}">
	<input type="hidden" id="hidTmprResultDocId"  name="hidTmprResultDocId"  value="${docId}">				 <!-- 사건 문서 ID  -->
	<input type="hidden" id="hidTmprResultFildId" name="hidTmprResultFildId" value="${fileId}">
	<input type="hidden" id="hidRcSeCd"			  name="hidRcSeCd" 			 value="${tmrpCaseInfo.RC_SE_CD}"><!-- 사건 구분 코드   -->
	<input type="hidden" id="hidReprtSe"		  name="hidReprtSe" 		 value="TRR">					 <!-- 보고서 구분 코드 -->

	<div class="popup_body"  style="padding-top: 10px;">
		<c:if test="${progrsSttusCd eq '02103' || progrsSttusCd eq '02132' || progrsSttusCd eq '02143'}">
		<!--버튼 -->
    	<div class="com_box  t_right ">
			<div class="btn_box">
				<input type="button" id="btnConfmRequest"  value="보고완료" class="btn_st3 icon_n fl ">
    		</div>
		</div>
		</c:if>
		<!--//버튼  -->
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
				  			<th>임시번호</th>
				  			<td>${tmprNo}</td>
			  			</tr>
					<c:choose>
	  					<c:when test="${progrsSttusCd eq '02103' || progrsSttusCd eq '02132' || progrsSttusCd eq '02143'}">
						<tr>
				  			<th>구분</th>
				  			<td>
				  				<div class="input_radio2 t_left">
					            	<input class="to-labelauty-icon labelauty" type="radio" name="rdoCaseEndSeChangeCd" value="00385"checked id="labelauty-779792" style="display: none;">
					            	<label for="labelauty-779792">
					            		<span class="labelauty-unchecked-image"></span>
					            		<span class="labelauty-checked-image"></span>
					            	</label>
					            	사건종결
					           	</div>
					            <div class="input_radio2 t_left">
					            	<input class="to-labelauty-icon labelauty" type="radio" name="rdoCaseEndSeChangeCd"  value="00382"	id="labelauty-549595" style="display: none;">
					            	<label for="labelauty-549595">
					            		<span class="labelauty-unchecked-image"></span>
					            		<span class="labelauty-checked-image"></span>
					            	</label>
					            	내사사건
					            </div>
					         <!-- 2020.07.24 [임시종결 - 입건]으로 통합   
					            <div class="input_radio2 t_left">
					            	<input class="to-labelauty-icon labelauty" type="radio" name="rdoCaseEndSeChangeCd"  value="00381"	id="labelauty-660266" style="display: none;">
					            	<label for="labelauty-660266">
					            		<span class="labelauty-unchecked-image"></span>
					            		<span class="labelauty-checked-image"></span>
					            	</label>
					            	정식사건
					           	</div> 
					        -->
							</td>
			  			</tr>
			  			<tr>
		  					<th>임시 종결 처분코드</th>
		  					<td>
		  						<select id="selTmprEndDspsCd"	name="selTmprEndDspsCd" size="1" class="input_com" style="width: 112px;">
					          		<option value="" selected="selected">=선택=</option>
					          		<c:forEach var="cd" items="${tmprEndDspsCdList}">
										<option value="${cd.cd}" ><c:out value="${cd.cdNm}" /></option>
									</c:forEach>
								</select>
							</td>
						</tr>
		  				</c:when>
						<c:otherwise>
		  				<tr>
		  					<th>보고일자</th>
		  					<td>${tmrpCaseInfo.TMPR_CASE_RESULT_REPORT_DT}</td>
		  				</tr>
							<tr>
				  			<th>구분</th>
		  					<td>${tmrpCaseInfo.CASE_END_SE_CHANGE_CD}</td>
				  		</tr>
							<tr>
				  			<th>처분결과</th>
		  					<td>${tmrpCaseInfo.ED_DSPS_CD}</td>
				  		</tr>
						</c:otherwise>
	  				</c:choose>
		  			</tbody>
			  	</table>
			</div>
		</div>

		<!-- report관련 iframe -->
		<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;"
			<c:choose>
			<c:when test="${progrsSttusCd eq '02103' || progrsSttusCd eq '02132' || progrsSttusCd eq '02143'}">
				height="320px"
			</c:when>
			<c:otherwise>
				height="340px"
			</c:otherwise>
		</c:choose>></iframe>
	</div>
</form>
