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
		var zrlongSeLst = [<c:forEach var="cd" items="${zrlongSeLst}" varStatus="status">{"cd":"${cd.cd}","cdNm":"${cd.cdNm}"},</c:forEach>];
		var arsttCdLst  = [<c:forEach var="cd" items="${arsttCdLst}" varStatus="status">{"cd":"${cd.cd}","cdNm":"${cd.cdNm}"},</c:forEach>];
		var excutSeLst  = [{"cd":"Y","cdNm":"집행"},{"cd":"N","cdNm":"집행불능"}];
		var reqstResultLst = [{"cd":"Y","cdNm":"가"},{"cd":"N","cdNm":"부"}];
		var columnLayout = [
			{ dataField : "grdZrlongReqstNo", 	headerText : "영장신청번호", width : 100},
			{ dataField : "grdZrlongNo", 		headerText : "영장번호", width : 90},
			{ dataField : "grdZrlongSeCd",  	headerText : "영장구분", width : 90,
               	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
           			return gridComboLabel(zrlongSeLst, value)
           		}
           	},
           	{ dataField : "grdArsttCd",  		headerText : "구속영장구분",
               	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
           			return gridComboLabel(arsttCdLst, value)
           		}
           	},
			{ dataField : "grdTrgterNm", 		headerText : "대상자명"},
			{ dataField : "grdPrsctDe", 		headerText : "입건일자", 		dataType : "date", formatString : "yyyy-mm-dd"},
			{ dataField : "grdReqstDe", 		headerText : "영장신청일", 	dataType : "date", formatString : "yyyy-mm-dd hh:MM"},
			{ dataField : "grdReqstResultYn", 	headerText : "신청결과", 		width : 80,
             	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
        			return gridComboLabel(reqstResultLst, value)
        		}
            },
			{ dataField : "grdIsueDt", 		headerText : "발부일시", 	dataType : "date", formatString : "yyyy-mm-dd hh:MM"},
			{ dataField : "grdExcutSeCd", 	headerText : "집행구분",	width : 80,
            	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
        			return gridComboLabel(excutSeLst, value)
        		}
            },
            { dataField : "grdExcutDt", 	headerText : "집행일시", dataType : "date", formatString : "yyyy-mm-dd hh:MM"},
		];
		var gridPros = {
			rowIdField : "grdZrlongReqstNo",
			selectionMode : "singleRow",
			fillColumnSizeMode : true,
			showRowNumColumn : false,
			noDataMessage:"조회 목록이 없습니다.",
			headerHeight : 30,
			rowHeight: 30
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);
		fnSearchGrid("/inv/zrlongPopupLstAjax/", "frmList", "#grid_list");
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
