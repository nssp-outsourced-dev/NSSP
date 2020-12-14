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
			{ dataField : "CONFMER_NM", headerText : "승인자", width : 90},
			{ dataField : "CF_CONFM_JOB", headerText : "승인업무", width : 180},
			{ dataField : "STTUS_NM", headerText : "상태", width : 90},
			{ dataField : "WRITNG_DT", headerText : "요청일시", width : 140},
			{ dataField : "UPDT_DT", headerText : "처리일시", width : 140}
		];

		var gridPros = {
			rowIdField : "CONFM_SN",
			selectionMode : "singleRow",
			fillColumnSizeMode : true,
			showRowNumColumn : false
		};
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);

		// 셀클릭 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellClick", function(event) {
			var item = event.item;
			if(item.CONFM_DC != null){
				$('#txtConfmDc').text(item.CONFM_DC);		
			}else{
				$('#txtConfmDc').text("");			
			}			
		});
		
		fnSearchGrid("/sanctn/historyAjax/", "frmList", "#grid_list");
	}

</script>

<body>

<!--팝업박스 -->
<form id="frmList" name="frmList" method="post">
	<input type="hidden" id="hidSanctnId" name="hidSanctnId" value="${hidSanctnId}">	
<div class="popup_body">

	<!--//버튼  -->	
	<!--테이블 시작 -->
	<div class="box_w2">
		<div class="box_w2_1c">
			<div class="com_box mb_10">  
				<div class="tb_01_box">
					<div id="grid_list" style="width:100%; height:350px; margin:0 auto;"></div>
				</div>
			</div> 
		</div>		
		<div class="box_w2_2c">
			<div class="com_box mb_10">
				<div class="tb_01_box">
					<textarea id="txtConfmDc" style="width:100%;height:350px;font-size:15px;" readonly></textarea>
				</div>
			</div>
		</div>
	</div>
</div>
</form>
 <!--팝업박스 -->	

</body>
</html>
