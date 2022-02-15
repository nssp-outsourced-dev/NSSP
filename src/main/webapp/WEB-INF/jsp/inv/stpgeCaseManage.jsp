<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<title>긴급체포/현행범인체포관리</title>
<style type="text/css">
.tbLft {
	text-align: left;
}
.my_grd_btn {
    color: #fff !important;
    background: url("/img/icon_search.png");
    background-position: center center;
    background-repeat: no-repeat;
    font-weight: bold;
    margin: 2px 10px;
    padding : 10px 10px;
    line-height:2em;
    cursor: pointer;
    float: right;
}

	/*
		2021.08.11
		coded by dgkim
		수사시스템 화면 비율 조정
		권종열 사무관 요청
	*/
	#gridT1_wrap, #gridT2_wrap { height: 152px !important; } /* 사건목록 */
	#showinbox { height: 190px !important; } /* 사건목록 영역 */
</style>
<script type="text/javascript">
	//var docNo = "00446";
	var docNo2 = "00461";
	var docNo3 = "00462";
	$(function() {
		fnTopLst ();
		fnDatePickerImg("txtArrstDt",null,false);
		fnDatePickerImg("txtAttractDt",null,false);
		fnDatePickerImg("txtCnfnmDt",null,false);
		fnDatePickerImg("txtUndtakeDt",null,false);
		fnDatePickerImg("txtRslDt",null,false);
		fnDatePickerImg("txtDecsnDe",null,false);
		fnDatePickerImg("txtDscvryDe",null,false);
		fnDatePickerImg("txtDscvryReportDe",null,false);
		fnDatePickerImg("txtInvResmptDe",null,false);
		$("#hidSelTabId").val("stprsc");//$("#hidSelTabId").val("arrst");

		//fnDoc ('ifrReport',"",docNo,"","");
		fnDoc ('ifrReport2',"",docNo2,"","");

		/* $('#txtEmrgncyArrstResn').keyup(function(){
			fnLimitString('txtEmrgncyArrstResn', 2000, 'txtEmrgncyArrstResnMsg');
		});
		$('#txtEmrgncyArrstResn').keyup(); */

		initGrid ();
		fnTab (0,2);
		//S:기소중지, R:참고인중지, A:체포
		fnSendKey ('${hidRcNo}', '${hidTrgterSn}', '${hidPageType}', '${hidArrstTyCd}');

		$("#chkSrccrmRelisYn").change(function(){
			if($(this).is(":checked")) {
				//지명수배 해제 요구서 생성
				var processAfterGet = function (data) {
					//alert("chk::"+JSON.stringify(data));
					if(parseInt(data.D_IN) > 0) {
						if(parseInt(data.D_OUT) < 1) {
							if(confirm("지명수배 해제 요구서가 등록되지 않았습니다.\n\n지명수배 해제 요구서를 생성하시겠습니까?")) {
								$('#ifrReport2').contents().find("#selReportAdd").val("00000000000000000258^Y");
								$('#ifrReport2')[0].contentWindow.fnReportAdd();
							}
						}
					} else {
						alert ("지명수배 입력요구서가 등록되지 않았습니다.");
						$("#chkSrccrmRelisYn").prop("checked", false);
						return;
					}
				};
				var param = "hidRcNo="+$("#hidDscvryRcNo").val() + "&hidTrgterSn="+$("#hidDscvryTrgterSn").val();
				var ajaxUrl = "<c:url value='/inv/getStpDocChkAjax/'/>";
				Ajax.getJson(ajaxUrl, param, processAfterGet);
			}
		});
	});
	function fnTab(num, tabCnt){
		var num      = num||0;
		var menu     = $("#mTab_box").children().children();
		var tabList  = $("#mTab_list").children();  //ifrTab1
		var select   = $(menu).eq(num);
		var i        = num;
		
		menu.click(function(){
			if(select !== null){
				select.removeClass("current");
				//tabList.eq(i).hide();
			}
			select = $(this);
			i = $(this).index();
			select.addClass("current");
			$("#hidSelTabId").val(select.prop("id"));
			if(i==2) tabList.eq(1).show();
			else tabList.eq(i).show();
			
			
			if(fnIsEmpty($("#searchRcNo").val())) {
				AUIGrid.clearGridData("#gridT1_wrap");
				AUIGrid.clearGridData("#gridT2_wrap");
			}

			/* switch(i) {
				case 0:
					//$("#searchRcNo").val($("#arrstForm").find("#hidsearchRcNo").val());
					//$("#searchTrgterSn").val($("#arrstForm").find("#hidsearchTrgterSn").val());
					fnT1Search(); //사건 쿼리 재조회
					AUIGrid.resize("#gridR_wrap");
					break;
				case 1:
					$("#trSrccYn").show();
					$("#trDscvryDc").css("height","80px");
					AUIGrid.resize("#grid_stprsc_rst");
					fnReset2(0);
					break;
				case 2:
					$("#trSrccYn").hide();
					$("#trDscvryDc").css("height","100px");
					AUIGrid.resize("#grid_stprsc_rst");
					fnReset2(0);
					break;
			} */
			switch(i) {
				case 0:
					$("#trSrccYn").show(0, function(){
						$(this).parent("tbody").find("th").css("width", "120px");
					});
					$("#trDscvryDc").css("height","80px");
					AUIGrid.resize("#grid_stprsc_rst");
					fnReset2(0);
					break;
				case 1:
					$("#trSrccYn").hide(0, function(){
						$(this).parent("tbody").find("th").css("width", "120px");
					});
					$("#trDscvryDc").css("height","100px");
					AUIGrid.resize("#grid_stprsc_rst");
					fnReset2(0);
					break;
			}
		});
	}
	function fnTopLst () {
		$("#show").click(function(){
	        $("#showinbox").show();
			 $("#show").hide();
			 $("#hide").show();
			 AUIGrid.resize("#gridT1_wrap");
			 AUIGrid.resize("#gridT2_wrap");
	    });
	    $("#hide").click(function(){
	        $("#showinbox").hide();
			 $("#show").show();
			 $("#hide").hide();
	    });
	}
	function fnDoc (pId, pDocId, pDocNo, pParam, pFileId) {
		fnReportList(pId,pDocId,pDocNo,pParam,pFileId);
	}
	function fnSetRow (gId, gCol, gVal, gPos) {
		var rows = AUIGrid.getRowIndexesByValue(gId,gCol,gVal);
		AUIGrid.setSelectionByIndex(gId, rows[0], gPos);
		return rows[0];
	}
	function fnSendKey (pRcNo, pTrSn, pPageType, pArrstTyCd) {
		if(!fnIsEmpty(pRcNo) && !fnIsEmpty(pArrstTyCd)) {
			$("#searchRcNo").val(pRcNo);
			$("#searchTrgterSn").val(pTrSn);
			$("#searchPageType").val(pPageType);
			$("#searchArrstTyCd").val(pArrstTyCd);

			if(pPageType == "S") {
				$("#stprsc").click ();
			} else if (pPageType == "R") {
				$("#refe").click ();
			} else {
				fnT1Search();
			}
		} else {
			fnT1Search();
		}
	}
	function initGrid () {
		var cdArr = ["00102","00759","00731"];
		var cdLst = fnAjaxAction2({txtUpCd:cdArr});
		var trgterSeList   = getCodeList (cdLst, cdArr[0]);
		var arresterSeList = getCodeList (cdLst, cdArr[1]);
		var arrstTyList	   = getCodeList (cdLst, cdArr[2]);
		var sugestResultList = [{"cd":"Y","cdNm":"가"},{"cd":"N","cdNm":"부"},{"cd":"E","cdNm":"비고"}];
		var columnLayoutT1 = [
					{ dataField : "grdCaseNo",      headerText : "사건번호", 	width : 120,
						renderer : {type : "TemplateRenderer"},
						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
							return fnChangeNo (value);
						}
					},
					{ dataField : "grdRcNo",      	headerText : "접수번호", 	width : 120, visible : false },
					{ dataField : "grdPrsctDe",   	headerText : "입건일자", 	width : 130, dataType : "date", formatString : "yyyy-mm-dd"},
					{ dataField : "grdInvProvisNm",	headerText : "수사단서",	width : 100 },
					{ dataField : "grdTrgterNmS",	headerText : "피의자",  	width : 120 },
	   				{ dataField : "grdVioltNm",		headerText : "위반죄명", 	style:'tbLft' },
	                ];
		var columnLayoutT2 = [
					{ dataField : "grdCaseTrgterSn",headerText : "대상자일련번호", 	visible : false},
	                { dataField : "grdRcNo",      	headerText : "접수번호", 		visible : false },
	                { dataField : "grdCaseNo",      headerText : "사건번호",
	                	renderer : {type : "TemplateRenderer"},
 						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
 							return fnChangeNo (value);
 						}
	                },
	                { dataField : "grdTrgterSeCd",  headerText : "구분",
	                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
	            			return gridComboLabel(trgterSeList, value)
	            		}
	            	},
	                { dataField : "grdTrgterNm",    headerText : "피의자명" },
	                { dataField : "grdTrgterRrn",   headerText : "주민번호", visible : false }
	                ];
		var columnLayoutR = [
 					{ dataField : "grdTrgterSn",   	headerText : "대상자일련번호", 	visible : false},
 	                { dataField : "grdCaseNo",      headerText : "사건번호", 		width : 110,
 	                	renderer : {type : "TemplateRenderer"},
	 	   				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
	 	   					return fnChangeNo (value);
	 	   				}
 	                },
 	                { dataField : "grdRcNo",      	headerText : "접수번호", 		visible : false },
 	                { dataField : "grdTrgterNm",    headerText : "대상자명" },
 	                { dataField : "grdArrstTyCd",	headerText : "체포유형", 		style:'tbLft', width : 150,
 	                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
	            			return gridComboLabel(arrstTyList, value)
	            		}
 	                },
 	                { dataField : "grdArrstSn",     headerText : "순번", width : 40, visible : false },
 	                { dataField : "grdArresterSeCd",headerText : "체포자구분",
 	                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
	            			return gridComboLabel(arresterSeList, value)
	            		}
 	                },
 	                { dataField : "grdConfmSugestYn",    headerText : "승인의견", width : 70},
 	                { dataField : "grdSugestResultCd",   headerText : "건의결과", width : 70,
 	                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
	            			return gridComboLabel(sugestResultList, value)
	            		}
 	                }];
		var columnLayoutSt = [
  					{headerText : "접수번호", 		dataField : "grdRcNo", 		 visible : false },
  					{headerText : "대상자일련번호", 	dataField : "grdTrgterSn", visible : false },
  					{headerText : "보고일련번호", 	dataField : "grdReportSn", visible : false },
  					{headerText : "의뢰일자 <img src='/img/point.png'/>", dataField : "grdCmndDe",
						dataType : "date",
						formatString : "yyyy.mm.dd.",
						width:110,
						editRenderer : calendarRenderer
						/*{
							type : "CalendarRenderer",
							showExtraDays : false, 	// 지난 달, 다음 달 여분의 날짜(days) 출력 안함
							onlyCalendar : true 	// 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
						}*/
  					},
  				    {headerText : "의뢰관서 <img src='/img/point.png'/>", dataField : "grdCmndGrfcNm", editable : false,
  						renderer : { // HTML 템플릿 렌더러 사용
  							type : "TemplateRenderer"
  						},
  						// dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음.
  						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
  							var template = '<div class="my_grd">';
  							template += '<span class="my_grd_text_box">' + value + '</span>';
  							template += '<span class="my_grd_btn" onclick="javascript:grdPopupBtnClick(' + rowIndex + ', event);" />';
  							template += '</div>';
  							return template;
  						}
  					},
  					{headerText : "회신일자", dataField : "grdReportDe",
						dataType : "date",
						formatString : "yyyy.mm.dd.",
						width:110,
						editRenderer : calendarRenderer
						/*{
							type : "CalendarRenderer",
							showExtraDays : false, 	// 지난 달, 다음 달 여분의 날짜(days) 출력 안함
							onlyCalendar : true 	// 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
						}*/
  					},
  					{headerText : "회신내용", 	dataField : "grdReportCn", style:'tbLft'}
  		            ];
		var gridPros = {
			displayTreeOpen : true,
			rowNumHeaderText:"순번",
			selectionMode : "singleCell",	// 선택모드 (기본값은 singleCell 임)
			//noDataMessage:"조회 목록이 없습니다.",
			//showAutoNoDataMessage:false,
			fillColumnSizeMode:true,
			headerHeight : 30,
			rowHeight: 30
		};
		AUIGrid.create("#gridT1_wrap",columnLayoutT1,gridPros);
		AUIGrid.create("#gridT2_wrap",columnLayoutT2,gridPros);
		//AUIGrid.create("#gridR_wrap",columnLayoutR,gridPros);
		AUIGrid.create("#grid_stprsc_rst",  columnLayoutSt,$.extend(gridPros,{
			//showRowCheckColumn : false,
			editable : true,
			showStateColumn : true,
			editBeginMode : "click",
			enableDrag : true,
			//enableDragByCellDrag : true,  /*row 자리 이동*/
			softRemoveRowMode : true,
		}));
		AUIGrid.bind("#gridT1_wrap", "ready", function(event) {
			var hidRcNo  = $("#searchRcNo").val();
			if(!fnIsEmpty(hidRcNo)) {
				fnSetRow (event.pid, "grdRcNo", hidRcNo, 0);
				var chk = $("#hidSelTabId").val();
				fnT2Search (chk);
			}
		});
		AUIGrid.bind("#gridT2_wrap", "ready", function(event) {			
			var hidTrgterSn = $("#searchTrgterSn").val();
			var hidRcNo   = $("#searchRcNo").val();
			if(!fnIsEmpty(hidTrgterSn) && !fnIsEmpty(hidRcNo)) {
				var srow = fnSetRow (event.pid, "grdTrgterSn", hidTrgterSn, 3);
				var chk = $("#hidSelTabId").val();
				if(srow > -1) {
					var gdt = AUIGrid.getGridData(event.pid);
					if(chk == "arrst") fnGridDtlList (gdt[srow]);
					else fnGridStprscDtl (gdt[srow],chk);
				} else {
					$("#searchForm").resetForm ();
				}				
			} else {
				$("#searchForm").resetForm ();
			}
		});		
		AUIGrid.bind("#gridT2_wrap", "cellClick", function(event) {
			var items = event.item;
			var chk = $("#hidSelTabId").val();
			if(chk == "arrst") {
				fnGridDtlList (items);
			} else if(chk) {
				//기소중지, 참고인중지
				fnGridStprscDtl (items,chk);
			}
		});
		AUIGrid.bind("#gridR_wrap", "cellClick", function(event) {
			var items = event.item;
			fnGridArrDtlList (items);
		});
		AUIGrid.bind("#gridT1_wrap", "cellClick", function(event) {
			var items = event.item.grdRcNo;
			if(!fnIsEmpty(items)) {
				var chk = $("#hidSelTabId").val();
				if(chk == "arrst") {
					fnReset (1);
				} else {
					fnReset2 (5);
				}
				$("#searchRcNo").val(items);
				fnT2Search (chk);
			} else {
				alert("접수번호가 확인되지 않습니다.");
			}
		});
	}
	function fnT1Search () {
		$("#searchSelTabId").val($("#hidSelTabId").val());
		/*  */
		$("#searchType").val("all");
		
		fnSearchGrid("/inv/arrstCaseListAjax/", "searchForm", "#gridT1_wrap");
	}
	function fnT2Search (sType) {
		var strUrl = "/inv/suspectListAjax/";
		if(!fnIsEmpty(sType) && sType != "arrst") {
			strUrl = "/inv/stprscSuspectListAjax/";
		}
		$("#searchSelTabId").val(sType);
		fnSearchGrid (strUrl, "searchForm", "#gridT2_wrap");
	}
	function fnArrstSearch (pForm) {
		var gid = "#gridR_wrap";
		var gdt = fnSearchGridAdd ("/inv/arrstListAjax/", pForm, gid);
		AUIGrid.setGridData(gid, gdt);
		if(!fnIsEmpty(gdt) && gdt.length > 0) {
			AUIGrid.setSelectionByIndex(gid, 0, 1);
			fnGridArrDtlList (gdt[0]);
		}
		$("#searchForm").resetForm ();
		$("#hide").click();
	}
	function fnGridArrDtlList (items) {
		fnReset (2);
		var processAfterGet = function(data) {
			//input 에 모두 넣기
			fn_form_bind ("dtlInfoForm",data);
			fn_form_bind ("dtlForm",data);
			$("#hidCudType").val("U");
			//docId
			if(!fnIsEmpty(data.docId)) {
				fnDoc('ifrReport',data.docId,docNo,"P_RC_NO="+data.rcNo+"&P_TRGTER_SN="+data.trgterSn+"&P_ARRST_SN="+data.arrstSn,data.fileId);
			}
			//사건번호
			$("#labCaseNo").text(fnChangeNo($("#labCaseNo").text()));
		}
		Ajax.getJson("<c:url value='/inv/arrstDtlAjax/'/>", "grdArrstSn="+items.grdArrstSn, processAfterGet);
	}
	function fnGridDtlList (items) {
		//체포목록 조회
		fnReset (1);
		$("#arrstForm").find("input[name='hidRcNo']").val(items.grdRcNo);
		$("#arrstForm").find("input[name='hidTrgterSn']").val(items.grdTrgterSn);
		$("#arrstForm").find("input[name='hidArrstPage']").val("E");   //현행범인 체포, 긴급체포
		$("#selArrstTyCd").val("00733");			//현행범인체포
		fnArrstSearch ("arrstForm");
		//dtl 기본 조회
		$("#dtlInfoForm").find("input[name='hidRcNo']").val(items.grdRcNo);
		$("#dtlInfoForm").find("input[name='hidTrgterSn']").val(items.grdTrgterSn);
		$("#dtlInfoForm").find("input[name='hidArrstPage']").val("E");   //현행범인 체포, 긴급체포
		fn_form_bind ("dtlInfoForm",items,"GRID");
		$("#dtlInfoForm").find("#labCaseNo").text(fnChangeNo($("#dtlInfoForm").find("#labCaseNo").text())); //case_no
	}
	//기소중지
	function fnGridStprscDtl (items, pType) {
		//기본 reset
		$("#hide").click();
		$("#searchForm").resetForm ();

		//reset
		fnReset2(5);
		$("#dtlInfoForm2").find("input[name='hidRcNo']").val(items.grdRcNo);
		$("#dtlInfoForm2").find("input[name='hidTrgterSn']").val(items.grdTrgterSn);

		var sDscvryNo = ""; //소재발견정보
		var sDocId = "";

		//성명, 사건번호, 송치일자, 조사담당자
		fn_form_bind ("dtlInfoForm2",items,"GRID");
		//기소중지자
		var processAfterGet = function(data) {
			fn_form_bind ("dtlInfoForm2",data);
			sDocId = data.docId;
		}
		Ajax.getJson("<c:url value='/inv/stprscDtlAjax/'/>", "grdRcNo="+items.grdRcNo+"&grdTrgterSn="+items.grdTrgterSn+"&hidSelTabId="+pType, processAfterGet);
		//소재수사지휘
		var processAfterGet = function(data) {
			AUIGrid.setGridData ("#grid_stprsc_rst",data);
		}
		Ajax.getJson("<c:url value='/inv/stprscReportListAjax/'/>", "grdRcNo="+items.grdRcNo+"&grdTrgterSn="+items.grdTrgterSn+"&hidSelTabId="+pType, processAfterGet);

		//소재발견
		$("#dtlDscvryForm").find("input[name='hidRcNo']").val(items.grdRcNo);
		$("#dtlDscvryForm").find("input[name='hidTrgterSn']").val(items.grdTrgterSn);
		var processAfterGet = function(data) {
			fn_form_bind ("dtlDscvryForm",data);
			sDscvryNo = data.dscvryNo;
		}
		Ajax.getJson("<c:url value='/inv/stprscDscvryDtlAjax/'/>", "grdRcNo="+items.grdRcNo+"&grdTrgterSn="+items.grdTrgterSn+"&hidSelTabId="+pType, processAfterGet);

		fnDoc ('ifrReport2',sDocId,(!fnIsEmpty(pType)&&pType == "refe"?docNo3:docNo2),"P_RC_NO="+items.grdRcNo+"&P_TRGTER_SN="+items.grdTrgterSn+"&P_DSCVRY_NO="+sDscvryNo,items.grdFileId);
	}
	function jusoReturnValue (returnValue) {
		$("#"+returnValue.paramTxtId).val(returnValue.addr);
	}
	function fnKeyChk (pMsg,pType) {
		if(fnIsEmpty($("#hidDtlRcNo").val()) && fnIsEmpty($("#hidDtlTrgterSn").val())) {
			alert ("최상단 우측 피의자 정보에서 "+pMsg+" 피의자를 선택해 주세요.");
			$("#show").click();
			return false;
		}
		if(pType == 2) {
			if( fnIsEmpty($("#hidArrstSn").val()) ) {
				alert ("상단 좌측 체포자 목록에서 "+pMsg+" 체포자를 선택해 주세요.");
				return false;
			}
		}
		return true;
	}
	function fnReset (sType) {
		var pArr = [""]
		if (sType == 1) {
			$("#dtlInfoForm").clearForm(pArr);
			$(".clrLabel").text("");
			fnDoc ('ifrReport',"",docNo,"","");
		}
		$(".clrFm").val("");
		$('#dtlForm').clearForm(pArr);
		$("#hidCudType").val("C");
		$("#saveBtn").html("저장");

		var d = new Date();
		$("#labWritngNm").text("${hidLoginNm}");
		$("#labWritngDt").text(fnGetToday(0, 0) + " " + d.getHours()+":"+d.getMinutes());
	}
	function fnAdd () {
		//우선 reset 부터
		fnReset (2);
		if(!fnKeyChk("추가할",1)) return;
	}
	function fnDel () {
		if(!fnKeyChk("삭제할",2)) return;
		if(!confirm("삭제하시겠습니까?")) return;
		$("#hidCudType").val("D");
		fnLajax ("saveEmgcArrstAjax","DEL");
	}
	function fnSave () {
		//피의자 선택??
		if(fnKeyChk ("등록하고자 하는",1)) {
			var rrn1 = $("#txtArresterRrn1").val();
			var rrn2 = $("#txtArresterRrn2").val();
			if(!fnIsEmpty(rrn1) || !fnIsEmpty(rrn2)) { //필수 아님-형식만 확인
				if(!fnRrnCheck (rrn1+"-"+rrn2)) {
					$("#txtArresterRrn1").focus();
					return;
				}
			}
			if(fnFormValueCheck("dtlInfoForm") && fnFormValueCheck("dtlForm")){
				fnLajax ("saveEmgcArrstAjax","SAVE");
			}
		}
		//기본정보 제외 clear
	}
	function fnLajax (sUrl, type) {
		var param = $('#dtlInfoForm').serialize();
		    param += ("&"+ $('#dtlForm').serialize());
		var processAfterGet = function(data) {
			if(type == "SAVE" || type == "DEL") {
				if(data.cnt == "0") {
					AUIGrid.setGridData("#gridR_wrap", []);
				} else {
					AUIGrid.setGridData("#gridR_wrap", data.list);
					if(type=="DEL") {
						alert("삭제되었습니다.");
						fnAdd ();
					} else {
						alert("저장되었습니다.");
						//재조회
						var rtnval = data.rtnValue;
						if(fnIsEmpty(rtnval)) {
							fnAdd ();
						} else {
							fnSetRow ("#gridR_wrap", "grdArrstSn", rtnval.arrstSn, 3);
							fnGridArrDtlList ({grdArrstSn:rtnval.arrstSn});
						}
					}
				}
			}
		}
		Ajax.getJson("<c:url value='/inv/"+sUrl+"/'/>", param, processAfterGet);
	}
	function fnSelectUser (userId, userNm, userDeptNm, userClsfNm, userResdncAddr, txtId) {
		if(txtId == "hidArresterId") {
			$("#txtArresterPsitn").val(userDeptNm);
			$("#txtArresterClss").val(userClsfNm);
			$("#txtArresterDwlsit").val(userResdncAddr);
		}
		$("#"+txtId).val(userId);
		$("#"+txtId.replace("Id","Nm").replace("hid","txt")).val(userNm);
	}
	function fnGridChg (sType, cType) {
		var strRcNo   = $("#dtlInfoForm2").find("#hidDtlRcNo2").val();
		var strTrgter = $("#dtlInfoForm2").find("#hidDtlTrgterSn2").val();
		if(fnIsEmpty(strRcNo) || fnIsEmpty(strTrgter)) {
			alert("상단 우측 피의자 목록에서 기소 중지된 피의자를 선택하여 주십시오.");
			$("#show").click();
			return;
		}
		if(sType == 1) {
			var item = {};
			item.grdRcNo 		= strRcNo,
			item.grdTrgterSn 	= strTrgter,
			item.grdReportSn 	= "",
			item.grdCmndDe		= "",
			item.grdCmndGrfcNm 	= "",
			item.grdReportDe 	= "",
			item.grdReportCn 	= ""

			// parameter
			// item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
			// rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
			AUIGrid.addRow("#grid_stprsc_rst", item, "last");
			//fn_form_bind ("dtlDscvryForm",item,"GRID");
		} else {
			var rowPos = AUIGrid.getSelectedIndex("#grid_stprsc_rst");
			AUIGrid.removeRow("#grid_stprsc_rst", rowPos[0]);
		}
	}
	function grdPopupBtnClick (rowIndex, event) {
		fnPolcSelect();
	}
	function fnSelectPolc(upCd, cd, cdNm) {
		AUIGrid.updateRow("#grid_stprsc_rst", {
			"grdCmndGrfcNm" : cdNm
		}, AUIGrid.getSelectedIndex("#grid_stprsc_rst")[0]);
	}
	function fnReset2 (pType) {
		if(pType == 1) {
			$("#dtlInfoForm2").clearForm (["hidRcNo","hidTrgterSn"]);
		} else if (pType == 2) {
			$("#dtlDscvryForm").clearForm (["hidRcNo","hidTrgterSn"]);
		} else if (pType == 3) {
			AUIGrid.clearGridData("#grid_stprsc_rst");
		} else {
			var pSid = $("#hidSelTabId").val();
			AUIGrid.clearGridData("#grid_stprsc_rst");
			if (pType == 0) {
				fnT1Search ();
				$("#show").click();
			};
			fnDoc ('ifrReport2',"",(!fnIsEmpty(pSid)&&pSid == "refe"?docNo3:docNo2),"","");
			$("#dtlInfoForm2").clearForm ();
			$("#dtlDscvryForm").clearForm ();
			$("#dtlInfoForm2").find('label').each(
			    function(index){
			    	$(this).text("");
			    }
			);
			if(pSid == "refe") $("#cnt2_t_nm").text("참고인중지자");
			else $("#cnt2_t_nm").text("기소중지자");
		}
	}
	function fnSave2 () {
		if(fnFormValueCheck("dtlInfoForm2")){
			var strTabId = $("#hidSelTabId").val();
			var processAfterGet = function(data) {
				var rData = data.data;
				if(!fnIsEmpty(rData)) {
					alert("저장되었습니다.");
					fnReset2 (1);
					fn_form_bind ("dtlInfoForm2", rData);

					var sDscvryNo = $("#dtlDscvryForm").find("#hidDscvryNo").val();
					fnDoc ('ifrReport2',rData.docId,(!fnIsEmpty(strTabId)&&strTabId == "refe"?docNo3:docNo2),"P_RC_NO="+rData.rcNo+"&P_TRGTER_SN="+rData.trgterSn+"&P_DSCVRY_NO="+sDscvryNo,rData.fileId);
				}
			}
			var param = $('#dtlInfoForm2').serialize();
			param += "&hidSelTabId="+strTabId;
			Ajax.getJson("<c:url value='/inv/saveStprscAjax/'/>", param, processAfterGet);
		}
	}
	function fnChkMainInfo (pMsg) {
		if(fnIsEmpty($("#dtlInfoForm2").find("#hidDtlRcNo2").val())) {
			alert("최상단 사건과 사건 피의자를 선택한 후 "+pMsg+"를 진행하여 주십시오.");
			$("#show").click();
			return false;
		}
		if(fnIsEmpty($("#dtlInfoForm2").find("#hidDtlTrgterSn2").val())) {
			alert("최상단 우측 사건 피의자를 선택한 후 "+pMsg+"를 진행하여 주십시오.");
			$("#show").click();
			return false;
		}
		if(fnIsEmpty($("#dtlInfoForm2").find("#hidChkKey").val())) {
			alert("기소 중지자의 기본정보를 입력 후\n\n"+pMsg+"를 진행 하여 주십시오.");
			$("#dtlInfoForm2").find("#txtExmnCaseNo").focus();
			return false;
		}
		return true;
	}
	//소재수사지휘저장
	function fnSave3 () {
		if(!fnChkMainInfo ("소재수사지휘")) return;
		var gId = "#grid_stprsc_rst";
		var totGrid = AUIGrid.getGridData (gId);
		if(fnIsEmpty(totGrid)||totGrid.length == 0) {
			fnGridChg (1, 1);
			alert("소재수사지휘의 내용을 입력하여 주십시오.");
		} else {
			var editGdata = {};
			var addedRowItems = AUIGrid.getAddedRowItems(gId);
			if(addedRowItems.length > 0) {
				editGdata.grdAdd = addedRowItems;
			}
			var editedRowItems = AUIGrid.getEditedRowItems (gId);
			if(editedRowItems.length > 0) {
				editGdata.grdEdit = editedRowItems;
			}
			var removedRowItems = AUIGrid.getRemovedItems(gId);
			if(removedRowItems.length > 0) {
				editGdata.grdDel = removedRowItems;
			}
			if(fnIsEmpty(editGdata)) {
				alert("수정된 내용이 없습니다.");
			} else {
				var valiArr = ["grdCmndDe","grdCmndGrfcNm"];
				if(AUIGrid.validateGridData(gId, valiArr, "필수 필드는 반드시 값을 직접 입력해야 합니다.")) {
					editGdata.hidRcNo 		= $("#dtlInfoForm2").find("#hidDtlRcNo2").val();
					editGdata.hidTrgterSn 	= $("#dtlInfoForm2").find("#hidDtlTrgterSn2").val();
					editGdata.hidSelTabId	= $("#hidSelTabId").val();
					var rSave = fnAjaxAction('/inv/saveStprscReportAjax/', JSON.stringify (editGdata));
					if(rSave.list != null) {
						alert("저장되었습니다.");
						fnReset2 (3);
						AUIGrid.setGridData (gId,rSave.list);
					}
				}
			}
		}
	}
	function fnSave4 () {
		//소재 발견
		if(!fnChkMainInfo ("소재발견 정보")) return;

		//해제 chk 확인
		var trSyDis = $("#trSrccYn").css("display");
		if(!fnIsEmpty(trSyDis) && trSyDis !="none") {
			var chkSrccrmRelisYn = $("#chkSrccrmRelisYn").is(":checked");
			if(fnIsEmpty(chkSrccrmRelisYn) || !chkSrccrmRelisYn) {
				if(!confirm("지명수배해제가 되지 않았습니다.\n\n지명수배해제 없이 소재발견 진행 하시겠습니까?")) {
					return;
				}
			}
		}

		var item = AUIGrid.getSelectedItems("#gridT2_wrap");
		//console.log(item[0]);
		
		if(confirm("현재 담당자는 " + item[0].item.grdChargerNm + "입니다.\n담당자를 재배당하시겠습니까?") == true){//재배당시
			alotSelectPopup = dhtmlmodal.open('alotSelect', 'iframe', '/alot/alotPopup/?snNo=' + item[0].item.grdRcNo + "&gbn=I&ret=N", '배당처리', 'width=750px,height=650px,center=1,resize=0,scrolling=1');
			alotSelectPopup.onclose = function(){
				saveStprscDscvry();
				return true;
			}
		}else{//재배당없이 진행
			saveStprscDscvry();
		}
	}
	function fnDel4 () {
		//소재발견 삭제
		if(confirm("소재 발견 정보를 삭제하시겠습니까?")) {
			var processAfterGet = function(data) {
				if(!fnIsEmpty(data.rst) && parseInt(data.rst) > 0) {
					alert("삭제되었습니다.");
					fnReset2 (2);
				}
			}
			var param = $('#dtlDscvryForm').serialize();
			param += "&hidSelTabId="+$("#hidSelTabId").val();
			Ajax.getJson("<c:url value='/inv/deleteStprscDscvryAjax/'/>", param, processAfterGet);
		}
	}
	function fnResmpt () {
		if(!fnChkMainInfo ("수사재개")) return;
		if(fnIsEmpty($("#dtlDscvryForm").find("#hidDscvryNo").val())) {
			alert("소재발견 정보를 저장 후 수사 재개를 하여 주십시오.");
			$("#dtlDscvryForm").find("#txtDscvryDe").focus();
			return;
		} else if(fnIsEmpty($("#dtlDscvryForm").find("#txtInvResmptDe").val())) {
			alert("수사재개일자를 입력하신 후 수사 재개를 하여 주십시오.");
			$("#dtlDscvryForm").find("#txtInvResmptDe").focus();
			return;
		}
		//수사재개
		if(confirm("수사 재개를 하시겠습니까?")) {
			//tab 확인
			var tId = $("#hidSelTabId").val();
			var processAfterGet = function(data) {
				if(!fnIsEmpty(data.rst) && parseInt(data.rst) > 0) {
					alert("수사 재개 되었습니다.");
					fnReset2 (0);
				}
			}
			var param = $('#dtlDscvryForm').serialize();
			Ajax.getJson("<c:url value='/inv/saveResmptAjax/'/>", param, processAfterGet);
		}
	}
	//석방지휘 건의로 이동
	function fnSendSugest() {
		var selectedItems = AUIGrid.getSelectedItems("#gridR_wrap");
		if(selectedItems.length > 0) {
			if(confirm(selectedItems[0].item.grdTrgterNm+"의 석방지휘건의를 진행하시겠습니까?")) {
				location.href = "<c:url value='/inv/sugest/?rcNo="+selectedItems[0].item.grdRcNo+"&sugestTyCd=01102'/>";
			}
		} else {
			alert("체포 정보가 확인되지 않습니다.\n\n체포 상세 정보를 저장 후 또는 체포 현황 중 하나를 선택 후\n지휘건의를 진행하여 주십시오.");
		}
	}
	
	/*
		2021.11.08
		coded by dgkim
		기소중지, 참고인중지 프로세스 변경으로 인한 소재발견 저장 함수 분리
	*/
	function saveStprscDscvry(){
		if(fnFormValueCheck("dtlDscvryForm")){
			var processAfterGet = function(data) {
				if(!fnIsEmpty(data.data)) {
					alert("저장되었습니다.");
					fnReset2 (2);
					fn_form_bind ("dtlDscvryForm", data.data);
				}
			}
			
			var param = $('#dtlDscvryForm').serialize();
			param += "&hidSelTabId="+$("#hidSelTabId").val();
			//지명수배해제여부
			var chkSrccrmRelisYn = $("#chkSrccrmRelisYn").is(":checked");
			if(!fnIsEmpty(chkSrccrmRelisYn) && chkSrccrmRelisYn) param += "&chkVlSrccrmRelisYn=Y";
			else param += "&chkVlSrccrmRelisYn=";
			Ajax.getJson("<c:url value='/inv/saveStprscDscvryAjax/'/>", param, processAfterGet);
		}
	}
