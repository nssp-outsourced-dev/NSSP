<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<script type="text/javascript" src="/js/jquery-ui.js"></script>
<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>
<!-- 접수사건관리 -->

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
	box-shadow: 3px 3px 3px rgba(0, 0, 0, 0.3);
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
			fnDatePickerImg(  "textReceiptDeEnd", null, true);	//input Calendar setting
			$("#hidRcSeCdTarget").val("RT");
			$("#hidRcSeCd").val("R");
			initGrid();			//그리드 초기화

			if( !fnSearchValidate() ){
				return;
			}

		});//end jQuery ready

		// document 이벤트
		$(document).on("click", function(event) {

			if($(event.target).attr("aria-haspopup")) { // 서브 메뉴 아이템 클릭 한 경우
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
	function fnSearch() {
		fnMoveGridPage( "/rc/getCaseListAjax/", "frmList", caseGridId, 1 );
	}

	//컬럼정보 설정
	var columnLayout = [
		  { dataField : "RN"			 , headerText : "순번" 	, width   : 35 	 }
		, { dataField : "RC_NO"			 , headerText : "접수번호"	, width   : 70
		  , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								return fnChangeNo (value);
		  					}
		  }
		, { dataField : "RC_SE_CD"	 	 , headerText : "구분코드"	, visible : false}
		, { dataField : "INV_PROVIS_NM"	 , headerText : "수사단서 "	, width   : 70 	 }
		, { dataField : "RC_SE_NM"	 	 , headerText : "사건구분"	, width   : 60 	 }
		, { dataField : "SUSPCT"		 , headerText : "피의자 등"	, width   : 80
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
		, { dataField : "VIOLT_NM"		 , headerText : "위반죄명"    	, width : 250	}
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

		, { dataField : "SANCTN_ID"		 , headerText : "SANCTN_ID"	, width : 110, visible : false }
		, { dataField : "PROGRS_STTUS_CD", headerText : "진행상태"  	, width : 120, visible : false }
		, { dataField : "PROGRS_STTUS_NM", headerText : "진행상태"		, width :  80, visible : true , height : 150
		   , renderer : {type : "TemplateRenderer"}
		   , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								var template = "";
								if(item.PROGRS_STTUS_CD == "02104"){
									template = "<a href=\"javascript:void(0);\" onClick=\"fnSanctnHistory('"+item.SANCTN_ID+"');\" class=\"btn_td1 icon_n fl \" style=\"text-align:center;\">"+value+"</a>";
								} else {
									template += value;
								}
								return template;
							}
		   , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {

								//지연 기간 임시 설정 original 90/(90+전자문서 작성)/60~90
								if( "02124" == item.PROGRS_STTUS_CD ) {	//Delay
									return "my-column-style";
								} else if( "02125" == item.PROGRS_STTUS_CD ) {
									return "my-column-style1";
								} else {
									return null;
								}
							}

		  }
		, { dataField : "CHARGER_DEPT_NM", headerText : "담당 부서"	 , width : 100	}
		, { dataField : "ALOT_USER_NM"	 , headerText : "담당자"	 , width : 80	}
		, { dataField : "CHARGER_ID"	 , headerText : "담당자 ID" , width : 80,	visible : false	}
		, { dataField : "RC_DT"			 , headerText : "접수일자"	 , width : 65	}
		, { dataField : "WRITNG_DT"		 , headerText : "작성일"	 , width : 65	}
		, { dataField : "DOC_ID"		 , headerText : "문서ID"	 , width : 110,	visible : false	}
	];

	//컬럼정보 설정
	var columnLayoutT = [
		  { dataField : "grdRn"			 , headerText : "순번"	, width : 30 	}
		, { dataField : "grdTrgterNm"	 , headerText : "대상자명"	, width : 80 	}
		, { dataField : "grdTrgterSeNm"	 , headerText : "구분"	, width : 60 	}
		, { dataField : "grdTrgterTyNm"	 , headerText : "유형"	, width : 60 	}
		, { dataField : "grdTrgterClNm"	 , headerText : "분류"	, width : 60 	}
		, { dataField : "grdTrgterAge"	 , headerText : "나이"	, width : 30 	}
		, { dataField : "grdSexdstnNm"	 , headerText : "성별"	, width : 30 	}
		, { dataField : "grdTrgterRrn"	 , headerText : "주민번호"	, width : 80 	}
		, { dataField : "grdHpNo"		 , headerText : "휴대전화"	, width : 80	}
		, { dataField : "grdAdresAddr"	 , headerText : "주소지"	, width : 250	}
		, { dataField : "grdChargerId"	 , headerText : "담당자ID", visible : false }
		, { dataField : "grdProgrsSttusCd",headerText : "진행상태"	, visible : false }
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
	function initGrid() {

		AUIGrid.create(   caseGridId,  columnLayout, gridPros);
		gridTargetList = AUIGrid.create( targetGridId, columnLayoutT, gridProsT);

		AUIGrid.bind(caseGridId, "cellDoubleClick", function(event) {
			var  items = event.item;
			var   rcNo = "";
			var caseNo = "";

			rcNo = items.RC_NO;

			if( null != items.CASE_NO){
				caseNo = items.CASE_NO;
			}

			fnCaseDetailPopup( rcNo, caseNo );	//사건상세조회 팝업
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

			$("#hidRcSeCd").val("R");

			if(items.CHARGER_ID	!= null){
				$("#hidChargerYN").val("Y");
			} else {
				$("#hidChargerYN").val("N");
			}

			$("#searchRcNo").val(rcNo);

			AUIGrid.clearGridData( gridTargetList );
			fnTargetSearch();//대상자 조회
		});

		AUIGrid.bind(   caseGridId, "contextMenu", auiGridContextEventHandler );
		AUIGrid.bind( targetGridId, "contextMenu", auiGridContextEventHandler );
		
		AUIGrid.bind(caseGridId, "sorting", gridSort);

		fnMoveGridPage( "/rc/getCaseListAjax/", "frmList", caseGridId, 1 );
	}// End grid Init


	//사건 진행상태 변경
	//접수번호/사건구분코드/진행상태코드/ 변경될 사건구분코드/변경상태코드
	function fnDelCase( rcNo, rcSeCd, progrsSttusCd, updateRcSeCd, crud ){

		//alert("사건삭제");

		var param = {	"rcNo" : rcNo
				    , "rcSeCd" : rcSeCd
			     	  , "crud" : crud
			  , "updateRcSeCd" : updateRcSeCd
			  ,"progrsSttusCd" : progrsSttusCd
			 		};

		var processAfterGet = function(data) {

			if(data == "0"){
				if("D" == crud ){			//변경상태 코드가 삭제 :D일 경우
					alert("삭제가 완료되었습니다.");
				}
				fnSearch();
			} else {
				alert("삭제 중 오류가 발생하였습니다.");
			}
		};

		if( confirm("삭제하시겠습니까?")){
			Ajax.getJson('<c:url value='/rc/updateCaseConfmRequst/'/>', param, processAfterGet);
		}
	}

	//그리드사건 클릭시 대상자 조회
	function fnTargetSearch (){

		fnSearchGrid("/rc/trgterList/", "gridSearchForm", targetGridId);

		$("#searchCaseNo").val("");
		$("#searchRcNo").val("");
	}

	// 사건 그리드 컨텍스트 메뉴 감추기
	function hideContextMenu(){

		if( nowBodyMenuVisible ){ // 메뉴 감추기
			$("#bodyMenu").menu("destroy");
			$("#bodyMenu").hide();
			/*
			$("#bodyMenu"+sectionVal+"T").menu("destroy");
			$("#bodyMenu"+sectionVal+"T").hide();
			*/

			nowBodyMenuVisible= false;
		}
	};


	// 진행상태 체크
	function fnValidateProgrsSttus( value ){

		switch(value) {
			case "02101": //접수대기
				return false;
				break;
			case "02104": //접수반려
				return false;
				break;
			default:
				return true;
				break;
		}
	}

	//사건그리드 컨텍스트 메뉴 이벤트 핸들러
	function auiGridContextEventHandler( event ){

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
			   , top : event.pageY
			}).show();

			var progrsSttus = "";
			var chargerYn = event.item.CHARGER_ID;

			if( event.pid =="#grid_case_list" ){		//사건 그리드

				chargerYn = event.item.CHARGER_ID;
				progrsSttus = event.item.PROGRS_STTUS_CD;

				//배당 완료 여부
				if( chargerYn != null ){
					$("#bodyMenu>li").not(".C").hide();
					return false; // 기본으로 제공되는 컨텍스트 사용 안함.
				} else if( fnValidateProgrsSttus( progrsSttus ) ){
					$("#bodyMenu>li").not(".R").hide();
					return false;
				} else {
					$("#bodyMenu>li").not(".RC").hide();
					return false;
				}

			} else if( event.pid =="#grid_target_list" ){ //대상자 그리드

				chargerYn = event.item.grdChargerId;
				progrsSttus = event.item.grdProgrsSttusCd;

				//배당 완료 여부
				if( chargerYn != null ){
					$("#bodyMenu>li").not(".C").hide();
					return false;
				} else if( fnValidateProgrsSttus( progrsSttus ) ){
					$("#bodyMenu>li").not(".R").hide();
					return false;
				} else {
					$("#bodyMenu>li").not(".RT").hide();
					return false;
				}
			}
		}
	};


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
		var    docId = "";		//문서번호
		var   rcSeCd = "";		//접수구분
		var   itivNo = "";		//내사번호
		var   caseNo = "";		//사건번호
		var sanctnId = "";		//결제ID
		var trgterSn = "";		//대상자 SN

		var   invProvisCd = ""; //수사단서
		var progrsSttusCd = "";	//진행상태 코드

		var i, rowItem, rowInfoObj, rcNo ;

		for( i = 0; i < selectedItems.length; i++) {
			rowInfoObj = selectedItems[i];

				  rcNo = rowInfoObj.item.RC_NO;
				rcSeCd = rowInfoObj.item.RC_SE_CD;
	     progrsSttusCd = rowInfoObj.item.PROGRS_STTUS_CD;
	     		 docId = rowInfoObj.item.DOC_ID;
	     	  sanctnId = rowInfoObj.item.SANCTN_ID;
	       invProvisCd = rowInfoObj.item.INV_PROVIS_CD;

	     	if( null != rowInfoObj.item.CASE_NO ){
				caseNo = rowInfoObj.item.CASE_NO;
     		}
     		if( null != rowInfoObj.item.ITIV_NO ){
				itivNo = rowInfoObj.item.ITIV_NO;
     		}
		}

		for( i = 0; i < selectedItemsT.length; i++) {
			rowInfoObj = selectedItemsT[i];
			  trgterSn = rowInfoObj.item.grdTrgterSn;
		}

		switch(selectedId) {

		case "liContextItem_RC00": //사건 승인 요청
			//location.href = "<c:url value='/rc/caseUpdateView/?rcNo="+rcNo+"&rcSeCd="+rcSeCd+"'/>";
			fnCaseConfmReqst( rcNo, rcSeCd, progrsSttusCd, rcSeCd, "", "01382", sanctnId );

			/* 사건 승인요청
		    		rcNo : 접수번호
		  		  rcSeCd : 사건구분코드
		   progrsSttusCd : 진행상태코드

			  changeSeCd : 변경요청 사건구분코드
		  changeProgrsCd : 변경될 사건진행코드
			confmJobSeCd : 승인구분코드
				sanctnId : 결재 ID
			*/
			break;
		case "liContextItem_RC01": //사건 수정
			//location.href = "<c:url value='/rc/caseUpdateView/?rcNo="+rcNo+"&rcSeCd="+rcSeCd+"'/>";
			fnCaseUpdatePopup( rcNo, rcSeCd, progrsSttusCd );
			break;
		case "liContextItem_RC02": //사건 삭제
			fnDelCase( rcNo, rcSeCd, progrsSttusCd, "F", "D" );
			break;
		case "liContextItem_RC10": //대상자 추가
			fnTargetInputPopup(rcNo, rcSeCd, progrsSttusCd );
			break;
		case "liContextItem_RC20": //사건이송
			fnCaseTrnsf( rcNo );
			break;
		case "liContextItem_RT01": //대상자 수정
			fnTargetUpdatePopup( rcNo, rcSeCd, progrsSttusCd, trgterSn );
			break;
		case "liContextItem_R01":
			alert("헤당 사건은 배당이 완료되었습니다.");
			break;
		default:
			break;
		}
	};


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

	function fnProgrsValidate(rcSeCd,progrsSttusCd, requestMsg){

		if("T" == rcSeCd){

			if( "02101" == progrsSttusCd || "02104" == progrsSttusCd ){
				returnMsg = "임시사건";
			} else {
				alert(requestMsg+"이(가) 가능한 상태가 아닙니다.");
				return false;
			}

		}else if("I" == rcSeCd){
			if( "02101" == progrsSttusCd || "02104" == progrsSttusCd ){
				returnMsg = "내사사건";
			} else {
				alert(requestMsg+"이(가) 가능한 상태가 아닙니다.");
				return false;
			}
		} else if ("F" == rcSeCd){
			if( "02101" == progrsSttusCd || "02104" == progrsSttusCd ){
				returnMsg = "정식사건";
			} else {
				alert(requestMsg+"이(가) 가능한 상태가 아닙니다.");
				return false;
			}
		}

		return returnMsg;
	}


	//사건 수정
	function fnCaseUpdatePopup( rcNo, rcSeCd , progrsSttusCd){

		var returnMsg = "";
		var requestMsg = "사건수정";

		returnMsg = fnProgrsValidate(rcSeCd, progrsSttusCd, requestMsg);

		if( !returnMsg ){
			return false;
		}

		caseUpdatePopup = dhtmlmodal.open('caseUpdatePopup', 'iframe', '/rc/caseUpdatePopup/?rcNo='+rcNo+'&rcSeCd='+rcSeCd, '사건 수정', caseUpdatePopSize);
	}

	//대상자 수정
	function fnTargetUpdatePopup( rcNo, rcSeCd, progrsSttusCd, trgterSn ){

		var returnMsg = "";
		var requestMsg = "대상자수정";

		returnMsg = fnProgrsValidate(rcSeCd, progrsSttusCd, requestMsg);

		if( !returnMsg ){
			return false;
		}

		targetUpdatePopup = dhtmlmodal.open('targetUpdatePopup', 'iframe', '/rc/targetUpdatePopup/?rcNo='+rcNo+'&rcSeCd='+rcSeCd+'&trgterSn='+trgterSn, '대상자 수정', trgterUpdatePopSize);
	}

	//대상자 추가
	function fnTargetInputPopup( rcNo,  rcSeCd, progrsSttusCd ){

		var returnMsg = "";
		var requestMsg = "대상자추가";

		returnMsg = fnProgrsValidate(rcSeCd, progrsSttusCd, requestMsg);

		if( !returnMsg ){
			return false;
		}

		targetInputPopup = dhtmlmodal.open('targetInputPopup', 'iframe', '/rc/targetInputPopup/?rcNo='+rcNo, '대상자 작성', 'width=895px,height=670px,center=1,resize=0,scrolling=1');
	}



	/* 사건 승인요청
    		rcNo : 접수번호
  		  rcSeCd : 사건구분코드
   progrsSttusCd : 진행상태코드

	  changeSeCd : 변경요청 사건구분코드
  changeProgrsCd : 변경될 사건진행코드
	confmJobSeCd : 승인구분코드
		sanctnId : 결재 ID
	*/
	function fnCaseConfmReqst( rcNo, rcSeCd, progrsSttusCd, changeSeCd, changeProgrsCd , confmJobSeCd, sanctnId ){

		var returnMsg = "";
		var requestMsg = "승인요청";

		returnMsg = fnProgrsValidate(rcSeCd, progrsSttusCd, requestMsg);

		if( !returnMsg ){
			return false;
		}

		if(confirm(requestMsg +"하시겠습니까?")){

			var  iUrl = "<c:url value='/rc/updateCaseConfmRequst/'/>";
			var param = {
							"rcNo" : rcNo
				    	, "rcSeCd" : rcSeCd
				 , "progrsSttusCd" : progrsSttusCd
				    , "changeSeCd" : changeSeCd
				, "changeProgrsCd" : changeProgrsCd
				  , "confmJobSeCd" : confmJobSeCd
				      , "sanctnId" : sanctnId
						};

			var processAfterGet = function(data) {
													if( data == "0" ){
														alert( requestMsg+"이 완료되었습니다." );
														AUIGrid.clearGridData(gridTargetList);
														fnMoveGridPage("/rc/getCaseListAjax/", "frmList", caseGridId, 1);
													} else {
														alert( requestMsg+" 중 오류가 발생하였습니다." );
													}
												 };

			Ajax.getJson(iUrl, param, processAfterGet);
		};
	}

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
	<input type="hidden" id="hidTotCnt" 		name="hidTotCnt" 	value="0">
	<input type="hidden" id="hidPageArea" 		name="hidPageArea" 	value="10">
	<input type="hidden" id="hidPageBlock" 		name="hidPageBlock" value="30">

	<!-- 그리드 관련 -->
	<input type="hidden" id="hidFormatId" 		name="hidFormatId">

	<!-- 탭클릭 사건구분 param -->
	<input type="hidden" id="hidRcSeCd" 		name="hidRcSeCd">
	<input type="hidden" id="hidChargerYN" 		name="hidChargerYN">
	<input type="hidden" id="hidRcSeCdTarget" 	name="hidRcSeCdTarget">
	<input type="hidden" id="hidRcNo" 			name="hidRcNo">
	<input type="hidden" id="hidCaseRcInputMode"name="hidCaseRcInputMode">
	<input type="hidden" id="hidDeptCd" 		name="hidDeptCd" 			value="${deptCd}">
	<input type="hidden" id="hidMyCaseSectionCd"name="hidMyCaseSectionCd" 	value="${myCaseSectionCd}">
	<input type="hidden" id="selCaseSearchTypeCd"name="selCaseSearchTypeCd" value="R">	<!-- 사건구분코드 접수사건관리는 고정 -->
	<input type="hidden" id="hidMenuCd" 	    name="hidMenuCd" 	value="00072"> <!-- 메뉴구분코드 Controller 에서 사용-->

	<!---------검색박스 --------->
	<div class="search_box mb_30">
		<div class="search_in">
			<div class="input_radio4  w_70px t_left" style="width: 100px;margin-right: 0px;">
				<input class="to-labelauty-icon mt_5 labelauty" type="radio" name="radioSearchStdr" id="radioSearchStdrDe" value= "stdrDe" checked="checked" style="display: none;">
					<label for="radioSearchStdrDe">
					<span class="labelauty-unchecked-image"></span>
					<span class="labelauty-checked-image"></span></label>
				<div class="stitle ">접수일자</div>
			</div>
			<div class="r_box ">
				<div class="input_out w_120px  fl">
					<input type="text"	id="textReceiptDeStart" name="textReceiptDeStart" class="w_120p input_com_s rc_search" maxlength="10" checkName="접수일자">
				</div>
				<div class="sp_tx fl mr_5 ml_5">~</div>
				<div class="input_out  w_120px fl">
					<input type="text"	id="textReceiptDeEnd" 	name="textReceiptDeEnd"	class="w_120p input_com_s datetimepicker rc_search" maxlength="10" checkName="접수일자">
				</div>
			</div>
			<div class="input_radio4  w_70px t_left" style="width: 100px;margin-right: 0px;margin-left: 20px;">
				<input class="to-labelauty-icon mt_5 labelauty" type="radio"name="radioSearchStdr"  id="radioSearchStdrNo" value= "stdrNo" style="display: none;">
				<label for="radioSearchStdrNo">
				<span class="labelauty-unchecked-image"></span>
					<span class="labelauty-checked-image"></span></label>
				<div class="stitle ">접수번호</div>
			</div>

			<div class="r_box w_180px mr_10" style="width: 260px;">
				<input type="text" id="textSearchYear" 		name="textSearchYear"		class="w_28p input_com_s onlyNumber rc_search"	maxlength="4" placeholder="예)2019" style="width: 68px;">
				-
				<input type="text" id="textSearchNoStart"	name="textSearchNoStart"	class="w_28p input_com_s onlyNumber rc_search"	maxlength="6">
				~
				<input type="text" id="textSearchNoEnd" 	name="textSearchNoEnd"		class="w_30p input_com_s onlyNumber rc_search"	maxlength="6">
			</div>
		</div>
		<div class="search_in" style="padding-left: 10px;width: 110px;border-right:0px">
			<div class="input_radio4  w_70px t_left" style="width: 70px;margin-right: 0px;padding-left: 25px;padding-right: 0px">
				<div class="stitle">접수대기</div>
				<input class="to-labelauty-icon ch_st1" type="checkbox" name="chkRcCase" id="chkRcCase" value="Y" checked="checked"/>
			</div>
		</div>
		<div class="go_search2"  id="btnSearch">검색</div>
	</div>
    <!--검색박스 종료-->
