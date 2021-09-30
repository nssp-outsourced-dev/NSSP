<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/inc/header.jsp" />
<script type="text/javascript" src="/js/validate/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/rc.common.js"></script>
<script type="text/javascript" src="/js/rc.validate.js"></script>
<style>
	.trHeight {
		height: 35px;
	}
</style>
<script type="text/javascript">

var myGridID = "#grid_wrap";

	$(function() {

		$(document).ready(function(){

			$('#hidRcNo').val( $('#hidRcNo', parent.document).val() );
			$('#hidCaseNo').val( $('#hidCaseNo', parent.document).val() );

			initGrid();		//그리드 초기화

		});


		//입력/수정 동시 사용을 위한 구분 코드
		$("input[name=rcSectionCd]").click(function(e){

			if( $(this).val() == "정식"){
				$("#alotUserId").prop('disabled', true);
				$("#alotUserId").val("");
				$("#alotUserNm").prop('disabled', true);
				$("#alotUserNm").val("");
			} else {
				$("#alotUserId").prop('disabled', true);
				$("#alotUserId").val("");
				$("#alotUserNm").prop('disabled', true);
				$("#alotUserNm").val("");
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
	});	// jQuery

	//사건정보 저장

	// addRowFinish 이벤트 핸들링
	function auiAddRowHandler(event) {
		// 행 추가 시 추가된 행에 선택자가 이동합니다.
		// 이 때 칼럼은 기존 칼럼 그래도 유지한채 이동함.
		// 원하는 칼럼으로 선택자를 보내 강제로 편집기(inputer) 를 열기 위한 코드
		var selected = AUIGrid.getSelectedIndex(myGridID);
		if(selected.length <= 0) {
			return;
		}

		var rowIndex = selected[0];
		var colIndex = AUIGrid.getColumnIndexByDataField(myGridID, "name");
		AUIGrid.setSelectionByIndex(myGridID, rowIndex, colIndex); // name 으로 선택자 이동

		// 빈행 추가 후 isbn 에 인푸터 열기
		AUIGrid.openInputer(myGridID);
	};


	// field enabled, disabled 전환
	function elementsDisabled(disabled) {
		var elementArr = ["input", "select"];
		$(elementArr).each(function(idx, element) {
			$("#addForm " + element + ":visible").each(function() {
				$(this).attr("disabled", disabled);
			});
		})
		// 예외 항목
		$("#userId").attr("disabled", false);
	}

	//그리드 초기화
	function initGrid() {

		//컬럼정보 설정
		var columnLayout = [
			  { dataField : "grdTrgterGroup"	, headerText : "대상자그룹"		, width   : 90
				 ,renderer : {type : "TemplateRenderer"}
			,labelFunction : function( rowIndex, columnIndex, value, headerText, item ){


								if( "suspct-Group" == value ){
									if( "F" == item.grdRcSeCd ){
				  				  	    return "피의자 등";
									} else if( "I" == item.grdRcSeCd ){
				  				  	    return "피내사자 등";
									} else if( "T" == item.grdRcSeCd ){
				  				  	    return "혐의자 등";
									}
				  				} else if( "accs-Group" == value ){
				  				  		return "고발인 등";
				  				}
							 }
			  }
			, { dataField : "grdTrgterSeNm"		, headerText : "대상자구분"		, width   : 90	 }
			, { dataField : "grdTrgterClNm"		, headerText : "대상자 분류"	, visible : false}
			, { dataField : "grdTrgterNm"	 	, headerText : "성명"			, width   : 100	 }
			, { dataField : "grdTrgterTyNm"		, headerText : "유형"			, visible : true , width   : 45}
			, { dataField : "grdTrgterSeCd"		, headerText : "구분"			, visible : false}
			, { dataField : "grdTrgterClCd"		, headerText : "대상자 분류"	, visible : false}
			, { dataField : "grdTrgterTyCd"		, headerText : "대상자 분류"	, visible : false}
			, { dataField : "grdTrgterEngNm"	, headerText : "성명(영문)"	, visible : false}
			, { dataField : "grdSexdstnNm"		, headerText : "성별"			, visible : false}
			, { dataField : "grdTrgterRrn"		, headerText : "주민등록번호"	, visible : false}
			, { dataField : "grdTrgterAge"		, headerText : "나이"			, visible : false}
			, { dataField : "grdHpNo"	 		, headerText : "휴대전화"		, visible : false}
			, { dataField : "grdOwnhomTel"		, headerText : "자택전화"		, visible : false}
			, { dataField : "grdWrcTel"	 		, headerText : "직장전화"		, visible : false}
			, { dataField : "grdEtcTel"	 		, headerText : "기타연락처"		, visible : false}
			, { dataField : "grdOccpCd"	 		, headerText : "직업"			, visible : false}
			, { dataField : "grdOccpNm"	 		, headerText : "직업명"		, visible : false}
			, { dataField : "grdWrcNm"	 		, headerText : "직장명"		, visible : false}
			, { dataField : "grdWrcZip"	 		, headerText : "직장 우편번호"	, visible : false}
			, { dataField : "grdWrcAddr"	 	, headerText : "직장 주소"		, visible : false}
			, { dataField : "grdAdresZip"	 	, headerText : "주소우편번호"	, visible : false}
			, { dataField : "grdAdresAddr"		, headerText : "주소지 "		, visible : false}
			, { dataField : "grdRegbsZip"	 	, headerText : "등록우편번호"	, visible : false}
			, { dataField : "grdRegbsAddr"		, headerText : "등록지"		, visible : false}
			, { dataField : "grdDwlsitZip"		, headerText : "주거지 우편번호" , visible : false}
			, { dataField : "grdDwlsitAddr"		, headerText : "주거지"		, visible : false}
			, { dataField : "grdEmail"	 		, headerText : "이메일"		, visible : false}
			, { dataField : "grdClsf"	 		, headerText : "직급"			, visible : false}
			, { dataField : "grdNltyCd"	 		, headerText : "국적"			, visible : false}
			, { dataField : "grdNltyNm"	 		, headerText : "국적명"		, visible : false}
			, { dataField : "grdPasportNo"		, headerText : "여권번호"		, visible : false}
			, { dataField : "grdDocId"	 	  	, headerText : "문서id"		, visible : false}
			, { dataField : "grdRcSeCd"	 	  	, headerText : "사건구분"		, visible : false}
		];

		//그리드 환경값 설정
		var gridPros = {
			     useGroupingPanel : false
			   , showRowNumColumn : false
			    , displayTreeOpen : true
			       , enableFilter : true
			  	  , selectionMode : "singleRow"	// 선택모드 singleCell(기본값), multipleCells, singleRow
			  	  , noDataMessage : "조회 목록이 없습니다."
	 	  	 , showRowCheckColumn : false	//gird checkbox 여부
			     , useContextMenu : false	//컨텍스트 메뉴 사용
		   , enableRightDownFocus : false	//컨텍스트 메뉴를 보기 위해 오른쪽 클릭을 한 경우 클릭 지점이 왼쪽 클릭과 같이 셀 선택을 할지 여부 기본값 : false
   , triggerSelectionChangeOnCell : true
				   , headerHeight : 30
					  , rowHeight : 30
			 , fillColumnSizeMode : true

		};

		AUIGrid.create(myGridID, columnLayout, gridPros);
		AUIGrid.bind(myGridID, "cellClick", function(event) {

			$("#targetForm")[0].reset(); //form 초기화
			//label reset
			$("#divTargetInfo").find("label").each(
			    function(index){
			    	$(this).text("");
			    }
			);
			var items = event.item;
			fn_form_bind_popup("targetForm", items ,"GRID");//fn_form_bind ("frmTtarget",items,"GRID");

			setDisplay();


		});//AUIGrid.bind cellClick end

		AUIGrid.bind("#grid_wrap", "ready", function(event) {
			var gdt = AUIGrid.getGridData(event.pid);
			if(gdt.length > 0) {
				AUIGrid.setSelectionByIndex(event.pid, 0, 5);  //최초 선택된 row 자동 상세 조회
				fn_form_bind_popup("targetForm", gdt[0], "GRID");//fn_form_bind ("frmTtarget",gdt[0],"GRID");
				setDisplay();
			}
		});

		fnMoveGridPage("/rc/getTrgterListAjax/", "targetForm", "#grid_wrap", 1);

		/*
		// 선택 체인지 이벤트 바인딩
		AUIGrid.bind(myGridID, "selectionChange", function(event) {
			var primeCell = event.primeCell; // 선택 대표 셀
			var item = primeCell.item; // 행 정보
			//setFieldToFormWindow(primeCell, item);

			alert("셀 selectionChange ");
			$("#targetForm")[0].reset(); //form reset
			fn_form_bind ("targetForm",item,"GRID");
		});
*/	
	}
	// End inint grid
	
	/*
		
	*/
	function fn_form_bind_popup(form, json, type){
		var text;
		if(json._$uid != null){
			delete json._$uid;
		}
		for(var i in json){
			if(type=="GRID") {
				var cName = (i).replace(/grd/g, "");
			} else {
				var cName = (i).charAt(0).toUpperCase() + (i).slice(1);
			}
			var inputType = $('#'+form).find("input[name='"+('txt'+cName)+"'], input[name='"+('hid'+cName)+"']," +
							"input[name='"+('rdo'+cName)+"'], input[name='"+('chk'+cName)+"']," +
							"select[name='"+('sel'+cName)+"'], textarea[name='"+('txt'+cName)+"']").prop('type');
			switch (inputType) {
			case "text":
				cName = 'txt'+cName;
				break;
			case "hidden":
				cName = 'hid'+cName;
				break;
			case "radio":
				cName = 'rdo'+cName;
				break;
			case "checkbox":
				cName = 'chk'+cName;
				break;
			case "select-one":
				cName = 'sel'+cName;
				break;
			case "textarea":
				cName = 'txt'+cName;
				break;
			default :
				cName = 'lab'+cName;
				break;
			}
			if(inputType == "text" || inputType == "hidden" ){
				/*  */
				if(cName.indexOf("Addr") > -1){
					var zip = json[i].indexOf("우");
					$('#'+form).find("input[name='"+cName+"']").val(json[i].substr(0, zip -1));
				}else{
					$('#'+form).find("input[name='"+cName+"']").val(json[i]);
				}
			}else if(inputType == "radio"){
				$('#'+form).find("input:radio[name='"+cName+"']").removeAttr('checked');
				$('#'+form).find("input:radio[name='"+cName+"']:radio[value='"+json[i]+"']").prop('checked', true);
			}else if(inputType == "checkbox"){
				$('#'+form).find("input:checkBox[name='"+cName+"']").val(json[i]);
				if(json[i] == null || json[i] == '' || json[i] =='N' ){
					$('#'+form).find("input:checkBox[name='"+cName+"']").prop('checked', false);
				}else{
					$('#'+form).find("input:checkBox[name='"+cName+"']").prop('checked', true);
				}
			}else if(inputType == "select-one"){
				$('#'+form).find("select[name='"+cName+"']").val(json[i]);
			}else if(inputType == "textarea"){
				$('#'+form).find("textarea[name='"+cName+"']").val(json[i]);
			}else{ 
				// label
				if(json[i] != null){
					text = 	$('#'+form).find("label[id='"+cName+"']").text();
					if(text != null || text == ''){
						$('#'+form).find('#'+cName).text('');
					}
					$('#'+form).find('#'+cName).text(json[i]);
				}
			}
		}
	}
	/* form binding 후 */
	function setDisplay(){
		//대상자 개인/기업에 따른 정보 분리
		if( "I" == $("#hidTrgterTyCd").val() ){			//개인
			$('.entrprs').css('display', 'none');
			$('.indvdl').css('display', '');
		} else if( "E" == $("#hidTrgterTyCd").val() ){ 	//기업
			$('.indvdl').css('display', 'none');
			$('.entrprs').css('display', '');
		}

		//대리인 있을경우 성명 전화번호 구분자 추가
		if( 0 < $("#labAgentNm").text().length ){
			$("#seAgent").text(" / ");
		}
	}
	
	//대상자 정보 수정
		function fnTrgterUpdate(){
			if( confirm("대상자정보를 수정하시겠습니까?") ){

				var iUrl = '<c:url value='/rc/updateTargetInfoAjax/'/>';
		 		var queryString =  $('#targetForm').serialize() + "&" + $('#targetBasicInfoForm').serialize();

		 		var processAfterGet = function(data) {
					if( data.result == "1" ){
						fnMoveGridPage("/rc/getTrgterListAjax/", "targetForm", "#grid_wrap", 1);
						alert("수정되었습니다.");
					} else {
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
			}
		}
</script>


<!--테이블 시작 -->
<div class="contents marginbot">
	<form id="targetBasicInfoForm" name="targetBasicInfoForm" method="post" >
		<input type="hidden" id="screenClassification" 	name="screenClassification" value="U"><!-- 화면 구분 validate 시 사용 - 작성화면 : C / 수정화면 : U -->
	</form>
	
	<input type="hidden" id="hidSelectAddress" 		name="hidSelectAddress" 	value="">
	
	<form id="targetForm">
		<input type="hidden"	id="hidRcNo" 			name="hidRcNo" 		value="${caseRcInfo.RC_NO}"> 	<!-- 접수번호 -->
		<input type="hidden" 	id="hidItivNo" 			name="hidItivNo" 	value="${caseRcInfo.ITIV_NO}">	<!-- 내사번호 -->
		<input type="hidden" 	id="hidCaseNo" 			name="hidCaseNo" 	value="${caseRcInfo.CASE_NO}">	<!-- 사건번호 -->
		<input type="hidden" 	id="hidDocId" 			name="hidDocId" 	value="${caseRcInfo.DOC_ID}">	<!-- 문서번호 -->
		<input type="hidden" 	id="hidProgrsSttusCd" 	name="hidProgrsSttusCd" 	value="${caseRcInfo.PROGRS_STTUS_CD}"> <!-- 진행상태 -->
		<input type="hidden" 	id="hidTrgterTyCd" 		name="hidTrgterTyCd" 	value=""><!-- 대상자 유형 -->
		<input type="hidden" 	id="hidTrgterSn" 		name="hidTrgterSn" 	value=""><!-- 대상자 순번 -->
		
		<input type="hidden" id="hidHpNo" 		name="hidHpNo"	   ><!-- 대상자 휴대전화	 -->
		<input type="hidden" id="hidOwnhomTel"	name="hidOwnhomTel"><!-- 대상자 자택전화	 -->
		<input type="hidden" id="hidWrcTel" 	name="hidWrcTel"   ><!-- 대상자 직장전화 	 -->
		<input type="hidden" id="hidEtcTel" 	name="hidEtcTel"   ><!-- 대상자 기타 연락처 -->
		<input type="hidden" id="hidAgentTel" 	name="hidAgentTel" ><!-- 대리인 전화번호	 -->
		<input type="hidden" id="hidTrgterRrn" 	name="hidTrgterRrn"><!-- 대리인 주민번호	 -->
			
		<div class="box_w2 mb_50 mt_10">
			<div class="box_w2_1" style="width: 320px;">
				<!-- 그리드 -->
				<div class="tb_01_box">
					<div id="grid_wrap"  class="gridResize" style="width: 100%; height: 570px; margin: 0px auto; position: relative;"></div>
				</div>
				<!-- //그리드 -->
	 		</div>

			<div class="box_w2_2" style="width: 760px;padding-left: 0px;">
				<div class="right_btn">
					<input type="button" id="btnTargetSave"	  	class="btn_st2 icon_n fl mr_m1" value="저장"	style="float: right;position: relative; margin-bottom: 5px;margin-right: 2px;">
					<!-- <input type="button" id="btnTargetDelete"	class="btn_st2 icon_n fl mr_m1" value="삭제"	style="float: right;position: relative;" > -->
				</div>
				<!--테이블 시작 -->
	 			<div class="tb_01_box"	id="divTargetInfo" >
					<table class="tb_01">
						<colgroup>
							<col width="100px">
				    		<col width="260px">
				    		<col width="100px">
				    		<col width="">
						</colgroup>
						<tbody>
				    		<tr class="trHeight">
								<th>대상자구분</th>
								<td>
									<label id="labTrgterSeNm"></label>
								</td>
								<th>대상자유형</th>
								<td>
									<label id="labTrgterTyNm"></label>
						  		</td>
							</tr>
							<tr class="trHeight">
	   							<th>성명(한글)</th>
	   							<td>
	   								<input class="w_100p input_com"	type="text" id="txtTrgterNm"	name="txtTrgterNm"  maxlength="19" size="50" ><!-- <label id="labTrgterNm"></label> -->
	   							</td>
								<th>성명(영문)</th>
								<td>
									<input type="text" 		id="txtTrgterEngNm" 	name="txtTrgterEngNm" maxlength="20" size="50"  class="w_100p input_com"><!-- <label id="labTrgterEngNm"></label> -->
								</td>
			      			</tr>
			      			<tr class="trHeight entrprs">
								<th>법인번호</th>
								<td>
								<input class="w_160px input_com"	type="text" id="txtTrgterCprn"	name="txtTrgterCprn" maxlength="16" >
								( "-" 포함 )<!-- <label id="labTrgterCprn"></label> -->
								</td>
								<th>대표자</th>
								<td>
									<input class="w_160px input_com"	type="text" id="txtRprsntvNm"	name="txtRprsntvNm"  maxlength="16" ><!-- <label id="labRprsntvNm"></label> -->
								</td>
								<!--
								<th>사업자번호</th>
						        <td>
						        	<label id="labTrgterCrn"></label>
						        </td> 
						        -->
							</tr>
							<tr class="trHeight indvdl">
								<th>주민등록번호</th>
								<td>
									<input type="text"	class="w_80px input_com onlyNumber"	id="txtTrgterRrnFront"	name="txtTrgterRrnFront" maxlength="6" size="10" onkeyup="fnTargetAgeCalculation();">
									-
									<input type="text"	class="w_80px input_com onlyNumber"	id="txtTrgterRrnEnd"	name="txtTrgterRrnEnd" maxlength="7" size="10" onkeyup="fnTargetAgeCalculation();"><!-- <label id="labTrgterRrn"></label> -->
								</td>
								<th>나이 </th>
								<td>
									<input type="text"	class="w_50px input_com onlyNumber"	id="txtTrgterAge"		name="txtTrgterAge"  		maxlength="3"	size="50" > (만)세<!-- <label id="labTrgterAge"></label> -->
								</td>
							</tr>
							<tr class="trHeight indvdl">
	   							<th>대상자분류</th>
						      	<td>
						      		<label id="labTrgterClNm"></label>
						  		</td>
								<th>성별</th>
					        	<td>
					        		<label id="labSexdstnNm"></label>
			            		</td>

							</tr>
	 						<tr class="trHeight indvdl">
	   							<th>휴대전화</th>
				       			<td>
				       				<select	class="w_80px input_com"	id="selHpNo1"	name="selHpNo1" size="1" >
										<option value="" selected="selected">=선택=</option>
										<c:forEach var="cd" items="${hpNoCdList}">
											<option value="${cd.cdNm}"><c:out value="${cd.cdNm}" /></option>
										</c:forEach>
					       			</select>
					       			&nbsp;-
					       			<input type="text"	class="w_60px input_com onlyNumber"	id="txtHpNo2" 	name="txtHpNo2"	maxlength="4" size="10" >
					         		-
					 				<input type="text"	class="w_60px input_com onlyNumber"	id="txtHpNo3"	name="txtHpNo3"	maxlength="4" size="10" >
								    <!-- <label id="labHpNo"></label> -->
				 				</td>
					        	<th>자택전화</th>
					        	<td>
					        		<select class="w_80px input_com"	id="selOwnhomTel1"	name="selOwnhomTel1" size="1" >
										<option value="" selected="selected">=선택=</option>
										<c:forEach var="cd" items="${telofcnoCdList}">
											<option value="${cd.cdNm}"><c:out value="${cd.cdNm}" /></option>
										</c:forEach>
									</select>
									&nbsp;-
									<input type="text"	class="w_60px input_com onlyNumber"	id="txtOwnhomTel2"	name="txtOwnhomTel2"	maxlength="4" size="10" value="${items.grdOwnhomTelCenter}">
									-
									<input type="text"	class="w_60px input_com onlyNumber"	id="txtOwnhomTel3"	name="txtOwnhomTel3"	maxlength="4" size="10" value="${items.grdOwnhomTelBack}"  >
					        		<!-- <label id="labOwnhomTel"></label> -->
								</td>
						    </tr>
							<tr class="trHeight">
								<th>직장전화 </th>
								<td>
									<select class="w_80px input_com"	id="selWrcTel1"	name="selWrcTel1" size="1" >
										<option value="" selected="selected">=선택=</option>
										<c:forEach var="cd" items="${telofcnoCdList}">
											<option value="${cd.cdNm}"><c:out value="${cd.cdNm}" /></option>
										</c:forEach>
									</select>
									&nbsp;-
									<input type="text" id="txtWrcTel2"	name="txtWrcTel2" 	size="10"  class="w_60px input_com onlyNumber" maxlength="4">
									-
									<input type="text" id="txtWrcTel3"	name="txtWrcTel3"  	size="10"  class="w_60px input_com onlyNumber" maxlength="4"><!-- <label id="labWrcTel"></label> -->
								</td>
								<th>기타연락처 </th>
								<td>
									<select id="selEtcTel1"	name="selEtcTel1" size="1" class="w_80px input_com notHangul">
										<option value="" selected="selected">=선택=</option>
										<c:forEach var="cd" items="${telofcnoCdList}">
											<option value="${cd.cdNm}"><c:out value="${cd.cdNm}" /></option>
										</c:forEach>
									</select>
									&nbsp;-
									<input type="text" id="txtEtcTel2"	name="txtEtcTel2"	maxlength="4" size="10" class="w_60px input_com onlyNumber">
        							-
									<input type="text" id="txtEtcTel3"	name="txtEtcTel3"	maxlength="4" size="10" class="w_60px input_com onlyNumber"><!-- <label id="labEtcTel"></label> -->
						  		</td>
							</tr>
							<tr class="trHeight indvdl">
								<th>직업</th>
								<td>
									<!--찾기 -->
									<div class="flex_r">
										<input type="text" 		id="txtOccpNm"	name="txtOccpNm" 	size="50"  class="w_265px input_com" readonly="readonly">
											<input type="hidden" 	id="hidOccpCd"	name="hidOccpCd" >
											<input type="button" 	value="" class="btn_search"  onclick="javascript:fnCdSelectSingle('00300');">
									</div>
									<!--//찾기 폼-->
									<!-- <label id="labOccpNm"></label> -->
								</td>
									<th>직장명</th>
								<td>
									<input type="text" id="txtWrcNm"	name="txtWrcNm"  maxlength="50" size="50"  class="w_100p input_com"><!-- <label id="labWrcNm"></label> -->
								</td>
							</tr>
							<tr class="trHeight indvdl">
								<th>직장 주소지</th>
								<td colspan="3">
									<div class="flex_r">
										<input type="text" 	id="txtWrcZip"		name="txtWrcZip" 	class="w_80px input_com mr_5" size="10" maxlength="10">
										<input type="text"	id="txtWrcAddr"		name="txtWrcAddr" 	maxlength="50" size="50"  class="w_m85p input_com">
										<input type="button"id="Wrc" 			class="btn_search"	onclick="javascript:fnZipPopConnect(this)">
									</div>
									<!-- <label id="labWrcZip"></label>
									<label id="labWrcAddr"></label> -->
								</td>
							</tr>
							<tr class="trHeight">
								<th>대리인구분</th>
						       	<td>
						       		<label id="labAgentSeNm"></label>
							 	</td>
						        <th style="width: 75px;padding-top: 0px;padding-bottom: 0px;">대리인 성명/연락처</th>
						        <td>
						        	<label id="labAgentNm"></label>
						        	<span id="seAgent"></span>
						        	<label id="labAgentTel"></label>
						        </td>
							</tr>

							<tr class="trHeight">
								<th>주소지</th>
								<td colspan="3">
									<div class="flex_r">
										<input type="text"	id="txtAdresZip"	name="txtAdresZip"	maxlength="10" size="10"  	class="w_80px input_com mr_5">
										<input type="text"	id="txtAdresAddr" 	name="txtAdresAddr" maxlength="50" size="50"	class="w_m85p input_com">
										<input type="button"id="Adres" 			class="btn_search"	onclick="javascript:fnZipPopConnect(this)">
									</div>
									<!-- <label id="labAdresZip"></label>
									<label id="labAdresAddr"></label> -->
								</td>
							</tr>
							<tr class="trHeight indvdl">
								<th>등록지</th>
					        	<td colspan="3">
					        		<!-- <div class="flex_r">
										<input type="text" 	id="txtRegbsZip"	name="txtRegbsZip" 		class="w_80px input_com mr_5" size="10" maxlength="10">
										<input type="text" 	id="txtRegbsAddr"	name="txtRegbsAddr" 	maxlength="50" size="50"  class="w_m85p input_com">
										<input type="button"id="Regbs" 			class="btn_search"		onclick="javascript:fnZipPopConnect(this)">
									</div> -->
					        		<label id="labRegbsZip"></label>
					        		<label id="labRegbsAddr"></label>
					        	</td>
							</tr>
							
							<!-- 2021-04-28 hsno 주거지 테이블 주석처리 -->
							<!-- <tr class="trHeight indvdl">
								<th>주거지</th>
								<td colspan="3">
									<label id="labDwlsitZip"></label>
									<label id="labDwlsitAddr"></label>
								</td>
							</tr> -->
							<tr class="trHeight">
								<th>이메일</th>
								<td>
									<input type="text" id="txtEmail" 	name="txtEmail" 	maxlength="20" size="10" class="w_150px input_com ">
									<!-- <label id="labEmail"></label> -->
								</td>
								<th>직급</th>
								<td>
									<input type="text" id="txtClsf" 	name="txtClsf" 	maxlength="20" size="10" class="w_150px input_com ">
									<!-- <label id="labClsf"></label> -->
								</td>
							</tr>
							<tr class="trHeight indvdl">
								<th>여권번호 </th>
								<td>
									<input type="text"id="txtPasportNo" name="txtPasportNo" maxlength="9" size="50"  class="w_100px input_com notHangul">
									<!-- <label id="labPasportNo"></label> -->
								</td>
								<th>국적 </th>
								<td>
									<input type="text" 		id="txtNltyNm" 	name="txtNltyNm"  maxlength="20" size="50"  class="w_200px input_com" readonly="readonly">
									<input type="hidden"	id="hidNltyCd"	name="hidNltyCd" >
									<input type="button"	id="btnNlty" 	class="btn_search">
									<!-- <label id="labNltyNm"></label> -->
								</td>
						  	</tr>
			    		</tbody>
					</table><!-- //대상자 정보 입력 table -->
				</div>
			</div>
		</div>
	</form>
</div>
