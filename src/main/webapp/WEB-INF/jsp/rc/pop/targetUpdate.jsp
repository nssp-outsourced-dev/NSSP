<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/inc/header.jsp" />

<script type="text/javascript" src="/js/validate/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/rc.common.js"></script>
<script type="text/javascript" src="/js/rc.validate.js"></script>
<script type="text/javascript">

	var gridTargetList;
	var myGridID = "#grid_target";

	$(function() {

		$(document).ready(function(){

			var param = $('#targetBasicInfoForm').serialize();
			var processAfterGet = function(data) {
			     fn_form_bind ("targetForm",data);
			}

			Ajax.getJson("<c:url value='/rc/getTargetInfoByFormBindAjax/'/>", param, processAfterGet);

			//대상자 유형
			if( "I" == $(":input:radio[name=rdoTrgterTyCd]:checked").val() ){
				$("#rdoTrgterTyCdI").prop("checked", true);
				$('.entrprs').css('display', 'none');
			} else if( "E" == $(":input:radio[name=rdoTrgterTyCd]:checked").val() ){
				$("#rdoTrgterTyCdE").prop("checked", true);
				$('.indvdl').css('display', 'none');
			} else {
				$("#rdoTrgterTyCdI").prop("checked", true);
				$('.entrprs').css('display', 'none');
			}

			//대리인
			if( "C" == $(":input:radio[name=rdoAgentSeCd]:checked").val() ){
				$("#rdoAgentSeCdC").prop("checked", true);
				$("#divAgent").show();
			} else if( "M" == $(":input:radio[name=rdoAgentSeCd]:checked").val() ){
				$("#rdoAgentSeCdM").prop("checked", true);
				$("#divAgent").show();
			} else {
				$("#rdoAgentSeCd").prop("checked", true);
				$("#divAgent").hide();
			}

			/*
			//대상자 구분 분류
			$("#rdoTrgterSeGroupCdS").prop("checked", true);
			$('#selTrgterSeCd option[class="accs-Group"]').hide();

			//대상자 구분 radio check
			if( "accs-Group" == $("#hidTrgterSeGroup").val() ){
				$("#rdoTrgterSeGroupCdA").prop("checked", true);
			} else {
				$("#rdoTrgterSeGroupCdS").prop("checked", true);
			} */

		});


		//대상자 구분 선택시
		$("input:radio[name='rdoTrgterSeGroupCd']").change(function(){

			$('#selTrgterSeCd option').eq(0).prop('selected', true);

			if( $("input:radio[name='rdoTrgterSeGroupCd']:radio[value='S']").prop("checked") ){	//피의자등
				$('#selTrgterSeCd option[class="accs-Group"]').hide();
				$('#selTrgterSeCd option[class="suspct-Group"]').show();
			}

			if( $("input:radio[name='rdoTrgterSeGroupCd']:radio[value='A']").prop("checked") ){	//피의자등
				$('#selTrgterSeCd option[class="accs-Group"]').show();
				$('#selTrgterSeCd option[class="suspct-Group"]').hide();
			}

		});

		//대상자 유형 선택시
		$("input:radio[name='rdoTrgterTyCd']").change(function(){

			if( $("input:radio[name='rdoTrgterTyCd']:radio[value='I']").prop("checked") ){	//개인
				$('.entrprs').css('display', 'none');
				$('.indvdl').css('display', '');

				$('#divTrgterNm').text('성명(한글)');
				$('#divTrgterEngNm').text('성명(영문)');

			} else {	//기업
				$('.indvdl').css('display', 'none');
				$('.entrprs').css('display', '');

				$('#divTrgterNm').text('기업명');
				$('#divTrgterEngNm').text('기업명(영문)');
			}
		});

		$("#selInvProvisCd").change(function(){	//수사단서 선택시

			//고소/고발일 경우 사건구분 정식사건으로 고정
			if( "00401" == $("#selInvProvisCd").val() || "00402" == $("#selInvProvisCd").val() ){

				$("#hidRcSeCdSub").val("F");
				$("input:radio[name='rdoRcSeCd']:radio[value='F']").prop("checked", true); // 선택하기
				$('input:radio[name=rdoRcSeCd]').attr('disabled', true);
			} else {
				$("#hidRcSeCdSub").val("");
				$('input:radio[name=rdoRcSeCd]').attr('disabled', false);
			}
		});


		$("#selTrgterClCd").change(function(){	//대상자 분류 선택시

			//고소/고발일 경우 사건구분 정식사건으로 고정
			if( "00271" == $("#selTrgterClCd").val() ){
				$("#txtNltyNm").val("대한민국");
				$("#hidNltyCd").val("01346");
			} else {
				$("#txtNltyNm").val("");
				$("#hidNltyCd").val("");
			}
		});

		//국적코드
		$("#btnNlty").click(function(){
			fnCdSelectSingle('01117');
		});

		//대상자 저장 버튼 클릭
		$("#btnTargetSave").click(function(){
			$("#targetForm").submit();
		});

		//삭제 버튼 클릭
		$("#btnTargetDelete").click(function(){

			if( confirm("대상자정보를 삭제하시겠습니까?") ){

				var iUrl = '<c:url value='/rc/deleteTargetInfoAjax/'/>';
		 		var queryString = $('#targetBasicInfoForm').serialize();
		 		var processAfterGet = function(data) {

					if( data.result == "1" ){
						parent.targetUpdatePopup.hide();
						$("#searchRcNo", parent.document).val($("#hidRcNo").val());
						parent.AUIGrid.clearGridData( parent.gridTargetList );
						parent.fnTargetSearch();//대상자 조회
						alert("삭제되었습니다.");

					} else {
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
			}
		});

		//위임자 선택시
		$("input:radio[name='rdoAgentSeCd']").change(function(){

			if ( $("input:radio[name='rdoAgentSeCd']:radio[value='']").prop("checked") ){	//피의자등
				$("#divAgent").hide();
			} else {
				$("#divAgent").show();
			}
		});

	});	// jQuery


	//대상자 정보 수정
	function fnTrgterUpdate(){

		if( confirm("대상자정보를 수정하시겠습니까?") ){

			var iUrl = '<c:url value='/rc/updateTargetInfoAjax/'/>';
	 		var queryString =  $('#targetForm').serialize() + "&" + $('#targetBasicInfoForm').serialize();

	 		var processAfterGet = function(data) {
				if( data.result == "1" ){
					parent.targetUpdatePopup.hide();
					$("#searchRcNo", parent.document).val($("#hidRcNo").val());
					parent.AUIGrid.clearGridData( parent.gridTargetList );
					parent.fnTargetSearch();//대상자 조회
					alert("수정되었습니다.");
				} else {
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}



</script>

<!--본문시작 -->
<div>
	<form id="targetBasicInfoForm" name="targetBasicInfoForm" method="post" >
		<input type="hidden" id="hidRcNo" 		name="hidRcNo" 		value="${rcNo}"    ><!-- 접수번호 -->
		<input type="hidden" id="hidItivNo" 	name="hidItivNo" 	value="${itivNo}"  ><!-- 내사번호 -->
		<input type="hidden" id="hidCaseNo" 	name="hidCaseNo" 	value="${caseNo}"  ><!-- 사건번호 -->
		<input type="hidden" id="hidRcSeCd" 	name="hidRcSeCd" 	value="${rcSeCd}"  ><!-- 사건구분 -->
		<input type="hidden" id="hidTrgterSn" 	name="hidTrgterSn" 	value="${trgterSn}"><!-- 대상자 순번 -->

		<input type="hidden" id="screenClassification" 	name="screenClassification" value="U"><!-- 화면 구분 validate 시 사용 - 작성화면 : C / 수정화면 : U -->
	</form>
	<!--테이블 시작 -->
	<div class="contents marginbot" style="margin-bottom: 0px;">
		<input type="hidden" id="hidSelectAddress" 		name="hidSelectAddress" 	value="">

		<form id="targetForm" name="targetForm" method="post" enctype="multipart/form-data" autocomplete="off">
			<input type="hidden" id="hidHpNo" 		name="hidHpNo"	   ><!-- 대상자 휴대전화	 -->
			<input type="hidden" id="hidOwnhomTel"	name="hidOwnhomTel"><!-- 대상자 자택전화	 -->
			<input type="hidden" id="hidWrcTel" 	name="hidWrcTel"   ><!-- 대상자 직장전화 	 -->
			<input type="hidden" id="hidEtcTel" 	name="hidEtcTel"   ><!-- 대상자 기타 연락처 -->
			<input type="hidden" id="hidAgentTel" 	name="hidAgentTel" ><!-- 대리인 전화번호	 -->
			<input type="hidden" id="hidTrgterRrn" 	name="hidTrgterRrn"><!-- 대리인 주민번호	 -->
			<!-- tabT 대상자정보 -->
			<div id="contentT">
				<div class="box_w2 mt_10">
					<div class="box_w2_2" style="width: 860px;">
						<div class="right_btn">
							<input type="button" id="btnTargetSave"	  	class="btn_st2 icon_n fl mr_m1" value="저장"	style="float: right;position: relative; margin-bottom: 5px;margin-right: 2px;">
							<input type="button" id="btnTargetDelete"	class="btn_st2 icon_n fl mr_m1" value="삭제"	style="float: right;position: relative;" >
						</div>
						<!--테이블 시작 -->
    					<div>
      						<div class="tb_01_box"	id="divTargetInfo">
      						<table class="tb_01">
    								<colgroup>
    									<col width="130px">
									    <col width="">
									    <col width="130px">
									    <col width="">
    								</colgroup>
    								<tbody>
									    <tr>
											<th>
												대상자구분<span class="point"><img src="/img/point.png" alt=""></span>
											</th>
									      	<td>
									      		<div class="input_radio2 t_left" style="padding-top: 5px;padding-left: 19px;">
								            		<input type="radio"	class="to-labelauty-icon labelauty"  name="rdoTrgterSeGroupCd"	id="rdoTrgterSeGroupCdS"  value="S" <c:if test="${items.grdTrgterSeCd eq 'I'}">checked</c:if>>
								            		<label for="rdoTrgterSeGroupCdS">
								            			<span class="labelauty-unchecked-image"></span>
								            			<span class="labelauty-checked-image"></span>
								            		</label>
							            			피의자 등
							            		</div>
							            		<div class="input_radio2 t_left" style="padding-top: 5px;padding-left: 19px">
							            			<input type="radio"	class="to-labelauty-icon labelauty"  name="rdoTrgterSeGroupCd"	id="rdoTrgterSeGroupCdA" value="A" <c:if test="${items.grdTrgterTyCd eq 'E'}">checked</c:if>>
							            			<label for="rdoTrgterSeGroupCdA">
							            				<span class="labelauty-unchecked-image"></span>
							            				<span class="labelauty-checked-image"></span>
							            			</label>
							            			고발인 등
							            		</div>
									      		<select id="selTrgterSeCd"	name="selTrgterSeCd" size="1" class="w_100px input_com">
													<option value="">=선택=</option>
									            	<c:forEach var="cd" items="${trgterSectionCdList}">
														<option value="${cd.cd}" class="${cd.cdDc}" <c:if test="${cd.cd eq items.grdTrgterSeCd}">selected</c:if> ><c:out value="${cd.cdNm}" /></option>
													</c:forEach>
									       		</select>
									       	</td>
									      	<th>
									      		대상자 유형<span class="point"><img src="/img/point.png" alt=""></span>
									      	</th>
									        <td>
									        	<div class="input_radio2 t_left">
								            		<input type="radio"	class="to-labelauty-icon labelauty"  name="rdoTrgterTyCd"	id="rdoTrgterTyCdI"  value="I" <c:if test="${items.grdTrgterTyCd eq 'I'}">checked</c:if>>
								            		<label for="rdoTrgterTyCdI">
								            			<span class="labelauty-unchecked-image"></span>
								            			<span class="labelauty-checked-image"></span>
								            		</label>
							            			개인
							            		</div>
							            		<div class="input_radio2 t_left">
							            			<input type="radio"	class="to-labelauty-icon labelauty"  name="rdoTrgterTyCd"	id="rdoTrgterTyCdE" value="E" <c:if test="${items.grdTrgterTyCd eq 'E'}">checked</c:if>>
							            			<label for="rdoTrgterTyCdE">
							            				<span class="labelauty-unchecked-image"></span>
							            				<span class="labelauty-checked-image"></span>
							            			</label>
							            			기업
							            		</div>
							            	</td>
										</tr>
      									<tr>
        									<th>
        										<span id="divTrgterNm">성명</span><span class="point"><img src="/img/point.png" alt=""></span>
        									</th>
        									<td>
   												<input class="w_265px input_com"	type="text" id="txtTrgterNm"	name="txtTrgterNm"  maxlength="19" size="50" value="${items.grdTrgterNm}">
        									</td>
        									<th><span id="divTrgterEngNm">성명(영문)</span></th>
											<td><input type="text" 		id="txtTrgterEngNm" 	name="txtTrgterEngNm"	value="${items.grdTrgterEngNm}" maxlength="20" size="50"  class="w_265px input_com"></td>
							      		</tr>
										<tr class="entrprs">
									       	<th>법인번호</th>
									       	<td>
									       		<input class="w_160px input_com"	type="text" id="txtTrgterCprn"	name="txtTrgterCprn" maxlength="16" value="${items.grdTrgterCprn}">
									       		( "-" 포함 )
									       	</td>
										    <th>대표자</th>
									       	<td>
									       		<input class="w_160px input_com"	type="text" id="txtRprsntvNm"	name="txtRprsntvNm"  maxlength="16" value="${items.grdRprsntvNm}">
									       	</td>
											<%--
											<th>사업자번호</th>
									       	<td>
									       		<input class="w_160px input_com"	type="text" id="txtTrgterCrn"	name="txtTrgterCrn"  maxlength="16" value="${items.grdTrgterCrn}">
									       		( "-" 포함 )
									       	</td> 
									        --%>
									    </tr>
										<tr class="indvdl">
											<th>주민등록번호</th>
											<td>
												<input type="text"	class="w_80px input_com onlyNumber"	id="txtTrgterRrnFront"	name="txtTrgterRrnFront"	maxlength="6" size="10" value="${items.grdTrgterRrnFront}" onkeyup="fnTargetAgeCalculation();">
												-
												<input type="text"	class="w_80px input_com onlyNumber"	id="txtTrgterRrnEnd"	name="txtTrgterRrnEnd" 		maxlength="7" size="10" value="${items.grdTrgterRrnEnd}"   onkeyup="fnTargetAgeCalculation();">
											</td>
											<th>나이</th>
											<td>
												<input type="text"	class="w_50px input_com onlyNumber"	id="txtTrgterAge"		name="txtTrgterAge"  		maxlength="3"	size="50" value="${items.grdTrgterAge}" > (만)세
											</td>
										</tr>
									    <tr class="indvdl">
									        <th>
									        	성별
									        </th>
									        <td>
									        	<div class="input_radio2 t_left">
								            		<input type="radio"	class="to-labelauty-icon labelauty"  name="rdoSexdstnCd"	id="rdoSexdstnCdM"  value="M" <c:if test="${items.grdSexdstnCd eq 'M'}">checked</c:if>>
								            		<label for="rdoSexdstnCdM">
								            			<span class="labelauty-unchecked-image"></span>
								            			<span class="labelauty-checked-image"></span>
								            		</label>
							            			남자
							            		</div>
							            		<div class="input_radio2 t_left">
							            			<input type="radio"	class="to-labelauty-icon labelauty"  name="rdoSexdstnCd"	id="rdoSexdstnCdF" value="F" <c:if test="${items.grdSexdstnCd eq 'F'}">checked</c:if>>
							            			<label for="rdoSexdstnCdF">
							            				<span class="labelauty-unchecked-image"></span>
							            				<span class="labelauty-checked-image"></span>
							            			</label>
							            			여자
							            		</div>
							            		<div class="input_radio2 t_left">
							            			<input type="radio"	class="to-labelauty-icon labelauty"  name="rdoSexdstnCd"	id="rdoSexdstnCdU" value="U" <c:if test="${items.grdSexdstnCd eq 'U'}">checked</c:if>>
							            			<label for="rdoSexdstnCdU">
							            				<span class="labelauty-unchecked-image"></span>
							            				<span class="labelauty-checked-image"></span>
							            			</label>
							            			불상
							            		</div>
							            	</td>
							            	<th>
									      		대상자분류
									      	</th>
									      	<td>
												<select id="selTrgterClCd"	name="selTrgterClCd" size="1" class="w_265px input_com">
														<option value="">미분류</option>
									            	<c:forEach var="cd" items="${trgterClCdList}">
														<option value="${cd.cd}" <c:if test="${cd.cd eq items.grdTrgterClCd}">selected</c:if> ><c:out value="${cd.cdNm}" /></option>
													</c:forEach>
									        	</select>
									  		</td>
										</tr>
      									<tr class="indvdl">
        									<th>휴대전화</th>

								       		<td>
								       			<select	class="w_80px input_com"	id="selHpNo1"	name="selHpNo1" size="1" >
													<option value="" selected="selected">=선택=</option>
													<c:forEach var="cd" items="${hpNoCdList}">
														<option value="${cd.cdNm}" <c:if test="${cd.cdNm eq items.grdHpNoFront}">selected</c:if> ><c:out value="${cd.cdNm}" /></option>
													</c:forEach>
								       			</select>
								         		&nbsp;-
								 				<input type="text"	class="w_60px input_com onlyNumber"	id="txtHpNo2" 	name="txtHpNo2"	maxlength="4" size="10" value="${items.grdHpNoCenter}" >
								         		-
								 				<input type="text"	class="w_60px input_com onlyNumber"	id="txtHpNo3"	name="txtHpNo3"	maxlength="4" size="10" value="${items.grdHpNoBack}" >
								 			</td>
									        <th>자택전화</th>
									        <td>
									        	<select class="w_80px input_com"	id="selOwnhomTel1"	name="selOwnhomTel1" size="1" >
									          		<option value="" selected="selected">=선택=</option>
									          		<c:forEach var="cd" items="${telofcnoCdList}">
														<option value="${cd.cdNm}" <c:if test="${cd.cdNm eq items.grdOwnhomTelFront}">selected</c:if> ><c:out value="${cd.cdNm}" /></option>
													</c:forEach>
									        	</select>
          										&nbsp;-
  												<input type="text"	class="w_60px input_com onlyNumber"	id="txtOwnhomTel2"	name="txtOwnhomTel2"	maxlength="4" size="10" value="${items.grdOwnhomTelCenter}">
          										-
  												<input type="text"	class="w_60px input_com onlyNumber"	id="txtOwnhomTel3"	name="txtOwnhomTel3"	maxlength="4" size="10" value="${items.grdOwnhomTelBack}"  >
  											</td>
								     	</tr>
										<tr>
								     		<th>직장전화 </th>
								       		<td>
								       			<select class="w_80px input_com"	id="selWrcTel1"	name="selWrcTel1" size="1" >
								           			<option value="" selected="selected">=선택=</option>
								           			<c:forEach var="cd" items="${telofcnoCdList}">
														<option value="${cd.cdNm}" <c:if test="${cd.cdNm eq items.grdWrcTelFront}">selected</c:if> ><c:out value="${cd.cdNm}" /></option>
													</c:forEach>
								         		</select>
								         		&nbsp;-
												<input type="text" id="txtWrcTel2"	name="txtWrcTel2" 	size="10" 	value="${items.grdWrcTelCenter}" class="w_60px input_com onlyNumber" maxlength="4">
												-
												<input type="text" id="txtWrcTel3"	name="txtWrcTel3"  	size="10" 	value="${items.grdWrcTelBack}"	 class="w_60px input_com onlyNumber" maxlength="4">
											</td>
        									<th>기타연락처 </th>
        									<td>
	        									<select id="selEtcTel1"	name="selEtcTel1" size="1" class="w_80px input_com notHangul">
									          		<option value="" selected="selected">=선택=</option>
									          		<c:forEach var="cd" items="${telofcnoCdList}">
														<option value="${cd.cdNm}" <c:if test="${cd.cdNm eq items.grdEtcTelFront}">selected</c:if> ><c:out value="${cd.cdNm}" /></option>
													</c:forEach>
        										</select>
          										&nbsp;-
  												<input type="text" id="txtEtcTel2"	name="txtEtcTel2"	maxlength="4" size="10" value="${items.grdEtcTelCenter}"class="w_60px input_com onlyNumber">
          										-
								  				<input type="text" id="txtEtcTel3"	name="txtEtcTel3"	maxlength="4" size="10" value="${items.grdEtcTelBack}" 	class="w_60px input_com onlyNumber">
								  			</td>
										</tr>
										<tr class="indvdl">
											<th>직업</th>
								        	<td>
								        		<!--찾기 -->
								        		<div class="flex_r">
									            	<input type="text" 		id="txtOccpNm"	name="txtOccpNm" 	value="${items.grdOccpNm}"	size="50"  class="w_265px input_com" readonly="readonly">
									            	<input type="hidden" 	id="hidOccpCd"	name="hidOccpCd"	value="${items.grdOccpCd}">
								            		<input type="button" 	value="" class="btn_search"  onclick="javascript:fnCdSelectSingle('00300');">
								          		</div>
								          		<!--//찾기 폼-->
									 		</td>
								        	<th>직장명(법인명)</th>
								        	<td>
									        	<input type="text" id="txtWrcNm"	name="txtWrcNm" 	value="${items.grdWrcNm}" maxlength="50" size="50"  class="w_265px input_com">
									        </td>
										</tr>
										<tr class="indvdl">
											<th>직장 주소지</th>
								        	<td colspan="3">
								        		<div class="flex_r">
									        		<input type="text" 	id="txtWrcZip"		name="txtWrcZip" 	value="${items.grdWrcZip}"	class="w_80px input_com mr_5" size="10" maxlength="10">
								          			<input type="text"	id="txtWrcAddr"		name="txtWrcAddr" 	value="${items.grdWrcAddr}"	maxlength="50" size="50"  class="w_m85p input_com">
								          			<input type="button"id="Wrc" 			class="btn_search"	onclick="javascript:fnZipPopConnect(this)">
								        		</div>
								        	</td>
										</tr>
										<tr>
											<th>주소지</th>
											<td colspan="3">
												<div class="flex_r">
										    		<input type="text"	id="txtAdresZip"	name="txtAdresZip"		value="${items.grdAdresZip}"	maxlength="10" size="10"  	class="w_80px input_com mr_5">
										    		<input type="text"	id="txtAdresAddr" 	name="txtAdresAddr" 	value="${items.grdAdresAddr}"	maxlength="50" size="50"	class="w_m85p input_com">
										    		<input type="button"id="Adres" 			class="btn_search"		onclick="javascript:fnZipPopConnect(this)">
										    	</div>
											</td>
										</tr>
										<tr class="indvdl">
											<th>등록지</th>
								        	<td colspan="3">
								        		<div class="flex_r">
									        		<input type="text" 	id="txtRegbsZip"	name="txtRegbsZip" 		value="${items.grdRegbsZip}"	class="w_80px input_com mr_5" size="10" maxlength="10">
								          			<input type="text" 	id="txtRegbsAddr"	name="txtRegbsAddr" 	value="${items.grdRegbsAddr}"	maxlength="50" size="50"  class="w_m85p input_com">
								          			<input type="button"id="Regbs" 			class="btn_search"		onclick="javascript:fnZipPopConnect(this)">
								        		</div>
								        	</td>
										</tr>
										<!-- 2021-04-27 hsno 주거 Text 주석처리 -->
										<%-- <tr class="indvdl">
											<th>주거지</th>
											<td colspan="3">
												<div class="flex_r">
											    	<input type="text"	id="txtDwlsitZip"	name="txtDwlsitZip"		value="${items.grdDwlsitZip}" 	maxlength="10" size="10" class="w_80px input_com mr_5">
											    	<input type="text"	id="txtDwlsitAddr"	name="txtDwlsitAddr"	value="${items.grdDwlsitAddr}" 	maxlength="50" size="50" class="w_m85p input_com">
											    	<input type="button"id="Dwlsit" 		class="btn_search"		onclick="javascript:fnZipPopConnect(this)">
										    	</div>
											</td>
										</tr> --%>
										<tr>
											<th>이메일</th>
											<td >
												<input type="text" id="txtEmail" 	name="txtEmail" 	maxlength="20" size="10" value="${items.grdEmail}" 	class="w_150px input_com ">
											</td>
											<th>직급</th>
											<td>
												<input type="text" id="txtClsf" 	name="txtClsf" 	maxlength="20" size="10" value="${items.grdClsf}" 	class="w_150px input_com ">
											</td>
										</tr>
										<tr class="indvdl">
											<th>여권번호 </th>
											<td>
												<input type="text"id="txtPasportNo" name="txtPasportNo"	value="${items.grdPasportNo}" maxlength="9" size="50"  class="w_100px input_com notHangul">
											</td>
											<th>국적 </th>
											<td>
												<input type="text" 		id="txtNltyNm" 	name="txtNltyNm"	value="${items.grdNltyNm}" maxlength="20" size="50"  class="w_250px input_com" readonly="readonly">
												<input type="hidden"	id="hidNltyCd"	name="hidNltyCd"	value="${items.grdNltyCd}">
											    <input type="button"	id="btnNlty" 	class="btn_search">
											</td>
										</tr>
										<tr>
											<th>대리인</th>
								        	<td colspan="3">
								        		<div class="input_radio2 t_left" style="padding-top: 5px;padding-left: 19px">
							            			<input type="radio"	class="to-labelauty-icon labelauty"  name="rdoAgentSeCd"	id="rdoAgentSeCd"	value="" <c:if test="${items.grdAgentSeCd eq ''}">checked</c:if>>
							            			<label for="rdoAgentSeCd">
							            				<span class="labelauty-unchecked-image"></span>
							            				<span class="labelauty-checked-image"></span>
							            			</label>
							            			없음
							            		</div>
								        		<div class="input_radio2 t_left" style="padding-top: 5px;padding-left: 19px;">
								            		<input type="radio"	class="to-labelauty-icon labelauty"  name="rdoAgentSeCd"	id="rdoAgentSeCdC"	value="C" <c:if test="${items.grdAgentSeCd eq 'C'}">checked</c:if>>
								            		<label for="rdoAgentSeCdC">
								            			<span class="labelauty-unchecked-image"></span>
								            			<span class="labelauty-checked-image"></span>
								            		</label>
							            			변호인<!-- Counsel -->
							            		</div>
							            		<div class="input_radio2 t_left" style="padding-top: 5px;padding-left: 19px;padding-right: 10px;">
							            			<input type="radio"	class="to-labelauty-icon labelauty"	name="rdoAgentSeCd"	id="rdoAgentSeCdM"	value="M" <c:if test="${items.grdAgentSeCd eq 'M'}">checked</c:if>>
							            			<label for="rdoAgentSeCdM">
							            				<span class="labelauty-unchecked-image"></span>
							            				<span class="labelauty-checked-image"></span>
							            			</label>
							            			위임인<!-- Mandator -->
							            		</div>
							            		<div id="divAgent" class="flex_r"style="width: 500px;">
								            		<div class="flex_r" style="width: 180px;">
										        		성명 :&nbsp;
										        		<input type="text" id="txtAgentNm"	name="txtAgentNm"		value="${items.grdAgentNm}" maxlength="20" size="20"  class="w_120px input_com">
								            		</div>
								            		<div class="flex_r" style="width: 300px;">
											        	전화번호 :&nbsp;
											        	<select id="selAgentTel1"	name="selAgentTel1" size="1" class="w_80px input_com notHangul">
											          		<option value="" selected="selected">=선택=</option>
											          		<c:forEach var="cd" items="${telofcnoCdList}">
																<option value="${cd.cdNm}" <c:if test="${cd.cdNm eq items.grdAgentTelFront}">selected</c:if> ><c:out value="${cd.cdNm}" /></option>
															</c:forEach>
		        										</select>
		          										&nbsp;-
		  												<input type="text" id="txtAgentTel2"	name="txtAgentTel2"	maxlength="4" size="10" value="${items.grdAgentTelCenter}"class="w_60px input_com onlyNumber">
		          										-
										  				<input type="text" id="txtAgentTel3"	name="txtAgentTel3"	maxlength="4" size="10" value="${items.grdAgentTelBack}" 	class="w_60px input_com onlyNumber">
										        	</div>
									        	</div>
									        </td>
										</tr>
						    		</tbody>
								</table><!-- //대상자 정보 입력 table -->
							</div>
						</div>
					</div>
				</div>
    		</div><!-- // tabT 사건접수 종료 -->
    	</form>
	</div>

</div>