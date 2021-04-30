<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<script type="text/javascript" src="/js/jquery-ui.js"></script>
<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>
<style>
/* 그리드 오버 시 행 선택자 만들기
.aui-grid-body-panel table tr:hover {
	background:#D9E5FF;
	color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel .aui-grid-table tr td:hover {
	background:#D9E5FF;
	color:#000;
}
*/

/* 검색박스 스타일 정의 */
.rc_search {
	height: 30px!important;
}

/* 바디 메뉴 스타일 정의 */
.bodyMenu {
	position:absolute;
	display:none;
	z-index:100;
}

/* jQuery UI Menu 스타일 재정의 */
.ui-menu {
	width: 200px;
	font-size:12px;
	box-shadow: 5px 5px 5px rgba(0, 0, 0, 0.3);
	-webkit-box-shadow: 3px 3px 3px rgba(0, 0, 0, 0.3);
	-moz-box-shadow: 3px 3px 3px rgba(0, 0, 0, 0.3);
}

.ui-widget-header {
	padding: 0.2em;
}

/* 커스텀 열 스타일 */
.my-column-style {
	background : #ff0000;
	 	 color : #105500;
   font-weight : bold;
}

/* 커스텀 열 스타일 */
.my-column-style1 {
	background : #1ab32e;
	 	 color : #105500;
   font-weight : bold;
}

/* 커스텀 열 스타일 */
.my-column-style2 {
	background : #dbcd34;
	 	 color : #105500;
   font-weight : bold;
}

/* 커스텀 열 스타일 */
.my-column-style3 {
	background : #ff0000;
	 	 color : #105500;
   font-weight : bold;
}

.my-column-style3 {
	style="overflow:hidden"
}

.pagebox {
    margin-bottom: 0px;
}

.cssBodyMenu {
	font-size : 13px;
	padding: 5px 0px;
}
.cssCtTxt {
	padding: 5px 10px 5px 10px;
}

.cssCtTxt:hover {
	background: #eee;
	font-weight: bold;
}

</style>
<script type="text/javascript" src="/js/rc.common.js"></script>
<script type="text/javascript">

//바디 컨텍스트 메뉴가 현재 보이고 있는지 여부
var nowBodyMenuVisible = false;

var nowBodyMenuVisible1 = false;
var nowBodyMenuVisible2 = false;

//바디 컨텍스트 메뉴 생성된 곳의 rowIndex 보관 변수
var currentRowIndex;

