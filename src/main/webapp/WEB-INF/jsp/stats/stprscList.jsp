<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<style type="text/css">
.tbLft {
	text-align: left;
}
.clsRed {
	background-color: rgba(233, 170, 171, 1);
	font-weight: bold;
}
</style>
<script type="text/javascript">
	var myGridID;

	$(function() {
		$(document).ready(function(){
			initGrid();
			fnDatePickerImg("searchPrsctDe1");
			fnDatePickerImg("searchPrsctDe2");

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
		fnMoveGridPage("/invsts/stprscListAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "grdRn", 			headerText : "순번", 			width : 50,  cellMerge : true,
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				}
			},
			{ dataField : "grdDscvryNo", 	headerText : "소재발견번호", 	width : 100, cellMerge : true, mergeRef : "grdMgNo", mergePolicy : "restrict",
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				},
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				}
			},
			{ dataField : "grdTrgterNm", 		headerText : "피의자", cellMerge : true, mergeRef : "grdMgNo", mergePolicy : "restrict",
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				},
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				}
			},
			{ dataField : "grdDscvryDe", 		headerText : "소재별견일자", width : 100, dataType : "date", formatString : "yyyy-mm-dd", cellMerge : true, mergeRef : "grdMgNo", mergePolicy : "restrict",
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				}
			},
			{ dataField : "grdDscvryResn", 		headerText : "소재발견사유<br/>(검거,재기신청)", cellMerge : true, mergeRef : "grdMgNo", mergePolicy : "restrict",
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				}
			},
			{ dataField : "grdDscvryReportDe",	headerText : "소재발견<br/>보고일자",width : 100,dataType : "date", formatString : "yyyy-mm-dd", cellMerge : true, mergeRef : "grdMgNo", mergePolicy : "restrict",
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				}
			},
			{ dataField : "grdVioltNm", 		headerText : "위반죄명", cellMerge : true, mergeRef : "grdMgNo", mergePolicy : "restrict", style : "tbLft",
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				}
			},
			{ dataField : "grdSrccrmRelisDe", 	headerText : "수배해제일자", width : 100, dataType : "date", formatString : "yyyy-mm-dd", cellMerge : true, mergeRef : "grdMgNo", mergePolicy : "restrict",
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				}
			},
			{ dataField : "grdCaseNo", 			headerText : "재기전사건번호",width : 110, cellMerge : true, mergeRef : "grdMgNo", mergePolicy : "restrict",
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				},
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				}
			},
			{ dataField : "grdTrnDe", 			headerText : "송치일자", 	width : 130, dataType : "date", formatString : "yyyy-mm-dd", cellMerge : true, mergeRef : "grdMgNo", mergePolicy : "restrict",
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				}
			},
			{ dataField : "grdChargerNm", 		headerText : "담당자", cellMerge : true, mergeRef : "grdMgNo", mergePolicy : "restrict",
				styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(item.grdChkDt == "F") {
						return "clsRed";
					}
					return null;
				}
			},

			{ headerText : "소재수사지휘",
				children: [
					{ dataField : "grdCmndDe", 		headerText : "의뢰일자", width : 100, dataType : "date", formatString : "yyyy-mm-dd" },
					{ dataField : "grdCmndGrfcNm", 	headerText : "의뢰관서", style : "tbLft" },
					{ dataField : "grdReportDe", 	headerText : "회신일자", width : 100, dataType : "date", formatString : "yyyy-mm-dd" },
					{ dataField : "grdReportCn", 	headerText : "회신내용" }
				]
			}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			enableCellMerge : true,
			cellMergePolicy : "withNull",
			fillColumnSizeMode : true,
			showRowNumColumn : false
		};
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var items = event.item;
			fnCaseDetailPopup(items.grdRcNo, "");
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
		fnCaseDetailPopup(items[0].item.grdRcNo, "");
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
				fileName : "기소중지부_CSV"
			});
		}else{
			AUIGrid.exportToXlsx(myGridID, {
				fileName : "기소중지부_EXCEL"
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
<input type="hidden" id="hidZrlongSeCd" name="hidZrlongSeCd" value="">  <!-- 체포영장 00774 구속영장 -->
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
		<div class="stitle w_100px">입건일자</div>
		<div class="r_box">
			<div class="input_out w_120px fl">
				<input type="text" class="w_100p input_com_ca" id="searchPrsctDe1" name="searchPrsctDe1" readonly style="line-height: 40px;">
			</div>
			<div class="input_out fl"> ~ </div>
			<div class="input_out w_120px fl">
				<input type="text" class="w_100p input_com_ca" id="searchPrsctDe2" name="searchPrsctDe2" readonly>
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
		<span class="icon_n fl clsRed mt_5" style="line-height: 20px; width: 5px; border: 1px solid #ff5623;">&nbsp;</span>
		<span class="icon_n fl mr_m1" style="line-height: 30px; font-size: 13px;">소재수사지휘 지연 (3개월)</span>
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
