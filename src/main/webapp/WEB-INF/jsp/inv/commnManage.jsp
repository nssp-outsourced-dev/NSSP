<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<script type="text/javascript">
	var myGridID;

	$(function() {
		$(document).ready(function(){
			fnDatePickerImg("calReqstDeFrom", fnGetToday(0, -7), true);
			fnDatePickerImg("calReqstDeTo", null, true);
			fnDatePickerImg("calReqstDe", null, false);
			fnDatePickerImg("calExcutDt", null, false);
			fnDatePickerImg("calPrmisnRecptDe", null, false);
			fnDatePickerImg("calIsueDe", null, false);
			fnDatePickerImg("calDsmsslDe", null, false);
			fnDatePickerImg("calReturnDe", null, false);
			fnUpCdList("00741", $("#selPrmisnSeCd"));  // 허가구분
			fnUpCdList("00744", $("#selCommnBsnmCd"));  // 전기통신사업자
			fnUpCdList("00736", $("#selReqstResultCd"));  // 통신사실확인 신청결과상태
			initGrid();   // 그리드관련
			//gridResize(); // 그리드관련

			fnReportList("ifrReport", "", "00450", ""); // 작성문서목록-신청내역
			fnReportList("ifrReport2", "", "00451", ""); // 작성문서목록-신청결과

			$("#divReqstResult").hide();
			$("#divBtnResult").hide();
		});

		$("#schNo1").keyup(function(event) {
			fnRemoveChar(event);
			if($(this).val().length == 4) {
				$("#schNo2").focus();
			}
		});

		$("#schNo2").keyup(function(event) {
			fnRemoveChar(event);
			if(event.keyCode == 13) {
				fnSetNo($(this));
				fnSearch();
			}
		});

		$("#selPrmisnSeCd").change(function(){
			fnSetTrAfterPermission($(this).val());
		});

		$("input:radio[name=rdoReqstResultCd]").change(function(){
			fnSetDisplay($(this).val());
		});
	});

	function fnSetNo(obj) {
		if($(obj).val()) {
			$(obj).val(fnLpad($(obj).val(), 6));
		}
	}
	function initGrid() {
		var columnLayoutT1 = [
	  					{ dataField : "grdCaseNo",      headerText : "사건번호", 	width : 120 },
	  					{ dataField : "grdPrsctDe",   	headerText : "입건일자", 	width : 130, dataType : "date", formatString : "yyyy-mm-dd"},
	  					{ dataField : "grdInvProvisNm",	headerText : "수사단서",	width : 100 },
	  	   				{ dataField : "grdVioltNm",		headerText : "위반사항" },
	  	                ];
		var columnLayoutT2 = [
					{ dataField : "grdTrgterSn",   	headerText : "대상자일련번호", visible : false},
	                { dataField : "grdCaseNo",      headerText : "사건번호" },
	                { dataField : "grdPrsctDe",   	headerText : "입건일자", 	dataType : "date", formatString : "yyyy-mm-dd"},
	                { dataField : "grdTrgterNm",    headerText : "피의자명", style:'tbLft'},
	                { dataField : "grdTrgterRrn",   headerText : "주민번호" }
	                ];
		var columnLayout = [{
				headerText : "진행번호",
				dataField : "PRMISN_PROGRS_NO"
			}, {
				headerText : "허가구분",
				dataField : "PRMISN_SE_CD_NM"
			}, {
				headerText : "사건번호",
				dataField : "CASE_NO"
			}, {
				headerText : "신청일자",
				dataField : "REQST_DE",
				dataType : "date",
				formatString : "yyyy-mm-dd"
			}, {
				headerText : "대상자",
				dataField : "TRGTER_NM"
			}, {
				headerText : "신청결과",
				dataField : "REQST_RESULT_CD_NM"
			}, {
				headerText : "재신청여부",
				dataField : "REREQST_YN"
			}
		];
		var gridPros = {
			showRowNumColumn : true,
			displayTreeOpen : true,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell:true,
			//noDataMessage:"조회 목록이 없습니다.",
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true
		};
		AUIGrid.create("#gridT1_wrap",columnLayoutT1,gridPros);
		AUIGrid.create("#gridT2_wrap",columnLayoutT2,gridPros);
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
			var items = event.item;
			fnDetail(items);
		});
		fnT1Search();
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
	}
	function fnT1Search () {
		fnSearchGrid("/inv/zrlongCaseListAjax/", "searchForm", "#gridT1_wrap");
	}
	function fnT2Search () {
		fnSearchGrid ("/inv/suspectZrlongListAjax/", "searchForm", "#gridT2_wrap");
	}
	function fnSearch() {
		if(!fnCompareDate($("#calReqstDeFrom"), $("#calReqstDeTo"))) return;
		// 신청목록 조회
		fnSearchGrid ("/inv/commnListAjax/", "frSearch", myGridID);
		fnInit();
	}

	function fnInit() {
		$("#frDetail").resetForm();
		$("#frResult").resetForm();
		$("input:radio[name=rdoReqstResultCd]").prop("disabled", false);
		$("input:radio[name=rdoReqstResultCd]").prop("checked", false);
		$("#span_hidPrmisnProgrsNo").html("");
		$("#span_txtCmptncExmnNm").html("");
		$("#span_txtAlotUserNm").html("");
		$("#span_txtCaseNo").html("");
		$("#span_txtVioltNm").html("");
		$("#span_txtTrgterNm").html("");
		$("#txtTrgterNm").show();
		$("#span_txtTrgterRrn").html("");
		$("#span_txtAdresAddr").html("");
		$("#span_txtOccpCdNm").html("");
		$("#span_hidPrmisnProgrsNo2").html("");
		$("#span_txtAlotUserNm2").html("");
		fnSetButton(null);
	}

	function fnTab(str) {
		if(str == "D") {
			$(".tab_box>ul>li:eq(0)>a").addClass("on");
			$("#divReqstDetail").show();
			$("#divBtnDetail").show();
			$(".tab_box>ul>li:eq(1)>a").removeClass("on");
			$("#divReqstResult").hide();
			$("#divBtnResult").hide();
		} else {
			$(".tab_box>ul>li:eq(0)>a").removeClass("on");
			$("#divReqstDetail").hide();
			$("#divBtnDetail").hide();
			$(".tab_box>ul>li:eq(1)>a").addClass("on");
			$("#divReqstResult").show();
			$("#divBtnResult").show();
		}
	}

	function fnDetail(oData) {
		//fnGetReqstDtls(oData.PRMISN_PROGRS_NO);
		//fnGetReqstResult(oData.PRMISN_PROGRS_NO);
		fnInit(); // 초기화

		var iUrl = "<c:url value='/inv/commnInfoAjax/'/>";
		var queryString = {hidPrmisnProgrsNo : oData.PRMISN_PROGRS_NO};
		var processAfterGet = function(data) {
			console.log('data.REQST_RESULT_CD : '+data.REQST_RESULT_CD);
			// 버튼 제어
			fnSetButton(data.REQST_RESULT_CD);
			// 신청내역 - 사후허가, 재신청사유
			fnSetTrAfterPermission(data.PRMISN_SE_CD);
			fnSetTrRerqest(data.ORIGNL_PROGRS_NO);
			// 신청결과 - 입력항목 제어
			fnSetDisplay(data.REQST_RESULT_CD);

			// 신청내역
			//$("#hidPrmisnProgrsNo").val(data.PRMISN_PROGRS_NO);
			//$("#hidReqstResultCd").val(data.REQST_RESULT_CD);
			$("input[name=hidPrmisnProgrsNo]").val(data.PRMISN_PROGRS_NO);
			$("input[name=hidReqstResultCd]").val(data.REQST_RESULT_CD);
			$("#span_hidPrmisnProgrsNo").html(data.PRMISN_PROGRS_NO);
			$("#hidOrignlProgrsNo").val(data.ORIGNL_PROGRS_NO);
			$("#hidRereqstYn").val(data.REREQST_YN);
			$("#calReqstDe").val(data.REQST_DE);
			$("#selPrmisnSeCd").val(data.PRMISN_SE_CD);
			$("#selCommnBsnmCd").val(data.COMMN_BSNM_CD);
			$("#span_txtCmptncExmnNm").html(data.CMPTNC_EXMN_NM); // 관할검찰
			$("#span_txtAlotUserNm").html(data.ALOT_USER_NM);  // 담당자
			$("#span_txtVioltNm").html(data.VIOLT_NM);  // 위반사항
			$("#txtRcNo").val(data.RC_NO);  // 접수번호
			$("#txtCaseNo").val(data.CASE_NO);
			$("#span_txtCaseNo").html(data.CASE_NO);
			$("#txtTrgterSn").val(data.TRGTER_SN);
			$("#txtTrgterNm").hide();
			$("#span_txtTrgterNm").html(data.TRGTER_NM);
			$("#span_txtTrgterRrn").html(data.TRGTER_RRN);
			$("#span_txtAdresAddr").html(data.ADRES_ADDR);
			$("#span_txtOccpCdNm").html(data.OCCP_CD_NM);
			$("#txtDtaScope").val(data.DTA_SCOPE);
			$("#txtRequstResn").val(data.REQUST_RESN);
			$("#txtSbscrberRelate").val(data.SBSCRBER_RELATE);
			$("#txtRerqestResn").val(data.RERQEST_RESN);
			$("#txtNnpmsnpcResn").val(data.NNPMSNPC_RESN);
			$("#calExcutDt").val(data.EXCUT_DT);
			fnReportList("ifrReport", data.DOC_ID, "00450", "P_PRMISN_PROGRS_NO="+data.PRMISN_PROGRS_NO); // 작성문서목록

			// 신청결과
			$("#span_hidPrmisnProgrsNo2").html(data.PRMISN_PROGRS_NO);
			$("#span_txtAlotUserNm2").html(data.ALOT_USER_NM);  // 담당자
			//$("#hidReqstResultCd").val(data.REQST_RESULT_CD);
			$("input:radio[name=rdoReqstResultCd]:input[value="+data.REQST_RESULT_CD+"]").prop("checked", true);
			$("input:radio[name=rdoReqstResultCd]:input[value!="+data.REQST_RESULT_CD+"]").prop("checked", false);
			if(data.REQST_RESULT_CD == "00737") { // 허가신청
				$("input:radio[name=rdoReqstResultCd]").prop("disabled", false);
			} else {
				$("input:radio[name=rdoReqstResultCd]:checked").prop("disabled", false);
				$("input:radio[name=rdoReqstResultCd]:not(:checked)").prop("disabled", true);
			}
			$("#txtPrmisnNo").val(data.PRMISN_NO);
			$("#calPrmisnRecptDe").val(data.PRMISN_RECPT_DE);
			$("#calIsueDe").val(data.ISUE_DE);
			$("input:radio[name=rdoDsmsslSeCd]:input[value="+data.DSMSSL_SE_CD+"]").prop("checked", true);
			$("input:radio[name=rdoDsmsslSeCd]:input[value!="+data.DSMSSL_SE_CD+"]").prop("checked", false);
			$("#calDsmsslDe").val(data.DSMSSL_DE);
			$("#txtDsmsslResn").val(data.DSMSSL_RESN);
			$("#calReturnDe").val(data.RETURN_DE);
			$("#txtReturnResn").val(data.RETURN_RESN);
			fnReportList("ifrReport2", data.DOC_ID, "00451", "P_PRMISN_PROGRS_NO="+data.PRMISN_PROGRS_NO); // 작성문서목록
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnSetButton(str) {
		if(fnIsEmpty(str)) {
			$("#btnNew").show();
			$("#btnTrgterPop").show();
			$("#btnRereqst").hide();
			$("#btnDel").hide();
			$("#btnSave").show();
			$("#btnSaveResult").show();
		} else {
			if(str == "00737") { // 허가신청
				$("#btnNew").show();
				$("#btnTrgterPop").hide();
				$("#btnRereqst").hide();
				$("#btnDel").show();
				$("#btnSave").show();
				$("#btnSaveResult").show();
			} else if(str == "00738" || str == "00740") { // 허가, 반환
				$("#btnNew").show();
				$("#btnTrgterPop").hide();
				$("#btnRereqst").hide();
				$("#btnDel").hide();
				$("#btnSave").hide();
				$("#btnSaveResult").hide();
			} else if(str == "00739") {  // 기각
				$("#btnNew").show();
				$("#btnTrgterPop").hide();
				$("#btnRereqst").show();
				$("#btnDel").hide();
				$("#btnSave").hide();
				$("#btnSaveResult").hide();
			}
		}
	}

	// 신청내역 script start
	function fnSetTrAfterPermission(str) {
		if(fnIsEmpty(str)) {
			$("#trAfterPermission").css("display", "none");
		} else {
			if(str == "00743") { // 사후허가
				$("#trAfterPermission").css("display", "");
			} else {
				$("#trAfterPermission").css("display", "none");
			}
		}
	}

	function fnSetTrRerqest(sOrgNo) {
		if(fnIsEmpty(sOrgNo)) {
			$("#trRerqest").css("display", "none");
		} else {
			$("#trRerqest").css("display", "");
		}
	}

	function fnNew(){
		/* if(fnIsEmpty($("#schCaseNo1").val()) || fnIsEmpty($("#schCaseNo2").val()) || fnIsEmpty($("#hidCaseNo").val())) {
			alert("압수물 목록 조회를 먼저 실행하세요.");
			return;
		} */

		if(confirm("새로 신청하시겠습니까?")) {
			fnInit();
			//$("input:radio[name='rdoReqstResultCd']").removeAttr("checked");
			fnSetTrAfterPermission(null);
			fnSetTrRerqest(null);
			//fnOpenWin("<c:url value='../myCaseListPopup/'/>", "myCaseListPopup", "1200", "500", "no");

			myCaseListPopup = dhtmlmodal.open('myCaseListPopup', 'iframe', "<c:url value='../myCaseListPopup/'/>", '내사건목록', 'width=950px,height=500px,center=1,resize=0,scrolling=1')
			myCaseListPopup.onclose = function(){
				var iframedoc = this.contentDoc;
				$("#txtRcNo").val(iframedoc.getElementById("hidRcNo").value);
				$("#txtCaseNo").val(iframedoc.getElementById("hidCaseNo").value);
				$("#txtTrgterNm").show();
				$("#span_txtTrgterNm").html("");
				$("#span_txtCaseNo").html(iframedoc.getElementById("hidCaseNo").value);
				$("#span_txtVioltNm").html(iframedoc.getElementById("hidVioltNm").value);
				$("#span_txtCmptncExmnNm").html(iframedoc.getElementById("hidCmptncExmnNm").value);
				$("#span_txtAlotUserNm").html(iframedoc.getElementById("hidAlotUserNm").value);
				$("#span_txtAlotUserNm2").html(iframedoc.getElementById("hidAlotUserNm").value);
				return true;
			}
		}
	}

	function fnRereqst() {
		if(!fnIsEmpty($("#hidRereqstYn").val()) && $("#hidRereqstYn").val() == "Y") {
			alert("이미 재신청한 건으로 다시 재신청할 수 없습니다.");
			return;
		}
		if(confirm("재신청하시겠습니까?")) {
			var iUrl = "<c:url value='/inv/addCommnReAjax/'/>";
			var queryString = $('#frDetail').serialize();
			var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("재신청되었습니다.");
					fnSearch();
					fnDetail({PRMISN_PROGRS_NO:data.key});
				}else{
					alert("재신청중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnSave() {
		console.log("1) 진행번호:"+$("#hidPrmisnProgrsNo").val());
		console.log("2) 결과코드:"+$("#hidReqstResultCd").val());
		console.log("3) 원진행번호:"+$("#hidOrignlProgrsNo").val());

		var iUrl = "<c:url value='/inv/addCommnAjax/'/>";

		if(!fnIsEmpty($("#hidPrmisnProgrsNo").val())) {
			if(!fnIsEmpty($("#hidReqstResultCd").val()) && $("#hidReqstResultCd").val() != "00737") {
				alert("신청결과가 존재하여 수정할 수 없습니다.");
				return;
			}
			iUrl = "<c:url value='/inv/modCommnAjax/'/>";
		}

		// 필수 체크
		if(!fnFormValueCheck("frDetail")) return;
		if(!fnCheckDate($("#calReqstDe"))) return;

		// 사후허가
		if($("#selPrmisnSeCd").val() == "00743") {
			if(fnIsEmpty($("#txtNnpmsnpcResn").val())) {
				alert("미리 허가받지 못한 사유은(는) 필수입력 항목입니다.");
				$("#txtNnpmsnpcResn").focus();
				return;
			}
			if(fnIsEmpty($("#calExcutDt").val())) {
				alert("집행일시은(는) 필수입력 항목입니다.");
				$("#calExcutDt").focus();
				return;
			}
			if(!fnCheckDate($("#calExcutDt"))) return;
		}

		// 재신청
		if($("#hidOrignlProgrsNo").val()) {
			if(fnIsEmpty($("#txtRerqestResn").val())) {
				alert("재청구 사유은(는) 필수입력 항목입니다.");
				$("#txtRerqestResn").focus();
				return;
			}
		}

		if(confirm("저장하시겠습니까?")){
			var queryString = $('#frDetail').serialize();
			var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("저장되었습니다.");
					fnSearch();
				}else{
					alert("저장중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnDel() {
		if(fnIsEmpty($("#hidPrmisnProgrsNo").val())) return;
		if(!fnIsEmpty($("#hidReqstResultCd").val()) && $("#hidReqstResultCd").val() != "00737") {
			alert("신청결과가 존재하여 삭제할 수 없습니다.");
			return;
		}

		var iUrl = "<c:url value='/inv/delCommnAjax/'/>";

		if(confirm("삭제하시겠습니까?")){
			var queryString = $('#frDetail').serialize();
			var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("삭제되었습니다.");
					fnSearch();
				} else {
					alert("삭제중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnTrgterPop(){
		if(fnIsEmpty($("#txtCaseNo").val())) return;

		var sUrl = "<c:url value='../myCaseTrgterListPopup/'/>"
				 + "?schCaseNo="+$("#txtCaseNo").val()
				 + "&schRcNo="+$("#txtRcNo").val()
		//fnOpenWin(sUrl, "myCaseTrgterListPopup", "1200", "500", "no");

		myCaseTrgterListPopup = dhtmlmodal.open('myCaseTrgterListPopup', 'iframe', sUrl, '대상자 선택', 'width=950px,height=400px,center=1,resize=0,scrolling=1')
		myCaseTrgterListPopup.onclose = function(){
			var iframedoc = this.contentDoc;
			$("#txtTrgterSn").val(iframedoc.getElementById("hidTrgterSn").value);
			$("#txtTrgterNm").show();
			$("#txtTrgterNm").val(iframedoc.getElementById("hidTrgterNm").value);
			$("#span_txtTrgterNm").html("");
			$("#span_txtTrgterRrn").html(iframedoc.getElementById("hidTrgterRrn").value);
			$("#span_txtAdresAddr").html(iframedoc.getElementById("hidAdresAddr").value);
			$("#span_txtOccpCdNm").html(iframedoc.getElementById("hidOccpCdNm").value);
			return true;
		}
	}
	// 신청내역 script end

	// 신청결과 script start
	function fnSetDisplay(str) {
		if(str == "00739") { // 기각
			//fnSetPrmisnReadOnly(true);
			$("#tabPrimsn").css("display", "none");
			$("#tabDsmssl").css("display", "");
			$("#tabReturn").css("display", "none");
		} else if(str == "00740") { // 반환
			//fnSetPrmisnReadOnly(true);
			$("#tabPrimsn").css("display", "none");
			$("#tabDsmssl").css("display", "none");
			$("#tabReturn").css("display", "");
		} else {
			//fnSetPrmisnReadOnly(false);
			$("#tabPrimsn").css("display", "");
			$("#tabDsmssl").css("display", "none");
			$("#tabReturn").css("display", "none");
		}
	}

	function fnSaveResult() {
		if(!fnIsEmpty($("#hidReqstResultCd").val()) && $("#hidReqstResultCd").val() != "00737") {
			alert("신청결과가 존재하여 수정할 수 없습니다.");
			return;
		}

		var str = $("input:radio[name=rdoReqstResultCd]:checked").val();
		if(fnIsEmpty(str)) {
			alert("신청결과은(는) 필수입력 항목입니다.");
			$("input:radio[name=rdoReqstResultCd]").focus();
			return;
		}
		else if(str == "00738") { // 허가
			if(fnIsEmpty($("#txtPrmisnNo").val())) {
				alert("허가서 번호은(는) 필수입력 항목입니다.");
				$("#txtPrmisnNo").focus();
				return;
			}
			if(fnIsEmpty($("#calPrmisnRecptDe").val())) {
				alert("허가서 수령일자은(는) 필수입력 항목입니다.");
				$("#calPrmisnRecptDe").focus();
				return;
			}
			if(fnIsEmpty($("#calIsueDe").val())) {
				alert("발부일자은(는) 필수입력 항목입니다.");
				$("#calIsueDe").focus();
				return;
			}
			if(!fnCheckDate($("#calPrmisnRecptDe"))) return;
			if(!fnCheckDate($("#calIsueDe"))) return;
		}
		else if(str == "00739") { // 기각
			if(fnIsEmpty($("input:radio[name=rdoDsmsslSeCd]:checked").val())) {
				alert("기각구분은(는) 필수입력 항목입니다.");
				$("input:radio[name=rdoDsmsslSeCd]").focus();
				return;
			}
			if(fnIsEmpty($("#calDsmsslDe").val())) {
				alert("기각일자은(는) 필수입력 항목입니다.");
				$("#calDsmsslDe").focus();
				return;
			}
			if(fnIsEmpty($("#txtDsmsslResn").val())) {
				alert("기각사유은(는) 필수입력 항목입니다.");
				$("#txtDsmsslResn").focus();
				return;
			}
			if(!fnCheckDate($("#calDsmsslDe"))) return;
		}
		else if(str == "00740") { // 반환
			if(fnIsEmpty($("#calReturnDe").val())) {
				alert("반환일자은(는) 필수입력 항목입니다.");
				$("#calReturnDe").focus();
				return;
			}
			if(fnIsEmpty($("#txtReturnResn").val())) {
				alert("반환사유은(는) 필수입력 항목입니다.");
				$("#txtReturnResn").focus();
				return;
			}
			if(!fnCheckDate($("#calReturnDe"))) return;
		}

		var iUrl = "<c:url value='/inv/modCommnResultAjax/'/>";

		if(confirm("저장하시겠습니까?")){
			var queryString = $('#frResult').serialize();
			var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("저장되었습니다.");
					fnSearch();
				}else{
					alert("저장중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}
	// 신청결과 script end

	//tab이동
	function fnSend (pType) {
		$('#sendForm').attr('action', '<c:url value='/inv/zrlong/'/>');
		$('#hidsendTabIndex').val(pType);
		$("#hidsendCaseNo").val($("#txtCaseNo").val());
		$("#hidsendTrgterSn").val($("#txtTrgterSn").val());
		if(fnIsEmpty($("#hidsendCaseNo").val())) {
			if($("#selNoType").val()=="C") {
				$("#hidsendCaseNo").val($("#schNo1").val()+"-"+$("#schNo2").val());
			}
		}
		$('#sendForm').submit();
	}
</script>
<form id="sendForm">
	<input type="hidden" id="hidsendTabIndex" name="hidsendTabIndex"/>
	<input type="hidden" id="hidsendCaseNo" name="hidsendCaseNo" value="${hidCaseNo}"/>
	<input type="hidden" id="hidsendTrgterSn" name="hidsendTrgterSn" value="${hidTrgterSn}"/>
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

<form id="frSearch" name="frSearch" method="post">
<!-----검색박스 ------->
<div class="search_box mb_20">
	<div class="search_in">
		<div class="stitle w_70px ">신청일자</div>
		<div class="r_box">
			<div class="input_out w_100px fl">
				<input type="text" class="w_100p input_com" id="calReqstDeFrom" name="calReqstDeFrom" maxlength="10" onkeyup="fnRemoveChar(event)" checkName="신청일자">
				<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
			</div>
			<div class="sp_tx  fl">~</div>
			<div class="input_out w_100px  fl">
				<input type="text" class="w_100p  input_com" id="calReqstDeTo" name="calReqstDeTo" maxlength="10" onkeyup="fnRemoveChar(event)" checkName="신청일자">
				<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
			</div>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_70px">진행번호</div>
		<div class="r_box">
			<select id="selNoType" name="selNoType" class="w_80px input_com mr_5">
				<option value="P">진행번호</option>
				<option value="C">사건번호</option>
			</select>
			<input type="text" id="schNo1" name="schNo1" maxlength="4" class="w_70px input_com"/>
			-
			<input type="text" id="schNo2" name="schNo2" maxlength="6" class="w_70px input_com" onblur="fnSetNo(this)"/>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_100px">신청결과상태</div>
		<div class="r_box">
			<select id="selReqstResultCd" name="selReqstResultCd" class="w_120px input_com"></select>
		</div>
	</div>
	<a href="javascript:fnSearch();"><div class="go_search2">검색</div></a>
</div>
<!-----//검색박스 ------->
</form>

<!-- main tab -->
<div class="tabnbtn_box mb_10" id="mTab_box">
	<ul class="tabs">
		<li id="mTab1" onclick="fnSend(1)">체포/구속</li>
		<li id="mTab2" onclick="fnSend(2)">압수수색검증</li>
		<li id="mTab3" style="width: 180px;" class="current">통신사실확인허가신청</li>
	</ul>
</div>
<!-- main tab -->

<div class="com_box mb_30">
	<div class="tb_01_box">
		<div id="grid_list" class="gridResize" style="width:100%; height:215px; margin:0 auto;"></div>
	</div>
</div>

<!--본문시작 -->
<div class="tabnbtn_box">
<!--텝메뉴 -->
<div class="tab_box">
	<ul>
		<li><a href="javascript:void(0);" onclick="fnTab('D');" class="on">신청내역</a></li>
		<li><a href="javascript:void(0);" onclick="fnTab('R');" >신청결과</a></li>
	</ul>
</div>

<!--버튼 -->
<div id="divBtnDetail" class="right_btn">
	<a href="javascript:void(0);" id="btnNew" onclick="fnNew();" class="btn_st1 icon_n fl mr_5">신규</a>
	<a href="javascript:void(0);" id="btnRereqst" onclick="fnRereqst();" class="btn_st1 icon_n fl mr_5" style="display:none;">재신청</a>
	<a href="javascript:void(0);" id="btnDel" onclick="fnDel();" class="btn_st1 icon_n fl mr_5" style="display:none;">삭제</a>
	<a href="javascript:void(0);" id="btnSave" onclick="fnSave();" class="btn_st1 icon_n fl mr_5" style="display:none;">저장</a>
</div>
<div id="divBtnResult" class="right_btn">
	<a href="javascript:void(0);" id="btnSaveResult" onclick="fnSaveResult();" class="btn_st1 icon_n fl mr_5" style="display:none;">저장</a>
</div>

<!--테이블 시작 -->
<div id="divReqstDetail">
<form id="frDetail" name="frDetail" method="post">
<div class="com_box mb_30">
	<div class="tb_01_box">
		<table class="tb_01_h100">
		<colgroup>
			<col width="15%">
			<col width="45%">
			<col width="15%">
			<col width="25%">
		</colgroup>
		<tbody>
			<tr>
				<th>진행번호</th>
				<td>
					<span id="span_hidPrmisnProgrsNo"></span>
					<input type="hidden" id="hidPrmisnProgrsNo" name="hidPrmisnProgrsNo"/>
					<input type="hidden" id="hidReqstResultCd" name="hidReqstResultCd"/>
					<input type="hidden" id="hidOrignlProgrsNo" name="hidOrignlProgrsNo"/>
					<input type="hidden" id="hidRereqstYn" name="hidRereqstYn"/>
				</td>
				<th>신청일자</th>
				<td><!--달력폼-->
					<div class="calendar_box  w_150px  mr_5">
					<input type="text" class="w_100p input_com calendar" id="calReqstDe" name="calReqstDe" check="text" checkName="신청일자"/>
					<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div><!--//달력폼-->
				</td>
			</tr>
			<tr>
				<th>허가구분</th>
				<td>
					<select id="selPrmisnSeCd" name="selPrmisnSeCd" class="w_150px input_com" check="text" checkName="허가구분"></select>
				</td>
				<th>관할검찰</th>
				<td>
					<span id="span_txtCmptncExmnNm"></span>
				</td>
			</tr>
			<tr>
				<th>전기통신사업자</th>
				<td>
					<select id="selCommnBsnmCd" name="selCommnBsnmCd" class="w_150px input_com" check="text" checkName="전기통신사업자"></select>
				</td>
				<th>담당자</th>
				<td>
					<span id="span_txtAlotUserNm"></span>
				</td>
			</tr>
			<tr class="h_40px">
				<th>위반사항</th>
				<td>
					<span id="span_txtVioltNm"></span>
				</td>
				<th>사건번호</th>
				<td>
					<span id="span_txtCaseNo"></span>
					<input type="hidden" id="txtCaseNo" name="txtCaseNo" class="w_150px input_readonly" readonly/>
					<input type="hidden" id="txtRcNo" name="txtRcNo" class="w_150px input_readonly" readonly/>
				</td>
			</tr>
			<tr class="h_40px">
				<th>대상자</th>
				<td>
					<span id="span_txtTrgterNm"></span>
					<input type="hidden" id="txtTrgterSn" name="txtTrgterSn" check="text" checkName="대상자"/>
					<input type="text" id="txtTrgterNm" name="txtTrgterNm" class="w_150px input_com" readonly onfocus="fnTrgterPop()"/>
					<input type="button" id="btnTrgterPop" class="btn_search" onclick="fnTrgterPop()">
				</td>
				<th>주민등록번호</th>
				<td>
					<span id="span_txtTrgterRrn"></span>
				</td>
			</tr>
			<tr class="h_40px">
				<th>주거</th>
				<td>
					<span id="span_txtAdresAddr"></span>
				</td>
				<th>작업</th>
				<td>
					<span id="span_txtOccpCdNm"></span>
				</td>
			</tr>
			<tr>
				<th>필요한 자료의 범위</th>
				<td colspan="3">
					<input type="text" id="txtDtaScope" name="txtDtaScope" class="w_90p input_com" check="text" checkName="필요한 자료의 범위"/>
				</td>
			</tr>
			<tr>
				<th>요청 사유</th>
				<td colspan="3">
					<input type="text" id="txtRequstResn" name="txtRequstResn" class="w_90p input_com" check="text" checkName="요청사유"/>
				</td>
			</tr>
			<tr>
				<th>해당 가입자와의 연관성</th>
				<td colspan="3">
					<input type="text" id="txtSbscrberRelate" name="txtSbscrberRelate" class="w_90p input_com" check="text" checkName="해당 가입자와의 연관성"/>
				</td>
			</tr>
			<tr id="trRerqest" class="border_bottom_b" style="display:none;">
				<th>재청구 사유</th>
				<td colspan="3">
					<input type="text" id="txtRerqestResn" name="txtRerqestResn" class="w_90p input_com" checkName="재청구 사유"/>
				</td>
			</tr>
			<tr id="trAfterPermission" class="border_bottom_b" style="display:none;">
				<th>미리 허가받지 못한 사유</th>
				<td>
					<input type="text" id="txtNnpmsnpcResn" name="txtNnpmsnpcResn" class="w_90p input_com" checkName="미리 허가받지 못한 사유"/>
				</td>
				<th>집행일시</th>
				<td>
					<div class="calendar_box w_150px  mr_5">
					<input type="text" class="w_100p input_com calendar" id="calExcutDt" name="calExcutDt" checkName="집행일시"/>
					<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div>
				</td>
			</tr>
		</tbody>
		</table>
	</div>
</div>
</form>
<!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
<div>
	<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%" height="230px"></iframe>
</div>
</div>

<!-- 결과 -->
<div id="divReqstResult">
<form id="frResult" name="frResult" method="post">
<div class="com_box mb_30">
	<div class="tb_01_box">
		<table class="tb_01">
		<colgroup>
			<col width="15%">
			<col width="45%">
			<col width="15%">
			<col width="25%">
		</colgroup>
		<tbody>
			<tr>
				<th>진행번호</th>
				<td>
					<span id="span_hidPrmisnProgrsNo2"></span>
					<input type="hidden" id="hidPrmisnProgrsNo2" name="hidPrmisnProgrsNo"/>
					<input type="hidden" id="hidReqstResultCd2" name="hidReqstResultCd"/>
				</td>
				<th>신청결과</th>
				<td>
				<c:forEach var="list" items="${reqstResultCdList}" varStatus="status">
				<div class='input_radio2 t_left'><input type="radio" name="rdoReqstResultCd" value="${list.cd}" class="to-labelauty-icon"/>${list.cdNm}</div>
				</c:forEach>
				</td>
			</tr>
		</tbody>
		</table>
		<table id="tabPrimsn" class="tb_01">
		<colgroup>
			<col width="15%">
			<col width="45%">
			<col width="15%">
			<col width="25%">
		</colgroup>
		<tbody>
			<tr>
				<th>허가서 번호</th>
				<td>
					<input type="text" id="txtPrmisnNo" name="txtPrmisnNo" class="w_150px input_com" maxlength="11" check="text" checkName="허가서 번호"/>
				</td>
				<th>허가서 수령일자</th>
				<td>
					<div class="calendar_box  w_150px  mr_5">
					<input type="text" class="w_100p input_com calendar" id="calPrmisnRecptDe" name="calPrmisnRecptDe" check="text" checkName="허가서 수령일자"/>
					<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div>
				</td>
			</tr>
			<tr>
				<th>발부일자</th>
				<td>
					<div class="calendar_box  w_150px  mr_5">
					<input type="text" class="w_100p input_com calendar" id="calIsueDe" name="calIsueDe" check="text" checkName="발부일자" />
					<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div>
				</td>
				<th>담당자</th>
				<td>
					<span id="span_txtAlotUserNm2"></span>
				</td>
			</tr>
		</tbody>
		</table>
		<table id="tabDsmssl" class="tb_01" style="display:none;">
			<colgroup>
				<col width="15%">
				<col width="45%">
				<col width="15%">
				<col width="25%">
			</colgroup>
			<tr>
				<th>기각구분</th>
				<td>
					<c:forEach var="list" items="${dsmsslSeCdList}" varStatus="status">
					<div class='input_radio2 t_left'><input type="radio" name="rdoDsmsslSeCd" value="${list.cd}" class="to-labelauty-icon" />${list.cdNm}</div>
					</c:forEach>
				</td>
				<th>기각일자</th>
				<td>
					<div class="calendar_box  w_150px  mr_5">
					<input type="text" class="w_100p input_com calendar" id="calDsmsslDe" name="calDsmsslDe" checkName="기각일자"/>
					<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div>
				</td>
			</tr>
			<tr>
				<th>기각사유</th>
				<td colspan="3">
					<input type="text" id="txtDsmsslResn" name="txtDsmsslResn" class="w_90p input_com" checkName="기각사유"/>
				</td>
			</tr>
		</table>
		<table id="tabReturn" class="tb_01" style="display:none;">
			<colgroup>
				<col width="15%">
				<col width="85%">
			</colgroup>
			<tr>
				<th>반환일자</th>
				<td>
					<div class="calendar_box  w_150px  mr_5">
					<input type="text" class="w_100p input_com calendar" id="calReturnDe" name="calReturnDe" checkName="반환일자"/>
					<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div>
				</td>
			</tr>
			<tr>
				<th>반환사유</th>
				<td>
					<input type="text" id="txtReturnResn" name="txtReturnResn" class="w_90p input_com" checkName="반환사유"/>
				</td>
			</tr>
		</table>
	</div>
</div>
</form>
<!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
<div>
	<iframe name="ifrReport2" id="ifrReport2" scrolling="no" frameborder="0" width="100%" height="230px"></iframe>
</div>
</div>
</div>