<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">
var docNo = "00457";	/*압수/수색*/
$(function() {
	fnTopLst ();
	fnRealDatePicker("txtReqstDe","divCal6");
	fnRealDateTimePicker("txtReqValidDt","divCal1");
	fnRealDateTimePicker("txtReqExcutDt","divCal2");
	fnRealDateTimePicker("txtRstValidDt","divCal3");
	fnRealDateTimePicker("txtIsueDt","divCal4");
	fnRealDateTimePicker("txtRstExcutDt","divCal5");
	initGrid ();
	fnDoc ("","");
	$(".szReqD1").hide();
	$(".szReqD2").hide();
});
function fnTopLst () {
	$("#show").click(function(){
        $("#showinbox").show();
		 $("#show").hide();
		 $("#hide").show();
		 AUIGrid.resize("#gridT1_wrap");
		 AUIGrid.resize("#gridT2_wrap");
    });
    $("#hide").click(function(){
        $("#showinbox").hide();
		 $("#show").show();
		 $("#hide").hide();
    });
}
function fnDoc (pDocId, pParam) {
	fnReportList('ifrReport',pDocId,docNo,pParam);
}
function initGrid () {
	var szureZrlongLst = [<c:forEach var="cd" items="${szureZrlongLst}" varStatus="status">{"cd":"${cd.cd}","cdNm":"${cd.cdNm}"},</c:forEach>];
	var zrlongReqstLst = [{"cd":"Y","cdNm":"신청완료"},{"cd":"N","cdNm":"신청취소"}];
	var reqstResultLst = [{"cd":"Y","cdNm":"가"},{"cd":"N","cdNm":"부"}];
	var columnLayoutT1 = [
				{ dataField : "grdCaseNo",      headerText : "사건번호", 	width : 120 },
				{ dataField : "grdPrsctDe",   	headerText : "입건일자", 	width : 130, dataType : "date", formatString : "yyyy-mm-dd"},
				{ dataField : "grdInvProvisNm",	headerText : "수사단서",	width : 100 },
				{ dataField : "grdTrgterNmS",	headerText : "피의자 성명",  width : 120 },
   				{ dataField : "grdVioltNm",		headerText : "위반죄명" },
                ];
	var columnLayoutT2 = [
				{ dataField : "grdTrgterSn",   	headerText : "대상자일련번호", 	visible : false},
                { dataField : "grdCaseNo",      headerText : "사건번호" },
                { dataField : "grdPrsctDe",   	headerText : "입건일자", 		dataType : "date", formatString : "yyyy-mm-dd"},
                { dataField : "grdTrgterNm",    headerText : "피의자명", 		style:'tbLft'},
                { dataField : "grdTrgterRrn",   headerText : "주민번호" }
                ];
	var columnLayoutR = [
				{ dataField : "grdTrgterSn",   		headerText : "대상자일련번호", 	visible : false},
                { dataField : "grdCaseNo",      	headerText : "사건번호", 		visible : false },
                { dataField : "grdZrlongNo",   		headerText : "영장번호", 		visible : false },
                { dataField : "grdZrlongReqstNo",   headerText : "영장신청번호" },
                { dataField : "grdSzureZrlongCd",   headerText : "영장구분",
                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
            			return gridComboLabel(szureZrlongLst, value)
            		}
                },
                { dataField : "grdZrlongReqstYn", 	headerText : "신청여부",
                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
            			return gridComboLabel(zrlongReqstLst, value)
            		}
                },
                { dataField : "grdReqstResultYn", 	headerText : "신청결과",
                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
            			return gridComboLabel(reqstResultLst, value)
            		}
                }];
	var gridPros = {
		displayTreeOpen : true,
		rowNumHeaderText:"순번",
		selectionMode : "singleRow",	// 선택모드 (기본값은 singleCell 임)
		//noDataMessage:"조회 목록이 없습니다.",
		headerHeight : 30,
		rowHeight: 30
	};
	AUIGrid.create("#gridT1_wrap",columnLayoutT1,gridPros);
	AUIGrid.create("#gridT2_wrap",columnLayoutT2,gridPros);
	AUIGrid.create("#gridR_wrap",columnLayoutR,gridPros);

	AUIGrid.bind("#gridT2_wrap", "cellDoubleClick", function(event) {
		var items = event.item;
		fnGridDtlList (items);
	});
	AUIGrid.bind("#gridR_wrap", "cellDoubleClick", function(event) {
		var items = event.item;
		fnSzureDtlList (items);
	});
	AUIGrid.bind("#gridT1_wrap", "cellDoubleClick", function(event) {
		var items = event.item.grdCaseNo.split("-");
		if(items != null && items.length == 2) {
			$("#searchCaseNo1").val(items[0]);
			$("#searchCaseNo2").val(items[1]);
			fnT2Search ();
		} else {
			alert("사건번호가 확인되지 않습니다.");
		}
	});
	//기본 조회
	fnT1Search();
}
function fnT1Search () {
	fnSearchGrid("/inv/zrlongCaseListAjax/", "searchForm", "#gridT1_wrap");
}
function fnT2Search () {
	fnSearchGrid ("/inv/suspectSzureListAjax/", "searchForm", "#gridT2_wrap");
}
function fnSzureDtlList (items) {
	fnReset (2);
	if(fnChkKey("조회",1,'S')) {
		//tab1
		fn_form_bind ("reqDtlForm",items,"GRID");
		$("#hidReqCudType").val("U");
		//긴급, 계좌 유무에 따른 정보
		fnSzrlSeClk (items.grdSzureZrlongCd);

		//영장신청일
		fn_form_bind ("trgterInfoForm",items,"GRID");

		//tab2
		fn_form_bind ("rstDtlForm",items,"GRID");
		if(fnIsEmpty(items.grdZrlongNo)) {
			$("#hidrstCudType").val("C");
		} else {
			$("#hidrstCudType").val("U");
		}

		//doc
		fnDoc(items.grdDocId,"P_CASE_NO="+items.grdCaseNo+"&P_TRGTER_SN="+items.grdTrgterSn+"&P_ZRLONG_REQST_NO="+items.grdZrlongReqstNo+"&P_ZRLONG_NO="+items.grdZrlongNo);
	}
}
function fnGridDtlList (items) {
	//체포목록 조회
	fnReset (1);
	$("input[name='hidCaseNo']").val(items.grdCaseNo);
	$("input[name='hidTrgterSn']").val(items.grdCaseTrgterSn);
	if(fnChkKey("조회",1,'S')) {
		fnSearchGrid ("/inv/szureListAjax/", "szureForm", "#gridR_wrap");
		fn_form_bind ("trgterInfoForm",items,"GRID");
	}
}
function fnChkKey (pMsg, pType, pSe) {
	if(fnIsEmpty($("#szureForm").find("#hidsearchCaseNo").val())||fnIsEmpty($("#szureForm").find("#hidsearchTrgterSn").val())) {
		alert("상단 좌측 피의자를 선택 후 "+pMsg+"해 주세요.");
		return false;
	}
	if(pSe == 'D') {
		if(fnIsEmpty($("#reqDtlForm").find("#hidReqZrlongReqstNo").val())) {
			alert("상단 우측 체포/구속영장신청 현황을 선택 후 "+pMsg+"해 주세요.");
			return false;
		}
	}
	if(pType == 2) {
		if(fnIsEmpty($("#rstDtlForm").find("#hidrstZrlongReqstNo").val())) {
			alert("상단 우측 체포/구속영장신청 현황을 선택 후 "+pMsg+"해 주세요.");
			return false;
		}
		if(pSe == 'D') {
			if(fnIsEmpty($("#rstDtlForm").find("#hidrstZrlongNoOrg").val())) {
				alert("구속영장 신청 결과가 없습니다. 신청 결과 여부를 다시 확인하여 주시기 바랍니다.");
				return false;
			}
		}
	}
	return true;
}
function fnReset (pType) {
	$("#reqDtlForm").clearForm ();
	$("#rstDtlForm").clearForm ();
	$(".dtlRs").val("");
	$("input[name='hidCudType']").val("C");
	if(pType == 1) {
		$("#trgterInfoForm").clearForm ();
		$("#szureForm").clearForm ();
		AUIGrid.setGridData("#gridR_wrap", []);
	}
}
function fnSearchKeyUp (event) {
	if (event.which == 13) {
		event.keyCode = 0;
		fnSearch ();
	}
}
function fnSearch () {
	if(fnIsEmpty($("#searchTrgterNm").val())&&(fnIsEmpty($("#searchTrgterRrn1").val())||fnIsEmpty($("#searchTrgterRrn2").val()))&&
			(fnIsEmpty($("#searchCaseNo1").val())||fnIsEmpty($("#searchCaseNo2").val()))) {
		alert ("조회조건은 필수 입니다.\n\n(피의자명, 주민등록번호, 사건번호 중 입력)");
		$("#searchCaseNo1").focus();
		return;
	}
	//대상자 정보
	fnReset (1);
	fnT2Search ();
}
function fnAdd () {
	//우선 reset 부터
	fnReset (2);
	if(!fnChkKey("추가",1,'A')) return;
}
function fnSave () {
	//활성 tab 확인
	var tab1 = $("#tab1").hasClass("current");
	if(tab1) {
		//신청내역 저장
		if(!fnChkKey("영장을 신청",1,'S')) return;
		$("#hidReqCaseNo").val($("#hidsearchCaseNo").val());
		$("#hidReqTrgterSn").val($("#hidsearchTrgterSn").val());
		if(fnFormValueCheck("reqDtlForm") && fnFormValueCheck("trgterInfoForm")){
			if(confirm("압수/수색/검증영장을 신청하시겠습니까?")) {
				fnLajax ("saveSzureAjax","SAVE","reqDtlForm", $("#hidReqCudType").val());
			}
		}
	} else {
		//신청결과 저장
		if(!fnChkKey("영장 신청결과를 저장",2,'S')) return;
		$("#hidrstCaseNo").val($("#hidsearchCaseNo").val());
		$("#hidrstTrgterSn").val($("#hidsearchTrgterSn").val());
		if(fnFormValueCheck("rstDtlForm")){
			if(confirm("압수/수색/검증영장 신청 결과를 저장 하시겠습니까?")) {
				fnLajax ("saveSzureRstAjax","SAVE","rstDtlForm", $("#hidrstCudType").val());
			}
		}
	}
}
function fnDel () {
	//활성 tab 확인
	var tab1 = $("#tab1").hasClass("current");
	if(tab1) {
		if(!fnChkKey("영장을 삭제",1,'D')) return;
		//결과가 나왔다면???
		if(!fnIsEmpty($("#rstDtlForm").find("#hidrstZrlongNo").val())) {
			if(!confirm("신청이 완료된 압수/수색/검증 영장입니다. \n\n삭제하시겠습니까?")) return;
		} else {
			if(!confirm("압수/수색/검증 영장 신청을 취소하시겠습니까?")) return;
		}
		$("#hidReqCudType").val("D");
		fnLajax ("saveSzureAjax","DEL","reqDtlForm","D");
	} else {
		if(!fnChkKey("영장 신청결과를 삭제",2,'D')) return;
		if(!confirm("압수/수색/검증 영장 신청 결과를 취소하시겠습니까?")) return;
		$("#hidrstCudType").val("D");
		fnLajax ("saveSzureRstAjax","DEL","rstDtlForm","D");
	}
}
function fnSzrlSeClk (pVal) {
	//00791 > 긴급
	//00792 > 금융계좌추적
	if(pVal == '00791') {
		$(".szReqD1").show();
		$(".szReqD2").hide();
	} else if (pVal == '00792') {
		$(".szReqD1").hide();
		$(".szReqD2").show();
	} else {
		$(".szReqD1").hide();
		$(".szReqD2").hide();
	}
}
function fnLajax (sUrl, type, pForm, pCudType) {
	if(type == 'SAVE') {
		if(fnIsEmpty(pCudType)||pCudType=="D") {
			fnReset (2);
			alert("ERROR");
			return;
		}
	}
	var param = $('#'+pForm).serialize();
	    param += ("&"+ $('#trgterInfoForm').serialize()); //영장신청일

	var processAfterGet = function(data) {
		if(type == "SAVE" || type == "DEL") {
			if(!fnIsEmpty(data.rst)) {
				if(!fnIsEmpty(data.rst["ERROR"])) {
					alert(data.rst["ERROR"]);
				} else {
					if(type=="DEL") {
						alert("삭제되었습니다.");
					} else {
						alert("저장되었습니다.");
					}
				}
			} else {
				alert("오류 발생!");
			}
			AUIGrid.setGridData("#gridR_wrap", data.list);
			fnAdd ();
		}
	}
	Ajax.getJson("<c:url value='/inv/"+sUrl+"/'/>", param, processAfterGet);
}
function fnSend (pType) {
	$("#hidsendCaseNo").val($("#hidsearchCaseNo").val());
	$("#hidsendTrgterSn").val($("#hidsearchTrgterSn").val());
	if(fnIsEmpty($("#hidsendCaseNo").val())) {
		$("#hidsendCaseNo").val($("#searchCaseNo1").val()+"-"+$("#searchCaseNo2").val());
	}
	if(pType == 1) {	/*압수수색*/
		$('#sendForm').attr('action', '<c:url value='/inv/zrlong/'/>');
	} else {			/*통신사실확인허가신청*/
		$('#sendForm').attr('action', '<c:url value='/inv/commnManage/'/>');
	}
	$('#sendForm').submit();
}
</script>
<form id="sendForm">
	<input type="hidden" id="hidsendCaseNo" name="hidsendCaseNo"/>
	<input type="hidden" id="hidsendTrgterSn" name="hidsendTrgterSn"/>