//grid 변수
var gridTargetList;
var   caseGridId = "#grid_case_list";
var targetGridId = "#grid_target_list";

	$(function() {

		$(document).ready(function(){

			fnDatePickerImg("textReceiptDeStart", fnGetToday(12, 0), true);	//input Calendar setting
			fnDatePickerImg(  "textReceiptDeEnd", null, true );	//input Calendar setting
			initGrid("A");			//그리드 초기화
			fnChoiceGrid("A");	//화면 초기에 정식사건으로 그리드 지정
		});//end jQuery ready

		// document 이벤트
		$(document).on("click", function(event) {

			if( $(event.target).attr("aria-haspopup") ){ // 서브 메뉴 아이템 클릭 한 경우
				return;
			}
			hideContextMenu();	//컨텍스트 메뉴 감추기
		});

		$('#btnSearch').click(function() {

			if( !fnSearchValidate() ){
				return;
			}
			fnMoveGridPage( "/rc/getCaseListAjax/", "frmList", caseGridId, 1 );
		});

	});//end jQuery

	//조회
	function fnSearch(){
		fnMoveGridPage( "/rc/getCaseListAjax/", "frmList", caseGridId, 1 );
	}

	var columnRn 	 = { dataField : "RN"	  , headerText : "순번" 		, width : 30 }	//순번
	var columnCaseNo = { dataField : "CASE_NO", headerText : "사건번호"	, width : 80 /*,  renderer : {type : "TemplateRenderer"} */
				       , labelFunction : function( rowIndex, columnIndex, value, headerText, item ){
											return fnChangeNo(value);
					   					 }
					   }
	var columnItivNo = { dataField : "ITIV_NO", headerText : "내사번호"	, width : 80 /* ,  renderer : {type : "TemplateRenderer"} */
				       , labelFunction : function( rowIndex, columnIndex, value, headerText, item ){
											return fnChangeNo(value);
					   					 }
					   }
	var columnTmprNo = { dataField : "TMPR_NO", headerText : "임시번호"	, width : 80 /* ,  renderer : {type : "TemplateRenderer"} */
  		    	       , labelFunction : function( rowIndex, columnIndex, value, headerText, item ){
											return fnChangeNo(value);
					 					 }
					   }
	var columnRcNo 	 = { dataField : "RC_NO"  , headerText : "접수번호"	, width : 80 /* ,  renderer : {type : "TemplateRenderer"} */
				       , labelFunction : function( rowIndex, columnIndex, value, headerText, item ){
											return fnChangeNo(value);
						 				}
					   }

	var columnCaseEndSeChangeCd = { dataField : "CASE_END_SE_CHANGE_CD", headerText : "사건종결코드", width : 30, visible : false}
	var columnCaseEndSeChangeNm = { dataField : "CASE_END_SE_CHANGE_NM", headerText : "사건종결구분", width : 80, visible : true }

	//컬럼정보 설정
	var columnLayoutBasic =
		   [{ dataField : "DELAY_PD"	 	 , headerText : "경과" , width : 35, visible : false
	    	  , style : "my-column-style"
			  , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									//지연 기간 임시 설정 original 90/(90+전자문서 작성)/60~90
									if( 20 >= value ) {	//Delay
										return "my-column-style1";
									} else if( 30 >= value ) {
										return "my-column-style2";
									} else if( 90 >= value ){
										return "my-column-style3";
									}
									return null;
								}
			 , labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {

				 	if( value < 0 ){
						return 0;
					} else {
						return value;
					}
			    }
		  }
		, { dataField : "INV_PROVIS_NM"	 , headerText : "수사단서 "	, width : 70 	 }
		, { dataField : "RC_SE_NM"	 	 , headerText : "사건구분"	, width : 60 	 }
		, { dataField : "RC_SE_CD"	 	 , headerText : "구분코드"	, visible : false}
		, { dataField : "SUSPCT"		 , headerText : "피의자 등"	, width : 120
		  , labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {

								var suspctArr = !fnIsEmpty(value)?value.split("/"):"";

			  				  	if( 1 < suspctArr.length ) {
			  				  	    return suspctArr[0] + ' 외 '+ (suspctArr.length-1)+'명';
			  				  	} else if( 1 == suspctArr.length && "" != suspctArr[0] ){
			  				  		return value;
			  				  	} else {
			  				  		return "없음";
			  				  	}
							}
		  }
		, { dataField : "VIOLT_NM"		 , headerText : "위반죄명"    	, width : 300 }
		, { dataField : "SUFRER"		 , headerText : "고발인 등"  , width : 80
		  , labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {

								var sufrerArr = !fnIsEmpty(value)?value.split("/"):"";

			  				  	if( 1 < sufrerArr.length ) {
			  				  	    return sufrerArr[0] + ' 외 '+ (sufrerArr.length-1)+'명';
			  				  	} else if( 1 == sufrerArr.length && "" != sufrerArr[0]  ){
			  				  		return value;
			  				  	} else {
			  				  		return "없음";
			  				  	}
							}
		  }
		, { dataField : "SANCTN_ID"		 , headerText : "SANCTN_ID"	, width : 100, visible : false }
		, { dataField : "PROGRS_STTUS_CD", headerText : "진행상태CD"  	, width : 100, visible : false }
		, { dataField : "PROGRS_STTUS_NM", headerText : "진행상태"		, width : 100, height : 150
		   , renderer : {type : "TemplateRenderer"}
		   , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								var template = "";
								if( item.PROGRS_STTUS_CD == "02104" ){
									template = "<a href=\"javascript:void(0);\" onClick=\"fnSanctnHistory('"+item.SANCTN_ID+"');\" class=\"btn_td1 icon_n fl \" style=\"text-align:center;\">"+value+"</a>";
								} else if( item.PROGRS_STTUS_CD == "02124" ){
									template = "접수완료";
								} else if( item.PROGRS_STTUS_CD == "02125" ){
									template = "접수완료";
								} else {
									template += value;
								}
								return template;
							}
		     , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
		    	 				/*
								//지연 기간 임시 설정 original 90/(90+전자문서 작성)/60~90
								if( "02124" == item.PROGRS_STTUS_CD ) {	//Delay
									return "my-column-style";
								} else if( "02125" == item.PROGRS_STTUS_CD ) {
									return "my-column-style1";
								} else {
									return null;
								}
		    	 				*/
							}
		  }
		, { dataField : "RC_DT"			  , headerText : "접수일자"	 	, width : 80	}
		, { dataField : "DOC_ID"		  , headerText : "문서ID"			, width : 110, visible : false	}
		];

	//컬럼정보 설정
	var columnLayoutBasic2 =
		   [{ dataField : "DELAY_PD"	 	 , headerText : "경과" , width : 35, visible : false
	    	  , style : "my-column-style"
			  , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {

				  					//지연 기간 임시 설정 original 90/(90+전자문서 작성)/60~90
									if( 20 >= value ){	//Delay
										return "my-column-style1";
									} else if( 30 >= value ){
										return "my-column-style2";
									} else if( 90 >= value ){
										return "my-column-style3";
									}
									return null;
								}
			 , labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
								 	if( value < 0 ){
										return 0;
									} else {
										return value;
									}
							   }
		  }
		, { dataField : "INV_PROVIS_NM"	 , headerText : "수사단서 "	, width : 70 	 }
		, { dataField : "RC_SE_NM"	 	 , headerText : "사건구분"	, width : 60 	 }
		, { dataField : "RC_SE_CD"	 	 , headerText : "구분코드"	, visible : false}
		, { dataField : "SUSPCT"		 , headerText : "피내사자 등"	, width : 80
		  , labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {

								var suspctArr = !fnIsEmpty(value)?value.split("/"):"";

			  				  	if( 1 < suspctArr.length ) {
			  				  	    return suspctArr[0] + ' 외 '+ (suspctArr.length-1)+'명';
			  				  	} else if( 1 == suspctArr.length && "" != suspctArr[0] ){
			  				  		return value;
			  				  	} else {
			  				  		return "없음";
			  				  	}
							}
		  }
		, { dataField : "VIOLT_NM"		 , headerText : "위반죄명"    	, width : 300 }
		, { dataField : "SUFRER"		 , headerText : "고발인 등"  , width : 80
		  , labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {

								var sufrerArr = !fnIsEmpty(value)?value.split("/"):"";

			  				  	if( 1 < sufrerArr.length ) {
			  				  	    return sufrerArr[0] + ' 외 '+ (sufrerArr.length-1)+'명';
			  				  	} else if( 1 == sufrerArr.length && "" != sufrerArr[0]  ){
			  				  		return value;
			  				  	} else {
			  				  		return "없음";
			  				  	}
							}
		  }
		, { dataField : "SANCTN_ID"		 , headerText : "SANCTN_ID"	, width : 100, visible : false }
		, { dataField : "PROGRS_STTUS_CD", headerText : "진행상태CD"  	, width : 100, visible : false }
		, { dataField : "PROGRS_STTUS_NM", headerText : "진행상태"		, width : 100, height : 150
		   , renderer : {type : "TemplateRenderer"}
		   , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								var template = "";
								if( item.PROGRS_STTUS_CD == "02104" ){
									template = "<a href=\"javascript:void(0);\" onClick=\"fnSanctnHistory('"+item.SANCTN_ID+"');\" class=\"btn_td1 icon_n fl \" style=\"text-align:center;\">"+value+"</a>";
								} else {
									template += value;
								}
								return template;
							}
		   , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {

								//지연 기간 임시 설정 original 90/(90+전자문서 작성)/60~90
								if( "02124" == value ) {	//Delay
									return "my-column-style1";
								} else if( "02125" == value ) {
									return "my-column-style2";
								} else {
									return null;
								}
							}
		  }
		, { dataField : "RC_DT"			  , headerText : "접수일자"		, width : 80 }
		, { dataField : "DOC_ID"		  , headerText : "문서ID"			, width : 110, visible : false	}
		];


	//사건에 따른 동적 컬럼생성
	function fnBuildColumnLayout( seCd ){

		columnLayout =[];
		columnLayout.push(columnRn);

		if( "A" == seCd ){			//전체사건
			columnLayout.push(columnCaseNo);
			columnLayout.push(columnItivNo);
			columnLayout.push(columnTmprNo);
			columnLayout.push(columnRcNo);
		} else if( "F" == seCd ||"S" == seCd ){	//정식/중지 사건
			columnLayout.push(columnCaseNo);
			columnLayout.push(columnRcNo);
		} else if( "I" == seCd ){	//내사사건
			columnLayout.push(columnItivNo);
			columnLayout.push(columnRcNo);
		} else if( "T" == seCd ){	//임시사건
			columnLayout.push(columnTmprNo);
			columnLayout.push(columnRcNo);
		}


		if("I" == seCd){
			for(i=0; i<columnLayoutBasic2.length; i++){
				columnLayout.push(columnLayoutBasic2[i]);
			}
		} else {
			for(i=0; i<columnLayoutBasic.length; i++){
				columnLayout.push(columnLayoutBasic[i]);
			}
		}

		//if( "F" != seCd && "S" != seCd ){
		if( true ){
			columnLayout.push(columnCaseEndSeChangeCd);
			columnLayout.push(columnCaseEndSeChangeNm);
		}
		return columnLayout;
	}


	//컬럼정보 설정
	var columnLayoutT = [
		  { dataField : "grdRn"			 , headerText : "순번"	 , width : 20  }
		, { dataField : "grdTrgterGroup" , headerText : "대상자그룹", width	 : 70
		   , renderer : {type : "TemplateRenderer"}
	  , labelFunction : function( rowIndex, columnIndex, value, headerText, item ){

							if( "suspct-Group" == value ){
								if( "F" == item.grdRcSeCd ){
			  				  	    return "피의자 등";
								} else if( "I" == item.grdRcSeCd ){
			  				  	    return "피내사자 등";
								} else if( "T" == item.grdRcSeCd ){
			  				  	    return "혐의자 등";
								}
			  				} else if( "accs-Group" == value ){
			  				  		return "고발인 등";
			  				}
						 }
		  }
		, { dataField : "grdTrgterSeNm"	 , headerText : "구분"	, width : 60  }
		, { dataField : "grdTrgterNm"	 , headerText : "대상자명"	, width : 80  }
		, { dataField : "grdTrgterTyNm"	 , headerText : "유형"	, width : 60  }
		, { dataField : "grdTrgterClNm"	 , headerText : "분류"	, width : 60  }
		, { dataField : "grdTrgterAge"	 , headerText : "나이"	, width : 30  }
		, { dataField : "grdSexdstnNm"	 , headerText : "성별"	, width : 30  }
		//, { dataField : "grdTrgterRrn"	 , headerText : "주민번호"	, width : 80  }
		, { dataField : "grdTrgterRrn"	 , 
			headerText : "주민번호(법인번호)"	, 
			width : 80, 
			labelFunction : function( rowIndex, columnIndex, value, headerText, item ){
								var template = "";
								
								if(value != null && value != ""){
									return value;
								}else if(item.grdTrgterCprn != null && item.grdTrgterCprn != ""){
									return item.grdTrgterCprn;
								}else if(
									(value == null || value == "") &&
									(item.grdTrgterCprn == null || item.grdTrgterCprn == "")
								){
									return "";	
								}
							}
		}
		, { dataField : "grdHpNo"		 , 
			headerText : "휴대전화(직장전화)"	, 
			width : 80,
			labelFunction : function( rowIndex, columnIndex, value, headerText, item ){
								var template = "";
								
								if(value != null && value != ""){
									template += value;
								}else if(item.grdWrcTel != null && item.grdWrcTel != "") {
									template += item.grdWrcTel;
								}else if(
									(value == null || value == "") &&
									(item.grdWrcTel == null || item.grdWrcTel == "")
								){
									return "";	
								}
								
								return template;
							}
		}
		, { dataField : "grdAdresAddr"	 , headerText : "주소지"	, width : 300 }
	];

	//그리드 환경값 설정
	var gridPros = {
		     useGroupingPanel : false
		   , showRowNumColumn : false
		    , displayTreeOpen : true
		       , enableFilter : true
		     , useContextMenu : true	//컨텍스트 메뉴 사용
	   , enableRightDownFocus : true	//컨텍스트 메뉴를 보기 위해 오른쪽 클릭을 한 경우 클릭 지점이 왼쪽 클릭과 같이 셀 선택을 할지 여부 기본값 : false
		       , headerHeight : 30
			      , rowHeight : 30
		 , fillColumnSizeMode : true
		//   , enableMouseWheel : false
	   //, enableHScrollByWheel : false
	   //        , scrollHeight : -8
	};


	var gridProsT = {
		     useGroupingPanel : false
		   , showRowNumColumn : false
		    , displayTreeOpen : true
		       , enableFilter : true
		     , useContextMenu : true	//컨텍스트 메뉴 사용
	   , enableRightDownFocus : true	//컨텍스트 메뉴를 보기 위해 오른쪽 클릭을 한 경우 클릭 지점이 왼쪽 클릭과 같이 셀 선택을 할지 여부 기본값 : false
		       , headerHeight : 30
			      , rowHeight : 30
		 , fillColumnSizeMode : true
		 , showAutoNoDataMessage : false
	};

	//그리드 초기화
	function initGrid(seCd) {

		AUIGrid.create(   caseGridId,  [], gridPros);
		gridTargetList = AUIGrid.create( targetGridId, columnLayoutT, gridProsT);

		// 칼럼 레이아웃 변경
		AUIGrid.changeColumnLayout(caseGridId, fnBuildColumnLayout(seCd));

		AUIGrid.bind(caseGridId, "cellDoubleClick", function(event) {
			var  items = event.item;
			var   rcNo = "";
			var caseNo = "";

			rcNo = items.RC_NO;

			if( null != items.CASE_NO){
				caseNo = items.CASE_NO;
			}

			fnCaseDetailPopup( rcNo, caseNo );	//사건상세조회 팝업 cubox.js
		});

		AUIGrid.bind(caseGridId, "cellClick", function(event) {
			var  items = event.item;
			var   rcNo = "";
			var caseNo = "";
			var rcSeCd = "";

			  rcNo = items.RC_NO;
			caseNo = items.CASE_NO;
			rcSeCd = items.RC_SE_CD;
			 docId = items.DOC_ID;

			//기소중지 및 참고인중지 추가 코드
			if( "02124" == items.PROGRS_STTUS_CD ||"02125" == items.PROGRS_STTUS_CD ){
				$("#hidRcSeCd").val("S");
			} else {
				$("#hidRcSeCd").val(rcSeCd);
			}

			$("#searchRcNo").val(rcNo);

			AUIGrid.clearGridData( gridTargetList );
			fnTargetSearch();//대상자 조회
		});

		AUIGrid.bind(   caseGridId, "contextMenu", auiGridContextEventHandler );
		AUIGrid.bind( targetGridId, "contextMenu", auiGridContextEventHandler );
				
		AUIGrid.bind(caseGridId, "sorting", gridSort);

	}// End grid Init


	//사건그리드 컨텍스트 메뉴 이벤트 핸들러
	function auiGridContextEventHandler(event) {

		var sectionVal = $("#hidRcSeCd").val();

			hideContextMenu();

			if( event.target == "body" ) { // 바디 컨텍스트
				currentRowIndex = event.rowIndex;
				// 사용자가 만든 컨텍스트 메뉴 보이게 하기
				nowBodyMenuVisible1 = true;
				//////////////////////////////
				nowBodyMenuVisible = true;
				// 바디 컨텍스트에서 사용할 메뉴 위젯 구성
				$("#bodyMenu>li").show();

				$("#bodyMenu").menu({
					select: bodyMenuSelectHandler
				});

				$("#bodyMenu").css({
					left : event.pageX
				   , top : event.pageY - (event.pageY-270)//event.pageY - 190
				}).show();

				if( event.item.grdTrgterSn == null ){
					if("S" == sectionVal){
						$("#bodyMenu>li").not(".S,.SC").hide();
						$("#bodyMenu").css({
							top : event.pageY -50 //event.pageY - 190
						}).show();
					} else{
						$("#bodyMenu>li").not("."+event.item.RC_SE_CD+",."+event.item.RC_SE_CD+"C").hide();
					}
				} else {

					if( "F" == sectionVal){
						$("#bodyMenu").css({
							top : event.pageY - (event.pageY-550) //event.pageY - 190
						}).show();
					} else {
						$("#bodyMenu").css({
							top : event.pageY - 50 //event.pageY - 190
						}).show();
					}

					$("#bodyMenu>li").not("."+$("#hidRcSeCd").val()+",."+$("#hidRcSeCd").val()+"T").hide();
				}

				return false; // 기본으로 제공되는 컨텍스트 사용 안함.

			}
	};

	//그리드 변경 function
	//사건 구분 코드 seVal - A:전체사건 F : 정식사건, T: 임시사건 , I : 내사사건, S : 중지사건
	function fnChoiceGrid(seVal){

		initGrid(seVal);

		if( !fnSearchValidate() ){
			return;
		}

		$("#hidRcSeCd").val(seVal);
		$("#hidRcSeCdTarget").val(seVal+"T");
		$("a[name=tab]").removeClass("on");
		$("#tab_"+seVal).addClass("on");

/*
 		$("#textReceiptYear").val();
		$("#textReceiptNoStart").val();
		$("#textReceiptNoEnd").val();

		$("#radioSearchStdr").val();

		$("#textReceiptYear").val();

		$("#textReceiptDeStart").val();
		$("#textReceiptDeEnd").val();
 */
		AUIGrid.clearGridData(gridTargetList);

		fnMoveGridPage("/rc/getCaseListAjax/", "frmList", caseGridId, 1);
	}

	// 바디 컨텍스트 메뉴 아이템 선택 핸들러
	function bodyMenuSelectHandler(event, ui) {

		var selectedId = ui.item.prop("id");
		var selectedItems;

		var selectedItems  = AUIGrid.getSelectedItems(caseGridId);
		var selectedItemsT = AUIGrid.getSelectedItems(targetGridId);

		if (selectedItems.length <= 0 ) {
			alert("없음");
			return;
		}

		var      str = "";
		var    docId = "";
		var   rcSeCd = "";	//접수구분
		var   tmprNo = "";	//임시번호
		var   itivNo = "";	//내사번호
		var   caseNo = "";	//사건번호
		var sanctnId = "";
		var trgterSn = "";	//대상자 순번

		var   invProvisCd = ""; /*수사단서*/
		var progrsSttusCd = "";

		var i, rowItem, rowInfoObj, rcNo ;

		for( i = 0; i < selectedItems.length; i++) {
			rowInfoObj = selectedItems[i];

				  rcNo = rowInfoObj.item.RC_NO;
				rcSeCd = rowInfoObj.item.RC_SE_CD;
	     progrsSttusCd = rowInfoObj.item.PROGRS_STTUS_CD;
	     		 docId = rowInfoObj.item.DOC_ID;
	     	  sanctnId = rowInfoObj.item.SANCTN_ID;
	       invProvisCd = rowInfoObj.item.INV_PROVIS_CD;
	 caseEndSeChangeCd = rowInfoObj.item.CASE_END_SE_CHANGE_CD;

	     	if( null != rowInfoObj.item.CASE_NO ){
				caseNo = rowInfoObj.item.CASE_NO;
     		}
     		if( null != rowInfoObj.item.ITIV_NO ){
				itivNo = rowInfoObj.item.ITIV_NO;
     		}
     		if( null != rowInfoObj.item.TMPR_NO ){
     			tmprNo = rowInfoObj.item.TMPR_NO;
     		}
		}
		for( i = 0; i < selectedItemsT.length; i++) {
			rowInfoObj = selectedItemsT[i];
			  trgterSn = rowInfoObj.item.grdTrgterSn;
		}

		switch(selectedId) {
		case "liContextItem_F01": //출석요구
			location.href = "<c:url value='/inv/atend/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"'/>";
			break;
		case "liContextItem_F02": //조서관리
			location.href = "<c:url value='/inv/rcdMgt/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"'/>";
			break;
		case "liContextItem_F03": //대상자 긴급체포
			location.href = "<c:url value='/inv/emgcArrst/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"&hidArrstTyCd=00732'/>";
			break;
		case "liContextItem_F04": //대상자 현행범체포
			location.href = "<c:url value='/inv/emgcArrst/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"&hidArrstTyCd=00733'/>";
			break;
		case "liContextItem_F05": //대상자 체포영장에의한 체포
			location.href = "<c:url value='/inv/emgcArrst/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"&hidArrstTyCd=00735'/>";
			break;
		case "liContextItem_F06": //대상자 통신사실확인 허가 신청
			location.href = "<c:url value='/inv/zrlong/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"&hidPageType=commng'/>";
			break;
		case "liContextItem_F07": //대상자 체포영장
			location.href = "<c:url value='/inv/zrlong/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"&hidPageType=zrlong'/>";
			break;
		case "liContextItem_F08": //대상자 구속영장
			location.href = "<c:url value='/inv/zrlong/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"&hidPageType=zrlong'/>";
			break;
		case "liContextItem_F09": //대상자 압수수색 검증 영장
			location.href = "<c:url value='/inv/zrlong/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"&hidPageType=szure'/>";
			break;
		case "liContextItem_F10": //대상자 피의자석방건의
			location.href = "<c:url value='/inv/sugest/?rcNo="+rcNo+"&sugestTyCd=01102'/>";
			break;
		case "liContextItem_F11": //압수물 지휘건의
			location.href = "<c:url value='/inv/sugest/?rcNo="+rcNo+"&sugestTyCd=01103'/>";
			break;
		case "liContextItem_F12": //압수물관리
			location.href = "<c:url value='/inv/ccdrcManage/?hidRcNo="+rcNo+"&hidCaseNo="+caseNo+"'/>";
			break;
		case "liContextItem_FC01": //정식사건 수정
			//location.href = "<c:url value='/rc/caseUpdateView/?rcNo="+rcNo+"&rcSeCd="+rcSeCd+"'/>";
			fnCaseUpdatePopup( rcNo, rcSeCd, progrsSttusCd );
			break;
		case "liContextItem_FC02": // 사건 대상자 추가
			fnTargetInputPopup(rcNo, progrsSttusCd );
			break;
		case "liContextItem_FC03": // 내사사건 사건변경요청
			//사건승인요청 공통 팝업   Reverse Forward
			fnCaseConfmReqst( rcNo, rcSeCd, progrsSttusCd, "I", "02131", "01383", sanctnId, "R" );
			break;
		case "liContextItem_FC04": // 임시사건 사건변경요청
			//사건승인요청 공통 팝업
			fnCaseConfmReqst( rcNo, rcSeCd, progrsSttusCd, "T", "02131", "01383", sanctnId, "R" );
			break;
		case "liContextItem_FC05": // 범죄인지보고
			fnCaseReception( rcNo, rcSeCd, progrsSttusCd, caseNo, sanctnId, caseEndSeChangeCd );
			break;
		case "liContextItem_FC06": // 범죄인지보고서
			fnCaseRptPopup (rcNo, docId, "8", invProvisCd, "R");
			break;
		case "liContextItem_FC07": //범죄인지서(표지)
			fnCaseRptPopup (rcNo, docId, "7", invProvisCd, "R");
			break;
		/*
		case "liContextItem_FC00": //고소,고발 또는 수사이첩 접수부
			fnReceptionReprtPopup( rcNo, docId );
			break;
		*/
		case "liContextItem_FC08": //수사지휘건의
			location.href = "<c:url value='/inv/sugest/?rcNo="+rcNo+"&sugestTyCd=01101'/>";
			break;
		case "liContextItem_FC09": //사건송치
			location.href = "<c:url value='/trn/trnManage/?hidRcNo="+rcNo+"'/>";
			break;
		case "liContextItem_FC10": //사건이송
			fnCaseTrnsf( rcNo );
			break;
		case "liContextItem_FT01": //사건 대상자 수정
			fnTargetUpdatePopup( rcNo, rcSeCd, trgterSn, progrsSttusCd );
			break;
		case "liContextItem_IC01": //내사사건 수정
			//location.href = "<c:url value='/rc/caseUpdateView/?rcNo="+rcNo+"&rcSeCd="+rcSeCd+"'/>";
			fnCaseUpdatePopup( rcNo, rcSeCd, progrsSttusCd )
			break;
		case "liContextItem_IC02": //사건 대상자 추가
			fnTargetInputPopup( rcNo, progrsSttusCd );
			break;
		case "liContextItem_IC11": //범죄인지보고(=정식사건 접수 요청)
			fnCaseReception( rcNo, rcSeCd, progrsSttusCd, caseNo, sanctnId );
			break;
		case "liContextItem_IC12": //범죄인지보고서
			fnCaseRptPopup (rcNo, docId, "8", invProvisCd);
			break;
		case "liContextItem_IC13": //범죄인지서
			fnCaseRptPopup (rcNo, docId, "7", invProvisCd);
			break;
		case "liContextItem_IC21": //내사착수 보고
			fnItivOutsetReprtPopup(rcNo, itivNo, progrsSttusCd);
			break;
		case "liContextItem_IC22": //내사사건표지
			fnCaseRptPopup (rcNo, docId, "5", invProvisCd);
			break;
		case "liContextItem_IC23": //내사결과보고
			fnItivResultReprtPopup(rcNo, itivNo, progrsSttusCd);
			break;
		case "liContextItem_IC31": //임시사건 사건변경요청
			fnCaseConfmReqst( rcNo, rcSeCd, progrsSttusCd, "T", "02131", "01383", sanctnId, "R" );
			break;
		case "liContextItem_IC41": //사건 이송
			fnCaseTrnsf( rcNo );
			break;
		case "liContextItem_IC10": //고소,고발 또는 수사이첩 접수부
			fnReceptionReprtPopup( rcNo, docId );
			break;
		case "liContextItem_I01": //출석요구관리
			location.href = "<c:url value='/inv/atend/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"'/>";
			break;
		case "liContextItem_I02": //조서관리
			location.href = "<c:url value='/inv/rcdMgt/?hidRcNo="+rcNo+"'/>";
			break;
		case "liContextItem_IT01": //사건대상자 수정
			fnTargetUpdatePopup( rcNo, rcSeCd, trgterSn, progrsSttusCd );
			break;
		case "liContextItem_TC01": //사건 대상자 추가
			fnTargetInputPopup( rcNo, progrsSttusCd );
			break;
		case "liContextItem_TC02": //임시사건 수정
			//location.href = "<c:url value='/rc/caseUpdateView/?rcNo="+rcNo+"&rcSeCd="+rcSeCd+"'/>";
			fnCaseUpdatePopup( rcNo, rcSeCd, progrsSttusCd );
			break;
		case "liContextItem_TC03": //임시사건 삭제
			/* 사건 승인요청
    		rcNo : 접수번호
  		  rcSeCd : 사건구분코드
   progrsSttusCd : 진행상태코드

	  changeSeCd : 변경요청 사건구분코드
  changeProgrsCd : 변경될 사건진행코드
	confmJobSeCd : 승인구분코드
		sanctnId : 결재 ID
			01382	사건작성
			01383	사건구분변경
			01384	사건삭제
			*/
			//사건승인요청 공통 팝업

			/* 사건 변경/삭제 승인요청
	        rcNo : 접수번호
   	      rcSeCd : 사건구분코드
   progrsSttusCd : 진행상태코드

      changeSeCd : 변경요청 사건구분코드
  changeProgrsCd : 변경될 사건진행코드
    confmJobSeCd : 승인구분코드
	    sanctnId : 결재 ID
	   direction : 정방향/역방향 변경요청 구분
	*/

			//fnCaseConfmReqst( rcNo, rcSeCd, progrsSttusCd, rcSeCd, "02141", "01384", "" );
			fnCaseConfmReqst( rcNo, rcSeCd, progrsSttusCd, "", "02142", "01384", sanctnId, "" );
			break;
		case "liContextItem_TC04": //임시사건 결과보고
			fnTmprResultReprtPopup(rcNo, tmprNo,progrsSttusCd);
		break;
		case "liContextItem_TC05": //임시사건결과보고서
			fnCaseRptPopup(rcNo, docId, "202", invProvisCd);
		break;
		case "liContextItem_TC06": //임시사건 표지
			fnCaseRptPopup (rcNo, docId, "201", invProvisCd);
		break;
		case "liContextItem_TC11": //범죄인지보고(=정식사건 접수 요청)
			fnCaseReception( rcNo, rcSeCd, progrsSttusCd, caseNo, sanctnId );
			break;
		case "liContextItem_TC12": //범죄인지보고서
			fnCaseRptPopup( rcNo, docId, "8", invProvisCd );
			break;
		case "liContextItem_TC13": //범죄인지
			fnCaseRptPopup( rcNo, docId, "7", invProvisCd );
			break;
		case "liContextItem_TC14": //내사사건 접수
			//사건승인요청 공통 팝업
			fnCaseConfmReqst( rcNo, rcSeCd, progrsSttusCd, "I", "02131", "01383", sanctnId );
			break;
		case "liContextItem_TC21": //사건 이송
			fnCaseTrnsf( rcNo );
			break;
		case "liContextItem_TC31": //고소,고발 또는 수사이첩 접수부
			fnReceptionReprtPopup( rcNo, docId );
			break;
		case "liContextItem_T01": //출석요구관리
			location.href = "<c:url value='/inv/atend/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"'/>";
			break;
		case "liContextItem_T02": //조서관리
			location.href = "<c:url value='/inv/rcdMgt/?hidRcNo="+rcNo+"'/>";
			break;
		case "liContextItem_TT01": //접수 사건대상자 수정
			fnTargetUpdatePopup( rcNo, rcSeCd, trgterSn, progrsSttusCd );
			break;
		case "liContextItem_SC01": //수사재개
			var stopType = "";
			if ( "02124" == progrsSttusCd) {
				stopType = "S"
			} else if( "02125" == progrsSttusCd ){
				stopType = "R"
			}
			location.href = "<c:url value='/inv/emgcArrst/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"&hidPageType="+stopType+"'/>";
			break;
		case "liContextItem_S01": //출석요구관리
			location.href = "<c:url value='/inv/atend/?hidRcNo="+rcNo+"&hidTrgterSn="+trgterSn+"'/>";
			break;
		case "liContextItem_S02": //조서관리
			location.href = "<c:url value='/inv/rcdMgt/?hidRcNo="+rcNo+"'/>";
			break;
		default:
			break;
		}
	};

	// 사건 그리드 컨텍스트 메뉴 감추기
	function hideContextMenu() {

		if( nowBodyMenuVisible ) { // 메뉴 감추기
			$("#bodyMenu").menu("destroy");
			$("#bodyMenu").hide();
			/* $("#bodyMenu"+sectionVal+"T").menu("destroy");
			$("#bodyMenu"+sectionVal+"T").hide(); */
			nowBodyMenuVisible= false;
		}
	};

	//범죄인지 보고서 팝업
	function fnCaseRptPopup( rcNo, docId, fmType, invProvisCd, docType ){

		if( invProvisCd == "00401" || invProvisCd == "00402" ) {	/*고소, 고발*/
			alert("고소 ·고발은 범죄인지보고서와 범죄인지서를 작성하지 않습니다.");
			return;
		}

		if( fnIsEmpty(docId) || fnIsEmpty(rcNo) ){
			alert("문서 양식을 확인할 수 없습니다.");
			return;
		}

		var strStatus = "width=1000,height=980,toolbar=no,status=no,scrollbars=yes,resizable=no";
		window.open('/inv/caseRptPopup/?hidRcNo='+rcNo+"&hidDocId="+docId+"&hidFmType="+fmType+"&hidDocType="+docType, 'reportInput', strStatus);
	}

	//범죄인지보고 팝업 (=정식 사건 접수) 접수번호, 접수구분, 사건진행상태, 사건번호, 승인ID
	function fnCaseReception( rcNo, rcSeCd, progrsSttusCd, caseNo, sanctnId , caseEndSeChangeCd ){
		
		/*
		if( !fnIsEmpty(caseNo) ){
			alert("승인이 완료된 접수입니다.");
			return;
		}
 		*/
 		
		if( fnIsEmpty(sanctnId) ){
			sanctnId = "";
		}

 		/*	if ( "F" == rcSeCd  "02103" == progrsSttusCd || "02104" == progrsSttusCd ) ){
			var processAfterGet = function(data){
				if( data.result == "1" ){
					alert("정식사건 접수요청이 완료되었습니다.");
					fnMoveGridPage( "/rc/getCaseListAjax/", "frmList", caseGridId, $("#hidPage").val() );
				} else if( data.result == "-2" ){
					alert("해당사건을 찾을 수 없습니다.");
				} else if( data.result == "-3" ){
					alert("정식사건 접수요청은 \n\n'정식사건 작성완료', \n'정식사건 반려' \n\n일 경우에 사용가능합니다.");
				} else {
					alert("승인요청중 오류가 발생하였습니다.");
				}
			}
			Aja x.getJson("<c:url value='/inv/savePrsctAjax/'/>", "?hidRcNo="+rcNo+"&hidSanctnId="+sanctnId, processAfterGet);
		}
			*/
		crmnlRecognitionPopup = dhtmlmodal.open('crmnlRecognitionPopup', 'iframe', '/rc/crmnlRecognitionPopup/?rcNo='+rcNo+'&rcSeCd='+rcSeCd, '범죄인지보고', 'width=882px,height=550px,center=1,resize=0,scrolling=1');
	}


	//그리드사건 클릭시 대상자 조회
	function fnTargetSearch() {

		fnSearchGrid( "/rc/trgterList/", "gridSearchForm", targetGridId );

		$("#searchCaseNo").val("");
		$("#searchRcNo").val("");
	}


	//사건 변경 공통 validate
	//진행상태, 그리드 구분(사건/대상자), CRUD
	function fnCaseAllChangeValidate( progrsSttusCd, gridType, crudType ){

		var returnCode = false;
		var typeNm="";
		var crudNm="";

		//그리드구분 처리
		if( "C" == gridType ){
			typeNm="사건을";
		} else if( "T" == gridType ){
			typeNm="대상자를";
		}

		//그리드구분 처리
		if( "C" == crudType ){
			crudNm="추가";
		} else if( "U" == crudType ){
			crudNm="수정";
		} else if( "D" == crudType ){
			crudNm="삭제";
		} else if( "R" == crudType ){ //여기서는 Request의 의미로 사용
			crudNm="변경";
		}

		if( "02131" == progrsSttusCd || "02141" == progrsSttusCd ){
			alert("사건 변경/삭제 요청중에는 "+typeNm+" "+crudNm+" 할 수 없습니다.");
			return false;
		}

		if( "02112" == progrsSttusCd || "02124" == progrsSttusCd || "02125" == progrsSttusCd ){
			alert("중지된 사건은 "+typeNm+" "+crudNm+" 할 수 없습니다.");
			return false;
		}

		if( "02111" == progrsSttusCd || "02113" == progrsSttusCd || "02114" == progrsSttusCd ||"02123" == progrsSttusCd ){
			alert("종결된 사건은 "+typeNm+" "+crudNm+" 할 수 없습니다.");
			return false;
		}
		if( "02142" == progrsSttusCd  ){
			alert("삭제 된 사건은 "+typeNm+" "+crudNm+" 할 수 없습니다.");
			return false;
		}

		return true;
	}

	/* 사건 변경/삭제 승인요청
	        rcNo : 접수번호
   	      rcSeCd : 사건구분코드
   progrsSttusCd : 진행상태코드

      changeSeCd : 변경요청 사건구분코드
  changeProgrsCd : 변경될 사건진행코드
    confmJobSeCd : 승인구분코드
	    sanctnId : 결재 ID
	   direction : 정방향/역방향 변경요청 구분
	*/
	function fnCaseConfmReqst( rcNo, rcSeCd, progrsSttusCd, changeSeCd, changeProgrsCd , confmJobSeCd, sanctnId, direction ){

		var crudType ="";

		if( "01383" == confmJobSeCd ){
			crudType = "R"
		} else if( "01384" == confmJobSeCd ){
			crudType = "D"
		}

		if( fnCaseAllChangeValidate( progrsSttusCd, "C", crudType ) ){

			var param = {
							"rcNo" : rcNo
				    	, "rcSeCd" : rcSeCd
				 , "progrsSttusCd" : progrsSttusCd
				    , "changeSeCd" : changeSeCd
				, "changeProgrsCd" : changeProgrsCd
				  , "confmJobSeCd" : confmJobSeCd
				      , "sanctnId" : sanctnId
				     , "direction" : direction
						};

			var processAfterGet = function(data) {
													if( data == "0" ){
														alert("신청이 완료되었습니다.");
														fnSearch();
													}else if( data == "-2"){
														alert("현재 진행상태에서는 사건변경할수없습니다."); 
													}else {
														alert("신청 중 오류가 발생하였습니다.");
													}
												 };
			Ajax.getJson('<c:url value='/rc/updateCaseConfmRequst/'/>', param, processAfterGet);
		}
	}


	//사건 수정
	function fnCaseUpdatePopup( rcNo, rcSeCd, progrsSttusCd ){
		if( fnCaseAllChangeValidate( progrsSttusCd, "C", "U" ) ){
			caseUpdatePopup = dhtmlmodal.open('caseUpdatePopup', 'iframe', '/rc/caseUpdatePopup/?rcNo='+rcNo+'&rcSeCd='+rcSeCd, '사건 수정', caseUpdatePopSize );
		}
	}

	//대상자 수정
	function fnTargetUpdatePopup( rcNo, rcSeCd, trgterSn, progrsSttusCd ){
		if( fnCaseAllChangeValidate( progrsSttusCd, "T", "U" ) ){
			targetUpdatePopup = dhtmlmodal.open('targetUpdatePopup', 'iframe', '/rc/targetUpdatePopup/?rcNo='+rcNo+'&rcSeCd='+rcSeCd+'&trgterSn='+trgterSn, '대상자 수정', trgterUpdatePopSize );
		}
	}

	//대상자 추가
	function fnTargetInputPopup( rcNo, progrsSttusCd ){
		if( fnCaseAllChangeValidate( progrsSttusCd, "T", "C" ) ){
			targetInputPopup = dhtmlmodal.open('targetInputPopup', 'iframe', '/rc/targetInputPopup/?rcNo='+rcNo, '대상자 작성', trgterUpdatePopSize);
		}
	}

	//타기관 이송
	function fnCaseTrnsf( rcNo ){
		trnsfPopup = dhtmlmodal.open('trnsfPopup', 'iframe', "/inv/trnsfPopup/?rcNo="+rcNo, '타기관이송', 'width=650px,height=410px,center=1,resize=0,scrolling=0');
		trnsfPopup.onclose = function(){

			var iframedoc = this.contentDoc;
			// 이송 ajax
			var str = "";
			var len = iframedoc.getElementsByName("rdoInsttSeCd").length;
			for (var i = 0 ; i < len ; i++) {
				if (iframedoc.getElementsByName("rdoInsttSeCd")[i].checked) {
					str = iframedoc.getElementsByName("rdoInsttSeCd")[i].value;
					break;
				}
			}

			var iUrl = "<c:url value='/inv/addTrnsfRcAjax/'/>";
			var queryString = {
				hidRcNo         : rcNo,
				calTrnsfDe      : iframedoc.getElementById("calTrnsfDe").value,
				rdoInsttSeCd    : str,
				txtInsttNm      : iframedoc.getElementById("txtInsttNm").value,
				txtInsttDept    : iframedoc.getElementById("txtInsttDept").value,
				txtInsttCharger : iframedoc.getElementById("txtInsttCharger").value,
				selResnCd       : iframedoc.getElementById("selResnCd").value,
				txtResnDc       : iframedoc.getElementById("txtResnDc").value
			};

			var processAfterGet = function(data) {
				if( data.result == "1" ){
					alert("이송저장되었습니다.");
					AUIGrid.clearGridData(gridTargetList);
					fnMoveGridPage("/rc/getCaseListAjax/", "frmList", caseGridId, 1);
				} else {
					alert("이송 저장중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);

			return true;
		};
	}

	//범죄인지보고
	function fnItivOutsetReprtPopup( rcNo, progrsSttusCd ){
		itivOutsetReprtPopup = dhtmlmodal.open('itivOutsetReprtPopup', 'iframe', '/rc/itivOutsetReprtPopup/?rcNo='+rcNo+'&progrsSttusCd='+progrsSttusCd, '내사착수보고', 'width=882px,height=550px,center=1,resize=0,scrolling=1');
	}

	//임시결과보고
	function fnTmprResultReprtPopup( rcNo, tmprNo, progrsSttusCd ){
		tmprResultReprtPopup = dhtmlmodal.open('tmprResultReprtPopup', 'iframe', '/rc/tmprResultReprtPopup/?rcNo='+rcNo+'&tmprNo='+tmprNo+'&progrsSttusCd='+progrsSttusCd , '임시결과보고', 'width=882px,height=550px,center=1,resize=0,scrolling=1');
	}

	//내사착수보고
	function fnItivOutsetReprtPopup( rcNo, itivNo, progrsSttusCd ){
		itivOutsetReprtPopup = dhtmlmodal.open('itivOutsetReprtPopup', 'iframe', '/rc/itivOutsetReprtPopup/?rcNo='+rcNo+'&itivNo='+itivNo+'&progrsSttusCd='+progrsSttusCd, '내사착수보고', 'width=882px,height=550px,center=1,resize=0,scrolling=1');
	}

	//내사결과보고
	function fnItivResultReprtPopup( rcNo, itivNo, progrsSttusCd ){
		if( itivNo == null || itivNo == "" ){
			alert("내사착수 승인 후 확인 가능합니다.");
		} else {
			itivResultReprtPopup = dhtmlmodal.open('itivResultReprtPopup', 'iframe', '/rc/itivResultReprtPopup/?rcNo='+rcNo+'&itivNo='+itivNo+'&progrsSttusCd='+progrsSttusCd , '내사결과보고', 'width=882px,height=550px,center=1,resize=0,scrolling=1');
		}
	}

	//고소,고발 또는 수사이첩 접수부
	function fnReceptionReprtPopup( rcNo, docId ){
		receptionReprtPopup = dhtmlmodal.open('receptionReprtPopup', 'iframe', '/rc/receptionReprtPopup/?rcNo='+rcNo+'&docId='+docId, '고소,고발 또는 수사이첩 접수부', 'width=700px,height=370px,center=1,resize=0,scrolling=0');
	}

	/*
	//정식 사건승인요청
	function btnPrsctPop (rcNo, caseNo) {
		prsctPopup = dhtmlmodal.open( 'prsctPopup', 'iframe'
				                    , '/inv/prsctPopup/?hidCaseNo='+caseNo+'&hidRcNo='+rcNo
				                    , '사건승인요청', 'width=1000px,height=700px,center=1,resize=0,scrolling=0');
	}

	//정식접수승인취소
	function prsctDtlPopup(caseNo){
		prsctDtlMoPopup = dhtmlmodal.open('prsctDtlPopup', 'iframe',
				'/inv/prsctDtlPopup/?hidCaseNo='+caseNo,
		        '정식접수승인취소', 'width=800px,height=580px,center=1,resize=0,scrolling=0');
	}
 */

</script>

<form id="gridSearchForm">
	<input type="hidden" id="searchCaseNo" name="searchCaseNo"/>
	<input type="hidden" id="searchRcNo"   name="searchRcNo"  />
</form>

<form id="frmList" name="frmList" >

	<!-- 그리드 sort 관련 -->
	<input type="hidden" id="sortingFields" name="sortingFields"/>
	<input type="hidden" id="sortchk" name="sortchk"/> 

	<!-- 그리드 paging 관련 -->
	<input type="hidden" id="hidPage"			name="hidPage" 		value="${hidPage}">
	<input type="hidden" id="hidTotCnt" 		name="hidTotCnt" 	value="0"		  >
	<input type="hidden" id="hidPageArea" 		name="hidPageArea" 	value="10"		  >
	<input type="hidden" id="hidPageBlock" 		name="hidPageBlock" value="30"		  >

	<!-- 그리드 관련 -->
	<input type="hidden" id="hidFormatId" 		name="hidFormatId">

	<!-- 탭클릭 사건구분 param -->
	<input type="hidden" id="hidRcSeCd" 		name="hidRcSeCd"		 >
	<input type="hidden" id="hidRcSeCdTarget" 	name="hidRcSeCdTarget"	 >
	<input type="hidden" id="hidRcNo" 			name="hidRcNo"			 >
	<input type="hidden" id="hidCaseRcInputMode"name="hidCaseRcInputMode">
	<input type="hidden" id="hidDeptCd" 		name="hidDeptCd" 		  value="${deptCd}"			>
	<input type="hidden" id="hidMyCaseSectionCd"name="hidMyCaseSectionCd" value="${myCaseSectionCd}">

	<input type="hidden" id="hidMenuCd" 	    name="hidMenuCd" 		  value="00056" > <!-- 메뉴구분코드 Controller 에서 사용-->

	<!---------검색박스 --------->
	<div class="search_box mb_30">
		<div class="search_in">
			<div class="input_radio4  w_70px t_left" style="width: 100px;margin-right: 0px;">
				<input class="to-labelauty-icon mt_5 labelauty" type="radio" name="radioSearchStdr" id="radioSearchStdrDe" value= "stdrDe"  style="display: none;">
					<label for="radioSearchStdrDe">
					<span class="labelauty-unchecked-image"></span>
					<span class="labelauty-checked-image"></span></label>
				<div class="stitle ">접수일자</div>
			</div>
			<div class="r_box ">
				<div class="input_out w_120px  fl">
					<input type="text"	id="textReceiptDeStart" name="textReceiptDeStart" class="w_120p input_com_s rc_search" maxlength="10" checkName="접수일자" >
				</div>
				<div class="sp_tx fl mr_5 ml_5">~</div>
				<div class="input_out  w_120px fl">
					<input type="text"	id="textReceiptDeEnd" 	name="textReceiptDeEnd"	class="w_120p input_com_s datetimepicker rc_search" maxlength="10" checkName="접수일자">
				</div>
			</div>
			<div class="input_radio4  w_100px t_left" style="width: 120px;margin-right: 0px;margin-left: 20px;">
				<input class="to-labelauty-icon mt_5 labelauty" type="radio"name="radioSearchStdr"  id="radioSearchStdrNo" value= "stdrNo" style="display: none;">
				<span class="labelauty-unchecked-image"></span>
				<span class="labelauty-checked-image"></span>
				<select name="selCaseSearchTypeCd" id="selCaseSearchTypeCd" size="1" class="input_com mr_5" style="width: 85px;">
					<option value="R">접수번호</option>
					<option value="C">사건번호</option>
					<option value="I">내사번호</option>
					<option value="T">임시번호</option>
				</select>
			</div>

			<div class="r_box w_180px mr_10" style="width: 260px;">
				<input type="text" id="textSearchYear" 		name="textSearchYear"	class="w_28p input_com_s onlyNumber rc_search"	maxlength="4" placeholder="예)2019" style="width: 68px;">
				-
				<input type="text" id="textSearchNoStart"	name="textSearchNoStart"class="w_28p input_com_s onlyNumber rc_search"	maxlength="6">
				~
				<input type="text" id="textSearchNoEnd" 	name="textSearchNoEnd"	class="w_30p input_com_s onlyNumber rc_search"	maxlength="6">
			</div>
		</div>
		<div class="go_search2"  id="btnSearch">검색</div>
	</div>
    <!--검색박스 종료-->
</form>

<!--탭 메뉴 -->
<div class="tab_box">
	<ul>
   		<li><a href="javascript:void(0);" onclick="fnChoiceGrid('A');" id="tab_A" name="tab" class="on">전체사건</a></li>
   		<li><a href="javascript:void(0);" onclick="fnChoiceGrid('F');" id="tab_F" name="tab" >정식 사건</a></li>
	  	<li><a href="javascript:void(0);" onclick="fnChoiceGrid('I');" id="tab_I" name="tab" >내사 사건</a></li>
	  	<li><a href="javascript:void(0);" onclick="fnChoiceGrid('T');" id="tab_T" name="tab" >임시 사건</a></li>
	  	<li><a href="javascript:void(0);" onclick="fnChoiceGrid('S');" id="tab_S" name="tab" >중지 사건</a></li>
	</ul>
</div>
<!-- 탭 메뉴 종료 -->

<!-- 그리드 & 그리드 페이징 -->
<div class="com_box mb" style="margin-bottom: 0px;">
	<div class="tb_01_box">
		<div id="grid_case_list" class="gridResize" style="width:100%; height:330px; margin:0 auto;"></div>
		<div id="grid_case_list_paging" style="width:100%; height:40px;  margin-bottom: 0px;" class="aui-grid-paging-panel my-grid-paging-panel"></div>
	</div>
</div>

<div class="title_s_st2 w_50p fl">
	<img src="/img/title_icon1.png" alt="">대상자 정보
</div>
<div class="com_box mb_30">
	<div class="tb_01_box">
		<div id="grid_target_list" class="gridResize" style="width:100%; height:183px; margin:0 auto;"></div>
	</div>
</div>

<ul id="bodyMenu" class="bodyMenu cssBodyMenu">
	<li id="liContextItem_FC01" class="FC cssCtTxt">사건정보 수정</li>
	<li id="liContextItem_FC02" class="FC cssCtTxt">사건대상자 추가</li>
	<li id="liContextItem_FC03" class="FC cssCtTxt">내사사건 사건변경</li>
	<li id="liContextItem_FC04" class="FC cssCtTxt">임시사건 사건변경</li>
	<li id="liContextItem_FC05" class="FC cssCtTxt">범죄인지보고</li>
	<li id="liContextItem_FC06" class="FC cssCtTxt">범죄인지보고서</li>
	<li id="liContextItem_FC07" class="FC cssCtTxt">범죄인지서(표지)</li>
	<!--
	<li id="liContextItem_FC06" class="FC">고소,고발 또는 수사이첩 접수부</li>
	-->
	<li class="FC"></li>
	<li id="liContextItem_FT01" class="FT cssCtTxt">사건대상자 수정</li>
	<li class="FT"></li>
	<li id="liContextItem_F01"  class="F cssCtTxt" >출석요구</li>
	<li id="liContextItem_F02"  class="F cssCtTxt" >조서관리</li>
	<li id="liContextItem_F03"  class="F cssCtTxt" >긴급체포</li>
	<li id="liContextItem_F04"  class="F cssCtTxt" >현행범체포</li>
	<li id="liContextItem_F05"  class="F cssCtTxt" >체포영장에의한 체포</li>
	<li id="liContextItem_F06"  class="F cssCtTxt" >통신사실확인 허가신청</li>
	<li id="liContextItem_F07"  class="F cssCtTxt" >체포영장</li>
	<li id="liContextItem_F08"  class="F cssCtTxt" >구속영장</li>
	<li id="liContextItem_F09"  class="F cssCtTxt" >압수수색 검증 영장</li>
	<li id="liContextItem_F10"  class="F cssCtTxt" >피의자석방건의</li>
	<li id="liContextItem_F11"  class="F cssCtTxt" >압수물 지휘건의</li>
	<li id="liContextItem_F12"  class="F cssCtTxt" >압수물관리</li>
	<li class="FC"></li>
	<li id="liContextItem_FC08" class="FC cssCtTxt">수사지휘건의</li>
	<li id="liContextItem_FC09" class="FC cssCtTxt">사건송치</li>
	<li id="liContextItem_FC10" class="FC cssCtTxt">사건이송</li>

	<li id="liContextItem_IT01" class="IT cssCtTxt">사건대상자 수정</li>
	<li id="liContextItem_IC01" class="IC cssCtTxt">내사사건 수정</li>
	<li id="liContextItem_IC02" class="IC cssCtTxt">사건 대상자 추가</li>
	<!--
	<li id="liContextItem_IC11" class="IC cssCtTxt">범죄인지보고</li>
	<li id="liContextItem_IC12" class="IC cssCtTxt">범죄인지보고서</li>
	<li id="liContextItem_IC13" class="IC cssCtTxt">범죄인지서(표지)</li>
	-->
	<li class="IC"></li>
	<li id="liContextItem_IC21" class="IC cssCtTxt">내사착수 보고</li>
	<li id="liContextItem_IC22" class="IC cssCtTxt">내사사건 표지</li>
	<li id="liContextItem_IC23" class="IC cssCtTxt">내사결과 보고</li>
	<li id="liContextItem_IC31" class="IC cssCtTxt">임시사건 사건변경</li>
	<li id="liContextItem_IC41" class="IC cssCtTxt">사건 이송</li>
	<li class="I"></li>
	<li id="liContextItem_I01"  class="I cssCtTxt" >출석요구관리</li>
	<li id="liContextItem_I02"  class="I cssCtTxt" >조서관리</li>

	<!-- <li id="liContextItem_IC09" class="IC cssCtTxt">고소,고발 또는 수사이첩 접수부</li> -->

	<li id="liContextItem_TT01" class="TT cssCtTxt">사건대상자 수정</li>
	<li class="TT"></li>
	<li id="liContextItem_TC01" class="TC cssCtTxt">사건 대상자 추가</li>
	<li id="liContextItem_TC02" class="TC cssCtTxt">임시사건 수정</li>
	<li id="liContextItem_TC03" class="TC cssCtTxt">임시사건 삭제</li>
	<li id="liContextItem_TC04" class="TC cssCtTxt">임시사건 결과보고</li>
	<li id="liContextItem_TC05" class="TC cssCtTxt">임시사건 결과보고서</li>
	<li id="liContextItem_TC06" class="TC cssCtTxt">임시사건 표지</li>
	<li class="TC"></li>
	<!--
	<li id="liContextItem_TC11" class="TC cssCtTxt">범죄인지보고</li>
	<li id="liContextItem_TC12" class="TC cssCtTxt">범죄인지보고서</li>
	<li id="liContextItem_TC13" class="TC cssCtTxt">범죄인지서(표지)</li>
	-->
	<!-- <li id="liContextItem_TC14" class="TC cssCtTxt">내사사건 접수</li> --> <!-- RcController 에서 미처리 됨, 우선 주석 2020.02.14 -->
	<li id="liContextItem_TC21" class="TC cssCtTxt">사건 이송</li>
	<li class="TC"></li>
	<li id="liContextItem_T01"  class="T cssCtTxt">출석요구관리</li>
	<li id="liContextItem_T02"  class="T cssCtTxt">조서관리</li>
	<!-- <li id="liContextItem_TC09" class="TC cssCtTxt">고소,고발 또는 수사이첩 접수부</li> -->

	<li id="liContextItem_SC01" class="SC cssCtTxt">수사재개</li>
	<li class="SC"></li>
	<li id="liContextItem_S01"  class="S cssCtTxt">출석요구관리</li>
	<li id="liContextItem_S02"  class="S cssCtTxt">조서관리</li>
</ul>
