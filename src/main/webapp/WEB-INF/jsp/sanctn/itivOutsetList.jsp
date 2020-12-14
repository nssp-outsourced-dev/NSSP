<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<script type="text/javascript">	

	$(function() {
		$(document).ready(function(){
			initGrid();
			//fnRealDatePicker("searchReqDe1","divCal1");
			//fnRealDatePicker("searchReqDe2","divCal2");
			fnDatePickerImg("searchReqDe1", fnGetToday(12, 0), true);
			fnDatePickerImg("searchReqDe2", null, true);
		});

	})


	function fnSearch() {
		fnMoveGridPage("/sanctn/itivOutsetListAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [{
				headerText : "선택", dataField : "CHK", width : 40,
				renderer : {
					type : "CheckBoxEditRenderer",
					showLabel : false,
					editable : true,
					checkValue : "Y",
					unCheckValue : "N",
					visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
						if(item.STTUS_CD == "00022") return true;
						else return false;
					}
				}
			},
			{ dataField : "SANCTN_ID", headerText : "SANCTN_ID", visible : false},
			{ dataField : "RC_NO", headerText : "접수번호"},
			{ dataField : "RC_DT", headerText : "접수일자", dataType : "date", formatString : "yyyy-mm-dd hh:MM"},
			{ dataField : "INV_PROVIS_NM", headerText : "수사단서"},
			{ dataField : "SUSPCT_NM", headerText : "피의자"},
			{ dataField : "SUFRER_NM", headerText : "피해자"},
			{ dataField : "VIOLT_NM", headerText : "위반사항"},
			{ dataField : "STTUS_CD", headerText : "STTUS_CD", visible : false},
			{ dataField : "STTUS_NM", headerText : "승인상태"},
			{ dataField : "PROGRS_STTUS_NM", headerText : "진행상태"},
			{ dataField : "REQ_NM", headerText : "요청자"},
			{ dataField : "REQ_DT", headerText : "요청일시"},
			{
				dataField : "CONFM_CONTENTS",
				headerText : "요청상세",
				width : 85,
				height : 150,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var template = "<a href=\"javascript:void(0);\" onClick=\"fnDocListPopup('A', '"+item.SANCTN_ID+"');\" class=\"btn_td2 icon_n fl \">요청상세</a>";
					return template;
				}
			},
			{ dataField : "CONFMER_NM", headerText : "승인자"},
			{ dataField : "CONFM_DT", headerText : "승인일시"},
			{
				dataField : "CONFM_HISTORY",
				headerText : "승인이력",
				width : 85,
				height : 150,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var template = "<a href=\"javascript:void(0);\" onClick=\"fnSanctnHistory('"+item.SANCTN_ID+"');\" class=\"btn_td1 icon_n fl \">승인이력</a>";
					return template;
				}
			}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,	
			fillColumnSizeMode : true,
			rowIdField : "SANCTN_ID",
			selectionMode : "singleRow",
			useGroupingPanel : false,		
			showRowNumColumn : true,			
			showRowCheckColumn : false,
			showRowAllCheckBox : false,
			noDataMessage:"조회 목록이 없습니다.",
			rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
				if(item.STTUS_CD != "${sttus_sanctn_wait}") {
					return false;
				}
				return true;
			}
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);

		// 셀클릭 이벤트 바인딩
		AUIGrid.bind("#grid_list", "cellClick", function(event) {
			var item = event.item;
			var rowIdField;
			var rowId;
			if(item.STTUS_CD != "${sttus_sanctn_wait}") {
				return;
			}

			rowIdField = AUIGrid.getProp(event.pid, "rowIdField"); // rowIdField 얻기
			rowId = item[rowIdField];
			
			// 이미 체크 선택되었는지 검사
			if(AUIGrid.isCheckedRowById(event.pid, rowId)) {
				// 엑스트라 체크박스 체크해제 추가
				AUIGrid.addUncheckedRowsByIds(event.pid, rowId);
			} else {
				// 엑스트라 체크박스 체크 추가
				AUIGrid.addCheckedRowsByIds(event.pid, rowId);
			}
		});

		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var items = event.item;
			//AUIGrid.setCheckedRowsByValue("#grid_list", "CASE_NO", items.CASE_NO);
			if(fnIsEmpty(items.CASE_NO)) {
				fnCaseDetailPopup(items.RC_NO, "");
			} else {
				fnCaseDetailPopup(items.RC_NO, items.CASE_NO);
			}
		});
		
		fnMoveGridPage("/sanctn/itivOutsetListAjax/", "frmList", "#grid_list", 1);		
	}

	function fnSelectDept(upcd, cd, nm){
		$("#searchDeptCd").val(cd);
		$("#searchDeptNm").val(nm);
	}

	function fnConfm(sttusCd){
		fnConfmSanctn("A", sttusCd);
	}
	
</script>

<!--검색박스 -->
<form id="frmList" name="frmList" method="post">
<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">

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
	</div>--%>
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
	</div>
	<div class="go_search2" onclick="fnSearch();">검색</div>
</div>
</form>
<!--//검색박스 -->

<!--------- 내용--------->
<div class="com_box ">
	<!-- 안내박스  -->
	<div class="title_s_st3 w_50p">
	</div>
	<!-- 안내박스  -->
	<!--버튼 -->
	<div class="right_btn fr mb_10">
		<!--<a href="#" onClick="popup010201(); return false" class="btn_st2_2 icon_n fl mr_m1">사건상세보기</a> -->
		<a href="javascript:fnConfm('${sttus_sanctn_compt}');" class="btn_st2 icon_n fl mr_m1">승인</a>
		<a href="javascript:fnConfm('${sttus_sanctn_return}');" class="btn_st1 icon_n fl mr_m1">반려</a>
	</div>
</div>

<!--//버튼  -->
<!--테이블 시작 -->
<div class="tb_01_box">
	<div id="grid_list" class="gridResize" style="width:100%; height:500px; margin:0 auto;"></div>		
	<div id="grid_list_paging" style="width:100%; height:40px;"></div>	
</div>
