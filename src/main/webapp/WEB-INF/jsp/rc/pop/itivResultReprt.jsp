<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>
<script type="text/javascript">

	$(function() {

		$(document).ready(function(){

			//접수, 승인반려일 경우만 문서를 작성가능, 승인요청 버튼도 관리
			//작성용
				fnReportList('ifrReport', $('#hidItivResultDocId').val(), '00444','P_RC_NO='+$("#hidRcNo").val(), $("#hidItivResultFileId").val());

			/* 보기만 가능할 겨우 제공
			if( "00211" == $("#hidProgrsSttusCd").val() || "00217" == $("#hidProgrsSttusCd").val() ){
				//작성용
				fnReportList('ifrReport', $('#hidItivResultDocId').val(), '00444','P_RC_NO='+$("#hidRcNo").val());
			} else {
				//조회용
				fnReportListView('ifrReport', $('#hidItivResultDocId').val());
			} */

			/* 
			 20200720 # 처리 사건변경 역순일 경우
			if( null != $("#hidItivResultCd").val() && 5 == $("#hidItivResultCd").val().length ){
				$("#btnConfmRequest").css('display', 'none');
			} */

			/* Checkbox change event */
			$('input[name="rdoCaseEndSeChangeCd"]').change(function() {

		        var value = $(this).val();              // value

		        if( "00381" == value ){		   //정식사건
		        	$("#selItivEndDspsCd").val("00601").prop("selected", true);
		        	$("#selItivEndDspsCd").attr("disabled","disabled");
		        } else if( "00384" == value ){ //내사중지
		        	$("#selItivEndDspsCd").val("00605").prop("selected", true);
		        	$("#selItivEndDspsCd").attr("disabled","disabled");
		        } else {
		        	$("#selItivEndDspsCd").val("").prop("selected", true);
		        	$("#selItivEndDspsCd").removeAttr("disabled");
		        }
			});


		});

		$("#btnConfmRequest").click(function(){

			if( "Y" != $("#hidOutsetReportYN").val() ){
				alert("내사착수보고가 완료되지 않았습니다.\n내사착수보고 후 다시 진행해주세요.");
				return false;
			}

			if( "" == $("#selItivEndDspsCd option:selected").val() ){
				alert("내사 종결 처분 코드를 선택해주세요");
				$("#selItivEndDspsCd").focus();
				return false;
			}

			/* if( $("#txtItivCn").val().length < 6 ){
				alert("사유는 5자 이상 입력해주세요");
				$("#txtItivCn").focus();
				return false;
			}   */


			var rowCnt = ifrReport.AUIGrid.getRowCount("#grid_list");
			var checkDoc006Cnt = 0; //내사결과보고서 유뮤 확인
			var formatId = "";
			var   fileNm = "";

			if( rowCnt > 0 ){
				for( var i = 0; i < rowCnt; i++ ){
					formatId = ifrReport.AUIGrid.getCellValue("#grid_list", i, "FORMAT_ID");
					  fileNm = ifrReport.AUIGrid.getCellValue("#grid_list", i, "FILE_NM");

					//임시 사건결과보고서
					if( "00000000000000000006" == formatId ){
						if( null != fileNm && String(fileNm).length > 0 ){
							checkDoc006Cnt++;
						}
					}
				}//end for
			}

			if( checkDoc006Cnt < 1 ){
				alert("내사결과보고서를 작성하지 않았습니다.\n작성 후 다시 진행해주세요");
				return false;
			}

			$("#selItivEndDspsCd").removeAttr("disabled");

			var processAfterGet = function(data) {

				if( data > 0 ){
					alert("내사결과보고가 완료되었습니다.");
					parent.itivResultReprtPopup.hide();

					parent.fnMoveGridPage("/rc/getCaseListAjax/", "frmList", parent.caseGridId, $("#hidPage", parent.document.body).val());
				}
			}

			Ajax.getJson("<c:url value='/rc/reprtConfmRequestAjax/'/>", $('#itivResultForm').serialize(), processAfterGet);
		});
	});

</script>

