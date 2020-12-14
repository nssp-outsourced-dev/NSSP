<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">
	var docNo = '00456';
	$(function() {
		initGrid ();
		fnDatePickerImg("txtPrsctDe",null,false);
		fnHidRcNo ();
		fnDoc("","");
	});
	function fnDoc (pDocId, pParam) {
		fnReportList('ifrReport',pDocId,docNo,pParam);
	}
	function fnEnterKeyUp (event) {
		fnRemoveChar(event);
		if (event.which == 13) {
			event.keyCode = 0;
			fnSearch ();
		}
	}
	function fnHidRcNo () {
		var hid1 	= $("#searchRcNo1").val();
		var hid2 	= $("#searchRcNo2").val();
		if (!fnIsEmpty(hid1) && !fnIsEmpty(hid2) && (hid1+hid2).length > 9) {  	//내사에서 이동
			fnSearch ();
		}
	}
	function columnLayoutSub (trgterSeList, statusL, statusR) {
		return [
				{ dataField : "grdCaseNo",   	headerText : "사건번호", 			visible : false /*statusR*/ },
				{ dataField : "grdRcTrgterSn",  headerText : "접수대상자일련번호", 	visible : false },
				{ dataField : "grdCaseTrgterSn",headerText : "입건대상자일련번호", 	visible : false },
		        { dataField : "grdRcNo",   		headerText : "접수번호", 			visible : false/*statusL*/ },
		        { dataField : "grdTrgterSeCd",  headerText : "대상자구분", 		editable : false, width : 100,
		        	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
            			return gridComboLabel(trgterSeList, value)
            		}
		        },
		        { dataField : "grdTrgterNm",   	headerText : "이름", 		editable : false, width : 100 },
		        { dataField : "grdTrgterRrn",   headerText : "주민번호", 	editable : false }
		        ];
	}
	function initGrid () {
		var progrsSttusList  = [<c:forEach var="cd" items="${progrsSttusList}" varStatus="status">{"cd":"${cd.cd}","cdNm":"${cd.cdNm}"},</c:forEach>];
		var trgterSeList 	 = [<c:forEach var="cd" items="${trgterSeList}" varStatus="status">{"cd":"${cd.cd}","cdNm":"${cd.cdNm}"},</c:forEach>];
		var invProvisList 	 = [<c:forEach var="cd" items="${invProvisList}" varStatus="status">{"cd":"${cd.cd}","cdNm":"${cd.cdNm}"},</c:forEach>];
		var rcSeCdList 	 = [{"cd":'T',"cdNm":'임시'},{"cd":'I',"cdNm":'내사'},{"cd":'F',"cdNm":'정식'}];
		var columnLayout = [
				{ dataField : "grdCmptncExmnCd", 	headerText : "관할검찰", 	visible : false },
				{ dataField : "grdCrmnlFact",   	headerText : "범죄사실", 	visible : false },
				{ dataField : "grdDocId",   		headerText : "파일ID", 	visible : false },
                { dataField : "grdRcSeCd",   		headerText : "구분", 	  	editable : false, width : 60,
                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
            			return gridComboLabel(rcSeCdList, value)
            		}
				},
            	{ dataField : "grdRcWritngDt",  	headerText : "접수일자", 	editable : false, dataType : "date", formatString : "yyyy-mm-dd hh:MM" },  		/*접수 테이블 등록일자 가져옴*/
                { dataField : "grdRcNo",     		headerText : "접수번호", 	editable : false },		/*RC_TMPR*/
                { dataField : "grdPrsctDe",   		headerText : "입건일자", 	dataType : "date",  editable : false, formatString : "yyyy-mm-dd",
                	/* editRenderer : calendarRenderer,
                	editable : true */
                },
                { dataField : "grdAditPrsctId",  headerText : "추가입건ID", visible : false },
                { dataField : "grdCaseNo",     	 headerText : "사건번호", editable : false },
                { dataField : "grdTrgterS",   	 headerText : "피의자명", editable : false },
                { dataField : "grdTrgterV",   	 headerText : "피해자명", editable : false },
                { dataField : "grdProgrsSttusCd",headerText : "진행상태", editable : false,
                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
            			return gridComboLabel(progrsSttusList, value)
            		}
                }];
		var gridPros = {
			rowNumHeaderText:"순번",
			selectionMode : "singleCell",	// 선택모드 (기본값은 singleCell 임)
			//noDataMessage:"조회 목록이 없습니다.",
			fillColumnSizeMode:true,
			softRemoveRowMode : false,	/*삭제처리 모드*/
			showRowCheckColumn : true,
			headerHeight : 30,
			rowHeight: 30
		};
		var gridProsR = $.extend({
			// 전체 체크박스 표시 설정
			showRowAllCheckBox : false,
			rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
				if(!fnIsEmpty(item.grdCaseNo)) { // 체크박스 disabeld 처리함
					return false; // false 반환하면 disabled 처리됨
				}
				return true;
			}
		}, gridPros);
		AUIGrid.create("#gridL_wrap",  columnLayoutSub (trgterSeList, true, false), gridPros);
		AUIGrid.create("#gridR_wrap",  columnLayoutSub (trgterSeList, false, true), gridProsR);
		AUIGrid.create("#grid_wrap",   columnLayout,  	gridPros);

		AUIGrid.bind("#grid_wrap", "cellDoubleClick", function(event) {
			var items = event.item;
			fnDetailList (items);
		});
		AUIGrid.bind("#grid_wrap", "ready", function(event) {
			var gdt = AUIGrid.getGridData(event.pid);
			if(gdt.length > 0) {
				fnSelOne (event.pid, gdt);
			}
		});
	}
	function fnSelOne (grd,gdt) {
		if(gdt.length > 0) {
			AUIGrid.setSelectionByIndex(grd, 0, 5);  //최초 선택된 row 자동 상세 조회
			fnDetailList (gdt[0]);
		} else {
			fnReset ();
		}
	}
	function fnDetailList (items) {
		fnReset ();
		fn_form_bind ("dtlForm",items,"GRID"); //dtl
		fnSearchGrid("/inv/rcTmprTrgterListAjax/","dtlForm", "#gridL_wrap"); //관리 대상자, 입견 대상자 조회
		fnSearchGrid("/inv/prsctAditTrgterListAjax/", "dtlForm", "#gridR_wrap");
		//doc
		if(!fnIsEmpty(items.grdAditPrsctId) && !fnIsEmpty(items.grdDocId)) {
			fnDoc(items.grdDocId,"P_ADIT_PRSCT_ID="+items.grdAditPrsctId);
		} else {
			fnDoc("","");
		}
	}
	function fnReset () {
		AUIGrid.setGridData("#gridL_wrap", []);
		$('#dtlForm').clearForm([""]);
	}
	function prscrKeyCheck(msg) {
		//key가 empty면 return
		var key1 = $('#dtlForm').find('#hidRcNo').val();
		var key2 = $('#dtlForm').find('#hidCaseNo').val();
		if(fnIsEmpty($.trim(key1))) {    //접수번호는 반드시 필요!!, caseNo는 없을 수 있음.
			alert("조회된 접수목록을 더블클릭 후 " + msg);
			return false;
		}
		return true;
	}
	function btnSaveSend (pProgrsSttusCd) {
		//대표 접수 건 확인
		if(!prscrKeyCheck("저장해 주세요.")) return;
		//접수전체목록
		var data = {};
		var mainLst = AUIGrid.getGridData("#grid_wrap");
		if(mainLst.length < 1) {
			alert("저장하려는 접수번호를 확인하여 주십시오.");
			return;
		}
		data.grdMainList = mainLst;
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
		var rSave = fnAjaxAction('/inv/savePrsct/', JSON.stringify (data));
		if(!fnIsEmpty(rSave) ) {
			if(!fnIsEmpty(rSave["ERROR"])) {
				alert(rSave["ERROR"]);
				return;
			}
			if(pProgrsSttusCd=="00222") {
				alert("승인요청되었습니다.");
			} else {
				alert("저장되었습니다.")
			}
			//alert(JSON.stringify (rSave))
			if( !fnIsEmpty(rSave["caseNo"]) ) {
				var arrCaseNo = rSave["caseNo"].split("-");
				if(arrCaseNo.length > 1) {
					$("#searchForm").find("#searchCaseNo1").val(arrCaseNo[0]);
					$("#searchForm").find("#searchCaseNo2").val(arrCaseNo[1]);
					fnSearch ();
				}
			} else if ( !fnIsEmpty(rSave["rcNo"]) ) {
				var arrRcNo = rSave["rcNo"].split("-");
				if(arrRcNo.length > 1) {
					$("#searchForm").find("#searchRcNo1").val(arrRcNo[0]);
					$("#searchForm").find("#searchRcNo2").val(arrRcNo[1]);
					fnSearch ();
				}
			}
			fnReset ();
		}
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
				AUIGrid.addRow(rGrid, uniqueAdd(items, rItm, "grdTrgterRrn"), 'last');  /*주민번호로 중복 체크*/
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
				AUIGrid.addRow(lGrid, uniqueAdd(items, lItm, "grdTrgterRrn"), 'last');
				AUIGrid.removeCheckedRows(rGrid);
			} else
				alert("선택된 대상자가 없습니다.");
			break;
		}
	}
	function fnSearch () {
		if( (fnIsEmpty($("#searchCaseNo1").val())||fnIsEmpty($("#searchCaseNo2").val())) &&
			(fnIsEmpty($("#searchRcNo1").val())||fnIsEmpty($("#searchRcNo2").val())) ) {
			alert ("사건번호 또는 접수번호가 누락되어 조회할 수 없습니다.");
			$("#searchCaseNo1").focus();
			return;
		}
		fnMainFind ("searchForm");
	}
	function fnMainFind (form) {
		fnSearchGrid("/inv/rcPrsctListAjax/", form, "#grid_wrap");
	}
	function btnSave () {
		btnSaveSend ('00221');  /*입건작성*/
	}
	function btnPrsct () {
		//기본 입력 내용
		if(!fnFormValueCheck("dtlForm")) return;
		if(confirm("해당 접수를 승인 요청 하시겠습니까?")) {
			//서류가 작성 되었는지?
			btnSaveSend ('00222');	/*입건승인요청*/
		}
	}
	function btnPrsctCmpl () {
		if(!prscrKeyCheck("승인요청해주세요.")) return;
		//승인 test
		var strSanctn = $("#dtlForm").find("#hidSanctnId").val();
		if( !fnIsEmpty(strSanctn) ) {
			var rSave = fnAjaxAction('/inv/savePrsctCmpl/', JSON.stringify ({sList:[strSanctn]}));
			if( !fnIsEmpty(rSave) ) {
				var arrCaseNo = rSave.split("-");
				if(arrCaseNo.length > 1) {
					$("#searchForm").find("#searchCaseNo1").val(arrCaseNo[0]);
					$("#searchForm").find("#searchCaseNo2").val(arrCaseNo[1]);
					fnSearch ();
				}
			}
		} else {
			alert("승인요청이 되지 않은 접수건 입니다.");
		}
	}
	function btnCancel () {
		//요청취소
		if(confirm("입건 완료 이전 접수에 대해서만 취소요청하실 수 있습니다.\n\n 진행하시겠습니까?")) {
			var gData = AUIGrid.getGridData("#grid_wrap");
			var cLst = [];
			var sLst = [];
			if(!fnIsEmpty(gData)) {
				if( fnIsEmpty(gData[0].grdCaseNo) && !fnIsEmpty(gData[0].grdAditPrsctId) ) {
					cLst.push(gData[0]);
					sLst.push(gData[0].grdAditPrsctId);
				}
				if(fnIsEmpty(cLst)) {
					alert("취소할 수 있는 접수 건이 없습니다.");
				} else {
					var rSave = fnAjaxAction('/inv/cancelAditPrsct/', JSON.stringify ({sList:sLst, cList:cLst}));
					if( !fnIsEmpty(rSave) ) {
						if(!fnIsEmpty(rSave["ERROR"])) {
							alert(rSave["ERROR"]);
						} else {
							alert("승인 요청이 취소 되었습니다.");
						}
					} else {
						alert("승인 요청 취소 오류 발생");
					}
					AUIGrid.setGridData("#gridL_wrap", []);
					AUIGrid.setGridData("#gridR_wrap", []);
					AUIGrid.setGridData("#grid_wrap", []);
					$('#dtlForm').clearForm([]);
					fnSearch ();
				}
			} else {
				alert("취소할 수 있는 접수 건이 없습니다.");
			}
		}
	}
	function btnLstDtl () {
		if(!prscrKeyCheck("상세보기 버튼을 클릭하여 주십시오.")) return;
		var prsctDtlPopup =
			dhtmlmodal.open('prsctDtlPopup', 'iframe',
 							'/inv/prsctDtlPopup/?hidCaseNo='+$("#dtlForm").find("#hidCaseNo").val(),
 					        '정식접수승인취소', 'width=800px,height=580px,center=1,resize=0,scrolling=0');
	}
	function btnPrsctPop () {
		var prsctPopup =
			dhtmlmodal.open('prsctPopup', 'iframe',
 							'/inv/prsctPopup/?hidCaseNo='+$("#dtlForm").find("#hidCaseNo").val()+'&hidRcNo='+$("#dtlForm").find("#hidRcNo").val(),
 					        '사건승인요청', 'width=1000px,height=700px,center=1,resize=0,scrolling=0');
	}
