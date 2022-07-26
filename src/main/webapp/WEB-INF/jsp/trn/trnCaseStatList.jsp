<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<style type="text/css">
.grid_td_left {
	text-align: left
}
</style>
<script type="text/javascript">
	var myGridID;

	$(function() {
		$(document).ready(function(){
			initGrid();
			fnDatePickerImg("searchTrnDe1");
			fnDatePickerImg("searchTrnDe2");

			<c:if test="${mngr_yn ne 'Y'}">
				fnSelectDept("", "${dept_cd}", "${dept_single_nm}")
				//$("#searchChager").val("${esntl_id}");//자신부서의 담당자 모두 검색 가능도록 수정 by dgkim 
				$("#searchDeptNm").attr("disabled",true);
				$("#btnDeptSearch").hide();
				//$("#searchChager").attr("disabled",false);//자신부서의 담당자 모두 검색 가능도록 수정 by dgkim 
			</c:if>
			fnSearch();
		});

	})

	function fnSearch() {
		if(!fnCompareDate($("#searchTrnDe1"), $("#searchTrnDe2"))) return;

		fnMoveGridPage("/trn/trnCaseStatListAjax/", "frmList", "#grid_list", 1);
	}
	/* 
		2021.01.18
		coded by dgkim
		송치의견 반영으로 인한 쿼리 수정, 피의자명 여러건 나오도록 수정
		김지만 수사관 요청
	*/
	function initGrid() {
		var columnLayout = [{
			headerText : "특별사법경찰",
			dataField : "TITLE_1", // 그룹 헤더의 dataField 는 무의미 하지만, 칼럼 속성 변경 시 접근자로  사용하기 위해 임의 지정함.(중복되지 않게 임의 지정하세요.)
			children :  [{
					headerText : "순번", dataField : "RN", width : 50
				}, {
					headerText : "송치번호", dataField : "TRN_NO", width : 120, cellMerge : true, mergePolicy:"restrict", mergeRef: "TRN_NO",
					labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
						return fnChangeNo (value);
					}
				}, {
					headerText : "송치일자", dataField : "TRN_DE", width : 120, dataType : "date", formatString : "yyyy-mm-dd", cellMerge : true, mergePolicy:"restrict", mergeRef: "TRN_NO",
				}, {
					headerText : "경찰사건번호", dataField : "CASE_NO", width : 120, cellMerge : true, mergePolicy:"restrict", mergeRef: "TRN_NO",
					labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
						return fnChangeNo (value);
					}
				}, {
					headerText : "피의자", dataField : "TRGTER_NM", width : 200
				}, {
					headerText : "죄명", dataField : "VIOLT_NM", style : "grid_td_left", cellMerge : true, mergePolicy:"restrict", mergeRef: "TRN_NO",
					/* renderer : {type : "TemplateRenderer"},
					labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
						var template = value.replace(",", "<br>");
						return template;
					} */
				}, {
					headerText : "담당자", dataField : "CHARGER_NM", width : 100, cellMerge : true, mergePolicy:"restrict", mergeRef: "TRN_NO",
				}, {
					headerText : "증거품", dataField : "EVDENC_DC", width : 150, cellMerge : true, mergePolicy:"restrict", mergeRef: "TRN_NO",
				}, {
					headerText : "구속여부", dataField : "IMPR_STTUS_NM"	, width : 100
				}]
			}, {
				headerText : "검찰",
				dataField : "TITLE_2", // 그룹 헤더의 dataField 는 무의미 하지만, 칼럼 속성 변경 시 접근자로  사용하기 위해 임의 지정함.(중복되지 않게 임의 지정하세요.)
				children :  [{
					headerText : "수리일자", dataField : "TRN_DE", width : 120, dataType : "date", formatString : "yyyy-mm-dd", cellMerge : true, mergePolicy:"restrict", mergeRef: "TRN_NO",
				}, {
					headerText : "수리자(직급,성명,날인)", dataField : "", width : 200, cellMerge : true, mergePolicy:"restrict", mergeRef: "TRN_NO",
				}]
			},
			{
				headerText : "송치의견", dataField : "TRN_OPINION_NM"	, width : 150
			} 
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			selectionMode : "singleRow",
			//wordWrap : true,
			//fillColumnSizeMode : true,
			showTooltip : true, //툴팁 출력 지정
			tooltipSensitivity : 300, //마우스 오버 시 300ms 이후 툴팁 출력
			useGroupingPanel : false,
			showRowNumColumn : false,
			displayTreeOpen : true,
			showAutoNoDataMessage : false,
			groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
			enableCellMerge : true,
		};
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var items = event.item;
			fnCaseDetailPopup(items.RC_NO, "");
		});
		AUIGrid.bind("#grid_list", "sorting", gridSort);
	}

	function fnSelectDept(upcd, cd, nm){
		$("#searchDeptCd").val(cd);
		$("#searchDeptNm").val(nm);

		fnUserList(cd, $("#searchChager"));
	}

	function fnCaseDetail() {
		var items = AUIGrid.getSelectedItems(myGridID);
		if(items.length <= 0) {
			alert("상세조회할 사건을 선택하세요.");
			return;
		}
		fnCaseDetailPopup(items[0].item.RC_NO, "");
	}


	function fnExportTo() {
		//FileSaver.js 로 로컬 다운로드가능 여부 확인
		if(!AUIGrid.isAvailableLocalDownload(myGridID)) {
			alert("로컬 다운로드 불가능한 브라우저 입니다. 서버 사이드로 전송하여 다운로드 처리하십시오.");
			return;
		}

		var rowCount = AUIGrid.getRowCount(myGridID);

		// 10만행 보다 크다면 CSV로 다운로드 처리
		if(rowCount >= 100000) {
			alert("10만건 이상일 경우  CSV로 데이터를 출력합니다.");
			AUIGrid.exportToCsv(myGridID, {
				fileName : "사건송치부_CSV"
			});
		}else{
			AUIGrid.exportToXlsx(myGridID, {
				fileName : "사건송치부_EXCEL"
			});
		}
	};

