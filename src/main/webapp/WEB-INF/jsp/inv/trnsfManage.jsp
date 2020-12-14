<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<style>
.w_47p {width:47%; box-sizing:border-box}
.grid_td_left {text-align:left}
input[type=radio] {
  visibility: visible; float: none;
}
</style>

<script type="text/javascript">

	$(function() {
		$(document).ready(function(){
			fnTopLst();
			fnDatePickerImg("calTrnsfDeFrom", null, false);
			fnDatePickerImg("calTrnsfDeTo", null, false);
			fnDatePickerImg("calSchDeFrom", null, false);
			fnDatePickerImg("calSchDeTo", null, false);
			fnDatePickerImg("calTrnsfDe", null, false);
			fnUpCdList("00768", $("#selResnCd"));  // 이송사유코드
			initGrid();   // 그리드관련
			gridResize(); // 그리드관련
		});

		$("#txtSchNo1").keyup(function(event) {
			fnRemoveChar(event);
			if($(this).val().length == 4) {
				$("#txtSchNo2").focus();
			}
		});

		$("#txtSchNo2").keyup(function(event) {
			fnRemoveChar(event);
			if(event.keyCode == 13) {
				fnSetNo($(this));
				fnSearch();
			}
		});

		/* $("input:radio[name=rdoDiv]").change(function(){
			if($(this).val() == "C") {
				$("#spanNo").html("사건번호");
				$("#spanDate").html("입건일자");
				$("#calSchDeFrom").attr("checkName", "입건일자");
				$("#calSchDeTo").attr("checkName", "입건일자");
			} else {
				$("#spanNo").html("접수번호");
				$("#spanDate").html("접수일자");
				$("#calSchDeFrom").attr("checkName", "접수일자");
				$("#calSchDeTo").attr("checkName", "접수일자");
			}
		}); */
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
		var columnLayoutT1 = [
   					{ dataField : "grdCaseNo",      headerText : "사건번호", 	width : 120 },
   					{ dataField : "grdPrsctDe",   	headerText : "입건일자", 	width : 130, dataType : "date", formatString : "yyyy-mm-dd"},
   					{ dataField : "grdInvProvisNm",	headerText : "수사단서",	width : 100 },
   	   				{ dataField : "grdVioltNm",		headerText : "위반사항", style : "grid_td_left" },
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
 		
		// 상단 공통 그리드
		AUIGrid.create("#gridT1_wrap",columnLayoutT1,gridProsT);
		AUIGrid.bind("#gridT1_wrap", "cellClick", function(event) {
			var items = event.item;
			$("#txtSchNo1").val(items.grdCaseNo.substr(0, 4));
			$("#txtSchNo2").val(items.grdCaseNo.substr(5, 6));
			$("#rdoDiv").val("C");
			fnSearch();
			//fnDetail(items);			
		}); 		
		  		
		var columnLayout = [{
				headerText : "사건번호",
				dataField : "CASE_NO",
				width : 120
			}, {
				headerText : "입건일자",
				dataField : "PRSCT_DE",
				width : 100,
				dataType : "date",
				formatString : "yyyy-mm-dd"
			}, {
				headerText : "진행상태",
				dataField : "PROGRS_STTUS_CD_NM",
				width : 140
			}, {
				headerText : "위반사항",
				dataField : "VIOLT_NM",
				style : "grid_td_left"
				//width : 180
				//minWidth : 100
			}, {
				headerText : "대상자",
				dataField : "TRGTER_NMS",
				width : 130
			}, {
				headerText : "이송기관명",
				dataField : "TRNSF_INSTT_NM",
				width : 150
			}, {
				headerText : "이송일자",
				dataField : "TRNSF_DE",
				width : 100,
				dataType : "date",
				formatString : "yyyy-mm-dd"
			}
		];
		var gridPros = {
			showRowNumColumn : true,
			displayTreeOpen : true,
			showRowCheckColumn : true,
			rowCheckToRadio : true,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell:true,
			noDataMessage:"조회 목록이 없습니다.",
			headerHeight : 30,
			rowHeight: 30
		};

		AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind("#grid_list", "cellClick", function(event) {
			var items = event.item;
			fnDetail(items);
			AUIGrid.setCheckedRowsByValue("#grid_list", "CASE_NO", items.CASE_NO);
		});

		// 체크박스(라디오버턴) 클릭 이벤트 바인딩
		AUIGrid.bind("#grid_list", "rowCheckClick", function(event) {
			//console.log("rowIndex : " + event.rowIndex + ", id : " + event.item.id + ", name : " + event.item.name + ", checked : " + event.checked);
			var items = event.item;
			fnDetail(items);
		});
		
		//기본 조회
		fnT1Search();			
	}

	function fnT1Search() {
		fnSearchGrid("/inv/arrstCaseListAjax/", "form_search", "#gridT1_wrap");
	}
	
	function fnSearch() {
		if(!fnCompareDate($("#calTrnsfDeFrom"), $("#calTrnsfDeTo"))) return;
		if(!fnCompareDate($("#calSchDeFrom"), $("#calSchDeTo"))) return;

		fnSearchGrid("/inv/trnsfListAjax/", "form_search", "#grid_list");
		$("#form_detail").resetForm();

		//var str = $("#schCaseNo1").val() + "-" + $("#schCaseNo2").val();
		//$("#hidCaseNo").val(str);
	}

	function fnSave() {
		if(fnIsEmpty($("#hidRcNo").val())) {
			alert("이송저장할 사건을 선택하세요.");
			return;
		}

		// 필수 체크
		var str = $("input:radio[name=rdoInsttSeCd]:checked").val();
		if(fnIsEmpty(str)) {
			alert("이송기관구분은(는) 필수입력 항목입니다.");
			$("input:radio[name=rdoInsttSeCd]").focus();
			return;
		}
		if(!fnFormValueCheck("form_detail")) return;
		if(!fnCheckDate($("#calTrnsfDe"))) return;

		var iUrl = "<c:url value='/inv/addTrnsfAjax/'/>";

		if(!fnIsEmpty($("#hidTrnsfSn").val())) {
			iUrl = "<c:url value='/inv/modTrnsfAjax/'/>";
		}

		if(confirm("저장하시겠습니까?")){
			var queryString = $('#form_detail').serialize();
			var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("저장되었습니다.");
					fnSearch();
				}else{
					alert("저장중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnDel() {
		if(fnIsEmpty($("#hidTrnsfSn").val())) {
			alert("이송삭제할 사건을 선택하세요.");
			return;
		}

		var iUrl = "<c:url value='/inv/delTrnsfAjax/'/>";

		if(confirm("삭제하시겠습니까?")){
			var queryString = $('#form_detail').serialize();
			var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("삭제되었습니다.");
					fnSearch();
				}else{
					alert("삭제중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	// 셀 셀렉션 변경 시 아이템의 정보를 Form 필드에 세팅함
	function fnDetail(cInfo) {
		$("#form_detail").resetForm();
		$("#hidRcNo").val(cInfo.RC_NO);
		$("#hidCaseNo").val(cInfo.CASE_NO);
		if(!fnIsEmpty(cInfo.TRNSF_SN)) {
			$("#hidTrnsfSn").val(cInfo.TRNSF_SN);
			$("#calTrnsfDe").val(cInfo.TRNSF_DE);
			//$("#rdoInsttSeCd").val(cInfo.TRNSF_INSTT_SE_CD);
			$("input:radio[name=rdoInsttSeCd]:input[value="+cInfo.TRNSF_INSTT_SE_CD+"]").prop("checked", true);
			$("input:radio[name=rdoInsttSeCd]:input[value!="+cInfo.TRNSF_INSTT_SE_CD+"]").prop("checked", false);
			$("#txtInsttNm").val(cInfo.TRNSF_INSTT_NM);
			$("#txtInsttDept").val(cInfo.TRNSF_INSTT_DEPT);
			$("#txtInsttCharger").val(cInfo.TRNSF_INSTT_CHARGER);
			$("#selResnCd").val(cInfo.TRNSF_RESN_CD);
			$("#txtResnDc").val(cInfo.TRNSF_RESN_DC);
		}
	}

	function fnDetailPop() {
		if(fnIsEmpty($("#hidRcNo").val())) {
			alert("이송삭제할 사건을 선택하세요.(사건상세보기 팝업 작업중)");
			return;
		}
		alert('사건상세보기 팝업 작업중');
	}

</script>
<!-- 상단 조회 -->
<div class="sh_box">
	<button id="hide" class="showbtn"></button>
	<button id="show" class="hidebtn" style="display: none"></button>

	<div class="show_in" id="showinbox">
		<!-- <div class="box_w2"> -->
			<!---------- 왼쪽테이블  ---------------->
			<!-- <div class="box_w2_1b_ov" style="height: 200px;"> -->
				<!--테이블 시작 -->
				<div class="com_box">
					<div id="gridT1_wrap" class="gridResize tb_01_box" style="width: 100%; height: 190px;"></div>
				</div>
			<!-- </div> -->
			<!---------- //왼쪽테이블  ---------------->
			<!---------- 오른쪽테이블 ---------------->
			<!-- <div class="box_w2_2b_ov">
				테이블 시작
				<div class="com_box">
					<div id="gridT2_wrap" class="gridResize tb_01_box" style="width: 100%; height: 190px;"></div>
				</div>
			</div> -->
			<!---------- //오른쪽테이블---------------->
		<!-- </div> -->
	</div>
</div>
<!-- //상단 조회 -->
<!--검색박스 -->
<form id="form_search" name="form_search" method="post">
<div class="search_box mb_20">
	<div class="search_in">
		<div class="stitle w_80px">이송일자</div>
		<div class="r_box">
			<div class="input_out w_100px  fl">
				<input type="text" class="w_100p input_com" name="calTrnsfDeFrom" id="calTrnsfDeFrom" maxlength="10" onkeyup="fnRemoveChar(event)" checkName="이송일자">
				<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
			</div>
			<div class="sp_tx fl">~</div>
			<div class="input_out w_100px  fl">
				<input type="text" class="w_100p input_com" name="calTrnsfDeTo" id="calTrnsfDeTo" maxlength="10" onkeyup="fnRemoveChar(event)" checkName="이송일자">
				<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
			</div>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_80px">사건번호</div>
			<div class="r_box">
				<input type="text" id="txtSchNo1" name="txtSchNo1" maxlength="4" class="w_80px input_com" />&nbsp;-
				<input type="text" id="txtSchNo2" name="txtSchNo2" maxlength="6" class="w_100px input_com" onblur="fnSetNo(this)"/>
				<input type="text" id="rdoDiv" name="rdoDiv" value="C"/>
			</div>			
		<%-- <div class="r_box  w_300px">
			<div class="tl_box">
				<div class="tt">검색기준</div>
				<div class="td">
					<div class='input_radio2 t_left'> <input class="to-labelauty-icon" type="radio" name="rdoDiv" value="R" checked/>접수번호 </div>
					<div class='input_radio2 t_left'> <input class="to-labelauty-icon" type="radio" name="rdoDiv" value="C"/>사건번호</div>
				</div>
			</div>
			<div class="tl_box">
				<div class="tt"><span id="spanNo">접수번호</span></div>
				<div class="td2">
					<input type="text" class="w_40p input_com_s" name="txtSchNo1" id="txtSchNo1" maxlength="4"/>
					 -
					<input type="text" class="w_50p input_com_s" name="txtSchNo2" id="txtSchNo2" maxlength="6" onblur="fnSetNo(this)"/>
				</div>
			</div>
			<div class="tl_box">
				<div class="tt"><span id="spanDate">접수일자</span></div>
				<div class="td2">
					<div class="input_out w_47p fl">
						<input type="text" class="w_100p input_com_s" name="calSchDeFrom" id="calSchDeFrom" maxlength="10" onkeyup="fnRemoveChar(event)" checkName="접수일자">
						<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div> ~
					<div class="input_out w_47p">
						<input type="text" class="w_100p input_com_s " name="calSchDeTo" id="calSchDeTo" maxlength="10" onkeyup="fnRemoveChar(event)" checkName="접수일자">
						<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div>
				</div>
			</div>
		</div> --%>
	</div>
	<a href="javascript:fnSearch();"><div class="go_search2">검색</div></a>
</div>
</form>
<!--// 검색박스 -->

<!---------------이송관리 버튼 -------------->
<div class="com_box mb_10">
	<div class="right_btn fr">
		<a href="javascript:void(0);" class="btn_st2_2 icon_n fl mr_m1" onclick="fnDetailPop();">사건상세보기</a>
	</div>
</div>
<!---------------// 이송관리 버튼 -------------->

<!-- 그리드 -->
<div class="com_box mb_20">
	<div class="tb_01_box">
		<div id="grid_list" class="gridResize" style="width:100%; height:215px; margin:0 auto;"></div>
	</div>
</div>

<div class="com_box mb_10">
	<div class="right_btn fr">
		<a href="javascript:void(0);" class="btn_st1 icon_n fl mr_m1" onclick="fnSave();">이송저장</a>
		<a href="javascript:void(0);" class="btn_st2 icon_n fl mr_m1" onclick="fnDel();">이송삭제</a>
	</div>
</div>

<!---------이송관서 및 사유 등 이송정보 ---------->
<form id="form_detail" name="form_detail" method="post">
<input type="hidden" name="hidRcNo" id="hidRcNo">
<input type="hidden" name="hidCaseNo" id="hidCaseNo">
<input type="hidden" name="hidTrnsfSn" id="hidTrnsfSn">
<div class="com_box">
	<div class="tb_01_box">
		<table class="tb_01_h100">
			<col width="150px"/>
			<col width="150px"/>
			<col width="25%"/>
			<col width="150px"/>
			<col width=""/>
			<tbody>
			<tr  class="h_40px">
				<th>이송기관구분</th>
				<td colspan="2">
					<c:forEach var="list" items="${trnsfInsttSeCdList}" varStatus="status">
					<div class='input_radio2 t_left'><input type="radio" name="rdoInsttSeCd" class="to-labelauty-icon" value="${list.cd}"/>${list.cdNm}</div>
					</c:forEach>
				</td>
				<th>이송일자</th>
				<td><div class="calendar_box w_150px mr_5">
					<input type="text" class="w_100p input_com calendar" id="calTrnsfDe" name="calTrnsfDe" check="text" checkName="이송일자" onkeyup="fnRemoveChar(event)">
					<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
					</div>
				</td>
			</tr>
			<tr  class="h_40px">
				<th rowspan="3">이송기관정보</th>
				<th>기관명</th>
				<td>
					<input type="text" name="txtInsttNm" id="txtInsttNm" maxlength="50" class="w_100p input_com" check="text" checkName="이송기관명">
				</td>
				<th rowspan="3">이송사유</th>
				<td>
					<select name="selResnCd" id="selResnCd" class="w_200px input_com" check="text" checkName="이송사유"></select>
				</td>
			</tr>
			<tr  class="h_40px">
				<th>부서</th>
				<td>
					<input type="text" name="txtInsttDept" id="txtInsttDept" maxlength="50" class="w_100p input_com" check="text" checkName="이송기관 부서">
				</td>
				<td rowspan="2" class="h100">
					<textarea id="txtResnDc" name="txtResnDc" maxlength="200"></textarea>
				</td>
			</tr>
			<tr  class="h_40px">
				<th>담당자</th>
				<td>
					<input type="text" name="txtInsttCharger" id="txtInsttCharger" maxlength="25" class="w_100p input_com" check="text" checkName="이송기관 담당자">
				</td>
			</tr>
			</tbody>
		</table>
	</div>
</div>
</form>
<!---------//이송관서 및 사유 등 이송정보 ---------->