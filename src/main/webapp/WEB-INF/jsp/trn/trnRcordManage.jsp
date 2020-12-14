<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<style type="text/css">
.grid_td_left {text-align:left}
</style>
<script type="text/javascript">
	var gridRcordList;
	var sFormatId = "00452";  //송치양식
	
	$(function() {
		$(document).ready(function(){
			fnDatePickerImg("calRcordDe", null, false);
			fnTopLst();
			initGrid();   // 그리드관련
			gridResize(); // 그리드관련
			fnReportList("ifrReport", "", sFormatId, ""); // 작성문서목록 //'P_RC_NO=2018000001&P_TRGTER_SN=13'
			$("#schCaseNo1").focus();
		});
	
		$("#schCaseNo1").keyup(function(event) {
			fnRemoveChar(event);
			if($(this).val().length == 4) {
				$("#schCaseNo2").focus();
			}
		});
	
		$("#schCaseNo2").keyup(function(event) {
			fnRemoveChar(event);
			if(event.keyCode == 13) {
				fnSetNo($(this));
				fnSearch();
			}
		});
	
		$("#schTrnNo1").keyup(function(event) {
			fnRemoveChar(event);
			if($(this).val().length == 4) {
				$("#schTrnNo2").focus();
			}
		});
	
		$("#schTrnNo2").keyup(function(event) {
			fnRemoveChar(event);
			if(event.keyCode == 13) {
				fnSetNo($(this));
				fnSearch();
			}
		});
	});
	
	function fnSetNo(obj) {
		if($(obj).val()) {
			$(obj).val(fnLpad($(obj).val(), 6));
		}
	}
	
	function fnTopLst () {
		$("#show").click(function(){
	        $("#showinbox").show();
			 $("#show").hide();
			 $("#hide").show();
	    });
	    $("#hide").click(function(){
	        $("#showinbox").hide();
			 $("#show").show();
			 $("#hide").hide();
	    });
	}		

	function initGrid() {
		// 상단 공통 그리드
		var columnLayoutT = [{
				headerText : "사건번호", dataField : "CASE_NO", width : 120
			}, {
				headerText : "입건일자", dataField : "PRSCT_DE", width : 120, dataType : "date", formatString : "yyyy-mm-dd"
			}, {
				headerText : "수사단서", dataField : "INV_PROVIS_NM", width : 100
			}, {
				headerText : "진행상태", dataField : "PROGRS_STTUS_NM", width : 100				
			}, {
				headerText : "위반사항", dataField : "VIOLT_NM", style : "grid_td_left"
			}
		];
 		var gridProsT = {
 	 		showRowNumColumn : true,
 			displayTreeOpen : true,
 			//showRowCheckColumn : true,
 			//rowCheckToRadio : true,
 			selectionMode : "singleRow",
 			triggerSelectionChangeOnCell:true,
 			noDataMessage:"조회 목록이 없습니다.",
 			headerHeight : 30,
 			rowHeight: 30,
 			fillColumnSizeMode : true
 		};
		AUIGrid.create("#gridCaseList", columnLayoutT, gridProsT);
		AUIGrid.bind("#gridCaseList", "cellDoubleClick", function(event) {
			var items = event.item;
			$("#schCaseNo1").val(items.CASE_NO.substr(0, 4));
			$("#schCaseNo2").val(items.CASE_NO.substr(5, 6));
			fnSearch();
		});
		
		var columnLayout = [{
				headerText : "서류표목", dataField : "RCORD_NM", width : "30%"
			}, {
				headerText : "진술자", dataField : "RCORD_STATER", width : "15%"
			}, {
				headerText : "정수", dataField : "RCORD_CO", width : "15%"
			}, {
				headerText : "작성일자", dataField : "RCORD_DE", width : "15%"
			}
		];
		var gridPros = {
			showRowNumColumn : true,
			displayTreeOpen : true,
			//showRowCheckColumn : true,
			//rowCheckToRadio : true,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell:true,
			noDataMessage:"조회 목록이 없습니다.",
			headerHeight : 30,
			rowHeight: 30
		};
	
		gridRcordList = AUIGrid.create("#gridRcordList", columnLayout, gridPros);
		AUIGrid.bind(gridRcordList, "cellDoubleClick", function(event) {
			var items = event.item;
			$("#hidTrnRcordNo").val(items.TRN_NO);
			$("#hidRcordSn").val(items.RCORD_SN);
			$("#txtRcordNm").val(items.RCORD_NM);
			$("#txtRcordStater").val(items.RCORD_STATER);
			$("#txtRcordCo").val(items.TRN_CCDRC_CO);
			$("#txtSort").val(items.SORT_ORDR);
			$("#txtRm").val(items.TRN_CCDRC_RM);
		});
		
		//기본 조회
		fnSearchGrid("/trn/caseListAjax/?gubun=TRN_CCDRC", "", "#gridCaseList");		
	}
	
	function fnSearch() {
		if(fnIsEmpty($("#schTrnNo1").val()) && fnIsEmpty($("#schTrnNo2").val()) && fnIsEmpty($("#schCaseNo1").val()) && fnIsEmpty($("#schCaseNo2").val())) {
			alert("송치번호 또는 사건번호를 입력하세요.");
			$("#schTrnNo1").focus();
			return;
		}
	
		if(fnIsEmpty($("#schTrnNo1").val()) && !fnIsEmpty($("#schTrnNo2").val())) {
			alert("송치번호를 정확하게 입력하세요.");
			$("#schTrnNo1").focus();
			return;
		}
	
		if(!fnIsEmpty($("#schTrnNo1").val()) && fnIsEmpty($("#schTrnNo2").val())) {
			alert("송치번호를 정확하게 입력하세요.");
			$("#schTrnNo2").focus();
			return;
		}
	
		if(fnIsEmpty($("#schCaseNo1").val()) && !fnIsEmpty($("#schCaseNo2").val())) {
			alert("사건번호를 정확하게 입력하세요.");
			$("#schCaseNo1").focus();
			return;
		}
	
		if(!fnIsEmpty($("#schCaseNo1").val()) && fnIsEmpty($("#schCaseNo2").val())) {
			alert("사건번호를 정확하게 입력하세요.");
			$("#schCaseNo2").focus();
			return;
		}
	
		var iUrl = "<c:url value='/trn/trnCaseInfoAjax/'/>";
		var queryString = $('#form_search').serialize();
		var processAfterGet = function(data) {
			console.log('data:'+data);
			if(data.result == "0") {
				alert("검색 결과가 없습니다.");
			} else {
				if(data.PROGRS_STTUS_CD == "00241" || data.PROGRS_STTUS_CD == "00242") {
					alert("사건진행상태가 " + data.PROGRS_STTUS_NM + "(으)로 조회만 가능합니다.");
					/* $("#btnSchExmn").hide();
					$("#btnSave").hide();
					$("#btnDel").hide();
					$("#btnAsk").hide();
					$("#btnSaveSuspct").hide();
					$("#btnSaveViolt").hide(); */
				} else {
					/* $("#btnSchExmn").show();
					$("#btnSave").show();
					$("#btnDel").show();
					$("#btnAsk").show();
					$("#btnSaveSuspct").show();
					$("#btnSaveViolt").show(); */
				}
				//$("#form_detail").resetForm();
				$("#hidTrnNo").val(data.TRN_NO);
				$("#hidTrnRcordNo").val(data.TRN_NO);
				$("#span_hidTrnNo").html(data.TRN_NO);
				$("#hidCaseNo").val(data.CASE_NO);
				$("#span_hidCaseNo").html(data.CASE_NO);
				$("#span_calTrnDe").html(data.TRN_DE);
				$("#span_txtInvProvisNm").html(data.INV_PROVIS_NM);
				$("#span_selEvdencYn").html(data.EVDENC_YN);
				$("#span_txtCmptncExmnNm").html(data.CMPTNC_EXMN_NM);
				$("#span_txtTrnRm").html(data.TRN_RM);
				fnSearchGrid("/trn/trnRcordListAjax/", "form_detail", gridRcordList);
				fnReportList("ifrReport", data.DOC_ID, sFormatId, "P_TRN_NO="+data.TRN_NO);
				//AUIGrid.clearGridData(gridVioltList);
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnSave() {
		if(fnIsEmpty($("#hidTrnRcordNo").val())) return;
		
		// 필수 체크
		if(!fnFormValueCheck("form_rcord")) return;
		
		console.log("hidTrnRcordNo : "+$("#hidTrnRcordNo").val());
		console.log("hidRcordSn : "+$("#hidRcordSn").val());
		
		if(confirm("저장하시겠습니까?")) {
			var iUrl = "<c:url value='/trn/modTrnRcordAjax/'/>";
			if(fnIsEmpty($("#hidRcordSn").val())) {
				iUrl = "<c:url value='/trn/addTrnRcordAjax/'/>";
			}

			var queryString = $("#form_rcord").serialize();
			var processAfterGet = function(data) {
				if(data.result == "1") {
					alert("저장되었습니다.");
					fnSearchGrid("/trn/trnRcordListAjax/", "form_detail", gridRcordList);
					fnInit();
				} else {
					alert("저장중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}
	
	function fnDel() {
		if(fnIsEmpty($("#hidTrnRcordNo").val())) return;
		
		if(fnIsEmpty($("#hidRcordSn").val())) {
			alert("삭제할 자료를 선택하세요.");
			return;
		}

		if(confirm("삭제하시겠습니까?")){
			var iUrl = "<c:url value='/trn/delTrnRcordAjax/'/>";
			var queryString = $('#form_rcord').serialize();
			var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("삭제되었습니다.");
					fnSearchGrid("/trn/trnRcordListAjax/", "form_detail", gridRcordList);
					fnInit();
				}else{
					alert("삭제중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}	
	
	function fnInit() {
		$("#form_rcord")[0].reset();
		$("#hidRcordSn").val("");
	}

</script>

<!-- 상단 조회 -->
<div class="sh_box">
	<button id="hide" class="showbtn"></button>
	<button id="show" class="hidebtn" style="display: none"></button>

	<div class="show_in" id="showinbox">
		<!--테이블 시작 -->
		<div class="com_box">
			<div id="gridCaseList" class="gridResize tb_01_box" style="width: 100%; height: 190px;"></div>
		</div>
	</div>
</div>
<!-- //상단 조회 -->

<!--검색박스 -->
<form id="form_search" name="form_search" method="post">
<input type="hidden" name="schProgrsSttusCd" id="schProgrsSttusCd" value="00240">
<div class="search_box mb_20">
	<div class="search_in">
		<div class="stitle mr_20">송치번호</div>
		<div class="r_box ">
			<input type="text" id="schTrnNo1" name="schTrnNo1" maxlength="4" class="w_80px input_com" />&nbsp;-
			<input type="text" id="schTrnNo2" name="schTrnNo2" maxlength="6" class="w_100px input_com" onblur="fnSetNo(this)"/>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle mr_20">사건번호</div>
		<div class="r_box ">
			<input type="text" id="schCaseNo1" name="schCaseNo1" maxlength="4" class="w_80px input_com" />&nbsp;-
			<input type="text" id="schCaseNo2" name="schCaseNo2" maxlength="6" class="w_100px input_com" onblur="fnSetNo(this)"/>
		</div>
	</div>
	<a href="javascript:fnSearch();"><div class="go_search2">검색</div></a>
</div>
</form>
<!--//검색박스 -->

<!--가로  2칸 -->
<form id="form_detail" name="form_detail" method="post">
<div class="box_w2 mb_10">
	<!-----------송치 기본정보----------->
	<div class="box_w2_1b">
		<div class="title_s_st2 w_50p fl mb_8">
			<img src="/img/title_icon1.png" alt="" />송치 기본정보
		</div>
		<div class="right_btn fr">
			<a href="#" onClick="popup010201(); return false" class="btn_st2_2 icon_n fl">사건상세조회</a>
		</div>
		<!--테이블 시작 -->
		<div class="com_box">
			<div class="tb_01_box">
				<table class="tb_01_h100">
					<col width="100px" />
					<col width="50%" />
					<col width="100px" />
					<col width="50%" />
					<tbody>
						<tr class="h_40px">
							<th>송치번호</th>
							<td>
								<span id="span_hidTrnNo"></span>
								<input type="hidden" name="hidTrnNo" id="hidTrnNo">
							</td>
							<th>사건번호</th>
							<td>
								<span id="span_hidCaseNo"></span>
								<input type="hidden" name="hidCaseNo" id="hidCaseNo">
							</td>
						</tr>
						<tr class="h_40px">
							<th>송치일자</th>
							<td><span id="span_calTrnDe"></span></td>
							<th>관할검찰</th>
							<td><span id="span_txtCmptncExmnNm"></span></td>
						</tr>
						<tr class="h_40px">
							<th>발각원인</th>
							<td><span id="span_txtInvProvisNm"></span></td>
							<th>증거품</th>
							<td><span id="span_selEvdencYn"></span></td>
						</tr>
						<tr class="h_120px">
							<th>비고</th>
							<td colspan="3"><span id="span_txtTrnRm"></span></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!--//송치 기본정보-->
	<div class="box_w2_2b">
		<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="295"></iframe>
	</div>
</div>
</form>

<!-- //가로2칸 --->
<!-- 가로2칸 --->
<form id="form_rcord" name="form_rcord" method="post">
<div class="box_w2 mb_20">
	<!----------가로 좌측 압수물 정보 ------------>
	<div class="box_w2_1b">
		<div class="title_s_st2 w_50p fl mb_8">
			<img src="/img/title_icon1.png" alt="" />기록목록 정보
		</div>
		<!--테이블 시작 -->
		<div class="com_box ">
			<div class="tb_01_box">
				<div id="gridRcordList" class="gridResize" style="width:100%; height:250px; margin:0 auto;"></div>
			</div>
		</div>
	</div>
	<!---------- //가로 좌측 ------------>
	<!----------가로 우측 ------------>
	<div class="box_w2_2b ">
		<!--버튼 -->
		<div class="right_btn fr mb_10">
			<input type="button" name="btnNew" id="btnNew" value="신규" class="btn_st1 icon_n fl mr_1" onclick="fnInit();">
			<input type="button" name="btnSave" id="btnSave" value="저장" class="btn_st1 icon_n fl mr_1" onclick="fnSave();">
			<input type="button" name="btnDel" id="btnDel" value="삭제" class="btn_st2 icon_n fl " onclick="fnDel();">
			<!--//버튼  -->
		</div>
		<!--테이블 시작 -->
		<div class="com_box ">
			<div class="tb_01_box">
				<table class="tb_01_h100">
					<col width="150px" />
					<col width="" />
					<tbody>
						<tr class="h_40px">
							<th>서류표목</th>
							<td><input type="text" name="txtRcordNm" id="txtRcordNm" class="w_400px input_com" check="text" checkName="서류표목">
								<input type="hidden" name="hidTrnRcordNo" id="hidTrnRcordNo">
								<input type="hidden" name="hidRcordSn" id="hidRcordSn"></td>
						</tr>
						<tr class="h_40px">
							<th>진술자</th>
							<td><input type="text" name="txtRcordStater" id="txtRcordStater" class="w_400px input_com" check="text" checkName="진술자"></td>
						</tr>
						<tr class="h_40px">
							<th>정수</th>
							<td><input type="text" name="txtRcordCo" id="txtRcordCo" class="w_400px input_com" check="text" checkName="정수"></td>
						</tr>
						<tr class="h_40px">
							<th>작성일자</th>
							<td><div class="calendar_box  w_150px  mr_5">
									<input type="text" name="calRcordDe" id="calRcordDe" class="w_100p input_com calendar" check="text" checkName="작성일자">
									<div class="calendar_icon"><img src="/img/search_calendar.png" alt="" /></div>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<!----------//가로우측 ------------>
</div>
<!----------//가로2칸 ------------>
</form>
