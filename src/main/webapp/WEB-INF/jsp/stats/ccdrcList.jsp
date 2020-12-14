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
			fnDatePickerImg("searchDe1");
			fnDatePickerImg("searchDe2");

			<c:if test="${mngr_yn ne 'Y'}">
				fnSelectDept("", "${dept_cd}", "${dept_single_nm}")
				$("#searchChager").val("${esntl_id}");
				$("#searchDeptNm").attr("disabled",true);
				$("#btnDeptSearch").hide();
				$("#searchChager").attr("disabled",true);
			</c:if>
			fnSearch();
		});

	})

	function fnSearch() {
		if(!fnCompareDate($("#searchPrsctDe1"), $("#searchPrsctDe2"))) return;

		fnMoveGridPage("/invsts/ccdrcListAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [{
				headerText : "순번", dataField : "RN", width : 50
			}, {
				headerText : "번호",
				dataField : "CCDRC_NUMBER", // 그룹 헤더의 dataField 는 무의미 하지만, 칼럼 속성 변경 시 접근자로  사용하기 위해 임의 지정함.(중복되지 않게 임의 지정하세요.)
				children : [{
					headerText : "압수부", dataField : "CCDRC_NO", width : 100,
					labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
						return fnChangeNo (value);
					}
				}, {
					headerText : "압수물", dataField : "CCDRC_SN", width : 50
				}]
			}, {
				headerText : "범죄사건부<br/>번호", dataField : "CASE_NO", width : 100,
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			}, {
				headerText : "압수연월일", dataField : "SZURE_DE", width : 100
			}, {
				headerText : "압수물건",
				dataField : "CCDRC_GOOD", // 그룹 헤더의 dataField 는 무의미 하지만, 칼럼 속성 변경 시 접근자로  사용하기 위해 임의 지정함.(중복되지 않게 임의 지정하세요.)
				children : [{
					headerText : "품종", dataField : "CCDRC_NM", width : 200, style : "grid_td_left"
				}, {
					headerText : "수량", dataField : "CCDRC_QY", width : 50
				}]
			}, {
				headerText : "소유자의<br/>주거성명", dataField : "CF_POSESN_TRGTER_NM", width : 100
			}, {
				headerText : "피압수자의<br/>주거성명", dataField : "CF_SZURE_TRGTER_NM", width : 100
			}, {
				headerText : "보관자확인", dataField : "CONFM", width : 100
			}, {
				headerText : "취급자확인", dataField : "CONFM", width : 100
			}, {
				headerText : "처분",
				dataField : "CCDRC_DSPS", // 그룹 헤더의 dataField 는 무의미 하지만, 칼럼 속성 변경 시 접근자로  사용하기 위해 임의 지정함.(중복되지 않게 임의 지정하세요.)
				children : [{
					headerText : "처분연월일", dataField : "DSPS_DE", width : 100
				}, {
					headerText : "요지", dataField : "DSPS_NM", width : 100
				}]
			}, {
				headerText : "비고", dataField : "ETC", width : 100
			}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true,
			useGroupingPanel : false,
			showRowNumColumn : false,
			displayTreeOpen : true,
			groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
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
				fileName : "압수부_CSV"
			});
		}else{
			AUIGrid.exportToXlsx(myGridID, {
				fileName : "압수부_EXCEL"
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
		<div class="stitle w_80px">소유자명</div>
		<div class="r_box w_120px">
			<input type="text" name="searchTrgterNm" maxlength="50" size="50" value="" class="w_180px input_com" placeholder="대상자">
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_100px">압수일자</div>
		<div class="r_box">
			<div class="input_out w_120px fl">
				<input type="text" class="w_100p input_com_ca" id="searchDe1" name="searchDe1" readonly style="line-height: 40px;">
			</div>
			<div class="input_out fl"> ~ </div>
			<div class="input_out w_120px fl">
				<input type="text" class="w_100p input_com_ca" id="searchDe2" name="searchDe2" readonly>
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
