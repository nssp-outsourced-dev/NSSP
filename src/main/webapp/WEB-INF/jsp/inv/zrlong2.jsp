<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<title>체포/구속영장관리(신청내역)</title>
<script type="text/javascript">
	var docNo = "00447";	/*구속양식*/
	$(function() {
		fnTopLst ();
		fnRealDatePicker("txtReqstDe","divCal9");
		fnRealDateTimePicker("txtRstValidDt","divCal10");
		fnRealDateTimePicker("txtIsueDt","divCal11");
		fnRealDateTimePicker("txtArrstDt","divCal1");
		fnRealDateTimePicker("txtReqValidDt","divCal2");
		fnRealDateTimePicker("txtReqAttractDt","divCal3");
		fnRealDateTimePicker("txtReqCnfnmDt","divCal4");
		fnRealDateTimePicker("txtExcutDt","divCal5");
		fnRealDateTimePicker("txtRstAttractDt","divCal6");
		fnRealDateTimePicker("txtRstCnfnmDt","divCal7");
		fnRealDateTimePicker("txtRslDt","divCal8");
		initGrid ();
		fnDoc ("","");
	});
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
	function fnDoc (pDocId, pParam) {
		fnReportList('ifrReport',pDocId,docNo,pParam);
	}
	function initGrid () {
		var zrlongSeLst = [<c:forEach var="cd" items="${zrlongSeLst}" varStatus="status">{"cd":"${cd.cd}","cdNm":"${cd.cdNm}"},</c:forEach>];
		var zrlongReqstLst = [{"cd":"Y","cdNm":"신청완료"},{"cd":"N","cdNm":"신청취소"}];
		var reqstResultLst = [{"cd":"Y","cdNm":"가"},{"cd":"N","cdNm":"부"}];
		var columnLayoutT1 = [
	  					{ dataField : "grdCaseNo",      headerText : "사건번호", 	width : 120 },
	  					{ dataField : "grdPrsctDe",   	headerText : "입건일자", 	width : 130, dataType : "date", formatString : "yyyy-mm-dd"},
	  					{ dataField : "grdInvProvisNm",	headerText : "수사단서",	width : 100 },
	  	   				{ dataField : "grdVioltNm",		headerText : "위반사항" },
	  	                ];
		var columnLayoutT2 = [
					{ dataField : "grdTrgterSn",   	headerText : "대상자일련번호", visible : false},
	                { dataField : "grdCaseNo",      headerText : "사건번호" },
	                { dataField : "grdPrsctDe",   	headerText : "입건일자", 	dataType : "date", formatString : "yyyy-mm-dd"},
	                { dataField : "grdTrgterNm",    headerText : "피의자명", style:'tbLft'},
	                { dataField : "grdTrgterRrn",   headerText : "주민번호" }
	                ];
		var columnLayoutR = [
 					{ dataField : "grdTrgterSn",   		headerText : "대상자일련번호", 	visible : false},
 	                { dataField : "grdCaseNo",      	headerText : "사건번호", 		visible : false },
 	                { dataField : "grdZrlongNoOrg",   	headerText : "영장번호" },
 	                { dataField : "grdZrlongSeCd",   	headerText : "영장구분",
 	                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
	            			return gridComboLabel(zrlongSeLst, value)
	            		}
 	                },
 	                { dataField : "grdReqstDe", 		headerText : "영장신청일"},
 	                { dataField : "grdZrlongReqstYn", 	headerText : "신청여부",
 	                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
	            			return gridComboLabel(zrlongReqstLst, value)
	            		}
 	                },
 	                { dataField : "grdReqstResultYn", 	headerText : "신청결과",
 	                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
	            			return gridComboLabel(reqstResultLst, value)
	            		}
 	                }];
		var gridPros = {
			displayTreeOpen : true,
			rowNumHeaderText:"순번",
			selectionMode : "singleRow",	// 선택모드 (기본값은 singleCell 임)
			//noDataMessage:"조회 목록이 없습니다.",
			headerHeight : 30,
			rowHeight: 30
		};
		AUIGrid.create("#gridT1_wrap",columnLayoutT1,gridPros);
		AUIGrid.create("#gridT2_wrap",columnLayoutT2,gridPros);
		AUIGrid.create("#gridR_wrap",columnLayoutR,gridPros);

		AUIGrid.bind("#gridT2_wrap", "cellDoubleClick", function(event) {
			var items = event.item;
			fnGridDtlList (items);
		});
		AUIGrid.bind("#gridR_wrap", "cellDoubleClick", function(event) {
			var items = event.item;
			fnZrlongDtlList (items);
		});
		AUIGrid.bind("#gridT1_wrap", "cellDoubleClick", function(event) {
			var items = event.item.grdCaseNo.split("-");
			if(items != null && items.length == 2) {
				$("#searchCaseNo1").val(items[0]);
				$("#searchCaseNo2").val(items[1]);
				fnT2Search ();
			} else {
				alert("사건번호가 확인되지 않습니다.");
			}
		});
		//기본 조회
		fnT1Search();
	}
	function fnT1Search () {
		fnSearchGrid("/inv/zrlongCaseListAjax/", "searchForm", "#gridT1_wrap");
	}
	function fnT2Search () {
		fnSearchGrid ("/inv/suspectZrlongListAjax/", "searchForm", "#gridT2_wrap");
	}
	function fnZrlongDtlList (items) {
		fnReset (2);
		if(fnChkKey("조회",1,'S')) {
			//tab1
			fn_form_bind ("zrlongDtlForm",items,"GRID");
			$("#hiddtlCudType").val("U");
			//필요고려사항
			var arrRn = items.grdNeedCnsdrCd.split(",");
			for(var i in arrRn) {
				$("input:checkBox[name='rdoNeedCnsdrCdChk']:checkBox[value='"+arrRn[i]+"']").prop("checked",true);
			}
			//영장신청일, 체포일시, 체포장소
			fn_form_bind ("trgterInfoForm",items,"GRID");

			//tab2
			fn_form_bind ("rstDtlForm",items,"GRID");
			if(fnIsEmpty(items.grdZrlongNo)) {
				$("#hidrstCudType").val("C");
			} else {
				$("#hidrstCudType").val("U");
			}

			//doc
			fnDoc(items.grdDocId,"P_CASE_NO="+items.grdCaseNo+"&P_TRGTER_SN="+items.grdTrgterSn+"&P_ZRLONG_REQST_NO="+items.grdZrlongReqstNo+"&P_ZRLONG_NO="+items.grdZrlongNo);
		}
	}
	function fnGridDtlList (items) {
		//체포목록 조회
		fnReset (1);
		$("input[name='hidCaseNo']").val(items.grdCaseNo);
		$("input[name='hidTrgterSn']").val(items.grdCaseTrgterSn);
		if(fnChkKey("조회",1,'S')) {
			fnSearchGrid ("/inv/zrlongListAjax/", "zrlongForm", "#gridR_wrap");
			fn_form_bind ("trgterInfoForm",items,"GRID");
		}
	}
	function fnChkKey (pMsg, pType, pSe) {
		if(fnIsEmpty($("#zrlongForm").find("#hidsearchCaseNo").val())||fnIsEmpty($("#zrlongForm").find("#hidsearchTrgterSn").val())) {
			alert("상단 좌측 피의자를 선택 후 "+pMsg+"해 주세요.");
			return false;
		}
		if(pSe == 'D') {
			if(fnIsEmpty($("#zrlongDtlForm").find("#hiddtlZrlongReqstNo").val())) {
				alert("상단 우측 체포/구속영장신청 현황을 선택 후 "+pMsg+"해 주세요.");
				return false;
			}
		}
		if(pType == 2) {
			if(fnIsEmpty($("#rstDtlForm").find("#hidrstZrlongReqstNo").val())) {
				alert("상단 우측 체포/구속영장신청 현황을 선택 후 "+pMsg+"해 주세요.");
				return false;
			}
			if(pSe == 'D') {
				if(fnIsEmpty($("#rstDtlForm").find("#hidrstZrlongNoOrg").val())) {
					alert("구속영장 신청 결과가 없습니다. 신청 결과 여부를 다시 확인하여 주시기 바랍니다.");
					return false;
				}
			}
		}
		return true;
	}
	function fnSearchKeyUp (event) {
		if (event.which == 13) {
			event.keyCode = 0;
			fnSearch ();
		}
	}
	function fnReset (pType) {
		$("#zrlongDtlForm").clearForm ();
		$("#rstDtlForm").clearForm ();
		$(".dtlRs").val("");
		$("input[name='hidCudType']").val("C");
		if(pType == 1) {
			$("#trgterInfoForm").clearForm ();
			$("#zrlongForm").clearForm ();
			AUIGrid.setGridData("#gridR_wrap", []);
		}
	}
	function fnSearch () {
		if(fnIsEmpty($("#searchTrgterNm").val())&&(fnIsEmpty($("#searchTrgterRrn1").val())||fnIsEmpty($("#searchTrgterRrn2").val()))&&
				(fnIsEmpty($("#searchCaseNo1").val())||fnIsEmpty($("#searchCaseNo2").val()))) {
			alert ("조회조건은 필수 입니다.\n\n(피의자명, 주민등록번호, 사건번호 중 입력)");
			$("#searchCaseNo1").focus();
			return;
		}
		//대상자 정보
		fnReset (1);
		fnT2Search ();
	}
	function fnAdd () {
		//우선 reset 부터
		fnReset (2);
		if(!fnChkKey("추가",1,'A')) return;
	}
	function fnSave () {
		//활성 tab 확인
		var tab1 = $("#tab1").hasClass("current");
		if(tab1) {
			//신청내역 저장
			if(!fnChkKey("영장을 신청",1,'S')) return;
			$("#hiddtlCaseNo").val($("#hidsearchCaseNo").val());
			$("#hiddtlTrgterSn").val($("#hidsearchTrgterSn").val());
			if(fnFormValueCheck("zrlongDtlForm") && fnFormValueCheck("trgterInfoForm")){
				if(confirm("체포/구속 영장을 신청하시겠습니까?")) {
					fnLajax ("saveZrlongAjax","SAVE","zrlongDtlForm", $("#hiddtlCudType").val());
				}
			}
		} else {
			//신청결과 저장
			if(!fnChkKey("영장 신청결과를 저장",2,'S')) return;
			$("#hidrstCaseNo").val($("#hidsearchCaseNo").val());
			$("#hidrstTrgterSn").val($("#hidsearchTrgterSn").val());
			if(fnFormValueCheck("rstDtlForm")){
				if(confirm("체포/구속 영장 신청 결과를 저장 하시겠습니까?")) {
					fnLajax ("saveZrlongRstAjax","SAVE","rstDtlForm", $("#hidrstCudType").val());
				}
			}
		}
	}
	function fnDel () {
		//활성 tab 확인
		var tab1 = $("#tab1").hasClass("current");
		if(tab1) {
			if(!fnChkKey("영장을 삭제",1,'D')) return;
			//결과가 나왔다면???
			if(!fnIsEmpty($("#rstDtlForm").find("#hidrstZrlongNo").val())) {
				if(!confirm("신청이 완료된 체포/구속 영장입니다. \n\n삭제하시겠습니까?")) return;
			} else {
				if(!confirm("체포/구속 영장 신청을 취소하시겠습니까?")) return;
			}
			$("#hiddtlCudType").val("D");
			fnLajax ("saveZrlongAjax","DEL","zrlongDtlForm","D");
		} else {
			if(!fnChkKey("영장 신청결과를 삭제",2,'D')) return;
			if(!confirm("체포/구속 영장 신청 결과를 취소하시겠습니까?")) return;
			$("#hidrstCudType").val("D");
			fnLajax ("saveZrlongRstAjax","DEL","rstDtlForm","D");
		}
	}
	function fnLajax (sUrl, type, pForm, pCudType) {
		if(type == 'SAVE') {
			if(fnIsEmpty(pCudType)||pCudType=="D") {
				fnReset (2);
				alert("ERROR");
				return;
			}
		}
		var param = $('#'+pForm).serialize();
		    param += ("&"+ $('#trgterInfoForm').serialize()); //체포일시, 체포장소, 영장신청일
		var arrNeedCd = [];
		$.each($('input[name=rdoNeedCnsdrCdChk]')
			.filter(function(idx){
				return $(this).prop('checked') === true
			}),
			function(idx, el){
				arrNeedCd.push($(this).val());
		});
		param += ("&rdoNeedCnsdrCd="+arrNeedCd);

		var processAfterGet = function(data) {
			if(type == "SAVE" || type == "DEL") {
				if(!fnIsEmpty(data.rst)) {
					if(!fnIsEmpty(data.rst["ERROR"])) {
						alert(data.rst["ERROR"]);
					} else {
						if(type=="DEL") {
							alert("삭제되었습니다.");
						} else {
							alert("저장되었습니다.");
						}
					}
				} else {
					alert("오류 발생!");
				}
				AUIGrid.setGridData("#gridR_wrap", data.list);
				fnAdd ();
			}
		}
		Ajax.getJson("<c:url value='/inv/"+sUrl+"/'/>", param, processAfterGet);
	}
	function fnSend (pType) {
		if(pType == 2) {	/*압수수색*/
			$('#searchForm').attr('action', '<c:url value='/inv/szure/'/>');
		} else {			/*통신사실확인허가신청*/
			$('#searchForm').attr('action', '<c:url value='/inv/commnManage/'/>');
		}
		$('#searchForm').submit();
	}
