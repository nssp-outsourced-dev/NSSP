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

			fnSelectDept("", "${dept_cd}", "${dept_single_nm}")
			<c:if test="${mngr_yn ne 'Y'}">
				$("#searchChager").val("${esntl_id}");
				$("#searchDeptNm").attr("disabled",true);
				$("#btnDeptSearch").hide();
				$("#searchChager").attr("disabled",true);
			</c:if>
			fnSearch();
		});


		//검색 미제사건 체크박스 클릭시
		$('#chkColdCase').click(function(){
			if( $("#chkColdCase").prop("checked") ){
				if( $("#chkStopCase").prop("checked") ){
					$("#chkStopCase").prop('checked', false);
				}
			}
		});

		//검색 중지사건 체크박스 클릭시
		$('#chkStopCase').click(function(){
			if( $("#chkStopCase").prop("checked") ){
				if( $("#chkColdCase").prop("checked") ){
					$("#chkColdCase").prop('checked', false);
				}
			}
		});

	})

	function fnSearch() {
		if(!fnCompareDate($("#searchTrnDe1"), $("#searchTrnDe2"))) return;

		fnMoveGridPage("/alot/hndvrListAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [{
				headerText : "순번", dataField : "RN", width : 40
			}, {
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
				headerText : "부서", dataField : "CHARGER_DEPT_NM", width : 150//, cellMerge : true, mergeRef : "CHARGER_ID", mergePolicy : "restrict"
			}, {
				headerText : "담당자", dataField : "USER_NM", width : 70//, cellMerge : true, mergeRef : "CHARGER_ID", mergePolicy : "restrict"
			}, {
				headerText : "접수번호", dataField : "RC_NO", width : 100,
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			}, {
				headerText : "접수일시", dataField : "RC_DT", width : 100

			}, {
				headerText : "수사단서", dataField : "INV_PROVIS_NM", width : 70
			}, {
				headerText : "구분", dataField : "RC_SE_NM", width : 50
			}, {
				headerText : "피의자", dataField : "SUSPCT_NM" , width : 80
			}, {
				headerText : "피해자", dataField : "VICTIM_NM" , width : 80
			}, {
				headerText : "죄명", dataField : "VIOLT_NM", width : 170, style : "grid_td_left"
			}, {
				headerText : "진행상태", dataField : "PROGRS_STTUS_NM" , width : 120
			}, {
				headerText : "경과일", dataField : "CF_DAYS" , width : 50
			}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			selectionMode : "singleRow",
			//wordWrap : true,
			fillColumnSizeMode : true,
			showTooltip : true, //툴팁 출력 지정
			tooltipSensitivity : 300, //마우스 오버 시 300ms 이후 툴팁 출력
			useGroupingPanel : false,
			showRowNumColumn : false,
			displayTreeOpen : true,
			showAutoNoDataMessage : false
			//enableCellMerge : true,
			//cellMergeRowSpan : false,
			//cellMergePolicy : "withNull",
			//rowSelectionWithMerge : true
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

	function fnHandover(){

		// 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
		var chkItems = AUIGrid.getItemsByValue("#grid_list", "CHK", "Y");
		//var chkItems = AUIGrid.getCheckedRowItems("#grid_list");//showRowCheckColumn

		if(chkItems.length < 1){
			alert("인계할 사건을 선택하세요.");
			return;
		}

		/* var editedRowItems = AUIGrid.getEditedRowItems("#grid_list");
		if(editedRowItems.length == 0) {
			alert("수정한 자료가 없습니다.");
			return;
		} */

		var chargerId = chkItems[0].CHARGER_ID;
		var deptCd = chkItems[0].CHARGER_DEPT_CD;
		var deptNm = chkItems[0].CHARGER_DEPT_NM;

		hndvrPop = dhtmlmodal.open('hndvrPop', 'iframe', '/alot/hndvrPopup/?deptCd='+deptCd+'&deptNm='+encodeURIComponent(deptNm)+'&chargerId='+chargerId, '인계처리', 'width=620px,height=520px,center=1,resize=0,scrolling=1')
		hndvrPop.onclose = function(){
			var iframedoc = this.contentDoc;
			var userId = iframedoc.getElementById("hidUserId").value;
			var deptCd = iframedoc.getElementById("hidDeptCd").value;
			//console.log('팝업에서 선택 후 : '+userId + "/" + deptCd);

			var data = fnAjaxAction("/alot/saveHndvrAjax/", JSON.stringify({alotList:chkItems, userId:userId, deptCd:deptCd}));
			if(data.result == "1") {
				alert("인수인계 처리되었습니다.");
				fnMoveGridPage("/alot/hndvrListAjax/", "frmList", "#grid_list", 1);
			} else {
				alert("인수인계 처리중 오류가 발생했습니다.");
			}

			return true;
		}
	}

</script>

<form id="frmList" name="frmList" method="post">
<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">

<!-- 그리드 sort 관련 -->
<input type="hidden" id="sortingFields" name="sortingFields"/>
<input type="hidden" id="sortchk" name="sortchk"/>
	
<!--검색박스 -->
<div class="search_box mb_20">
	<div class="search_in">
		<div class="stitle w_100px">부서/담당자</div>
		<div class="r_box w_350px">
			<!--찾기 -->
			<div class="flex_r ">
				<input type="hidden" id="searchDeptCd" name="searchDeptCd" value="${dept_cd}">
				<input type="text" id="searchDeptNm" name="searchDeptNm" maxlength="50" size="50" value="${dept_single_nm}" class="w_150px input_com" placeholder="부서" readonly>
				<c:if test="${mngr_yn eq 'Y'}">
				<input type="button" id="btnDeptSearch" value="" class="btn_search mr_10" onclick="fnDeptSelect();">
				</c:if>
				<!--//찾기 폼-->
				<select class="w_130px" id="searchChager" name="searchChager">
					<option value="">==선택하세요==</option>
				</select>
			</div>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_70px ">조회건수</div>
		<div class="r_box">
			<select name="hidPageBlock" id="hidPageBlock" class="w_100px fl">
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
	<div class="search_in" style="padding-left: 10px;width: 110px;border-right:0px">
		<div class="input_radio4  w_70px t_left" style="width: 70px;margin-right: 0px;padding-left: 25px;padding-right: 0px">
			<div class="stitle">미제사건</div>
			<input class="to-labelauty-icon ch_st1" type="checkbox" name="chkColdCase" id="chkColdCase" value="Y"/>
		</div>
	</div>
	<div class="search_in" style="padding-left: 10px;width: 110px;border-right:0px">
		<div class="input_radio4  w_70px t_left" style="width: 70px;margin-right: 0px;padding-left: 25px;">
			<div class="stitle">중지사건</div>
			<input class="to-labelauty-icon ch_st1" type="checkbox" name="chkStopCase"	id="chkStopCase"	value="Y"/>
		</div>
	</div>
	<div class="go_search2" onclick="fnSearch();">검색</div>
</div>
<!--//검색박스 -->
</form>

<!--------- 내용--------->
<div class="com_box ">
	<!-- 안내박스  -->
	<div class="title_s_st3 w_50p">
	</div>
	<!-- 안내박스  -->
	<!--버튼 -->
	<div class="right_btn fr mb_10">
		<a href="javascript:fnHandover();" class="btn_st2 icon_n fl mr_m1">인계</a>
	</div>
</div>
<!--//버튼  -->
<!--테이블 시작 -->
<div class="tb_01_box">
	<div id="grid_list" class="gridResize" style="width:100%; height:560px; margin:0 auto;"></div>
	<div id="grid_list_paging" style="width:100%; height:40px;"></div>
</div>
