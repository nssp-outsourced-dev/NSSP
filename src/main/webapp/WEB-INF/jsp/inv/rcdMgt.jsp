<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<style type="text/css">
.ntBrdCss .ntSelCss {
	border: 0px solid #fff;
	background-color: #fff !important;
}
.tbLft {
	text-align: left;
}
.my-cell-style {
	/* background:#FFEBFE; */
	color:#0000ff;
	font-weight:bold;
}
#bodyMenu {
	position:absolute;
	display:none;
	z-index:100;
}
.aui-grid-row-depth-mystyle {
	font-weight: bold;
	color: #5D5D5D;
	background: #eff0f4;
}
	/*
		2021.08.11
		coded by dgkim
		수사시스템 화면 비율 조정
		권종열 사무관 요청
	*/
	#gridT1_wrap { height: 140px !important; }/* 사건목록 */
	#gridT2_wrap { height: 492px !important; }/* 작성문서목록 */
	.tb_01_h100 tr:last-child { height: 20px !important;}/* 범죄사실 */
</style>
<script type="text/javascript">
	var docNo = "00445";	/*입건조서*/
	var nowBodyMenuVisible = false;
	$(function() {
		fnDatePickerImg("txtVidoTrplantDe",null,false);
		fnSendKey ('${hidRcNo}', '${hidTrgterSn}');
		fnTopLst ();
		initGrid ();
		$("#searchFormatClCd").val(docNo);

		$(document).on("click", function(event) {
			if($(event.target).attr("aria-haspopup")) { // 서브 메뉴 아이템 클릭 한 경우
				return;
			}
			hideContextMenu();
		});

	});
	function fnTopLst () {
		$("#show").click(function(){
	        $("#showinbox").show();
			 $("#show").hide();
			 $("#hide").show();
			 AUIGrid.resize("#gridT1_wrap");
	    });
	    $("#hide").click(function(){
	        $("#showinbox").hide();
			 $("#show").show();
			 $("#hide").hide();
	    });
	}
	function fnSetRow (gId, gCol, gVal, gPos) {
		var rows = AUIGrid.getRowIndexesByValue(gId,gCol,gVal);
		if(gCol == "grdTrgterKey" && fnIsEmpty(rows[0])) {
			AUIGrid.setSelectionByIndex(gId, 0, gPos);
		} else {
			AUIGrid.setSelectionByIndex(gId, rows[0], gPos);
		}
	}
	function fnSendKey (pRcNo, pTrSn) {
		if(!fnIsEmpty(pRcNo) || !fnIsEmpty(pTrSn)) {
			$("#searchRcNo").val(pRcNo);
			$("#searchTrgterSn").val(pTrSn);
		}
	}
	function initGrid () {
		var cdArr = ["00102"];
		var cdLst = fnAjaxAction2({txtUpCd:cdArr});
		var trgterSeList   = getCodeList (cdLst, cdArr[0]);
		var columnLayoutT1 = [
						{ dataField : "grdDsCaseNo",    headerText : "사건/내사번호", 	width : 130,
							filter : {
								showIcon : true,
								iconWidth:20
							},
							renderer : {type : "TemplateRenderer"},
	 						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
	 							return fnChangeNo (value);
	 						}
						},
						{ dataField : "grdRcNo",      	headerText : "접수번호", 	width : 120,
							filter : {
								showIcon : true,
								iconWidth:20
							},
							renderer : {type : "TemplateRenderer"},
	 						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
	 							return fnChangeNo (value);
	 						}
						},
						{ dataField : "grdPrsctDe",   	headerText : "입건일자", 	width : 130, dataType : "date", formatString : "yyyy-mm-dd",
							filter : {
								showIcon : true,
								iconWidth:20
							},
						},
						{ dataField : "grdInvProvisNm",	headerText : "수사단서",	width : 100 },
						{ dataField : "grdRcSeNm",		headerText : "사건구분",	width : 100 },
						{ dataField : "grdTrgterNmS",	headerText : "피의자 등",  width : 120 },
		   				{ dataField : "grdVioltNm",		headerText : "위반죄명",  style:'tbLft' },
		   				{ dataField : "grdTrgterNmV",	headerText : "고발인 등",  width : 120 },
		                ];
		var columnLayoutT2 = [
						{ dataField : "grdRcNo", headerText : "RC_NO", width : 0, visible : false},
						{ dataField : "grdFormatNm", headerText : "서식명"},
						{ dataField : "grdDocSort", headerText : "순번", width : 60},
						{ dataField : "grdTrgterSn", headerText : "TRGTER_SN", width : 0, visible : false},
						{ dataField : "grdFormatId", headerText : "FORMAT_ID", width : 0, visible : false},
						{ dataField : "grdDocYn", headerText : "DOC_YN", width : 0, visible : false},
						{
							dataField : "grdInputYn",
							headerText : "입력폼",
							visible : false,
							width : 60,
							renderer : {type : "TemplateRenderer"},
							labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								var template = "";
								if(value == "Y"){
									template += "O";
								}else if(value == "N"){
									template += "X";
								}else{
									template += "";
								}
								return template;
							}
						},
						{
							dataField : "grdJsonYn",
							headerText : "작성여부",
							width : 100,
							renderer : {type : "TemplateRenderer"},
							visible : false,
							labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								var template = "";
								if( item.grdChkType == "FILE" ){
									template = "첨부파일";
								} else {
									if( value == "Y" ){
										template += "작성완료";
									} else if( value == "N" ){
										template += "미작성";
									} else {
										template += "";
									}
								}
								return template;
							}
						},
						{
							dataField : "grdFileNm",
							headerText : "작성여부",
							width : 100,
							visible : true,
							renderer : {type : "TemplateRenderer"},
							labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								var template = "";

								if( item._$depth > 1 ){
									if( item.grdChkType == "FILE" ){
										template = "첨부파일";
									} else {
										if( value != null && value != "" ){
											template += "작성완료";
										} else {
											template += "미작성";
										}
									}
								}
								return template;
							}
						},
						{ dataField : "grdDocId", headerText : "서식ID", width : 0, visible : false},
						{ dataField : "grdFileId", headerText : "파일ID", 	visible:false },
						{ dataField : "grdPblicteSn", headerText : "PBLICTE_SN", width : 0, visible : false},
						{ dataField : "grdDocNo", headerText : "문서번호", width : 0, visible : false},
						{ dataField : "grdWritngNm", headerText : "작성자", width : 0, visible : false},
						{ dataField : "grdUpdtDt", headerText : "작성일", width : 100},
						{ dataField : "grdChkType", headerText : "저장구분", width : 100, style:'tbLft',
							renderer : {type : "TemplateRenderer"},
							labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								var template = (fnIsEmpty(value)?"":value) + (fnIsEmpty(item.grdDocClCd)?"":" ["+item.grdDocClCd+"]");
								return template;
							}
						}
					];

		var gridPros = {
			rowNumHeaderText:"순번",
			selectionMode : "singleRow",	// 선택모드 (기본값은 singleCell 임)
	    	triggerSelectionChangeOnCell:true,
			headerHeight : 30,
			rowHeight: 30,
			enableFilter : true
		};
		var gridPros2 = {
			headerHeight : 33,
			rowHeight: 30,
			selectionMode : "singleRow",
			fillColumnSizeMode : true,
			showRowNumColumn : false,
			treeColumnIndex : 1,
			displayTreeOpen : true,
			useContextMenu : true,
			rowStyleFunction : function(rowIndex, item) {
				if(item._$isBranch) {
				/*  브랜치 행에 대해 depth 별로
				 	depth 가 많아진 경우는 그에 맞게 스타일을 정의하십시오.
				  	현재 3개의 스타일이 기본으로 정의됨.(AUIGrid_style.css) */

					switch(item._$depth) {  // 계층형의 depth 비교 연산
					case 1:
						return "aui-grid-row-depth-mystyle";
					}
				}
				return "";
			}

		};
		AUIGrid.create("#gridT1_wrap",columnLayoutT1,gridPros);
		AUIGrid.create("#gridT2_wrap",columnLayoutT2,gridPros2);
		AUIGrid.bind("#gridT2_wrap", "contextMenu", auiGridContextEventHandler);
		AUIGrid.bind("#gridT2_wrap", "cellClick", function(event) {
			console.log("gridT2_wrap cell click");
			var items = event.item;
			//depth 1까지는 열고 닫는 이벤트 처리
			if(items._$depth == 1) {
				var selectedItems = AUIGrid.getSelectedItems(event.pid);
				if(selectedItems.length <= 0) return null;
				var rowId = selectedItems[0].rowIdValue;
				var isOpen = AUIGrid.isItemOpenByRowId(event.pid, rowId);
				AUIGrid.expandItemByRowId(event.pid, rowId, !isOpen);
			}
			if(!fnIsEmpty(items.grdRcNo) && !fnIsEmpty(items.grdTrgterSn)) {
				$("#searchRcNo").val(items.grdRcNo);
				$("#searchTrgterSn").val(items.grdTrgterSn);
				fnDetail (items);
			}
		});

		AUIGrid.bind("#gridT2_wrap", "cellDoubleClick", function(event) {
			var items = event.item;
			//문서열기
			if(items.grdDocSort > 0 && items._$depth > 1) {
				var sTsn  = $("#hidTrgterSn").val();
				var sRcNo = $("#hidRcNo").val();
				if(!fnIsEmpty(sRcNo)) {
					if(fnIsEmpty(items.grdChkType)||items.grdChkType!="FM") {
						if(fnIsEmpty(sTsn)) {
							alert("대상자가 확인되지 않습니다.");
							return;
						}
					}
					$('#searchRcNo').val(sRcNo);
					$('#searchTrgterSn').val(sTsn);
					if(items.grdChkType == "FILE") {
						fnDocFileDownload(items.grdFileId, items.grdPblicteSn);
					} else {
						if(items.grdDocYn == "Y"){
							//fnReportViewIfr("gridT2_wrap",items.grdDocId, items.grdPblicteSn);
							fnHwpctrl( items.grdDocId, items.grdPblicteSn, items.grdFormatNm, "fnT2Search()" );
						} else {
							if(fnIsEmpty(items.grdDocId)) {
								alert("대상자의 문서ID가 확인되지 않습니다.");
							} else {
								fnReportMake(items.grdFormatId, items.grdInputYn, items.grdDocId, "fnT2Search ()");
							}
						}
					}
				} else {
					alert("사건번호가 확인되지 않습니다.");
				}
			}
		});

		AUIGrid.bind("#gridT1_wrap", "ready", function(event) {
			var hidRcNo  = $("#searchRcNo").val();
			if( !fnIsEmpty(hidRcNo )){
				fnSetRow (event.pid, "grdRcNo", hidRcNo, 0);
				fnT2Search();
			}
		});

		AUIGrid.bind("#gridT2_wrap", "ready", function(event) {
			var strSetRow = $("#searchSetRow").val();
			if(fnIsEmpty(strSetRow) || strSetRow != "N") {
				var hidTrgterSn = $("#searchTrgterSn").val();
				var hidRcNo  = $("#searchRcNo").val();
				fnSetRow (event.pid, "grdTrgterKey", hidRcNo+hidTrgterSn, 1);
				var selectedItems = AUIGrid.getSelectedItems(event.pid);
				if(selectedItems.length == 1) {
					fnDetail (selectedItems[0].item);
				}
			} else {
				fnReset ();
			}
			$(".searchCld").val ("");
		});
		AUIGrid.bind("#gridT1_wrap", "cellClick", function(event) {
			console.log("gridT1_wrap cell click");
			var items = event.item.grdRcNo;
			if( !fnIsEmpty(items) ){
				$("#searchRcNo").val(items);
				fnT2Search();
			} else {
				alert("사건번호가 확인되지 않습니다.");
			}
			$("#hide").click();
		});
		//기본 조회
		fnT1Search();
	}

	//조서관리-사건목록 그리드 조회
	function fnT1Search(){
		fnSearchGrid("/inv/rmCaseListAjax/", "searchForm", "#gridT1_wrap");
	}

	//조서관리-대상자 작성문서 목록 조회
	function fnT2Search(){
		fnSearchGrid("/inv/rcdMgtTrgterListAjax/", "searchForm", "#gridT2_wrap");
	}

	function fnReset (){
		$("#dtltgForm").find('input, select, textarea').each (
		    function(index){
		        $(this).val("");
		    }
		);
		$("#dtltgForm").find('label').each(
		    function(index){
		    	$(this).text("");
		    }
		);
	}
	function fnDetail(items) {
		var processAfterGet2 = function(data) {
			fn_form_bind ("dtltgForm",data);
			$("#hidPblicteSn").val(items.grdPblicteSn); /*영상녹화 정보 저장을 위함*/
			$("#hidFormatId").val(items.grdFormatId);

			if(items.grdRcSeCd == "F") {
				$("#btnRstPop").hide();
			} else {
				$("#btnRstPop").show();
				if (items.grdRcSeCd == "T") $("#btnRstPop").text ("임시사건결과보고");
				else $("#btnRstPop").text ("내사사건결과보고");
			}
			//영상녹화
			if(!fnIsEmpty(items.grdFormatId) && parseInt(items.grdFormatId) == 21) {
				$("#txtVidoTrplantCharger").prop("readonly", false);
				$("#txtVidoTrplantDe").prop("disabled", false);
			} else {
				$("#txtVidoTrplantCharger").prop("readonly", true);
				$("#txtVidoTrplantDe").prop("disabled", true);
			}
		}
		Ajax.getJson("<c:url value='/inv/rmTrgterListAjax/'/>", "grdRcNo="+items.grdRcNo+"&grdTrgterSn="+items.grdTrgterSn+"&grdPblicteSn="+items.grdPblicteSn, processAfterGet2);
	}
	function fnReportMake (formatId, inputYn, docId, target ){
		if(!fnIsEmpty(docId) && docId.length != 20){
			alert("문서정보가 확인되지 않습니다.");
			return;
		}
		//선택된 row
		var selectedItems = AUIGrid.getSelectedItems("#gridT2_wrap");
		if(selectedItems.length < 1) {
			alert("선택된 내용이 확인되지 않습니다.");
			return;
		}
		var strSn  = selectedItems[0].item.grdRcNo;
		var strRno = selectedItems[0].item.grdTrgterSn;

		if(fnIsEmpty(strSn) || fnIsEmpty(strRno)) {
			alert("대상자를 선택한 후 문서작성을 진행하여 주십시오.")
			return;
		}
		var strInParam = "P_RC_NO="+strSn+"&P_TRGTER_SN="+strRno;
		if(parseInt(formatId) == 33) {
			var sels = AUIGrid.getRowIndexesByValue("#gridT2_wrap", "grdTrgterKey", strSn+strRno+"00000000000000000033");
			strInParam += ("&P_CNT="+(parseInt(sels.length)+2));
		}
		$('#searchDocId').val(docId);
		$('#searchFormatId').val(formatId);
		$("#searchInputParam").val(strInParam);
		var iUrl = '<c:url value='/doc/reportAddAjax/'/>';
 		var queryString =  $('#searchForm').serialize();
 		var processAfterGet = function(data) {
			if(data.result == "1"){
				//fnSearch();
				if(inputYn == "Y") {
					//fnReportInputIfr("gridT2_wrap",data.doc_id, data.pblicte_sn);
					fnHwpctrl (data.doc_id, data.pblicte_sn, data.format_nm, target);
				}else{
					//fnReportViewIfr("gridT2_wrap",data.doc_id, data.pblicte_sn);
					fnHwpctrl (data.doc_id, data.pblicte_sn, data.format_nm, target);
				}
			}else{
				alert("진행중 오류가 발생하였습니다.");
			}
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}
	function fnReportAdd() {
		var formatId = $("#selReportAdd").val();
		if(formatId.length != 22) {
			alert("문서서식을 선택하세요.");
			return;
		}
		var temp = formatId.split("^");
		if(temp.length==2) {
			//기타일경우 파일관리 팝업 띄움
			if(parseInt(temp[0])===298) fnFilePop ();
			else {			
				//현재 선택된 row
				var selectedItems = AUIGrid.getSelectedItems("#gridT2_wrap");
				if(selectedItems.length < 1) {
					alert("선택된 내용이 확인되지 않습니다.");
					return;
				}
				$("#searchRcNo").val($("#hidRcNo").val());
				fnReportMake(temp[0], temp[1], selectedItems[0].item.grdDocId, "fnT2Search()");
			}
		}		
	}
	// 바디 컨텍스트 메뉴 아이템 선택 핸들러
	function bodyMenuSelectHandler(event, ui) {
		var selectedId = ui.item.prop("id");
		var selectedItems = AUIGrid.getSelectedItems("#gridT2_wrap");
		if(selectedItems.length < 1) {
			alert("선택된 내용이 확인되지 않습니다.");
			return;
		}
		var items = selectedItems[0].item;
		switch(selectedId) {
		case "cm2":
			if(items.grdDocYn == "Y"){
				if(items.grdChkType == "FILE") {
					fnDocFileDownload(items.grdFileId, items.grdPblicteSn);
				} else {
					fnReportViewIfr("gridT2_wrap",items.grdDocId, items.grdPblicteSn);
				}
			}else{
				alert("문서가 생성되지 않았습니다.");
			}
			break;
		case "cm1":
			if(items.grdDocYn == "Y"){
				if(items.grdInputYn == "Y"){
					fnReportInputIfr("gridT2_wrap",items.grdDocId, items.grdPblicteSn);
				}else{
					alert("해당 서식은 입력폼을 지원하지 않습니다.");
				}
			}else{
				alert("문서가 생성되지 않았습니다.");
			}
			break;
		case "cm3":
			if(items.grdDocYn == "Y"){
				if(items.grdChkType == "FILE") {
					if(confirm(items.grdFormatNm+"("+items.grdDocClCd+")\n첨부파일을 삭제하시겠습니까?")) {
						fnDocFileDelete(items.grdFileId, items.grdPblicteSn);
					}
				} else {
					if(confirm(items.grdFormatNm+" ("+items.grdDocNo+")를 삭제하시겠습니까?")){
						var iUrl = '<c:url value='/doc/reportDelAjax/'/>';
						var queryString =  "docId=" + items.grdDocId + "&pblicteSn=" + items.grdPblicteSn;
						var processAfterGet = function(data) {
							if(data.result == "1"){
								fnSearch();
							}else{
								alert("삭제 진행중 오류가 발생하였습니다.");
							}
						};
						Ajax.getJson(iUrl, queryString, processAfterGet);
					}
				}
			}else{
				alert("문서가 생성되지 않았습니다.");
			}
			break;
		}
	}
	function auiGridContextEventHandler(event) {
		if(event.target == "body") { // 바디 컨텍스트
			currentRowIndex = event.rowIndex;

			// 사용자가 만든 컨텍스트 메뉴 보이게 하기
			if(event.item.grdDocSort > 0) {
				nowBodyMenuVisible = true;
				// 바디 컨텍스트에서 사용할 메뉴 위젯 구성
				$("#bodyMenu").menu({
					select: bodyMenuSelectHandler
				});
				$("#bodyMenu").css({
					left : event.pageX,
					top : parseInt(event.pageY)-100
				}).show();
			}else{
				hideContextMenu();
			}
			return false; // 기본으로 제공되는 컨텍스트 사용 안함.
		}
	}
	// 컨텍스트 메뉴 감추기
	function hideContextMenu() {
		if(nowBodyMenuVisible) { // 메뉴 감추기
			$("#bodyMenu").menu("destroy");
			$("#bodyMenu").hide();
			nowBodyMenuVisible = false;
		}
	}
	function btnDtl () {
		var strRcNo = $("#hidRcNo").val();
		if(fnIsEmpty (strRcNo)) {
			alert("상세 조회 정보가 없습니다.\n\n사건번호를 검색해 주세요.");
		} else {
			fnCaseDetailPopup ($("#hidRcNo").val(), "");
		}
	}
	function fnSearch () {
		$("#searchTrgterSn").val($("#hidTrgterSn").val());
		$("#searchRcNo").val($("#hidRcNo").val());
		$("#searchSetRow").val("N");
		fnT2Search();
	}
	function fnTree (pType) {
		if(pType == 1) {
			AUIGrid.expandAll("#gridT2_wrap");
		} else {
			AUIGrid.collapseAll("#gridT2_wrap");
		}
	}
	function fnFilePop () {
		var selectedItems = AUIGrid.getSelectedItems("#gridT2_wrap");
		if(selectedItems.length < 1) {
			alert("선택된 내용이 확인되지 않습니다.");
			return;
		}
		var selFId = selectedItems[0].item.grdFileId;
		if(fnIsEmpty(selFId)) {
			alert("파일을 첨부할 대상자를 선택하여 주십시오.");
			return;
		}		
		var formatId = $("#selReportAdd").val();	
		var docFpopup = btnDocFilePop(docNo,selFId,formatId);
		docFpopup.controls.onclick=function(){
			$("#searchRcNo").val($("#dtltgForm").find("#hidRcNo").val());
			fnT2Search();
			dhtmlmodal.close(this._parent, true);
		}
	}
	/*첨부파일 다운로드*/
	function fnDocFileDownload(sFileID, sFileSn){
		location.href = "<c:url value='/file/getFileBinary/'/>?file_id=" + sFileID + "&file_sn=" + sFileSn;
	}
	/*첨부파일 삭제*/
	function fnDocFileDelete(sFileID, sFileSn){
		var iUrl = '<c:url value='/file/deleteAjax/'/>';
			var queryString =  "file_id=" + sFileID + "&file_sn=" + sFileSn;
			var processAfterGet = function(data) {
			if(data.result == "1"){
				alert("삭제되었습니다.");
				$("#searchRcNo").val($("#dtltgForm").find("#hidRcNo").val());
				fnT2Search();
			}else{
				alert("삭제 진행중 오류가 발생하였습니다.");
			}
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}
	//영상녹화시필요적 고려사항
	function btnInfoPop () {
		recInfoPopup = dhtmlmodal.open('changePw', 'iframe', '/inv/recInfoPopup/', '영상녹화시 필요적 고지사항', 'width=750px,height=460px,center=1,resize=0,scrolling=0')
		recInfoPopup.onclose = function() {
			return true;
		}
	}
	function fnRecSave () {
		var strFormatId = $("#hidFormatId").val();
		if(fnIsEmpty(strFormatId) || parseInt(strFormatId) != 21) {
			alert("좌측 목록에서 해당되는 영상녹화 문서를 선택 후 영상녹화 정보를 저장하여 주십시오.");
			return;
		}
		var strDocNo = $("#hidDocId").val();
		var strPblicteSn = $("#hidPblicteSn").val();
		if(fnIsEmpty(strDocNo) || fnIsEmpty(strPblicteSn)) {
			alert("좌측 목록에서 해당되는 영상녹화 문서를 선택 후 영상녹화 정보를 저장하여 주십시오.");
			return;
		}
		if(fnFormValueCheck("dtltgForm")){
			var processAfterGet = function(data) {
				if(!fnIsEmpty(data.rst) && parseInt(data.rst) > 0) {
					alert("영상녹화 정보가 되었습니다.");
				}
			}
			var param = $('#dtltgForm').serialize();
			Ajax.getJson("<c:url value='/inv/saveVdoRecAjax/'/>", param, processAfterGet);
		}
	}
	function fnRstPop () {
		var strRcSeCd = $("#hidRcSeCd").val();
		var progrsSttusCd = $("#hidProgrsSttusCd").val();
		if(strRcSeCd == "I") {
			var itivNo = $("#hidItivNo").val();
			if(fnIsEmpty(itivNo)) {
				alert("내사사건번호가 확인되지 않습니다. 좌측 정보를 다시 클릭하여 주십시오.");
				return;
			}
			var itivResultReprtPopup = dhtmlmodal.open('itivResultReprtPopup', 'iframe', '/rc/itivResultReprtPopup/?rcNo='+$("#hidRcNo").val()+'&itivNo='+itivNo+'&progrsSttusCd='+progrsSttusCd , '내사결과보고', 'width=882px,height=550px,center=1,resize=0,scrolling=1');
		} else if (strRcSeCd == "T") {
			var tmprNo = $("#hidTmprNo").val();
			if(fnIsEmpty(tmprNo)) {
				alert("임시사건번호가 확인되지 않습니다. 좌측 정보를 다시 클릭하여 주십시오.");
				return;
			}
			var tmprResultReprtPopup = dhtmlmodal.open('tmprResultReprtPopup', 'iframe', '/rc/tmprResultReprtPopup/?rcNo='+$("#hidRcNo").val()+'&tmprNo='+tmprNo+'&progrsSttusCd='+progrsSttusCd , '임시결과보고', 'width=882px,height=550px,center=1,resize=0,scrolling=1');
		}
	}
</script>
<!-- 상단 조회 -->
<div id="bodyMenu" class="aui-grid-context-popup-layer">
	<span class="aui-grid-context-item" id="cm1">문서입력</span>
	<span class="aui-grid-context-item" id="cm2">문서출력</span>
	<span class="aui-grid-context-item" id="cm3">문서삭제</span>
</div>
<div class="sh_box">
	<button id="hide" class="showbtn"></button>
	<button id="show" class="hidebtn" style="display: none"></button>

	<div class="show_in" id="showinbox">
		<!--테이블 시작 -->
		<div class="com_box">
			<div id="gridT1_wrap" class="gridResize tb_01_box" style="width: 100%; height: 450px;"></div>
		</div>
	</div>
</div>
<!-- //상단 조회 -->
<div class="search_box mb_20" style="display: none;">
	<form id="searchForm">
		<input type="hidden" id="searchTrgterSn" 	name="searchTrgterSn" 	class="searchCld"/> <!-- 내사건관리에서 넘어오는 값 -->
		<input type="hidden" id="searchCaseNo"   	name="searchCaseNo"		class="searchCld"/>
		<input type="hidden" id="searchRcNo"   	  	name="searchRcNo"		class="searchCld"/>
		<input type="hidden" id="searchFormatClCd" 	name="searchFormatClCd" />
		<input type="hidden" id="searchFormatId" 	name="formatId"	/>
		<input type="hidden" id="searchDocId" 		name="docId"	/>
		<input type="hidden" id="searchInputParam"  name="inputParam" />
		<input type="hidden" id="searchSetRow"  	name="searchSetRow" 	class="searchCld"/>
	</form>
</div>

<div class="box_w2 mb_20">
	<div class="box_w2_1b">
		<div class="com_box" style="margin-bottom: 7px;">
			<div class="title_s_st2 fl" style="width: 270px">
				<img src="/img/title_icon1.png" alt="" />대상자 및 작성문서목록
				<a href="javascript:fnTree(2)" class="fr" style="width: 25px; font-size: 20px;">－</a>
				<a href="javascript:fnTree(1)" class="fr" style="width: 25px; font-size: 20px;">＋</a>
			</div>
			<div class="fr" style="width: calc(100% - 300px)">
				<div class="right_btn fr" style="width : 100%">
					<a href="javascript:fnFilePop()" class="btn_st2 icon_n fr mr_m1">파일관리</a>
					<a href="javascript:fnReportAdd()" class="btn_st2 icon_n fr mr_m1">추가</a>
					<select name="selReportAdd" id="selReportAdd" class="w_200px h_32px" style="float: right;">
						<option value="">== 문서를 선택하세요 ==</option>
						<c:forEach var="result" items="${formatClList}">
							<option value="${result.FORMAT_ID}^${result.INPUT_YN}">${result.FORMAT_NM}</option>
						</c:forEach>
					</select>
				</div>
			</div>
		</div>
		<div class="com_box mb_10">
			<div id="gridT2_wrap" class="gridResize tb_01_box" style="width: 100%; height: 643px;"></div>
		</div>
	</div>
	<div class="box_w2_2b">
		<div class="com_box" style="margin-bottom: 7px;">
			<div class="title_s_st2 fl" style="width: 100px;">
				<img src="/img/title_icon1.png" alt="" />대상자정보
			</div>
			<div class="right_btn fr">
				<a href="javascript:fnRstPop();" class="btn_st2 icon_n fl mr_m1" style="display: none;" id = "btnRstPop">내사결과보고</a>
				<a href="javascript:btnInfoPop();" class="btn_st2_2 icon_n fl">영상녹화시필요적고지사항</a>
				<a href="javascript:btnDtl();" class="btn_st2_2 icon_n fl mr_m1">사건상세보기</a>
			</div>
		</div>
		<!--테이블 시작 -->
		<form id="dtltgForm">
		<input type="hidden" id="hidRcSeCd" name="hidRcSeCd"/>	<!-- 사건구분 -->
		<input type="hidden" id="hidRcNo" name="hidRcNo"/>
		<input type="hidden" id="hidTrgterSn" name="hidTrgterSn"/>
		<input type="hidden" id="hidDocId" name="hidDocId"/>
		<input type="hidden" id="hidFileId" name="hidFileId"/>
		<input type="hidden" id="hidPblicteSn" name="hidPblicteSn"/>
		<input type="hidden" id="hidFormatId" name="hidFormatId"/>
		<input type="hidden" id="hidProgrsSttusCd" name="hidProgrsSttusCd"/>
		<input type="hidden" id="hidItivNo" name="hidItivNo"/>
		<input type="hidden" id="hidTmprNo" name="hidTmprNo"/>
		<div class="com_box mb_20">
			<div class="tb_01_box">
				<table class="tb_01_h100">
					<caption>대상자상세보기</caption>
					<colgroup>
						<col width="100px" />
						<col width="100px" />
						<col width="" />
						<col width="100px" />
						<col width="" />
					</colgroup>
					<tbody>
						<tr>
							<th> <a id="btnVdoRec" onclick="fnRecSave()" class="btn_st1 icon_n fl" style="width : 95px; padding: 0 0 0 0; text-align: center;" >영상녹화저장</a>
							</th>
							<th style="height: 30px;">영상녹화물<br/>관리자</th>
							<td>
								<input type="text" name="txtVidoTrplantCharger" id="txtVidoTrplantCharger" readonly="readonly" class="w_120px input_com" maxlength="20" check="text" checkName="녹화담당자"/>
							</td>
							<th>영상<br/>녹화일</th>
							<td>
								<div class="calendar_box mr_5 fl" style="width: 130px">
									<input type="text" class="w_100p input_com calendar" id="txtVidoTrplantDe" disabled="disabled"  name="txtVidoTrplantDe" readonly="readonly" check="text" checkName="녹화일"/>
								</div>
							</td>
						</tr>
						<tr>
							<th rowspan="2">개인정보</th>
							<th style="height: 30px;">성명</th>
							<td>
								<label id="labTrgterNm"></label>
							</td>
							<th>주민번호</th>
							<td>
								<label id="labTrgterRrn"></label>
							</td>
						</tr>
						<tr>
							<th style="height: 30px;">자택전화</th>
							<td>
								<label id="labOwnhomTel"></label>
							</td>
							<th>휴대전화</th>
							<td>
								<label id="labHpNo"></label>
							</td>
						</tr>
						<tr>
							<th rowspan="3">주소정보</th>
							<th style="height: 30px;">주소지</th>
							<td colspan="3">
								( <label id="labAdresZip"></label> )&nbsp;&nbsp;
								<label id="labAdresAddr"></label>
							</td>
						</tr>
						<tr>
							<th style="height: 30px;">등록지</th>
							<td colspan="3">
								( <label id="labRegbsZip"></label> )&nbsp;&nbsp;
								<label id="labRegbsAddr"></label>
							</td>
						</tr>
						<tr>
							<th style="height: 30px;">주거지</th>
							<td colspan="3">
								( <label id="labDwlsitZip"></label> )&nbsp;&nbsp;
								<label id="labDwlsitAddr"></label>
							</td>
						</tr>
						<tr>
							<th rowspan="2">직장정보</th>
							<th style="height: 30px;">직장명</th>
							<td colspan="3">
								<label id="labWrcNm"></label>
							</td>
						</tr>
						<tr>
							<th style="height: 30px;">전화번호</th>
							<td colspan="3">
								<label id="labWrcTel"></label>
							</td>
						</tr>
						<tr>
							<th rowspan="4">사건정보</th>
							<th style="height: 30px;">접수번호</th>
							<td colspan="3">
								<label id="labRcNo"></label>
							</td>
						</tr>
						<tr>
							<th style="height: 30px;">적용법조</th>
							<td colspan="3" style="line-height:30px;">
								<label id="labVioltNm"></label>
							</td>
						</tr>
						<tr style="height: 222px">
							<th>범죄사실</th>
							<td colspan="3">
								<textarea disabled="disabled" id="txtCrmnlFact" name="txtCaseSumry"></textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		</form>
	</div>
</div>