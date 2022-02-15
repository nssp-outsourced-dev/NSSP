<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<script type="text/javascript">
	var myGridID;

	$(function() {
		initGrid();
		fnDatePickerImg("searchDe1");
		fnDatePickerImg("searchDe2");
		
		/*  */
		$("#btnExportTo").on("click", function(){
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
					fileName : "사건대장출력이력_CSV"
				});
			}else{
				AUIGrid.exportToXlsx(myGridID, {
					fileName : "사건대장출력이력_EXCEL"
				});
			}
		});
	})

	function fnSearch() {
		fnMoveGridPage("/stats/outptHistListAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "RN", headerText : "순번", width : 30},
			{ dataField : "OUTPT_DT", headerText : "일시", width : 100},
			{ dataField : "USER_ID", headerText : "ID", width : 50},
			{ dataField : "USER_NM", headerText : "성명", width : 50},
			{ dataField : "MENU_NM", headerText : "출력 경로 메뉴명", width : 350},
			{ dataField : "OUTPT_IP", headerText : "IP", width : 50},
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
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);

		fnSearch();
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
		<div class="stitle">접속일별</div>
		<div class="tl_box">
			<div class="input_out w_120px fl">
				<input type="text" class="w_100p input_com_ca" id="searchDe1" name="searchDe1" readonly style="line-height: 40px;">
			</div>
			<div class="input_out fl"> ~ </div>
			<div class="input_out w_120px fl">
				<input type="text" class="w_100p input_com_ca" id="searchDe2" name="searchDe2" readonly>
			</div>
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

<!--------- 내용--------->
<div class="com_box ">
	<!-- 안내박스  -->
	<div class="title_s_st3 w_50p">
	</div>
	<!-- 안내박스  -->
	<!--버튼 -->
	<div class="right_btn fr mb_10">
		<a href="javascript:void(0);" id="btnExportTo" class="btn_st2 icon_n fl mr_m1">엑셀출력</a>
	</div>
</div>

<div class="com_box mb_30">
	<div class="tb_01_box">
		<div id="grid_list" class="gridResize" style="width:100%; height:580px; margin:0 auto;"></div>
		<div id="grid_list_paging" style="width:100%; height:40px;"></div>
	</div>
</div>
