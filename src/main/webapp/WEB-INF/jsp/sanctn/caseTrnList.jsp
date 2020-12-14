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
			fnDatePickerImg("searchReqDe1", fnGetToday(12, 0), true);
			fnDatePickerImg("searchReqDe2", null, true);
			initGrid();   // 그리드관련
			gridResize(); // 그리드관련
			$("#searchNo1").focus();
		});

		$("#searchNo1").keyup(function(event) {
			fnRemoveChar(event);
			if($(this).val().length == 4) {
				$("#searchNo2").focus();
			}
		});

		$("#searchNo2").keyup(function(event) {
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
				headerText : "선택", dataField : "CHK", width : 50, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false},
				/* headerRenderer : {
					type : "CheckBoxHeaderRenderer",
					// 헤더의 체크박스가 상호 의존적인 역할을 할지 여부(기본값:false)
					// dependentMode 는 renderer 의 type 으로 CheckBoxEditRenderer 를 정의할 때만 활성화됨.
					// true 설정했을 때 클릭하면 해당 열의 필드(데모 상은 isActive 필드)의 모든 데이터를 true, false 로 자동 바꿈
					dependentMode : true,
					position : "bottom" // 기본값 "bottom"
				},*/
				renderer : {
					type : "CheckBoxEditRenderer",
					showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
					editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
					checkValue : "Y", // true, false 인 경우가 기본
					unCheckValue : "N",
					// 체크박스 Visible 함수
					visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
						if(item.STTUS_CD == "00022") return true;
						else return false;
					}
				}
			}, {
				headerText : "송치번호", dataField : "TRN_NO", width : 80, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false}
			}, {
				headerText : "송치일자", dataField : "TRN_DE", width : 80, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false}, dataType : "date", formatString : "yyyy-mm-dd"
			}, {
				headerText : "사건번호", dataField : "CASE_NO", width : 80, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false}
			}, {
				headerText : "담당자", dataField : "CHARGER_NM", width : 60, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false}
			}, {
				headerText : "관할검찰", dataField : "CMPTNC_EXMN_NM", width : 120, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false}
			}, {
				headerText : "증거물여부", dataField : "EVDENC_YN", width : 60, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false}
			}, {
				headerText : "피의자", dataField : "TRGTER_NM", width : 70, tooltip : {show : false}
			}, {
				headerText : "위반사항", dataField : "VIOLT_NM", width : 200, style : "grid_td_left"
			}, {
				headerText : "구속여부", dataField : "IMPR_STTUS_NM", width : 70, tooltip : {show : false}
			}, {
				headerText : "진행상태", dataField : "PROGRS_STTUS_NM", width : 70, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false}
			}, {
				headerText : "요청자", dataField : "REQ_NM", width : 60, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false}
			}, {
				headerText : "요청일시", dataField : "REQ_DT", width : 100, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false}
			}, {
				headerText : "요청상세", dataField : "CONFM_CONTENTS", width : 80, height : 150, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false},
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var template = "<a href=\"javascript:void(0);\" onClick=\"fnDocListPopup('T', '"+item.SANCTN_ID+"');\" class=\"btn_td2 icon_n fl \">요청상세</a>";
					return template;
				}
			}, {
				headerText : "승인(반려)자", dataField : "CONFMER_NM", width : 70, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false}
			}, {
				headerText : "승인(반려)일시", dataField : "CONFM_DT", width : 100, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false}
			}, {
				headerText : "승인이력", dataField : "CONFM_HISTORY", width : 80, height : 150, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false},
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var template = "<a href=\"javascript:void(0);\" onClick=\"fnSanctnHistory('"+item.SANCTN_ID+"');\" class=\"btn_td1 icon_n fl \">승인이력</a>";
					return template;
				}
			}
		];
		var gridPros = {
			rowIdField : "RN",
			showRowNumColumn : true,
			displayTreeOpen : true,
			showRowCheckColumn : false,
			rowCheckToRadio : false,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell:true,
			noDataMessage:"조회 목록이 없습니다.",
			showTooltip : true, //툴팁 출력 지정
			tooltipSensitivity : 0, //툴팁 마우스 대면 바로 나오도록
			tooltipSensitivity : 300, //마우스 오버 시 300ms 이후 툴팁 출력
			enableCellMerge : true,
			cellMergePolicy : "withNull",
			rowSelectionWithMerge : true,
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);
		// 셀 수정 완료 이벤트 바인딩
		AUIGrid.bind("#grid_list", "cellEditEnd", function(event) {
			// group 칼럼 수정 완료 한 경우
			if(event.dataField == "CHK") {
				// 체크박스 클릭 했을 때, 병합된 모든 행의 체크박스를 동기화 시킴.
				syncData(event.item, event.rowIndex, event.dataField, "TRN_NO", event.value);
			}
		});
		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var items = event.item;
			//AUIGrid.setCheckedRowsByValue("#grid_list", "CASE_NO", items.CASE_NO);
			fnCaseDetailPopup(items.RC_NO, items.CASE_NO);
		});

		// 조회
		fnSearch();
	}

	// 체크박스 클릭 했을 때, 병합된 모든 행의 체크박스를 동기화 시킴.
	function syncData(item, rowIndex, dataField, refDataField, value) {
		var gridData = AUIGrid.getGridData("#grid_list");
		var gridLen = gridData.length;
		var rowIdField = AUIGrid.getProp("#grid_list", "rowIdField");
		var items4update = [];
		var row;
		var obj;

		for (var i = rowIndex + 1; i < gridLen; i++) {
			row = gridData[i];
			if (item[refDataField] == row[refDataField]) {
				obj = {};
				obj[rowIdField] = row[rowIdField];
				obj[dataField] = value;
				items4update.push(obj);
			} else {
				break;
			}
		}
		// 동일하게 변경
		AUIGrid.updateRowsById("#grid_list", items4update);
	};

	function fnSearch() {
		if(!fnCompareDate($("#searchReqDe1"), $("#searchReqDe2"))) return;
		fnMoveGridPage("/sanctn/caseTrnListAjax/", "frmList", "#grid_list", 1);
	}

	function fnConfm(sttusCd){
		// 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
		//var chkItems = AUIGrid.getCheckedRowItems("#grid_list");//showRowCheckColumn
		var chkItems = AUIGrid.getItemsByValue("#grid_list", "CHK", "Y");

		if(chkItems.length < 1){
			alert("한 개 이상의 승인건을 선택해야 합니다.");
			return;
		}

		var ids = [];
		for(var i = 0 ; i < chkItems.length ; i++) {
			if(i == 0) {
				ids.push(chkItems[i].SANCTN_ID); // 아이디만 따로 보관해서 alert 출력
			} else {
				if(chkItems[i].SANCTN_ID != chkItems[i].SANCTN_ID) {
					ids.push(chkItems[i].SANCTN_ID);
				}
			}
		}
		var str = ids.join("^");

		//console.log(str);

		sanctnConfmPopup = dhtmlmodal.open('sanctnConfm', 'iframe', '/sanctn/confmPopup/?cate=T&sttusCd='+ sttusCd +'&chkId='+str, '승인/반려', 'width=800px,height=300px,center=1,resize=0,scrolling=1')
		sanctnConfmPopup.onclose = function(){
			fnSearch();
			return true;
		}
	}
