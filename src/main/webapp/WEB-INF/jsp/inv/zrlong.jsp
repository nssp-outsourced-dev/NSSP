<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<title>체포/구속영장관리(신청내역)</title>
<style type="text/css">
.tbLft {
	text-align: left;
}
.my-column {
	color:#D9418C;
}

	/*
		2021.08.11
		coded by dgkim
		수사시스템 화면 비율 조정
		권종열 사무관 요청
	*/
	#gridT1_wrap, #gridT2_wrap { height: 152px !important; } /* 사건목록 */
	#showinbox { height: 190px !important; } /* 사건목록 영역 */
	/* #gridzrlong_wrap, #gridszure_wrap, #gridcmmng_wrap { height: 140px !important; } 체포/구속, 압수수색검증, 통신사실확인허가신청 */ 
	/* #ifrReportzrlong, #ifrReportszure, #ifrReportcmmng { height: 185px !important; } 작성문서목록 */
</style>
<!-- <script type="text/javascript" src="/js/cmmng.js"></script> -->
<script type="text/javascript">
	var zrlongDocNo = "00447";	/*구속양식*/
	var szureDocNo 	= "00449"; 	/*압수수색*/
	var cmmngDocNo 	= "00450";  /*00451 통신사실확인 작성문서 목록*/
	var cdNeedEtc 	= "00783";
	$(function() {
		fnSendKey ('${hidRcNo}', '${hidTrgterSn}', '${hidPageType}');
		fnTopLst ();
		/*체포/영장*/
		fnDatePickerImg("txtReqstDe",null,false);
		fnDatePickerImg("txtRstValidDt",null,false);
		fnDatePickerImg("txtIsueDt",null,false);
		fnDatePickerImg("txtArrstDt",null,false);
		fnDatePickerImg("txtReqValidDt",null,false);
		fnDatePickerImg("txtReqAttractDt",null,false);
		fnDatePickerImg("txtReqCnfnmDt",null,false);
		fnDatePickerImg("txtExcutDt",null,false);
		fnDatePickerImg("txtRstAttractDt",null,false);
		fnDatePickerImg("txtRstCnfnmDt",null,false);
		fnDatePickerImg("txtRslDt",null,false);

		/*압수/수색*/
		fnDatePickerImg("txtSzureReqstDe",null,false);
		fnDatePickerImg("txtSzureReqValidDt",null,false);
		fnDatePickerImg("txtSzureReqExcutDt",null,false);
		fnDatePickerImg("txtSzureRstValidDt",null,false);
		fnDatePickerImg("txtSzureIsueDt",null,false);
		fnDatePickerImg("txtSzureRstExcutDt",null,false);

		/*통신사실*/
		fnDatePickerImg("txtCmmngReqstDe",null,false);
		fnDatePickerImg("txtCmmngExcutDt",null,false);
		fnDatePickerImg("txtPrmisnRecptDe",null,false);
		fnDatePickerImg("txtIsueDe",null,false);
		fnDatePickerImg("txtDsmsslDe",null,false);
		fnDatePickerImg("txtReturnDe",null,false);

		initGrid ();
		fnDoc ("ifrReportzrlong","","",zrlongDocNo,"");
		fnDoc ("ifrReportszure","","",szureDocNo,"");
		fnDoc ("ifrReportcmmng","","",cmmngDocNo,"");
		fnTab ("m",0,3);
		fnTab ("s",0,2);
		fnTab ("z",0,2);
		fnTab ("c",0,2);
		$(".szReqD1").hide();
		$(".szReqD2").hide();
		$(".zClsS").hide();
		$(".zClsF").prop("colspan",3);

		fnSetCmmng ();
		fnKeyEvent ();

		$('#txtRereqstResn').keyup();
		$('#txtDsmsslResn').keyup();
		$('#txtDsmsslResn2').keyup();
		$('#txtExcutPlace2').keyup();
		$('#txtRstSzureThing').keyup();
		$("#txtZrlongReturnResn").keyup();
		$("#txtSzureReturnResn").keyup();
		
		/*
			2021.10.20
			coded by dgkim
			압수수색검증에 기록목록 기능 추가
			김지만 수사관 요청
		*/
		$('#btnRcord').hide();//기록목록 버튼
	});
	function fnKeyEvent () {
		$('#txtRereqstResn').keyup(function(){
			fnLimitString('txtRereqstResn', 2000, 'txtRereqstResnMsg');
		});
		$('#txtDsmsslResn').keyup(function(){
			fnLimitString('txtDsmsslResn', 2000, 'txtDsmsslResnMsg');
		});
		$('#txtDsmsslResn2').keyup(function(){
			fnLimitString('txtDsmsslResn2', 2000, 'txtDsmsslResnMsg2');
		});
		$('#txtExcutPlace2').keyup(function(){
			fnLimitString('txtExcutPlace2', 2000, 'txtExcutPlaceMsg');
		});
		$('#txtRstSzureThing').keyup(function(){
			fnLimitString('txtRstSzureThing', 2000, 'txtRstSzureThingMsg');
		});
		$("#txtZrlongReturnResn").keyup(function(){
			fnLimitString("txtZrlongReturnResn",2000,"txtZrlongReturnResnMsg");
		});
		$("#txtSzureReturnResn").keyup(function(){
			fnLimitString("txtSzureReturnResn",2000,"txtSzureReturnResnMsg");
		});
		$("#rdoNeed"+cdNeedEtc).change (function(){
			var strV = $(this).prop("checked");
			if(strV) {
				$("#txtNeedCnsdrEtc").prop ("readonly", false);
			} else {
				$("#txtNeedCnsdrEtc").val("");
				$("#txtNeedCnsdrEtc").prop ("readonly", true);
			}
		});
	}
	function fnSetRow (gId, gCol, gVal, gPos) {
		var rows = AUIGrid.getRowIndexesByValue(gId,gCol,gVal);
		if(!fnIsEmpty(rows) && rows[0] > -1) {
			AUIGrid.setSelectionByIndex(gId, rows[0], gPos);
		}
		return rows[0];
	}
	function fnSendKey (pRcNo, pTrSn, pPageType) {
		if((!fnIsEmpty(pRcNo) || !fnIsEmpty(pTrSn)) && !fnIsEmpty(pPageType)) {
			$("#searchRcNo").val(pRcNo);
			$("#searchTrgterSn").val(pTrSn);
			$("#searchPageType").val(pPageType);
		}
	}
	function fnSetCmmng () {
		$("#divBtnCmmngResult").hide();
		$("#selPrmisnSeCd").change(function(){
			fnSetTrAfterPermission($(this).val());
		});
		$("input:radio[name=rdoReqstResultCd]").change(function(){
			fnSetDisplay($(this).val());
		});
	}
	function fnTab(e, num, tabCnt){
		var num      = num||0;
		var menu     = $("#"+e+"Tab_box").children().children("li");//기록목록 버튼 제외
		var tabList  = $('#'+e+'Tab_list').children();  //ifrTab1
		var select   = $(menu).eq(num);
		var i        = num;
		menu.click(function(){
			if(select !== null){
				select.removeClass("current");
				tabList.eq(i).hide();
			}
			select = $(this);
			i = $(this).index();
			select.addClass("current");
			tabList.eq(i).show();
			if(e=="m") {
				switch(i) {
					case 0:
						fnTabSetGd("zrlong");
						$(".box_w2_1b_ov").css("width","calc(65% - 15px)");
						$("#gridT2_wrap").show();
						
						/*
							2021.10.20
							coded by dgkim
							압수수색검증에 기록목록 기능 추가
							김지만 수사관 요청
						*/
						$('#btnRcord').hide();//기록목록 버튼 숨기기
					
						break;
					case 1:
						fnTabSetGd("szure");
						$(".box_w2_1b_ov").css("width","100%");
						$("#gridT2_wrap").hide();
						AUIGrid.resize("#grid_trgter_list");
						AUIGrid.resize("#grid_szure_rst");
						AUIGrid.resize("#grid_acnut");
						
						/*
							2021.10.20
							coded by dgkim
							압수수색검증에 기록목록 기능 추가
							김지만 수사관 요청
						*/
						$('#btnRcord').show();//기록목록 버튼 보이기
					
						break;
					case 2:
						fnTabSetGd("cmmng");
						$(".box_w2_1b_ov").css("width","calc(65% - 15px)");
						$("#gridT2_wrap").show();
						
						/*
							2021.10.20
							coded by dgkim
							압수수색검증에 기록목록 기능 추가
							김지만 수사관 요청
						*/
						$('#btnRcord').hide();//기록목록 버튼 숨기기
						
						break;
				}
				//피의자 정보의 유무에 따른 크기 조절
				AUIGrid.resize("#gridT1_wrap");
			}
			if(e=="c") {
				switch(i) {
					case 0:
						$("#divBtnCmmngDetail").show();
						$("#divBtnCmmngResult").hide();
						break;
					case 1:
						$("#divBtnCmmngDetail").hide();
						$("#divBtnCmmngResult").show();
						break;
				}
			}
			if(e=="s") {
				if(i==1) {
					AUIGrid.resize("#grid_szure_rst");
					$("#btnSzureAdd").hide();
				} else {
					AUIGrid.resize("#grid_trgter_list");
					AUIGrid.resize("#grid_acnut");
					$("#btnSzureAdd").show();
				}
			}
			if(e=="z") {
				if(i==1) $("#btnZrlongAdd").hide();
				else $("#btnZrlongAdd").show();
			}
		});
		if(!fnIsEmpty('${hidPageType}')) {
			switch ('${hidPageType}') {
			case "commng":
				$("#mTab3").click ();
				break;
			case "szure":
				$("#mTab2").click ();
				break;
			}
		}
	}
	function fnTabSetGd(pTabId) {
		AUIGrid.resize("#grid"+pTabId+"_wrap");
		AUIGrid.clearSelection("#gridT1_wrap");
		var sn = $("#"+pTabId+"Form").find("input[name='hidRcNo']").val();
		if(!fnIsEmpty(sn)) {
			fnSetRow ("#gridT1_wrap", "grdRcNo", sn, 1);
		}
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
	function fnDoc (pId, pDocId, pParam, pDocNo, pFileId) {
		fnReportList(pId,pDocId,pDocNo,pParam,pFileId);
	}
	function initCol (pLst, pCol) {
		var zrlongReqstLst = [{"cd":"Y","cdNm":"신청완료"},{"cd":"N","cdNm":"신청취소"}];
		var reqstResultLst = [{"cd":"Y","cdNm":"가"},{"cd":"N","cdNm":"부"}];
		var columnLayout = [
 					{ dataField : "grdTrgterSn",   		headerText : "대상자일련번호", 	visible : false},
 	                { dataField : "grdCaseNo",      	headerText : "사건번호",
 						renderer : {type : "TemplateRenderer"},
 						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
 							return fnChangeNo (value);
 						}
 	                },
 	                { dataField : "grdRcNo",      		headerText : "접수번호", 		visible : false },
 	                { dataField : "grdZrlongNoOrg",   	headerText : "영장번호" },
 	                { dataField : pCol,   				headerText : "영장구분",
 	                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
	            			return gridComboLabel(pLst, value)
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
 	                },
 	                { dataField : "grdTrgterNmS",	headerText : "피의자",  width : 120 }
 	                ];
		return columnLayout;
	}
	function initGrid () {
		var cdArr = ["00772","00789","00102","01338"];
		var cdLst = fnAjaxAction2({txtUpCd:cdArr});
		var zrlongSeLst    = getCodeList (cdLst, cdArr[0]);
		var szureZrlongLst = getCodeList (cdLst, cdArr[1]);
		var trgterSeList   = getCodeList (cdLst, cdArr[2]);
		var acnutNmLst	   = getCodeList (cdLst, cdArr[3]);
		var dsmsLst 	   = [ {"cd":"P","cdNm":"검찰"}, {"cd":"C","cdNm":"법원"}, {"cd":"","cdNm":""} ];
		var columnLayoutT1 = [
	  					{ dataField : "grdCaseNo",      headerText : "사건번호",  	width : 120,
	  						renderer : {type : "TemplateRenderer"},
	 						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
	 							return fnChangeNo (value);
	 						}
	  					},
	  					{ dataField : "grdRcNo",      	headerText : "접수번호", 	visible : false },
	  					{ dataField : "grdPrsctDe",   	headerText : "입건일자", 	width : 100, dataType : "date", formatString : "yyyy-mm-dd"},
	  					{ dataField : "grdInvProvisNm",	headerText : "수사단서", 	width : 100 },
	  					{ dataField : "grdTrgterNmS",	headerText : "피의자 성명",  width : 120 },
	  	   				{ dataField : "grdVioltNm",		headerText : "위반죄명", 	style:'tbLft' },
	  	                ];
		var columnLayoutT2 = [
					{ dataField : "grdTrgterSn",   	headerText : "대상자일련번호", visible : false},
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
	                { dataField : "grdTrgterNm",    headerText : "피의자명" }
	                ];
		var columnLayoutCmm = [
		            {headerText : "진행번호", 	dataField : "grdPrmisnProgrsNo",
		            	renderer : {type : "TemplateRenderer"},
 						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
 							return fnChangeNo (value);
 						}
		            },
		            {headerText : "허가구분", 	dataField : "grdPrmisnSeCdNm"},
		            {headerText : "사건번호", 	dataField : "grdCaseNo",
		            	renderer : {type : "TemplateRenderer"},
 						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
 							return fnChangeNo (value);
 						}
		            },
		            {headerText : "접수번호", 	dataField : "grdRcNo", 		visible : false},
		            {headerText : "신청일자", 	dataField : "grdReqstDe", 	dataType : "date", formatString : "yyyy-mm-dd"},
		            {headerText : "대상자",	dataField : "grdTrgterNm"},
		            {headerText : "신청결과",	dataField : "grdReqstResultCdNm"},
		            {headerText : "재신청여부",dataField : "grdRereqstYn"}
					];
		var columnLayoutAcnt = [
   		            {headerText : "접수번호", 		dataField : "grdRcNo", 			visible : false},
   		            {headerText : "대상자일련번호", 	dataField : "grdTrgterSn", 		visible : false},
   		            {headerText : "영장신청번호", 	dataField : "grdZrlongReqstNo", visible : false},
   		         	{headerText : "계좌명의구분",	dataField : "grdAcnutNmCd",
	                	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
	            			return gridComboLabel(acnutNmLst, value)
	            		}
	            	},
   		            {headerText : "계좌명의인", 		dataField : "grdAcnutNm"},
   		            {headerText : "개설은행", 		dataField : "grdAcnutBank"},
   		            {headerText : "계좌번호",		dataField : "grdAcnutNo"},
   		            {headerText : "거래기간",		dataField : "grdDelngPd"},
   		            {headerText : "거래정보등의내용",	dataField : "grdDelngCn"}
   					];
		var columnLayoutSz = [
					{headerText : "접수번호", 		dataField : "grdRcNo", 			visible : false },
					{headerText : "영장신청번호", 	dataField : "grdZrlongReqstNo", visible : false },
					{headerText : "영장번호 <img src='/img/point.png'/>", dataField : "grdZrlongNo" },
					{ headerText : "유효일시 <img src='/img/point.png'/>",
						children: [
							{headerText : "일자", dataField : "grdRstValidDt",
								dataType : "date",
								formatString : "yyyy.mm.dd.",
								width:110,
								editRenderer : calendarRenderer
								//{
									//type : "CalendarRenderer",
									//showExtraDays : false, 	// 지난 달, 다음 달 여분의 날짜(days) 출력 안함
									//onlyCalendar : true 	// 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
								//}
							},
							{headerText : "시간", 		dataField : "grdRstValidDt2", width : 50,
								editRenderer : {
									type : "InputEditRenderer",
									onlyNumeric : true, // Input 에서 숫자만 가능케 설정
									// 에디팅 유효성 검사
									validator : function(oldValue, newValue, item) {
										var isValid = false;
										var numVal = Number(newValue);
										if(!isNaN(numVal) && numVal < 24) {
											isValid = true;
										}
										return { "validate" : isValid, "message"  : "24 보다 작은수 수를 입력하세요." };
									}
								}
							},
							{headerText : "분", 			dataField : "grdRstValidDt3", width : 50,
								editRenderer : {
									type : "InputEditRenderer",
									onlyNumeric : true, // Input 에서 숫자만 가능케 설정
									// 에디팅 유효성 검사
									validator : function(oldValue, newValue, item) {
										var isValid = false;
										var numVal = Number(newValue);
										if(!isNaN(numVal) && numVal < 60) {
											isValid = true;
										}
										return { "validate" : isValid, "message"  : "60 보다 작은수 수를 입력하세요." };
									}
								}
							},
						]
					},
					{ headerText : "발부일시 <img src='/img/point.png'/>",
						children: [
							{headerText : "일자",		dataField : "grdIsueDt",
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
							{headerText : "시간", 		dataField : "grdIsueDt2", width : 50,
								editRenderer : {
									type : "InputEditRenderer",
									onlyNumeric : true, // Input 에서 숫자만 가능케 설정
									// 에디팅 유효성 검사
									validator : function(oldValue, newValue, item) {
										var isValid = false;
										var numVal = Number(newValue);
										if(!isNaN(numVal) && numVal < 24) {
											isValid = true;
										}
										return { "validate" : isValid, "message"  : "24 보다 작은수 수를 입력하세요." };
									}
								}
							},
							{headerText : "분", 			dataField : "grdIsueDt3", width : 50,
								editRenderer : {
									type : "InputEditRenderer",
									onlyNumeric : true, // Input 에서 숫자만 가능케 설정
									// 에디팅 유효성 검사
									validator : function(oldValue, newValue, item) {
										var isValid = false;
										var numVal = Number(newValue);
										if(!isNaN(numVal) && numVal < 60) {
											isValid = true;
										}
										return { "validate" : isValid, "message"  : "60 보다 작은수 수를 입력하세요." };
									}
								}
							},
						]
					},
				    {headerText : "기각기관", 		dataField : "grdDsmsslInsttCd",
						editRenderer : {
							type : "DropDownListRenderer",
							list : dsmsLst,
							keyField : "cd",
							valueField : "cdNm"
						},
				    	labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
	            			return gridComboLabel(dsmsLst, value)
	            		}
					},
				    {headerText : "기각사유", 		dataField : "grdDsmsslResn"}
		            ];
		var gridPros = {
			displayTreeOpen : true,
			rowNumHeaderText:"순번",
			selectionMode : "singleCell",	// 선택모드 (기본값은 singleCell 임)
			//noDataMessage:"조회 목록이 없습니다.",
			headerHeight : 30,
			rowHeight: 30,
			softRemoveRowMode : false,
			fillColumnSizeMode : true
		};
		AUIGrid.create("#gridT1_wrap",columnLayoutT1,gridPros);
		AUIGrid.create("#gridT2_wrap",columnLayoutT2,gridPros);
		AUIGrid.create("#gridzrlong_wrap",initCol(zrlongSeLst,   "grdZrlongSeCd"),gridPros);
		AUIGrid.create("#gridszure_wrap", initCol(szureZrlongLst,"grdSzureZrlongCd"),gridPros);
		AUIGrid.create("#gridcmmng_wrap", columnLayoutCmm,gridPros);

		AUIGrid.create("#grid_acnut",columnLayoutAcnt,$.extend(gridPros,{ showRowCheckColumn : true }));
		columnLayoutT2.push ({ dataField : "grdTrgterRrn",   headerText : "주민번호" });
		AUIGrid.create("#grid_trgter_list",columnLayoutT2,gridPros);

		AUIGrid.create("#grid_szure_rst",  columnLayoutSz,$.extend(gridPros,{
			showRowCheckColumn : false,
			editable : true,
			showStateColumn : true,
			editBeginMode : "click",
			enableDrag : true,
			enableDragByCellDrag : true,
			softRemoveRowMode : true,
		}));

		AUIGrid.bind("#gridT2_wrap", "cellClick", function(event) {
			var items = event.item;
			var chk1 = $("#mTab_box").find("#mTab1").hasClass("current");
			var chk2 = $("#mTab_box").find("#mTab2").hasClass("current");
			if(chk1) {
				fnGridDtlList (items, "zrlong", "zrlongForm");
			} else if(chk2){
				//사건단위로 조회함
				//fnGridDtlList (items, "szure", "szureForm");
			} else {
				fnCmmngGridDtlList (items, "cmmng");
			}
			$("#hide").click();
		});
		AUIGrid.bind("#grid_szure_rst", "cellClick", function(event) {
			var items = event.item;
			fn_form_bind ("szureRstDtlForm",items,"GRID");
		});
		AUIGrid.bind("#gridzrlong_wrap", "cellClick", function(event) {
			var items = event.item;
			fnZrlongDtlList (items, "zrlong");
		});
		AUIGrid.bind("#gridszure_wrap", "cellClick", function(event) {
			var items = event.item;
			fnZrlongDtlList (items, "szure");
		});
		AUIGrid.bind("#gridcmmng_wrap", "cellClick", function(event) {
			var items = event.item;
			fnCmmngDtlList(items);
		});
		AUIGrid.bind("#gridT1_wrap", "cellClick", function(event) {
			var items = event.item.grdRcNo;
			if(!fnIsEmpty(items)) {
				$("#searchRcNo").val(items);
				fnT2Search ();
				var chk1 = $("#mTab_box").find("#mTab1").hasClass("current");
				var chk2 = $("#mTab_box").find("#mTab2").hasClass("current");
				if(chk1) {
					fnReset (1, "zrlong", false);
				} else if(chk2){
					fnReset (1, "szure", false);
					fnGridDtlList (event.item, "szure", "szureForm");
					$("#hide").click();
				} else {
					fnCmmngReset(1);
				}
			} else {
				alert("접수번호가 확인되지 않습니다.");
			}
		});
		AUIGrid.bind("#grid_szure_rst", "ready", function(event) {
			var gdt = AUIGrid.getGridData(event.pid);
			if(fnIsEmpty(gdt) || gdt.length == 0) {
				fnGridChg (1, 2);
			} else {
				AUIGrid.setSelectionByIndex(event.pid, 0, 2);
				fn_form_bind ("szureRstDtlForm",gdt[0],"GRID");
			}
		});		
		AUIGrid.bind("#gridT1_wrap", "ready", function(event) {
			var hidRcNo  = $("#searchRcNo").val();
			if(!fnIsEmpty(hidRcNo)) {
				fnSetRow (event.pid, "grdRcNo", hidRcNo, 0);
				var hidPageType = $("#searchPageType").val();
				if(!fnIsEmpty(hidPageType) && hidPageType == "szure") {
					var selectedItems = AUIGrid.getSelectedItems(event.pid);
					if(selectedItems.length > 0) {
						fnGridDtlList (selectedItems[0].item, "szure", "szureForm");
						$("#hide").click();
					}
				} else {
					fnT2Search ();
				}
			}
		});
		AUIGrid.bind("#gridT2_wrap", "ready", function(event) {
			var hidTrgterSn = $("#searchTrgterSn").val();
			var hidRcNo   = $("#searchRcNo").val();
			var hidPageType = $("#searchPageType").val();
			if(!fnIsEmpty(hidTrgterSn) && !fnIsEmpty(hidRcNo) && !fnIsEmpty(hidPageType)) {
				var srow = fnSetRow (event.pid, "grdTrgterSn", hidTrgterSn, 3);
				if(srow > -1) {
					var gdt = AUIGrid.getGridData(event.pid);
					switch (hidPageType) {					
					case "commng":
						fnCmmngGridDtlList (gdt[srow], "cmmng");
						$("#hide").click();
						break;
					case "zrlong":	
						fnGridDtlList (gdt[srow], hidPageType, hidPageType+"Form");
						$("#hide").click();
						break;
					default :
						$("#searchForm").resetForm ();
						break;
					}
				} else {
					$("#searchForm").resetForm ();
				}
			} else {
				$("#searchForm").resetForm ();
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
	function fnCmmngSearch (pForm) {
		var gid = "#gridcmmng_wrap";
		var gdt = fnSearchGridAdd ("/inv/commnListAjax/", pForm, gid);	
		AUIGrid.setGridData(gid, gdt);
		var key = $("#hidPrmisnProgrsNo").val();
		if(!fnIsEmpty(key)) {
			fnSetRow (gid, "grdPrmisnProgrsNo", key, 1);
		} else {
			if(!fnIsEmpty(gdt) && gdt.length > 0) {
				AUIGrid.setSelectionByIndex(gid, 0, 0);
				fnCmmngDtlList(gdt[0]);
			}
		}		
		$("#searchForm").resetForm ();
	}
	function fnZrlongDtlList (items, pTabId) {
		fnReset (2, pTabId, false);
		var processAfterGet = function(data) {
			//tab1
			fn_form_bind (pTabId+"ReqDtlForm",data,"");
			$("#"+pTabId+"ReqDtlForm").find("input[name='hidCudType']").val("U");
			if(pTabId=="zrlong") {
				//필요고려사항
				if(!fnIsEmpty(data.needCnsdrCd)) {
					var arrRn = data.needCnsdrCd.split(",");
					for(var i in arrRn) {
						$("input:checkBox[name='rdoNeedCnsdrCdChk']:checkBox[value='"+arrRn[i]+"']").prop("checked",true);
						//기타
						if(arrRn[i]==cdNeedEtc) {   /*기타*/
							$("#txtNeedCnsdrEtc").prop ("readonly", false);
						}
					}
				}
				fnZrCdSeClick (data.zrlongSeCd);
				fn_form_bind (pTabId+"RstDtlForm",data,""); //tab2
			} else {
				//압수수색영장구분
				fnSzrlSeClk (data.szureZrlongCd);
				//압수수색 계좌 정보
				fnGetSzureAcnutLst (data.zrlongReqstNo);
				//압수수색결과
				fnSearchGridData ("/inv/szureRstListAjax/", "#grid_szure_rst", "hidRcNo="+data.rcNo+"&hidZrlongReqstNo="+data.zrlongReqstNo);
				//압수수색 피의자 선택정보
				fnGetSzureTrgterLst (data.zrlongReqstNo);
			}
			//영장신청일, 체포일시, 체포장소
			fn_form_bind (pTabId+"TrgterInfoForm",data,"");

			if(fnIsEmpty(data.zrlongNo)) {
				$("#"+pTabId+"RstDtlForm").find("#hidCudType").val("C");
			} else {
				$("#"+pTabId+"RstDtlForm").find("#hidCudType").val("U");
			}
			
			//doc
			fnDoc("ifrReport"+pTabId,data.docId,"P_RC_NO="+data.rcNo+"&P_TRGTER_SN="+data.trgterSn+"&P_ZRLONG_REQST_NO="+data.zrlongReqstNo+"&P_ZRLONG_NO="+data.zrlongNo, eval(pTabId+"DocNo"), data.fileId);

			console.log("P_RC_NO="+data.rcNo+"&P_TRGTER_SN="+data.trgterSn+"&P_ZRLONG_REQST_NO="+data.zrlongReqstNo+"&P_ZRLONG_NO="+data.zrlongNo);
			/*
				2021.10.20
				coded by dgkim
				압수수색검증에 기록목록 기능 추가
				김지만 수사관 요청
			*/
			$("#rcNo").val(data.rcNo);
			
			/*압수수색쪽에는 없음*/
			if(pTabId == "zrlong") $("#"+pTabId+"TrgterInfoForm").find("#labCaseNo").text(fnChangeNo($("#"+pTabId+"TrgterInfoForm").find("#labCaseNo").text()));
		}
		Ajax.getJson("<c:url value='/inv/"+pTabId+"DtlAjax/'/>", "grdZrlongReqstNo="+items.grdZrlongReqstNo, processAfterGet);
	}
	function fnGridDtlList (items, pTabId, pForm) {
		fnReset (1, pTabId, false);
		$("#"+pTabId+"RstDtlForm").find("input[name='hidRcNo']").val(items.grdRcNo);
		$("#"+pTabId+"Form").find("input[name='hidRcNo']").val(items.grdRcNo);
		$("#"+pTabId+"RstDtlForm").find("input[name='hidTrgterSn']").val(items.grdTrgterSn);
		$("#"+pTabId+"Form").find("input[name='hidTrgterSn']").val(items.grdTrgterSn);
		if(fnIsEmpty(pForm) || pForm != "searchForm") {
			if(!fnChkKey("조회",1,'S',pTabId)) return;
		}
		if(!fnIsEmpty(pTabId)) {
			var gid = "#grid"+pTabId+"_wrap";
			var gdt = fnSearchGridAdd ("/inv/"+pTabId+"ListAjax/", pForm, gid);	
			AUIGrid.setGridData(gid, gdt);
			
			if(pTabId == "szure") {
				AUIGrid.setGridData("#grid_trgter_list",fnSearchGridAdd("/inv/suspectZrlongListAjax/", "searchForm", "#grid_trgter_list")); //하단의 대상자 정보
			}			
			if(!fnIsEmpty(gdt) && gdt.length > 0) {
				AUIGrid.setSelectionByIndex(gid, 0, 1);
				fnZrlongDtlList (gdt[0], pTabId);
			}			
		}		
		fn_form_bind (pTabId+"TrgterInfoForm",items,"GRID");

		if(!fnIsEmpty(pForm) && pForm == "searchForm") {
			$("#searchForm").resetForm ();
		}

		/*압수수색쪽에는 없음*/
		if(pTabId == "zrlong") $("#"+pTabId+"TrgterInfoForm").find("#labCaseNo").text(fnChangeNo($("#"+pTabId+"TrgterInfoForm").find("#labCaseNo").text()));
	}
	function fnChkKey (pMsg, pType, pSe, pTabId) {
		if(pTabId == "szure") {
			if(fnIsEmpty($("#"+pTabId+"Form").find("input[name='hidRcNo']").val())) {
				alert("최상단 목록에서 사건을 선택 후 "+pMsg+"해 주세요.");
				return false;
			}
		} else {
			if(fnIsEmpty($("#"+pTabId+"Form").find("input[name='hidRcNo']").val())
					||fnIsEmpty($("#"+pTabId+"Form").find("input[name='hidTrgterSn']").val())) {
				alert("최상단 우측 피의자를 선택 후 "+pMsg+"해 주세요.");
				return false;
			}
		}
		if(pSe == 'D') {
			if(fnIsEmpty($("#"+pTabId+"ReqDtlForm").find("input[name='hidZrlongReqstNo']").val())) {
				alert("상단 좌측 영장신청 현황을 선택 후 "+pMsg+"해 주세요.");
				return false;
			}
		}
		if(pType == 2) {
			if(fnIsEmpty($("#"+pTabId+"RstDtlForm").find("input[name='hidZrlongReqstNo']").val())) {
				alert("상단 죄측 영장신청 현황을 선택 후 "+pMsg+"해 주세요.");
				return false;
			}
			if(pSe == 'D') {
				if(fnIsEmpty($("#"+pTabId+"RstDtlForm").find("input[name='hidZrlongNoOrg']").val())) {
					alert("영장 신청 결과가 없습니다. 신청 결과 여부를 다시 확인하여 주시기 바랍니다.");
					return false;
				}
			}
		}
		return true;
	}
	function fnReset (pType, sTabId, sRstType) {
		if(fnIsEmpty(sRstType)) {
			sRstType = false;
		}
		if(!sRstType) {  /*결과 페이지 인지의 여부, 결과 페이지가 아닐경우만 reset*/
			$("#"+sTabId+"ReqDtlForm").clearForm ();
			$("#"+sTabId+"TrgterInfoForm").find(".dtlRs").val("");
			$("#"+sTabId+"ReqDtlForm").find("input[name='hidCudType']").val("C");
			if(sTabId == "szure") {
				fnSzrlSeClk ("00790");	/*사전으로 set*/
			}
			if(pType == 1) {
				$("#"+sTabId+"TrgterInfoForm").clearForm ();
				$("#"+sTabId+"TrgterInfoForm").find(".clrLabel").text("");
				$("#"+sTabId+"Form").clearForm ();
				AUIGrid.clearGridData("#grid"+sTabId+"_wrap");
				fnDoc ("ifrReport"+sTabId,"","",eval(sTabId+"DocNo"),"");
			}
			$("#"+sTabId+"TrgterInfoForm").find("#labWritngNm").text("${hidLoginNm}"); //영장 작성자 - 기본 정보
		}
		$("#"+sTabId+"RstDtlForm").clearForm ();
		$("#"+sTabId+"RstDtlForm").find("input[name='hidCudType']").val("C");
		AUIGrid.clearGridData("#grid_szure_rst");
	}
	function fnAdd (sTabId) {
		var rstCurrent = $("#"+sTabId+"Tab2").hasClass("current");
		//우선 reset 부터
		fnReset (2,sTabId,rstCurrent);
		if(!fnChkKey("추가",1,'A',sTabId)) return;
		if(sTabId == "szure" && rstCurrent) {
			fnGridChg (1, 2);
		}
	}
	function fnSave (sTabId) {
		if(sTabId=="szure") {
			var sMsg = "압수/수색/검증";
		} else {
			var sMsg = "체포/구속";
		}
		//활성 tab 확인
		var tab1 = $("#"+sTabId+"Tab1").hasClass("current");
		if(tab1) {
			//신청내역 저장
			if(!fnChkKey("영장을 신청",1,'S',sTabId)) return;
			$("#"+sTabId+"ReqDtlForm").find("input[name='hidRcNo']").val($("#"+sTabId+"Form").find("input[name='hidRcNo']").val());
			$("#"+sTabId+"ReqDtlForm").find("input[name='hidTrgterSn']").val($("#"+sTabId+"Form").find("input[name='hidTrgterSn']").val());
			if(fnFormValueCheck(sTabId+"ReqDtlForm") && fnFormValueCheck(sTabId+"TrgterInfoForm")){
				var sTabIdU = sTabId.charAt(0).toUpperCase() + sTabId.slice(1);
				fnLajax ("save"+sTabIdU+"Ajax","SAVE",sTabId+"ReqDtlForm", $("#"+sTabId+"ReqDtlForm").find("input[name='hidCudType']").val(), sTabId);
			}
		} else {
			//신청결과 저장
			if(!fnChkKey("영장 신청결과를 저장",2,'S',sTabId)) return;
			$("#"+sTabId+"RstDtlForm").find("input[name='hidRcNo']").val($("#"+sTabId+"Form").find("input[name='hidRcNo']").val());
			$("#"+sTabId+"RstDtlForm").find("input[name='hidTrgterSn']").val($("#"+sTabId+"Form").find("input[name='hidTrgterSn']").val());
			if(fnFormValueCheck(sTabId+"RstDtlForm")){
				var sTabIdU = sTabId.charAt(0).toUpperCase() + sTabId.slice(1);
				fnLajax ("save"+sTabIdU+"RstAjax","SAVE",sTabId+"RstDtlForm", $("#"+sTabId+"RstDtlForm").find("input[name='hidCudType']").val(), sTabId);
			}
		}
	}
	function fnDel (sTabId) {
		if(sTabId=="szure") {
			var sMsg = "압수/수색/검증";
		} else {
			var sMsg = "체포/구속";
		}
		//활성 tab 확인
		var tab1 = $("#"+sTabId+"Tab1").hasClass("current");
		if(tab1) {
			if(!fnChkKey("영장을 삭제",1,'D', sTabId)) return;
			//결과가 나왔다면???
			if(!fnIsEmpty($("#"+sTabId+"RstDtlForm").find("input[name='hidZrlongNo']").val())) {
				if(!confirm("신청이 완료된 "+sMsg+" 영장입니다. \n\n삭제하시겠습니까?")) return;
			} else {
				if(!confirm(sMsg+" 영장 신청을 취소하시겠습니까?")) return;
			}
			$("#"+sTabId+"ReqDtlForm").find("input[name='hidCudType']").val("D");
			var sTabIdU = sTabId.charAt(0).toUpperCase() + sTabId.slice(1);
			fnLajax ("save"+sTabIdU+"Ajax","DEL",sTabId+"ReqDtlForm","D", sTabId);
		} else {
			if(!fnChkKey("영장 신청결과를 삭제",2,'D',sTabId)) return;
			if(!confirm(sMsg+" 영장 신청 결과를 취소하시겠습니까?")) return;
			if(sTabId=="szure") {
				fnGridChg (2, 2);
			}
			$("#"+sTabId+"RstDtlForm").find("input[name='hidCudType']").val("D");
			var sTabIdU = sTabId.charAt(0).toUpperCase() + sTabId.slice(1);
			fnLajax ("save"+sTabIdU+"RstAjax","DEL",sTabId+"RstDtlForm","D", sTabId);
		}
	}
	function fnLajax (sUrl, type, pForm, pCudType, sTabId) {
		if(type == 'SAVE') {
			if(fnIsEmpty(pCudType)||pCudType=="D") {
				fnReset (2, sTabId, false);
				alert("ERROR");
				return;
			}
		}
		$.each($('#'+pForm).find('input:checkbox')
			.filter(function(idx){
				return (!fnIsEmpty($(this).prop('name')) && $(this).prop('name') != "rdoNeedCnsdrCdChk")
			}),
			function(idx, el){
				if(this.checked) {
					$(this).val("Y")
				}
		});
		var param = $('#'+pForm).serialize();
		    param += ("&"+ $('#'+sTabId+'TrgterInfoForm').serialize()); //체포일시, 체포장소, 영장신청일
		if(sTabId == 'zrlong') {
			var arrNeedCd = [];
			$.each($('input[name=rdoNeedCnsdrCdChk]')
				.filter(function(idx){
					return $(this).prop('checked') === true
				}),
				function(idx, el){
					arrNeedCd.push($(this).val());
			});
			param += ("&rdoNeedCnsdrCd="+arrNeedCd);
		} else if (sTabId == "szure") {
			if(pForm == "szureReqDtlForm") {
				//계좌
				var acnutGdata = AUIGrid.getGridData("#grid_acnut");
				if(acnutGdata != null && acnutGdata.length > 0) {
					param += ("&grdAcnutData="+JSON.stringify(acnutGdata));
				}
				//피의자
				var checkedItems = AUIGrid.getCheckedRowItems("#grid_trgter_list");
				if(checkedItems.length <= 0 ) {
					alert("피의자를 선택하여 주십시오.");
					return;
				} else {
					var trgterGdata = [];
					for(var i in checkedItems) {
						trgterGdata.push (checkedItems[i].item);
					}
					param += ("&grdTrgterData="+JSON.stringify(trgterGdata));
				}
			} else {
				var szureRstGdata = AUIGrid.getGridData("#grid_szure_rst");
				if(szureRstGdata == null || szureRstGdata.length < 1) {
					alert("영장결과 정보를 입력하여 주십시오.");
					fnGridChg (1, 2);
					return;
				}
				var valiArr = ["grdZrlongNo", "grdRstValidDt","grdRstValidDt2","grdRstValidDt3","grdIsueDt","grdIsueDt2","grdIsueDt3"];
				if(AUIGrid.validateGridData("#grid_szure_rst", valiArr, "필수 필드는 반드시 값을 직접 입력해야 합니다.")) {
					//영장번호 체크
					var selectedGdata = AUIGrid.getSelectedItems("#grid_szure_rst");
					$("#szureReqDtlForm").find("#hidSzureRstZrlongNo").val(selectedGdata[0].item.grdZrlongNo);

					var szureGdata = "";
					var addedRowItems = AUIGrid.getAddedRowItems("#grid_szure_rst");
					if(addedRowItems.length > 0) {
						szureGdata = "&grdRstAdd="+JSON.stringify(addedRowItems);
					}
					var editedRowItems = AUIGrid.getEditedRowItems ("#grid_szure_rst"); //getEditedRowColumnItems("#grid_szure_rst");
					if(editedRowItems.length > 0) {
						szureGdata += ("&grdRstEdit="+JSON.stringify(editedRowItems));
					}
					var removedRowItems = AUIGrid.getRemovedItems("#grid_szure_rst");
					if(removedRowItems.length > 0) {
						szureGdata += ("&grdRstDel="+JSON.stringify(removedRowItems));
					}
					param += szureGdata;
				} else {
					return;
				}
			}
		}

		var processAfterGet = function(data) {
			if(type == "SAVE" || type == "DEL") {
				if(!fnIsEmpty(data.rst)) {
					if(!fnIsEmpty(data.rst["ERROR"])) {
						alert(data.rst["ERROR"]);
					} else {
						AUIGrid.setGridData("#grid"+sTabId+"_wrap", data.list);
						if(type=="DEL") {
							alert("삭제되었습니다.");
							fnAdd (sTabId);
						} else {
							var msg = "저장되었습니다.";
							if(!fnIsEmpty(data.rst["CHK"])) {
								msg = data.rst["CHK"];
							}
							alert(msg);
							//상세보기 조회
							var rtnval = data.rst;
							if(fnIsEmpty(rtnval)) {
								fnAdd (sTabId);
							} else {
								fnSetRow ("#grid"+sTabId+"_wrap", "grdZrlongReqstNo", rtnval.rtnZrlongReqNo, 3);
								fnZrlongDtlList ({grdZrlongReqstNo:rtnval.rtnZrlongReqNo}, sTabId);
							}
						}
					}
				} else {
					alert("오류 발생!");
				}
			}
		}
		Ajax.getJson("<c:url value='/inv/"+sUrl+"/'/>", param, processAfterGet);
	}
	function fnSzrlSeClk (pVal) {
		//00791 > 긴급
		//00792 > 금융계좌추적
		if(pVal == '00791') {
			$(".szReqD1").show();
			$(".szReqD2").hide();
		} else if (pVal == '00792') {
			$(".szReqD1").hide();
			$(".szReqD2").show();
			AUIGrid.resize("#grid_acnut");
		} else {
			$(".szReqD1").hide();
			$(".szReqD2").hide();
		}
	}
	function fnSelectUser (userId, userNm, userDeptNm, userClsfNm, userResdncAddr, hidId) {
		$("#"+hidId).val(userId);
		$("#"+hidId.replace("Id","Nm").replace("hid","txt")).val(userNm);
	}
	/*압수수색*/
	function fnCmmngDtlList (items) {
		fnCmmngReset(2);
		var iUrl = "<c:url value='/inv/commnInfoAjax/'/>";
		var queryString = {hidPrmisnProgrsNo : items.grdPrmisnProgrsNo};
		var processAfterGetCmmng = function(data) {
			// 버튼 제어
			fnCmmngSetButton(data.reqstResultCd);
			// 신청내역 - 사후허가, 재신청사유
			fnSetTrAfterPermission(data.prmisnSeCd);
			fnSetTrRerqest(data.orignlProgrsNo);
			// 신청결과 - 입력항목 제어
			fnSetDisplay(data.reqstResultCd);

			//기본정보
			fn_form_bind ("cmmngForm",data,"");

			// 신청내역
			fn_form_bind ("cmmngReqDtlForm",data,"");
			$("#labCmmngPrmisnProgrsNo").html(fnChangeNo(data.prmisnProgrsNo));
			$("#labCmmngRcNo").html(fnChangeNo(data.rcNo));
			$("#cmmngReqDtlForm").find("#labCaseNo").text(fnChangeNo(items.grdCaseNo)); //사건번호

			// 신청결과
			fn_form_bind ("cmmngRstDtlForm",data,"");
			$("#labCmmngPrmisnProgrsNo2").html(fnChangeNo(data.prmisnProgrsNo));
			$("#labAlotUserNm2").html(data.alotUserNm);  // 담당자

			if(data.reqstResultCd == "00737") { // 허가신청
				$("input:radio[name=rdoReqstResultCd]").prop("disabled", false);
			} else {
				$("input:radio[name=rdoReqstResultCd]:checked").prop("disabled", false);
				$("input:radio[name=rdoReqstResultCd]:not(:checked)").prop("disabled", true);
			}
			fnDoc ("ifrReportcmmng", data.docId, "P_PRMISN_PROGRS_NO="+data.prmisnProgrsNo, cmmngDocNo, data.fileId);
		};
		Ajax.getJson(iUrl, queryString, processAfterGetCmmng);
	}
	function fnCmmngReset(type) {
		$("#cmmngReqDtlForm").clearForm ();
		$("#cmmngRstDtlForm").clearForm ();
		if(type != 2) {
			$("#cmmngForm").clearForm();
			$(".cmmngClrLabel").text("");
			AUIGrid.clearGridData("#gridcmmng_wrap");
			fnDoc ("ifrReportcmmng", "", "", cmmngDocNo,"");
		}
		$("#labCmmngPrmisnProgrsNo").empty();
		$("#labCmmngPrmisnProgrsNo2").empty();
		fnCmmngSetButton(null);
		$("#labAlotUserNm").text("${hidLoginNm}");
		$("#labAlotUserNm2").text("${hidLoginNm}");
	}
	function fnCmmngSetButton (str) {
		if(fnIsEmpty(str)) {
			$("#btnCmmngNew").show();
			$("#btnCmmngTrgterPop").show();
			$("#btnCmmngRereqst").hide();
			$("#btnCmmngDel").hide();
			$("#btnCmmngSave").show();
			$("#btnCmmngSaveResult").show();
		} else {
			if(str == "00737") { // 허가신청
				$("#btnCmmngNew").show();
				$("#btnCmmngTrgterPop").hide();
				$("#btnCmmngRereqst").hide();
				$("#btnCmmngDel").show();
				$("#btnCmmngSave").show();
				$("#btnCmmngSaveResult").show();
			} else if(str == "00738" || str == "00740") { // 허가, 반환
				$("#btnCmmngNew").show();
				$("#btnCmmngTrgterPop").hide();
				$("#btnCmmngRereqst").hide();
				$("#btnCmmngDel").hide();
				$("#btnCmmngSave").hide();
				$("#btnCmmngSaveResult").hide();
			} else if(str == "00739") {  // 기각
				$("#btnCmmngNew").show();
				$("#btnCmmngTrgterPop").hide();
				$("#btnCmmngRereqst").show();
				$("#btnCmmngDel").hide();
				$("#btnCmmngSave").hide();
				$("#btnCmmngSaveResult").hide();
			}
		}
	}
	function fnSetTrAfterPermission(str) {
		if(fnIsEmpty(str)) {
			$("#trAfterPermission").css("display", "none");
		} else {
			if(str == "00743") { // 사후허가
				$("#trAfterPermission").css("display", "");
			} else {
				$("#trAfterPermission").css("display", "none");
			}
		}
	}
	function fnSetTrRerqest(sOrgNo) {
		if(fnIsEmpty(sOrgNo)) {
			$("#trRerqest").css("display", "none");
		} else {
			$("#trRerqest").css("display", "");
		}
	}
	function fnSetDisplay(str) {
		if(str == "00739") { // 기각
			$("#tabPrimsn").css("display", "none");
			$("#tabDsmssl").css("display", "");
			$("#tabReturn").css("display", "none");
		} else if(str == "00740") { // 반환
			$("#tabPrimsn").css("display", "none");
			$("#tabDsmssl").css("display", "none");
			$("#tabReturn").css("display", "");
		} else {
			$("#tabPrimsn").css("display", "");
			$("#tabDsmssl").css("display", "none");
			$("#tabReturn").css("display", "none");
		}
	}
	function fnCmmngGridDtlList (items) {
		fnCmmngReset (1);
		fn_form_bind ("cmmngForm",items,"GRID");		//기본정보
		$("#labCmptncExmnNm").text(fnIsEmpty(items.grdCmptncExmnNm)?"":items.grdCmptncExmnNm); //관할검찰
		fn_form_bind ("cmmngReqDtlForm",items,"GRID"); 	// 신청내역
		$("#labCmmngRcNo").html(items.grdRcNo);
		$("#cmmngReqDtlForm").find("#labCaseNo").text(fnChangeNo(items.grdCaseNo)); //사건번호
		fn_form_bind ("cmmngRstDtlForm",items,"GRID");	// 신청결과
		fnCmmngSearch ('cmmngForm');
	}
	function fnCmmngRereqst() {
		if(!fnIsEmpty($("#hidRereqstYn").val()) && $("#hidRereqstYn").val() == "Y") {
			alert("이미 재신청한 건으로 다시 재신청할 수 없습니다.");
			return;
		}
		var iUrl = "<c:url value='/inv/addCommnReAjax/'/>";
		var queryString = $('#cmmngReqDtlForm').serialize();
		var processAfterGet = function(data) {
			if(data.result == "1"){
				alert("재신청되었습니다.");
				fnCmmngGridDtlList({grdRcNo:$("#hidMcmmngRcNo").val(),grdTrgterSn:$("#hidMcmmngTrgterSn").val(),grdCaseNo:$("#cmmngReqDtlForm").find("#labCaseNo").text()});
				fnCmmngDtlList({grdPrmisnProgrsNo:data.key});
			}else{
				alert("재신청중 오류가 발생하였습니다.");
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}
	function fnCmmngDel() {
		if(fnIsEmpty($("#hidPrmisnProgrsNo").val())) return;
		if(!fnIsEmpty($("#hidReqstResultCd").val()) && $("#hidReqstResultCd").val() != "00737") {
			alert("신청결과가 존재하여 삭제할 수 없습니다.");
			return;
		}

		var iUrl = "<c:url value='/inv/delCommnAjax/'/>";

		if(confirm("삭제하시겠습니까?")){
			var queryString = $('#cmmngReqDtlForm').serialize();
			var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("삭제되었습니다.");
					fnCmmngGridDtlList({grdRcNo:$("#hidMcmmngRcNo").val(),grdTrgterSn:$("#hidMcmmngTrgterSn").val(),grdCaseNo:$("#cmmngReqDtlForm").find("#labCaseNo").text()});
				} else {
					alert("삭제중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}
	function fnCmmngSave() {
		var iUrl = "<c:url value='/inv/addCommnAjax/'/>";
		if(!fnIsEmpty($("#hidPrmisnProgrsNo").val())) {
			if(!fnIsEmpty($("#hidReqstResultCd").val()) && $("#hidReqstResultCd").val() != "00737") {
				alert("신청결과가 존재하여 수정할 수 없습니다.");
				return;
			}
			iUrl = "<c:url value='/inv/modCommnAjax/'/>";
		}
		// 필수 체크
		if(!fnFormValueCheck("cmmngReqDtlForm")) return;
		if(!fnCheckDate($("#txtCmmngReqstDe"))) return;
		// 사후허가
		if($("#selPrmisnSeCd").val() == "00743") {
			if(fnIsEmpty($("#txtNnpmsnpcResn").val())) {
				alert("미리 허가받지 못한 사유은(는) 필수입력 항목입니다.");
				$("#txtNnpmsnpcResn").focus();
				return;
			}
			if(fnIsEmpty($("#txtCmmngExcutDt").val())) {
				alert("집행일시은(는) 필수입력 항목입니다.");
				$("#txtCmmngExcutDt").focus();
				return;
			}
			if(!fnCheckDate($("#txtCmmngExcutDt"))) return;
		}

		// 재신청
		if($("#hidOrignlProgrsNo").val()) {
			if(fnIsEmpty($("#txtRerqestResn").val())) {
				alert("재청구 사유은(는) 필수입력 항목입니다.");
				$("#txtRerqestResn").focus();
				return;
			}
		}
		$.each($("#cmmngReqDtlForm").find('input:checkbox')
			.filter(function(idx){
				return !fnIsEmpty($(this).prop('name'))
			}),
			function(idx, el){
				if(this.checked) {
					$(this).val("Y")
				}
		});
		var queryString = $('#cmmngReqDtlForm').serialize();
		var processAfterGet = function(data) {
			if(data.result == "1"){
				alert("저장되었습니다.");
				fnCmmngGridDtlList({grdRcNo:$("#hidMcmmngRcNo").val(),grdTrgterSn:$("#hidMcmmngTrgterSn").val(),grdCaseNo:$("#cmmngReqDtlForm").find("#labCaseNo").text()});
				fnCmmngDtlList({grdPrmisnProgrsNo:data.key});
			}else{
				alert("저장중 오류가 발생하였습니다.");
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}
	function fnCmmngSaveResult() {
		if(!fnIsEmpty($("#hidReqstResultCd").val()) && $("#hidReqstResultCd").val() != "00737") {
			alert("신청결과가 존재하여 수정할 수 없습니다.");
			return;
		}
		var str = $("input:radio[name=rdoReqstResultCd]:checked").val();
		if(fnIsEmpty(str)) {
			alert("신청결과은(는) 필수입력 항목입니다.");
			$("input:radio[name=rdoReqstResultCd]").focus();
			return;
		}
		else if(str == "00738") { // 허가
			if(!fnFormValueCheck("cmmngRstDtlForm")) return;
			if(!fnCheckDate($("#txtPrmisnRecptDe"))) return;
			if(!fnCheckDate($("#txtIsueDe"))) return;
		}
		else if(str == "00739") { // 기각
			if(fnIsEmpty($("input:radio[name=rdoDsmsslSeCd]:checked").val())) {
				alert("기각구분은(는) 필수입력 항목입니다.");
				$("input:radio[name=rdoDsmsslSeCd]").focus();
				return;
			}
			if(fnIsEmpty($("#txtDsmsslDe").val())) {
				alert("기각일자은(는) 필수입력 항목입니다.");
				$("#txtDsmsslDe").focus();
				return;
			}
			if(fnIsEmpty($("#txtDsmsslResn").val())) {
				alert("기각사유은(는) 필수입력 항목입니다.");
				$("#txtDsmsslResn").focus();
				return;
			}
			if(!fnCheckDate($("#txtDsmsslDe"))) return;
		}
		else if(str == "00740") { // 반환
			if(fnIsEmpty($("#txtReturnDe").val())) {
				alert("반환일자은(는) 필수입력 항목입니다.");
				$("#txtReturnDe").focus();
				return;
			}
			if(fnIsEmpty($("#txtReturnResn").val())) {
				alert("반환사유은(는) 필수입력 항목입니다.");
				$("#txtReturnResn").focus();
				return;
			}
			if(!fnCheckDate($("#txtReturnDe"))) return;
		}
		var iUrl = "<c:url value='/inv/modCommnResultAjax/'/>";
		var queryString = $('#cmmngRstDtlForm').serialize();
		var processAfterGet = function(data) {
			if(data.result == "1"){
				alert("저장되었습니다.");
				fnCmmngGridDtlList({grdRcNo:$("#hidMcmmngRcNo").val(),grdTrgterSn:$("#hidMcmmngTrgterSn").val(),grdCaseNo:$("#cmmngReqDtlForm").find("#labCaseNo").text()});
				fnCmmngDtlList({grdPrmisnProgrsNo:data.key});
			}else{
				alert("저장중 오류가 발생하였습니다.");
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}
	/*신규는 손볼것*/
	function fnCmmngNew () {
		fnCmmngReset (2);
		fnSetTrAfterPermission(null);
		fnSetTrRerqest(null);
		$("#hidCmmngRcNo").val($("#hidMcmmngRcNo").val());
		$("#hidCmmngTrgterSn").val($("#hidMcmmngTrgterSn").val());
	}
	function jusoReturnValue (returnValue) {
		$("#"+returnValue.paramTxtId).val(returnValue.addr);
	}

	/*계좌정보*/
	function fnAcnutAdd () {
		if(!fnChkKey("추가",1,'A',"szure")) return;
		var rNo = $("#szureReqDtlForm").find("#hidSzureReqRcNo").val();
		var qNo = $("#szureReqDtlForm").find("#hidSzureReqZrlongReqstNo").val();
		var param = "?hidRcNo=" + rNo + "&hidZrlongReqstNo=" + qNo;
		var acnutPopup = dhtmlmodal.open('acnutPopup', 'iframe', '/inv/acnutPopup/'+param, '계좌정보 작성', 'width=895px,height=350px,center=1,resize=0,scrolling=1');
		acnutPopup.onclose = function() {
			var iframedoc = this.contentDoc;
			var test = iframedoc.getElementById("dtlForm");
			var data = $(test).serializeFormJSON();
			AUIGrid.addRow("#grid_acnut", data, "last");
			return true;
		}
	}
	function fnAcnutDel () {
		if( 0 < AUIGrid.getRowCount("#grid_acnut") ) {
			if( confirm("선택한 계좌정보를 삭제 하시겠습니까?") ) {
				AUIGrid.removeCheckedRows("#grid_acnut");
			}
		} else {
			alert("저장된 계좌정보가 없습니다.");
		}
	}
	function fnGetSzureAcnutLst (rNo) {
		var processAfterGet = function(data) {
			AUIGrid.setGridData("#grid_acnut", data);
		}
		Ajax.getJson("<c:url value='/inv/szureAcnutListAjax/'/>", "hidZrlongReqstNo="+rNo, processAfterGet);
	}
	function fnGetSzureTrgterLst (rNo) {
		var processAfterGet = function(data) {
			var arrSn = [];
			for(var i in data) {
				if(!fnIsEmpty(data[i].trgterSn)) arrSn.push(data[i].trgterSn);
			}
			if(arrSn.length > 0) {
				AUIGrid.setCheckedRowsByValue("#grid_trgter_list", "grdTrgterSn", arrSn);
			}
		}
		Ajax.getJson("<c:url value='/inv/szureTrgterListAjax/'/>", "hidZrlongReqstNo="+rNo, processAfterGet);
	}
	/*영장구분*/
	function fnZrCdSeClick (val) {
		if(!fnIsEmpty(val) && val == "00773") {
			//체포
			$(".zClsS").hide();
			$(".zClsF").prop("colspan",3);
		} else {
			$(".zClsS").show();
			$(".zClsF").prop("colspan",1);
		}
	}
	function fnGridChg (sType, cType) {
		if(!fnIsEmpty(cType) && cType == 1) {
			if(!fnChkKey("추가 또는 삭제",1,'A',"szure")) return;
		}
		if(sType == 1) {
			var item = {};
			item.grdRcNo 			= $("#szureReqDtlForm").find("#hidSzureReqRcNo").val(),
			item.grdZrlongReqstNo 	= $("#szureReqDtlForm").find("#hidSzureReqZrlongReqstNo").val(),
			item.grdZrlongNo 		= "",
			item.grdZrlongNoOrg		= "",
			item.grdRstValidDt 		= "",
			item.grdIsueDt 			= "",
			item.grdDsmsslInsttCd 	= "",
			item.grdDsmsslResn 		= "",

			//집행구분, 집행자, 집행일시,집행장소, 압수물건, 집행불능사유
			item.grdExcutSeCd		= "",
			item.grdRstExcuterId	= "",
			item.grdRstExcuterNm 	= "",
			item.grdRstExcutDt		= "",
			item.grdRstExcutDt2		= "",
			item.grdRstExcutDt3		= "",
			item.grdExcutPlace		= "",
			item.grdRstSzureThing	= "",
			item.grdExcutIncpctyCd	= "",
			item.grdExcutIncpctyEtc	= ""


			// parameter
			// item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
			// rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
			AUIGrid.addRow("#grid_szure_rst", item, "last");
			fn_form_bind ("szureRstDtlForm",item,"GRID");
		} else {
			var rowPos = AUIGrid.getSelectedIndex("#grid_szure_rst");
			AUIGrid.removeRow("#grid_szure_rst", rowPos[0]);
		}
	}
	
	function fnSugestRcord(){
		var sRcNo = $("#rcNo").val()
		if(sRcNo == ""){
			alert("사건목록을 선택해주세요.");
			return false;
		}
		sugestRcordPopup = dhtmlmodal.open('sugestRcord', 'iframe', '/inv/sugestRcordPopup/?rcNo='+ sRcNo, '기록목록', 'width=1000px,height=450px,center=1,resize=0,scrolling=1')
		sugestRcordPopup.onclose = function(){
			return true;
		}
	}
</script>
<!-- 상단 조회 -->
<div class="sh_box" style="margin-bottom: 10px;">
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
	<input type="hidden" id="rcNo" 			name="rcNo">
	
	<form id="searchForm">
		<input type="hidden" id="searchRcNo"   	 name="searchRcNo"/>
		<input type="hidden" id="searchCaseNo"   name="searchCaseNo"/>
		<input type="hidden" id="searchTrgterSn" name="searchTrgterSn"/>
		<input type="hidden" id="searchPageType" name="searchPageType"/>
	</form>
</div>
<!--//검색박스 -->

<!-- main tab -->
<div class="tabnbtn_box mb_10" id="mTab_box">
	<ul class="tabs">
		<li id="mTab1" class="current">체포/구속</li>
		<li id="mTab2">압수수색검증</li>
		<li id="mTab3" style="width: 180px;">통신사실확인허가신청</li>
	</ul>
	
	<!--버튼 -->
	<div class="right_btn">
		<a id="btnRcord" onClick="fnSugestRcord(); return false;" class="btn_st2_2 icon_n fl mr_m1">기록목록</a>
	</div>
	<!--//버튼  -->
</div>
<div class="contents marginbot" id="mTab_list">
	<!---------- 체포/구속 --------->
	<div id="mContent1" class="tabscontent">

		<div class="box_w2 mb_5">
			<!---------- 피의자 조회 ------------>
			<div class="box_w2_2b" style="width:calc(58% - 30px);">
				<div class="title_s_st2 w_50p fl" style="margin-bottom: 7px;">
					<img src="/img/title_icon1.png" alt="" />체포/구속영장신청 현황
				</div>
				<!--테이블 시작 -->
				<div class="com_box">
					<div id="gridzrlong_wrap" class="gridResize tb_01_box" style="width: 100%; height: 230px;"></div>
				</div>
			</div>
			<!---------- //피의자 조회 ------------>
			<!---------- 체포/구속영장신청 현황 ------------>
			<form id="zrlongForm">
				<input type="hidden" name="hidRcNo" id="hidsearchRcNo"/>
				<input type="hidden" name="hidTrgterSn" id="hidsearchTrgterSn"/>
			</form>
			<div class="box_w2_1b" style="width:42%; padding-right: 0px;">
				<!--작성문서목록 -->
				<iframe name="ifrReportzrlong" id="ifrReportzrlong" scrolling="no" frameborder="0" width="100%" height="280px"></iframe>
			</div>
			<!---------- //체포/구속영장신청 현황 ------------>
		</div>
		<!-- 탭영역  -->
		<div id="">
			<div class="tabnbtn_box mb_10" >
				<div id="zTab_box">
					<ul class="tabs">
						<li id="zrlongTab1" class="current">신청내역</li>
						<li id="zrlongTab2">신청결과</li>
					</ul>
				</div>
				<!--버튼 -->
				<div class="right_btn">
					<a class="btn_st2 icon_n fl mr_m1" onclick="fnAdd('zrlong'); return false;" id="btnZrlongAdd">신규</a>
					<a class="btn_st2 icon_n fl mr_m1" onclick="fnDel('zrlong'); return false;">삭제</a>
					<a class="btn_st2 icon_n fl" onclick="fnSave('zrlong'); return false;">저장</a>
				</div>
				<!--//버튼  -->
			</div>

			<div class="contents marginbot" id="zTab_list">
				<!---------- 신청내역  내용 --------->
				<div id="zrlongContent1" class="tabscontent">
					<div class="box_w2 mb_20">
						<div class="box_w2_2b">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" />피의자 정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box mb_10">
								<form id="zrlongTrgterInfoForm">
								<div class="tb_01_box">
									<table class="tb_01">
										<col width="" style="max-width:130px;"/>
										<col width="30%" />
										<col width="" style="max-width:130px;"/>
										<col width="" />
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
												<td>
													<label id="labOccpNm" class="clrLabel"></label>
												</td>
												<th>변호인성명</th>
												<td>
													<input type="text" name="txtCounslNm" class="input_com w_150px dtlRs"/>
												</td>
											</tr>
											<tr class="h_40px">
												<th>피의자주거</th>
												<td colspan="3">
													<label id="labDwlsitAddr" class="clrLabel"></label>
												</td>
											</tr>
											<tr class="h_40px">
												<th>위반사항</th>
												<td colspan="3">
													<label id="labVioltNm" class="clrLabel"></label>
												</td>
											</tr>
											<tr>
												<th>영장작성자</th>
												<td>
													<label id="labWritngNm" class="clrLabel"></label>
												</td>
												<th>영장신청일 <img src="/img/point.png" /></th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 130px;">
														<input type="text" class="w_100p input_com calendar dtlRs" id="txtReqstDe" name="txtReqstDe" check="text" checkName="영장신청일" readonly="readonly">
														<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
													</div>
												</td>
											</tr>
											<tr>
												<th>체포일시</th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl" style="width: 130px">
														<input type="text" class="w_100p input_com calendar dtlRs" id="txtArrstDt"  name="txtArrstDt" readonly="readonly">
														<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
													</div>
													<div class="fl">
														<input type="text" id="txtArrstDt2" name="txtArrstDt2" class="input_com dtlRs" maxlength="2" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
														<input type="text" id="txtArrstDt3" name="txtArrstDt3" class="input_com dtlRs" maxlength="2" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
													</div>
												</td>
											</tr>
											<tr>
												<th>체포장소</th>
												<td class="t_left" colspan="3">
													<div class="flex_r">
														<input type="text" id="txtArrstPlace" name="txtArrstPlace" maxlength="130" class="w_100p input_com dtlRs">
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
								<form id="zrlongReqDtlForm">
								<input type="hidden" id="hiddtlCudType" 	 	name="hidCudType" />
								<input type="hidden" id="hiddtlRcNo" 	 		name="hidRcNo" />
								<input type="hidden" id="hiddtlTrgterSn" 		name="hidTrgterSn" />
								<input type="hidden" id="hiddtlZrlongReqstNo" 	name="hidZrlongReqstNo" />
								<div class="tb_01_box">
									<table class="tb_01_h100">
										<col width="" 		style="min-width: 90px; max-width: 120px;"/>
										<col width="32%;" 	style="min-width: 240px;"/>
										<col width="" 		style="min-width: 120px; max-width: 140px;"/>
										<col width="" 		style="min-width: 150px;"/>
										<tbody>
											<tr class="h_40px">
												<th>영장구분 <img src="/img/point.png" /></th>
												<td class="zClsF">
													<c:forEach var="cd" items="${zrlongSeLst}">
														<div class='input_radio2 t_left'>
															<input class="to-labelauty-icon" type="radio" name="rdoZrlongSeCd" value="${cd.cd}" check="radio" checkName="영장구분" onclick="fnZrCdSeClick('${cd.cd}')"/>
													    	${cd.cdNm}
													    </div>
													</c:forEach>
												</td>
												<th class="zClsS">구속영장구분 </th>
												<td class="zClsS">
													<select name="selArsttCd" size="1" class="w_100p input_com">
														<option value="">==선택하세요==</option>
														<c:forEach var="cd" items="${arsttCdLst}">
															<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
														</c:forEach>
													</select>
												</td>
											</tr>
											<tr class="h_40px">
												<th>유효일자 <img src="/img/point.png" /></th>
												<td style="min-width: 240px;">
													<div class="calendar_box mr_5 fl" style="width: 130px">
														<input type="text" class="w_100p input_com calendar" id="txtReqValidDt"  name="txtValidDt" check="text" checkName="유효일자" readonly="readonly">
													</div>
													<!-- <div class="fl">
														<input type="text" id="txtReqValidDt2" name="txtValidDt2" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;" check="text" checkName="유효시간"/>:
														<input type="text" id="txtReqValidDt3" name="txtValidDt3" class="input_com" maxlength="2" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;" check="text" checkName="유효시간"/>
													</div> -->
												</td>
												<th>체포/구속장소 <img src="/img/point.png" /></th>
												<td>
													<input type="text" name="txtImprPlace" maxlength="30" class="w_100p input_com" check="text" checkName="구속장소" />
												</td>
											</tr>
											<tr class="h_40px">
												<th>체포/구속사유 <img src="/img/point.png" /></th>
												<td colspan="3">
													<input type="text" name="txtImprResn" maxlength="1300" class="input_com mr_5" check="text" checkName="구속사유" style="width: 100%">
													<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkImprResnEnclsrYn" value="Y"/> 별지 -->
												</td>
											</tr>
											<tr class="" style="height: 112px;">
												<th>재신청 취지 및 이유<br/><span id="txtRereqstResnMsg" style="margin-top:5px;"></span></th>
												<td colspan="3" class="h100">
													<textarea name="txtRereqstResn" id="txtRereqstResn" class="mr_5" style="width: 100%"></textarea>
													<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkRereqstResnEnclsrYn" value="Y"/> 별지 -->
												</td>
											</tr>
											<tr class="h_80px">
												<th>필요 고려사항</th>
												<td colspan="3" style="line-height: 25px;">
													<c:forEach var="cd" items="${NeedCnsdrLst}" varStatus="status">
														<input class="to-labelauty-icon ch_st1" type="checkbox" name="rdoNeedCnsdrCdChk" id="rdoNeed${cd.cd}" value="${cd.cd}"/>${cd.cdNm}&nbsp;
													</c:forEach>
													<br/>
													<input type="text" name="txtNeedCnsdrEtc" id="txtNeedCnsdrEtc" maxlength="70" class="input_com mt_10 mr_5 fl" style="width: 100%" readonly="readonly"/>
													<div class="fl ml_5" style="margin-top: 15px;">
													<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkNeedCnsdrEtcEnclsrYn" value="Y"/> 별지 -->
													</div>
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
				<div id="zrlongContent2" class="tabscontent" style="display: none;">
					<form id="zrlongRstDtlForm">
					<input type="hidden" id="hidrstCudType" 	 	name="hidCudType" />
					<input type="hidden" id="hidrstRcNo" 	 		name="hidRcNo" />
					<input type="hidden" id="hidrstTrgterSn" 		name="hidTrgterSn" />
					<input type="hidden" id="hidrstZrlongReqstNo" 	name="hidZrlongReqstNo" />
					<input type="hidden" id="hidrstZrlongSeCd" 		name="hidZrlongSeCd" />
					<input type="hidden" id="hidrstZrlongNoOrg" 	name="hidZrlongNoOrg" />	<!-- 기존 key 값 확인용 -->
					<input type="hidden" id="hidrstDocId" 			name="hidDocId" />  		<!-- 신청에 있는 DOC ID 복사 -->
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
												<th>영장번호 <img src="/img/point.png" /></th>
												<td colspan="3">
													<input type="text" name="txtZrlongNo" maxlength="11" class="input_com" style="width: 180px;" check="text" checkName="영장번호">
												</td>
											</tr>
											<tr class="h_40px">
												<th>유효일자 <img src="/img/point.png" /></th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl" style="width: 130px">
														<input type="text" class="w_100p input_com calendar" id="txtRstValidDt"  name="txtRstValidDt" check="text" checkName="유효일자" readonly="readonly">
													</div>
													<!-- <div class="fl mr_5">
														<input type="text" id="txtRstValidDt2" name="txtRstValidDt2" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;" check="text" checkName="유효시간"/>:
														<input type="text" id="txtRstValidDt3" name="txtRstValidDt3" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;" check="text" checkName="유효시간"/>
													</div> -->
													<div style="margin-top: 7px;"> 까지</div>
												</td>
											</tr>
											<tr class="h_40px">
												<th>발부일시 <img src="/img/point.png" /></th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl" style="width: 130px">
														<input type="text" class="w_100p input_com calendar" id="txtIsueDt"  name="txtIsueDt" check="text" checkName="발부일자" readonly="readonly">
														<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
													</div>
													<div class="fl">
														<input type="text" id="txtIsueDt2" name="txtIsueDt2" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;" check="text" checkName="발부시간"/>:
														<input type="text" id="txtIsueDt3" name="txtIsueDt3" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;" check="text" checkName="발부시간"/>
													</div>
												</td>
											</tr>
											<tr class="h_40px">
												<th>기각기관</th>
												<td colspan="3">
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoDsmsslInsttCd" value="P"/> 검찰
													</div>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoDsmsslInsttCd" value="C"/> 법원
													</div>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoDsmsslInsttCd" value=""/> 해당없음
													</div>
												</td>
											</tr>
											<tr class="h_125px" style="">
												<th rowspan="3">기각사유<br/><span id="txtDsmsslResnMsg" style="margin-top:5px;"></span></th>
												<td rowspan="3" colspan="3" style="height: 205px;"> <!-- class="h180" -->
													<textarea name="txtDsmsslResn" id="txtDsmsslResn"></textarea>
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
										<col width="31%;" style="min-width: 240px;"/>
										<col width="" style="max-width:130px;"/>
										<col width="" style="min-width: 200px;"/>
										<tbody>
											<tr class="h_40px">
												<th>집행구분</th>
												<td colspan="3"><div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoExcutSeCd" value="Y" /> 집행
													</div>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoExcutSeCd" value="N" />집행불능
													</div>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoExcutSeCd" value="R"/>반환
													</div>
												</td>
											</tr>
											<tr>
												<th>집행자</th>
												<td>
													<input type="hidden" name="hidExcuterId" id="hidExcuterId"/>
													<input type="text" name="txtExcuterNm" id="txtExcuterNm" class="input_com" style="width: 180px;" readonly="readonly">
													<input type="button" class="btn_search" onclick="btnUserPop('hidExcuterId')">
												</td>
												<th>집행일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 50%; max-width: 130px;">
														<input type="text" class="w_100p input_com calendar" id="txtExcutDt"  name="txtExcutDt" readonly="readonly">
														<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
													</div>
													<div class="fl">
														<input type="text" id="txtExcutDt2" name="txtExcutDt2" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
														<input type="text" id="txtExcutDt3" name="txtExcutDt3" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
													</div>
												</td>
											</tr>
											<tr>
												<th>집행장소</th>
												<td colspan="3">
													<div class="flex_r">
														<input type="text" id="txtExcutPlace" name="txtExcutPlace" maxlength="130" class="w_100p input_com">
														<input type="button" value="" class="btn_search" onclick="fnZipPop('txtExcutPlace')">
													</div>
												</td>
											</tr>
											<tr>
												<th>인치일시</th>
												<td style="min-width: 240px;">
													<div class="calendar_box mr_5 fl" style="width: 130px">
														<input type="text" class="w_100p input_com calendar" id="txtRstAttractDt"  name="txtRstAttractDt" readonly="readonly">
														<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
													</div>
													<div class="fl">
														<input type="text" id="txtRstAttractDt2" name="txtRstAttractDt2" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
														<input type="text" id="txtRstAttractDt3" name="txtRstAttractDt3" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
													</div>
												</td>
												<th>인치장소</th>
												<td><input type="text" name="txtRstAttractPlace" class="w_100p input_com" maxlength="30"></td>
											</tr>
											<tr>
												<th>구금일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 130px">
														<input type="text" class="w_100p input_com calendar" id="txtRstCnfnmDt"  name="txtRstCnfnmDt" readonly="readonly">
														<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
													</div>
													<div class="fl">
														<input type="text" id="txtRstCnfnmDt2" name="txtRstCnfnmDt2" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
														<input type="text" id="txtRstCnfnmDt3" name="txtRstCnfnmDt3" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
													</div>
												</td>
												<th>구금장소</th>
												<td><input type="text" name="txtRstCnfnmPlace" class="w_100p input_com" maxlength="30"></td>
											</tr>
											<tr>
												<th>석방일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 130px">
														<input type="text" class="w_100p input_com calendar" id="txtRslDt"  name="txtRslDt" readonly="readonly">
														<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
													</div>
													<div class="fl">
														<input type="text" id="txtRslDt2" name="txtRslDt2" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
														<input type="text" id="txtRslDt3" name="txtRslDt3" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
													</div>
												</td>
												<th>인수자</th>
												<td>
													<input type="hidden" name="hidAcptrId" id="hidAcptrId" />
													<input type="text" name="txtAcptrNm" id="txtAcptrNm" class="w_90p input_com" readonly="readonly"/>
													<input type="button" class="btn_search" onclick="btnUserPop('hidAcptrId')" />
												</td>
											</tr>
											<tr>
												<th>석방사유</th>
												<td colspan="3">
													<select name="selRslResnCd" size="1" class="w_30p input_com mr_5">
														<option value="">== 선택하세요 ==</option>
														<c:forEach var="cd" items="${rslResnList}">
															<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
														</c:forEach>
													</select>
													<input type="text" name="txtRslResnEtc" maxlength="70" class="input_com" style="width:calc(70% - 5px);">
												</td>
											</tr>
											<tr>
												<th>집행불능사유</th>
												<td colspan="3">
													<div class="flex_r">
														<select name="selExcutIncpctyCd" size="1" class="w_30p input_com mr_5">
															<option value="">== 선택하세요 ==</option>
															<c:forEach var="cd" items="${excutSeList}">
																<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
															</c:forEach>
														</select>
														<input type="text" name="txtExcutIncpctyEtc" maxlength="70" class="input_com" style="width:calc(70% - 5px);">
													</div>
												</td>
											</tr>
											<tr class="" style="height: 70px;">
												<th rowspan="3">영장반환사유<br/><span id="txtZrlongReturnResnMsg" style="margin-top:5px;"></span></th>
												<td rowspan="3" colspan="3">
													<textarea name="txtZrlongReturnResn" id="txtZrlongReturnResn"></textarea>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
					</form>
				</div>
				<!---------- //신청결과 내용 --------->
			</div>
		</div>
		<!-- //탭영역  -->
	</div>
	<!---------- //체포/구속 --------->
	<!---------- 압수수색검증 --------->
	<div id="mContent2" class="tabscontent" style="display: none;">
		<div class="box_w2 mb_5">
			<!--------------- 피의자 조회--------------->
			<div class="box_w2_1b" style="width:calc(58% - 10px);">
				<div class="title_s_st2 w_50p fl" style="margin-bottom: 7px;">
					<img src="/img/title_icon1.png" alt="" />압수/수색/검증영장신청 현황
				</div>
				<!--테이블 시작 -->
				<form id="szureForm">
					<input type="hidden" name="hidRcNo" id="hidSzureRcNo"/>
					<input type="hidden" name="hidTrgterSn" id="hidSzureTrgterSn"/>
				</form>
				<div class="com_box">
					<div id="gridszure_wrap" class="gridResize tb_01_box" style="width: 100%; height: 250px;"></div>
				</div>
			</div>
			<!--------------- //피의자 조회--------------->
			<!--------------- 압수/수색/검증영장신청 현황-------------->
			<div class="box_w2_2b" style="width: 42%">
				<!--테이블 시작 -->
				<iframe name="ifrReportszure" id="ifrReportszure" scrolling="no" frameborder="0" width="100%" height="300px"></iframe>
			</div>
			<!--------------- //압수/수색/검증영장신청 현황-------------->
		</div>
		<!-- //가로2칸 -->
		<!---텝영역---->
		<div id="">
			<div class="tabnbtn_box mb_10">
				<div id="sTab_box">
					<ul class="tabs">
						<li id="szureTab1" class="current">신청내역</li>
						<li id="szureTab2">신청결과</li>
					</ul>
				</div>
				<!--버튼 -->
				<div class="right_btn">
					<a class="btn_st2 icon_n fl mr_m1" onclick="fnAdd('szure'); return false;" id="btnSzureAdd">신규</a>
					<a class="btn_st2 icon_n fl mr_m1" onclick="fnDel('szure'); return false;">삭제</a>
					<a class="btn_st2 icon_n fl" onclick="fnSave('szure'); return false;">저장</a>
				</div>
				<!--//버튼 -->
			</div>
			<div class="contents marginbot" id="sTab_list">
				<!---텝1--->
				<div id="sContent1" class="tabscontent">
					<div class="box_w2 mb_20">
						<!--------------피의자 정보----------------->
						<div class="box_w2_1b">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" alt="" />피의자 정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box">
								<form id="szureTrgterInfoForm">
								<div class="tb_01_box">
									<table class="tb_01">
										<col width="" style="max-width:130px;"/>
										<col width="30%" />
										<col width="" style="max-width:130px;"/>
										<col width="" />
										<tbody>
											<tr class="h_40px">
												<th>위반사항</th>
												<td colspan="3" style="line-height: 25px;">
													<label id="labVioltNm" class="clrLabel"></label>
												</td>
											</tr>
											<tr class="h_40px">
												<th>영장작성자</th>
												<td>
													<label id="labWritngNm" class="clrLabel"></label>
												</td>
												<th>영장신청일 <img src="/img/point.png" /></th>
												<td>
													<div class="calendar_box mr_5 fl w_150px">
														<input type="text" class="w_100p input_com calendar dtlRs" id="txtSzureReqstDe"  name="txtReqstDe" check="text" checkName="영장신청일" readonly="readonly">
														<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								</form>
							</div>
							<div class="com_box" style="margin-top: 13px;">
								<div id="grid_trgter_list" class="gridResize tb_01_box" style="width: 100%; height: 195px;"></div>
							</div>
						</div>
						<!-------------- /피의자 정보----------------->
						<!-------------- 영장 정보----------------->
						<div class="box_w2_2b">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" alt="" />영장 정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box ">
								<form id="szureReqDtlForm">
								<input type="hidden" id="hidSzureReqCudType" 	 	name="hidCudType" />
								<input type="hidden" id="hidSzureReqRcNo" 	 		name="hidRcNo" />
								<input type="hidden" id="hidSzureReqTrgterSn" 		name="hidTrgterSn" />
								<input type="hidden" id="hidSzureReqZrlongReqstNo" 	name="hidZrlongReqstNo" />
								<div class="tb_01_box">
									<table class="tb_01">
										<col width="150px" />
										<col width="" />
										<tbody>
											<tr class="h_40px">
												<th>영장구분 <img src="/img/point.png" /></th>
												<td>
													<c:forEach var="cd" items="${szureZrlongLst}">
														<div class='input_radio2 t_left'>
															<input class="to-labelauty-icon" type="radio" name="rdoSzureZrlongCd" onclick="fnSzrlSeClk('${cd.cd}')" check="radio" checkName="영장구분" value="${cd.cd}"/>
													    	${cd.cdNm}
													    </div>
													</c:forEach>
												</td>
											</tr>
											<tr class="h_40px">
												<th>유효일시 <img src="/img/point.png" /></th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 130px">
														<input type="text" class="w_100p input_com calendar" id="txtSzureReqValidDt"  name="txtValidDt" check="text" checkName="유효일자" readonly="readonly">
														<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
													</div>
													<div class="fl">
														<input type="text" id="txtSzureReqValidDt2" name="txtValidDt2" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;" check="text" checkName="유효시간"/>:
														<input type="text" id="txtSzureReqValidDt3" name="txtValidDt3" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;" check="text" checkName="유효시간"/>
													</div>
												</td>
											</tr>
											<!-- 압수수색검증영장 신청이 긴급일 경우 표시  -->
											<tr class="h_40px szReqD1">
												<th>집행자</th>
												<td>
													<input type="hidden" name="hidExcuterId" id="hidSzureExcuterId"/>
													<input type="text" name="txtExcuterNm" id="txtSzureExcuterNm" class="input_com" style="width: 180px;" readonly="readonly">
													<input type="button" class="btn_search" onclick="btnUserPop('hidSzureExcuterId')">
												</td>
											</tr>
											<tr class="h_40px szReqD1">
												<th>집행일시</th>
												<td>
													<div class="calendar_box mr_5 fl" style="width: 130px">
														<input type="text" class="w_100p input_com calendar" id="txtSzureReqExcutDt"  name="txtExcutDt" readonly="readonly">
														<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
													</div>
													<div class="fl">
														<input type="text" id="txtSzureReqExcutDt2" name="txtExcutDt2" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
														<input type="text" id="txtSzureReqExcutDt3" name="txtExcutDt3" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
													</div>
												</td>
											</tr>
											<!-- 압수수색검증영장 신청이 금융계좌추적용일 경우 표시 -->
											<tr class="szReqD2" style="height: 130px;">
												<th>계좌정보
													<div class="box_w2_top mt_10">
														<div class="btn_box">
															<input type="button" id="btnAcnutAdd" onclick="fnAcnutAdd()" value="추가 +" class="btn_st1 icon_n fl mr_2" style="width: 50px; padding-left: 0px; padding-right: 0px;">
															<input type="button" id="btnAcnutDel" onclick="fnAcnutDel()" value="삭제 -" class="btn_st1 icon_n fl " style="width: 50px; padding-left: 0px; padding-right: 0px;">
														</div>
													</div>
												</th>
												<td class="td_grid" style="padding-top: 0px; padding-left: 0px; padding-bottom: 0px; padding-right: 0px;">
													<!-- 그리드 -->
													<div id="grid_acnut" class="gridResize" style="width: 100%; height: 130px !important; margin: 0px auto; position: relative;"></div>
												</td>
											</tr>
											<tr style="height: 70px;">
												<th>압수물건</th>
												<td>
													<textarea name="txtSzureThing" maxlength="30" class="input_com mr_5" style="width: 100%; height:100% !important;"></textarea>
													<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkSzureThingEnclsrYn" value="Y"/> 별지 -->
												</td>
											</tr>
											<tr style="height: 70px;">
												<th>수색검증장소/신체/물건</th>
												<td>
													<textarea name="txtSrchngTrget" maxlength="70" class="input_com mr_5" style="width: 100%; height:100% !important;"></textarea>
													<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkSrchngTrgetEnclsrYn" value="Y"/> 별지 -->
												</td>
											</tr>
											<tr style="height: 70px;">
												<th>압수수색사유</th>
												<td>
													<textarea name="txtSrchngResn" maxlength="1300" class="input_com mr_5" style="width: 100%; height:100% !important;"></textarea>
													<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkSrchngResnEnclsrYn" value="Y"/> 별지 -->
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								</form>
							</div>
						</div>
						<!-------------- //영장 정보----------------->
					</div>
				</div>
				<!---텝2 -->
				<div id="sContent2" class="tabscontent" style="display: none;">
					<form id="szureRstDtlForm">
					<input type="hidden" id="hidSzureRstCudType" 	 	name="hidCudType" />
					<input type="hidden" id="hidSzureRstRcNo" 	 		name="hidRcNo" />
					<input type="hidden" id="hidSzureRstTrgterSn" 		name="hidTrgterSn" />
					<input type="hidden" id="hidSzureRstZrlongReqstNo" 	name="hidZrlongReqstNo" />
					<input type="hidden" id="hidSzureRstZrlongNo" 		name="hidZrlongNo" />
					<input type="hidden" id="hidSzureRstZrlongNoOrg" 	name="hidZrlongNoOrg" />	<!-- 기존 key 값 확인용 -->
					<input type="hidden" id="hidSzureRstDocId" 			name="hidDocId" />  		<!-- 신청에 있는 DOC ID 복사 -->
					<div class="box_w2 mb_20">
						<!-------------- 신청결과정보 -------------->
						<div class="box_w2_1b" style="width:calc(60% + 40px);">
							<div class="title_s_st2 fl" style="width: 150px;">
								<img src="/img/title_icon1.png" />신청결과정보
							</div>
							<a href="javascript:fnGridChg(2, 1)" class="btn_st2 icon_n fr">행삭제</a>
							<a href="javascript:fnGridChg(1, 1)" class="btn_st2 icon_n fr mr_m1">행추가</a>
							<div class="com_box">
								<div id="grid_szure_rst" class="gridResize tb_01_box" style="width: 100%; height: 405px;"></div>
							</div>
						</div>
						<!-------------- //신청결과정보 -------------->
						<!-------------- 집행정보 -------------->
						<div class="box_w2_2b" style="width:calc(40% - 40px);">
							<div class="title_s_st2 w_50p fl">
								<img src="/img/title_icon1.png" alt="" />집행정보
							</div>
							<!--테이블 시작 -->
							<div class="com_box ">
								<div class="tb_01_box">
									<table class="tb_01_h100">
										<col width="150px" />
										<col width="" />
										<tbody>
											<tr class="h_40px">
												<th>집행구분</th>
												<td colspan="3"><div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoExcutSeCd" value="Y"/> 집행
													</div>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoExcutSeCd" value="N"/>집행불능
													</div>
													<div class='input_radio2 t_left'>
														<input class="to-labelauty-icon" type="radio" name="rdoExcutSeCd" value="R"/>반환
													</div>
												</td>
											</tr>
											<tr class="h_40px">
												<th>집행자</th>
												<td colspan="3">
													<input type="hidden" 	name="hidRstExcuterId" id="hidSzureRstExcuterId"/>
													<input type="text" 		name="txtRstExcuterNm" id="txtSzureRstExcuterNm" class="input_com" style="width: 180px;" readonly="readonly">
													<input type="button" 	class="btn_search" onclick="btnUserPop('hidSzureRstExcuterId')">
												</td>
											</tr>
											<tr class="h_40px">
												<th>집행일시</th>
												<td colspan="3">
													<div class="calendar_box mr_5 fl" style="width: 130px">
														<input type="text" class="w_100p input_com calendar" id="txtSzureRstExcutDt"  name="txtRstExcutDt" readonly="readonly">
														<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
													</div>
													<div class="fl mr_5">
														<input type="text" id="txtSzureRstExcutDt2" name="txtRstExcutDt2" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
														<input type="text" id="txtSzureRstExcutDt3" name="txtRstExcutDt3" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
													</div>
												</td>
											</tr>
											<tr class="h_80px">
												<th>집행장소/신체/물건<br/><span id="txtExcutPlaceMsg" style="margin-top:5px;"></span></th>
												<td colspan="3" class="h100">
													<textarea name="txtExcutPlace" id="txtExcutPlace2" style="width: 100%" class="mr_5"></textarea>
													<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkExcutPlaceEnclsrYn" value="Y"/> 별지 -->
												</td>
											</tr>
											<tr class="h_80px">
												<th>압수물건<br/><span id="txtRstSzureThingMsg" style="margin-top:5px;"></span></th>
												<td colspan="3" class="h100">
													<textarea name="txtRstSzureThing" id="txtRstSzureThing" style="width: 100%" class="mr_5"></textarea>
													<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkRstSzureThingEnclsrYn" value="Y"/> 별지 -->
												</td>
											</tr>
											<tr class="h_40px">
												<th>집행불능사유</th>
												<td colspan="3">
													<div class="flex_r">
														<select name="txtExcutIncpctyCd" size="1" class="w_200px input_com mr_5" style="width:30%">
															<option value="">== 선택하세요 ==</option>
															<c:forEach var="cd" items="${excutSeList}">
																<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
															</c:forEach>
														</select>
														<input type="text" name="txtExcutIncpctyEtc" maxlength="700" class="input_com" style="width:calc(70%- 5px);">
													</div>
												</td>
											</tr>
											<tr class="" style="height: 80px;">
												<th rowspan="3">영장반환사유<br/><span id="txtSzureReturnResnMsg" style="margin-top:5px;"></span></th>
												<td rowspan="3" colspan="3">
													<textarea name="txtZrlongReturnResn" id="txtSzureReturnResn"></textarea>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<!-------------- //집행정보 -------------->
					</div>
					</form>
				</div>
			</div>
		</div>
		<!---//텝영역---->
	</div>
	<!---------- //압수수색검증 --------->
	<!---------- 통신사실허가신청 --------->
	<div id="mContent3" class="tabscontent" style="display: none;">
		<div class="box_w2 mb_5">
			<div class="box_w2_1b">
				<div class="title_s_st2 w_50p fl" style="margin-bottom: 8px;">
					<img src="/img/title_icon1.png" alt="" />통신사실 허가 현황
				</div>
				<div class="com_box">
					<form id="cmmngForm">
						<input type="hidden" id="hidMcmmngRcNo" 	name="hidRcNo"/>
						<input type="hidden" id="hidMcmmngTrgterSn" name="hidTrgterSn"/>
					</form>
					<div id="gridcmmng_wrap" class="gridResize tb_01_box" style="width:100%; height:180px; margin:0 auto;"></div>
				</div>
			</div>
			<div class="box_w2_2b">
				<!--테이블 시작 -->
				<iframe name="ifrReportcmmng" id="ifrReportcmmng" scrolling="no" frameborder="0" width="100%" height="230px"></iframe>
			</div>
		</div>
		<!--텝메뉴 -->
		<div class="tabnbtn_box mb_10">
			<div id="cTab_box">
				<ul class="tabs">
					<li id="cmmngTab1" class="current">신청내역</li>
					<li id="cmmngTab2">신청결과</li>
				</ul>
			</div>
			<!--버튼 -->
			<div id="divBtnCmmngDetail" class="right_btn">
				<a href="javascript:void(0);" id="btnCmmngNew" onclick="fnCmmngNew();" class="btn_st2 icon_n fl mr_m1">신규</a>
				<a href="javascript:void(0);" id="btnCmmngRereqst" onclick="fnCmmngRereqst();" class="btn_st2 icon_n fl" style="display:none;">재신청</a>
				<a href="javascript:void(0);" id="btnCmmngDel" onclick="fnCmmngDel();" class="btn_st2 icon_n fl mr_m1" style="display:none;">삭제</a>
				<a href="javascript:void(0);" id="btnCmmngSave" onclick="fnCmmngSave();" class="btn_st2 icon_n fl" style="display:none;">저장</a>
			</div>
			<div id="divBtnCmmngResult" class="right_btn">
				<a href="javascript:void(0);" id="btnCmmngSaveResult" onclick="fnCmmngSaveResult();" class="btn_st2 icon_n fl" style="display:none;">저장</a>
			</div>
		</div>

		<!--테이블 시작 -->
		<div class="contents marginbot" id="cTab_list">
			<!---텝1--->
			<div id="cContent1" class="tabscontent">
				<form id="cmmngReqDtlForm" method="post">
				<div class="com_box mb_30">
					<div class="tb_01_box">
						<table class="tb_01_h100">
						<colgroup>
							<col width="15%">
							<col width="45%">
							<col width="15%">
							<col width="25%">
						</colgroup>
						<tbody>
							<tr>
								<th>진행번호</th>
								<td>
									<label id="labCmmngPrmisnProgrsNo" class="cmmngClrLabel"></label>
									<input type="hidden" id="hidPrmisnProgrsNo" name="hidPrmisnProgrsNo"/>
									<input type="hidden" id="hidReqstResultCd" name="hidReqstResultCd"/>
									<input type="hidden" id="hidOrignlProgrsNo" name="hidOrignlProgrsNo"/>
									<input type="hidden" id="hidRereqstYn" name="hidRereqstYn"/>
								</td>
								<th>신청일자 <img src="/img/point.png" /></th>
								<td>
									<div class="calendar_box mr_5 fl w_150px">
										<input type="text" class="w_100p input_com calendar" id="txtCmmngReqstDe"  name="txtReqstDe" check="text" checkName="신청일자" readonly="readonly">
										<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
									</div>
								</td>
							</tr>
							<tr>
								<th>허가구분 <img src="/img/point.png" /></th>
								<td>
									<select name="selPrmisnSeCd" id="selPrmisnSeCd" size="1" class="w_150px input_com" check="text" checkName="허가구분">
										<option value="">== 선택하세요 ==</option>
										<c:forEach var="cd" items="${prmisnSeCdLst}">
											<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
										</c:forEach>
									</select>
								</td>
								<th>관할검찰</th>
								<td>
									<label id="labCmptncExmnNm" class="cmmngClrLabel"></label>
								</td>
							</tr>
							<tr>
								<th>전기통신사업자 <img src="/img/point.png" /></th>
								<td>
									<%-- <select id="selCommnBsnmCd" name="selCommnBsnmCd" size="1" class="w_150px input_com" check="text" checkName="전기통신사업자">
										<option value="">==선택하세요==</option>
										<c:forEach var="cd" items="${commnBsnmCdLst}">
											<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
										</c:forEach>
									</select> --%>
									<input type="text" id="txtCommnBsnm" name="txtCommnBsnm" maxlength="1300" class="input_com mr_5" style="width: 90%" placeholder="예) SKT, KT, LG U+ 등을 입력하세요." check="text" checkName="전기통신사업자"/>
								</td>
								<th>담당자</th>
								<td>
									<label id="labAlotUserNm" class="cmmngClrLabel"></label>
								</td>
							</tr>
							<tr class="h_40px">
								<th>위반사항</th>
								<td>
									<label id="labVioltNm" class="cmmngClrLabel"></label>
								</td>
								<th>사건번호</th>
								<td>
									<label id="labCaseNo" class="cmmngClrLabel"></label>
									<input type="hidden" id="hidCmmngRcNo" name="hidRcNo" class="w_150px input_readonly" readonly/>
								</td>
							</tr>
							<tr class="h_40px">
								<th>대상자</th>
								<td>
									<input type="hidden" id="hidCmmngTrgterSn" name="hidTrgterSn" class="w_150px input_readonly" readonly/>
									<label id="labTrgterNm" class="cmmngClrLabel"></label>
								</td>
								<th>주민등록번호</th>
								<td>
									<label id="labTrgterRrn" class="cmmngClrLabel"></label>
								</td>
							</tr>
							<tr class="h_40px">
								<th>주거</th>
								<td>
									<label id="labAdresAddr" class="cmmngClrLabel"></label>
								</td>
								<th>작업</th>
								<td>
									<label id="labOccpCdNm" class="cmmngClrLabel"></label>
								</td>
							</tr>
							<tr>
								<th>필요한 자료의 범위 <img src="/img/point.png" /></th>
								<td colspan="3">
									<input type="text" id="txtDtaScope" name="txtDtaScope" maxlength="1300" class="input_com mr_5" style="width: 100%" check="text" checkName="필요한 자료의 범위"/>
									<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkDtaScopeEnclsrYn" value="Y"/> 별지 -->
								</td>
							</tr>
							<tr>
								<th>요청 사유 <img src="/img/point.png" /></th>
								<td colspan="3">
									<input type="text" id="txtRequstResn" name="txtRequstResn" maxlength="1300" class="input_com mr_5" style="width: 100%" check="text" checkName="요청사유"/>
									<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkRequstResnEnclsrYn" value="Y"/> 별지 -->
								</td>
							</tr>
							<tr>
								<th>해당 가입자와의 연관성 <img src="/img/point.png" /></th>
								<td colspan="3">
									<input type="text" id="txtSbscrberRelate" name="txtSbscrberRelate" maxlength="1300" class="input_com mr_5" style="width: 100%" check="text" checkName="해당 가입자와의 연관성"/>
									<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkSbscrberRelateEnclsrYn" value="Y"/> 별지 -->
								</td>
							</tr>
							<tr id="trRerqest" class="border_bottom_b" style="display:none;">
								<th>재청구 사유</th>
								<td colspan="3">
									<input type="text" id="txtRerqestResn" name="txtRerqestResn" maxlength="1300" class="input_com mr_5" style="width: 100%"/>
									<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkRerqestResnEnclsrYn" value="Y"/> 별지 -->
								</td>
							</tr>
							<tr id="trAfterPermission" class="border_bottom_b" style="display:none;">
								<th>미리 허가받지 못한 사유</th>
								<td>
									<input type="text" id="txtNnpmsnpcResn" name="txtNnpmsnpcResn" maxlength="1300" class="input_com mr_5" style="width: 100%"/>
									<!-- <input class="to-labelauty-icon ch_st1" type="checkbox" name="chkNnpmsnpcResnEnclsrYn" value="Y"/> 별지 -->
								</td>
								<th>집행일시</th>
								<td>
									<div class="calendar_box mr_5 fl" style="width: 130px">
										<input type="text" class="w_100p input_com calendar" id="txtCmmngExcutDt"  name="txtExcutDt" readonly="readonly">
										<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
									</div>
									<div class="fl">
										<input type="text" id="txtCmmngExcutDt2" name="txtExcutDt2" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;"/>:
										<input type="text" id="txtCmmngExcutDt3" name="txtExcutDt3" maxlength="2" class="input_com" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;"/>
									</div>
								</td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
				</form>
			</div>
			<div id="cContent2" class="tabscontent" style="display: none;">
				<form id="cmmngRstDtlForm" method="post">
				<div class="com_box mb_30">
					<div class="tb_01_box">
						<table class="tb_01_h100">
						<colgroup>
							<col width="15%">
							<col width="45%">
							<col width="15%">
							<col width="25%">
						</colgroup>
						<tbody>
							<tr>
								<th>진행번호</th>
								<td>
									<span id="labCmmngPrmisnProgrsNo2" class="cmmngClrLabel"></span>
									<input type="hidden" id="hidPrmisnProgrsNo2" name="hidPrmisnProgrsNo"/>
								</td>
								<th>신청결과 <img src="/img/point.png" /></th>
								<td>
								<c:forEach var="list" items="${reqstResultCdList}" varStatus="status">
									<div class='input_radio2 t_left'>
										<input type="radio" name="rdoReqstResultCd" value="${list.cd}" class="to-labelauty-icon" check="text" checkName="신청결과"/>${list.cdNm}
									</div>
								</c:forEach>
								</td>
							</tr>
						</tbody>
						</table>
						<table id="tabPrimsn" class="tb_01">
						<colgroup>
							<col width="15%">
							<col width="45%">
							<col width="15%">
							<col width="25%">
						</colgroup>
						<tbody>
							<tr>
								<th>허가서 번호 <img src="/img/point.png" /></th>
								<td>
									<input type="text" id="txtPrmisnNo" name="txtPrmisnNo" class="w_150px input_com" maxlength="11" check="text" checkName="허가서 번호"/>
								</td>
								<th>허가서 수령일자 <img src="/img/point.png" /></th>
								<td>
									<div class="calendar_box mr_5 fl w_150px">
										<input type="text" class="w_100p input_com calendar" id="txtPrmisnRecptDe"  name="txtPrmisnRecptDe" check="text" checkName="허가서 수령일자" readonly="readonly">
										<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
									</div>
								</td>
							</tr>
							<tr>
								<th>발부일자 <img src="/img/point.png" /></th>
								<td>
									<div class="calendar_box mr_5 fl w_150px">
										<input type="text" class="w_100p input_com calendar" id="txtIsueDe"  name="txtIsueDe" check="text" checkName="발부일자" readonly="readonly">
										<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
									</div>
								</td>
								<th>담당자</th>
								<td>
									<span id="labAlotUserNm2" class="cmmngClrLabel"></span>
								</td>
							</tr>
						</tbody>
						</table>
						<table id="tabDsmssl" class="tb_01" style="display:none;">
							<colgroup>
								<col width="15%">
								<col width="45%">
								<col width="15%">
								<col width="25%">
							</colgroup>
							<tr>
								<th>기각구분 <img src="/img/point.png" /></th>
								<td>
									<c:forEach var="list" items="${dsmsslSeCdList}" varStatus="status">
										<div class='input_radio2 t_left'>
											<input type="radio" name="rdoDsmsslSeCd" value="${list.cd}" class="to-labelauty-icon" />${list.cdNm}
										</div>
									</c:forEach>
								</td>
								<th>기각일자 <img src="/img/point.png" /></th>
								<td>
									<div class="calendar_box mr_5 fl w_150px">
										<input type="text" class="w_100p input_com calendar" id="txtDsmsslDe"  name="txtDsmsslDe" readonly="readonly">
										<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
									</div>
								</td>
							</tr>
							<tr>
								<th>기각사유 <img src="/img/point.png" /></th>
								<td colspan="3">
									<input type="text" name="txtDsmsslResn" maxlength="1300" class="w_90p input_com"/>
								</td>
							</tr>
						</table>
						<table id="tabReturn" class="tb_01" style="display:none;">
							<colgroup>
								<col width="15%">
								<col width="85%">
							</colgroup>
							<tr>
								<th>반환일자 <img src="/img/point.png" /></th>
								<td>
									<div class="calendar_box mr_5 fl w_150px">
										<input type="text" class="w_100p input_com calendar" id="txtReturnDe"  name="txtReturnDe" readonly="readonly">
										<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div> -->
									</div>
								</td>
							</tr>
							<tr>
								<th>반환사유 <img src="/img/point.png" /></th>
								<td>
									<input type="text" name="txtReturnResn" maxlength="1300" class="w_90p input_com"/>
								</td>
							</tr>
						</table>
					</div>
				</div>
				</form>
			</div>
		</div>
	</div>
	<!---------- //통신사실허가신청 --------->
</div>
<!-- //메인 탭영역  -->

