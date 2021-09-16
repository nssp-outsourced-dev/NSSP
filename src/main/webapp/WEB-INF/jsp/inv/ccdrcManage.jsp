<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<style type="text/css">
.grid_td_left {
	text-align: left
}
input[type=radio] {
	visibility: visible;
	float: none;
}
.box_w2_1b_ov{ width:calc(70% - 10px); float:left; box-sizing: border-box; padding: 0px 0px 0px 0px; max-height: 195px; overflow-x: hidden; overflow-y: auto }
.box_w2_2b_ov{ width:calc(30% - 10px); float:left; box-sizing: border-box; padding: 0px 0px 0px 0px; max-height: 195px; overflow-x: hidden; overflow-y: auto }

	/* 
		2021.08.11
		coded by dgkim
		수사시스템 화면 비율 조정
		권종열 사무관 요청
	*/
	.box_w2_1b_ov { height: 160px !important; }/* 사건목록 영역 */
	#showinbox { height: 190px; }
	#gridT1_wrap, #gridT2_wrap, #grid_list { height: 152px !important; }/* 사건목록, 압수물 목록 */
	#ifrReport { height: 202px !important; }/* 작성문서목록 */
</style>
<script type="text/javascript">
	var sFormatId = "00448";

	$(document).ready(function(){
		fnTopLst();
		fnDatePickerImg("calSzureDe", null, true);
		fnDatePickerImg("calDspsDe", null, true);
		fnUpCdList("00707", $("#selCcdrcClCd"));  // 압수물구분코드
		fnUpCdList("00703", $("#selDspsCd"));  // 압수처분코드
		fnUpCdList("00723", $("#selSzureTrgterSe")); // 피압수자구분
		initGrid();   // 그리드관련
		initGridCcdrc();
		gridResize(); // 그리드관련
		fnReportList("ifrReport", "", sFormatId, "", ""); // 작성문서목록 //'P_RC_NO=2018000001&P_TRGTER_SN=13'
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

	function fnInitForm() {
		$("#span_hidCaseNo").html("");
		$("#span_hidCcdrcNo").html("");
		$("#span_hidCcdrcSn").html("");
		$("#span_txtSzureTrgterRrn").html("");
		$("#span_txtSzureTrgterTel").html("");
		$("#span_txtSzureTrgterHpNo").html("");
		$("#span_txtSzureAdresAddr").html("");
		$("#span_txtPosesnTrgterRrn").html("");
		$("#span_txtPosesnTrgterTel").html("");
		$("#span_txtPosesnTrgterHpNo").html("");
		$("#span_txtPosesnAdresAddr").html("");

		$("#form_detail").resetForm();
		$("#hidPosesnTrgterSe").val("00722");  // 소유자 구분코드
	}

	function initGrid() {
		var columnLayoutT1 = [
			{ dataField : "CASE_NO",       headerText : "사건번호", width : 80,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}},
			{ dataField : "PRSCT_DE",      headerText : "입건일자", width : 80, dataType : "date", formatString : "yyyy-mm-dd"},
			{ dataField : "INV_PROVIS_NM", headerText : "수사단서", width : 70 },
			{ dataField : "TRGTER_NM_S",      headerText : "피의자", width : 80},
			{ dataField : "VIOLT_NM",      headerText : "위반죄명", width : 250, style : 'grid_td_left'}

		];
		var columnLayoutT2 = [
			{ dataField : "CASE_NO",       headerText : "사건번호", width : 100,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				} },
			{ dataField : "CCDRC_NO",      headerText : "압수번호", width : 100,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}},
			{ dataField : "CF_CNT", headerText : "압수건수", width : 70 }
		];
		var gridProsT1 = {
			showRowNumColumn : true,
			displayTreeOpen : true,
			//showRowCheckColumn : true,
			//rowCheckToRadio : true,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell:true,
			//noDataMessage:"조회 목록이 없습니다.",
			showAutoNoDataMessage:false,
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true
		};
		AUIGrid.create("#gridT1_wrap", columnLayoutT1, gridProsT1);
		AUIGrid.create("#gridT2_wrap", columnLayoutT2, gridProsT1);
		AUIGrid.bind("#gridT1_wrap", "ready", function(event) {
			if(!fnIsEmpty("${hidRcNo}")) {
				var rows = AUIGrid.getRowIndexesByValue("#gridT1_wrap", "RC_NO", "${hidRcNo}");
				//console.log("################ row[0]:"+rows[0]);
				AUIGrid.setSelectionByIndex("#gridT1_wrap", rows[0]);

				//AUIGrid.bind("#gridT1_wrap", "cellClick") 동일
				fnSearchGrid("/inv/ccdrcNoListAjax/?schRcNo=${hidRcNo}", "", "#gridT2_wrap");

				AUIGrid.clearGridData("#grid_list");
				fnReportList("ifrReport", "", sFormatId, "", "");
				fnInitForm();

				$("#span_hidCaseNo").html("<font color='blue'>${hidRcNo}</font>");
				$("#hidCaseNo").val("${hidRcNo}");
				$("#hidRcNo").val("${hidRcNo}");
			}
		});
		AUIGrid.bind("#gridT1_wrap", "cellClick", function(event) {
			var items = event.item;
			fnSearchGrid("/inv/ccdrcNoListAjax/?schRcNo="+items.RC_NO, "", "#gridT2_wrap");
			AUIGrid.clearGridData("#grid_list");
			fnReportList("ifrReport", "", sFormatId, "", "");
			fnInitForm();

			$("#span_hidCaseNo").html("<font color='blue'>"+fnChangeNo(items.CASE_NO)+"</font>");
			$("#hidCaseNo").val(items.CASE_NO);
			$("#hidRcNo").val(items.RC_NO);
		});
		AUIGrid.bind("#gridT2_wrap", "cellClick", function(event) {
			var items = event.item;
			fnSearch(items);
			// 2019-06-26 사건목록 hide
			$("#hide").click();
		});

		fnSearchGrid("/inv/ccdrcCaseListAjax/", "", "#gridT1_wrap");
	}

	function initGridCcdrc() {
		var columnLayout = [{
				headerText : "연번", dataField : "CCDRC_SN", width : 40
			}, {
				headerText : "압수일자", dataField : "SZURE_DE", width : 90
			}, {
				headerText : "물건명", dataField : "CCDRC_NM", width : 150, style : "grid_td_left"
			}, {
				headerText : "수량", dataField : "CCDRC_QY", width : 70
			}, {
				headerText : "소지(제출)자", dataField : "CF_SZURE_TRGTER_NM", width : 80
			}, {
				headerText : "소유자", dataField : "CF_POSESN_TRGTER_NM", width : 80
			}, {
				headerText : "처분결과", dataField : "DSPS_CD_NM", width : 80
			}, {
				headerText : "처분비고", dataField : "DSPS_RM", width : 80
			}
		];
		var gridPros = {
			//showRowNumColumn : true,
			displayTreeOpen : true,
			showRowCheckColumn : true,
			rowCheckToRadio : true,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell:true,
			//noDataMessage:"조회 목록이 없습니다.",
			showAutoNoDataMessage:false,
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true
		};

		// 업무 그리드
		AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind("#grid_list", "cellClick", function(event) {
			var items = event.item;
			fnDetail(items);
			AUIGrid.setCheckedRowsByValue("#grid_list", "RNUM", items.RNUM);
		});
		// 체크박스(라디오버턴) 클릭 이벤트 바인딩
		AUIGrid.bind("#grid_list", "rowCheckClick", function(event) {
			//console.log("rowIndex : " + event.rowIndex + ", id : " + event.item.id + ", name : " + event.item.name + ", checked : " + event.checked);
			var items = event.item;
			fnDetail(items);
		});
		AUIGrid.bind("#grid_list", "ready", function(event) {
			// 압수물목록 첫번째 압수물 자동 선택
			if(AUIGrid.getRowCount("#grid_list") > 0) {
				AUIGrid.setCheckedRowsByValue("#grid_list", "RNUM", "1");
				AUIGrid.setSelectionByIndex("#grid_list", 0);
				var checkedItems = AUIGrid.getCheckedRowItems("#grid_list");
				var items = checkedItems[0].item;
				fnDetail(items);
			}
		});
	}

	function fnSearch(data) {
		fnSearchGrid("/inv/ccdrcListAjax/?schRcNo="+data.RC_NO+"&schCcdrcNo="+data.CCDRC_NO, "", "#grid_list");
		fnReportList("ifrReport", data.DOC_ID, sFormatId, "P_CCDRC_NO="+data.CCDRC_NO, data.FILE_ID);
		fnInitForm();

		$("#span_hidCaseNo").html("<font color='blue'>"+fnChangeNo(data.CASE_NO)+"</font>");
		$("#span_hidCcdrcNo").html("<font color='blue'>"+fnChangeNo(data.CCDRC_NO)+"</font>");
		$("#hidCaseNo").val(data.CASE_NO);
		$("#hidRcNo").val(data.RC_NO);
		$("#hidCcdrcNo").val(data.CCDRC_NO);
		$("#hidDocId").val(data.DOC_ID);
		$("#hidFileId").val(data.FILE_ID);
	}

	function fnGoCmnd() {
		if(fnIsEmpty($("#hidRcNo").val())) {
			alert("처리할 사건을 선택하세요.");
			return;
		}

		if(!confirm("압수물 지휘건의로 이동하시겠습니까?")) return;

		var rcNo = $("#hidRcNo").val();
		var caseNo = $("#hidCaseNo").val();
		var ccdrcNo = $("#hidCcdrcNo").val();
		location.href = "<c:url value='/inv/sugest/?rcNo="+rcNo+"&sugestTyCd=01103&caseNo="+caseNo+"&ccdrcNo="+ccdrcNo+"'/>";
	}

	function fnTrgterPop(str){
		if(fnIsEmpty($("#hidRcNo").val())) return;

		var str2 = "";
		if(str == "S") str2 = $("#selSzureTrgterSe").val();
		else if(str == "P") str2 = $("#hidPosesnTrgterSe").val();

		var sUrl = "<c:url value='../ccdrcTrgterRegPopup/'/>"
				 + "?schCcdrcNo="+$("#hidCcdrcNo").val()
				 + "&schCcdrcSn="+$("#hidCcdrcSn").val()
				 + "&schCaseNo="+$("#hidCaseNo").val()
				 + "&schRcNo="+$("#hidRcNo").val()
				 + "&schTrgterSe="+str
				 + "&schSzureTrgterCd="+str2;
		//fnOpenWin(sUrl, "ccdrTrgterPop", "1200", "500", "no");

		ccdrTrgterPop = dhtmlmodal.open('ccdrTrgterPop', 'iframe', sUrl, '압수대상자 선택', 'width=1000px,height=500px,center=1,resize=0,scrolling=1')
		ccdrTrgterPop.onclose = function(){
			var iframedoc = this.contentDoc;
			var str = "";
			if(iframedoc.getElementById("hidTrgterSe").value == "S") { // 피압수자
				str = "Szure";
			} else if(iframedoc.getElementById("hidTrgterSe").value == "P") {  // 소유자
				str = "Posesn";
			}
			$("#hid"+str+"TrgterSn").val(iframedoc.getElementById("hidTrgterSn").value);
			$("#txt"+str+"TrgterNm").val(iframedoc.getElementById("txtTrgterNm").value);
			if(!fnIsEmpty(iframedoc.getElementById("txtTrgterRrn1").value)) {
				$("#txt"+str+"TrgterRrn").val(iframedoc.getElementById("txtTrgterRrn1").value+"-"+iframedoc.getElementById("txtTrgterRrn2").value);
				$("#span_txt"+str+"TrgterRrn").html(iframedoc.getElementById("txtTrgterRrn1").value+"-"+iframedoc.getElementById("txtTrgterRrn2").value);
			} else {
				$("#txt"+str+"TrgterRrn").val("");
				$("#span_txt"+str+"TrgterRrn").html("");
			}
			if(!fnIsEmpty(iframedoc.getElementById("txtTrgterTel1").value)) {
				$("#txt"+str+"TrgterTel").val(iframedoc.getElementById("txtTrgterTel1").value+"-"+iframedoc.getElementById("txtTrgterTel2").value+"-"+iframedoc.getElementById("txtTrgterTel3").value);
				$("#span_txt"+str+"TrgterTel").html(iframedoc.getElementById("txtTrgterTel1").value+"-"+iframedoc.getElementById("txtTrgterTel2").value+"-"+iframedoc.getElementById("txtTrgterTel3").value);
			} else {
				$("#txt"+str+"TrgterTel").val("");
				$("#span_txt"+str+"TrgterTel").html("");
			}
			if(!fnIsEmpty(iframedoc.getElementById("txtTrgterHpNo1").value)) {
				$("#txt"+str+"TrgterHpNo").val(iframedoc.getElementById("txtTrgterHpNo1").value+"-"+iframedoc.getElementById("txtTrgterHpNo2").value+"-"+iframedoc.getElementById("txtTrgterHpNo3").value);
				$("#span_txt"+str+"TrgterHpNo").html(iframedoc.getElementById("txtTrgterHpNo1").value+"-"+iframedoc.getElementById("txtTrgterHpNo2").value+"-"+iframedoc.getElementById("txtTrgterHpNo3").value);
			} else {
				$("#txt"+str+"TrgterHpNo").val("");
				$("#span_txt"+str+"TrgterHpNo").html("");
			}
			$("#txt"+str+"AdresZip").val(iframedoc.getElementById("txtAdresZip").value);
			$("#txt"+str+"AdresAddr").val(iframedoc.getElementById("txtAdresAddr").value);
			$("#span_txt"+str+"AdresAddr").html(iframedoc.getElementById("txtAdresAddr").value + " " + iframedoc.getElementById("txtAdresZip").value);

			var obj = iframedoc.getElementsByName('rdoTrgterTyCd');
			for(var i = 0 ; i < obj.length ; i++ ) {
				if(obj[i].checked) {
					$("#hid"+str+"TrgterTyCd").val(obj[i].value);
				}
			}

			return true;
		}
	}

	function fnNew(){
		if(fnIsEmpty($("#hidRcNo").val())) {
			alert("사건을 선택하세요.");
			return;
		}

		var rcNo = $("#hidRcNo").val();
		var caseNo = $("#hidCaseNo").val();
		var ccdrcNo = $("#hidCcdrcNo").val();
		fnInitForm();
		fnReportList("ifrReport", "", sFormatId, "", "");

		$("#hidRcNo").val(rcNo);
		$("#hidCaseNo").val(caseNo);
		$("#hidCcdrcNo").val(ccdrcNo);
		$("#span_hidCaseNo").html("<font color='blue'>"+fnChangeNo(caseNo)+"</font>");
		$("#span_hidCcdrcNo").html("<font color='blue'>"+fnChangeNo(ccdrcNo)+"</font>");
	}

	/* function fnAdd(){
		if(fnIsEmpty($("#hidRcNo").val()) || fnIsEmpty($("#hidCaseNo").val())) {
			return;
		}

		ccdrNoListPop = dhtmlmodal.open('ccdrNoListPop', 'iframe', "<c:url value='../ccdrcNoListPopup/'/>?schCaseNo="+$("#hidCaseNo").val(), '압수번호 선택', 'width=400px,height=200px,center=1,resize=0,scrolling=1')
		ccdrNoListPop.onclose = function(){
			var iframedoc = this.contentDoc;
			var sno = iframedoc.getElementById("selCcdrcNo").value; // 압수번호|문서번호
			var str = sno.split("|");

			var rcNo = $("#hidRcNo").val();
			var caseNo = $("#hidCaseNo").val();
			fnInitForm();
			fnReportList("ifrReport", str[1], sFormatId, "P_CCDRC_NO="+str[0]);

			$("#hidRcNo").val(rcNo);
			$("#hidCaseNo").val(caseNo);
			$("#hidCcdrcNo").val(str[0]);
			$("#span_hidCcdrcNo").html(str[0]);

			return true;
		}

		//fnOpenWin("<c:url value='../ccdrcNoListPopup/'/>?schCaseNo="+$("#hidCaseNo").val(), "ccdrNoListPop", "300", "300", "no");
	} */

	function fnSave() {
		if(fnIsEmpty($("#hidRcNo").val()) || fnIsEmpty($("#hidCaseNo").val())) {
			return;
		}

		if(!fnFormValueCheck("form_detail")) return;

		var iUrl = "<c:url value='/inv/addCcdrcAjax/'/>";
		if(!fnIsEmpty($("#hidCcdrcNo").val()) && !fnIsEmpty($("#hidCcdrcSn").val())) {
			iUrl = "<c:url value='/inv/modCcdrcAjax/'/>";
		}
		var queryString = $('#form_detail').serialize();
		var processAfterGet = function(data) {
			if(data.result == "1"){
				alert("저장되었습니다.");
				fnSearchGrid("/inv/ccdrcNoListAjax/?schRcNo="+data.RC_NO, "", "#gridT2_wrap");
				fnSearchGrid("/inv/ccdrcListAjax/?schRcNo="+data.RC_NO+"&schCcdrcNo="+data.CCDRC_NO, "", "#grid_list");
				fnReportList("ifrReport", data.DOC_ID, sFormatId, "P_CCDRC_NO="+data.CCDRC_NO, data.FILE_ID);

				if(fnIsEmpty($("#hidCcdrcNo").val())) {
					$("#span_hidCcdrcNo").html(fnChangeNo(data.CCDRC_NO));
					$("#hidCcdrcNo").val(data.CCDRC_NO);
				}
				if(fnIsEmpty($("#hidCcdrcSn").val())) {
					$("#span_hidCcdrcSn").html(fnChangeNo(data.CCDRC_SN));
					$("#hidCcdrcSn").val(data.CCDRC_SN);
				}
			}else{
				alert("저장중 오류가 발생하였습니다.");
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnDel() {
		if(fnIsEmpty($("#hidCcdrcSn").val())) {
			alert("삭제할 압수물을 선택하세요.");
			return;
		}

		if(confirm("삭제하시겠습니까?")){
			var iUrl = "<c:url value='/inv/delCcdrcAjax/'/>";
			var queryString = $('#form_detail').serialize();
			var processAfterGet = function(data) {
				//console.log(data);
				if(data.result == "1"){
					alert("삭제되었습니다.");

					fnSearchGrid("/inv/ccdrcNoListAjax/?schRcNo="+data.RC_NO, "", "#gridT2_wrap");
					fnSearchGrid("/inv/ccdrcListAjax/?schRcNo="+data.RC_NO+"&schCcdrcNo="+data.CCDRC_NO, "", "#grid_list");
					fnReportList("ifrReport", data.DOC_ID, sFormatId, "P_CCDRC_NO="+data.CCDRC_NO, data.FILE_ID);
					fnInitForm();

					$("#hidRcNo").val(data.RC_NO);
					$("#hidCaseNo").val(data.CASE_NO);
					$("#hidCcdrcNo").val(data.CCDRC_NO);
					$("#span_hidCaseNo").html("<font color='blue'>"+fnChangeNo(data.CASE_NO)+"</font>");
					$("#span_hidCcdrcNo").html("<font color='blue'>"+fnChangeNo(data.CCDRC_NO)+"</font>");

				}else{
					alert("삭제중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	// 셀 셀렉션 변경 시 아이템의 정보를 Form 필드에 세팅함
	function fnDetail(cInfo) {
		$("#span_hidCaseNo").html(fnChangeNo(cInfo.CASE_NO));
		$("#span_hidCcdrcNo").html(fnChangeNo(cInfo.CCDRC_NO));
		$("#span_hidCcdrcSn").html(cInfo.CCDRC_SN);
		$("#hidRcNo").val(cInfo.RC_NO);
		$("#hidCaseNo").val(cInfo.CASE_NO);
		$("#hidCcdrcNo").val(cInfo.CCDRC_NO);
		$("#hidCcdrcSn").val(cInfo.CCDRC_SN);
		$("#hidDocId").val(cInfo.DOC_ID);
		$("#hidFileId").val(cInfo.FILE_ID);
		$("#calSzureDe").val(cInfo.SZURE_DE);
		$("#selCcdrcClCd").val(cInfo.CCDRC_CL_CD);
		$("#txtCcdrcNm").val(cInfo.CCDRC_NM);
		$("#txtCcdrcQy").val(cInfo.CCDRC_QY);
		$("#txtCcdrcDc").val(cInfo.CCDRC_DC);
		$("#txtPolcOpinion").val(cInfo.POLC_OPINION);
		$("#selDspsCd").val(cInfo.DSPS_CD);
		$("#calDspsDe").val(cInfo.DSPS_DE);
		$("#txtDspsRm").val(cInfo.DSPS_RM);
		$("input:radio[name=rdoRndmPresentnYn]:input[value="+cInfo.RNDM_PRESENTN_YN+"]").prop("checked", true);  //2019-07-12
		$("input:radio[name=rdoRndmPresentnYn]:input[value!="+cInfo.RNDM_PRESENTN_YN+"]").prop("checked", false);

		// 압수대상자 조회
		var iUrl = "<c:url value='/inv/ccdrcTrgterInfoAjax/'/>";
		var queryString = {
			hidCcdrcNo : cInfo.CCDRC_NO,
			hidCcdrcSn : cInfo.CCDRC_SN,
			hidCaseNo : cInfo.CASE_NO,
			hidRcNo : cInfo.RC_NO
		};
		var processAfterGet = function(data) {
			// 피압수자
			$("#selSzureTrgterSe").val(data.sInfo.SZURE_TRGTER_CD);
			$("#hidSzureTrgterSn").val(data.sInfo.TRGTER_SN);
			$("#txtSzureTrgterNm").val(data.sInfo.TRGTER_NM);
			$("#txtSzureTrgterRrn").val(data.sInfo.TRGTER_RRN);
			$("#span_txtSzureTrgterRrn").html(data.sInfo.TRGTER_RRN);
			$("#txtSzureTrgterTel").val(data.sInfo.TRGTER_TEL);
			$("#span_txtSzureTrgterTel").html(data.sInfo.TRGTER_TEL);
			$("#txtSzureTrgterHpNo").val(data.sInfo.TRGTER_HP_NO);
			$("#span_txtSzureTrgterHpNo").html(data.sInfo.TRGTER_HP_NO);
			$("#txtSzureAdresZip").val(data.sInfo.ADRES_ZIP);
			$("#txtSzureAdresAddr").val(data.sInfo.ADRES_ADDR);
			if(!fnIsEmpty(data.sInfo.ADRES_ADDR)) {
				$("#span_txtSzureAdresAddr").html(data.sInfo.ADRES_ADDR + (fnIsEmpty(data.sInfo.ADRES_ZIP)?"":" ("+data.sInfo.ADRES_ZIP+")"));
			} else {
				$("#span_txtSzureAdresAddr").html("");
			}
			// 소유자
			$("#hidPosesnTrgterSe").val(data.pInfo.SZURE_TRGTER_CD);
			$("#hidPosesnTrgterSn").val(data.pInfo.TRGTER_SN);
			$("#txtPosesnTrgterNm").val(data.pInfo.TRGTER_NM);
			$("#txtPosesnTrgterRrn").val(data.pInfo.TRGTER_RRN);
			$("#span_txtPosesnTrgterRrn").html(data.pInfo.TRGTER_RRN);
			$("#txtPosesnTrgterTel").val(data.pInfo.TRGTER_TEL);
			$("#span_txtPosesnTrgterTel").html(data.pInfo.TRGTER_TEL);
			$("#txtPosesnTrgterHpNo").val(data.pInfo.TRGTER_HP_NO);
			$("#span_txtPosesnTrgterHpNo").html(data.pInfo.TRGTER_HP_NO);
			$("#txtPosesnAdresZip").val(data.pInfo.ADRES_ZIP);
			$("#txtPosesnAdresAddr").val(data.pInfo.ADRES_ADDR);
			if(!fnIsEmpty(data.pInfo.ADRES_ADDR)) {
				$("#span_txtPosesnAdresAddr").html(data.pInfo.ADRES_ADDR + (fnIsEmpty(data.pInfo.ADRES_ZIP)?"":" ("+data.pInfo.ADRES_ZIP+")"));
			} else {
				$("#span_txtPosesnAdresAddr").html("");
			}
		}
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

</script>

<!-- 상단 조회 -->
<div class="sh_box">
	<button id="hide" class="showbtn"></button>
	<button id="show" class="hidebtn" style="display: none"></button>

	<div class="show_in" id="showinbox">
		<div class="box_w2">
			<!---------- 왼쪽테이블  ---------------->
			<div class="box_w2_1b_ov" style="height: 190px;">
				<div class="com_box">
					<div id="gridT1_wrap" class="gridResize tb_01_box" style="width: 100%; height: 182px;"></div>
				</div>
			</div>
			<!---------- //왼쪽테이블  ---------------->
			<!---------- 오른쪽테이블 ---------------->
			<div class="box_w2_2b_ov">
				<div class="com_box">
					<div id="gridT2_wrap" class="gridResize tb_01_box" style="width: 100%; height: 182px;"></div>
				</div>
			</div>
			<!---------- //오른쪽테이블---------------->
		</div>
	</div>
</div>
<!-- //상단 조회 -->

<div class="box_w2 mb_10">
	<div class="box_w2_1c" ><!-- style="height:230px;" -->
		<div class="title_s_st2 w_150px fl">
			<img src="/img/title_icon1.png" alt="" />압수물 목록
		</div>
		<div class="right_btn fr mb_10" > <!-- style="margin-bottom: 8px;" -->
			<a href="javascript:void(0);" id="btnCmnd" onClick="fnGoCmnd();"  class="btn_st2 icon_n fl">압수물 지휘건의</a>
		</div>
		<div class="tb_01_box">
			<div id="grid_list" class="gridResize" style="width:100%; height:242px; margin:0 auto;"></div>
		</div>
	</div>
	<div class="box_w2_2c">
		<div class="box_w2 "><!--  mb_30 -->
			<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%" height="292px"></iframe>
		</div>
	</div>
</div>

<!-- <div class="title_s_st3 w_50p">
	<img src="/img/icon_error.png" alt=""/>사건번호로 조회를 선행한 후에 압수물 등록이 가능합니다.
</div>
 -->
<!--본문시작 -->
<div class="com_box mb_10">
	<div class="title_s_st2 w_50p fl"><img src="/img/title_icon1.png" alt=""/>압수내역</div>
	<!--버튼 -->
	<div class="right_btn fr">
		<a href="javascript:void(0);" id="btnNew" onclick="fnNew();" class="btn_st2 icon_n fl mr_m1">신규</a>
		<!-- <a href="javascript:void(0);" id="btnAdd" onclick="fnAdd();" class="btn_st1 icon_n fl mr_m1">추가</a> -->
		<a href="javascript:void(0);" id="btnDel" onclick="fnDel();" class="btn_st2 icon_n fl mr_m1">삭제</a>
		<a href="javascript:void(0);" id="btnSave" onclick="fnSave();" class="btn_st2 icon_n fl">저장</a>
	</div>
	<!--//버튼  -->
</div>

<form id="form_detail" name="form_detail" method="post">
<input type="hidden" id="hidRcNo" name="hidRcNo">
<input type="hidden" id="hidCaseNo" name="hidCaseNo">
<input type="hidden" id="hidCcdrcNo" name="hidCcdrcNo">
<input type="hidden" id="hidCcdrcSn" name="hidCcdrcSn">
<input type="hidden" id="hidDocId" name="hidDocId">
<input type="hidden" id="hidFileId" name="hidFileId">

<!--테이블 시작 -->
<div class="com_box mb_20">
	<div class="tb_01_box">
		<table class="tb_01_h100">
		<colgroup>
			<col width="8%"/>
			<col width="5%"/>
			<col width="17%"/>
			<col width="10%"/>
			<col width="20%"/>
			<col width="10%"/>
			<col width="30%"/>
		</colgroup>
		<tbody>
			<tr>
				<th colspan="2">사건번호</th>
				<td>
					<span id="span_hidCaseNo">
				</td>
				<th>압수번호(연번)</th>
				<td>
					<span id="span_hidCcdrcNo"></span>&nbsp;(&nbsp;<span id="span_hidCcdrcSn"></span>&nbsp;)
				</td>
				<th>압수일자<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<div class="calendar_box  w_150px  mr_5">
					<input type="text" name="calSzureDe" id="calSzureDe" class="w_100p input_com calendar" readonly check="text" checkName="압수일자">
					<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
					</div>
				</td>
			</tr>
			<tr>
				<th colspan="2">물건명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<input type="text" id="txtCcdrcNm" name="txtCcdrcNm" maxlength="50" class="w_100p input_com" check="text" checkName="물건명"/>
				</td>
				<th>수량<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<input type="text" id="txtCcdrcQy" name="txtCcdrcQy" class="w_150px input_com" maxlength="10" check="text" checkName="수랑"/>
				</td>
				<th>임의제출여부</th>
				<td>
					<div class='input_radio2 t_left'><input type="radio" name="rdoRndmPresentnYn" value="Y" class="to-labelauty-icon"/>예</div>
					<div class='input_radio2 t_left'><input type="radio" name="rdoRndmPresentnYn" value="N" class="to-labelauty-icon" checked/>아니오</div>
				</td>
			</tr>
			<tr>
				<th rowspan="2">소지자 또는<br>제출자<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<th>성명</th>
				<td><div class="flex_r w_150px">
					<input type="hidden" id="hidSzureTrgterTyCd" name="hidSzureTrgterTyCd"/>
					<input type="hidden" id="hidSzureTrgterSn" name="hidSzureTrgterSn"/>
					<input type="text" id="txtSzureTrgterNm" name="txtSzureTrgterNm" class="w_100p input_com" check="text" checkName="소지자 또는 제출자" readonly onfocus="fnTrgterPop('S')"/>
					<input type="button" id="btnSchCcdrcTrgter" class="btn_search" onclick="fnTrgterPop('S')">
					</div>
				</td>
				<th>주민등록번호</th>
				<td>
					<span id="span_txtSzureTrgterRrn"></span>
					<input type="hidden" id="txtSzureTrgterRrn" name="txtSzureTrgterRrn" class="w_100p"/>
				</td>
				<th>피압수자구분</th>
				<td>
					<select name="selSzureTrgterSe" id="selSzureTrgterSe" class="w_150px input_com" check="text" checkName="피압수자구분"></select>
				</td>
			</tr>
			<tr class="h_40px">
				<th>전화번호</th>
				<td>
					<span id="span_txtSzureTrgterTel"></span>
					<input type="hidden" id="txtSzureTrgterTel" name="txtSzureTrgterTel" class="w_150px"/>
				</td>
				<th>휴대번호</th>
				<td>
					<span id="span_txtSzureTrgterHpNo"></span>
					<input type="hidden" id="txtSzureTrgterHpNo" name="txtSzureTrgterHpNo" class="w_150px"/>
				</td>
				<th>주소</th>
				<td>
					<span id="span_txtSzureAdresAddr"></span>
					<input type="hidden" id="txtSzureAdresZip" name="txtSzureAdresZip" class="w_20p"/>
					<input type="hidden" id="txtSzureAdresAddr" name="txtSzureAdresAddr" class="w_80p" />
				</td>
			</tr>
			<tr>
				<th rowspan="2">소유자<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<th>성명</th>
				<td><div class="flex_r w_150px">
					<input type="hidden" id="hidPosesnTrgterSe" name="hidPosesnTrgterSe" value="00722"/>
					<input type="hidden" id="hidPosesnTrgterTyCd" name="hidPosesnTrgterTyCd"/>
					<input type="hidden" id="hidPosesnTrgterSn" name="hidPosesnTrgterSn"/>
					<input type="text" id="txtPosesnTrgterNm" name="txtPosesnTrgterNm" class="w_100p input_com"  check="text" checkName="소유자" onfocus="fnTrgterPop('P')" readonly/>
					<input type="button" id="btnSchCcdrcTrgter" class="btn_search"  onclick="fnTrgterPop('P')">
					</div>
				</td>
				<th>주민등록번호</th>
				<td>
					<span id="span_txtPosesnTrgterRrn"></span>
					<input type="hidden" id="txtPosesnTrgterRrn" name="txtPosesnTrgterRrn" class="w_100p" />
				</td>
				<th></th>
				<td></td>
			</tr>
			<tr class="h_40px">
				<th>전화번호</th>
				<td>
					<span id="span_txtPosesnTrgterTel"></span>
					<input type="hidden" id="txtPosesnTrgterTel" name="txtPosesnTrgterTel" class="w_150px" />
				</td>
				<th>휴대번호</th>
				<td>
					<span id="span_txtPosesnTrgterHpNo"></span>
					<input type="hidden" id="txtPosesnTrgterHpNo" name="txtPosesnTrgterHpNo" class="w_150px" />
				</td>
				<th>주소</th>
				<td>
					<span id="span_txtPosesnAdresAddr"></span>
					<input type="hidden" id="txtPosesnAdresZip" name="txtPosesnAdresZip" class="w_20p" />
					<input type="hidden" id="txtPosesnAdresAddr" name="txtPosesnAdresAddr" class="w_80p"/>
				</td>
			</tr>
			<tr>
				<th colspan="2">처분결과</th>
				<td>
					<select name="selDspsCd" id="selDspsCd" class="w_150px input_com"></select>
				</td>
				<th>처분일자</th>
				<td>
					<div class="calendar_box  w_150px  mr_5">
					<input type="text" name="calDspsDe" id="calDspsDe" class="w_100p input_com calendar" readonly>
					<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
					</div>
				</td>
				<th>처분비고</th>
				<td>
					<input type="text" id="txtDspsRm" name="txtDspsRm" class="w_100p input_com" maxlength="250"/>
				</td>
			</tr>
		</tbody>
		</table>
	</div>
</div>
</form>


