<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<style type="text/css">
.grid_td_left {text-align:left}
.box_w2_1z{ width:70%; height: 100%;  float:left; box-sizing: border-box;  padding: 0px 10px 0px 0px }
.box_w2_2z{ width:30%; height: 100%; float:left; box-sizing: border-box; padding: 0px 0px 0px 10px}

	/*
		2021.08.11
		coded by dgkim
		수사시스템 화면 비율 조정
		권종열 사무관 요청
	*/
	#gridCaseList { height: 132px !important; }/* 사건목록 */
	#gridSuspctList, #gridVioltList, #gridRcordList, #gridCcdrcList, #gridZeroNoList { height: 150px !important; }/* 피의자 정보, 위반사항, 기록목록 정보, 압수물 정보, 통계원표 */
</style>
<script type="text/javascript">
	var sFormatId = "00452";  //송치양식
	var sProgrsSttusCd = "";
	var bFirst = true;

	$(document).ready(function(){
		//$("#btnCancel").hide();
		fnTopLst();
		fnDatePickerImg("calTrnDe", null, true);
		fnDatePickerImg("calRcordDe", null, true);
		initGrid();   // 그리드관련
		initGridTrn();   // 그리드관련
		gridResize(); // 그리드관련
		fnReportList("ifrReport", "", sFormatId, "", ""); // 작성문서목록 //'P_RC_NO=2018000001&P_TRGTER_SN=13'
		fnTab("S");
	});


	function fnTopLst () {
		$("#show").click(function(){
			$("#showinbox").show();
			 $("#show").hide();
			 $("#hide").show();
			 AUIGrid.resize("#gridCaseList");
		});
		$("#hide").click(function(){
			$("#showinbox").hide();
			 $("#show").show();
			 $("#hide").hide();
		});
	}

	function fnCheckCase() {
		if(!$("#hidRcNo").val()) {
			alert("처리할 사건을 선택하세요.");
			return false;
		}
		if(!$("#hidTrnNo").val()) {
			alert("먼저 송치할 사건을 저장 하세요.");
			return false;
		}
		return true;
	}

	var keyValueList = ${code1};  // 피의자 신병상태
	var keyValueList2 = ${code2}; // 위반사항 송치의견

	// 상단 공통 그리드
	function initGrid() {
		var columnLayoutT = [{
				headerText : "사건번호", dataField : "CASE_NO", width : 100,
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			}, {
				headerText : "접수번호", dataField : "RC_NO", width : 100,
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			}, {
				headerText : "입건일자", dataField : "PRSCT_DE", width : 120, dataType : "date", formatString : "yyyy-mm-dd"
			}, {
				headerText : "송치번호", dataField : "TRN_NO", width : 100,
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			}, {
				headerText : "송치일자", dataField : "TRN_DE", width : 120, dataType : "date", formatString : "yyyy-mm-dd"
			}, {
				headerText : "수사단서", dataField : "INV_PROVIS_NM", width : 100
			}, {
				headerText : "피의자", dataField : "TRGTER_NM", width : 150
			}, {
				headerText : "위반죄명", dataField : "VIOLT_NM", style : "grid_td_left", width : 200
			}
		];
 		var gridProsT = {
 	 		showRowNumColumn : true,
 			displayTreeOpen : true,
 			selectionMode : "singleRow",
 			triggerSelectionChangeOnCell:true,
 			showAutoNoDataMessage : false,
 			headerHeight : 30,
 			rowHeight: 30,
 			fillColumnSizeMode : true
 		};
		AUIGrid.create("#gridCaseList", columnLayoutT, gridProsT);
		AUIGrid.bind("#gridCaseList", "ready", function(event) {
			if(!fnIsEmpty("${hidRcNo}")) {
				if(bFirst) {
					var rows = AUIGrid.getRowIndexesByValue("#gridCaseList", "RC_NO", "${info.RC_NO}");
					AUIGrid.setSelectionByIndex("#gridCaseList", rows[0]);
					// AUIGrid.bind("#gridCaseList", "cellClick") 동일!!
					$("#form_ccdrc").resetForm();
					$("#form_rcord").resetForm();
					$("#schRcNo").val("${info.RC_NO}");
					$("#schCaseNo").val("${info.CASE_NO}");
					$("#schTrnNo").val("${info.TRN_NO}");
					$("#schTrgterSn").val("");
					$("#hidCcdrcTrnNo").val("${info.TRN_NO}");
					$("#hidRcordRcNo").val("${info.TRN_NO}");
					$("#txtTrnRmMsg").html("");
					//$("#txtRmMsg").html("");
					sProgrsSttusCd = "${info.PROGRS_STTUS_CD}";

					var selectedItems = AUIGrid.getSelectedItems("#gridCaseList");
					if(selectedItems.length <= 0) return;
					else $("#hide").click();

					fnSearch();
					bFirst = false;
				}
			}
		});
		AUIGrid.bind("#gridCaseList", "cellClick", function(event) {
			var items = event.item;
			$("#form_ccdrc").resetForm();
			$("#form_rcord").resetForm();
			$("#schRcNo").val(items.RC_NO);
			$("#schCaseNo").val(items.CASE_NO);
			$("#schTrnNo").val(items.TRN_NO);
			$("#schTrgterSn").val("");
			$("#hidCcdrcTrnNo").val(items.TRN_NO);
			$("#hidRcordRcNo").val(items.RC_NO);
			$("#txtTrnRmMsg").html("");
			//$("#txtRmMsg").html("");
			sProgrsSttusCd = items.PROGRS_STTUS_CD;

			$("#hide").click();
			fnSearch();
		});

		fnSearchGrid("/trn/caseListAjax/", "", "#gridCaseList");
	}

	// 송치업무 관련 그리드
	function initGridTrn() {

		var columnLayout = [{
				headerText : "성명", dataField : "TRGTER_NM", width : 70, editable : false
			}, {
				headerText : "주민번호", 	dataField : "TRGTER_RRN", width : 120, editable : false
			}, {
				headerText : "송치<span class='point'><img src='/img/point.png'/></span>", dataField : "TRN_YN", width : 40, visible : false,
				renderer : {
					type : "CheckBoxEditRenderer",
					showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
					editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
					checkValue : "Y", // true, false 인 경우가 기본
					unCheckValue : "N"
				}
			}, {
				headerText : "신병상태<span class='point'><img src='/img/point.png'/></span>", dataField : "IMPR_STTUS_CD", width : 100,
				labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
					var retStr = "";
					for(var i = 0 ; i < keyValueList.length ; i++) {
						if(keyValueList[i].cd == value) {
							retStr = keyValueList[i].cdNm;
							break;
						}
					}
					return retStr;
				},
				renderer : {
					type : "DropDownListRenderer",
					list : keyValueList, //key-value Object 로 구성된 리스트
					keyField : "cd", // key 에 해당되는 필드명
					valueField : "cdNm" // value 에 해당되는 필드명
				}
			}, {
				headerText : "지문원지작성번호", dataField : "FNGPRT_FORMS_NO", width : 120,
				/* editRenderer : {
					type : "InputEditRenderer",
					//onlyNumeric : true, // Input 에서 숫자만 가능케 설정
					// 에디팅 유효성 검사
					validator : function(oldValue, newValue, item) {

						var isValid = false;
						var msg = "";
						if(!fnIsEmpty(item.TRGTER_TY_CD) && item.TRGTER_TY_CD == "E") {
							isValid = fnIsEmpty(newValue);
							msg = "기업은 지문원지작성번호가 없습니다. 빈 값을 입력하세요.";
						} else{
							isValid = true;
						}
						
						/* else {
							var reg = /^(19|20)\d{2}-\d{6}$/;
							isValid = reg.test(newValue);
							msg = "2019-123456 형식으로 입력하세요.";
						}
						
						return { "validate" : isValid, "message" : msg };
					}
				} */  /* 2021-05-24 hsno 기업인 경우에도 지문원지작성번호 작성가능하도록 수정 */
			}, {
				headerText : "구속영장청구번호<span class='point'><img src='/img/icon_dot.png'/></span>", dataField : "ARSTT_RQEST_NO", width : 120
			}, {
				headerText : "피의자원표번호", dataField : "SUSPCT_ZERO_NO", width : 80, editable : false
			}, {
				headerText : "통신사실청구번호<span class='point'><img src='/img/icon_dot.png'/></span>", dataField : "COMMN_FACT_RQEST_NO", width : 120
			}
		];

		var columnLayoutV = [{
				headerText : "위반사항", dataField : "VIOLT_NM", style : "grid_td_left", editable : false, width : 100
			}, {
				headerText : "송치<span class='point'><img src='/img/point.png'/></span>", dataField : "TRN_YN", width : 60, visible : false,
				renderer : {
					type : "CheckBoxEditRenderer",
					showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
					editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
					checkValue : "Y", // true, false 인 경우가 기본
					unCheckValue : "N"
				}
			}, {
				headerText : "송치의견<span class='point'><img src='/img/point.png'/></span>", 	dataField : "TRN_OPINION_CD", width : 100,
				labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
					var retStr = "";
					for(var i = 0 ; i < keyValueList2.length ; i++) {
						if(keyValueList2[i].cd == value) {
							retStr = keyValueList2[i].cdNm;
							break;
						}
					}
					return retStr;
				},
				renderer : {
					type : "DropDownListRenderer",
					list : keyValueList2, //key-value Object 로 구성된 리스트
					keyField : "cd", // key 에 해당되는 필드명
					valueField : "cdNm" // value 에 해당되는 필드명
				}
			}
		];

		var gridPros = {
			showRowNumColumn : true,
			displayTreeOpen : true,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell : true,
			showAutoNoDataMessage : false,
			editBeginMode : "click",
			editable : true,
			enableDrag : false,
			enableDragByCellDrag : false,
			enableSorting : false,
			fillColumnSizeMode : true,
			headerHeight : 30,
			rowHeight: 30
		};

		AUIGrid.create("#gridSuspctList", columnLayout, gridPros);
		AUIGrid.create("#gridVioltList", columnLayoutV, gridPros);

		AUIGrid.bind("#gridSuspctList", "ready", function(event) {
			if(AUIGrid.getRowCount("#gridSuspctList") > 0) {
				AUIGrid.setSelectionByIndex("#gridSuspctList", 0);
				var selectedItems = AUIGrid.getSelectedItems("#gridSuspctList");
				var items = selectedItems[0].item;
				if(items.TRN_YN == "Y") {
					if(items.CHK == "N") {
					} else {
						fnGetViolt(items);
						$("#spanSuspct").html(items.TRGTER_NM+"의");
					}
				} else {
					AUIGrid.clearGridData("#gridVioltList");
					$("#spanSuspct").html("");
				}
			}
		});

		AUIGrid.bind("#gridSuspctList", "cellClick", function(event) {
			if(event.columnIndex == 0 || event.columnIndex == 1) {
				var items = event.item;
				//console.log("TRN_YN : "+items.TRN_YN);
				if(items.TRN_YN == "Y") {
					if(items.CHK == "N") {
						alert("송치 피의자 수정사항을 저장 후 처리하세요.");
					} else {
						fnGetViolt(items);
						$("#spanSuspct").html(items.TRGTER_NM+"의");
					}
				} else {
					alert("송치 피의자인 경우, 위반사항 조회 가능합니다.");
					AUIGrid.clearGridData("#gridVioltList");
					$("#spanSuspct").html("");
				}
			}
		});

		// 에디팅 시작 이벤트 바인딩
		AUIGrid.bind("#gridSuspctList", "cellEditBegin", function(event) {
			//console.log("  sProgrsSttusCd : "+sProgrsSttusCd);
			if(sProgrsSttusCd == "02123") return false;
		});

		/* 체크박스(라디오버턴) 클릭 이벤트 바인딩
		AUIGrid.bind(gridSuspctList, "rowCheckClick", function(event) {
			//console.log("rowIndex : " + event.rowIndex + ", id : " + event.item.id + ", name : " + event.item.name + ", checked : " + event.checked);
			var items = event.item;
			fnDetail(items);
		}); */

		//////////////////////////////////////////////////////////////////////////////////
		/////////////// 압수물총목록 start /////////////////////////////////////////////////
		var columnLayoutC = [{
				headerText : "송치<span class='point'><img src='/img/point.png'/></span>", dataField : "USE_YN", width : 70,
				renderer : {
					type : "CheckBoxEditRenderer",
					showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
					editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
					checkValue : "Y", // true, false 인 경우가 기본
					unCheckValue : "N"
				}
			}, {
				headerText : "물건명", dataField : "TRN_CCDRC_NM", style : "grid_td_left", editable : false
			}, {
				headerText : "수량", dataField : "TRN_CCDRC_QY", width : 100, editable : false
			}, {
				headerText : "기록정수<span class='point'><img src='/img/icon_dot.png'/></span>", dataField : "TRN_CCDRC_CO", width : 100
			}, {
				headerText : "비고<span class='point'><img src='/img/icon_dot.png'/></span>", dataField : "TRN_CCDRC_RM", width : 300, style : "grid_td_left"
			}
		];
		var gridProsC = {
			showRowNumColumn : true,
			showStateColumn : true,
			displayTreeOpen : true,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell : true,
			editBeginMode : "click",
			editable : true,
			enableDrag : false,
			enableDragByCellDrag : false,
			enableSorting : false,
			showAutoNoDataMessage : false,
			fillColumnSizeMode : true,
			headerHeight : 30,
			rowHeight: 30
		};

		AUIGrid.create("#gridCcdrcList", columnLayoutC, gridProsC);
		AUIGrid.bind("#gridCcdrcList", "cellClick", function(event) {
			var items = event.item;
			$("#hidCcdrcTrnNo").val(items.TRN_NO);
			$("#hidCcdrcSn").val(items.TRN_CCDRC_SN);
			$("#txtCcdrcNm").val(items.TRN_CCDRC_NM);
			$("#txtCcdrcQy").val(items.TRN_CCDRC_QY);
			$("#txtCcdrcCo").val(items.TRN_CCDRC_CO);
			$("#txtCcdrcSort").val(items.SORT_ORDR);
			$("#txtRm").val(items.TRN_CCDRC_RM);
		});

		/////////////// 압수물총목록 end /////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////

		//////////////////////////////////////////////////////////////////////////////////
		/////////////// 기록목록 start /////////////////////////////////////////////////
		var columnLayoutR = [{
				headerText : "서류표목<span class='point'><img src='/img/point.png'/></span>", dataField : "RCORD_NM", style : "grid_td_left"
			}, {
				headerText : "진술자<span class='point'><img src='/img/icon_dot.png'/></span>", dataField : "RCORD_STATER", width : 150
			}, {
				headerText : "작성일자<span class='point'><img src='/img/icon_dot.png'/></span>", dataField : "RCORD_DE", width : 120, dataType : "date", formatString : "yyyy-mm-dd",
				editRenderer : {
					type : "InputEditRenderer",
					onlyNumeric : true, // Input 에서 숫자만 가능케 설정
					maxlength : 8,
					// 에디팅 유효성 검사
					validator : function(oldValue, newValue, item) {
						var isValid = false;
						if(newValue && newValue.length == 8) {
							isValid = true;
						}
						isValid = fnChkDateVal(newValue);
						// 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
						return { "validate" : isValid, "message"  : "날짜를 정확하게 입력해 주세요." };
					}
				}
			}, {
				headerText : "면수<span class='point'><img src='/img/icon_dot.png'/></span>", dataField : "RCORD_CO", width : 100
			}
		];
		var gridProsR = {
			rowIdField : "RCORD_SN",
			showRowNumColumn : true,
			showStateColumn : true,
			displayTreeOpen : true,
			selectionMode : "singleRow",
			wrapSelectionMove : true,
			enterKeyColumnBase : true,
			triggerSelectionChangeOnCell : true,
			editBeginMode : "click",
			editable : true,
			enableDrag : true,
			enableDragByCellDrag : true,
			enableSorting : false,
			softRemoveRowMode : true,
			showAutoNoDataMessage : false,
			fillColumnSizeMode : true,
			headerHeight : 30,
			rowHeight: 30
		};

		AUIGrid.create("#gridRcordList", columnLayoutR, gridProsR);
		AUIGrid.bind("#gridRcordList", "cellClick", function(event) {
			var items = event.item;
			$("#hidRcordRcNo").val(items.RC_NO);
			$("#hidRcordSn").val(items.RCORD_SN);
			$("#txtRcordNm").val(items.RCORD_NM);
			$("#txtRcordStater").val(items.RCORD_STATER);
			$("#txtRcordCo").val(items.RCORD_CO);
			$("#calRcordDe").val(items.RCORD_DE);
			//$("#txtRcordSort").val(items.SORT_ORDR);
			$("#txtRm").val(items.TRN_RCORD_RM);
		});
		/////////////// 기록목록 end //////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////

		//////////////////////////////////////////////////////////////////////////////////
		/////////////// 통계원표 start /////////////////////////////////////////////////
		var columnLayoutZ = [{
				headerText : "통계원표", dataField : "FORMAT_NM", width : 150
			}, {
				headerText : "원표번호", dataField : "ZERO_NO", width : 150
			}, {
				headerText : "송치피의자", dataField : "TRGTER_NM", width : 120
			}, {
				headerText : "주민번호", dataField : "TRGTER_RRN", width : 150
			}, {
				headerText : "", dataField : "PBLICTE_SN",
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var btn = "원표생성";
					if(!fnIsEmpty(value)) btn = "원표보기";
					                                                        //fnReport(trnNo, rcNo, trgterSn, docId, zeroNo, formatId, pblicteSn)
					var template = "<a href=\"javascript:void(0);\" onClick=\"fnReport('"+item.TRN_NO+"','"+item.RC_NO+"','"+item.TRGTER_SN+"','"+item.DOC_ID+"','"+item.ZERO_NO+"', '"+item.FORMAT_ID+"','"+item.PBLICTE_SN+"');\" class=\"btn_td2 icon_n fl \">"+btn+"</a>";
					return template;
				}
			}
		];
		var gridProsZ = {
			showRowNumColumn : true,
			showStateColumn : true,
			displayTreeOpen : true,
			selectionMode : "singleRow",
			wrapSelectionMove : true,
			enterKeyColumnBase : true,
			triggerSelectionChangeOnCell : true,
			editBeginMode : "click",
			editable : false,
			enableDrag : false,
			enableDragByCellDrag : false,
			enableSorting : false,
			softRemoveRowMode : true,
			showAutoNoDataMessage : false,
			fillColumnSizeMode : true,
			headerHeight : 30,
			rowHeight: 30
		};

		AUIGrid.create("#gridZeroNoList", columnLayoutZ, gridProsZ);
		/////////////// 통계원표 end //////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////
	}

	function fnSetBtnShow(bool) {
		if(bool) {
			$("#btnSchExmn").show();
			$("input[name=btnNew]").show();
			$("input[name=btnSave]").show();
			$("input[name=btnDel]").show();
			//$("#btnAsk").show();
			$("#btnCompt").show();
			//$("#btnCancel").hide();
			$("#btnSaveSuspct").show();
			$("#btnSaveViolt").show();
		} else {
			$("#btnSchExmn").hide();
			$("input[name=btnNew]").hide();
			$("input[name=btnSave]").hide();
			$("input[name=btnDel]").hide();
			//$("#btnAsk").hide();
			$("#btnCompt").hide();
			//$("#btnCancel").show();
			$("#btnSaveSuspct").hide();
			$("#btnSaveViolt").hide();
		}

		$("#txtCcdrcNm").attr("readonly", !bool);
		$("#txtCcdrcQy").attr("readonly", !bool);
		$("#txtCcdrcCo").attr("readonly", !bool);
		$("#txtCcdrcSort").attr("readonly", !bool);
		$("#txtRm").attr("readonly", !bool);

		$("#txtRcordNm").attr("readonly", !bool);
		$("#txtRcordStater").attr("readonly", !bool);
		$("#txtRcordCo").attr("readonly", !bool);
		$("#calRcordDe").attr("readonly", !bool);
		//$("#txtRcordSort").attr("readonly", !bool);
	}

	function fnSearch() {
		var iUrl = "<c:url value='/trn/trnCaseInfoAjax/'/>";
		var queryString = $('#form_search').serialize();
		var processAfterGet = function(data) {
			if(data.result == "0") {
				alert("검색 결과가 없습니다.");
			} else {
				fnSetBtnShow(true);
				// form_detail
				$("#form_detail").resetForm();
				$("#hidTrnNo").val(data.TRN_NO);
				$("#span_hidTrnNo").html(fnChangeNo(data.TRN_NO));
				$("#hidCaseNo").val(data.CASE_NO);
				$("#hidRcNo").val(data.RC_NO);
				$("#span_hidCaseNo").html(fnChangeNo(data.CASE_NO));
				$("#calTrnDe").val(data.TRN_DE);
				$("#span_txtInvProvisNm").html(data.INV_PROVIS_NM);
				$("#txtEvdencDc").val(data.EVDENC_DC);
				$("#hidCmptncExmnCd").val(data.CMPTNC_EXMN_CD);
				$("#txtCmptncExmnNm").val(data.CMPTNC_EXMN_NM);
				$("#txtTrnRm").val(data.TRN_RM);
				// form_search
				$("#schTrnNo").val(data.TRN_NO);
				$("#schCaseNo").val(data.CASE_NO);
				$("#schRcNo").val(data.RC_NO);
				$("#schTrgterNo").val("");

				fnSearchGrid("/trn/trnRcordListAjax/", "form_search", "#gridRcordList");
				AUIGrid.clearGridData("#gridVioltList");
				$("#spanSuspct").html("");
				if(!fnIsEmpty(data.TRN_NO)) {
					fnSearchGrid("/trn/trnSuspctListAjax/", "form_search", "#gridSuspctList");
					fnSearchGrid("/trn/trnCcdrcListAjax/", "form_search", "#gridCcdrcList");
					fnSearchGrid("/trn/trnZeroNoListAjax/", "form_search", "#gridZeroNoList");
					fnReportList("ifrReport", data.DOC_ID, sFormatId, "P_TRN_NO="+data.TRN_NO, data.FILE_ID);

					if(data.newTrnNo) {
						fnSearchGrid("/trn/caseListAjax/", "", "#gridCaseList");
					}
				} else {
					AUIGrid.clearGridData("#gridSuspctList");
					AUIGrid.clearGridData("#gridCcdrcList");
					AUIGrid.clearGridData("#gridZeroNoList");
					fnReportList("ifrReport", "", sFormatId, "", "");
				}
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnGetViolt(oData) {
		$("#schTrnNo").val(oData.TRN_NO);
		$("#schCaseNo").val(oData.CASE_NO);
		$("#schRcNo").val(oData.RC_NO);
		$("#schTrgterSn").val(oData.TRGTER_SN);
		fnSearchGrid("/trn/trnVioltListAjax/", "form_search", "#gridVioltList");
		fnSearchGrid("/trn/trnZeroNoListAjax/", "form_search", "#gridZeroNoList");
	}

	function fnSave() {
		if(!fnCheckCase()) return;

		// 필수 체크
		if(!fnFormValueCheck("form_detail")) return;
		if(!fnCheckDate($("#calTrnDe"))) return;

		var iUrl = "<c:url value='/trn/addTrnAjax/'/>";
		var gubun = "A";
		if($("#hidTrnNo").val()) {
			iUrl = "<c:url value='/trn/modTrnAjax/'/>";
			gubun = "M";
		}
		var queryString = $("#form_detail").serialize();
		var processAfterGet = function(data) {
			if(data.result == "1") {
				alert("저장되었습니다.");
				if(gubun == "A") {
					$("#span_hidTrnNo").html(data.trnNo);
					$("#schTrnNo").val(data.trnNo);
					$("#hidTrnNo").val(data.trnNo);
					$("#hidCcdrcTrnNo").val(data.trnNo);
					fnSearchGrid("/trn/caseListAjax/", "", "#gridCaseList");
					fnSearchGrid("/trn/trnSuspctListAjax/", "form_search", "#gridSuspctList");
					//fnSearchGrid("/trn/trnVioltListAjax/", "form_search", "#gridVioltList");
					fnSearchGrid("/trn/trnCcdrcListAjax/", "form_search", "#gridCcdrcList");
					fnSearchGrid("/trn/trnRcordListAjax/", "form_search", "#gridRcordList");
					fnSearchGrid("/trn/trnZeroNoListAjax/", "form_search", "#gridZeroNoList");
					fnReportList("ifrReport", data.docId, sFormatId, "P_TRN_NO="+data.trnNo, data.fileId);
				}
			} else {
				alert("저장중 오류가 발생하였습니다.");
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnDel() {
		if(!fnCheckCase()) return;

		if(confirm("삭제하시겠습니까?")){
			var iUrl = "<c:url value='/trn/delTrnAjax/'/>";
			var queryString = $('#form_detail').serialize();
			var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("삭제되었습니다.");
					fnSearchGrid("/trn/caseListAjax/", "", "#gridCaseList");
					AUIGrid.clearGridData("#gridSuspctList");
					AUIGrid.clearGridData("#gridVioltList");
					$("#spanSuspct").html("");
					AUIGrid.clearGridData("#gridCcdrcList");
					AUIGrid.clearGridData("#gridRcordList");
					AUIGrid.clearGridData("#gridZeroNoList");
					fnReportList("ifrReport", "", sFormatId, "", "");
					$("#span_hidTrnNo").html("");
					$("#span_hidCaseNo").html("");
					$("#form_search").resetForm();
					$("#form_detail").resetForm();
					$("#form_ccdrc").resetForm();
					$("#form_rcord").resetForm();
				} else {
					alert("삭제중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnComptTrn() {
		if(!fnCheckCase()) return;

		if(!confirm("송치완료하시겠습니까?")) return;

		var iUrl = "<c:url value='/trn/completeTrnAjax/'/>";
		var queryString = $("#form_detail").serialize();
		var processAfterGet = function(data) {
			if(data.result == "1") {
				alert("송치완료 되었습니다.");
				fnSearchGrid("/trn/caseListAjax/", "", "#gridCaseList");
				fnSetBtnShow(false);
			} else {
				if(fnIsEmpty(data.message)) {
					alert("송치완료 중 오류가 발생하였습니다.");
				} else {
					alert(data.message);
				}
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	/* 2019-07-25 송치취소 없음(송치종결 사건을 해당 화면에서 조회하지 않음.)
	function fnCancel() {
		if(!fnCheckCase()) return;

		if(!confirm("송치취소하시겠습니까?")) return;

		var iUrl = "<c:url value='/trn/cancelTrnAjax/'/>";
		var queryString = $("#form_detail").serialize();
		var processAfterGet = function(data) {
			if(data.result == "1") {
				alert("송치취소 되었습니다.");
				fnSearchGrid("/trn/caseListAjax/", "", "#gridCaseList");
				fnSetBtnShow(true);
			} else {
				if(fnIsEmpty(data.message)) {
					alert("송치취소 중 오류가 발생하였습니다.");
				} else {
					alert(data.message);
				}
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}*/

	/* 송치요청 업무 삭제, 승인절차없이 바로 송치종결 처리
	function fnAsk() {
		if(!fnCheckCase()) return;

		var iUrl = "<c:url value='/trn/askTrnAjax/'/>";
		var queryString = $("#form_detail").serialize();
		var processAfterGet = function(data) {
			if(data.result == "1") {
				alert("승인요청 되었습니다.");
				fnSearchGrid("/trn/caseListAjax/", "", "#gridCaseList");
				fnSetBtnShow(false);
			} else {
				alert("승인요청 중 오류가 발생하였습니다.");
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}*/

	function fnSaveSuspct() {
		if(!fnCheckCase()) return;

		var gData = AUIGrid.getGridData("#gridSuspctList");
		if(gData.length > 0) {
			for(var i in gData) {
				if(fnIsEmpty(gData[i].IMPR_STTUS_CD)) {
					alert(gData[i].TRGTER_NM + "의 신병상태를 선택하세요.");
					return;
				}
			/* 	if(gData[i].TRGTER_TY_CD == "I" && fnIsEmpty(gData[i].FNGPRT_FORMS_NO)) {
					alert(gData[i].TRGTER_NM + "의 지문원지번호를 입력하세요.");
					return;
				} */
				/* if(gData[i].TRGTER_TY_CD != "I" && !fnIsEmpty(gData[i].FNGPRT_FORMS_NO)) { 
					alert("법인인 경우, 지문원지번호를 입력하지 않습니다.");
					return;
				} */  /* 2021-05-24 hsno 기업인 경우에도 지문원지작성번호 작성가능하도록 수정 */
			}
		}

		var editedRowItems = AUIGrid.getEditedRowItems("#gridSuspctList");
		if(editedRowItems.length == 0) {
			alert("수정한 자료가 없습니다.");
			return;
		}

		var data = fnAjaxAction("/trn/saveTrnSuspctAjax/", JSON.stringify({sList:editedRowItems}));
		if(data.result == "1") {
			alert("송치피의자 저장 되었습니다.");
			fnSearchGrid("/trn/trnSuspctListAjax/", "form_search", "#gridSuspctList");
			fnSearchGrid("/trn/trnZeroNoListAjax/", "form_search", "#gridZeroNoList");
			AUIGrid.clearGridData("#gridVioltList");
			$("#spanSuspct").html("");
		} else {
			alert("송치피의자 저장중 오류가 발생했습니다.");
		}
	}

	function fnSaveViolt() {
		if(!fnCheckCase()) return;

		var gData = AUIGrid.getGridData("#gridVioltList");
		if(gData.length > 0) {
			for(var i in gData) {
				if(fnIsEmpty(gData[i].TRN_OPINION_CD)) {
					alert(gData[i].VIOLT_NM + "의 송치의견을 선택하세요.");
					return;
				}
			}
		}

		var editedRowItems = AUIGrid.getEditedRowItems("#gridVioltList");
		if(editedRowItems.length == 0) {
			alert("수정한 자료가 없습니다.");
			return;
		}

		var data = fnAjaxAction("/trn/saveTrnVioltAjax/", JSON.stringify({vList:editedRowItems, trnNo:$("#schTrnNo").val()}));
		if(data.result == "1") {
			alert("위반사항 저장 되었습니다.");
			fnSearchGrid("/trn/trnVioltListAjax/", "form_search", "#gridVioltList");
			fnSearchGrid("/trn/trnZeroNoListAjax/", "form_search", "#gridZeroNoList");
		} else {
			alert("위반사항 저장중 오류가 발생했습니다.");
		}
	}

	// 2019-07-09
	function fnSaveCcdrcList() {
		if(!fnCheckCase()) return;

		var gdata = AUIGrid.getGridData("#gridCcdrcList");
		if(gdata.length == 0) {
			alert("저장할 압수물이 없습니다.");
			return;
		}

		/*
		var chkItems = AUIGrid.getItemsByValue("#gridCcdrcList", "USE_YN", "Y");
		console.log("chkItems.length: "+chkItems.length);
		if(chkItems.length == 0){
			alert("송치할 압수물을 선택하세요.");
			return;
		}*/

		var editedRowItems = AUIGrid.getEditedRowItems("#gridCcdrcList");
		if(editedRowItems.length == 0) {
			alert("수정한 자료가 없습니다.");
			return;
		}

		var data = fnAjaxAction("/trn/saveTrnCcdrcAjax/", JSON.stringify({cList:editedRowItems}));
		if(data.result == "1") {
			alert("압수물총목록이 저장 되었습니다.");
			fnSearchGrid("/trn/trnCcdrcListAjax/", "form_search", "#gridCcdrcList");
			AUIGrid.clearGridData("#gridCcdrcList");
		} else {
			alert("압수물총목록 저장중 오류가 발생했습니다.");
		}
	}

	function fnSaveCcdrc() {
		if(!fnCheckCase()) return;

		if(fnIsEmpty($("#hidCcdrcTrnNo").val())) return;

		// 필수 체크
		if(!fnFormValueCheck("form_ccdrc")) return;

		var iUrl = "<c:url value='/trn/modTrnCcdrcAjax/'/>";
		if(fnIsEmpty($("#hidCcdrcSn").val())) {
			iUrl = "<c:url value='/trn/addTrnCcdrcAjax/'/>";
		}

		var queryString = $("#form_ccdrc").serialize();
		var processAfterGet = function(data) {
			if(data.result == "1") {
				alert("저장되었습니다.");
				fnSearchGrid("/trn/trnCcdrcListAjax/", "form_search", "#gridCcdrcList");
				fnInitCcdrc();
			} else {
				alert("저장중 오류가 발생하였습니다.");
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnDelCcdrc() {
		if(!fnCheckCase()) return;

		if(fnIsEmpty($("#hidCcdrcTrnNo").val())) return;

		if(fnIsEmpty($("#hidCcdrcSn").val())) {
			alert("삭제할 자료를 선택하세요.");
			return;
		}

		if(confirm("삭제하시겠습니까?")){
			var iUrl = "<c:url value='/trn/delTrnCcdrcAjax/'/>";
			var queryString = $('#form_ccdrc').serialize();
			var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("삭제되었습니다.");
					fnSearchGrid("/trn/trnCcdrcListAjax/", "form_search", "#gridCcdrcList");
					fnInitCcdrc();
				}else{
					alert("삭제중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnInitCcdrc() {
		$("#form_ccdrc")[0].reset();
		$("#hidCcdrcSn").val("");
	}

	function fnBringRcord() {
		if(!fnCheckCase()) return;

		if(fnIsEmpty($("#hidRcordRcNo").val())) return;

		var iUrl = "<c:url value='/trn/bringTrnRcordAjax/'/>";
		var queryString = $("#form_rcord").serialize();
		var processAfterGet = function(data) {
			if(data.result == "1") {
				alert("저장되었습니다.");
				fnSearchGrid("/trn/trnRcordListAjax/", "form_search", "#gridRcordList");
				fnInitRcord();
			} else {
				alert("저장중 오류가 발생하였습니다.");
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnSaveRcord() {
		if(!fnCheckCase()) return;

		if(fnIsEmpty($("#hidRcordRcNo").val())) return;

		// 필수 체크
		if(!fnFormValueCheck("form_rcord")) return;

		//console.log("hidRcordRcNo : "+$("#hidRcordRcNo").val());
		//console.log("hidRcordSn : "+$("#hidRcordSn").val());

		var iUrl = "<c:url value='/trn/modTrnRcordAjax/'/>";
		if(fnIsEmpty($("#hidRcordSn").val())) {
			iUrl = "<c:url value='/trn/addTrnRcordAjax/'/>";
		}
		var queryString = $("#form_rcord").serialize();
		var processAfterGet = function(data) {
			if(data.result == "1") {
				alert("저장되었습니다.");
				fnSearchGrid("/trn/trnRcordListAjax/", "form_search", "#gridRcordList");
				fnInitRcord();
			} else {
				alert("저장중 오류가 발생하였습니다.");
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnDelRcord() {
		if(!fnCheckCase()) return;

		//console.log('hidRcordRcNo : '+ $("#hidRcordRcNo").val());
		//console.log('hidRcordSn : '+$("#hidRcordSn").val());
		if(fnIsEmpty($("#hidRcordRcNo").val())) return;

		if(fnIsEmpty($("#hidRcordSn").val())) {
			alert("삭제할 자료를 선택하세요.");
			return;
		}

		if(confirm("삭제하시겠습니까?")){
			var iUrl = "<c:url value='/trn/delTrnRcordAjax/'/>";
			var queryString = $('#form_rcord').serialize();
			var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("삭제되었습니다.");
					fnSearchGrid("/trn/trnRcordListAjax/", "form_search", "#gridRcordList");
					fnInitRcord();
				}else{
					alert("삭제중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnInitRcord() {
		$("#form_rcord")[0].reset();
		$("#hidRcordSn").val("");
	}

	/**
	 * 날짜 형식 체크
	 */
	function fnChkDateVal(str) {
		// 19xx~ 20xx 년만 가능
		var isDate = /^(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/.test(str.replace(/-/g,""));
		// 2월
		var twoMonth = /^\d{4}(02)\d{1,2}$/.test(str.replace(/-/g,""));
		// 말일
		var twoMLastday = /^\d{4}(02)(0[1-9]|[12][0-9])$/.test(str.replace(/-/g,""));

		if(str != "" && !isDate) {
			alert("작성일자가 날짜 형식이 아닙니다.");
			return false;
		}
		else if(str != "" && isDate) { // idDate True
			if(twoMonth) { // 그 중 2월이면
				if(!twoMLastday) { // 말일만 한번 더 점검
					alert("작성일자가 날짜 형식이 아닙니다.");
					return false;
				}
			}
		}
		return true;
	}

	function fnSaveRcordList() {
		if(!fnCheckCase()) return;

		/*var gdata = AUIGrid.getGridData("#gridRcordList");
		if(gdata.length == 0) {
			alert("저장할 기록목록이 없습니다.");
			return;
		}*/

		if(fnIsEmpty($("#hidRcordRcNo").val())) return;

		// 추가된 행 아이템들(배열)
		//var addedRowItems = AUIGrid.getAddedRowItems("#gridRcordList");

		// 수정된 행 아이템들(배열) : 수정된 필드와 수정안된 필드 모두를 얻음.
		//var editedRowItems = AUIGrid.getEditedRowItems("#gridRcordList");

		// 삭제된 행 아이템들(배열)
		//var removedRowItems = AUIGrid.getRemovedItems("#gridRcordList");

		// 삭제 처리된 아이템 있는지 보기
		var removedRows = AUIGrid.getRemovedItems("#gridRcordList", true);
		if(removedRows.length > 0) {
			// softRemoveRowMode 가 true 일 때 삭제를 하면 그리드 상에 마크가 되는데
			// 이를 실제로 그리드에서 삭제 함.
			AUIGrid.removeSoftRows("#gridRcordList");
		}

		var gridItems = AUIGrid.getGridData("#gridRcordList");

		if(gridItems.length > 0) {
			for(var i in gridItems) {
				var item = gridItems[i];
				if(!fnIsEmpty(item.RCORD_DE) && !fnChkDateVal(item.RCORD_DE)) {
					return;
				}
			}
		}

		var data = fnAjaxAction("/trn/saveTrnRcordAjax/", JSON.stringify({rList:gridItems, RC_NO:$("#hidRcordRcNo").val()}));
		if(data.result == "1") {
			alert("기록목록이 저장 되었습니다.");
			fnSearchGrid("/trn/trnRcordListAjax/", "form_search", "#gridRcordList");
			AUIGrid.clearGridData("#gridRcordList");
		} else {
			alert("기록목록 저장중 오류가 발생했습니다.");
		}
	}

	function fnAddRowRcord(str) {
		if(!fnCheckCase()) return;

		var rowPos = str;

		var item = new Object();
		item.RC_NO = $("#hidRcNo").val();
		item.RCORD_SN = "";
		item.RCORD_NM = "";
		item.RCORD_STATER = "";
		item.RCORD_CO = "";
		item.RCORD_DE = "";
		item.SORT_ORDR = "";

		// parameter
		// item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
		// rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
		AUIGrid.addRow("#gridRcordList", item, rowPos);
	};

	function fnDelRowRcord() {
		if(!fnCheckCase()) return;

		var rowPos = "selectedIndex";

		AUIGrid.removeRow("#gridRcordList", rowPos);
	}

	function fnGetZeroNoList() {
		if(!fnCheckCase()) return;

		fnSearchGrid("/trn/trnZeroNoListAjax/", "form_search", "#gridZeroNoList");
	}

	function fnSelectExmn(upcd, cd, nm){
		$("#hidCmptncExmnCd").val(cd);
		$("#txtCmptncExmnNm").val(nm);
		//console.log("검찰선택 : "+upcd+"/"+cd+"/"+nm);
	}

	function fnTab(str) {
		if(str == "S") {
			$("#tabSuspct").addClass("current");
			$("#tabCcdrc").removeClass("current");
			$("#tabRcord").removeClass("current");
			$("#tabZero").removeClass("current");
			$("#divSuspct").show();
			$("#divCcdrc").hide();
			$("#divRcord").hide();
			$("#divZero").hide();
		} else if(str == "C") {
			$("#tabSuspct").removeClass("current");
			$("#tabCcdrc").addClass("current");
			$("#tabRcord").removeClass("current");
			$("#tabZero").removeClass("current");
			$("#divSuspct").hide();
			$("#divCcdrc").show();
			$("#divRcord").hide();
			$("#divZero").hide();
		} else if(str == "R") {
			$("#tabSuspct").removeClass("current");
			$("#tabCcdrc").removeClass("current");
			$("#tabRcord").addClass("current");
			$("#tabZero").removeClass("current");
			$("#divSuspct").hide();
			$("#divCcdrc").hide();
			$("#divRcord").show();
			$("#divZero").hide();
		} else if(str == "Z") {
			$("#tabSuspct").removeClass("current");
			$("#tabCcdrc").removeClass("current");
			$("#tabRcord").removeClass("current");
			$("#tabZero").addClass("current");
			$("#divSuspct").hide();
			$("#divCcdrc").hide();
			$("#divRcord").hide();
			$("#divZero").show();
		}
	}

	function fnCaseDtlPop() {
		 if(fnIsEmpty($("#schCaseNo").val())) {
			alert("조회할 사건을 선택하세요.");
			return;
		}

		fnCaseDetailPopup($("#schRcNo").val(), $("#schCaseNo").val());
	}

	function fnReport(trnNo, rcNo, trgterSn, docId, zeroNo, formatId, pblicteSn) {
		if(fnIsEmpty(zeroNo)) {
			var inputParam = "P_TRN_NO="+trnNo;
			if(formatId == "00000000000000000074") {  // 피의자원표
				inputParam = "P_TRN_NO="+trnNo+"&P_RC_NO="+rcNo+"&P_TRGTER_SN="+trgterSn;
			}
			var iUrl = "<c:url value='/doc/reportAddAjax/'/>";
			var queryString = {
				'docId' : docId,
				'inputParam' : inputParam,
				'formatId' : formatId,
				'trnNo' : trnNo,
				'rcNo' : rcNo,
				'trgterSn' : trgterSn
			};
			var processAfterGet = function(data) {
				if(data.result == "1"){
					//fnReportView(data.doc_id, data.pblicte_sn);
					fnHwpctrl(data.doc_id, data.pblicte_sn, "통계원표", "");
					fnSearchGrid("/trn/trnZeroNoListAjax/", "form_search", "#gridZeroNoList");
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		} else {
			//fnReportView(docId, pblicteSn);
			fnHwpctrl(docId, pblicteSn, "통계원표", "");
		}
	}

</script>

<!-- 상단 조회 -->
<div class="sh_box">
	<button id="hide" class="showbtn"></button>
	<button id="show" class="hidebtn" style="display: none"></button>
	<div class="show_in" id="showinbox">
		<!--테이블 시작 -->
		<div class="com_box">
			<div id="gridCaseList" class="gridResize tb_01_box" style="width: 100%; height: 182px;"></div>
		</div>
	</div>
</div>
<!-- //상단 조회 -->

<!--검색박스 -->
<form id="form_search" name="form_search" method="post">
<input type="hidden" id="schRcNo" name="schRcNo">
<input type="hidden" id="schCaseNo" name="schCaseNo">
<input type="hidden" id="schTrnNo" name="schTrnNo">
<input type="hidden" name="schTrgterSn" id="schTrgterSn">
</form>
<!--//검색박스 -->

<!-- start ---------------------------------------- -->
<form id="form_detail" name="form_detail" method="post">
<input type="hidden" name="hidTrnNo" id="hidTrnNo">
<input type="hidden" name="hidCaseNo" id="hidCaseNo">
<input type="hidden" name="hidRcNo" id="hidRcNo">
<div class="box_w2">
	<div class="box_w2_1b" style="height:250px;">
		<div class="title_s_st2 w_100px fl">
			<img src="/img/title_icon1.png" alt="" />송치기본정보
		</div>
		<div class="right_btn fr" style="margin-bottom: 8px;">
			<a href="javascript:void(0);" class="btn_st2_2 icon_n fl mr_m1" onclick="fnCaseDtlPop();">사건상세조회</a>
			<input type="button" name="btnSave" value="저장" class="btn_st2 icon_n fl mr_1" onclick="fnSave();">
			<input type="button" name="btnDel" value="삭제" class="btn_st2 icon_n fl mr_1" onclick="fnDel();">
			<input type="button" id="btnCompt" value="송치완료" class="btn_st2 icon_n fl mr_1" onclick="fnComptTrn();">
			<%-- <input type="button" id="btnCancel" value="송치취소" class="btn_st2 icon_n fl mr_1" onclick="fnCancel();"> --%>
			<%-- <input type="button" id="btnAsk" value="승인요청" class="btn_st2 icon_n fl mr_1" onclick="fnAsk();"> --%>
		</div>
		<!--테이블 시작 -->
		<div class="tb_01_box">
		<table class="tb_01_h100">
			<col width="15%"/>
			<col width="35%"/>
			<col width="15%"/>
			<col width="35%"/>
			<tbody>
				<tr>
					<th>송치번호</th>
					<td>
						<span id="span_hidTrnNo"></span>
					</td>
					<th>사건번호</th>
					<td>
						<span id="span_hidCaseNo"></span>
					</td>
				</tr>
				<tr>
					<th>송치일자<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td>
						<div class="calendar_box  w_150px  mr_5">
						<input type="text" name="calTrnDe" id="calTrnDe" class="w_100p input_com calendar" readonly check="text" checkName="송치일자">
						<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
						</div>
					</td>
					<th>관할검찰<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td><div class="flex_r">
						<input type="hidden" id="hidCmptncExmnCd" name="hidCmptncExmnCd"/>
						<input type="text" id="txtCmptncExmnNm" name="txtCmptncExmnNm" class="w_200px input_com" check="text" checkName="관할검찰" readonly onfocus="fnExmnSelect()"/>
						<input type="button" id="btnSchExmn" class="btn_search" onclick="fnExmnSelect()">
						</div>
					</td>
				</tr>
				<tr>
					<th>수사단서</th>
					<td colspan="3"><span id="span_txtInvProvisNm"></span></td>
				</tr>
				<tr>
					<th>증거품</th>
					<td colspan="3"><input type="text" id="txtEvdencDc" name="txtEvdencDc"  maxlength="200" class="w_95p input_com" checkName="증거품"/></td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="3"><input type="text" id="txtTrnRm" name="txtTrnRm"  maxlength="200" class="w_95p input_com" checkName="비고"/></td>
				</tr>
			</tbody>
		</table>
		</div>
	</div>
	<div class="box_w2_2b">
		<!--테이블 시작 -->
		<!--테이블 시작 -->
		<div class="box_w2 mb_30">
			<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="295"></iframe>
		</div>
	</div>
</div>
</form>
<!-- end ---------------------------------------- -->
<div class="tabnbtn_box mb_10">
	<ul class="tabs">
		<li id="tabSuspct" class="current" onclick="fnTab('S')">사건송치서</li>
		<li id="tabCcdrc" onclick="fnTab('C')">압수물총목록</li>
		<li id="tabRcord" onclick="fnTab('R')">기록목록</li>
		<li id="tabZero" onclick="fnTab('Z')">통계원표</li>
	</ul>
</div>
<!-- start ---------------------------------------- -->
<div class="contents marginbot">
<div id="divSuspct" class="tabscontent">
<div class="box_w2">
	<div class="box_w2_1z">
		<div class="title_s_st2 w_150px fl">
			<img src="/img/title_icon1.png" alt="" />피의자 정보
		</div>
		<div class="right_btn fr" style="margin-bottom: 8px;">
			<input type="button" id="btnSaveSuspct" value="저장" class="btn_st2 icon_n fl mr_1" onclick="fnSaveSuspct();">
		</div>
		<!--테이블 시작 -->
		<div class="com_box ">
			<!-- 그리드 -->
			<div class="com_box mb_30">
				<div class="tb_01_box">
					<div id="gridSuspctList" class="gridResize" style="width:100%; height:240px; margin:0 auto;"></div>
				</div>
			</div>
			<!-- //그리드 -->
		</div>
	</div>
	<div class="box_w2_2z">
		<div class="title_s_st2 w_300px fl" >
			<img src="/img/title_icon1.png" alt="" /><span id="spanSuspct"></span>&nbsp;위반사항
		</div>
		<div class="right_btn fr" style="margin-bottom: 8px;">
			<input type="button" id="btnSaveViolt" value="저장" class="btn_st2 icon_n fl mr_1" onclick="fnSaveViolt();">
		</div>
		<!--테이블 시작 -->
		<div class="com_box ">
			<!-- 그리드 -->
			<div class="com_box mb_30">
				<div class="tb_01_box">
					<div id="gridVioltList" class="gridResize" style="width:100%; height:240px; margin:0 auto;"></div>
				</div>
			</div>
			<!-- //그리드 -->
		</div>
	</div>
</div>
</div> <!-- 피의자 end -->
<div id="divCcdrc" class="tabscontent">
<form id="form_ccdrc" name="form_ccdrc" method="post">
<div class="box_w2 mb_20">
	<!----------가로 좌측 압수물 정보 ------------>
	<!-- <div class="box_w2_1b"> -->
		<div class="title_s_st2 w_50p fl mb_8">
			<img src="/img/title_icon1.png" alt="" />압수물 정보
		</div>
		<div class="right_btn fr" style="margin-bottom: 8px;">
			<input type="button" id="btnSaveCcdrcList" value="저장" class="btn_st2 icon_n fl mr_1" onclick="fnSaveCcdrcList();">
		</div>
		<!--테이블 시작 -->
		<div class="com_box ">
			<div class="tb_01_box">
				<div id="gridCcdrcList" class="gridResize" style="width:100%; height:240px; margin:0 auto;"></div>
			</div>
		</div>
	<!-- </div> -->
	<!---------- //가로 좌측 ------------>
</div>
<!----------//가로2칸 ------------>
</form>
</div> <!-- 압수물총목록 end -->
<div id="divRcord" class="tabscontent">
<form id="form_rcord" name="form_rcord" method="post">
<input type="hidden" name="hidRcordRcNo" id="hidRcordRcNo">
<div class="box_w2 mb_20">
	<!----------가로 좌측 압수물 정보 ------------>
	<!-- <div class="box_w2_1b"> -->
		<div class="title_s_st2 w_50p fl mb_8">
			<img src="/img/title_icon1.png" alt="" />기록목록 정보
		</div>
		<div class="right_btn fr" style="margin-bottom: 8px;">
			<%-- 문서가져오기는 '지휘건의'에서 먼저 처리함.
			<input type="button" id="btnBringRcord" value="가져오기" class="btn_st2 icon_n fl" onclick="fnBringRcord();"> --%>
			<a href="javascript:fnSaveRcordList()" class="btn_st2 icon_n fr mr_m1">저장</a>
			<a href="javascript:fnDelRowRcord()" class="btn_st2 icon_n fr mr_m1">삭제</a>
			<a href="javascript:fnAddRowRcord('selectionDown')" class="btn_st2 icon_n fr mr_m1">추가</a>
			<a href="javascript:fnAddRowRcord('first')" class="btn_st2 icon_n fr mr_m1">첫번째 행추가</a>
		</div>
		<!--테이블 시작 -->
		<div class="com_box ">
			<div class="tb_01_box">
				<div id="gridRcordList" class="gridResize" style="width:100%; height:240px; margin:0 auto;"></div>
			</div>
		</div>
	<!-- </div> -->
	<!---------- //가로 좌측 ------------>
</div>
</form>
</div> <!-- 기록목록 end -->
<!-- 통계원표 start -->
<div id="divZero" class="tabscontent">
<form id="form_zero" name="form_zero" method="post">
<div class="box_w2 mb_20">
	<!----------가로 좌측 압수물 정보 ------------>
	<!-- <div class="box_w2_1b"> -->
		<div class="title_s_st2 w_50p fl mb_8">
			<img src="/img/title_icon1.png" alt="" />통계원표
		</div>
		<div class="right_btn fr" style="margin-bottom: 8px;">
			<a href="javascript:fnGetZeroNoList();" class="btn_st2 icon_n fr mr_m1">조회</a>
		</div>
		<!--테이블 시작 -->
		<div class="com_box ">
			<div class="tb_01_box">
				<div id="gridZeroNoList" class="gridResize" style="width:100%; height:240px; margin:0 auto;"></div>
			</div>
		</div>
	<!-- </div> -->
	<!---------- //가로 좌측 ------------>
</div>
</form>
</div> <!-- 통계원표 end -->
</div>
<!-- end ---------------------------------------- -->

