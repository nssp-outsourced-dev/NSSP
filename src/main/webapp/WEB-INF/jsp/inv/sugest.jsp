<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style type="text/css">
.ntBrdCss .ntSelCss {
	border: 0px solid #fff;
	background-color: #fff !important;
}
input[type=radio] {
  visibility: visible; float: none;
}
.tbLft {
	text-align: left;
}
</style>
<script type="text/javascript">

var myGridID;

	$(document).ready(function(){
		fnTopLst ();
		initGrid ();
		initTrgterGrid();
		fnDoc("", "", "");

		fnDatePickerImg("txtSugestDe");
		fnDatePickerImg("txtCmndDe");

		$('#btnRcord').hide();
		$('#btnClear').hide();
		$('#btnAdd').hide();
		//$('#btnDelete').hide();


        $('#txtSugestCn').keyup(function(){
			fnLimitString('txtSugestCn', 2000, 'txtSugestCnMsg');
        });
        $('#txtCmndCn').keyup(function(){
			fnLimitString('txtCmndCn', 2000, 'txtCmndCnMsg');
        });


        $("#divSugest").show();		//기록목록을 제외란 나머지 탭
		$("#divSugestRcord").hide();//기록목록 탭

	});

	function fnSetRow (gId, gCol, gVal, gPos) {
		var rows = AUIGrid.getRowIndexesByValue(gId,gCol,gVal);
		if(!fnIsEmpty(rows) && rows[0] > -1) {
			AUIGrid.setSelectionByIndex(gId, rows[0], gPos);
		}
	}

	function fnTopLst () {
		$("#show").click(function(){
			$("#showinbox").show();
			$("#show").hide();
			$("#hide").show();

			gridResize();
	    });
	    $("#hide").click(function(){
			$("#showinbox").hide();
			$("#show").show();
			$("#hide").hide();
	    });
	}
	function fnDoc(pDocId, pParam, pFileId) {
		fnReportList('ifrReport', pDocId, $("#formatClCd").val(), pParam, pFileId);
	}

	function initGrid () {
		var columnLayout1 = [
			{ dataField : "RC_NO", headerText : "접수번호", width : 120, visible : false},
			{ dataField : "CASE_IV_NO", headerText : "사건/내사번호", width : 120,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			},
			{ dataField : "PRSCT_DE", headerText : "입건일자", width : 130, dataType : "date", formatString : "yyyy-mm-dd"},
			{ dataField : "INV_PROVIS_NM", headerText : "수사단서", width : 100 },
			{ dataField : "RC_SE_NM",	   headerText : "사건구분", width : 100 },
			{ dataField : "TRGTER_NM_S", headerText : "피의자",  width : 150 },
			{ dataField : "VIOLT_NM", headerText : "위반죄명", style:'tbLft' }
		];
		var columnLayout2 = [
			{ dataField : "SUGEST_NO", headerText : "지휘건의번호",
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			},
			{ dataField : "RC_NO", headerText : "RC_NO", visible : false},
			{ dataField : "TRGTER_SN", headerText : "TRGTER_SN", visible : false},
			{ dataField : "DOC_ID", headerText : "DOC_ID", visible : false},
			{ dataField : "SUGEST_TY_NM", headerText : "건의구분"},
			{ dataField : "SUGEST_DE", headerText : "건의일자", width : 130, dataType : "date", formatString : "yyyy-mm-dd"},
			{ dataField : "CMND_DE", headerText : "지휘일자", width : 130, dataType : "date", formatString : "yyyy-mm-dd"},
			{ dataField : "SUGEST_RESULT_NM", headerText : "건의결과" },
			{ dataField : "TRGTER_NM_S", headerText : "피의자성명"},
		];

		var gridPros = {
			rowNumHeaderText:"순번",
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true,
			//showRowNumColumn : false,
			selectionMode : "singleRow"
		};
		AUIGrid.create("#grid_case_list",columnLayout1,gridPros);
		AUIGrid.create("#grid_sugest_list",columnLayout2,gridPros);

		AUIGrid.bind("#grid_case_list", "cellClick", function(event) {
			var items = event.item;
			$("#rcNo").val(items.RC_NO);
			$("#schRcNo").val(items.RC_NO);
			$("#hidRcordRcNo").val(items.RC_NO);

			fnSugestSearch();

			if( $("#sugestTyCd").val() == "${suggest_case1}" ){			//수사지휘 Tab
				fnTrgterSearch();
			} else if( $("#sugestTyCd").val() == "${suggest_case2}" ){	//피의자 석방 Tab
				fnArrstSearch();
			} else if( $("#sugestTyCd").val() == "${suggest_case3}" ){	//압수물 지휘 Tab
				fnCcdrcSearch();
			} else if( $("#sugestTyCd").val() == "sugestRcord"){		//기록목록 Tab

				fnSugestRcordSearch();
			}

			fnClear( $("#sugestTyCd").val() );

			$("#hide").click();
			//검찰청
			$("#tdCmptncExmnNm").text(items.CMPTNC_EXMN_NM);
		});
		AUIGrid.bind("#grid_sugest_list", "cellClick", function(event) {
			var items = event.item;
			fnSelect(items.SUGEST_NO);
		});

		AUIGrid.bind("#grid_case_list", "ready", function(event) {
			//접수번호 및 작성 세팅
			if("${rcNo}" != ""){
				$("#rcNo").val("${rcNo}");
				fnTabDisplay("${sugestTyCd}");
				fnTabGridSet("${sugestTyCd}");
				fnSetRow("#grid_case_list", "RC_NO", "${rcNo}", 0);

				fnSugestSearch();

				if( $("#sugestTyCd").val() == "${suggest_case1}" ){
					fnTrgterSearch();
				} else if( $("#sugestTyCd").val() == "${suggest_case2}" ){
					fnArrstSearch();
				} else if( $("#sugestTyCd").val() == "${suggest_case3}" ){
					fnCcdrcSearch();
				} else if( $("#sugestTyCd").val() == "sugestRcord"){
					fnSugestRcordSearch();
				}

				fnClear();
			}

			if(!fnIsEmpty($("#addForm").find("#rcNo").val())) {
				fnSetRow("#grid_case_list", "RC_NO", $("#addForm").find("#rcNo").val(), 0);
			}
		});

		AUIGrid.bind("#grid_sugest_list", "ready", function(event) {
			var hidSno = $("#hidSugestNo").val();
			if(!fnIsEmpty(hidSno)) {
				fnSetRow("#grid_sugest_list", "SUGEST_NO", hidSno, 0);
			}
		});

		fnCaseSearch();
	}

	function fnCaseSearch() {
		fnSearchGrid("/inv/sugestCaseListAjax/", "addForm", "#grid_case_list");
	}
	function fnSugestSearch() {
		fnSearchGrid("/inv/sugestListAjax/", "addForm", "#grid_sugest_list");
	}


	/* ============== 탭별 그리드 분기(대상자, 대상자_라디오, 압수물)) ================ */

	function initTrgterGrid() {
		AUIGrid.destroy("#grid_trgter_list");
		var columnLayout = [
			{ dataField : "TRGTER_SN", headerText : "TRGTER_SN", visible : false},
            { dataField : "CASE_IV_NO", headerText : "사건번호",
            	renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
            },
            { dataField : "TRGTER_NM", headerText : "대상자명"},
            { dataField : "TRGTER_RRN", headerText : "주민번호" }
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true,
			rowNumHeaderText:"순번",
			selectionMode : "singleRow",	// 선택모드 (기본값은 singleCell 임)
	    	triggerSelectionChangeOnCell:true,
			//noDataMessage:"조회 목록이 없습니다."
		};

		myGridID = AUIGrid.create("#grid_trgter_list",columnLayout,gridPros);
		fnTrgterSearch();
	}

	function initArrstGrid() {
		AUIGrid.destroy("#grid_trgter_list");
		var columnLayout = [
			{ dataField : "PK_SN", headerText : "PK_SN", visible : false},
			{ dataField : "TRGTER_SN", headerText : "TRGTER_SN", visible : false},
			{ dataField : "ARRST_SN", headerText : "ARRST_SN", visible : false},
            { dataField : "RC_NO", headerText : "RC_NO", visible : false},
            { dataField : "TRGTER_NM", headerText : "대상자명"},
            { dataField : "TRGTER_RRN", headerText : "주민번호"},
            { dataField : "ARRST_TY_NM", headerText : "체포유형", style:'tbLft' },
            { dataField : "ARRST_DT", headerText : "체포일시"},
            { dataField : "RSL_DT", headerText : "석방일시"}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true,
			showRowNumColumn : false,
			showRowCheckColumn : true,
			rowCheckToRadio : true,
			selectionMode : "singleRow",
			showEditedCellMarker : false
		};

		myGridID = AUIGrid.create("#grid_trgter_list",columnLayout,gridPros);

		AUIGrid.bind(myGridID, "ready", function( event ) {
			AUIGrid.setCheckedRowsByValue(myGridID, "PK_SN", $('#hidPkSn').val());
		});
		fnArrstSearch();
	}

	function initCcdrcGrid() {
		AUIGrid.destroy("#grid_trgter_list");
		var columnLayout = [
			{
				dataField : "SUGEST_YN",
				headerText : "",
				width: 60,
				headerRenderer : {
					type : "CheckBoxHeaderRenderer",
					dependentMode : true,
					position : "bottom" // 기본값 "bottom"
				},
				renderer : {
					type : "CheckBoxEditRenderer",
					showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
					editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
					checkValue : "Y", // true, false 인 경우가 기본
					unCheckValue : "N"
				}
			},
			{ dataField : "CCDRC_NO", headerText : "압수번호",
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			},
			{ dataField : "CCDRC_SN", headerText : "연번", width : 50},
            { dataField : "SZURE_DE", headerText : "압수일자"},
            { dataField : "CCDRC_CL_CD_NM", headerText : "분류"},
            { dataField : "CCDRC_NM", headerText : "품종", style:'tbLft'},
            { dataField : "CCDRC_QY", headerText : "수량", width : 50},
            { dataField : "CF_SZURE_TRGTER_NM", headerText : "소지(제출)자"},
            { dataField : "CF_POSESN_TRGTER_NM", headerText : "소유자", style:'tbLft' },
            { dataField : "DSPS_CD_NM", headerText : "처분결과"}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true,
			useGroupingPanel : false,
			showRowNumColumn : false,
			showEditedCellMarker : false,
		};

		myGridID = AUIGrid.create("#grid_trgter_list",columnLayout,gridPros);
		fnCcdrcSearch();
	}


	function fnTrgterSearch() {
		fnSearchGrid("/inv/sugestCaseTrgterListAjax/", "addForm", "#grid_trgter_list");
	}

	function fnArrstSearch() {
		fnSearchGrid("/inv/sugestCaseArrstListAjax/", "addForm", "#grid_trgter_list");
	}

	function fnCcdrcSearch() {
		fnSearchGrid("/inv/sugestCcdrcListAjax/", "addForm", "#grid_trgter_list");
	}



	/* ============== 탭별 그리드 분기(대상자, 체포, 압수물, 기록목록) ================	last update 2019.09.27 hsw */

	function fnTabDisplay(gbn){
		$("#sugestTyCd").val(gbn);

		if( gbn == "${suggest_case1}"){
			$("#btn_${suggest_case1}").attr("class","current");
			$("#btn_${suggest_case2}").attr("class","");
			$("#btn_${suggest_case3}").attr("class","");
			$("#btn_sugestRcord").attr("class","");
			//건의분류 조정
			//$("#tdSugestDe").attr("colspan","3");
			$("#thSugestCl").hide();
			$("#tdSugestCl").hide();
			$(".trCmndMsg").css("height",70);
			$("#grid_trgter_list").css("height",231);
		} else if(gbn == "${suggest_case2}"){
			$("#btn_${suggest_case1}").attr("class","");
			$("#btn_${suggest_case2}").attr("class","current");
			$("#btn_${suggest_case3}").attr("class","");
			$("#btn_sugestRcord").attr("class","");
			//건의분류 조정
			//$("#tdSugestDe").attr("colspan","3");
			$("#thSugestCl").hide();
			$("#tdSugestCl").hide();
			$(".trCmndMsg").css("height",70);
			$("#grid_trgter_list").css("height",231);
		} else if(gbn == "${suggest_case3}"){
			$("#btn_${suggest_case1}").attr("class","");
			$("#btn_${suggest_case2}").attr("class","");
			$("#btn_${suggest_case3}").attr("class","current");
			$("#btn_sugestRcord").attr("class","");
			//건의분류 조정
			//$("#tdSugestDe").attr("colspan","1");
			$("#btn_${suggest_case3}").attr("class","current");
			$("#thSugestCl").show();
			$("#tdSugestCl").show();
			$(".trCmndMsg").css("height",110);
			$("#grid_trgter_list").css("height",271);
		} else if(gbn == "sugestRcord"){
			$("#btn_${suggest_case1}").attr("class","");
			$("#btn_${suggest_case2}").attr("class","");
			$("#btn_${suggest_case3}").attr("class","");
			$("#btn_sugestRcord").attr("class","current");
			$("#tdSugestCl").hide();
			$("#thSugestCl").hide();
			$("#tdSugestCl").hide();

		}
		AUIGrid.resize("#grid_trgter_list");
	}

	function fnTabGridSet(gbn){

		if(gbn == "${suggest_case1}"){
			//문서분류
			$("#formatClCd").val("${format_case1}");
			//그리드타이틀
			$("#divTitle").html("피의자정보");
			initTrgterGrid();
			$("#divSugest").show();		//기록목록 제외한 div
			$("#divSugestRcord").hide();//기록목록 div
			//btn show
			$("#btnsUpDown").show();
		} else if(gbn == "${suggest_case2}"){
			//문서분류
			$("#formatClCd").val("${format_case2}");
			//그리드타이틀
			$("#divTitle").html("체포내역");
			initArrstGrid();
			$("#divSugest").show();
			$("#divSugestRcord").hide();
			$("#btnsUpDown").hide();
		} else if(gbn == "${suggest_case3}"){
			$("#formatClCd").val("${format_case3}");
			//그리드타이틀
			$("#divTitle").html("압수물내역");
			initCcdrcGrid();
			$("#divSugest").show();
			$("#divSugestRcord").hide();
			$("#btnsUpDown").hide();
		} else if( gbn == "sugestRcord" ){	//기록목록

			$("#divSugest").hide();
			$("#divSugestRcord").show();
			initSugestRcordGrid(); //기록목록 그리드
			AUIGrid.resize("#grid_sugest_list");
			$("#btnsUpDown").hide();
		}

		gridResize();
	}

	function fnTabClick(gbn){
		fnTabDisplay(gbn);
		fnTabGridSet(gbn);
		fnClear(gbn);
	}


	function fnClear(gbn){
		$('#hidSugestNo').val("");
		$('#selSugestClCd').val("");
		$('#txtSugestDe').val("");
		$('#txtSugestCn').val("");

		$('#txtCmndDe').val("");
		$('#txtCmndPrsecNm').val("");
		$('#txtCmndCn').val("");

		$('#tdWritngDeptNm').html("${hidLoginDeptNm}");
		$('#tdWritngNm').html("${hidLoginNm}");

		$('input:radio[name=rdoSugestResultCd]:checked').prop("checked", false);
		$('input:radio[name=rdoSugestOpinionCd]:checked').prop("checked", false);

		fnDoc("", "", "");

		$('#hidPkSn').val("");
		$('#hidCcdrcNo').val("");

		if( $("#rcNo").val() == "" ){
			$('#btnClear').hide();
			$('#btnAdd').hide();
			//$('#btnDelete').hide();
		} else {
			$('#btnClear').hide();
			//$('#btnDelete').hide();

			if( gbn == "sugestRcord" ){
				$('#btnRcord').hide();
				$('#btnAdd').hide();
			} else {
				$('#btnRcord').show();
				$('#btnAdd').show();
			}
		}
	}


	function fnSelect(sNo){
		var iUrl = '<c:url value='/inv/sugestDetailAjax/'/>';
 		var queryString =  "sugestNo=" + sNo;
 		var processAfterGet = function(data) {

 			fnTabDisplay(data.SUGEST_TY_CD);

 			$('#hidSugestNo').val(data.SUGEST_NO);
 			$('#hidPkSn').val(data.PK_SN);
 			$('#hidCcdrcNo').val("");

 			fnTabGridSet(data.SUGEST_TY_CD);

 			$('#selSugestClCd').val(data.SUGEST_CL_CD);
 			$('#txtSugestDe').val(data.SUGEST_DE);
 			$('#txtSugestCn').val(data.SUGEST_CN);

 			$('#txtCmndDe').val(data.CMND_DE);
 			$('#txtCmndPrsecNm').val(data.CMND_PRSEC_NM);
 			$('#txtCmndCn').val(data.CMND_CN);

 			$('#tdWritngDeptNm').html(data.WRITNG_DEPT_NM);
 			$('#tdWritngNm').html(data.WRITNG_NM);
 			$('#tdCmptncExmnNm').html(data.CMPTNC_EXMN_NM);

 			if(fnIsEmpty(data.SUGEST_RESULT_CD)) {
 	 			$('input:radio[name=rdoSugestResultCd]:checked').prop("checked", false);
 			}else{
 	 			$('input:radio[name=rdoSugestResultCd][value=' + data.SUGEST_RESULT_CD + ']').prop("checked", true).change();
 			}
 			if(fnIsEmpty(data.SUGEST_OPINION_CD)) {
 	 			$('input:radio[name=rdoSugestOpinionCd]:checked').prop("checked", false);
 			}else{
 	 			$('input:radio[name=rdoSugestOpinionCd][value=' + data.SUGEST_OPINION_CD + ']').prop("checked", true).change();
 			}

 			fnDoc(data.DOC_ID, "P_SUGEST_NO="+data.SUGEST_NO+"&P_RC_NO="+data.RC_NO, data.FILE_ID);


 			$('#btnClear').show();
 			$('#btnAdd').show();
 			//$('#btnDelete').show();
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnAdd(){
		if(fnIsEmpty($("#rcNo").val())){
			alert("좌측상단에서 사건을 선택하세요.");
			return;
		}


		if( $("#sugestTyCd").val() == "${suggest_case1}" ){
			//지휘가 가결일때 의견서 작성 여부 확인
			if($('input:radio[name=rdoSugestResultCd]:checked').val() == "Y") {
				var docChk = false;
				var processAfterGet = function(data) {
					if(!fnIsEmpty(data.result) && parseInt(data.result) > 0) {
						docChk = true;
					}
				}
				var param = "hidSugestNo="+$("#hidSugestNo").val();
				var ajaxUrl = "<c:url value='/inv/selectDocChkAjax/'/>";
				Ajax.getJson(ajaxUrl, param, processAfterGet);
				if(!docChk) {
					$("input[name=rdoSugestResultCd]").prop("checked", false);
					alert("의견서를 작성하여 주십시오.\n\n신규작성의 경우,\n건의내용 저장 후 (건의결과 작성 제외) 의견서를 작성하여 주십시오.");
					return;
				}
			}
		}else if($("#sugestTyCd").val() == "${suggest_case2}"){
			var chkItems = AUIGrid.getCheckedRowItems(myGridID);
			if(chkItems.length <= 0 ) {
				alert("피의자 체포이력을 선택하세요.");
				return;
			}
			var ids = [];
			for(var i=0; i<chkItems.length; i++) {
				ids.push( chkItems[i].item.TRGTER_SN + ":" + chkItems[i].item.ARRST_SN );
			}
			var str = ids.join("^");
			$('#hidPkSn').val(str);
		}else if($("#sugestTyCd").val() == "${suggest_case3}"){
			var chkItems = AUIGrid.getItemsByValue("#grid_trgter_list", "SUGEST_YN", "Y");
			if(chkItems.length <= 0 ) {
				alert("한개이상의 압수물을 선택해야 합니다.");
				return;
			}
			var ids = [];
			for(var i=0; i<chkItems.length; i++) {
				ids.push( chkItems[i].CCDRC_NO + ":" + chkItems[i].CCDRC_SN);
			}
			var str = ids.join("^");
			$('#hidCcdrcNo').val(str);
		}else{
			return;
		}

		if($('#sugestTyCd').val() == "${suggest_case3}"){
			if($('#selSugestClCd').val() == ""){
				alert("건의분류를 선택하세요.");
				return;
			}
		}

		if(fnFormValueCheck("addForm")){
			var iUrl = '<c:url value='/inv/addSugestAjax/'/>';
	 		var queryString =  $('#addForm').serialize();
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("저장되었습니다.");
					if(data.sugest_no != null && data.sugest_no != ''){
						fnSelect(data.sugest_no);
					}
					fnSugestSearch();
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnDelete(){
		if(confirm("삭제하시겠습니까?")){
			var iUrl = '<c:url value='/inv/deleteSugestAjax/'/>';
	 		var queryString =  $('#addForm').serialize();
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					fnSugestSearch();
					fnClear();
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}


	function fnSugestRcord(){
		var sRcNo = $("#rcNo").val()
		if(sRcNo == ""){
			alert("사건목록을 선택해주세요.");
			return;
		}
		sugestRcordPopup = dhtmlmodal.open('sugestRcord', 'iframe', '/inv/sugestRcordPopup/?rcNo='+ sRcNo, '기록목록', 'width=1000px,height=450px,center=1,resize=0,scrolling=1')
		sugestRcordPopup.onclose = function(){
			return true;
		}
	}
</script>


<script type="text/javascript">

	function initSugestRcordGrid() {
		var columnLayoutR = [{
				headerText : "서류표목", dataField : "RCORD_NM", style : "grid_td_left"
			}, {
				headerText : "진술자", dataField : "RCORD_STATER", width : 150
			}, {
				headerText : "면수", dataField : "RCORD_CO", width : 100
			}, {
				headerText : "작성일자", dataField : "RCORD_DE", width : 120, dataType : "date", formatString : "yyyy-mm-dd",
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
		fnSearchGrid("/trn/trnRcordListAjax/", "form_search", "#gridRcordList");
	}

	//기록목록 조회
	function fnSugestRcordSearch() {
		fnSearchGrid("/trn/trnRcordListAjax/", "form_search", "#gridRcordList");
	}

	function fnDelRowRcord() {
		var rowPos = "selectedIndex";
		AUIGrid.removeRow("#gridRcordList", rowPos);
	}
	function fnAddRowRcord(str) {
		var rowPos = str;
		var item = new Object();
		item.RC_NO = $("#hidRcordRcNo").val();
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
	}

	//기록목록 저장
	function fnSaveRcordList() {

		if( fnIsEmpty($("#hidRcordRcNo").val()) ) return;
		// 삭제 처리된 아이템 있는지 보기
		var removedRows = AUIGrid.getRemovedItems("#gridRcordList", true);
		if(removedRows.length > 0) {
			// softRemoveRowMode 가 true 일 때 삭제를 하면 그리드 상에 마크가 되는데
			// 이를 실제로 그리드에서 삭제 함.
			AUIGrid.removeSoftRows("#gridRcordList");
		}
		var gridItems = AUIGrid.getGridData("#gridRcordList");
		if( gridItems.length > 0 ){
			for( var i in gridItems ){
				var item = gridItems[i];
				if( !fnIsEmpty(item.RCORD_DE) && !fnChkDateVal(item.RCORD_DE) ){
					return;
				}
			}
		}
		var data = fnAjaxAction("/trn/saveTrnRcordAjax/", JSON.stringify({rList:gridItems, RC_NO:$("#hidRcordRcNo").val()}));
		if( data.result == "1" ) {
			alert("기록목록이 저장 되었습니다.");
			fnSearchGrid("/trn/trnRcordListAjax/", "form_search", "#gridRcordList");
			AUIGrid.clearGridData("#gridRcordList");
		} else {
			alert("기록목록 저장중 오류가 발생했습니다.");
		}
	}

	//문서기록 가져오기
	function fnBringRcord() {

		if( fnIsEmpty($("#rcNo").val()) ) return;
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

	//날짜 형식 체크
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
	function fnsup () {
		AUIGrid.moveRowsToUp("#grid_trgter_list");
	}
	function fnsdw () {
		AUIGrid.moveRowsToDown("#grid_trgter_list");
	}
	function fnorsave () {
		var paramLst = [];
		var gridItems = AUIGrid.getGridData("#grid_trgter_list");
		if( gridItems.length > 0 ){
			for( var i in gridItems ){
				var item = gridItems[i];
				paramLst.push({"rcNo":item.RC_NO,"trgterSn":item.TRGTER_SN});
			}
		}
		var rSave = fnAjaxAction('/inv/saveTrgterOrder/', JSON.stringify ({sList:paramLst}));
		if(rSave > 0){
			alert("저장되었습니다.");
			//지휘건의 목록 재조회
			fnCaseSearch ();
			//사건목록 재조회
			fnSugestSearch ();
		}else{
			alert("진행중 오류가 발생하였습니다.");
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
			<div class="box_w2_1b_ov" style="height: 200px; width:100%;">
				<!--테이블 시작 -->
				<div class="com_box">
					<div id="grid_case_list" class="gridResize tb_01_box" style="width: 100%; height: 190px;"></div>
				</div>
			</div>
			<!---------- //왼쪽테이블  ---------------->
		</div>
	</div>
</div>

<div>
	<div class="tabnbtn_box mb_10">
		<ul class="tabs">
			<li class="current" id="btn_${suggest_case1}" onclick="fnTabClick('${suggest_case1}');">수사지휘</li>
			<li id="btn_${suggest_case2}" onclick="fnTabClick('${suggest_case2}');">피의자석방</li>
			<li id="btn_${suggest_case3}" onclick="fnTabClick('${suggest_case3}');">압수물지휘</li>
			<li id="btn_sugestRcord" 	  onclick="fnTabClick('sugestRcord');">기록목록</li>
		</ul>
		<!--버튼 -->
		<div class="right_btn">
			<a href="javascript:void(0);" id="btnRcord"  onClick="fnSugestRcord();" class="btn_st2_2 icon_n fl mr_m1">기록목록</a>
			<a href="javascript:void(0);" id="btnClear"  onClick="fnClear();" 		class="btn_st2 icon_n fl mr_m1">신규</a>
			<a href="javascript:void(0);" id="btnAdd" 	 onClick="fnAdd();" 		class="btn_st2 icon_n fl mr_m1">저장</a>
			<!-- 
				2021.05.07 
				by dgkim
				건의 내용을 삭제하면 지휘건의번호간에 중간 공백이 있도록 설계되어있어 삭제못하도록 조치
				건의내용을 삭제하지않고 수정하여 사용하도록 권종열 사무관과 협의
			 -->
			<!-- <a href="javascript:void(0);" id="btnDelete" onClick="fnDelete();" 		class="btn_st2 icon_n fl mr_m1">삭제</a> -->
		</div>
		<!--//버튼  -->
	</div>

	<div class="contents marginbot" id="divSugest">
		<div class="tabscontent">
			<div class="box_w2 mb_20">
				<div class="box_w2_1b">
					<!--테이블 시작 -->
					<div class="title_s_st2 w_50p fl" style="margin-bottom: 7px;">
						<img src="/img/title_icon1.png" alt="" />지휘건의목록
					</div>
					<div class="com_box">
						<div id="grid_sugest_list" class="gridResize tb_01_box" style="width: 100%; height: 220px;"></div>
					</div>
				</div>
				<div class="box_w2_2b" id="divIframe">
					<!-- 작성문서 목록 -->
					<div class="w_100p">
						<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="268px"></iframe>
					</div>
				</div>
			</div>
			<div class="box_w2 mb_20">
				<div class="box_w2_1b">
					<form id="addForm" name="addForm" method="post">
					<input type="hidden" id="rcNo" 			name="rcNo">
					<input type="hidden" id="hidSugestNo" 	name="hidSugestNo">
					<input type="hidden" id="hidPkSn" 		name="hidPkSn">
					<input type="hidden" id="hidCcdrcNo" 	name="hidCcdrcNo">
					<input type="hidden" id="sugestTyCd" 	name="sugestTyCd" value="${suggest_case1}">
					<input type="hidden" id="formatClCd" 	name="formatClCd" value="${format_case1}">

					<div style="width:calc(50% + 20px); padding-right: 20px;" class="fl">
						<div class="title_s_st2 w_50p fl">
							<img src="/img/title_icon1.png" alt="" />건의내용
						</div>
						<div class="com_box">
							<div class="tb_01_box">
								<table class="tb_01_h100">
									<col width="150px" />
									<col width="" />
									<tbody>
										<tr class="h_40px">
											<th>건의일자<span class="point"><img src="/img/point.png"  alt=""/></span></th>
											<td id="tdSugestDe">
												<div class="calendar_box  w_150px  mr_5">
													<input type="text" class="w_100p input_com calendar" id="txtSugestDe" name="txtSugestDe" value="" readonly check="text" checkName="건의일자">
												</div>
											</td>
										</tr>
										<tr>
											<th id="thSugestCl" style="display:none;">건의분류<span class="point"><img src="/img/point.png"  alt=""/></span></th>
											<td id="tdSugestCl" style="display:none;">
												<select id="selSugestClCd" name="selSugestClCd" class="w_100p input_com">
													<option value="">==선택하세요==</option>
													<c:forEach var="cd" items="${sugestClList}">
														<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr class="h_40px">
											<th>건의자부서</th>
											<td id="tdWritngDeptNm"></td>
										</tr>
										<tr>
											<th>건의자성명</th>
											<td id="tdWritngNm"></td>
										</tr>
										<tr class="h_40px">
											<th>검찰청</th>
											<td id="tdCmptncExmnNm"></td>
										</tr>
										<tr style="height: 65px;">
											<th rowspan="5">
												건의내용
												<span id="txtSugestCnMsg" style="margin-top:5px;"></span>
											</th>
											<td rowspan="5" colspan="3" class="">
												<textarea id="txtSugestCn" name="txtSugestCn"></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div style="width:calc(50% - 20px);" class="fl">
						<div class="title_s_st2 w_50p fl">
							<img src="/img/title_icon1.png" alt="" />건의결과
						</div>
						<!--테이블 시작 -->
						<div class="com_box">
							<div class="tb_01_box">
								<table class="tb_01_h100">
									<col width="120px;" />
									<col width="" style="min-width:180px"/>
									<tbody>
										<tr class="h_40px">
											<th>지휘일자</th>
											<td>
												<div class="calendar_box  w_150px  mr_5">
													<input type="text" class="w_100p input_com calendar" id="txtCmndDe" name="txtCmndDe" value="" readonly>
												</div>
											</td>
										</tr>
										<tr>
											<th>지휘</th>
											<td>
												<div class='input_radio2 t_left'>
													<input class="to-labelauty-icon" type="radio" name="rdoSugestResultCd" value="Y"/> 가
												</div>
												<div class='input_radio2 t_left'>
													<input class="to-labelauty-icon" type="radio" name="rdoSugestResultCd" value="N"/> 부
												</div>
												<div class='input_radio2 t_left'>
													<input class="to-labelauty-icon" type="radio" name="rdoSugestResultCd" value="C"/> 비고
												</div>
											</td>
										</tr>
										<tr>
											<th>검사명</th>
											<td>
												<input type="text" class="w_100p input_com " id="txtCmndPrsecNm" name="txtCmndPrsecNm" value="">
											</td>
										</tr>
										<tr>
											<th>건의자의견</th>
											<td>
												<div class='input_radio2 t_left'>
													<input class="to-labelauty-icon" type="radio" name="rdoSugestOpinionCd" value="Y"/> 기소
												</div>
												<div class='input_radio2 t_left'>
													<input class="to-labelauty-icon" type="radio" name="rdoSugestOpinionCd" value="N"/> 불기소
												</div>
												<div class='input_radio2 t_left'>
													<input class="to-labelauty-icon" type="radio" name="rdoSugestOpinionCd" value=""/> 의견없음
												</div>
											</td>
										</tr>
										<tr class="trCmndMsg" style="height: 70px;">
											<th rowspan="5">
												지휘내용
												<span id="txtCmndCnMsg" style="margin-top:5px;"></span>
											</th>
											<td rowspan="5" colspan="3" class="">
												<textarea id="txtCmndCn" name="txtCmndCn"></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					</form>
				</div>
				<div class="box_w2_2b">
					<div class="title_s_st2 w_50p fl" >
						<img src="/img/title_icon1.png" alt="" /><p id="divTitle">피의자정보</p>
					</div>
					<!--버튼 -->
					<div class="right_btn fr" id="btnsUpDown">
						<a href="javascript:void(0);" id="btnsup"    onClick="fnsup();" 	class="btn_st2 icon_n fl mr_m1">▲</a>
						<a href="javascript:void(0);" id="btnsdw"    onClick="fnsdw();" 	class="btn_st2 icon_n fl mr_m1">▼</a>
						<a href="javascript:void(0);" id="btnorsave" onClick="fnorsave();" 	class="btn_st2 icon_n fl mr_m1">순서저장</a>
					</div>
					<!--//버튼  -->
					<div class="com_box">
						<div id="grid_trgter_list" class="gridResize tb_01_box" style="width: 100%; height: 231px;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 기록목록 그리드 -->
	<div class="contents marginbot" id="divSugestRcord">
		<form id="form_search" name="form_search" method="post">
		<input type="hidden" id="schRcNo" name="schRcNo" value="${hidRcordRcNo}">
		</form>

		<div class="popup_body" style="padding-top: 0px; padding-bottom: 0px; padding-left: 0px; padding-right: 0px;">
			<form id="form_rcord" name="form_rcord" method="post">
				<input type="hidden" name="hidRcordRcNo" id="hidRcordRcNo" value="${hidRcordRcNo}">
				<div class="box_w2 mb_20">
					<div class="title_s_st2 w_50p fl mb_8">
						<img src="/img/title_icon1.png" alt="" />기록목록 정보
					</div>
					<div class="right_btn fr" style="margin-bottom: 8px;">
						<input type="button" id="btnBringRcord" value="가져오기" class="btn_st2 icon_n fl" onclick="fnBringRcord();">
						<a href="javascript:fnSaveRcordList()" class="btn_st2 icon_n fr mr_m1">저장</a>
						<a href="javascript:fnDelRowRcord()" class="btn_st2 icon_n fr mr_m1">삭제</a>
						<a href="javascript:fnAddRowRcord('selectionDown')" class="btn_st2 icon_n fr mr_m1">추가</a>
						<a href="javascript:fnAddRowRcord('first')" class="btn_st2 icon_n fr mr_m1">첫번째 행추가</a>
					</div>
					<!--테이블 시작 -->
					<div class="com_box ">
						<div class="tb_01_box">
							<div id="gridRcordList" class="gridResize" style="width:100%; height:600px; margin:0 auto;"></div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>

</div>