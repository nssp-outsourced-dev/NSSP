<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/inc/header.jsp"/>
<style type="text/css">
.tbLft {
	text-align: left;
}
</style>
<script type="text/javascript">

	var myGridID;
	$(document).ready(function(){
		initGrid();
	});

	function initGrid() {
		var columnLayout = [
			{ dataField : "FORMAT_ID", headerText : "FORMAT_ID", width : 0, visible : false},
			{ dataField : "FORMAT_CL_NM", headerText : "서식분류", cellMerge : true, visible : false},
			{ dataField : "FORMAT_NM", headerText : "서식명"},
			{ dataField : "DOC_SORT", headerText : "순번", width : 60},
			{ dataField : "DOC_YN", headerText : "DOC_YN", width : 0, visible : false},
			{
				dataField : "INPUT_YN",
				headerText : "입력폼",
				visible : false,
				width : 60,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var template = "";
					if(value == "Y"){
						template += "O";
					}else{
						template += "X";
					}
					return template;
				}
			},
			{
				dataField : "JSON_YN",
				headerText : "작성여부",
				width : 100,
				renderer : {type : "TemplateRenderer"},
				visible : false,
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var template = "";
					if(item.CHK_TYPE == "FILE") {
						template = "첨부파일";
					} else {
						if(value == "Y"){
							template += "작성완료";
						}else{
							template += "미작성";
						}
					}
					return template;
				}
			},
			{
				dataField : "FILE_NM",
				headerText : "작성여부",
				width : 100,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var template = "";

					if( value != null && value != ""){
						template += "작성완료";
					}else{
						template += "미작성";
					}
					return template;
				}
			},
			{ dataField : "DOC_ID", headerText : "DOC_ID", width : 0, visible : false},
			{ dataField : "PBLICTE_SN", headerText : "PBLICTE_SN", width : 0, visible : false},
			{ dataField : "DOC_NO", headerText : "문서번호", width : 0, visible : false},
			{ dataField : "WRITNG_DEPT_NM", headerText : "소속", width : 0},
			{ dataField : "WRITNG_NM", headerText : "작성자", width : 0, visible : false},
			{ dataField : "UPDT_DT", headerText : "작성일", width : 100},
			{ dataField : "CHK_TYPE", headerText : "저장구분", width : 100, style:'tbLft',
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var template = value + (fnIsEmpty(item.DOC_CL_CD)?"":" ["+item.DOC_CL_CD+"]");
					return template;
				}
			}
		];

<c:choose>
	<c:when test="${owner eq 'Y'}">
		var myContextMenus = [ {
			label : "문서출력", callback : contextItemHandler
		}, {
			label : "문서입력", callback : contextItemHandler
		}, {
			label : "문서삭제", callback : contextItemHandler
		}];
	</c:when>
	<c:otherwise>
		var myContextMenus = [ {
			label : "문서출력", callback : contextItemHandler
		}];
	</c:otherwise>
