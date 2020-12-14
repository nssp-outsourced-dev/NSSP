<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/inc/header.jsp" />

<script type="text/javascript">
	$(function() {
		initGrid ();
		$("#hidSearchText").focus();
	});

	function initGrid () {
		var columnLayout = [
				{ dataField : "grdRcSeNm",   	headerText : "사건구분",  	width : 70 },
				{ dataField : "grdDsCaseNo",    headerText : "사건번호", 	width : 100,
					renderer : {type : "TemplateRenderer"},
					labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
						return fnChangeNo (value);
					}
				},
				{ dataField : "grdDeptNm",   	headerText : "담당자부서",  width : 190 },
				{ dataField : "grdRspofcNm",   	headerText : "담당자직책", 	width : 80 },
				{ dataField : "grdChargerNm",   headerText : "담당자",   	width : 80 },
				{ dataField : "grdTelNo",   	headerText : "담당자연락처"  },
				{ dataField : "grdHpNo",   		headerText : "담당자휴대전화"	},
				{ dataField : "grdProgrsSttusNm",headerText : "수사상태",	width : 120 },
   				{ dataField : "grdVioltNm",		headerText : "위반죄명", 	style:'tbLft' },
                ];
		var gridPros = {
			rowNumHeaderText:"순번",
			selectionMode : "singleCell",	// 선택모드 (기본값은 singleCell 임)
			noDataMessage:"사건이 확인되지 않습니다.",
			//showAutoNoDataMessage:false,
			fillColumnSizeMode:true,
			headerHeight : 40,
			rowHeight: 40
		};
		AUIGrid.create("#grid_list_wrap",columnLayout,gridPros);
		if(!fnIsEmpty($("#hidSearchText").val())) {
			fnSearchGrid ("/ccc/caseInfoListAjax/", "caseInfoFrm", "#grid_list_wrap");
		}
	}

</script>

<!--팝업박스 -->
<div class="popup_body">
	<div class="tabnbtn_box2">
		<div class="search_box">
			<div class="search_in" style="border-right:0px">
				<div class="stitle w_80px">검색정보</div>
				<input type="text" class="w_150px input_com" value="${searchText}" disabled="disabled">
			</div>
		</div>
		<!--본문시작 -->
		<form id="caseInfoFrm" method="post">
			<input type="hidden" id="hidSearchType" 	name="hidSearchType" 	value="${searchType}">
			<input type="hidden"	 id="hidSearchText" 	name="hidSearchText" 	value="${searchText}">
		</form>

		<!-- grid -->
		<div id="grid_list_wrap" class="gridResize tb_01_box" style="width: 100%; height: 330px;"></div>
	</div>
</div>