</form>
<!-- 상단 조회 -->
<div class="sh_box">
	<button id="hide" class="showbtn"></button>
	<button id="show" class="hidebtn" style="display: none"></button>
	<div class="show_in" id="showinbox">
		<div class="box_w2">
			<!---------- 왼쪽테이블  ---------------->
			<div class="box_w2_1b_ov" style="height: 200px;">
				<!--테이블 시작 -->
				<div class="com_box">
					<div id="gridT1_wrap" class="gridResize tb_01_box" style="width: 100%; height: 190px;"></div>
				</div>
			</div>
			<!---------- //왼쪽테이블  ---------------->
			<!---------- 오른쪽테이블 ---------------->
			<div class="box_w2_2b_ov">
				<!--테이블 시작 -->
				<div class="com_box">
					<div id="gridT2_wrap" class="gridResize tb_01_box" style="width: 100%; height: 190px;"></div>
				</div>
			</div>
			<!---------- //오른쪽테이블---------------->
		</div>
	</div>
</div>
<!-- //상단 조회 -->
<div class="search_box mb_10">
	<form id="searchForm">
		<div class="search_in">
	   		<div class="stitle w_80px">피의자명</div>
		 	<input type="text" class="w_100px input_com" id="searchTrgterNm" name="searchTrgterNm" onkeyup="fnSearchKeyUp(event)">
		 </div>
		 <div class="search_in">
			<div class="stitle w_120px">주민등록번호</div>
			<div class="r_box">
				<input type="text" class="w_100px input_com" id="searchTrgterRrn1" name="searchTrgterRrn1" onkeyup="fnRemoveChar(event)">-
				<input type="text" class="w_100px input_com" id="searchTrgterRrn2" name="searchTrgterRrn2" onkeyup="fnRemoveChar(event)">
			</div>
		</div>
		<div class="search_in">
   			<div class="stitle w_80px" style="width: 80px; margin-bottom: 5px;">사건번호</div>
	 		<div class="r_box">
				<input type="text" class="w_100px input_com" id="searchCaseNo1" name="searchCaseNo1" onkeyup="fnRemoveChar(event)"> -
				<input type="text" class="w_100px input_com" id="searchCaseNo2" name="searchCaseNo2" onkeyup="fnEnterKeyUp(event)">
			</div>
		</div>
		<div class="go_search2" onclick="fnSearch()">검색</div>
	</form>