</script>

<!--검색박스 -->
<form id="frmList" name="frmList" method="post">

<!-- 그리드 sort 관련 -->
<input type="hidden" id="sortingFields" name="sortingFields"/>
<input type="hidden" id="sortchk" name="sortchk"/>

<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">
<div class="search_box mb_30">
	<div class="search_in">
		<div class="stitle w_100px">부서/담당자</div>
		<div class="r_box">
			<!--찾기 -->
			<div class="flex_r mb_5 w_120px mr_5">
				<input type="hidden" id="searchDeptCd" name="searchDeptCd">
				<input type="text" id="searchDeptNm" name="searchDeptNm" maxlength="50" size="50" value="" class="w_100p input_com" placeholder="부서" readonly>
				<input type="button" id="btnDeptSearch" value="" class="btn_search" onclick="fnDeptSelect();">
			</div>
			<select class="w_150px" id="searchChager" name="searchChager">
				<option value="">==선택하세요==</option>
			</select>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_80px">대상자명</div>
		<div class="r_box w_120px">
			<input type="text" name="searchTrgterNm" maxlength="50" size="50" value="" class="w_180px input_com" placeholder="대상자">
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_100px">송치일자</div>
		<div class="r_box">
			<div class="input_out w_120px fl">
				<input type="text" class="w_100p input_com_ca" id="searchTrnDe1" name="searchTrnDe1" readonly style="line-height: 40px;">
			</div>
			<div class="input_out fl"> ~ </div>
			<div class="input_out w_120px fl">
				<input type="text" class="w_100p input_com_ca" id="searchTrnDe2" name="searchTrnDe2" readonly>
			</div>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_100px">조회건수</div>
		<div class="r_box">
			<select name="hidPageBlock" id="hidPageBlock" class="w_100px">
				<option value="" <c:if test="${hidPageBlock eq ''}">selected</c:if>>==전체==</option>
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
		<a href="javascript:fnExportTo();" class="btn_st2 icon_n fl mr_m1">엑셀출력</a>
		<a href="javascript:fnCaseDetail();" class="btn_st2_2 icon_n fl mr_m1">사건상세보기</a>
	</div>
</div>
<!--//버튼  -->
<!--테이블 시작 -->
<div class="tb_01_box">
	<div id="grid_list" class="gridResize" style="width:100%; height:570px; margin:0 auto;"></div>
	<div id="grid_list_paging" style="width:100%; height:40px;"></div>
</div>