</script>
<!-- 상단 조회 -->
<div class="sh_box">
	<button id="hide" class="showbtn"></button>
	<button id="show" class="hidebtn" style="display: none"></button>

	<div class="show_in" id="showinbox">
		<div class="box_w2">
			<!---------- 왼쪽테이블  ---------------->
			<div class="box_w2_1b_ov" style="height: 200px; width:calc(65% - 15px);">
				<!--테이블 시작 -->
				<div class="com_box">
					<div id="gridT1_wrap" class="gridResize tb_01_box" style="width: 100%; height: 190px;"></div>
				</div>
			</div>
			<!---------- //왼쪽테이블  ---------------->
			<!---------- 오른쪽테이블 ---------------->
			<div class="box_w2_2b_ov" style="width:calc(35% - 15px);">
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
<div class="search_box mb_10" style="display: none;">
	<form id="searchForm">
		<input type="hidden" id="searchRcNo"      name="searchRcNo"/>
		<input type="hidden" id="searchCaseNo"    name="searchCaseNo"/>
		<input type="hidden" id="searchTrgterSn"  name="searchTrgterSn"/>
		<input type="hidden" id="searchSelTabId"  name="searchSelTabId" />
		<input type="hidden" id="searchPageType"  name="searchPageType" />
		<input type="hidden" id="searchType"  name="searchType" value="all" />
		<!-- <input type="hidden" id="searchArrstTyCd" name=""/> -->  <!-- 이걸걸면 대상자의 다른 유형이 안나올 수 있어서 보류! -->
	</form>
