<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>
<script type="text/javascript">

	$(function() {

		$(document).ready(function(){

			//접수, 승인반려일 경우만 문서를 작성가능, 승인요청 버튼도 관리
			fnReportList('ifrReport', $('#hidItivOutsetDocId').val(), '00441','P_RC_NO='+$("#hidRcNo").val(), $("#hidItivOutsetFileId").val());

			if( "Y" == $("#hidOutsetReportYN").val() ){
				$("#btnComptRequest").css('display', 'none');
			}
			
			if( null != $("#hidItivNo").val() && "" != $("#hidItivNo").val() ){
				$("#btnConfmRequest").css('display', 'none');
			}
		});


		//내사 착수 보고
		$("#btnComptRequest").click(function(){

			var checkDoc003Cnt = 0; //내사착수보고서 유뮤 확인
			var   rowCnt = ifrReport.AUIGrid.getRowCount("#grid_list");
			var formatId = "";
			var   fileNm = "";

			if( $("#hidItivNo").val() == null || $("#hidItivNo").val().length < 1 ){
				alert("내사착수 승인이 완료되지 않았습니다.");
				return;
			}
			
			if( rowCnt > 0 ){
				for( var i = 0; i < rowCnt; i++ ){
					formatId = ifrReport.AUIGrid.getCellValue( "#grid_list", i, "FORMAT_ID");
					  fileNm = ifrReport.AUIGrid.getCellValue( "#grid_list", i, "FILE_NM");

					//내사착수 보고서
					if( "00000000000000000003" == formatId ){
						if( null != fileNm && String(fileNm).length > 0 ){
							checkDoc003Cnt++;
						}
					}
				}//end for
			}

			if( checkDoc003Cnt < 1 ){
				alert("내사착수보고서를 작성하지 않았습니다.\n작성 후 다시 진행해주세요");
				return false;
			}

			if( !confirm("내사착수보고를 진행하시겠습니까?") ){
				alert("취소되었습니다.");
				return false;
			}

			var processAfterGet = function(data) {

				 if( data > 0 ){
					alert("내사착수보고가 완료되었습니다.");
					parent.itivOutsetReprtPopup.hide();
					parent.fnMoveGridPage("/rc/getCaseListAjax/", "frmList", parent.caseGridId, $("#hidPage", parent.document.body).val());
				 }
			}

			Ajax.getJson("<c:url value='/rc/reprtConfmRequestAjax/'/>", $('#itivOutsetForm').serialize(), processAfterGet);

		});
		
		//내사착수 승인 요청
		$("#btnConfmRequest").click(function(){
			
			if( null != $("#hidItivNo").val() && "" != $("#hidItivNo").val() ){
				alert("내사번호가 존재합니다.");
				return;
			}
			
			if( confirm("승인 요청하시겠습니까?") ){
				
				$("#hidOutsetConfmResultYN").val("Y");
	
				var processAfterGet = function(data) {

					 if( data > 0 ){
						$("#hidOutsetConfmResultYN").val("");
						$("#divItivDesc").text("내사착수 승인 요청중입니다. 내사착수 승인이 완료되면 확인이 가능합니다.");
						$("#btnConfmRequest").hide();
						alert("내사착수 승인 요청이 완료되었습니다.");
					 }
				}
				
				Ajax.getJson( "<c:url value='/rc/reprtConfmRequestAjax/'/>", $('#itivOutsetForm').serialize(), processAfterGet );
			}
		});
	});

</script>

<form id="itivOutsetForm" name="itivOutsetForm" method="post">
	<input type="hidden" id="hidRcNo" 			  name="hidRcNo"			  value="${rcNo}">
	<input type="hidden" id="hidItivNo" 		  name="hidItivNo"			  value="${itivNo}">
	<input type="hidden" id="hidProgrsSttusCd" 	  name="hidProgrsSttusCd" 	  value="${progrsSttusCd}">
	<input type="hidden" id="hidItivOutsetDocId"  name="hidItivOutsetDocId"   value="${docId}">	<!-- 내사착수승인 문서ID -->
	<input type="hidden" id="hidItivOutsetFileId" name="hidItivOutsetFileId"  value="${fileId}">
	<input type="hidden" id="hidReprtSe"		  name="hidReprtSe" 		  value="IOR">		<!-- 보고서 구분 코드-->
	<input type="hidden" id="hidOutsetReportYN"   name="hidOutsetReportYN"	  value="${outsetReportYN}"><!-- 착수보고 완료 여부-->
	<input type="hidden" id="hidOutsetConfmResultYN"   name="hidOutsetConfmResultYN"	  value="${outsetConfmResultYN}"><!-- 착수승인 요청 여부-->

	<div class="popup_body" style="padding-top: 5px; padding-bottom: 0px;">
	<c:if test="${ '02103' eq progrsSttusCd || '02104' eq progrsSttusCd || '02132' eq progrsSttusCd || '02143' eq progrsSttusCd }">
		<!--버튼 -->
		<div class="com_box  t_right">
			<div class="btn_box">
	  			<c:if test="${ null eq itivNo || '' eq itivNo }">
		  			<c:if test="${ 'Y' ne outsetConfmResultYN }">
						<input type="button" id="btnConfmRequest" name="btnConfmRequest" value="내사착수 승인 요청" class="btn_st3 icon_n fl" style="margin-right: 10px;">
					</c:if>
	  			</c:if>
				<input type="button" id="btnComptRequest" name="btnComptRequest" value="내사착수 보고 완료" class="btn_st3 icon_n fl">
	   		</div>
		</div>
		<!--//버튼  -->
	</c:if>
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
				  			<th>접수번호</th>
				  			<td>${rcNo}</td>
			  			</tr>
			  			<tr class="h_40px">
				  			<th>내사번호</th>
				  			<td>
				  			    <div id="divItivDesc">
				  			    <c:choose>
				  			        <c:when test="${ null eq itivNo || '' eq itivNo }">
					  			        <c:if test="${ 'Y' eq outsetConfmResultYN }">
					  			                내사착수 승인 요청중입니다. 내사착수 승인이 완료되면 확인이 가능합니다.
					  			        </c:if>
			  					        <c:if test="${ 'Y' ne outsetConfmResultYN }">
					  				        <c:choose>
						  			            <c:when test="${ 'R' eq outsetConfmResultYN }">
 					  				                       내사착수승인요청이 반려되었습니다. 내사착수 승인 요청을 다시 진행해주세요
                                                </c:when>
						  			            <c:otherwise>
							  			               내사착수 승인 후 확인 가능합니다. 내사착수 승인 요청을 진행해주세요
					  					        </c:otherwise>
				  					        </c:choose>
					  			        </c:if>
				  			         </c:when>
				  			         <c:otherwise>
				  			         ${itivNo}
				  			         </c:otherwise>
				  			    </c:choose>
				  			    </div>
				  			</td>
			  			</tr>
	  					<c:if test="${ 'Y' eq outsetReportYN }">
		  				<tr class="h_40px">
		  					<th>보고일자</th>
		  					<td>${itivOutsetInfo.OUTSET_REPORT_DT}</td>
		  				</tr>
						</c:if>
		  			</tbody>
			  	</table>
			</div>
		</div>

		<!-- report관련 iframe -->
		<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="410px"></iframe>
	</div>
</form>
