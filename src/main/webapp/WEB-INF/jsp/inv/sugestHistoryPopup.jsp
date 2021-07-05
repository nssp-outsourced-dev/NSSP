<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">
	var myGridID;
	
	$(document).ready(function(){
		initGrid();
		
		/* 
			2021.06.25
			coded by dgkim
			사건종결 후에도 지휘건의 검사명 수정가능하게끔 조치
		*/
		$("#saveBtn").on("click", function(){
			var editedRowItems = AUIGrid.getEditedRowItems( "#grid_list" );
			console.log(editedRowItems);
			
			if( editedRowItems.length == 0 ){
				alert("수정한 자료가 없습니다.");
				return;
			}
			
			var data = fnAjaxAction( "/inv/updateCmndPrsecNmAjax/", JSON.stringify({ sList:editedRowItems }) );
			if( data.result == "1" ){
				alert("저장 되었습니다.");
				fnSearchGrid("/inv/sugestHistoryAjax/", "frmList", "#grid_list");
			} else {
				alert("저장중 오류가 발생했습니다.");
			}
		});
	});


	function initGrid() {
		var columnLayout = [
			{ dataField : "SUGEST_NO", headerText : "지휘건의번호", editable : false},
			{ dataField : "CASE_NO", headerText : "CASE_NO", visible : false, editable : false},
			{ dataField : "TRGTER_SN", headerText : "TRGTER_SN", visible : false, editable : false},
			{ dataField : "ARRST_SN", headerText : "ARRST_SN", visible : false, editable : false},
			{ dataField : "DOC_ID", headerText : "DOC_ID", visible : false, editable : false},
			{ dataField : "SUGEST_TY_NM", headerText : "건의구분", editable : false},
			{ dataField : "SUGEST_DE", headerText : "건의일자", width : 130, dataType : "date", formatString : "yyyy-mm-dd", editable : false},
			{ dataField : "SUGEST_RESULT_NM", headerText : "건의결과", editable : false},
			{ dataField : "CMND_DE", headerText : "지휘일자", width : 130, dataType : "date", formatString : "yyyy-mm-dd", editable : false},
			{ dataField : "CMPTNC_EXMN_NM", headerText : "검찰청", editable : false},
			{ dataField : "CMND_PRSEC_NM", headerText : "지휘검사<span class='point'><img src='/img/icon_dot.png'/></span>", editable : true}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,	
			rowIdField : "SUGEST_NO",
			selectionMode : "singleRow",
			fillColumnSizeMode : true,
			showRowNumColumn : false,
			editBeginMode : "click",
			editable : true,
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
	<div class="com_box ">
		<!-- 안내박스  -->
		<div class="title_s_st3 w_50p">
		</div>
		<!-- 안내박스  -->
		<!--버튼 -->
		<div class="right_btn fr mb_10">
			<a href="javascript:void(0);" class="btn_st2 icon_n fl mr_m1" id="saveBtn">저장</a>
		</div>
	</div>
	
	<div class="tb_01_box">
		<div id="grid_list" style="width:100%; height:450px; margin:0 auto;"></div>
	</div>
</div> 
</form>	

</body>
</html>