</script>
<div class="search_box mb_10">
	<form id="searchForm">
		<div class="search_in">
			<div class="stitle w_80px">사건번호</div>
			<div class="r_box">
				<input type="text" class="w_100px input_com " id="searchCaseNo1" name="searchCaseNo1" onkeyup="fnRemoveChar(event)"> -
				<input type="text" class="w_100px input_com " id="searchCaseNo2" name="searchCaseNo2" onkeyup="fnEnterKeyUp(event)">
			</div>
		</div>
		<div class="search_in">
			<div class="stitle w_80px">접수번호</div>
			<div class="r_box">
				<input type="text" class="w_100px input_com " id="searchRcNo1" name="searchRcNo1" onkeyup="fnRemoveChar(event)" value="${hidRcNo1}"> -
				<input type="text" class="w_100px input_com " id="searchRcNo2" name="searchRcNo2" onkeyup="fnEnterKeyUp(event)" value="${hidRcNo2}">
			</div>
		</div>
	</form>
	<form id="sendForm">
		<input type="hidden" id ="hidsearchRcNo" name="hidsearchRcNo" value="${hidRcNo}"/> 	<!-- 값이 하나니까.. ex)2019-000001 -->
	</form>
	<div class="go_search2" onclick="fnSearch()">검색</div>