<form id="itivResultForm" name=itivResultForm method="post">
	<input type="hidden" id="hidRcNo" 			  name="hidRcNo" 			 value="${rcNo}">
	<input type="hidden" id="hidItivNo" 		  name="hidItivNo" 			 value="${itivNo}">
	<input type="hidden" id="hidProgrsSttusCd" 	  name="hidProgrsSttusCd" 	 value="${progrsSttusCd}">
	<input type="hidden" id="hidItivResultFileId" name="hidItivResultFileId" value="${fileId}">
	<input type="hidden" id="hidItivResultDocId"  name="hidItivResultDocId"  value="${docId}">			 <!-- 내사착수승인 문서ID -->
	<input type="hidden" id="hidReprtSe"		  name="hidReprtSe" 		 value="IRR">				 <!-- 보고서 구분 코드 -->
	<input type="hidden" id="hidOutsetReportYN"	  name="hidOutsetReportYN" 	 value="${outsetReportYN}">  <!-- 내사착수여부 -->
	<input type="hidden" id="hidItivResultCd"	  name="hidItivResultCd" 	 value="${itivResultInfo.ITIV_RESULT_CD}">	<!-- 내사결과코드-->
	<div class="popup_body"  style="padding-top: 5px;">
		<!--버튼 -->
    	<div class="com_box  t_right">
			<div class="btn_box">
			<c:choose>
	  			<c:when test="${progrsSttusCd eq '02103' || progrsSttusCd eq '02132' || progrsSttusCd eq '02143'}">
				<input type="button" id="btnConfmRequest" name="btnSave" value="내사결과보고 완료" class="btn_st3 icon_n fl ">
				</c:when>
				<c:when test="${progrsSttusCd eq '02121'}">
						사건 구분변경 요청 중입니다.
				</c:when>
				<c:otherwise>
				</c:otherwise>
			</c:choose>						
				
    		</div>
		</div>
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
			  			<tr class="h_40px">
				  			<th>내사번호</th>
				  			<td>${itivNo}</td>
			  			</tr>
			  		<c:choose>
	  					<c:when test="${progrsSttusCd eq '02103' || progrsSttusCd eq '02132' || progrsSttusCd eq '02143'}">
						<tr class="h_40px">
				  			<th>구분</th>
				  			<td>
				  				<div class="input_radio2 t_left">
					            	<input class="to-labelauty-icon labelauty" type="radio" name="rdoCaseEndSeChangeCd" value="00383"	id="labelauty-779792" checked="" style="display: none;">
					            	<label for="labelauty-779792"><span class="labelauty-unchecked-image">
					            	</span><span class="labelauty-checked-image"></span>
					            	</label>
					            	내사종결
					           	</div>
					            <div class="input_radio2 t_left">
					            	<input class="to-labelauty-icon labelauty" type="radio" name="rdoCaseEndSeChangeCd"  value="00384"	id="labelauty-549595" style="display: none;"><label for="labelauty-549595"><span class="labelauty-unchecked-image"></span><span class="labelauty-checked-image"></span>
					            	</label>
					            	내사중지
					            </div>
					        <!-- 2020.07.24 [내사종결 - 입건]으로 통합  
					           <div class="input_radio2 t_left">
					            	<input class="to-labelauty-icon labelauty" type="radio" name="rdoCaseEndSeChangeCd"  value="00381"	id="labelauty-660266" style="display: none;"><label for="labelauty-660266"><span class="labelauty-unchecked-image"></span><span class="labelauty-checked-image"></span>
					            	</label>
					            	정식사건
					           	</div> 
					        -->
							</td>
			  			</tr>
						<tr class="h_40px">
		  					<th>내사 종결 처분코드</th>
		  					<td>
		  						<select id="selItivEndDspsCd"	name="selItivEndDspsCd" size="1" class="input_com" style="width: 112px;">
					          		<option value="" selected="selected">=선택=</option>
					          		<c:forEach var="cd" items="${itivEndDspsCdList}">
										<option value="${cd.cd}" <c:if test="${cd.cdNm eq itivResultInfo.grdEtcTelFront}">selected</c:if> ><c:out value="${cd.cdNm}" /></option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr class="h_40px">
		  					<th>사유</th>
		  					<td><input type="text" id="txtItivCn" name="txtItivCn"   maxlength="50" size="50"></td>
	  					</tr>
						</c:when>
						<c:otherwise>
	  					<tr class="h_40px">
				  			<th>구분</th>
		  					<td>${itivResultInfo.ITIV_RESULT_NM}</td>
				  		</tr>
		  				<tr class="h_40px">
		  					<th>보고일자</th>
		  					<td>${itivResultInfo.ITIV_RESULT_REPORT_DT}</td>
		  				</tr>
						<tr class="h_40px">
				  			<th>사유</th>
				  			<td>${itivResultInfo.ITIV_CN}</td>
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
				height="280px"
			</c:when>
			<c:otherwise>
				height="310px"
			</c:otherwise>
		</c:choose>></iframe>
	</div>
</form>
