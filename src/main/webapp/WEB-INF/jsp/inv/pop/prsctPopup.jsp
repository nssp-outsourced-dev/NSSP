<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp" />

<script type="text/javascript">
	var docNo = '00456';
	$(function() {
		initGrid ();
		fnDatePickerImg("txtPrsctDe",'${dtl.prsctDe}',false);
		fnSearch();
		fnBtnSet ();
	});
	function fnBtnSet () {
		var pStatus = $("#hidPstatus").val();
		if (pStatus == 'A') {
			$("#btnAditPrsct").show();
			$("#btnAditSave").show();
		} else if (pStatus == "I") {
			$("#btnCancel").show();
		} else if (pStatus != 'E') {
			$("#btnAditPrsct").show();
			$("#btnCancel").show();
			$("#btnAditSave").show();
		} else {
			$("#btnAditSave").show();
		}
	}
	function fnDoc (pDocId, pParam) {
		fnReportList('ifrReport',pDocId,docNo,pParam);
	}
	function columnLayoutSub (statusL, statusR) {
		var trgterSeList = [<c:forEach var="cd" items="${trgterSeList}" varStatus="status">{"cd":"${cd.cd}","cdNm":"${cd.cdNm}"},</c:forEach>];
		return [
				{ dataField : "grdCaseNo",   	headerText : "사건번호", 			visible : false, editable : false /*statusR*/ },
				{ dataField : "grdRcTrgterSn",  headerText : "접수대상자일련번호", 	visible : false, editable : false },
				{ dataField : "grdCaseTrgterSn",headerText : "입건대상자일련번호", 	visible : false, editable : false },
		        { dataField : "grdRcNo",   		headerText : "접수번호", 			visible : false, editable : false/*statusL*/ },
		        { dataField : "grdTrgterSeCd",  headerText : "대상자구분", 		width : 100,
		        	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
	        			return gridComboLabel(trgterSeList, value)
	        		},
	        		editRenderer : {
        				type : "DropDownListRenderer",
        				list : trgterSeList,
        				keyField : "cd", // key 에 해당되는 필드명
        				valueField : "cdNm" // value 에 해당되는 필드명
	        		}
		        },
		        { dataField : "grdTrgterNm",   	headerText : "이름", 		editable : false, width : 100 },
		        { dataField : "grdTrgterRrn",   headerText : "주민번호", 	editable : false },
		        { dataField : "grdSelKey",   	headerText : "이동KEY",  visible : false, editable : false }
		        ];
	}
	function initGrid () {
		var gridPros = {
			rowNumHeaderText:"순번",
			selectionMode : "singleCell",	// 선택모드 (기본값은 singleCell 임)
			noDataMessage:"조회 목록이 없습니다.",
			fillColumnSizeMode:true,
			softRemoveRowMode : false,	/*삭제처리 모드*/
			showRowCheckColumn : true,
			headerHeight : 30,
			rowHeight: 30
		};
		var gridProsR = $.extend({
			// 전체 체크박스 표시 설정
			showRowAllCheckBox : false,
			editable:true,
			rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
				if(!fnIsEmpty(item.grdCaseNo)) { // 체크박스 disabeld 처리함
					return false; // false 반환하면 disabled 처리됨
				}
				return true;
			}
		}, gridPros);
		AUIGrid.create("#gridL_wrap",  columnLayoutSub (true, false), gridPros);
		AUIGrid.create("#gridR_wrap",  columnLayoutSub (false, true), gridProsR);
	}
	function fnSearch () {
		fnSearchGrid("/inv/rcTmprTrgterListAjax/","dtlForm", "#gridL_wrap"); //관리 대상자, 입견 대상자 조회
		fnSearchGrid("/inv/prsctAditTrgterListAjax/", "dtlForm", "#gridR_wrap");
		//doc
		if(!fnIsEmpty($("#hidAditPrsctId").val()) && !fnIsEmpty($("#hidDocId").val())) {
			fnDoc($("#hidDocId").val(),"P_ADIT_PRSCT_ID="+$("#hidAditPrsctId").val());
		} else {
			fnDoc("","");
		}
	}
	function prscrKeyCheck() {
		//key가 empty면 return
		var key1 = $('#dtlForm').find('#hidRcNo').val();
		var key2 = $('#dtlForm').find('#hidCaseNo').val();
		if(fnIsEmpty($.trim(key1))) {    //접수번호는 반드시 필요!!, caseNo는 없을 수 있음.
			alert("접수번호를 확인할 수 없습니다. \n\n접수번호를 다시 확인하여 주십시오.");
			return false;
		}
		return true;
	}
	function btnSaveSend (pProgrsSttusCd) {
		//접수전체목록
		var data = {};
		//대상
		var trgterG = AUIGrid.getGridData("#gridR_wrap");
		if(trgterG.length < 1) {
			alert("대상자를 지정하여 주십시오.");
			return;
		}
		//상세보기 내용
		data.dtl = $('#dtlForm').serializeFormJSON();
		/*진행상태*/
		data.dtl["hidProgrsSttusCd"] = pProgrsSttusCd;
		/*대상*/
		if(trgterG.length > 0) {
			var fTrgter = [];
			for(var i in trgterG) {
				if(fnIsEmpty(trgterG[i].grdCaseNo)) {
					fTrgter.push(trgterG[i]);
				}
			}
			if(fTrgter.length > 0) {
				data.grdTrgter = trgterG;
			}
		}
		var rSave = fnAjaxAction('/inv/savePrsctAjax/', JSON.stringify (data));
		if(!fnIsEmpty(rSave) ) {
			if(!fnIsEmpty(rSave["ERROR"])) {
				alert(rSave["ERROR"]);
				return;
			}
			if(pProgrsSttusCd=='00221') {
				alert("사건정보가 저장되었습니다.");
			} else {
				alert("승인요청되었습니다.");
			}
			if( !fnIsEmpty(rSave["caseNo"]) ) {
				$('#dtlForm').find('#hidCaseNo').val(rSave["caseNo"]);
				fnSubmit();
			} else if ( !fnIsEmpty(rSave["rcNo"]) ) {
				$('#dtlForm').find('#hidRcNo').val(rSave["rcNo"]);
				fnSubmit();
			} else {
				alert("ERROR");
			}
		}
	}
	function fnSubmit () {
		$('#dtlForm').attr('action', '<c:url value='/inv/prsctPopup/'/>');
		$('#dtlForm').submit();
	}
	/*btn event*/
	function btnMove (type) {
		if(!prscrKeyCheck("이동해주세요.")) return;
		var lGrid = "#gridL_wrap";
		var rGrid = "#gridR_wrap";
		switch (type) {
		case 1:
			//오른쪽 grid
			var lChckItm = AUIGrid.getCheckedRowItems(lGrid);
		    var rItm = AUIGrid.getGridData(rGrid);
			if(lChckItm.length > 0) {
				var items = [];
				for(var i in lChckItm) {
					items.push(lChckItm[i].item);
				}
				AUIGrid.addRow(rGrid, uniqueAdd(items, rItm, "grdSelKey"), 'last');  /*주민번호로 중복 체크*/
				AUIGrid.removeCheckedRows(lGrid);
			} else
				alert("선택된 대상자가 없습니다.");
			break;
		default:
			var rChckItm = AUIGrid.getCheckedRowItems(rGrid);
		    var lItm = AUIGrid.getGridData(lGrid);
			if(rChckItm.length > 0) {
				var items = [];
				for(var i in rChckItm) {
					items.push(rChckItm[i].item);
				}
				AUIGrid.addRow(lGrid, uniqueAdd(items, lItm, "grdSelKey"), 'last');
				AUIGrid.removeCheckedRows(rGrid);
			} else
				alert("선택된 대상자가 없습니다.");
			break;
		}
	}
	function btnAditPrsct () {
		if(!prscrKeyCheck()) return;				//접수 건 확인
		if(!fnFormValueCheck("dtlForm")) return;	//기본 입력 내용
		btnSaveSend ('00222');	/*입건승인요청*/
	}
	function btnAditSave () {
		if(!prscrKeyCheck()) return;				//접수 건 확인
		if(!fnFormValueCheck("dtlForm")) return;	//기본 입력 내용
		btnSaveSend ('00221');	/*입건승인요청*/
	}
	function btnCancel () {
		//요청취소
		if(confirm("입건 완료 이전 접수에 대해서만 취소요청하실 수 있습니다.\n\n 진행하시겠습니까?")) {
			var sLst = [];
			if( fnIsEmpty($("#hidCaseNo").val()) && !fnIsEmpty($("#hidAditPrsctId").val()) && !fnIsEmpty($("#hidSanctnId").val()) ) {
				sLst.push($("#hidAditPrsctId").val());
			}
			if(fnIsEmpty(sLst)) {
				alert("취소할 수 있는 접수 건이 없습니다.");
			} else {
				var rSave = fnAjaxAction('/inv/cancelAditPrsctAjax/', JSON.stringify ({sList:sLst}));
				if( !fnIsEmpty(rSave) ) {
					if(!fnIsEmpty(rSave["ERROR"])) {
						alert(rSave["ERROR"]);
					} else {
						alert("입건 요청이 취소 되었습니다.");
						fnClose();
					}
				} else {
					alert("입건 요청 취소 오류 발생");
				}
			}

		}
	}
	function fnClose() {
		parent.prsctPopup.hide();
	}
	/*임시 승인*/
	function btnPrsctCmpl () {
		//승인 test
		var hidPrId = $("#hidAditPrsctId").val();
		var sanctnLst = [];
		if(!fnIsEmpty(hidPrId)) {
			sanctnLst.push(hidPrId);
			if(sanctnLst.length > 0) {
				var rSave = fnAjaxAction('/inv/savePrsctCmplAjax/', JSON.stringify ({sList:sanctnLst}));
				alert("승인되었습니다.");
				if( !fnIsEmpty(rSave) ) {
					$('#dtlForm').find('#hidCaseNo').val(rSave);
					fnSubmit();
				} else {
					alert("ERROR");
				}
			}
		} else {
			alert("error");
		}
	}