</div>
<div class="box_w2 mb_10">
	<div class="box_w2_1b" style="width:calc(60% + 40px);">
		<div class="title_s_st3 w_100p mt_5">
			<img src="/img/icon_error.png" alt="" />범죄인지서, (붙임)범죄인지보고서 작성 후 입건처리 하시기 바랍니다.
		</div>
		<div class="com_box">
			<div class="title_s_st2 w_150px fl">
				<img src="/img/title_icon1.png" alt="" />접수목록
			</div>
			<div class="right_btn fr mb_10" id="tab_btn1">
				<a href="#" onClick="btnLstDtl(); return false" class="btn_st2_2 icon_n fl mr_m1">사건상세조회</a>
				<a class="btn_st1 icon_n fl mr_m1" onclick="btnSave(); return false">저장</a>
				<!-- <a class="btn_st2 icon_n fl mr_m1" onclick="">범죄인지서작성</a> -->
				<a class="btn_st2_2 icon_n fl mr_m1" onclick="btnCancel(); return false">요청취소</a>
				<a class="btn_st1 icon_n fl mr_5" onclick="btnPrsct(); return false">입건</a>
				<a class="btn_st1 icon_n fl mr_m1 " onclick="btnPrsctCmpl(); return false">입건승인</a>
				<a class="btn_st1 icon_n fl mr_m1" onclick="btnPrsctPop(); return false">사건승인팝업</a>
			</div>
		</div>
		<div class="com_box">
			<div id="grid_wrap" class="gridResize tb_01_box" style="width: 100%; height: 220px; float: left; margin-bottom: 15px;"></div>
		</div>
	</div>
	<!-- 작성문서목록 -->
	<div class="box_w2_2b mt_40" style="width:calc(40% - 40px);">
		<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="270px"></iframe>
	</div>
