<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<style type="text/css">
.btn-bl {
	height: 22px;
	line-height: 22px;
	vertical-align:bottom;
	margin-left: 1px;
}
.tbLft {
	text-align: left;
}

	/*
		2021.08.11
		coded by dgkim
		수사시스템 화면 비율 조정
		권종열 사무관 요청
	*/
	#gridT1_wrap, #gridT2_wrap { height: 152px !important; } /* 사건목록 */
	#showinbox { height: 190px !important; } /* 사건목록 영역 */
	/* #gridR_wrap { height: 150px !important; } 사건목록 */
	/* #ifrReport { height: 200px !important; } 작성문서목록 */
</style>
<script type="text/javascript">

$(function() {
	fnSendKey ('${hidRcNo}', '${hidTrgterSn}');
	fnTopLst ();
	fnDatePickerImg("txtStartDt",null,false);
	fnDatePickerImg("txtEndDt",null,false);
	fnDatePickerImg("txtDscntcDt",null,false);
	fnDatePickerImg("txtResmptDt",null,false);
	fnDatePickerImg("txtVidoTrplantDe",null,false);
	initGrid ();
	fnDoc ("","","");

	$('#txtReferCn').keyup(function(){
		fnLimitString('txtReferCn', 210, 'txtReferCnMsg');  //오류
	});
	$('#txtAtendRm').keyup(function(){
		fnLimitString('txtAtendRm', 2000, 'txtAtendRmMsg');
	});
	$('#txtReferCn').keyup();
	$('#txtAtendRm').keyup();
	
	btnInfoPop();//영상녹화시필요적 고려사항
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
function fnDoc (pDocId, pParam, pFileId) {
	fnReportList('ifrReport',pDocId,docNo,pParam, pFileId);
}
function fnSendKey (pRcNo, pTrSn) {
	if(!fnIsEmpty(pRcNo) || !fnIsEmpty(pTrSn)){
		$("#searchRcNo").val(pRcNo);
		$("#searchTrgterSn").val(pTrSn);
	}
}
function fnSetRow (gId, gCol, gVal, gPos) {
	var rows = AUIGrid.getRowIndexesByValue(gId,gCol,gVal);
	AUIGrid.setSelectionByIndex(gId, rows[0], gPos);
	return rows[0];
}
function initGrid () {
	var cdArr = ["00102","00103"];
	var cdLst = fnAjaxAction2({txtUpCd:cdArr});
	var trgterSeList 	 = getCodeList (cdLst, cdArr[0]);
	var atendNticeCdList = getCodeList (cdLst, cdArr[1]);
	var columnLayoutT1 = [
						{ dataField : "grdDsCaseNo",   	headerText : "사건/내사번호", 	width : 120,
							renderer : {type : "TemplateRenderer"},
	 						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
	 							return fnChangeNo (value);
	 						}
						},
						{ dataField : "grdRcNo",      	headerText : "접수번호", 	width : 120,
							renderer : {type : "TemplateRenderer"},
	 						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
	 							return fnChangeNo (value);
	 						}
						},
						{ dataField : "grdPrsctDe",   	headerText : "입건일자", 	width : 130, dataType : "date", formatString : "yyyy-mm-dd"},
						{ dataField : "grdInvProvisNm",	headerText : "수사단서",	width : 100 },
						{ dataField : "grdRcSeNm",		headerText : "사건구분",	width : 100 },
						{ dataField : "grdTrgterNmS",	headerText : "피의자 등",  width : 120 },
						/* { dataField : "grdTrgterNmV",	headerText : "고발인 등",  width : 120 }, */
		   				{ dataField : "grdVioltNm",		headerText : "위반죄명", 	style:'tbLft' },
		                ];
	var columnLayoutT2 = [
						{ dataField : "grdTrgterSn",   	headerText : "대상자일련번호", visible : false},
		                { dataField : "grdRcNo",      	headerText : "접수번호",
		                	renderer : {type : "TemplateRenderer"},
	 						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
	 							return fnChangeNo (value);
	 						}
		                },
		                { dataField : "grdTrgterSeCd",  headerText : "구분",
		                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
		            			return gridComboLabel(trgterSeList, value)
		            		}
		            	},
		                { dataField : "grdTrgterNm",      headerText : "대상자명", style:'tbLft'},
		                { dataField : "grdTrgterRrn",     headerText : "주민번호", visible : false }
		                ];
	var columnLayoutR = [
						{ dataField : "grdRcNo",      		headerText : "접수번호", visible : false},
						{ dataField : "grdVdoId",      		headerText : "영상녹화ID", visible : false},
						{ dataField : "grdDocId",      		headerText : "문서ID", visible : false},
						{ dataField : "grdPblicteSn",      		headerText : "발행 일련번호", visible : false},
						{ dataField : "grdRn",   			headerText : "회차", 			width : 50 },
						{ dataField : "grdTrgterSn",   		headerText : "대상자일련번호", 	visible : false},
						{ dataField : "grdTrgterNm",    	headerText : "대상자명", width : 100},
						{ dataField : "grdSuspctNm",     	headerText : "피의자 여부", 		width : 100 },
						{ dataField : "grdExmnr",     	headerText : "조사자 성명 및 직책", 		width : 150 },
						{ dataField : "grdAtdrn",     	headerText : "참여자 성명 및 직책", 		width : 150 },
						{ dataField : "grdVidoTrplantCharger",     	headerText : "영상녹화물 관리자", 		width : 130 },
						{ dataField : "grdVidoTrplantDe",	headerText : "영상녹화일",	dataType : "date", formatString : "yyyy-mm-dd" },
						];
	var gridPros = {
		displayTreeOpen : true,
		rowNumHeaderText:"순번",
		selectionMode : "singleRow",	// 선택모드 (기본값은 singleCell multipleCells 임)
    	triggerSelectionChangeOnCell:true,
		//noDataMessage:"조회 목록이 없습니다.",
		showAutoNoDataMessage:false,
		headerHeight : 30,
		rowHeight: 30
	};
	var gridPros1 = {
		showRowNumColumn : true
	};
	var gridPros2 = {
		showRowNumColumn : false
	};
	AUIGrid.create("#gridR_wrap", 	  columnLayoutR,   $.extend( gridPros, gridPros2 ));

	/*상단목록*/
	AUIGrid.create("#gridT1_wrap", 	  columnLayoutT1,   $.extend( gridPros, gridPros1 ));
	AUIGrid.create("#gridT2_wrap", 	  columnLayoutT2,   $.extend( gridPros, gridPros1 ));

	AUIGrid.bind("#gridT2_wrap", "cellClick", function(event) {
		var items = event.item;
		fnDetailList (items);		
	});
	AUIGrid.bind("#gridR_wrap", "cellClick", function(event) {
		var items = event.item;
		fnDetail (items);
	});
	AUIGrid.bind("#gridT1_wrap", "cellClick", function(event) {
		var items = event.item.grdRcNo;
		if(!fnIsEmpty(items)) {
			fnReset (1);
			$("#searchRcNo").val(items);
			fnT2Search ();
		} else {
			alert("접수번호가 확인되지 않습니다.");
		}
	});
	AUIGrid.bind("#gridT1_wrap", "ready", function(event) {
		var hidRcNo  = $("#searchRcNo").val();
		if(!fnIsEmpty(hidRcNo)) {
			fnSetRow (event.pid, "grdRcNo", hidRcNo, 0);
			fnT2Search ();
		}
	});
	AUIGrid.bind("#gridT2_wrap", "ready", function(event) {
		var hidTrgterSn = $("#searchTrgterSn").val();
		var hidRcNo   = $("#searchRcNo").val();
		if(!fnIsEmpty(hidTrgterSn) && !fnIsEmpty(hidRcNo)) {			
			var srow = fnSetRow (event.pid, "grdTrgterSn", hidTrgterSn, 3);
			if(srow > -1) {
				var gdt = AUIGrid.getGridData(event.pid);
				fnDetailList (gdt[srow]);	
			} else {
				$("#searchForm").resetForm ();
			}
		} else {
			$("#searchForm").resetForm ();
		}
	});
	//기본 조회
	fnT1Search();
}
function fnT1Search () {
	fnSearchGrid("/inv/atendCaseListAjax/", "searchForm", "#gridT1_wrap");
}
function fnT2Search () {
	fnSearchGrid("/inv/trgterList/", "searchForm", "#gridT2_wrap");
}
function fnVidoTrplantLstSearch (pForm) {
	var gid = "#gridR_wrap";
	var gdt = fnSearchGridAdd ("/inv/vidoTrplantAjax/", pForm, gid);	
	AUIGrid.setGridData(gid, gdt);
	if(!fnIsEmpty(gdt) && gdt.length > 0) {
		AUIGrid.setSelectionByIndex(gid, 0, 2);
		fnDetail (gdt[0]);
	}
	$("#searchForm").resetForm ();
}
function fnKeySet(items) {
	$("#hidRcNo").val(items.grdRcNo);
	$("#hidTrgterSn").val(items.grdTrgterSn);
	$("#hidDocId").val(items.grdDocId);
	$("#hidVdoId").val(items.grdVdoId);
	
	//$("#selTrgterSeCd").val(items.grdTrgterSeCd);
	//$("#txtTrgterNm").val(items.grdTrgterNm);

	//$("#txtRcverZip").val(items.grdRcverZip);
	//$("#txtRcverAddr").val(items.grdRcverAddr);
}
function fnDetailList (items) {
	fnReset (1);
	fnKeySet (items);
	fnVidoTrplantLstSearch ("vidoTrplantForm");
	$("#hide").click();
}
function fnDetail (items) {
	fnReset (2);
	fnKeySet (items);
	//$("#hidPblicteSn").val(items.grdPblicteSn);
	$("#hidDocId").val(items.grdDocId);
	$("#hidCudType").val("U");
	$("#hidVdoId").val(items.grdVdoId);
	
	//$("#saveBtn").html("수정");
	//재조회
	fnLajax ("searchVidoTrplantDetailAjax","SEARCH");
	//문서조회
	fnDoc(items.grdDocId,"P_RC_NO="+items.grdRcNo+"&P_TRGTER_SN="+items.grdTrgterSn+"&P_VDO_ID="+items.grdVdoId, items.grdFileId);
}
function fnReset (type) {
	var formId = "vidoTrplantForm";
	var pArr = [""];
	if(type == 2) {
		pArr = ["hidRcNo","hidTrgterSn"];//clear할때 제회할 필드 
	}
	$('#'+formId).clearForm(pArr);
	if (type == 1) {
		$("#hidCudType").val("C");
		//$("#saveBtn").html("저장");
		AUIGrid.setGridData("#gridR_wrap", []);
		fnDoc ("","","");
	}
	//신청인
	$("#txtWritngNm").val("${hidLoginNm}");
}
function fnAdd () {
	fnReset (2);
	$("#hidCudType").val("C");
	//$("#saveBtn").html("저장");
	if(!fnKeyChk("추가로 입력할",1)) return;
}
function fnSave () {
	if(!fnKeyChk("신규로 입력할",1)) return;
	if(fnFormValueCheck("vidoTrplantForm")){
		fnLajax ("saveVdoRecAjax","SAVE");
	}
}
function fnKeyChk (pMsg, type) {
	if(fnIsEmpty($("#hidRcNo").val()) && fnIsEmpty($("#hidTrgterSn").val())) {
		alert ("최상단 우측 대상자 정보에서 "+pMsg+" 대상자를 선택해 주세요.");
		return false;
	}
	if(type == 2) {
		if(fnIsEmpty($("#hidPblicteSn").val())) {
			alert ("영상녹화현황에서 "+pMsg+" 목록을 선택해 주세요.");
			return false;
		}
	}
	return true;
}
function fnDel () {
	if(!fnKeyChk("삭제할",2)) return;
	if(!confirm("삭제하시겠습니까?")) return;
	$("#hidCudType").val("D");
	fnLajax ("saveAtendAjax","DEL");  //삭제 처리 해야 함....
}
function fnLajax (sUrl, type) {
	var param = $('#vidoTrplantForm').serialize();
	var processAfterGet = function(data) {
		if(type == "SAVE" || type == "DEL") {
			if(data.cnt == "0") {
				AUIGrid.setGridData("#gridR_wrap", []);
			} else {
				AUIGrid.setGridData("#gridR_wrap", data.list);
				if(type=="DEL") {
					alert("삭제되었습니다.");
					fnAdd ();
				} else {
					alert("저장되었습니다.");
					//detail 조회
					var rtnval = data.rtnValue;console.log(rtnval);
					if(fnIsEmpty(rtnval)) {
						fnAdd ();
					} else {
						fnDetail ({grdVdoId:rtnval.vdoId, grdRcNo:rtnval.rcNo, grdTrgterSn:rtnval.trgterSn, grdDocId:rtnval.docId});
						fnSetRow ("#gridR_wrap", "grdVdoId", rtnval.vdoId, 3);
					}
				}
			}
		} else {
			//input 에 모두 넣기
			fn_form_bind ("vidoTrplantForm",data.detail);
		}
	}
	Ajax.getJson("<c:url value='/inv/"+sUrl+"/'/>", param, processAfterGet);
}
function jusoReturnValue (returnValue) {
	$("#txtRcverAddr").val(returnValue.addr);
	$("#txtRcverZip").val(returnValue.zipCd);
}