</div>
<!-- main tab -->
<div class="tabnbtn_box mb_10" id="mTab_box">
	<input type="hidden" name="hidSelTabId" id="hidSelTabId"/>
	<ul class="tabs">
		<!-- <li id="arrst" class="current">체포</li> -->
		<li id="stprsc" class="current">기소중지</li>
		<li id="refe">참고인중지</li>
	</ul>
</div>
<!-- //main tab -->
<div class="contents marginbot" id="mTab_list">
	<%-- <div id="mContent1" class="tabscontent">
		<div class="box_w2">
			<div class="box_w2_1b">
				<div class="title_s_st2 fl" style="width: 150px; margin-bottom: 7px;">
					<img src="/img/title_icon1.png" />체포 현황
				</div>
				<div class="right_btn fr">
					<a class="btn_st2 icon_n fl" onclick="fnSendSugest(); return false" href="#" id="saveBtn2">석방지휘건의</a>
				</div>
				<!--테이블 시작 -->
				<div class="com_box">
					<div id="gridR_wrap" class="gridResize tb_01_box" style="width: 100%; height: 250px;"></div>
				</div>
			</div>
			<form id="arrstForm">
				<input type="hidden" name="hidRcNo" 		id="hidsearchRcNo"/>
				<input type="hidden" name="hidTrgterSn" 	id="hidsearchTrgterSn"/>
				<input type="hidden" name="hidArrstPage" 	id="hidsearchArrstPage"/>
			</form>
			<div class="box_w2_2b">
				<!--문서목록 -->
				<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="300px"></iframe>
			</div>
		</div>
		<!-- 상세 -->
		<form id="dtlInfoForm">
			<input type="hidden" name="hidRcNo" id="hidDtlRcNo"/>
			<input type="hidden" name="hidTrgterSn" id="hidDtlTrgterSn"/>
			<input type="hidden" name="hidArrstPage" id="hidtlArrstPage"/>  <!-- 체포구분 -->
			<div class="fl w_100p">
				<div class="title_s_st2 fl mb_10" style="width: 90px;">
					<img src="/img/title_icon1.png" alt=""/>체포유형
				</div>
				<img src="/img/point.png" class="fl mr_5 mt_10"/>
				<select size="1" class="w_200px input_com fl mt_5" name="selArrstTyCd" id="selArrstTyCd" check="text" checkName="체포유형">
					<option value="">==선택하세요==</option>
					<c:forEach var="cd" items="${arrstTyList}">
						<c:if test="${cd.cdDc eq '체포유형'}">
							<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
						</c:if>
					</c:forEach>
				</select>
				<div class="right_btn fr">
					<a class="btn_st2 icon_n fl mr_m1" 	onclick="fnAdd();  return false" href="#" id="addBtn">신규</a>
					<a class="btn_st2 icon_n fl mr_m1" 	onclick="fnDel();  return false" href="#" >삭제</a>
					<a class="btn_st2 icon_n fl " 		onclick="fnSave(); return false" href="#" id="saveBtn">저장</a>
				</div>
			</div>
			<div class="com_box fl" style="width: 42%">
			<div class="tb_01_box">
			<table class="tb_01_h100 ntBrdCss">
				<caption>
				<h4>체포정보</h4>
				</caption>
				<colgroup>
				<col width="120px;"/>
				<col width="31%"/>
				<col width="120px;"/>
				<col width=""/>
				</colgroup>
				<tbody>
					<tr class="h_40px">
						<th>피의자성명</th>
						<td>
							<label id="labTrgterNm" class="clrLabel"></label>
						</td>
						<th>사건번호</th>
						<td>
							<label id="labCaseNo" class="clrLabel"></label>
						</td>
					</tr>
					<tr class="h_40px">
						<th>주민등록번호</th>
						<td>
							<label id="labTrgterRrn" class="clrLabel"></label>
						</td>
						<th>나이</th>
						<td>
							<label id="labTrgterAge" class="mr_5 clrLabel"></label>(만)세
						</td>
					</tr>
					<tr class="h_40px">
						<th>피의자직업</th>
						<td colspan="3">
							<label id="labOccpNm" class="clrLabel"></label>
						</td>
					</tr>
					<tr class="h_40px">
						<th>피의자주거</th>
						<td colspan="3">
							<label id="labDwlsitAddr" class="mr_5 clrLabel"></label>
							(우편 : <label id="labDwlsitZip" class="clrLabel"></label>)
						</td>
					</tr>
					<tr class="h_40px">
						<th>적용법조</th>
						<td colspan="3" style="line-height:27px;">
							<label id="labVioltNm" class="clrLabel"></label>
						</td>
					</tr>
					<tr class="h_40px">
						<th>작성자</th>
						<td>
							<label id="labWritngNm" class="clrLabel"></label>
						</td>
						<th>작성일시</th>
						<td>
							<label id="labWritngDt" class="clrLabel"></label>
						</td>
					</tr>
					<tr class="h_40px">
						<th>영장신청여부 <img src="/img/point.png" /></th>
						<td colspan="3">
							<div class='input_radio2 t_left'>
							    <input class="to-labelauty-icon" type="radio" name="rdoZrlongReqstYn" value="Y"/>신청
							</div>
							<div class='input_radio2 t_left'>
							    <input class="to-labelauty-icon" type="radio" name="rdoZrlongReqstYn" value="N"/>미신청
							</div>
						</td>
					</tr>
					<tr>
						<th>체포일시 <img src="/img/point.png" /></th>
						<td colspan="3">
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar clrFm" id="txtArrstDt"  name="txtArrstDt" check="text" checkName="체포일자" readonly="readonly">
								<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
							</div>
							<div class="fl">
								<input type="text" id="txtArrstDt2" name="txtArrstDt2" class="input_com clrFm" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;" check="text" checkName="체포시간"/>:
								<input type="text" id="txtArrstDt3" name="txtArrstDt3" class="input_com clrFm" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;" check="text" checkName="체포시간"/>
							</div>
						</td>
					</tr>
					<tr>
						<th>체포장소 <img src="/img/point.png" /></th>
						<td colspan="3">
							<div class="flex_r">
								<input type="text" id="txtArrstPlace" name="txtArrstPlace" class="w_100p input_com clrFm" maxlength="50" check="text" checkName="체포장소">
								<input type="button" value="" class="btn_search" onclick="fnZipPop('txtArrstPlace')">
							</div>
						</td>
					</tr>
					<tr style="height: 120px;">
						<th>체포사유 <img src="/img/point.png" /><br/><span id="txtEmrgncyArrstResnMsg" style="margin-top:5px;"></span></th>
						<td colspan="3"> <!-- class="h180" -->
							<textarea name="txtEmrgncyArrstResn" id="txtEmrgncyArrstResn" class="clrFm" maxlength="2000" check="text" checkName="체포사유"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
			</div>
			</div>
		</form>
		<form id="dtlForm">
			<input type="hidden" name="hidArrstSn" id="hidArrstSn"/>
			<input type="hidden" name="hidCudType" id="hidCudType"/>

			<div class="com_box fl ml_20 mb_20" style="width: calc(58% - 20px);">
			<div class="tb_01_box">
			<table class="tb_01">
				<caption>
				<h4>체포정보</h4>
				</caption>
				<colgroup>
				<col width="" style="min-width: 90px;"/>
				<col width="33%" style="min-width: 240px;"/>
				<col width="" style="min-width: 90px;"/>
				<col width="" style="min-width: 230px;"/>
				</colgroup>
				<tbody>
					<tr>
						<th>체포자구분 <img src="/img/point.png" /></th>
						<td style="min-width: 240px;">
							<c:forEach var="cd" items="${arresterSeList}">
								<div class='input_radio2 t_left'>
							    	<input class="to-labelauty-icon" type="radio" name="rdoArresterSeCd" check="text" checkName="체포자구분" value="${cd.cd}"/>
							    ${cd.cdNm}</div>
							</c:forEach>
						</td>
						<th>성명 <img src="/img/point.png" /></th>
						<td style="min-width: 230px;">
							<div class="flex_r">
								<input type="hidden" name="hidArresterId" id="hidArresterId" />
								<input type="text" name="txtArresterNm" id="txtArresterNm" class="w_150px input_com" maxlength="20" check="text" checkName="성명"/>
								<input type="button" class="btn_search" onclick="btnUserPop('hidArresterId')">
							</div>
						</td>
					</tr>
					<tr>
						<th>소속 <img src="/img/point.png" /></th>
						<td>
							<input type="text" name="txtArresterPsitn" id="txtArresterPsitn" class="input_com w_200px" maxlength="30" check="text" checkName="소속"/>
						</td>
						<th>계급</th>
						<td>
							<input type="text" name="txtArresterClss" id="txtArresterClss" class="w_150px input_com" maxlength="30" />
						</td>
					</tr>
					<tr>
						<th>주민번호</th>
						<td>
							<input type="text" name="txtArresterRrn1" id="txtArresterRrn1" class="w_100px input_com" maxlength="6" onkeyup="fnRemoveChar(event)">-
							<input type="text" name="txtArresterRrn2" id="txtArresterRrn2" class="w_100px input_com" maxlength="7" onkeyup="fnRemoveChar(event)">
						</td>
						<th>변호인 성명</th>
						<td>
							<input type="text" name="txtCounslNm" id="txtCounslNm" class="w_150px input_com" maxlength="20" />
						</td>
					</tr>
					<tr>
						<th>주거지</th>
						<td colspan="3">
							<div class="flex_r">
								<input type="text" id="txtArresterDwlsit" name="txtArresterDwlsit" class="input_com w_100p" maxlength="50" />
								<input type="button" value="" class="btn_search" onclick="fnZipPop('txtArresterDwlsit')">
							</div>
						</td>
					</tr>
					<tr>
						<th>인치일시 <img src="/img/point.png" /></th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtAttractDt"  name="txtAttractDt" readonly="readonly" check="text" checkName="인치일자">
								<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
							</div>
							<div class="fl">
								<input type="text" id="txtAttractDt2" name="txtAttractDt2" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;" check="text" checkName="인치시간"/>:
								<input type="text" id="txtAttractDt3" name="txtAttractDt3" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;" check="text" checkName="인치시간"/>
							</div>
						</td>
						<th>인치장소 <img src="/img/point.png" /></th>
						<td>
							<input type="text" name="txtAttractPlace" class="w_200px input_com" maxlength="30" check="text" checkName="인치장소"/>
						</td>
					</tr>
					<tr>
						<th>구금자 </th>
						<td>
							<div class="flex_r">
								<input type="hidden" name="hidCnfnmExcutrId" id="hidCnfnmExcutrId"/>
								<input type="text" name="txtCnfnmExcutrNm" id="txtCnfnmExcutrNm" class="input_com w_200px" readonly="readonly">
								<input type="button" class="btn_search" onclick="btnUserPop('hidCnfnmExcutrId')">
							</div>
						</td>
						<th>인수자</th>
						<td>
							<div class="flex_r">
								<input type="hidden" name="hidAcptrId" id="hidAcptrId"/>
								<input type="text" name="txtAcptrNm" id="txtAcptrNm" class="input_com w_200px" readonly="readonly">
								<input type="button" class="btn_search" onclick="btnUserPop('hidAcptrId')">
							</div>
						</td>
					</tr>
					<tr>
						<th>구금일시 </th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtCnfnmDt"  name="txtCnfnmDt" readonly="readonly">
								<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
							</div>
							<div class="fl">
								<input type="text" id="txtCnfnmDt2" name="txtCnfnmDt2" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
								<input type="text" id="txtCnfnmDt3" name="txtCnfnmDt3" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
							</div>
						</td>
						<th>인수일시</th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtUndtakeDt"  name="txtUndtakeDt" readonly="readonly">
								<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
							</div>
							<div class="fl">
								<input type="text" id="txtUndtakeDt2" name="txtUndtakeDt2" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
								<input type="text" id="txtUndtakeDt3" name="txtUndtakeDt3" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
							</div>
						</td>
					</tr>
					<tr>
						<th>구금장소</th>
						<td>
							<input type="text" name="txtCnfnmPlace" class="w_200px input_com" maxlength="30"/>
						</td>
						<th>인수장소</th>
						<td>
							<input type="text" name="txtUndtakePlace" class="w_200px input_com" maxlength="30"/>
						</td>
					</tr>
					<tr>
						<th>석방자</th>
						<td colspan="3">
							<div class="flex_r">
								<input type="hidden" name="hidRslExcutrId" id="hidRslExcutrId"/>
								<input type="text" name="txtRslExcutrNm" id="txtRslExcutrNm" class="input_com w_200px" readonly="readonly">
								<input type="button" class="btn_search" onclick="btnUserPop('hidRslExcutrId')">
							</div>
						</td>
					</tr>
					<tr>
						<th>석방일시</th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtRslDt"  name="txtRslDt" readonly="readonly">
								<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
							</div>
							<div class="fl">
								<input type="text" id="txtRslDt2" name="txtRslDt2" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
								<input type="text" id="txtRslDt3" name="txtRslDt3" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
							</div>
						</td>
						<th>석방장소</th>
						<td>
							<input type="text" name="txtRslPlace" class="w_200px input_com" maxlength="30"/>
						</td>
					</tr>
					<tr>
						<th>석방사유</th>
						<td colspan="3">
							<select name="selRslResnCd" size="1" class="w_200px input_com mr_5">
								<option value="">== 선택하세요 ==</option>
								<c:forEach var="cd" items="${rslResnList}">
									<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
								</c:forEach>
							</select>
							<input type="text" name="txtRslResnEtc" maxlength="70" class="input_com" style="width:calc(100% - 210px);">
						</td>
					</tr>
					<tr>
						<th style="height: 30px;">건의여부</th>
						<td>
							<div class='input_radio2 t_left'>
							    <input class="to-labelauty-icon" type="radio" name="rdoConfmSugestYn" value="Y"/>Y
							</div>
							<div class='input_radio2 t_left'>
							    <input class="to-labelauty-icon" type="radio" name="rdoConfmSugestYn" value="N"/>N
							</div>
						</td>
						<th>건의결과</th>
						<td>
							<div class='input_radio2 t_left'>
							    <input class="to-labelauty-icon" type="radio" name="rdoSugestResultCd" value="Y"/>가
							</div>
							<div class='input_radio2 t_left'>
							    <input class="to-labelauty-icon" type="radio" name="rdoSugestResultCd" value="N"/>부
							</div>
							<div class='input_radio2 t_left'>
							    <input class="to-labelauty-icon" type="radio" name="rdoSugestResultCd" value="E"/>비고
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			</div>
			</div>
		</form>
	</div> --%>
	<div id="mContent2" class="tabscontent" ><!-- style="display: none;" -->
		<form id="dtlInfoForm2">
			<input type="hidden" name="hidRcNo" id="hidDtlRcNo2"/>
			<input type="hidden" name="hidTrgterSn" id="hidDtlTrgterSn2"/>
			<input type="hidden" name="hidChkKey" id="hidChkKey"/>
			<div class="box_w2_1b">
				<div class="fl w_100p">
					<div class="title_s_st2 fl" style="width: 90px; margin-bottom: 7px;">
						<img src="/img/title_icon1.png" alt=""/><label id="cnt2_t_nm">기소중지자</label>
					</div>
					<div class="right_btn fr">
						<a class="btn_st2 icon_n fl " 		onclick="fnSave2(); return false" href="#" id="saveBtn2">저장</a>
					</div>
				</div>
				<div class="tb_01_box">
				<table class="tb_01_h100 ntBrdCss">
					<caption>
					</caption>
					<colgroup>
					<col width="120px;"/>
					<col width=""/>
					<col width="120px;"/>
					<col width=""/>
					</colgroup>
					<tbody>
						<tr class="h_40px">
							<th>성명</th>
							<td>
								<label id="labTrgterNm" class=""></label>
							</td>
							<th>사건번호</th>
							<td>
								<label id="labCaseNo" class=""></label>
							</td>
						</tr>
						<tr class="h_40px">
							<th>송치일자</th>
							<td>
								<label id="labTrnDe" class=""></label>
							</td>
							<th>조사담당자</th>
							<td>
								<label id="labChargerNm" class=""></label>
							</td>
						</tr>
						<tr class="h_40px">
							<th>형제번호 <img src="/img/point.png" /></th>
							<td>
								<input type="text" name="txtExmnCaseNo" id="txtExmnCaseNo" maxlength="30" class="w_100p input_com" check="text" checkName="형제번호" />
							</td>
							<th>주임검사 <img src="/img/point.png" /></th>
							<td>
								<input type="text" name="txtPrsecNm" maxlength="30" class="w_100p input_com" check="text" checkName="주임검사" />
							</td>
						</tr>
						<tr class="h_40px">
							<th>결정일자 <img src="/img/point.png" /></th>
							<td>
								<div class="calendar_box mr_5 fl" style="width: 130px;">
									<input type="text" class="w_100p input_com calendar dtlRs" id="txtDecsnDe" name="txtDecsnDe" check="text" checkName="결정일자" readonly="readonly">
								</div>
							</td>
							<th>공소시효</th>
							<td>
								<input type="text" name="txtStprscPspps" maxlength="30" class="w_100p input_com"/>
							</td>
						</tr>
					</tbody>
				</table>
				</div>
			</div>
		</form>
		<div class="box_w2_2b">
			<!--문서목록 -->
			<iframe name="ifrReport2" id="ifrReport2" scrolling="no" frameborder="0" width="100%;" height="210px"></iframe>
		</div>
		<div class="box_w2_1b" style="width:calc(65% + 40px); margin-top: 10px;">
			<div class="fl w_100p">
				<div class="title_s_st2 fl" style="width: 90px; margin-bottom: 7px;">
					<img src="/img/title_icon1.png" alt=""/>소재수사지휘
				</div>
				<div class="right_btn fr">
					<a class="btn_st2 icon_n fl mr_m1" 	onclick="fnGridChg(1, 1);  return false" href="#" id="addGrd">행추가</a>
					<a class="btn_st2 icon_n fl mr_m1" 	onclick="fnGridChg(2, 1);  return false" href="#" id="delGrd">행삭제</a>
					<a class="btn_st2 icon_n fl " 		onclick="fnSave3(); return false" href="#" id="saveBtn3">저장</a>
				</div>
			</div>
			<div class="com_box">
				<div id="grid_stprsc_rst" class="gridResize tb_01_box" style="width: 100%; height: 285px;"></div>
			</div>
		</div>
		<form id="dtlDscvryForm">
		<input type="hidden" name="hidRcNo" id="hidDscvryRcNo"/>
		<input type="hidden" name="hidTrgterSn" id="hidDscvryTrgterSn"/>
		<input type="hidden" name="hidDscvryNo" id="hidDscvryNo"/>
		<div class="box_w2_2b" style="width:calc(35% - 40px); margin-top: 10px; margin-bottom: 20px;">
			<div class="title_s_st2 fl" style="width: 90px; margin-bottom: 7px;">
				<img src="/img/title_icon1.png" alt=""/>소재발견
			</div>
			<div class="right_btn fr">
				<!-- <a class="btn_st2 icon_n fl mr_m1" 	onclick="fnAdd4();  return false" href="#" id="addBtn2">신규</a> -->
				<a class="btn_st2 icon_n fl mr_m1" 	onclick="fnDel4();  return false" href="#" id="delBtn4">삭제</a>
				<a class="btn_st2 icon_n fl " 		onclick="fnSave4(); return false" href="#" id="saveBtn4">저장</a>
			</div>
			<div class="tb_01_box">
			<table class="tb_01_h100 ntBrdCss">
				<caption>
				</caption>
				<colgroup>
				<col width="120px;"/>
				<col width=""/>
				</colgroup>
				<tbody>
					<tr class="h_40px">
						<th>발견일자 <img src="/img/point.png" /></th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px;">
								<input type="text" class="w_100p input_com calendar dtlRs" id="txtDscvryDe" name="txtDscvryDe" readonly="readonly" check="text" checkName="발견일자">
							</div>
						</td>
					</tr>
					<tr class="h_40px">
						<th>소재발견유형 <img src="/img/point.png" /></th>
						<td>
							<select size="1" class="w_200px input_com fl mt_5" name="selDscvryTy" id="selDscvryTy" check="text" checkName="소재발견유형">
								<option value="">==선택하세요==</option>
								<c:forEach var="cd" items="${dscvryTyList}">
									<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr id="trDscvryDc" style="height: 80px;"> <!--  style="height: 100px;" class="h_80px"  -->
						<th>발견경위 <br/>및 의견</th>
						<td>
							<textarea name="txtDscvryDc" maxlength="200" class="w_100p input_com"></textarea>
						</td>
					</tr>
					<!-- <tr class="h_80px">
						<th>발견사유<br/>(재기신청)</th>
						<td>
							<textarea name="txtDscvryResn" maxlength="200" class="w_100p input_com" ></textarea>
						</td>
					</tr>  -->
					<tr class="h_40px">
						<th>발견보고일 <img src="/img/point.png" /></th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px;">
								<input type="text" class="w_100p input_com calendar dtlRs" id="txtDscvryReportDe" name="txtDscvryReportDe" readonly="readonly" check="text" checkName="발견보고일">
							</div>
						</td>
					</tr>
					<tr class="h_40px" id="trSrccYn">
						<th>지명수배해제여부</th>
						<td>
							<div>
							    <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkSrccrmRelisYn" id="chkSrccrmRelisYn" value="Y"/>&nbsp;&nbsp;해제
							</div>
						</td>
					</tr>
					<tr class="h_40px">
						<th>수사재개일자</th>
						<td>
							<div class="flex_r">
								<div class="calendar_box fl" style="width: 130px;">
									<input type="text" class="w_100p input_com calendar dtlRs" id="txtInvResmptDe" name="txtInvResmptDe" readonly="readonly">
								</div>
								<input type="button" class="btn_text" onclick="fnResmpt(); return false" id="saveResmpt" value="수사재개" style="margin-left: 3px"/>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			</div>
		</div>
		</form>
	</div>
</div>
<!-- end 상세 -->