</div>
<form id="dtlForm">
	<input type="hidden" id="hidAditPrsctId" name="hidAditPrsctId" />
	<input type="hidden" id="hidSanctnId" name="hidSanctnId" />
	<input type="hidden" id="hidRcNo" name="hidRcNo" />
	<input type="hidden" id="hidCaseNo" name="hidCaseNo" />
	<input type="hidden" id="hidEditYn" name="hidEditYn"/>
	<div class="mb_20 mt_10 fl" style="width: 70%">
		<!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
		<div class="box_w3_1">
			<div class="title_s_st2 w_50p fl">
				<img src="/img/title_icon1.png" />관리대상자
			</div>
			<div class="com_box">
				<div id="gridL_wrap" class="gridResize tb_01_box" style="width: 100%; height: 250px;"></div>
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
				<img src="/img/title_icon1.png" />입건대상자
			</div>
			<div class="com_box">
				<div id="gridR_wrap" class="gridResize tb_01_box" style="width: 100%; height: 250px;"></div>
			</div>
		</div>
	</div>
	<div class="fl mt_10 mb_20 ml_20" style="width:calc(30% - 20px);">
		<!-- <div class="box_w3_1"> -->
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
									<div class="calendar_box  w_100p  mr_5">
										<input type="text" class="w_100p input_com calendar" id="txtPrsctDe"  name="txtPrsctDe" check = "text" checkName = "입건일자">
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
											<option value="${cd.exmnCd}"><c:out value="${cd.exmnNm}" /></option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr style="height: 170px">
								<th>범죄사실</th>
								<td class="t_left" colspan="3">
									<textarea id="txtCrmnlFact" name="txtCrmnlFact" check = "text" checkName = "범죄사실"></textarea>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		<!-- </div> -->
	</div>
</form>

