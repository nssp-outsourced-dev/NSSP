<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
</style>
<script type="text/javascript">
	var gCaseNo = "";
	$(function() {
		$(document).ready(function(){
			fnDatePickerImg("calTrnDeFrom", null, false);
			fnDatePickerImg("calTrnDeTo", null, false);
			initGrid();   // 그리드관련
			gridResize(); // 그리드관련
			$("#schCaseNo1").focus();
		});
	
		$("#schCaseNo1").keyup(function(event) {
			fnRemoveChar(event);
			if($(this).val().length == 4) {
				$("#schCaseNo2").focus();
			}
		});
	
		$("#schCaseNo2").keyup(function(event) {
			fnRemoveChar(event);
			if(event.keyCode == 13) {
				fnSetNo($(this));
				fnSearch();
			}
		});
	
		$("#schTrnNo1").keyup(function(event) {
			fnRemoveChar(event);
			if($(this).val().length == 4) {
				$("#schTrnNo2").focus();
			}
		});
	
		$("#schTrnNo2").keyup(function(event) {
			fnRemoveChar(event);
			if(event.keyCode == 13) {
				fnSetNo($(this));
				fnSearch();
			}
		});
	});
	
	function fnSetNo(obj) {
		if($(obj).val()) {
			$(obj).val(fnLpad($(obj).val(), 6));
		}
	}
	
	function initGrid() {
		var columnLayout = [{
				headerText : "송치번호", dataField : "TRN_NO"
			}, {
				headerText : "송치일자", dataField : "TRN_DE", width : 120, dataType : "date", formatString : "yyyy-mm-dd"
			}, {
				headerText : "사건번호", dataField : "CASE_NO"
			}, {
				headerText : "담당자", dataField : "CHARGER_NM"
			}, {
				headerText : "관할검찰", dataField : "CMPTNC_EXMN_NM", style : "grid_td_left"
			}, {
				headerText : "증거물여부", dataField : "EVDENC_YN"
			}, {
				headerText : "비고", dataField : "TRN_RM"
			}
		];
 		var gridPros = {
 	 		showRowNumColumn : true,
 			displayTreeOpen : true,
 			showRowCheckColumn : true,
 			rowCheckToRadio : true,
 			selectionMode : "singleRow",
 			triggerSelectionChangeOnCell:true,
 			noDataMessage:"조회 목록이 없습니다.",
 			headerHeight : 30,
 			rowHeight: 30,
 			fillColumnSizeMode : true
 		};
		AUIGrid.create("#gridList", columnLayout, gridPros);
		AUIGrid.bind("#gridList", "cellDoubleClick", function(event) {
			var items = event.item;
			AUIGrid.setCheckedRowsByValue("#gridList", "CASE_NO", items.CASE_NO);
			fnCaseDtlPop(items.CASE_NO);			
		});
		// 체크박스(라디오버턴) 클릭 이벤트 바인딩
		AUIGrid.bind("#gridList", "rowCheckClick", function(event) {
			//console.log("rowIndex : " + event.rowIndex + ", id : " + event.item.id + ", name : " + event.item.name + ", checked : " + event.checked);
			var items = event.item;
			gCaseNo = items.CASE_NO;
			//fnCaseDtlPop(items.CASE_NO);
		});		
	}
	
	function fnSearch() {
		if(!fnCompareDate($("#calTrnDeFrom"), $("#calTrnDeTo"))) return;

		fnSearchGrid("/trn/trnCaseListAjax/", "form_search", "#gridList");
	}
	
	function fnCaseDtlPop(sCaseNo) {
		if(!sCaseNo) {
			sCaseNo = gCaseNo;
		}
		fnCaseDetailPopup($("#labRcNo").val(), sCaseNo);	
	}
</script>
<!--검색박스 -->
<div class="search_box mb_20">
	<div class="search_in">
		<div class="stitle mr_20">송치번호</div>
		<div class="r_box ">
			<input type="text" name="schTrnNo1" id="schTrnNo1" maxlength="4" class="w_80px input_com" />&nbsp;-
			<input type="text" name="schTrnNo2" id="schTrnNo2" maxlength="6" class="w_100px input_com" onblur="fnSetNo(this)"/>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle mr_20">사건번호</div>
		<div class="r_box ">
			<input type="text" name="schCaseNo1" id="schCaseNo1" maxlength="4" class="w_80px input_com" />&nbsp;-
			<input type="text" name="schCaseNo2" id="schCaseNo2" maxlength="6" class="w_100px input_com" onblur="fnSetNo(this)"/>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_70px ">신청일자</div>
		<div class="r_box">
			<div class="input_out w_120px fl">
				<input type="text" name="calTrnDeFrom" id="calTrnDeFrom" class="w_100p input_com">
				<div class="calendar_icon">
					<img src="/img/search_calendar.png" alt="" />
				</div>
			</div>
			<div class="sp_tx  fl">~</div>
			<div class="input_out w_120px  fl">
				<input type="text" name="calTrnDeTo" id="calTrnDeTo" class="w_100p  input_com">
				<div class="calendar_icon">
					<img src="/img/search_calendar.png" alt="" />
				</div>

			</div>
		</div>
	</div>
	<a href="javascript:fnSearch();"><div class="go_search2">검색</div></a>
</div>
<!--//검색박스 -->
<!-- 버튼 -->
<div class="com_box mb_10 ">
	<div class="right_btn fr">
		<a href="javascript:void(0);" class="btn_st2_2 icon_n fl " onclick="fnCaseDtlPop();">사건상세조회</a>
	</div>
</div>
<!--//버튼 -->
<!--테이블 시작 -->
<div class="com_box mb_20">
	<div class="tb_01_box">
		<div id="gridList" class="gridResize" style="width:100%; height:600px; margin:0 auto;"></div>
	</div>
</div>