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
				headerText : "선택", dataField : "CHK", width : 40,
				renderer : {
					type : "CheckBoxEditRenderer",
					showLabel : false,
					editable : true,
					checkValue : "Y",
					unCheckValue : "N"
					/* visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
						if(item.STTUS_CD == "00022") return true;
						else return false;
					} */
				}
			}, {
				headerText : "임시번호", dataField : "TMPR_NO", width : 80,
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			}, {
				headerText : "접수번호", dataField : "RC_NO", width : 80,
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			}, {
				headerText : "접수일자", dataField : "RC_DT", width : 80, dataType : "date", formatString : "yyyy-mm-dd" //"yyyy-mm-dd hh:MM"
			}, {
				headerText : "수사단서", dataField : "INV_PROVIS_NM", width : 60
			}, {
				headerText : "혐의자", dataField : "TRGTERT_NMS", width : 90
			}, {
				headerText : "위반죄명", dataField : "VIOLT_NMS", width : 200, style : "grid_td_left"
			}, {
				headerText : "담당자", dataField : "CHARGER_NM", width : 60
			}, {
				headerText : "진행상태", dataField : "PROGRS_STTUS_NM", width : 110
			}, {
				headerText : "승인요청정보",
				dataField : "REQ_INFO", // 그룹 헤더의 dataField 는 무의미 하지만, 칼럼 속성 변경 시 접근자로  사용하기 위해 임의 지정함.(중복되지 않게 임의 지정하세요.)
				children : [{
					headerText : "승인상태", dataField : "STTUS_NM", width : 65
				}, {
					headerText : "요청자", dataField : "REQ_NM", width : 60
				}, {
					headerText : "요청일자", dataField : "REQ_DT", width : 80, dataType : "date", formatString : "yyyy-mm-dd"
				/*}, {
					headerText : "요청상세", dataField : "CONFM_CONTENTS", width : 75, height : 150, cellMerge : true, mergeRef : "TRN_NO", mergePolicy : "restrict", tooltip : {show : false},
					renderer : {type : "TemplateRenderer"},
					labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
						var template = "<a href=\"javascript:void(0);\" onClick=\"fnDocListPopup('P', '"+item.SANCTN_ID+"');\" class=\"btn_td2 icon_n fl \">요청상세</a>";
						return template;
					}*/
				}]
			}, {
				headerText : "승인(반려)정보",
				dataField : "CONFM_INFO", // 그룹 헤더의 dataField 는 무의미 하지만, 칼럼 속성 변경 시 접근자로  사용하기 위해 임의 지정함.(중복되지 않게 임의 지정하세요.)
				children : [{
					headerText : "작업자", dataField : "CONFMER_NM", width : 70
				}, {
					headerText : "작업일자", dataField : "CONFM_DT", width : 80, dataType : "date", formatString : "yyyy-mm-dd"
				}, {
					headerText : "작업이력", dataField : "CONFM_HISTORY", width : 75, height : 150, tooltip : {show : false},
					renderer : {type : "TemplateRenderer"},
					labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
						var template = "<a href=\"javascript:void(0);\" onClick=\"fnSanctnHistory('"+item.SANCTN_ID+"');\" class=\"btn_td1 icon_n fl \">승인이력</a>";
						return template;
					}
				}]
			}
		];
		var gridPros = {
			rowIdField : "RN",
			showRowNumColumn : true,
			displayTreeOpen : true,
			showRowCheckColumn : false,
			showRowAllCheckBox : false,
			rowCheckToRadio : false,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell:true,
			showTooltip : true, //툴팁 출력 지정
			tooltipSensitivity : 300, //마우스 오버 시 300ms 이후 툴팁 출력
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var items = event.item;
			AUIGrid.setCheckedRowsByValue("#grid_list", "RC_NO", items.RC_NO);
			fnCaseDetailPopup(items.RC_NO, "");
		});		
		AUIGrid.bind("#grid_list", "sorting", gridSort);

		// 조회
		fnSearch();
	}

	function fnSearch() {
		if(!fnCompareDate($("#searchReqDe1"), $("#searchReqDe2"))) return;

		fnMoveGridPage("/sanctn/tmprCanclReqListAjax/", "frmList", "#grid_list", 1);
	}

	function fnSelectDept(upcd, cd, nm){
		$("#searchDeptCd").val(cd);
		$("#searchDeptNm").val(nm);

		//fnUserList(cd, $("#searchChager"));
	}

	function fnConfm(sttusCd){
		fnConfmSanctn("S", sttusCd);
	}

</script>

<!-- 검색박스 -->
<form id="frmList" name="frmList" method="post">
<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">

<!-- 그리드 sort 관련 -->
<input type="hidden" id="sortingFields" name="sortingFields"/>
<input type="hidden" id="sortchk" name="sortchk"/>

<div class="search_box mb_20">
	<div class="search_in">
		<div class="stitle w_70px">승인상태</div>
		<div class="r_box">
			<select id="searchSttusCd" name="searchSttusCd" class="w_100px input_com">
				<option value="" selected>전체</option>
				<c:forEach var="cd" items="${sttusList}" varStatus="status">
				<option value="${cd.cd}" <c:if test="${cd.cd == '00022' && (searchSttusCd eq null)}">selected</c:if>><c:out value="${cd.cdNm}"/></option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_70px">요청일자</div>
		<div class="r_box">
			<div class="input_out w_120px  fl">
				<div class="calendar_box  w_120px  mr_5">
				<input type="text" name="searchReqDe1" id="searchReqDe1" class="w_100p input_com calendar" readonly checkName="요청일자">
				</div>
			</div>
			<div class="sp_tx fl">~</div>
			<div class="input_out  w_120px fl">
				<div class="calendar_box  w_120px  mr_5">
				<input type="text" name="searchReqDe2" id="searchReqDe2" class="w_100p input_com calendar" readonly checkName="요청일자">
				</div>
			</div>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_50px">부서</div>
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
	<div class="search_in">
		<div class="stitle w_70px">조회건수</div>
		<div class="r_box">
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
<!-- //검색박스 -->

<!-- 버튼 -->
<div class="com_box mb_10 ">
	<div class="right_btn fr">
		<!-- <a href="javascript:void(0);" class="btn_st2_2 icon_n fl " >사건상세조회</a> -->
		<a href="javascript:fnConfm('${sttus_sanctn_compt}');" class="btn_st2 icon_n fl mr_m1">승인</a>
		<a href="javascript:fnConfm('${sttus_sanctn_return}');" class="btn_st2 icon_n fl mr_m1">반려</a>
	</div>
</div>
<!--//버튼 -->

<!--테이블 시작 -->
<div class="tb_01_box">
	<div id="grid_list" class="gridResize" style="width:100%; height:570px; margin:0 auto;"></div>
	<div id="grid_list_paging" style="width:100%; height:40px;"></div>
</div>