</script>
</head>
<body>
<div class="popup_body">
<form id="dtlForm">
	<input type="hidden" id="hidAditPrsctId" name="hidAditPrsctId" value="${dtl.aditPrsctId}"/>
	<input type="hidden" id="hidSanctnId" name="hidSanctnId" value="${dtl.sanctnId}"/>
	<input type="hidden" id="hidDocId" name="hidDocId" value="${dtl.docId}"/>
	<input type="hidden" id="hidCaseNo" name="hidCaseNo" value="${dtl.caseNo}"/>
	<input type="hidden" id="hidRcNo" name="hidRcNo" value="${dtl.rcNo}"/>
	<input type="hidden" id="hidPstatus" name="hidPstatus" value="${dtl.progStatus}"/>
	<div class="search_box">
		<div class="search_in" style="border-right:0px">
			<div class="stitle w_80px">사건번호</div>
			<input type="text" class="w_150px input_com" id="txtViewCaseNo" name="txtViewCaseNo" value="${dtl.caseNo}" disabled="disabled">
		</div>
		<div class="search_in" style="border-right:0px">
			<div class="stitle w_80px">접수번호</div>
			<input type="text" class="w_150px input_com" id="txtViewRcNo" name="txtViewRcNo" value="${dtl.rcNo}" disabled="disabled">
		</div>
	</div>

	<div class="w_100p">
		<div class="title_s_st3 w_100p mt_5">
			<img src="/img/icon_error.png" alt="" />범죄인지서, (붙임)범죄인지보고서 작성 후 입건처리 하시기 바랍니다.
			<div class="right_btn fr" id="tab_btn1">
				<a class="btn_st1 icon_n fl mr_m1" id="btnAditSave" onclick="btnAditSave(); return false" style="display: none;">사건정보저장</a>
				<a class="btn_st1 icon_n fl mr_m1" id="btnAditPrsct" onclick="btnAditPrsct(); return false" style="display: none;">승인요청</a>
				<a class="btn_st1 icon_n fl mr_m1" id="btnCancel" onclick="btnCancel(); return false" style="display: none;">요청취소</a>

				<!-- <a class="btn_st2_2 icon_n fl ml_5" id="btnCmplSave" onclick="btnPrsctCmpl(); return false">임시승인완료</a> -->
			</div>
		</div>
	</div>

	<div class="box_w3_1">
		<div class="title_s_st2 w_50p fl">
			<img src="/img/title_icon1.png" />관리대상자
		</div>
		<div class="com_box">
			<div id="gridL_wrap" class="gridResize tb_01_box" style="width: 100%; height: 220px;"></div>
		</div>
	</div>
	<div class="box_w3_2 mt_100">
		<div class="btn_box">
			<img src="/img/ar_r.png" id="btnL" onclick="btnMove(1)"/>
		</div>
		<div class="btn_box">
			<img src="/img/ar_l.png" id="btnR" onclick="btnMove(2)"/>
		</div>
	</div>
	<div class="box_w3_3">
		<div class="title_s_st2 w_50p fl">
			<img src="/img/title_icon1.png" />사건대상자
		</div>
		<div class="com_box">
			<div id="gridR_wrap" class="gridResize tb_01_box" style="width: 100%; height: 220px;"></div>
		</div>
	</div>

	<div class="box_w2 mb_10 mt_20">
		<div class="box_w2_2b mt_10">
			<div class="com_box">
				<div class="title_s_st3">
					<img src="/img/icon_error.png" alt="" />범죄사실을 입력하세요.
				</div>
			</div>
			<div class="com_box ">
				<div class="tb_01_box">
					<table class="tb_01_h100">
						<caption>
						<h4>입건 상세정보</h4>
						</caption>
						<colgroup>
						<col width="20%"/>
						<col width=""/>
						</colgroup>
						<tbody>
							<tr>
								<th>입건일자</th>
								<td>
									<div class="calendar_box mr_5 fl" style="width: 150px">
										<input type="text" class="w_100p input_com calendar" id="txtPrsctDe"  name="txtPrsctDe" check="text" checkName="입건일자">
										<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
									</div>
								</td>
							</tr>
							<tr>
								<th>관할검찰</th>
								<td>
									<select name="selCmptncExmnCd" id="selCmptncExmnCd" size="1" class="w_100p input_com" check = "text" checkName = "관할검찰">
										<option value="">====선택하세요=====</option>
										<c:forEach var="cd" items="${exmnList}">
											<option value="${cd.exmnCd}" <c:if test="${dtl.cmptncExmnCd eq cd.exmnCd}">selected</c:if>><c:out value="${cd.exmnNm}" /></option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr style="height: 100px">
								<th>범죄사실</th>
								<td class="t_left" colspan="3">
									<textarea id="txtCrmnlFact" name="txtCrmnlFact" check = "text" checkName = "범죄사실">${dtl.crmnlFact}</textarea>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="box_w2_2b">
			<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="235px"></iframe>
		</div>

	</div>

	<!-- 작성문서목록 -->
	<div class="box_w2_2b mt_40">
	</div>
</form>
</div>
</body>