</c:choose>

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			// 셀 병합 실행
			enableCellMerge : true,
			cellMergePolicy : "withNull",
			fillColumnSizeMode : true,
			showRowNumColumn : false,
			useContextMenu : true,
			contextMenuItems : myContextMenus,
			enableRightDownFocus : true // 기본값 : false
		};
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);

		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var items = event.item;
			if(items.CHK_TYPE == "FILE") {
				fnDocFileDownload(items.DOC_ID, items.PBLICTE_SN);
			} else {
				<c:choose>
					<c:when test="${owner eq 'Y'}">
						if(items.DOC_YN == "Y"){
							if(items.JSON_YN == "N" && items.INPUT_YN == "Y"){
								//parent.fnReportInputIfr("${ifr_id}",items.DOC_ID, items.PBLICTE_SN);
								parent.fnHwpctrl (items.DOC_ID, items.PBLICTE_SN, items.FORMAT_NM, "${ifr_id}");
							}else{
								//parent.fnReportViewIfr("${ifr_id}",items.DOC_ID, items.PBLICTE_SN);
								parent.fnHwpctrl (items.DOC_ID, items.PBLICTE_SN, items.FORMAT_NM, "${ifr_id}");
							}
						}else{
							fnReportMake(items.FORMAT_ID, items.INPUT_YN);
						}
					</c:when>
					<c:otherwise>
						parent.fnReportViewIfr("${ifr_id}",items.DOC_ID, items.PBLICTE_SN);
					</c:otherwise>
				</c:choose>
			}
		});
		AUIGrid.bind(myGridID, "ready", function(event) {
			<c:if test="${fn:length(ifr_id) > 0}">
			    var iframeHeight = parent.document.getElementById("${ifr_id}").height;
			    var gHeight = iframeHeight.replace(/\px/i,'');
	    		gHeight -= 50;
			    fnResizeGrid("100%", gHeight);
			</c:if>
		});
		fnSearch();
	}

	function fnResizeGrid(w, h) {
		if(myGridID){
			AUIGrid.resize(myGridID, w, h);
		}
	}

	function fnSearch(){
	<c:choose>
		<c:when test="${owner eq 'Y'}">
			fnSearchGrid("/doc/reportListOwnerAjax/", "frmList", "#grid_list");
		</c:when>
		<c:otherwise>
			fnSearchGrid("/doc/reportListAjax/", "frmList", "#grid_list");
		</c:otherwise>
	</c:choose>
	}

	// 컨텍스트 메뉴 아이템 핸들러
	function contextItemHandler(event) {
		var items = event.item;
		switch(event.contextIndex) {
		case 0:
			if(items.DOC_YN == "Y"){
				if(items.CHK_TYPE == "FILE") {
					fnDocFileDownload(items.DOC_ID, items.PBLICTE_SN);
				} else {
					//parent.fnReportViewIfr("${ifr_id}",items.DOC_ID, items.PBLICTE_SN);
					parent.fnHwpctrl (items.DOC_ID, items.PBLICTE_SN, items.FORMAT_NM, "${ifr_id}");
				}
			}else{
				alert("문서가 생성되지 않았습니다.");
			}
			break;
		case 1:
			if(items.DOC_YN == "Y"){
				if(items.INPUT_YN == "Y"){
					//parent.fnReportInputIfr("${ifr_id}",items.DOC_ID, items.PBLICTE_SN);
					parent.fnHwpctrl (items.DOC_ID, items.PBLICTE_SN, items.FORMAT_NM, "${ifr_id}");
				}else{
					alert("해당 서식은 입력폼을 지원하지 않습니다.");
				}
			}else{
				alert("문서가 생성되지 않았습니다.");
			}
			break;
		case 2:
			if(items.DOC_YN == "Y"){
				if(items.CHK_TYPE == "FILE") {
					if(confirm(items.FORMAT_NM + "\n파일을 삭제하시겠습니까?")) {
						fnDocFileDelete(items.DOC_ID, items.PBLICTE_SN);
					}
				} else {
					if(confirm(items.FORMAT_NM+"("+items.DOC_NO+")를 삭제하시겠습니까?")){
						var iUrl = '<c:url value='/doc/reportDelAjax/'/>';
						var queryString =  "docId=" + items.DOC_ID + "&pblicteSn=" + items.PBLICTE_SN;
						var processAfterGet = function(data) {
							if(data.result == "1"){
								fnSearch();
							}else{
								alert("삭제 진행중 오류가 발생하였습니다.");
							}
						};
						Ajax.getJson(iUrl, queryString, processAfterGet);
					}
				}
			}else{
				alert("문서가 생성되지 않았습니다.");
			}
			break;
		}
	}

	function fnReportAdd(){
		var formatId = $("#selReportAdd").val();
		if(formatId.length != 22){
			alert("문서서식을 선택하세요.");
			return;
		}
		var temp = formatId.split("^");
		fnReportMake(temp[0], temp[1]);
	}

	function fnReportMake(formatId, inputYn){
		if($('#docId').val().length != 20){
			alert("처리할 사건을 선택하세요.");
			return;
		}

		$('#formatId').val(formatId);
		var iUrl = '<c:url value='/doc/reportAddAjax/'/>';
 		var queryString =  $('#frmList').serialize();
 		var processAfterGet = function(data) {
			if(data.result == "1"){
				fnSearch();
				if(inputYn == "Y"){
					//parent.fnReportInputIfr("${ifr_id}",data.doc_id, data.pblicte_sn);
					parent.fnHwpctrl (data.doc_id, data.pblicte_sn, data.format_nm,"${ifr_id}");
				}else{
					//parent.fnReportViewIfr("${ifr_id}",data.doc_id, data.pblicte_sn);
					parent.fnHwpctrl (data.doc_id, data.pblicte_sn, data.format_nm,"${ifr_id}");
				}
			}else{
				alert("진행중 오류가 발생하였습니다.");
			}
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}
	function fnFilePop () {
		if($('#docId').val().length != 20){
			alert("처리할 사건을 선택하세요.");
			return;
		}
		var formatId = $("#selReportAdd").val();
		var docFpopup = parent.btnDocFilePop("${format_cl_cd}","${file_id}", formatId);
		docFpopup.controls.onclick=function(){
			fnSearch ();
			parent.dhtmlmodal.close(this._parent, true);
		}
	}
	/*첨부파일 다운로드*/
	function fnDocFileDownload(sFileID, sFileSn){
		parent.location.href = "<c:url value='/file/getFileBinary/'/>?file_id=" + sFileID + "&file_sn=" + sFileSn;
	}
	/*첨부파일 삭제*/
	function fnDocFileDelete(sFileID, sFileSn){
		var iUrl = '<c:url value='/file/deleteAjax/'/>';
			var queryString =  "file_id=" + sFileID + "&file_sn=" + sFileSn;
			var processAfterGet = function(data) {
			if(data.result == "1"){
				alert("삭제되었습니다.");
				fnSearch();
			}else{
				alert("삭제 진행중 오류가 발생하였습니다.");
			}
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}
</script>
<body>
<!--팝업박스 -->
<form id="frmList" name="frmList" method="post" action="<c:url value='/doc/detail/'/>">
<input type="hidden" id="docId" name="docId" value="${doc_id}" />
<input type="hidden" id="formatClCd" name="formatClCd" value="${format_cl_cd}" />
<input type="hidden" id="inputParam" name="inputParam" value="${input_param}" />
<input type="hidden" id="formatId" name="formatId">
<input type="hidden" id="fileId" name="fileId" value="${file_id}" />
</form>


<!--버튼 -->
<div class="com_box ">
	<div class="title_s_st2 w_100px fl"><img src="/img/title_icon1.png" alt=""/>작성문서목록</div>
	<div class="fr mb_10" style="width: calc(100% - 100px)">
		<c:choose>
			<c:when test="${owner eq 'Y'}">
				<div class="right_btn fr" style="width : 100%">
					<a href="javascript:fnFilePop()" class="btn_st2 icon_n fr mr_m1">파일관리</a>
					<a href="javascript:fnReportAdd()" class="btn_st2 icon_n fr mr_m1">추가</a>
					<select name="selReportAdd" id="selReportAdd" class="w_200px h_32px" style="float: right;">
						<option value="">== 문서를 선택하세요 ==</option>
						<c:forEach var="result" items="${formatClList}">
							<option value="${result.FORMAT_ID}^${result.INPUT_YN}">${result.FORMAT_NM}</option>
						</c:forEach>
					</select>
				</div>
			</c:when>
			<c:otherwise>
			</c:otherwise>
		</c:choose>
	</div>
</div>
<!--//버튼 -->
<!--테이블 시작 -->
<div class="com_box">
	<div class="tb_01_box">
		<div id="grid_list" class="gridResize" style="width:100%; height:100%; margin:0 auto;"></div>
	</div>
</div>

</body>
</html>