<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">
	var myGridID;

	$(function() {
		$(document).ready(function(){
			fnDatePickerImg("calRcDtFrom", fnGetToday(0, -7), true);
			fnDatePickerImg("calRcDtTo", null, true);
			fnDatePickerImg("calPrsctDeFrom", fnGetToday(0, -7), true);
			fnDatePickerImg("calPrsctDeTo", null, true);
			initGrid();   // 그리드관련
			gridResize(); // 그리드관련
		});

		$('input[name="rdoDiv"]').change(function(){
			if($(this).val() == "R") {
				$("#schRcNo1").attr("readonly", false);
				$("#schRcNo2").attr("readonly", false);
				$("#calRcDtFrom").attr("readonly", false);
				$("#calRcDtTo").attr("readonly", false);

				$("#schCaseNo1").attr("readonly", true);
				$("#schCaseNo2").attr("readonly", true);
				$("#calPrsctDeFrom").attr("readonly", true);
				$("#calPrsctDeTo").attr("readonly", true);
			} else {
				$("#schRcNo1").attr("readonly", true);
				$("#schRcNo2").attr("readonly", true);
				$("#calRcDtFrom").attr("readonly", true);
				$("#calRcDtTo").attr("readonly", true);

				$("#schCaseNo1").attr("readonly", false);
				$("#schCaseNo2").attr("readonly", false);
				$("#calPrsctDeFrom").attr("readonly", false);
				$("#calPrsctDeTo").attr("readonly", false);
			}
		});
	});

	function initGrid() {
		var columnLayout = [{
				headerText : "접수번호",
				dataField : "RC_NO",
				width: "13%"
			}, {
				headerText : "사건번호",
				dataField : "CASE_NO",
				width: "13%"
			}, {
				headerText : "접수일자",
				dataField : "RC_DT",
				width: "12%"
			}, {
				headerText : "입건일자",
				dataField : "PRSCT_DE",
				width: "12%"
			}, {
				headerText : "위반사항",
				dataField : "VIOLT_NM",
				width: "25%"
			}, {
				headerText : "대상자",
				dataField : "TRGTER_NMS",
				width: "25%"
				/*
				align : 'left',
				textAlign : 'left',
				editRenderer : {
					//type : "InputEditRenderer",
					//showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
					textAlign : "left" // 인푸터 텍스트 왼쪽 정렬(기본값)
				}*/
			}
		];
		var gridPros = {
			showRowNumColumn : true,
			displayTreeOpen : true,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell : true,
			//noDataMessage : "조회 목록이 없습니다.",
			headerHeight : 30,
			rowHeight : 30
		};

		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
			var items = event.item;
			fnSetCaseInfo(items);
		});
	}

	function fnSearch() {
		if(!fnCompareDate($("#calRcDtFrom"), $("#calRcDtTo"))) return;
		if(!fnCompareDate($("#calPrsctDeFrom"), $("#calPrsctDeTo"))) return;

		// 내사건목록
		fnSearchGrid("/inv/myCaseListAjax/", "frmCaseList", myGridID);
	}

	function fnSetCaseInfo(oData) {
		if(fnIsEmpty(oData.CASE_NO)) {
			alert("접수사건은 입건 후에 통신사실확인 허가신청이 가능합니다.");
			return;
		}
		/*
		$("#txtRcNo", opener.document).val(oData.RC_NO);
		$("#txtCaseNo", opener.document).val(oData.CASE_NO);
		$("#txtVioltNm", opener.document).val(oData.VIOLT_NM);
		$("#txtCmptncExmnNm", opener.document).val(oData.CMPTNC_EXMN_NM);
		$("#txtAlotUserNm", opener.document).val(oData.ALOT_USER_NM);
		window.self.close();
		*/
		$("#hidRcNo").val(oData.RC_NO);
		$("#hidCaseNo").val(oData.CASE_NO);
		$("#hidVioltNm").val(oData.VIOLT_NM);
		$("#hidCmptncExmnNm").val(oData.CMPTNC_EXMN_NM);
		$("#hidAlotUserNm").val(oData.ALOT_USER_NM);
		parent.myCaseListPopup.hide();
	}

</script>

<body>
<form id="frmCaseList" name="frmCaseList" method="post">
<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">

<input type="hidden" id="hidRcNo" name="hidRcNo">
<input type="hidden" id="hidCaseNo" name="hidCaseNo">
<input type="hidden" id="hidVioltNm" name="hidVioltNm">
<input type="hidden" id="hidCmptncExmnNm" name="hidCmptncExmnNm">
<input type="hidden" id="hidAlotUserNm" name="hidAlotUserNm">

<!--팝업박스 -->
<div class="popup_body">
	<!-- 검색조건 -->
	<div class="search_box mb_20">
		<div class="inbox03 mb_10">
			<div class="tl_box3">
				<div class="tt3">접수번호</div>
				<div class="td6">
					<input type="text" id="schRcNo1" name="schRcNo1" maxlength="4" class="w_60p input_com_s" onkeyup="fnRemoveChar(event)">
					 -
					<input type="text" id="schRcNo2" name="schRcNo2" maxlength="6" class="w_80p input_com_s" onkeyup="fnRemoveChar(event)">
				</div>
			</div>
			<div class="tl_box2">
				<div class="tt2">접수일자</div>
				<div class="td4">
					<div class="input_out w_45p fl">
						<input type="text" id="calRcDtFrom" name="calRcDtFrom" class="w_100p input_com_s" maxlength="10" onkeyup="fnRemoveChar(event)" checkName="접수일자">
						<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div> ~
					<div class="input_out w_45p">
						<input type="text" id="calRcDtTo" name="calRcDtTo" class="w_100p input_com_s" maxlength="10" onkeyup="fnRemoveChar(event)" checkName="접수일자">
						<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div>
				</div>
			</div>
			<div class="tl_box3">
				<div class="tt3">사건번호  </div>
				<div class="td6">
					<input type="text" id="schCaseNo1" name="schCaseNo1" maxlength="4" class="w_60p input_com_s" onkeyup="fnRemoveChar(event)"> -
					<input type="text" id="schCaseNo2" name="schCaseNo2" maxlength="6" class="w_80p input_com_s" onkeyup="fnRemoveChar(event)">
				</div>
			</div>
			<div class="tl_box2">
				<div class="tt2">입건일자</div>
				<div class="td4">
					<div class="input_out w_45p fl">
						<input type="text" id="calPrsctDeFrom" name="calPrsctDeFrom" class="w_100p input_com_s"  maxlength="10" onkeyup="fnRemoveChar(event)" checkName="입건일자">
						<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div> ~
					<div class="input_out w_45p">
						<input type="text" id="calPrsctDeTo" name="calPrsctDeTo" class="w_100p input_com_s" maxlength="10" onkeyup="fnRemoveChar(event)" checkName="입건일자">
						<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div>
				</div>
			</div>
		</div>
		<input type="button" name="input_button" value="검색" class="btn_st2_2 icon_n" onclick="fnSearch();">
	</div>

	<div class="com_box">
		<div class="title_s_st2 w_50p fl"><img src="/img/title_icon1.png" alt=""/>사건 목록</div>
		<div class="fr t_right">
			<input type="button" id="btnNew" value="선택" class="btn_st4 icon_n" onclick="alert('선택');">
		</div>

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