</script>
<form id="sendForm">
	<input type="hidden" id="hidsendCaseNo" name="hidsendCaseNo"/>
	<input type="hidden" id="hidsendTrgterSn" name="hidsendTrgterSn"/>
</form>
<!-- 상단 조회 -->
<div class="sh_box">
	<button id="hide" class="showbtn"></button>
	<button id="show" class="hidebtn" style="display: none"></button>

	<div class="show_in" id="showinbox">
		<div class="box_w2">
			<!---------- 왼쪽테이블  ---------------->
			<div class="box_w2_1b_ov" style="height: 200px;">
				<!--테이블 시작 -->
				<div class="com_box">
					<div id="gridT1_wrap" class="gridResize tb_01_box" style="width: 100%; height: 190px;"></div>
				</div>
			</div>
			<!---------- //왼쪽테이블  ---------------->
			<!---------- 오른쪽테이블 ---------------->
			<div class="box_w2_2b_ov">
				<!--테이블 시작 -->
				<div class="com_box">
					<div id="gridT2_wrap" class="gridResize tb_01_box" style="width: 100%; height: 190px;"></div>
				</div>
			</div>
			<!---------- //오른쪽테이블---------------->
		</div>
	</div>
</div>
<!-- //상단 조회 -->
<div class="search_box mb_10">
	<form id="searchForm">
		<div class="search_in">
	   		<div class="stitle w_80px">피의자명</div>
		 	<input type="text" class="w_100px input_com" id="searchTrgterNm" name="searchTrgterNm" onkeyup="fnSearchKeyUp(event)">
		 </div>
		 <div class="search_in">
			<div class="stitle w_120px">주민등록번호</div>
			<div class="r_box">
				<input type="text" class="w_100px input_com" id="searchTrgterRrn1" name="searchTrgterRrn1" onkeyup="fnRemoveChar(event)">-
				<input type="text" class="w_100px input_com" id="searchTrgterRrn2" name="searchTrgterRrn2" onkeyup="fnRemoveChar(event)">
			</div>
		</div>
		<div class="search_in">
   			<div class="stitle w_80px" style="width: 80px; margin-bottom: 5px;">사건번호</div>
	 		<div class="r_box">
				<input type="text" class="w_100px input_com" id="searchCaseNo1" name="searchCaseNo1" onkeyup="fnRemoveChar(event)"> -
				<input type="text" class="w_100px input_com" id="searchCaseNo2" name="searchCaseNo2" onkeyup="fnEnterKeyUp(event)">
			</div>
		</div>
		<div class="go_search2" onclick="fnSearch()">검색</div>
	</form>