</form>

<!--탭 메뉴 -->
<!-- <div class="tab_box">
	<ul>
	  	<li><a href="javascript:void(0);" onclick="fnChoiceGrid('R');" id="tab_R" name="tab" class="on">접수 사건</a></li>
	</ul>
</div> -->
<!-- 탭 메뉴 종료 -->

<!-- 그리드 & 그리드 페이징 -->
<div class="com_box mb" style="margin-bottom: 0px;">
	<div class="tb_01_box">
		<div id="grid_case_list" class="gridResize" style="width:100%; height:370px; margin:0 auto;"></div>
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

<ul id="bodyMenu" class="bodyMenu cssBodyMenu" style="box-shadow : 5px 5px 5px rgba(0,0,0,0.3)">
	<li id="liContextItem_RC00"	class="RC cssCtTxt">사건 승인 요청</li>
	<li class="RC"></li>
	<li id="liContextItem_RC01"	class="RC cssCtTxt">사건 수정</li>
	<li id="liContextItem_RC02" class="RC cssCtTxt">사건 삭제</li>
	<li class="RC"></li>
	<li id="liContextItem_RC10" class="RC cssCtTxt">대상자 추가</li>
	<li class="RC"></li>
	<li id="liContextItem_RC20" class="RC cssCtTxt">사건이송</li>
	<li id="liContextItem_RT01" class="RT cssCtTxt">대상자 수정</li>
	<li id="liContextItem_R01" 	class="C cssCtTxt">사건 배당 완료</li>
	<li id="liContextItem_R02" 	class="R cssCtTxt">승인 요청중입니다</li>
</ul>