</script>

<!-- 검색박스 -->
<form id="frmList" name="frmList" method="post">
<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">
<input type="hidden" id="hidPageBlock" name="hidPageBlock" value="1000">

<div class="search_box mb_20">
	<div class="search_in">
		<div class="stitle w_70px">승인상태</div>
		<div class="r_box">
			<select id="searchSttusCd" name="searchSttusCd" class="w_100px input_com">
				<option value="">전체</option>
				<c:forEach var="cd" items="${sttusList}" varStatus="status">
				<option value="${cd.cd}" <c:if test="${status.index == 0}">selected</c:if>><c:out value="${cd.cdNm}"/></option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle  w_80px">요청일자</div>
		<div class="r_box">
			<div class="input_out w_120px  fl">
				<input type="text" class="w_100p input_com_s" id="searchReqDe1" name="searchReqDe1" readonly>
				<div class="calendar_icon">
					<img src="/img/search_calendar.png" alt="" />
				</div>
				<div id="divCal1" class="calendarOverlay"></div>
			</div>
			<div class="sp_tx fl">~</div>
			<div class="input_out  w_120px fl">
				<input type="text" class="w_100p input_com_s" id="searchReqDe2" name="searchReqDe2" readonly>
				<div class="calendar_icon">
					<img src="/img/search_calendar.png" alt="" />
				</div>
				<div id="divCal2" class="calendarOverlay"></div>
			</div>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_70px">부서</div>
		<div class="r_box w_120px">
			<div class="flex_r mb_5">
			<input type="hidden" id="searchDeptCd" name="searchDeptCd" value="${dept_cd}">
			<input type="text" id="searchDeptNm" name="searchDeptNm" maxlength="50" size="50" value="${dept_single_nm}" class="w_100p input_com" placeholder="부서" readonly> 
			<input type="button" value="" class="btn_search" onclick="fnDeptSelect();">
			</div>
		</div>
	</div>
	<%--<div class="search_in">
		<div class="r_box">
			<select name="searchNoDiv"  class="w_80px input_com mr_5">
				<option value="C">사건번호</option>
				<option value="T">송치번호</option>
			</select>
			<input type="text" name="searchNo1" id="searchNo1" class="w_60px input_com"> -
			<input type="text" name="searchNo2" id="searchNo2" class="w_80px input_com">
		</div>
	</div>
	<div class="inbox08">
		<div class="stitle">조회건수</div>
		<div class="tl_box">
			<select name="hidPageBlock" id="hidPageBlock" class="w_100px fl">
				<option value="10" <c:if test="${hidPageBlock eq '10'}">selected</c:if>>10</option>
				<option value="20" <c:if test="${hidPageBlock eq '20'}">selected</c:if>>20</option>
				<option value="50" <c:if test="${hidPageBlock eq '50'}">selected</c:if>>50</option>
				<option value="100" <c:if test="${hidPageBlock eq '100'}">selected</c:if>>100</option>
				<option value="200" <c:if test="${hidPageBlock eq '200'}">selected</c:if>>200</option>
				<option value="500" <c:if test="${hidPageBlock eq '500'}">selected</c:if>>500</option>
			</select>
		</div>
	</div>--%>
	<div class="go_search2" onclick="fnSearch();">검색</div>
</div>
</form>
<!-- //검색박스 -->

<!-- 버튼 -->
<div class="com_box mb_10 ">
	<div class="right_btn fr">
		<!-- <a href="javascript:void(0);" class="btn_st2_2 icon_n fl " >사건상세조회</a> -->
		<a href="javascript:fnConfm('${sttus_sanctn_compt}');" class="btn_st2 icon_n fl mr_m1">승인</a>
		<a href="javascript:fnConfm('${sttus_sanctn_return}');" class="btn_st1 icon_n fl mr_m1">반려</a>
	</div>
</div>
<!--//버튼 -->

<!--테이블 시작 -->
<div class="tb_01_box">
	<div id="grid_list" class="gridResize" style="width:100%; height:500px; margin:0 auto;"></div>
	<div id="grid_list_paging" style="width:100%; height:40px;"></div>
</div>