</div>
<!--//검색박스 -->

<!-- main tab -->
<div class="tabnbtn_box mb_10" id="tab_box">
	<ul class="tabs">
		<li id="mTab1" class="current">체포/구속</li>
		<li id="mTab2" onclick="fnSend(2)">압수수색검증</li>
		<li id="mTab3" onclick="fnSend(3)" style="width: 180px;">통신사실확인허가신청</li>
	</ul>
</div>
<div class="contents marginbot" id="mTab_list">
	<!---------- 영장관리 --------->
	<div id="mContent1" class="tabscontent">

		<div class="box_w2 mb_10">
			<!---------- 피의자 조회 ------------>
			<div class="box_w2_2b" style="margin-top: 7px;">
				<div class="title_s_st2 w_50p fl">
					<img src="/img/title_icon1.png" alt="" />체포/구속영장신청 현황
				</div>
				<!--테이블 시작 -->
				<div class="com_box">
					<div id="gridR_wrap" class="gridResize tb_01_box" style="width: 100%; height: 200px;"></div>
				</div>
			</div>
			<!---------- //피의자 조회 ------------>
			<!---------- 체포/구속영장신청 현황 ------------>
			<form id="zrlongForm">
				<input type="hidden" name="hidCaseNo" id="hidsearchCaseNo"/>
				<input type="hidden" name="hidTrgterSn" id="hidsearchTrgterSn"/>
			</form>
			<div class="box_w2_1b" style="width:calc(50% + 10px); padding-right: 0px;">
				<!--작성문서목록 -->
				<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%" height="250px"></iframe>
			</div>
			<!---------- //체포/구속영장신청 현황 ------------>
		</div>
		<!-- 탭영역  -->
		<div id="tabsholder">
			<div class="tabnbtn_box mb_10" id="tab_box">
				<ul class="tabs">
					<li id="tab1">신청내역</li>
					<li id="tab2">신청결과</li>
				</ul>
				<!--버튼 -->
				<div class="right_btn">
					<a class="btn_st1 icon_n fl mr_m1" onclick="fnAdd()">신규</a>
					<a class="btn_st1 icon_n fl mr_m1" onclick="fnDel()">삭제</a>
					<a class="btn_st2 icon_n fl" onclick="fnSave()">저장</a>
				</div>
				<!--//버튼  -->
			</div>

			<div class="contents marginbot" id="tab_list">
				<!---------- 신청내역  내용 --------->
				<div id="content1" class="tabscontent">
					<div class="box_w2 mb_20">
						<div class="box_w2_2b">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" />피의자 정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box mb_10">
								<form id="trgterInfoForm">
								<div class="tb_01_box">
									<table class="tb_01">
										<col width="" style="max-width:130px;"/>
										<col width="30%" />
										<col width="" style="max-width:130px;"/>
										<col width="" />
										<tbody>
											<tr>
												<th>피의자성명</th>
												<td colspan="3">
													<label id="labTrgterNm"></label>
												</td>
											</tr>
											<tr>
												<th>주민등록번호</th>
												<td>
													<label id="labTrgterRrn"></label>
												</td>
												<th>나이</th>
												<td>
													<label id="labTrgterAge" class="mr_5"></label>(만)세
												</td>
											</tr>
											<tr>
												<th>피의자직업</th>
												<td colspan="3">
													<label id="labOccpNm"></label>
												</td>
											</tr>
											<tr>
												<th>피의자주거</th>
												<td colspan="3">
													<label id="labDwlsitAddr"></label>
												</td>
											</tr>
											<tr>
												<th>위반사항</th>
												<td colspan="3">
													<label id="labVioltNm"></label>
												</td>
											</tr>
											<tr>
												<th>영장작성자</th>
												<td>
													<label id="labWritngNm"></label>
												</td>
												<th>영장신청일</th>
												<td>
													<div class="calendar_box mr_5 fl w_150px">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtReqstDe" name="txtReqstDe" check="text" checkName="영장신청일">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal9" class="calendarOverlay"></div>
													</div>
												</td>
											</tr>
											<tr>
												<th>체포일시</th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtArrstDt" name="txtArrstDt">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal1" class="calendarOverlay"></div>
													</div>
												</td>
											</tr>
											<tr>
												<th>체포장소</th>
												<td class="t_left" colspan="3">
													<div class="flex_r">
														<input type="text" id="txtArrstPlace" name="txtArrstPlace" class="w_100p input_com dtlRs">
														<input type="button" value="" class="btn_search" onclick="fnZipPop('txtArrstPlace')">
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								</form>
							</div>
						</div>
						<div class="box_w2_1b" style="width:calc(50% + 10px); padding-right: 0px;">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" />영장 정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box ">
								<form id="zrlongDtlForm">
								<input type="hidden" id="hiddtlCudType" 	 	name="hidCudType" />
								<input type="hidden" id="hiddtlCaseNo" 	 		name="hidCaseNo" />
								<input type="hidden" id="hiddtlTrgterSn" 		name="hidTrgterSn" />
								<input type="hidden" id="hiddtlZrlongReqstNo" 	name="hidZrlongReqstNo" />
								<div class="tb_01_box">
									<table class="tb_01_h100">
										<col width="" 		style="max-width:130px;"/>
										<col width="32%;" 	style="min-width:200px"/>
										<col width="" 		style="max-width:130px;"/>
										<col width="" />
										<tbody>
											<tr class="h_40px">
												<th>영장구분</th>
												<td>
													<c:forEach var="cd" items="${zrlongSeLst}">
														<div class='input_radio2 t_left'>
															<input class="to-labelauty-icon" type="radio" name="rdoZrlongSeCd" check="text" checkName="영장구분" value="${cd.cd}"/>
													    	${cd.cdNm}
													    </div>
													</c:forEach>
												</td>
												<th>구속영장구분</th>
												<td>
													<select name="selArsttCd" size="1" class="w_100p input_com" check="text" checkName="구속영장구분">
														<option value="">==선택하세요==</option>
														<c:forEach var="cd" items="${arsttCdLst}">
															<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
														</c:forEach>
													</select>
												</td>
											</tr>
											<tr class="h_40px">
												<th>유효일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtReqValidDt" name="txtValidDt" check="text" checkName="유효일시">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal2" class="calendarOverlay"></div>
													</div>
												</td>
												<th>구속장소</th>
												<td>
													<input type="text" name="txtImprPlace" class="w_100p input_com">
												</td>
											</tr>
											<tr class="h_40px">
												<th>구속사유</th>
												<td colspan="3">
													<div class="flex_r">
														<input type="text" name="txtImprResn" class="w_100p input_com" check="text" checkName="구속사유">
													</div>
												</td>
											</tr>
											<tr class="h_80px">
												<th>재신청 취지 및 이유</th>
												<td colspan="3" class="h100">
													<textarea name="txtRereqstResn"></textarea>
												</td>
											</tr>
											<tr class="h_40px">
												<th>인치일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtReqAttractDt" name="txtAttractDt">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal3" class="calendarOverlay"></div>
													</div>
												</td>
												<th>인치장소</th>
												<td><input type="text" name="txtAttractDt" class="w_100p input_com"></td>
											</tr>
											<tr class="h_40px">
												<th>구금일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtReqCnfnmDt" name="txtCnfnmDt">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal4" class="calendarOverlay"></div>
													</div>
												</td>
												<th>구금장소</th>
												<td>
													<input type="text" name="txtCnfnmPlace" class="w_100p input_com">
												</td>
											</tr>
											<tr class="h_80px">
												<th>필요 고려사항</th>
												<td colspan="3">
													<c:forEach var="cd" items="${NeedCnsdrLst}" varStatus="status">
														<input class="to-labelauty-icon ch_st1" type="checkbox" name="rdoNeedCnsdrCdChk" value="${cd.cd}"/>${cd.cdNm}&nbsp;
													</c:forEach>
													<br/>
													<input type="text" name="txtNeedCnsdrEtc" class="w_100p input_com mt_10"/>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								</form>
							</div>
						</div>
					</div>
				</div>
				<!---------- //신청내역  내용 --------->
				<!---------- 신청결과 내용 --------->
				<form id="rstDtlForm">
				<input type="hidden" id="hidrstCudType" 	 	name="hidCudType" />
				<input type="hidden" id="hidrstCaseNo" 	 		name="hidCaseNo" />
				<input type="hidden" id="hidrstTrgterSn" 		name="hidTrgterSn" />
				<input type="hidden" id="hidrstZrlongReqstNo" 	name="hidZrlongReqstNo" />
				<input type="hidden" id="hidrstZrlongSeCd" 		name="hidZrlongSeCd" />
				<input type="hidden" id="hidrstZrlongNoOrg" 	name="hidZrlongNoOrg" />	<!-- 기존 key 값 확인용 -->
				<input type="hidden" id="hidrstDocId" 			name="hidDocId" />  		<!-- 신청에 있는 DOC ID 복사 -->
				<div id="content2" class="tabscontent">
					<div class="box_w2 mb_20">
						<div class="box_w2_2b">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" />신청결과정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box ">
								<div class="tb_01_box">
									<table class="tb_01_h100">
										<col width="" style="max-width:130px;"/>
										<col width="" />
										<tbody>
											<tr class="h_40px">
												<th>영장번호</th>
												<td colspan="3">
													<input type="text" name="txtZrlongNo" class="input_com" style="width: 180px;" check="text" checkName="영장번호">
												</td>
											</tr>
											<tr class="h_40px">
												<th>유효일시</th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtRstValidDt" name="txtRstValidDt" check="text" checkName="유효일시">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal10" class="calendarOverlay"></div>
													</div>
													<div style="margin-top: 7px;"> 까지</div>
												</td>
											</tr>
											<tr class="h_40px">
												<th>발부일시</th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtIsueDt" name="txtIsueDt" check="text" checkName="발부일시">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal11" class="calendarOverlay"></div>
													</div>
												</td>
											</tr>
											<tr class="h_40px">
												<th>기각기관</th>
												<td colspan="3">
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoDsmsslInsttCd" /> 검찰
													</div>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoDsmsslInsttCd" /> 법원
													</div>
												</td>
											</tr>
											<tr class="h_125px" style="">
												<th rowspan="3">기각사유</th>
												<td rowspan="3" colspan="3" style="height: 205px;"> <!-- class="h180" -->
													<textarea name="txtDsmsslResn"></textarea>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<div class="box_w2_1b" style="width:calc(50% + 10px); padding-right: 0px;">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" />집행정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box ">
								<div class="tb_01_box">
									<table class="tb_01_h100">
										<col width="" style="max-width:130px;"/>
										<col width="31%;" style="min-width:200px"/>
										<col width="" style="max-width:130px;"/>
										<col width="" />
										<tbody>
											<tr>
												<th>집행구분</th>
												<td colspan="3"><div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoExcutSeCd" value="Y" /> 집행
													</div>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoExcutSeCd" value="N" />집행불능
													</div>
												</td>
											</tr>
											<tr>
												<th>집행자</th>
												<td colspan="3">
													<input type="text" name="txtExcuterId" class="input_com" style="width: 180px;">
													<input type="button" class="btn_search">
												</td>
											</tr>
											<tr>
												<th>집행일시</th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtExcutDt" name="txtExcutDt">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal5" class="calendarOverlay"></div>
													</div>
												</td>
											</tr>
											<tr>
												<th>집행장소</th>
												<td colspan="3">
													<div class="flex_r">
														<input type="text" id="txtExcutPlace" name="txtExcutPlace" class="w_100p input_com">
														<input type="button" value="" class="btn_search" onclick="fnZipPop('txtExcutPlace')">
													</div>
												</td>
											</tr>
											<tr>
												<th>인치일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtRstAttractDt" name="txtRstAttractDt">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal6" class="calendarOverlay"></div>
													</div>
												</td>
												<th>인치장소</th>
												<td><input type="text" name="txtRstAttractPlace" class="w_100p input_com"></td>
											</tr>
											<tr>
												<th>구금일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtRstCnfnmDt" name="txtRstCnfnmDt">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal7" class="calendarOverlay"></div>
													</div>
												</td>
												<th>구금장소</th>
												<td><input type="text" name="txtRstCnfnmPlace" class="w_100p input_com"></td>
											</tr>
											<tr>
												<th>석방일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 180px;">
														<input type="text" class="w_100p input_com_s datetimepicker dtlRs" id="txtRslDt" name="txtRslDt">
														<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" /></div>
														<div id="divCal8" class="calendarOverlay"></div>
													</div>
												</td>
												<th>인수자</th>
												<td>
													<input type="text" name="txtAcptrId" class="w_90p input_com">
													<input type="button" class="btn_search">
												</td>
											</tr>
											<tr>
												<th>석방사유</th>
												<td colspan="3">
													<select name="selRslResnCd" size="1" class="w_30p input_com mr_5">
														<option value="" selected>-선택-</option>
														<option value=""></option>
													</select>
													<input type="text" name="txtRslResnEtc" class="input_com" style="width:calc(70% - 5px);">
												</td>
											</tr>
											<tr>
												<th>집행불능사유</th>
												<td colspan="3">
													<div class="flex_r">
														<select name="selExcutIncpctyCd" size="1" class="w_30p input_com mr_5">
															<option value="" selected>-선택-</option>
															<option value=""></option>
														</select>
														<input type="text" name="txtExcutIncpctyEtc" class="input_com" style="width:calc(70% - 5px);">
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				</form>
				<!---------- //신청결과 내용 --------->
			</div>
		</div>
		<!-- //탭영역  -->
	</div>
</div>
<!-- //메인 탭영역  -->

