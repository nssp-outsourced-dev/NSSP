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
</style>
<script type="text/javascript">
var docNo = "00454";  /*출석요구*/
$(function() {
	fnSendKey ('${hidRcNo}', '${hidTrgterSn}');
	fnTopLst ();
	fnDatePickerImg("txtAtendNticeDe",null,false);
	fnDatePickerImg("txtAtendDemandDt",null,false);
	fnDatePickerImg("txtAtendDt",null,false);
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
						{ dataField : "grdRn",   			headerText : "회차", 			width : 50 },
						{ dataField : "grdTrgterSn",   		headerText : "대상자일련번호", 	visible : false},
						{ dataField : "grdRcNo",      		headerText : "접수번호",
							renderer : {type : "TemplateRenderer"},
	 						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
	 							return fnChangeNo (value);
	 						}
						},
						{ dataField : "grdCaseNo",      	headerText : "사건번호", 		visible : false},
						{ dataField : "grdTrgterNm",    	headerText : "대상자명"},
	                    { dataField : "grdAtendDemandDt",	headerText : "출석요구일시",	dataType : "date", formatString : "yyyy-mm-dd hh:MM" },
	                    { dataField : "grdAtendYn",     	headerText : "출석여부", 		width : 80 },
	                    { dataField : "grdAtendNticeCd", 	headerText : "통지방법",		width : 80,
	                    	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
		            			return gridComboLabel(atendNticeCdList, value)
		            		}
	                    },
	                    { dataField : "grdDocId", 		headerText : "첨부파일ID",	visible : false },
	                    { dataField : "grdAtendNticeDe", headerText : "통지일자", dataType : "date", formatString : "yyyy-mm-dd" }
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
function fnAtendLstSearch (pForm) {
	var gid = "#gridR_wrap";
	var gdt = fnSearchGridAdd ("/inv/atendListAjax/", pForm, gid);	
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
	$("#selTrgterSeCd").val(items.grdTrgterSeCd);
	$("#txtTrgterNm").val(items.grdTrgterNm);

	$("#txtRcverZip").val(items.grdRcverZip);
	$("#txtRcverAddr").val(items.grdRcverAddr);
}
function fnDetailList (items) {
	fnReset (1);
	fnKeySet (items);
	fnAtendLstSearch ("atendForm");
	$("#hide").click();
}
function fnDetail (items) {
	fnReset (2);
	fnKeySet (items);
	$("#hidDemandSn").val(items.grdDemandSn);
	$("#hidCudType").val("U");
	//$("#saveBtn").html("수정");
	//재조회
	fnLajax ("searchAtendDetailAjax","SEARCH");
	//문서조회
	fnDoc(items.grdDocId,"P_RC_NO="+items.grdRcNo+"&P_TRGTER_SN="+items.grdTrgterSn+"&P_DEMAND_SN="+items.grdDemandSn,items.grdFileId);
}
function fnReset (type) {
	var formId = "atendForm";
	var pArr = [""];
	if(type == 2) {
		pArr = ["selTrgterSeCd","txtTrgterNm","hidRcNo","hidTrgterSn","txtRcverZip","txtRcverAddr"];
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
	if(fnFormValueCheck("atendForm")){
		fnLajax ("saveAtendAjax","SAVE");
	}
}
function fnKeyChk (pMsg, type) {
	if(fnIsEmpty($("#hidRcNo").val()) && fnIsEmpty($("#hidTrgterSn").val())) {
		alert ("최상단 우측 대상자 정보에서 "+pMsg+" 대상자를 선택해 주세요.");
		return false;
	}
	if(type == 2) {
		if(fnIsEmpty($("#hidDemandSn").val())) {
			alert ("출석요구현황에서 "+pMsg+" 목록을 선택해 주세요.");
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
	var param = $('#atendForm').serialize();
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
					var rtnval = data.rtnValue;
					if(fnIsEmpty(rtnval)) {
						fnAdd ();
					} else {
						fnDetail ({grdDemandSn:rtnval.demandSn,grdDocId:rtnval.docId,grdRcNo:rtnval.rcNo,grdTrgterSn:rtnval.trgterSn});
						fnSetRow ("#gridR_wrap", "grdDemandSn", rtnval.demandSn, 3);
					}
				}
			}
		} else {
			//input 에 모두 넣기
			fn_form_bind ("atendForm",data.detail);
		}
	}
	Ajax.getJson("<c:url value='/inv/"+sUrl+"/'/>", param, processAfterGet);
}
function jusoReturnValue (returnValue) {
	$("#txtRcverAddr").val(returnValue.addr);
	$("#txtRcverZip").val(returnValue.zipCd);
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
			<img src="/img/title_icon1.png" alt="" />출석요구 현황
		</div>
		<!--테이블 시작 -->
		<div class="com_box">
			<!-- 
				2021.08.11
				coded by dgkim
				수사시스템 화면 비율 조정
				권종열 사무관 요청
			 -->
			<div id="gridR_wrap" class="gridResize tb_01_box" style="width: 100%; height: 230px;"></div>
			<!-- <div id="gridR_wrap" class="gridResize tb_01_box" style="width: 100%; height: 280px;"></div> -->
		</div>
	</div>
	<div class="box_w2_2b">
		<!--테이블 시작 -->
		<!-- 
			2021.08.11
			coded by dgkim
			수사시스템 화면 비율 조정
			권종열 사무관 요청
		 -->
		<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="280px"></iframe>
		<!-- <iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="330px"></iframe> -->
	</div>
</div>
<form id="atendForm" name="atendForm" method="post">
<div class="com_box mb_5">
	<input type="hidden" id="hidRcNo" name="hidRcNo" />
	<input type="hidden" id="hidTrgterSn" name="hidTrgterSn" />
	<input type="hidden" id="hidDemandSn" name="hidDemandSn" />
	<input type="hidden" id="hidCudType" name="hidCudType" />
	<input type="hidden" id="hidDocId" name="hidDocId" />
	<div class="title_s_st2 w_50p fl">
		<img src="/img/title_icon1.png" alt="" />출석요구 내역
	</div>
	<div class="right_btn fr">
		<a class="btn_st2 icon_n fl mr_m1" onclick="fnAdd();  return false" href="#">신규</a>
		<a class="btn_st2 icon_n fl mr_m1" onclick="fnDel();  return false" href="#">삭제</a>
		<a class="btn_st2 icon_n fl" onclick="fnSave(); return false" href="#" id="saveBtn">저장</a>
	</div>
</div>
<!--//버튼 -->
<div class="box_w2 mb_20">
	<div class="box_w2_1c">
		<!--테이블 시작 -->
		<div class="tb_01_box">
			<table class="tb_01_h100">
				<col width="" style="min-width: 110px; max-width: 140px;"/>
				<col width="" style="min-width: 250px;"/>
				<col width="" style="min-width: 110px; max-width: 140px;"/>
				<col width="" style="min-width: 250px;"/>
				<tbody>
					<tr class="h_40px">
						<th>통지일자 <img src="/img/point.png" /></th>
						<td>
							<!--달력폼-->
							<div class="calendar_box mr_5 fl w_150px">
								<input type="text" class="w_100p input_com calendar" id="txtAtendNticeDe"  name="txtAtendNticeDe" check="text" checkName="통지일자" readonly="readonly">
								<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
							</div>
							<!--//달력폼-->
						</td>
						<th>출석요구일시 <img src="/img/point.png" /></th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtAtendDemandDt"  name="txtAtendDemandDt" check="text" checkName="출석요구일자" readonly="readonly">
								<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
							</div>
							<div class="fl">
								<input type="text" id="txtAtendDemandDt2" name="txtAtendDemandDt2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" maxlength="2" style="width: 40px;" check="text" checkName="출석요구시간"/>:
								<input type="text" id="txtAtendDemandDt3" name="txtAtendDemandDt3" class="input_com" onkeyup="fnHHMMChk(event,'MM')" maxlength="2" style="width: 40px;" check="text" checkName="출석요구시간"/>
							</div>
						</td>
					</tr>
					<tr class="h_40px">
						<th>통지방법 <img src="/img/point.png" /></th>
						<td>
							<select size="1" class="w_150px input_com" name="selAtendNticeCd" id="selAtendNticeCd" check = "text" checkName = "통지방법">
								<option value="">== 선택하세요 ==</option>
								<c:forEach var="cd" items="${atendNticeCd}">
									<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
								</c:forEach>
							</select>
						</td>
						<th>대상자구분</th>
						<td>
							<select size="1" class="w_150px input_com" name="selTrgterSeCd" id="selTrgterSeCd" disabled="disabled" readonly>
								<option value="">== 선택하세요 ==</option>
								<c:forEach var="cd" items="${trgterSeList}">
									<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr class="h_40px">
						<th>대상자명</th>
						<td>
							<input type="text" id="txtTrgterNm" name="txtTrgterNm" class="w_150px input_com" readonly="readonly">
						</td>
						<th>신청인</th>
						<td>
							<input type="text" id="txtWritngNm" name="txtWritngNm" class="w_150px input_com" readonly="readonly">
						</td>
					</tr>
					<tr class="h_90px">
						<th>수신처</th>
						<td>
							<input type="text" id="txtRcverZip"  name="txtRcverZip"  maxlength="10" size="10" class="w_80px input_com onlyNumber"><br/>
							<div class="flex_r">
								<input type="text" id="txtRcverAddr" name="txtRcverAddr" class="w_100p input_com mt_5" maxlength="130">
								<input type="button" class="btn_search mt_5" onclick="fnZipPop()">
							</div>
						</td>
						<th>참고내용<br/><span id="txtReferCnMsg" style="margin-top:5px;"></span></th>
						<td class="h100">
							<textarea id="txtReferCn" name="txtReferCn"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

	</div>
	<div class="box_w2_2c">
		<!--테이블 시작 -->
		<!--테이블 시작 -->
		<div class="tb_01_box">
			<table class="tb_01_h100">
				<col width="150px" />
				<col width="" style="min-width: 250px;"/>
				<tbody>
					<tr class="h_40px">
						<th>출석여부</th>
						<td>
							<div class='input_radio2 t_left'>
								<input class="to-labelauty-icon" type="radio" name="rdoAtendYn" value="Y"/>출석
							</div>
							<div class='input_radio2 t_left'>
								<input class="to-labelauty-icon" type="radio" name="rdoAtendYn" value="N"/>미출석
							</div>
						</td>
					</tr>
					<tr class="h_40px">
						<th>출석일시</th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtAtendDt"  name="txtAtendDt" readonly="readonly">
								<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
							</div>
							<div class="fl">
								<input type="text" id="txtAtendDt2" name="txtAtendDt2" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
								<input type="text" id="txtAtendDt3" name="txtAtendDt3" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
							</div>
						</td>
					</tr>
					<tr class="" style="height: 130px">
						<th>비고<br/><span id="txtAtendRmMsg" style="margin-top:5px;"></span></th>
						<td>
							<textarea id="txtAtendRm" name="txtAtendRm"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
		</div>

	</div>
</div>
</form>




