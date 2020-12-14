<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<style type="text/css">
.grdLft {
	text-align: left;
}
#bodyMenu {
	position:absolute;
	display:none;
	z-index:100;
}
</style>
<script type="text/javascript">
var nowBodyMenuVisible = false;
$(function() {
	initGrid ();
	gridResize ();
	$(document).on("click", function(event) {
		if($(event.target).attr("aria-haspopup")) { // 서브 메뉴 아이템 클릭 한 경우
			return;
		}
		hideContextMenu();
	});
});
function initGrid () {
	var columnLayout = [
			{ dataField : "grdFileId",   	headerText : "파일ID", 	visible:false },
			{ dataField : "grdFormatId",   	headerText : "서식ID", 	visible:false },
			{ dataField : "grdFormatNm",   	headerText : "서식명", 	width:150},
            { dataField : "grdFileSn",     	headerText : "SN", 		visible:false },
            { dataField : "grdFileSort",    headerText : "순번", 		width:60 },
            { dataField : "grdFileNm",		headerText : "파일명", 	style:"grdLft"},
            { dataField : "grdSysFilePath", headerText : "파일PATH", 	visible:false },
            { dataField : "grdWritngNm",    headerText : "등록자", 	width:60 },
            { dataField : "grdWritngDt", 	headerText : "등록일시", 	width:120, dataType : "date", formatString : "yyyy-mm-dd HH:MM"}
           	];
	var gridPros = {
		showRowNumColumn : false,
		selectionMode : "singleCell",	// 선택모드 (기본값은 singleCell 임)
    	triggerSelectionChangeOnCell:true,
		//noDataMessage:"조회 목록이 없습니다.",
		//showRowCheckColumn : true,
		//rowCheckToRadio: true,
		fillColumnSizeMode:true,
		headerHeight : 30,
		rowHeight: 30,
		useContextMenu : true,
	};
	AUIGrid.create("#grid_wrap",  columnLayout,  gridPros);
	AUIGrid.bind("#grid_wrap", "contextMenu", auiGridContextEventHandler);
	AUIGrid.bind("#grid_wrap", "cellDoubleClick", function(event) {
		var items = event.item;
		fnDocFileDownload(items.grdFileId, items.grdFileSn);
	});

	fnSearchGrid("/doc/docFileListAjax/", "docFileForm", "#grid_wrap");
}
//파일 저장
function fnInsertFile(){
	var strFi = $("#selReportAdd").val();
	if(fnIsEmpty(strFi) || strFi.length != 22){
		alert("문서서식을 선택하세요.");
		return;
	}
	$("#hidFormatId").val(strFi.substr(0,20));
	var form = $("form[id=docFileForm]");
	form.attr({"method":"post","action":"<c:url value='/doc/uploadFile/'/>"});
	form.submit();
}
function auiGridContextEventHandler(event) {
	if(event.target == "body") { // 바디 컨텍스트
		currentRowIndex = event.rowIndex;

		// 사용자가 만든 컨텍스트 메뉴 보이게 하기
		if(event.item.grdFileSort > 0) {
			nowBodyMenuVisible = true;
			// 바디 컨텍스트에서 사용할 메뉴 위젯 구성
			$("#bodyMenu").menu({
				select: bodyMenuSelectHandler
			});
			$("#bodyMenu").css({
				left : event.pageX,
				top : parseInt(event.pageY)-80
			}).show();
		}else{
			hideContextMenu();
		}
		return false; // 기본으로 제공되는 컨텍스트 사용 안함.
	}
}
function bodyMenuSelectHandler(event, ui) {
	var selectedId = ui.item.prop("id");
	var selectedItems = AUIGrid.getSelectedItems("#grid_wrap");
	if(selectedItems.length < 1) {
		alert("선택된 내용이 확인되지 않습니다.");
		return;
	}
	var items = selectedItems[0].item;
	switch(selectedId) {
	case "cm1":
		fnDocFileDownload(items.grdFileId, items.grdFileSn);
		break;
	case "cm2":
		if(confirm(items.grdFileNm + "\n파일을 삭제하시겠습니까?")) {
			fnDocFileDelete(items.grdFileId, items.grdFileSn);
		}
		break;
	}
}
function fnDocFileDownload(sFileID, sFileSn){
	location.href = "<c:url value='/file/getFileBinary/'/>?file_id=" + sFileID + "&file_sn=" + sFileSn;
}
function fnDocFileDelete(sFileID, sFileSn){
	var iUrl = '<c:url value='/file/deleteAjax/'/>';
		var queryString =  "file_id=" + sFileID + "&file_sn=" + sFileSn;
		var processAfterGet = function(data) {
		if(data.result == "1"){
			alert("삭제되었습니다.");
			location.reload();
		}else{
			alert("삭제 진행중 오류가 발생하였습니다.");
		}
    };
	Ajax.getJson(iUrl, queryString, processAfterGet);
}
function hideContextMenu() {
	if(nowBodyMenuVisible) { // 메뉴 감추기
		$("#bodyMenu").menu("destroy");
		$("#bodyMenu").hide();
		nowBodyMenuVisible = false;
	}
}
</script>
<body>
	<div id="bodyMenu" class="aui-grid-context-popup-layer">
		<span class="aui-grid-context-item" id="cm1">파일다운로드</span>
		<span class="aui-grid-context-item" id="cm2">파일삭제</span>
	</div>
	<div class="popup_body">
		<form id="docFileForm" method="post" enctype="multipart/form-data">
			<input type="hidden" id="hidFileId" name="hidFileId" value="${file_id}">
			<input type="hidden" id="hidFormatClCd" name="hidFormatClCd" value="${format_cl_cd}">
			<input type="hidden" id="hidFormatId" name="hidFormatId">

			<div class="search_box mb_10">
				<div class="mb_10 mt_10 ml_10">
					<div class="right_btn fr mb_10" style="width : 100%">
						<select name="selReportAdd" id="selReportAdd" class="w_200px h_32px mr_5" style="float: left">
							<option value="">== 문서를 선택하세요 ==</option>
							<c:forEach var="result" items="${formatClList}">
								<c:set var="setfid" value="${result.FORMAT_ID}^${result.INPUT_YN}" />
								<option value="${setfid}" <c:if test="${setfid eq format_Id}">selected</c:if>>${result.FORMAT_DC}</option> <!-- ${result.FORMAT_NM} -->
							</c:forEach>
						</select>
						<div id="fileList" class="file fl mr_5"><input type="file" multiple="multiple" name="txtFiles" style="height: 32px; apperance:none; -webkit-apperance: none; "></div>
						<a class="btn_st2 icon_n fl mr_m1" onclick="fnInsertFile();  return false" href="#">업로드</a>						
					</div>
				</div>
			</div>
			<div class="com_box mb_30">
				<div id="grid_wrap" class="gridResize tb_01_box" style="width: 100%; height: 250px; float: left; margin-bottom: 0px;"></div>
				<div id="grid_wrap_paging" class="" style="float: left; width: 100%;"></div>
			</div>
		</form>
	</div>
</body>
</html>