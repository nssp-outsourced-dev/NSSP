<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<style type="text/css">
.grdLft {
	text-align: left;
}
input[type=radio] {float: none;}
</style>
<script type="text/javascript">
$(function() {
	initGrid ();
	gridResize ();
	$("#txtUserNm").keyup(function(event) {
		if(event.keyCode == 13) {
			fnSearchPop();
		}
	});
	$("#txtUserNm").focus();
});
function initGrid () {
	var hidParam = $("#hidParamId").val();
	var cBoo = !fnIsEmpty(hidParam) && hidParam=='fnd'?false:true;
	var columnLayout = [
			{ dataField : "grdEsntlId",   	headerText : "사용자ID", width:150, visible : cBoo },
			{ dataField : "grdDeptNm",   	headerText : "부서명", width:200, style:"grdLft" },
            { dataField : "grdUserNm",     	headerText : "사용자명" },
            { dataField : "grdClsfNm",		headerText : "직급"},
            { dataField : "grdChrgJob",		headerText : "담당업무"},
            { dataField : "grdTelNo",    	headerText : "전화번호" },
            { dataField : "grdHpNo",    	headerText : "휴대전화번호" },
            { dataField : "grdResdncAddr", 	headerText : "주거지", visible : cBoo }
           	];
	var gridPros = {
		showRowNumColumn : false,
		selectionMode : "multipleCells",	// 선택모드 (기본값은 singleCell 임)
    	triggerSelectionChangeOnCell:true,
		//noDataMessage:"조회 목록이 없습니다.",
		showRowCheckColumn : cBoo,
		rowCheckToRadio: true,
		//fillColumnSizeMode:true,
		headerHeight : 30,
		rowHeight: 30
	};
	AUIGrid.create("#grid_wrap", columnLayout,  gridPros);
	AUIGrid.bind("#grid_wrap", "cellDoubleClick", function(event) {
		var items = event.item;
		$("#hidEsntlId").val(items.grdEsntlId);
		$("#hidUserNm").val(items.grdUserNm);
		$("#hidDeptNm").val(items.grdDeptNm);
		$("#hidClsfNm").val(items.grdClsfNm);
		$("#hidResdncAddr").val(items.grdResdncAddr);
		fnClose();
	});

	if(!cBoo) $("#btnAdd").hide();
}
function btnAddPop () {
	var activeItems = AUIGrid.getCheckedRowItems("#grid_wrap");
	if(activeItems.length < 1){
		alert('선택된 행이 없습니다.');
	}else if(confirm('선택한 사용자를 반영하시겠습니까?')){
		$("#hidEsntlId").val(activeItems[0].item.grdEsntlId);
		$("#hidUserNm").val(activeItems[0].item.grdUserNm);
		$("#hidDeptNm").val(activeItems[0].item.grdDeptNm);
		$("#hidClsfNm").val(activeItems[0].item.grdClsfNm);
		$("#hidResdncAddr").val(activeItems[0].item.grdResdncAddr);
		fnClose();
	}
}
function fnClose(){
	parent.userSelectPopup.hide();
}
function fnSearchPop () {
	fnMoveGridPage("/member/userFullListAjax/", "searchForm", "#grid_wrap", 1);
}
</script>
<body>
	<div class="popup_body">
		<form id="searchForm">
			<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
			<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
			<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">
			<input type="hidden" id="hidPageBlock" name="hidPageBlock" value="10">
			<input type="hidden" id="hidEsntlId" name="hidEsntlId" />
			<input type="hidden" id="hidUserNm" name="hidUserNm" />
			<input type="hidden" id="hidDeptNm" name="hidDeptNm"/>
			<input type="hidden" id="hidClsfNm" name="hidClsfNm" />
			<input type="hidden" id="hidResdncAddr" name="hidResdncAddr" />
			<input type="hidden" id="hidParamId" name="hidParamId" value="${pId}" />

			<div class="search_box mb_10">
				<div class="search_in" style="border-right:0px">
					<div class="stitle w_80px">사용자명</div>
					<input type="text" class="w_120px input_com" id="txtUserNm" name="txtUserNm">
				</div>
			</div>
			<div class="com_box ">
				<div class="title_s_st2 w_50p fl"><img src="/img/title_icon1.png" alt=""/>사용자목록</div>
				<div class="fr t_right">
					<input type="button" name="input_button" id="btnSearch" value="조회" onclick="fnSearchPop()" class="btn_st3 icon_n fl mr_m1">
					<input type="button" name="input_button" id="btnAdd" value="적용" onclick="btnAddPop()" 	class="btn_st4 icon_n" >
			    </div>
			</div>
			<div class="com_box mb_30">
				<div id="grid_wrap" class="gridResize tb_01_box" style="width: 100%; height: 350px; float: left; margin-bottom: 0px;"></div>
				<div id="grid_wrap_paging" class="" style="float: left; width: 100%;"></div>
			</div>
		</form>
	</div>
</body>
</html>