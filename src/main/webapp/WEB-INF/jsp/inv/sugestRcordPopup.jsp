<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">

var myGridID;

	$(document).ready(function(){
		initGrid();
	});

	function fnClose(){
		parent.relateAddPopup.hide();
	}

	function initGrid() {
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
	function fnSearch() {
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
	function fnSaveRcordList() {
		if(fnIsEmpty($("#hidRcordRcNo").val())) return;
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
	function fnBringRcord() {
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
</script>

<body>

<!--팝업박스 -->
<form id="form_search" name="form_search" method="post">
<input type="hidden" id="schRcNo" name="schRcNo" value="${hidRcordRcNo}">
</form>

<div class="popup_body">
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
					<div id="gridRcordList" class="gridResize" style="width:100%; height:350px; margin:0 auto;"></div>
				</div>
			</div>
		</div>
	</form>
</div>
 <!--팝업박스 -->

</body>
</html>