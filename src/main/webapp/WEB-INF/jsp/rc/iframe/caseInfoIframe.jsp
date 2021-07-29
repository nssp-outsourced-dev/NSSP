<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/inc/header.jsp" />
<style>
	.trHeight {
		height: 35px;
	}
</style>
<script type="text/javascript">

var myGridID = "#grid_wrap";

	$(function() {
		
		$(document).ready(function(){
			
		});
	});	// jQuery
	
</script>

<!--테이블 시작 -->
<div class="contents marginbot">  
	<form id="caseForm" name="caseForm" method="post" enctype="multipart/form-data">
		<input type="hidden"	id="hidRcNo"	name="hidRcNo" 		value="${rcNo}"> 			<!-- 접수번호 -->
		<input type="hidden"	id="hidItivNo" 	name="hidItivNo" 	value="${caseInfo.ITIV_NO}"><!-- 내사번호 -->
		<input type="hidden"	id="hidCaseNo" 	name="hidCaseNo" 	value="${caseNo}">			<!-- 사건번호 -->
		<input type="hidden"	id="hidDocId" 	name="hidDocId" 	value="${caseInfo.DOC_ID}" ><!-- 문서번호 -->
		<input type="hidden"	id="hidProgrsSttusCd"	name="hidProgrsSttusCd" 	value="${caseInfo.PROGRS_STTUS_CD}"> <!-- 진행상태 -->
		<input type="hidden" 	id="hidGridRowStatus"	name="hidGridRowStatus" 	value=""   ><!-- 그리드 로우 상태 -->

		<!-- tab1 사건정보 -->
		<div id="content1" >
			<div class="tb_01_box">
	 			<table class="tb_01">
				    <colgroup>
				    	<col width="150px">
					    <col width="520px" style="min-width: 500px; max-width: 700px;">
					    <col width="150px">
					    <col width="">
				    </colgroup>
				    <tbody>
		     			<tr class="trHeight">
					        <th>접수번호 </th>
					        <td colspan="3" class="t_left">
					        	<c:if test="${caseInfo.RC_NO != null}">
									${caseInfo.TRIM_RC_NO}
								</c:if>
								<c:if test="${caseInfo.RC_NO == null}">
									접수번호가 존재하지 않습니다.
								</c:if>
							</td>
							
							<%-- 2021.04.19 --%>
							<%-- 사건접수일시는 불필요하기에 안보이게 처리 --%>
					        <%-- <th>접수일시 </th>
					        <td class="t_left ">			
								${caseInfo.RC_DT}
			  				</td> --%>
						</tr>
						
						<tr class="trHeight">
							<th>임시사건<br>결과보고일시</th>
							<td colspan="3" class="t_left">
								<div class="calendar_box mr_5 fl w_150px">
									<input type="text" class="w_120p input_com calendar" id="tmprCaseDt" name="tmprCaseDt" readonly="readonly" value="${caseInfo.TMPR_CASE_RESULT_REPORT_DT eq null ? '' : caseInfo.TMPR_CASE_RESULT_REPORT_DT}" disabled="disabled">
								</div>
								<input type="button" id="tmprCaseDtModBtn" value="수정" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px;">
								<input type="button" id="tmprCaseDtSaveBtn" value="저장" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px; display: none;">
							</td>
						</tr>
						
						<tr>
							<th>내사착수일자</th>
							<td class="t_left">
								<div class="calendar_box mr_5 fl w_150px">
									<input type="text" class="w_120p input_com calendar" id="outsetDt" name="outsetDt" readonly="readonly" value="${caseInfo.OUTSET_REPORT_DT eq null ? '' : caseInfo.OUTSET_REPORT_DT}" disabled="disabled">
								</div>
								<input type="button" id="outsetDtModBtn" value="수정" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px;">
								<input type="button" id="outsetDtSaveBtn" value="저장" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px; display: none;">
							</td>
							
							<th>내사결과보고일자</th>
							<td class="t_left">
								<%-- ${caseInfo.ITIV_RESULT_REPORT_DT} --%>
								<div class="calendar_box mr_5 fl w_150px">
									<input type="text" class="w_120p input_com calendar" id="resultDt" name="resultDt" readonly="readonly" value="${caseInfo.ITIV_RESULT_REPORT_DT eq null ? '' : caseInfo.ITIV_RESULT_REPORT_DT}" disabled="disabled">
								</div>
								<input type="button" id="resultDtModBtn" value="수정" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px;">
								<input type="button" id="resultDtSaveBtn" value="저장" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px; display: none;">
							</td>
						</tr>
						
						<tr class="trHeight">
							<th>입건일자</th>
							<td colspan="3" class="t_left">
								<fmt:parseDate value="${caseInfo.PRSCT_DE}" var="date" pattern="yyyymmdd" />
								<fmt:formatDate value="${date}" pattern="yyyy-mm-dd" var="PRSCT_DE"/>
								
								<div class="calendar_box mr_5 fl w_150px">
									<input type="text" class="w_120p input_com calendar" id="prsctDt"  name="prsctDt" readonly="readonly" value="${PRSCT_DE}" disabled="disabled">
								</div>
								<input type="button" id="prsctDtModBtn" value="수정" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px;">
								<input type="button" id="prsctDtSaveBtn" value="저장" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px; display: none;">
							</td>
						</tr>
						
						<tr class="trHeight">
							<th>수사재개일시</th>
							<td colspan="3" class="t_left">
								<div class="calendar_box mr_5 fl w_150px">
									<input type="text" class="w_120p input_com calendar" id="invResmptDt" name="invResmptDt" readonly="readonly" value="${caseInfo.INV_RESMPT_DE eq null ? '' : caseInfo.INV_RESMPT_DE}" disabled="disabled">
								</div>
								<input type="button" id="invResmptDtModBtn" value="수정" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px;">
								<input type="button" id="invResmptDtSaveBtn" value="저장" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px; display: none;">
							</td>
						</tr>
						
						<tr class="trHeight">
							<th>내사번호 </th>
						  	<td class="t_left">
						  		<c:if test="${caseInfo.ITIV_NO != null}">
									${caseInfo.TRIM_ITIV_NO}
								</c:if>
								<c:if test="${caseInfo.ITIV_NO == null}">
									내사번호가 존재하지 않습니다.
								</c:if>
							</td>
						  	<th>사건번호 </th>
						  	<td class="t_left">
						  		<c:if test="${caseInfo.CASE_NO != null}">
									${caseInfo.TRIM_CASE_NO}
								</c:if>
								<c:if test="${caseInfo.CASE_NO == null}">
									사건입건 후 확인 가능합니다
								</c:if>
							</td>
						</tr>
		    			<tr class="trHeight">
							<th>수사단서</th>
					        <td class="t_left">
				            	<c:forEach var="cd" items="${invProvisoList}">
									<c:if test="${cd.cd == caseInfo.INV_PROVIS_CD}">${cd.cdNm}</c:if>	
								</c:forEach>
					        </td>
					        <th>사건구분</th>
					        <td class="t_left">
								${caseInfo.RC_SE_NM}								
					        </td>
					    </tr>
		     			<tr class="trHeight">
		       				<th>발생일시</th>
							<td class="t_left">
								<div class=" flex_r">
									<!--달력폼-->
									<div class="calendar_box  w_120px  mr_5">
										<input type="text" 	 id="txtOccrrncBeginDe"	  name="txtOccrrncBeginDe"	class="w_100p input_com calendar"	readonly="readonly" value="${caseInfo.OCCRRNC_BEGIN_DE}" disabled="disabled">
									</div>
									<div class="fl">
										<input type="text"   id="txtOccrrncBeginDeHh" name="txtOccrrncBeginDeHh" class="input_com" onkeyup="fnHHMMChk(event,'HH')" maxlength="2" style="width: 40px;" value="${caseInfo.OCCRRNC_BEGIN_DE_HH}" disabled="disabled"/>:
										<input type="text"   id="txtOccrrncBeginDeMi" name="txtOccrrncBeginDeMi" class="input_com" onkeyup="fnHHMMChk(event,'MM')" maxlength="2" style="width: 40px;" value="${caseInfo.OCCRRNC_BEGIN_DE_MI}" disabled="disabled"/>
									</div>
									&nbsp;~&nbsp;
									<!--달력폼-->
									<div class="calendar_box  w_120px ml_5 mr_5">
										<input type="text" 	 id="txtOccrrncEndDe"	  name="txtOccrrncEndDe"	class="w_100p input_com calendar"	readonly="readonly" value="${caseInfo.OCCRRNC_END_DE}" disabled="disabled">
									</div>
									<div class="fl">
										<input type="text"   id="txtOccrrncEndDeHh"   name="txtOccrrncEndDeHh" class="input_com" onkeyup="fnHHMMChk(event,'HH')" maxlength="2" style="width: 40px;" value="${caseInfo.OCCRRNC_END_DE_HH}" disabled="disabled" />:
										<input type="text"   id="txtOccrrncEndDeMi"   name="txtOccrrncEndDeMi" class="input_com" onkeyup="fnHHMMChk(event,'MM')" maxlength="2" style="width: 40px;" value="${caseInfo.OCCRRNC_END_DE_MI}" disabled="disabled" />
									</div>
									&nbsp;
									<input type="button" id="OccrrncModBtn" value="수정" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px;">
									<input type="button" id="OccrrncSaveBtn" value="저장" class="btn_st1 icon_n mr_2" style="width: 50px;padding-left: 0px;padding-right: 0px; display: none;">
								<%-- ${caseInfo.OCCRRNC_BEGIN_DT}
								<c:if test="${NULL != caseInfo.OCCRRNC_BEGIN_DT}">
									&nbsp;~&nbsp;
								</c:if>
								${caseInfo.OCCRRNC_END_DT} --%>
								</div>
								
							</td>
							<th>접수형태 </th>
						   	<td class="t_left">
					            <c:forEach var="cd" items="${rcFormList}">
									<c:if test="${cd.cd == caseInfo.RC_STLE_CD}">${cd.cdNm}</c:if>	
								</c:forEach>
		        			</td>
		     			</tr>
						<tr class="trHeight">
		      				<th>발생장소</th>
		     				<td colspan="3" class="t_left">
								<c:if test="${NULL != caseInfo.OCCRRNC_ZIP}">
									우편번호 :  ${caseInfo.OCCRRNC_ZIP}
								</c:if>
								<c:if test="${NULL != caseInfo.OCCRRNC_ADDR}">
									&nbsp;&nbsp;&nbsp;&nbsp;
									주소 :  ${caseInfo.OCCRRNC_ADDR}
								</c:if>
							</td>
		     			</tr>
						<tr class="trHeight">
		       				<th>민원인연락처</th>
		       				<td class="t_left">
		       					${caseInfo.CPTTR_HP_NO}
		       				</td>
		       				<th>담당자</th>
				        	<td class="t_left">
				        		${userInfo.USER_NM}( ${userInfo.DEPT_NM} )
				        	</td>
		     			</tr>
						<tr class="trHeight">
							<th>상담방법</th>
							<td class="t_left">
								<c:forEach var="cd" items="${cnsltMthCdList}">
									<c:if test="${cd.cd == caseInfo.CNSLT_MTH_CD}">${cd.cdNm}</c:if>	
								</c:forEach>
							</td>
							<th>상담일시</th>
							<td class="t_left">
								${caseInfo.CNSLT_DT} 
							</td>
						</tr>
						<tr class="trHeight">
				        	<th>관할검찰</th>
				        	<td colspan="3" class="t_left">
				        		${caseInfo.CMPTNC_EXMN_NM}
				        	</td>
				     	</tr>
						<tr class="trHeight">
		       				<th>위반죄명 </th>
		       				<td colspan="3" class="t_left">
		       					${caseInfo.VIOLT_NM} 
		       				</td>
				        </tr>
						<tr class="trHeight">
			  				<th>범죄사실<br>
								(혐의사실) 
							</th>
			  				<td class="t_left">
			  					<c:out value="${caseInfo.CRMNL_FACT}" escapeXml="false"/>
			  				</td>
			  				<th>기타 </th>
			  				<td class="t_left">
			  					<c:out value="${caseInfo.ETC_CN}" escapeXml="false"/>
			  				</td>
			  			</tr>
						<tr class="trHeight">
			  				<th>사건개요<br>(수사의뢰 경위) 
			    			</th>
			  				<td class="t_left">
			  					<c:out value="${caseInfo.CASE_SUMRY}" escapeXml="false"/> 
			  				</td>
			  				<th>입증자료</th>
		  					<td class="t_left">
		  						<c:out value="${caseInfo.PRF_DTA}" escapeXml="false"/>
		  					</td>
			  			</tr> 
						
					<c:if test="${ NULL != caseInfo.TRNSF_SN && '' != caseInfo.TRNSF_SN }">
						<tr class="trHeight">
							<th>이송관서</th>
							<td class="t_left">
								${caseInfo.TRNSF_INSTT_NM}&nbsp;${caseInfo.TRNSF_INSTT_DEPT}
							</td>
							<th>이송일자</th>
							<td class="t_left">
								${caseInfo.TRNSF_DE}
							</td>
						</tr>
						<tr class="trHeight">
							<th>이송사유</th>
							<td colspan="3" class="t_left">
								${caseInfo.TRNSF_RESN_DC}
							</td>
						</tr>
					</c:if>
						<tr class="trHeight">
							<th>첨부파일</th>
							<td colspan="3" class="t_left">
								<iframe id="ifrFile" src="<c:url value='/file/fileListIframe/'/>?ifr_id=ifrFile&file_id=${caseInfo.FILE_ID}" scrolling="no" frameborder="0" width="100%" style="height: 20px;"></iframe>
							</td>
						</tr>
	   				</tbody>
				</table>
			</div>
		</div>
	</form>
