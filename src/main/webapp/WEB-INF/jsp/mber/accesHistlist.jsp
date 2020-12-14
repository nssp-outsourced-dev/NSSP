<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<script type="text/javascript">
	$(function() {
		$(document).ready(function(){
			initGrid();
		});

	})


	function fnSearch() {
		fnMoveGridPage("/member/accesHistlistAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "RN", headerText : "순번", width : 50},
			{ dataField : "ESNTL_ID", headerText : "ESNTL_ID", width : 0, visible : false},
			{ dataField : "ACCES_DE", headerText : "ACCES_DE", width : 0, visible : false},
			{ dataField : "ACCES_SN", headerText : "ACCES_SN", width : 0, visible : false},
			{ dataField : "USER_ID", headerText : "ID", width : 100},
			{ dataField : "USER_NM", headerText : "성명", width : 80},
			{ dataField : "DEPT_NM", headerText : "부서", width : 200},
			{ dataField : "MENU_NM", headerText : "접속메뉴", width : 150},
			{ dataField : "ACCES_URL", headerText : "접속URL", width : 200},
			{ dataField : "ACCES_IP", headerText : "접속IP", width : 100},
			{ dataField : "ACCES_DT", headerText : "접속일시", width : 120}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true,
			useGroupingPanel : true,
			showRowNumColumn : false,
			displayTreeOpen : true,
			groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);

		fnMoveGridPage("/member/accesHistlistAjax/", "frmList", "#grid_list", 1);
	}

</script>

<form id="frmList" name="frmList" method="post">
<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">
<!--검색박스 -->
<div class="search_box mb_30">
	<div class="inbox08">
		<div class="stitle">ID</div>
		<div class="tl_box">
			<input type="text" id="searchUserID" name="searchUserID" maxlength="20" class="w_100px input_com_s ">
		</div>
	</div>
	<div class="inbox08">
		<div class="stitle">사용자명</div>
		<div class="tl_box">
			<input type="text" id="searchUserNm" name="searchUserNm" maxlength="20" class="w_100px input_com_s ">
		</div>
	</div>
	<div class="inbox08">
		<div class="stitle">IP</div>
		<div class="tl_box">
			<input type="text" id="searchAccesIp" name="searchAccesIp" maxlength="20" class="w_200px input_com_s ">
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
	</div>
	<div class="go_search2" onclick="fnSearch();">검색</div>
</div>
</form>

<div class="com_box mb_30">
	<div class="tb_01_box">
		<div id="grid_list" class="gridResize" style="width:100%; height:580px; margin:0 auto;"></div>
		<div id="grid_list_paging" style="width:100%; height:40px;"></div>
	</div>
</div>

