<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<style type="text/css">

/* 커스텀 스타일 */
.left {
	text-align:left;
}

</style>
<script type="text/javascript">
	$(function() {
		$(document).ready(function(){
			initGrid();
		});

	})


	function fnSearch() {
		fnSearchGridData("/doc/inqireListAjax/", "#grid_list", "");
	}


	function initGrid() {
		var columnLayout = [
			{ dataField : "FORMAT_ID", headerText : "FORMAT_ID"},
			{ dataField : "FORMAT_CL_NM", headerText : "서식분류", cellMerge : true},
			{ dataField : "FORMAT_NM", headerText : "서식명", style : "left"},
			{ dataField : "FORMAT_DC", headerText : "서식설명", style : "left"},
			{ dataField : "FORMAT_CL_CD", headerText : "서식분류", style : "left", visible : false}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			// 셀 병합 실행
			enableCellMerge : true,
			cellMergePolicy : "withNull",
			showRowNumColumn : false,
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);

		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var items = event.item;

			if( "01337" == items.FORMAT_CL_CD){
				alert("통계부 서식은 사건통계메뉴에서 확인가능합니다");
				return false;
			}

			if(event.columnIndex > 1){
				fnReportPreview(items.FORMAT_ID);
			}
		});

		fnSearchGridData("/doc/inqireListAjax/", "#grid_list", "");
	}


</script>

<div class="com_box mb_30">
	<div class="tb_01_box">
		<div id="grid_list" class="gridResize" style="width:100%; height:750px; margin:0 auto;"></div>
	</div>
</div>
