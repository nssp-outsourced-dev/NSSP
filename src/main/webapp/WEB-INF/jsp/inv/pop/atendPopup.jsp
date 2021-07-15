<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">
	$(document).ready(function(){
		initGrid();
	});
	function initGrid() {
		var trgterSeList 	 = [<c:forEach var="cd" items="${trgterSeList}" varStatus="status">{"cd":"${cd.cd}","cdNm":"${cd.cdNm}"},</c:forEach>];
		var atendNticeCdList = [<c:forEach var="cd" items="${atendNticeCd}" varStatus="status">{"cd":"${cd.cd}","cdNm":"${cd.cdNm}"},</c:forEach>];
		var columnLayout = [
			{ dataField : "grdDemandSn", 	headerText : "출석요구순번", width : 110},
			{ dataField : "grdTrgterSeCd",  headerText : "구분",
               	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
           			return gridComboLabel(trgterSeList, value)
           		}
           	},
			{ dataField : "grdTrgterNm", 		headerText : "대상자"},
			{ dataField : "grdAtendDemandDt", 	headerText : "출석요구일시", 	dataType : "date", formatString : "yyyy-mm-dd hh:MM"},
			{ dataField : "grdAtendNticeDe", 	headerText : "통지일자", 		dataType : "date", formatString : "yyyy-mm-dd"},
			{ dataField : "grdAtendNticeCd", 	headerText : "통지방법",		width : 80,
            	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
        			return gridComboLabel(atendNticeCdList, value)
        		}
            },
			{ dataField : "grdAtendNticeDe", 	headerText : "출석일자", dataType : "date", formatString : "yyyy-mm-dd"}
		];

		var gridPros = {
			rowIdField : "grdDemandSn",
			selectionMode : "singleRow",
			fillColumnSizeMode : true,
			showRowNumColumn : false,
			noDataMessage:"조회 목록이 없습니다.",
			headerHeight : 30,
			rowHeight: 30
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);
		fnSearchGrid("/inv/atendPopupLstAjax/", "frmList", "#grid_list");
	}
</script>
<body>
<form id="frmList" name="frmList" method="post">
<input type="hidden" id="hidRcNo" name="hidRcNo" value="${rcNo}">
<div class="com_box mb_20">
</div>
<div class="com_box mb_10">
	<div class="tb_01_box">
		<div id="grid_list" style="width:100%; height:450px; margin:0 auto;"></div>
	</div>
</div>
</form>
</body>
</html>