</div>
<!--//검색박스 -->
<!-- main tab -->
<div class="tabnbtn_box mb_10" id="tab_box">
	<ul class="tabs">
		<li id="mTab1" onclick="fnSend(1)">체포/구속</li>
		<li id="mTab2" class="current">압수수색검증</li>
		<li id="mTab3" onclick="fnSend(3)" style="width: 180px;">통신사실확인허가신청</li>
	</ul>
</div>
<div class="contents marginbot" id="mTab_list">
	<!---------- 압수수색--------->
	<div id="mContent2" class="tabscontent">
		<div class="box_w2 mb_10">
			<!--------------- 피의자 조회--------------->
			<div class="box_w2_1b" style="margin-top: 7px;">
				<div class="title_s_st2 w_50p fl">
					<img src="/img/title_icon1.png" alt="" />압수/수색/검증영장신청 현황
				</div>
				<!--테이블 시작 -->
				<form id="szureForm">
					<input type="hidden" name="hidCaseNo" id="hidsearchCaseNo"/>
					<input type="hidden" name="hidTrgterSn" id="hidsearchTrgterSn"/>
				</form>
				<div class="com_box">
					<div id="gridR_wrap" class="gridResize tb_01_box" style="width: 100%; height: 200px;"></div>
				</div>
			</div>
			<!--------------- //피의자 조회--------------->
			<!--------------- 압수/수색/검증영장신청 현황-------------->
			<div class="box_w2_2b">
				<!--테이블 시작 -->
				<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%" height="250px"></iframe>
			</div>
			<!--------------- //압수/수색/검증영장신청 현황-------------->
		</div>
		<!-- //가로2칸 -->
		<!---텝영역---->
		<div id="tabsholder">
			<div class="tabnbtn_box mb_10">
				<ul class="tabs">
					<li id="tab1">신청내역</li>
					<li id="tab2">신청결과</li>
				</ul>
				<!--버튼 -->
				<div class="right_btn">
					<a class="btn_st1 icon_n fl mr_m1" onclick="fnAdd()">신규</a>
					<a class="btn_st1 icon_n fl mr_m1" onclick="fnDel()">삭제</a>
					<a class="btn_st2 icon_n fl" onclick="fnSave()">저장</a>
				</div>
				<!--//버튼 -->
			</div>
			<div class="contents marginbot" id="tab_list">
				<!---텝1--->
				<div id="content1" class="tabscontent">
					<div class="box_w2 mb_20">
						<!--------------피의자 정보----------------->
						<div class="box_w2_1b">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" alt="" />피의자 정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box ">
								<form id="trgterInfoForm">
								<div class="tb_01_box">
									<table class="tb_01">
										<col width="130px" />
										<col width="30%" />
										<col width="130px" />
										<col width="" />
										<tbody>
											<tr>
												<th>피의자성명</th>
												<td colspan="3">
													<label id="labTrgterNm"></label>
												</td>
											</tr>
											<tr>
												<th>주민등록번호</th>
												<td>
													<label id="labTrgterRrn"></label>
												</td>
												<th>나이</th>
												<td>
													<label id="labTrgterAge" class="mr_5"></label>(만)세
												</td>
											</tr>
											<tr>
												<th>피의자직업</th>
												<td colspan="3">
													<label id="labOccpNm"></label>
												</td>
											</tr>
											<tr>
												<th>피의자주거</th>
												<td colspan="3">
													<label id="labDwlsitAddr"></label>
												</td>
											</tr>
											<tr>
												<th>위반사항</th>
												<td colspan="3">
													<label id="labVioltNm"></label>
												</td>
											</tr>
											<tr>
												<th>영장작성자</th>
												<td colspan="3">
													<label id="labWritngNm"></label>
												</td>
											</tr>
											<tr>
												<th>영장신청일</th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl w_150px">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtReqstDe" name="txtReqstDe" check="text" checkName="영장신청일">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal6" class="calendarOverlay"></div>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								</form>
							</div>
						</div>
						<!-------------- /피의자 정보----------------->
						<!-------------- 영장 정보----------------->
						<div class="box_w2_2b">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" alt="" />영장 정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box ">
								<form id="reqDtlForm">
								<input type="hidden" id="hidReqCudType" 	 	name="hidCudType" />
								<input type="hidden" id="hidReqCaseNo" 	 		name="hidCaseNo" />
								<input type="hidden" id="hidReqTrgterSn" 		name="hidTrgterSn" />
								<input type="hidden" id="hidReqZrlongReqstNo" 	name="hidZrlongReqstNo" />
								<div class="tb_01_box">
									<table class="tb_01">
										<col width="150px" />
										<col width="" />
										<tbody>
											<tr class="h_40px">
												<th>영장구분</th>
												<td>
													<c:forEach var="cd" items="${szureZrlongLst}">
														<div class='input_radio2 t_left'>
															<input class="to-labelauty-icon" type="radio" name="rdoSzureZrlongCd" onclick="fnSzrlSeClk('${cd.cd}')" check="text" checkName="영장구분" value="${cd.cd}"/>
													    	${cd.cdNm}
													    </div>
													</c:forEach>
												</td>
											</tr>
											<tr class="h_40px">
												<th>유효일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtReqValidDt" name="txtValidDt" check="text" checkName="유효일시">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal1" class="calendarOverlay"></div>
													</div>
												</td>
											</tr>
											<!-- 압수수색검증영장 신청이 긴급일 경우 표시  -->
											<tr class="h_40px szReqD1">
												<th>집행자</th>
												<td>
													<div class="flex_r">
														<input type="text" name="txtExcuterId" class="w_150px input_com">
														<input type="button" class="btn_search">
													</div>
												</td>
											</tr>
											<tr class="h_40px szReqD1">
												<th>집행일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtReqExcutDt" name="txtExcutDt">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal2" class="calendarOverlay"></div>
													</div>
												</td>
											</tr>
											<!-- 압수수색검증영장 신청이 금융계좌추적용일 경우 표시 -->
											<tr class="h_40px szReqD2">
												<th>계좌명의인</th>
												<td>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoAcnutNmCd" />피의자 본인
													</div>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoAcnutNmCd" />제3자
													</div>
												</td>
											</tr>
											<tr class="szReqD2">
												<th>거래기간</th>
												<td>
													<input type="text" name="txtDelngPd" class="w_100p input_com">
												</td>
											</tr>
											<tr class="szReqD2">
												<th>개설은행/계좌번호</th>
												<td>
													<div class="flex_r">
														<input type="text" name="txtAcnutBank" class="input_com mr_5" style="width: 30%">
														<input type="text" name="txtAcnutNo" class="input_com" style="width:calc(70%- 5px);">
													</div>
												</td>
											</tr>
											<tr class="szReqD2">
												<th>거래정보등의내용</th>
												<td>
													<input type="text" name="txtDelngCn" class="w_100p input_com">
												</td>
											</tr>
											<tr>
												<th>압수물건</th>
												<td>
													<input type="text" name="txtSzureThing" class="w_100p input_com">
												</td>
											</tr>
											<tr>
												<th>수색검증장소/신체/물건</th>
												<td>
													<input type="text" name="txtSrchngTrget" class="w_100p input_com">
												</td>
											</tr>
											<tr>
												<th>압수수색사유</th>
												<td>
													<input type="text" name="txtSrchngResn" class="w_100p input_com">
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								</form>
							</div>
						</div>
						<!-------------- //영장 정보----------------->
					</div>
				</div>
				<!---텝2 -->
				<form id="rstDtlForm">
				<input type="hidden" id="hidrstCudType" 	 	name="hidCudType" />
				<input type="hidden" id="hidrstCaseNo" 	 		name="hidCaseNo" />
				<input type="hidden" id="hidrstTrgterSn" 		name="hidTrgterSn" />
				<input type="hidden" id="hidrstZrlongReqstNo" 	name="hidZrlongReqstNo" />
				<input type="hidden" id="hidrstZrlongNoOrg" 	name="hidZrlongNoOrg" />	<!-- 기존 key 값 확인용 -->
				<input type="hidden" id="hidrstDocId" 			name="hidDocId" />  		<!-- 신청에 있는 DOC ID 복사 -->
				<div id="content2" class="tabscontent">
					<div class="box_w2 mb_20">
						<!-------------- 신청결과정보 -------------->
						<div class="box_w2_1b">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" alt="" />신청결과정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box ">
								<div class="tb_01_box">
									<table class="tb_01_h100">
										<col width="150px" />
										<col width="" />
										<tbody>
											<tr class="h_40px">
												<th>영장번호</th>
												<td colspan="3">
													<input type="text" name="txtZrlongNo" class="input_com" style="width: 180px;" check="text" checkName="영장번호">
												</td>
											</tr>
											<tr class="h_40px">
												<th>유효일시</th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtRstValidDt" name="txtRstValidDt" check="text" checkName="유효일시">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal3" class="calendarOverlay"></div>
													</div>
													<div style="margin-top: 7px;"> 까지</div>
												</td>
											</tr>
											<tr class="h_40px">
												<th>발부일시</th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtIsueDt" name="txtIsueDt" check="text" checkName="발부일시">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal4" class="calendarOverlay"></div>
													</div>
												</td>
											</tr>
											<tr class="h_40px">
												<th>기각기관</th>
												<td colspan="3">
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoDsmsslInsttCd" /> 검찰
													</div>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoDsmsslInsttCd" /> 법원
													</div>
												</td>
											</tr>
											<tr class="" style="height: 165px;">
												<th rowspan="2">기각사유</th>
												<td rowspan="2" colspan="3">
													<textarea name="txtDsmsslResn"></textarea>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<!-------------- //신청결과정보 -------------->
						<!-------------- 집행정보 -------------->
						<div class="box_w2_2b">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" alt="" />집행정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box ">
								<div class="tb_01_box">
									<table class="tb_01_h100">
										<col width="150px" />
										<col width="" />
										<tbody>
											<tr class="h_40px">
												<th>집행구분</th>
												<td colspan="3"><div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoExcutSeCd" value="Y"/> 집행
													</div>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoExcutSeCd" value="N"/>집행불능
													</div>
												</td>
											</tr>
											<tr class="h_40px">
												<th>집행자</th>
												<td colspan="3">
													<div class="flex_r">
														<input type="text" name="txtExcuterId" class="w_200px input_com">
														<input type="button" class="btn_search">
													</div>
												</td>
											</tr>
											<tr class="h_40px">
												<th>집행일시</th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtRstExcutDt" name="txtRstExcutDt">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal5" class="calendarOverlay"></div>
													</div>
												</td>
											</tr>
											<tr class="h_80px">
												<th>집행장소/신체/물건</th>
												<td colspan="3" class="h100">
													<textarea name="txtExcutPlace"></textarea>
												</td>
											</tr>
											<tr class="h_80px">
												<th>압수물건</th>
												<td colspan="3" class="h100">
													<textarea name="txtRstSzureThing"></textarea>
												</td>
											</tr>
											<tr class="h_40px">
												<th>집행불능사유</th>
												<td colspan="3">
													<div class="flex_r">
														<select name="txtExcutIncpctyCd" size="1" class="w_200px input_com mr_5" style="width:30%">
															<option value="" selected>-선택-</option>
															<option value=""></option>
														</select>
														<input type="text" name="txtExcutIncpctyEtc" class="input_com" style="width:calc(70%- 5px);">
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<!-------------- //집행정보 -------------->
					</div>
				</div>
				</form>
			</div>
		</div>
		<!---//텝영역---->
	</div>
</div>