//영상녹화시필요적 고려사항
function btnInfoPop () {
	recInfoPopup = dhtmlmodal.open('changePw', 'iframe', '/inv/recInfoPopup/', '영상녹화시 필요적 고지사항', 'width=750px,height=460px,center=1,resize=0,scrolling=0')
	recInfoPopup.onclose = function() {
		return true;
	}
}
</script>
<!-- 상단 조회 -->
<div class="sh_box">
	<button id="hide" class="showbtn"></button>
	<button id="show" class="hidebtn" style="display: none"></button>

	<div class="show_in" id="showinbox">
		<div class="box_w2">
			<!---------- 왼쪽테이블  ---------------->
			<div class="box_w2_1b_ov" style="height: 200px; width:calc(65% - 15px);">
				<!--테이블 시작 -->
				<div class="com_box">
					<div id="gridT1_wrap" class="gridResize tb_01_box" style="width: 100%; height: 190px;"></div>
				</div>
			</div>
			<!---------- //왼쪽테이블  ---------------->
			<!---------- 오른쪽테이블 ---------------->
			<div class="box_w2_2b_ov" style="width:calc(35% - 15px);">
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

<div class="search_box mb_10" style="display: none;">
	<form id="searchForm">
		<input type="hidden" id="searchTrgterSn" name="searchTrgterSn"/> <!-- 내사건관리에서 넘어오는 값 -->
		<input type="hidden" id="searchCaseNo" name="searchCaseNo"/>
		<input type="hidden" id="searchRcNo" name="searchRcNo"/>
	</form>