</div>

<script type="text/javascript">
	$(function() {
		$("#tmprCaseDt, #outsetDt, #resultDt, #prsctDt, #invResmptDt, #txtOccrrncBeginDe, #txtOccrrncEndDe").datepicker({
			dateFormat : 'yy-mm-dd',
			monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월',
					'9월', '10월', '11월', '12월' ],
			monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월',
					'8월', '9월', '10월', '11월', '12월' ],
			dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
			dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
			dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
			changeYear : true,
			changeMonth : true,
			showOn : 'both', /*button*/
			buttonImageOnly : false,
			//selectOtherMonths : true,
			buttonImage : "/img/search_calendar.png",
			beforeShow: function() {
				setTimeout(function(){
					$('.ui-datepicker').css('z-index', 99999999999999);
				}, 0);
			}
		});
		
		/****************************임시사건 결과 보고 일시***************************************/
		/* 임시사건 결과 보고 일시 수정 */
		$("#tmprCaseDtModBtn").on("click", function(){
			$("#tmprCaseDt").attr("disabled", !$("#tmprCaseDt").attr("disabled"));
			$("#tmprCaseDtModBtn").hide();
			$("#tmprCaseDtSaveBtn").show();
		});
		
		/* 임시사건 결과 보고 일시 완료 */
		$("#tmprCaseDtSaveBtn").on("click", function(){
			var data = $("#tmprCaseDt").val();
			if(data == "" || 
					data.length == 0 || 
					data == undefined){
				alert("수정한 자료가 없습니다.");
				return false;
			}
			
			updateDeAjax({tmprCaseDt: data}, function(data){
				if(data.result == "1"){
					$("#tmprCaseDt").attr("disabled", !$("#tmprCaseDt").attr("disabled"));
					$("#tmprCaseDtModBtn").show();
					$("#tmprCaseDtSaveBtn").hide();
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
			});
		});
		/****************************임시사건 결과 보고 일시 END***********************************/
		
		/****************************입건일자***************************************/
		/* 입건일자 수정 */
		$("#prsctDtModBtn").on("click", function(){
			$("#prsctDt").attr("disabled", !$("#prsctDt").attr("disabled"));
			$("#prsctDtModBtn").hide();
			$("#prsctDtSaveBtn").show();
		});
		
		/* 입건일자 완료 */
		$("#prsctDtSaveBtn").on("click", function(){
			var data = $("#prsctDt").val();
			if(data == "" || 
					data.length == 0 || 
					data == undefined){
				alert("수정한 자료가 없습니다.");
				return false;
			}
			
			updateDeAjax({prsctDt: data}, function(data){
				if(data.result == "1"){
					$("#prsctDt").attr("disabled", !$("#prsctDt").attr("disabled"));
					$("#prsctDtModBtn").show();
					$("#prsctDtSaveBtn").hide();
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
			});
		});
		/****************************입건일자 END***********************************/
		
		/****************************수사재개일시***************************************/
		/* 수사재개일시 수정 */
		$("#invResmptDtModBtn").on("click", function(){
			$("#invResmptDt").attr("disabled", !$("#invResmptDt").attr("disabled"));
			$("#invResmptDtModBtn").hide();
			$("#invResmptDtSaveBtn").show();
		});
		
		/* 수사재개일시 완료 */
		$("#invResmptDtSaveBtn").on("click", function(){
			var data = $("#invResmptDt").val();
			if(data == "" || 
					data.length == 0 || 
					data == undefined){
				alert("수정한 자료가 없습니다.");
				return false;
			}
			
			updateDeAjax({invResmptDt: data}, function(data){
				if(data.result == "1"){
					$("#invResmptDt").attr("disabled", !$("#invResmptDt").attr("disabled"));
					$("#invResmptDtModBtn").show();
					$("#invResmptDtSaveBtn").hide();
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
			});
		});
		/****************************수사재개일시 END***********************************/
		
		/****************************내사착수일자***************************************/
		/* 내사착수일자 수정 */
		$("#outsetDtModBtn").on("click", function(){
			console.log(!$("#outsetDt").attr("disabled"));
			$("#outsetDt").attr("disabled", !$("#outsetDt").attr("disabled"));
			$(this).hide();
			$("#outsetDtSaveBtn").show();
		});
		
		/* 내사착수일자 완료 */
		$("#outsetDtSaveBtn").on("click", function(){
			var data = $("#outsetDt").val();
			if(data == "" || 
					data.length == 0 || 
					data == undefined){
				alert("수정한 자료가 없습니다.");
				return false;
			}
			
			updateDeAjax({outsetDt: data}, function(data){
				if(data.result == "1"){
					$("#outsetDt").attr("disabled", !$("#outsetDt").attr("disabled"));
					$("#outsetDtModBtn").show();
					$("#outsetDtSaveBtn").hide();
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
			});
		});
		/****************************내사착수일자 END***********************************/
		
		/****************************내사결과보고일자***************************************/
		/* 내사결과보고일자 수정 */
		$("#resultDtModBtn").on("click", function(){
			$("#resultDt").attr("disabled", !$("#resultDt").attr("disabled"));
			$("#resultDtModBtn").hide();
			$("#resultDtSaveBtn").show();
		});
		
		/* 내사결과보고일자 완료 */
		$("#resultDtSaveBtn").on("click", function(){
			var data = $("#resultDt").val();
			if(data == "" || 
					data.length == 0 || 
					data == undefined){
				alert("수정한 자료가 없습니다.");
				return false;
			}
			
			updateDeAjax({resultDt: data}, function(data){
				if(data.result == "1"){
					$("#resultDt").attr("disabled", !$("#resultDt").attr("disabled"));
					$("#resultDtModBtn").show();
					$("#resultDtSaveBtn").hide();
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
			});
		});
		/****************************내사결과보고일자 END***********************************/
		
		/* 
			2021.06.25
			일자 수정
			시스템에서 자동 생성되는 일자가 맞지 않다면 수기로 작성하도록 수정.
			임시사건 결과 보고일자, 입건일자, 수사재개일자 수기로 작성하게끔 수정.
			김지만 수사관 요청
		*/
		function updateDeAjax(param, fn){
			if(confirm("저장하시겠습니까?")){
				param.rc_no = "${caseInfo.RC_NO}";
				
				Ajax.getJson("<c:url value='/rc/updateDeAjax/'/>", param, fn);
			}
		}
		
		/************************************************************************************/
		$("#OccrrncModBtn").on("click", function(){
			var isDisabled = $("#txtOccrrncBeginDe").attr("disabled");
			$("#txtOccrrncBeginDe, #txtOccrrncBeginDeHh, #txtOccrrncBeginDeMi, #txtOccrrncEndDe, #txtOccrrncEndDeHh, #txtOccrrncEndDeMi").attr("disabled", !isDisabled);
			
			$(this).hide();
			$("#OccrrncSaveBtn").show();
		});
		
		$("#OccrrncSaveBtn").on("click", function(){
			var occrrnc_begin_dt = $("#txtOccrrncBeginDe").val() + $("#txtOccrrncBeginDeHh").val() + $("#txtOccrrncBeginDeMi").val();
			var occrrnc_end_dt = $("#txtOccrrncEndDe").val() + $("#txtOccrrncEndDeHh").val() + $("#txtOccrrncEndDeMi").val()
			
			if(occrrnc_begin_dt == "" || 
					occrrnc_begin_dt.length == 0 || 
					occrrnc_begin_dt == undefined){
				alert("수정한 자료가 없습니다.");
				return false;
			}
			
			if(occrrnc_end_dt == "" || 
					occrrnc_end_dt.length == 0 || 
					occrrnc_end_dt == undefined){
				alert("수정한 자료가 없습니다.");
				return false;
			}
			
			updateDeAjax({occrrnc_begin_dt: occrrnc_begin_dt, occrrnc_end_dt: occrrnc_end_dt}, function(data){
				if(data.result == "1"){
					var isDisabled = $("#txtOccrrncBeginDe").attr("disabled");
					$("#txtOccrrncBeginDe, #txtOccrrncBeginDeHh, #txtOccrrncBeginDeMi, #txtOccrrncEndDe, #txtOccrrncEndDeHh, #txtOccrrncEndDeMi").attr("disabled", !isDisabled);
					
					$("#OccrrncSaveBtn").hide();
					$("#OccrrncModBtn").show();
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
			});
		});
		/************************************************************************************/
	});	
</script>
	
