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
			{ dataField : "ALOT_SE_NM", headerText : "배당구분", width : 100},
			{ dataField : "ALOT_DEPT_NM", headerText : "배당자 소속부서", width : 150},
			{ dataField : "ALOT_USER_NM", headerText : "배당자", width : 100},
			{ dataField : "WRITNG_DT", headerText : "배당일시", width : 100}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,	
			selectionMode : "singleRow",
			fillColumnSizeMode : true,
			showRowNumColumn : false
		};
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);

		fnSearchGrid("/alot/historyAjax/", "frmList", "#grid_list");
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