</div>


<div class="box_w2 mb_10">
	<div class="box_w2_1b" style="margin-top: 8px;">
		<div class="title_s_st2 w_50p fl">
			<img src="/img/title_icon1.png" alt="" />영상녹화 현황
		</div>
		<!--테이블 시작 -->
		<div class="com_box">
			<div id="gridR_wrap" class="gridResize tb_01_box" style="width: 100%; height: 280px;"></div>
		</div>
	</div>
	<div class="box_w2_2b">
		<!--테이블 시작 -->
		<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="330px"></iframe>
	</div>
</div>
<div class="com_box mb_10">
	<div class="title_s_st2 w_50p fl"><img src="/img/title_icon1.png" alt="">영상녹화시 필요적 고지사항</div>
	<!--버튼 -->
	<div class="right_btn fr">
		<a class="btn_st2 icon_n fl mr_m1" onclick="fnAdd();  return false" href="#">신규</a>
		<!-- <a class="btn_st2 icon_n fl mr_m1" onclick="fnDel();  return false" href="#">삭제</a> -->
		<a class="btn_st2 icon_n fl" onclick="fnSave(); return false" href="#" id="saveBtn">저장</a>
	</div>
	<!--//버튼  -->
</div>

<form id="vidoTrplantForm" name="vidoTrplantForm" method="post">
	<input type="hidden" id="hidRcNo" name="hidRcNo" />
	<input type="hidden" id="hidTrgterSn" name="hidTrgterSn" />
	<input type="hidden" id="hidPblicteSn" name="hidPblicteSn" />
	<input type="hidden" id="hidCudType" name="hidCudType" />
	<input type="hidden" id="hidDocId" name="hidDocId" />
	<input type="hidden" id="hidVdoId" name="hidVdoId" />
	
	<div class="com_box mb_20">
		<div class="tb_01_box">
			<table class="tb_01_h100">
				<tbody>
					<tr class="h_40px">
						<th>피의자 여부<img src="/img/point.png"></th>
						<td colspan="9">
							<div class='input_radio2 t_left'>
								<input class="to-labelauty-icon" type="radio" name="rdoIsSuspct" value="Y" check="radio" checkName="피의자 여부" />피의자
							</div>
							<div class='input_radio2 t_left'>
								<input class="to-labelauty-icon" type="radio" name="rdoIsSuspct" value="N" check="radio" checkName="피의자 여부" />참여자
							</div>
						</td>
					</tr>
					<tr>
						<th>조사자<img src="/img/point.png"></th>
						<td><input type="text" id="txtExmnr" name="txtExmnr" class="w_150px input_com" check="text" checkName="조사자"></td>
						<th>직책</th>
						<td><input type="text" id="txtExmnrRspofc" name="txtExmnrRspofc" class="w_150px input_com"></td>
						<th>참여자<img src="/img/point.png"></th>
						<td><input type="text" id="txtAtdrn" name="txtAtdrn" class="w_150px input_com" check="text" checkName="참여자"></td>
						<th>직책</th>
						<td><input type="text" id="txtAtdrnRspofc" name="txtAtdrnRspofc" class="w_150px input_com"></td>
					</tr>
					<tr>
						<th>영상녹화 사실</th>
						<td colspan="9"><input type="text" id="txtVidoTrplantFact" name="txtVidoTrplantFact" class="input_com mr_5" style="width: 100%;" /></td>
					</tr>
					<tr>
						<th>영상녹화 장소</th>
						<td colspan="3"><input type="text" id="txtVidoTrplantPlace" name="txtVidoTrplantPlace" class="w_250px input_com" style="width: 100%;" /></td>
						<th>시작 시각</th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtStartDt"  name="txtStartDt" readonly="readonly">
							</div>
							<div class="fl">
								<input type="text" id="txtStartDt2" name="txtStartDt2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" maxlength="2" style="width: 40px;" />:
								<input type="text" id="txtStartDt3" name="txtStartDt3" class="input_com" onkeyup="fnHHMMChk(event,'MM')" maxlength="2" style="width: 40px;" />
							</div>
						</td>
						<th>종료 시각</th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtEndDt"  name="txtEndDt" readonly="readonly">
							</div>
							<div class="fl">
								<input type="text" id="txtEndDt2" name="txtEndDt2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" maxlength="2" style="width: 40px;" />:
								<input type="text" id="txtEndDt3" name="txtEndDt3" class="input_com" onkeyup="fnHHMMChk(event,'MM')" maxlength="2" style="width: 40px;" />
							</div>
						</td>
					</tr>
					<tr>
						<th>중단 이유</th>
						<td colspan="9"><input type="text" id="txtDscntcResn" name="txtDscntcResn" class="input_com mr_5" style="width: 100%;" /></td>
					</tr>
					<tr>
						<th>중단 시각</th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtDscntcDt"  name="txtDscntcDt" readonly="readonly">
							</div>
							<div class="fl">
								<input type="text" id="txtDscntcDt2" name="txtDscntcDt2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" maxlength="2" style="width: 40px;" />:
								<input type="text" id="txtDscntcDt3" name="txtDscntcDt3" class="input_com" onkeyup="fnHHMMChk(event,'MM')" maxlength="2" style="width: 40px;" />
							</div>
						</td>
						<th>재개 시각</th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtResmptDt"  name="txtResmptDt" readonly="readonly">
							</div>
							<div class="fl">
								<input type="text" id="txtResmptDt2" name="txtResmptDt2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" maxlength="2" style="width: 40px;" />:
								<input type="text" id="txtResmptDt3" name="txtResmptDt3" class="input_com" onkeyup="fnHHMMChk(event,'MM')" maxlength="2" style="width: 40px;" />
							</div>
						</td>
						<th>영상녹화물 관리자</th>
						<td><input type="text" id="txtVidoTrplantCharger" name="txtVidoTrplantCharger" class="w_150px input_com"></td>
						<th>영상녹화일</th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtVidoTrplantDe"  name="txtVidoTrplantDe" readonly="readonly">
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</form>