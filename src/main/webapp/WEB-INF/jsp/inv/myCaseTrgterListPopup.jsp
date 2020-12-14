<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">
	var myGridID;

	$(function() {
		$(document).ready(function(){
			initGrid();   // 그리드관련
			gridResize(); // 그리드관련
		});
	});

	function initGrid() {
		var columnLayout = [{
				headerText : "구분",
				dataField : "TRGTER_SE_CD_NM",
				width: "10%"
			}, {
				headerText : "성명",
				dataField : "TRGTER_NM",
				width: "10%"
			}, {
				headerText : "주민번호",
				dataField : "TRGTER_RRN",
				width: "15%"
			}, {
				headerText : "자택 전화",
				dataField : "TRGTER_TEL",
				width: "12%"
			}, {
				headerText : "휴대 전화",
				dataField : "TRGTER_HP_NO",
				width: "13%"
			}, {
				headerText : "우편번호",
				dataField : "ADRES_ZIP",
				width: "10%"
			}, {
				headerText : "주소",
				dataField : "ADRES_ADDR",
				width: "30%"
			}
		];
		var gridPros = {
			showRowNumColumn : true,
			displayTreeOpen : true,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell : true,
			//noDataMessage : "조회 목록이 없습니다.",
			headerHeight : 30,
			rowHeight: 30		
		};

		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
			var items = event.item;
			fnSetTrgterInfo(items);
		});
		
		// 사건대상자 목록
		fnSearchGrid("/inv/ccdrcTrgterListAjax/", "form_detail", myGridID);
	}

	function fnSetTrgterInfo(oData) {
		/*
		$("#txtTrgterSn", opener.document).val(oData.TRGTER_SN);
		$("#txtTrgterNm", opener.document).val(oData.TRGTER_NM);
		$("#txtTrgterRrn", opener.document).val(oData.TRGTER_RRN);
		$("#txtAdresAddr", opener.document).val(oData.ADRES_ADDR);
		$("#txtOccpCdNm", opener.document).val(oData.OCCP_CD_NM);
		window.self.close();
		*/
		$("#hidTrgterSn").val(oData.TRGTER_SN);
		$("#hidTrgterNm").val(oData.TRGTER_NM);
		$("#hidTrgterRrn").val(oData.TRGTER_RRN);
		$("#hidAdresAddr").val(oData.ADRES_ADDR);
		$("#hidOccpCdNm").val(oData.OCCP_CD_NM);
		parent.myCaseTrgterListPopup.hide();
	}
	

</script>

<body>
<form id="form_detail" name="form_detail" method="post">
<input type="hidden" id="hidCaseNo" name="hidCaseNo" value="${hidCaseNo}">
<input type="hidden" id="hidTrgterSn" name="hidTrgterSn">
<input type="hidden" id="hidTrgterNm" name="hidTrgterNm">
<input type="hidden" id="hidTrgterRrn" name="hidTrgterRrn">
<input type="hidden" id="hidAdresAddr" name="hidAdresAddr">
<input type="hidden" id="hidOccpCdNm" name="hidOccpCdNm">

<!--팝업박스 -->
<div class="popup_body">
	<!--버튼 -->
	<!-- <div class="com_box  t_right">
		<div class="btn_box">
			<input type="hidden" id="hidCdNm" name="hidCdNm" maxlength="50" size="50" onkeypress="press(event);">
			<input type="button" name="input_button" value="검색"  class="btn_st3 icon_n fl mr_5" onclick="fnSearch();">
			<input type="button" name="input_button" value="선택 "  class="btn_st4 icon_n fl " onclick="fnSelect();">
		</div>
	</div> -->
	<!--//버튼  -->
	<div class="com_box ">
		<div class="title_s_st2 w_50p fl"><img src="/img/title_icon1.png" alt=""/>대상자 목록</div>
	</div>
	<!--테이블 시작 -->
	<div class="com_box mb_30">  
		<div class="tb_01_box">
			<div id="grid_list" class="gridResize" style="width:100%; height:300px; margin:0 auto;"></div>
		</div>
	</div>

</div>
<!--팝업박스 -->
</form>
</body>
</html>
