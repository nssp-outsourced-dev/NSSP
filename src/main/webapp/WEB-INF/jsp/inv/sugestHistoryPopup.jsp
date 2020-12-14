<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">

var myGridID;
	
	$(document).ready(function(){
		initGrid();
	});


	function initGrid() {
		var columnLayout = [
			{ dataField : "SUGEST_NO", headerText : "지휘건의번호"},
			{ dataField : "CASE_NO", headerText : "CASE_NO", visible : false},
			{ dataField : "TRGTER_SN", headerText : "TRGTER_SN", visible : false},
			{ dataField : "ARRST_SN", headerText : "ARRST_SN", visible : false},
			{ dataField : "DOC_ID", headerText : "DOC_ID", visible : false},
			{ dataField : "SUGEST_TY_NM", headerText : "건의구분"},
			{ dataField : "SUGEST_DE", headerText : "건의일자", width : 130, dataType : "date", formatString : "yyyy-mm-dd"},
			{ dataField : "SUGEST_RESULT_NM", headerText : "건의결과" },
			{ dataField : "CMND_DE", headerText : "지휘일자", width : 130, dataType : "date", formatString : "yyyy-mm-dd"},
			{ dataField : "CMPTNC_EXMN_NM", headerText : "검찰청"},
			{ dataField : "CMND_PRSEC_NM", headerText : "지휘검사"}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,	
			rowIdField : "SUGEST_NO",
			selectionMode : "singleRow",
			fillColumnSizeMode : true,
			showRowNumColumn : false
		};
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);

		fnSearchGrid("/inv/sugestHistoryAjax/", "frmList", "#grid_list");
	}

</script>

<body>

<form id="frmList" name="frmList" method="post">
<input type="hidden" id="rcNo" name="rcNo" value="${rcNo}">	
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
