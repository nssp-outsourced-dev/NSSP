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

</style>

<script type="text/javascript" src="/js/rc.common.js"></script>
<script type="text/javascript">

//바디 컨텍스트 메뉴가 현재 보이고 있는지 여부
var nowBodyMenuVisible = false;

//바디 컨텍스트 메뉴 생성된 곳의 rowIndex 보관 변수
var currentRowIndex;

//grid 변수
var caseGridId = "#grid_case_list";

	$(function() {

		$(document).ready(function(){

			fnDatePickerImg("textReceiptDeStart", fnGetToday(12, 0), true);	//input Calendar setting
			fnDatePickerImg("textReceiptDeEnd"	, null, true);	//input Calendar setting
			initGrid();			//그리드 초기화
			fnChoiceGrid("A");	//화면 초기에 정식사건으로 그리드 지정

		});//end jQuery ready

		// document 이벤트
		$(document).on("click", function(event) {
			if($(event.target).attr("aria-haspopup")) { // 서브 메뉴 아이템 클릭 한 경우
				return;
			}
		});

		$('#btnSearch').click(function() {

			if( !fnSearchValidate() ){
				return;
			}

			fnMoveGridPage( "/rc/getCaseListAjax/", "frmList", caseGridId, 1 );
		});

	});//end jQuery
	
	
	//조회
	function fnSearch () {
		$('#btnSearch').click();
	}

	//컬럼정보 설정
	var columnLayout = [
		  { dataField : "RN"			 , headerText : "순번"	  , width : 30 }
		, { dataField : "DELAY_PD"	 	 , headerText : "경과"	  , width : 30, style:"my-column-style", visible : false
			  , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
									//지연 기간 임시 설정 original 90/(90+전자문서 작성)/60~90
									if(20 >= value ) {	//Delay
										return "my-column-style1";
									} else if (30 >= value  ) {
										return "my-column-style2";
									} else if (90 >= value  ){
										return "my-column-style3";
									}
									return null;
								}
			 , labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
					if(value < 0 ){
						return 0;
					}else{
						return value;
					}
			    }
			  }
		, { dataField : "CASE_NO"		 , headerText : "사건번호"	, width : 80
			 , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
		  }
		, { dataField : "ITIV_NO"		 , headerText : "내사번호"	, width : 80
			 , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
		  }
		, { dataField : "TMPR_NO"		 , headerText : "임시번호"	, width : 80
			 , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
		  }
		, { dataField : "RC_NO"			 , headerText : "접수번호"	, width : 80
			 , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
		  }
		, { dataField : "INV_PROVIS_NM"	 , headerText : "수사단서"	, width : 70 	}
		, { dataField : "RC_SE_NM"	 	 , headerText : "사건구분"	, width : 60 	}
		, { dataField : "SUSPCT"		 , headerText : "피의자 등"	, width : 90
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
		, { dataField : "VIOLT_NM"		 , headerText : "위반죄명"	, width : 300	}
		, { dataField : "SUFRER"		 , headerText : "고발인 등"  , width : 90
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
		, { dataField : "PROGRS_STTUS_NM", headerText : "진행상태", width : 110
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
		, { dataField : "RC_DT"			 , headerText : "접수일자", width : 70	}
	];


	//그리드 환경값 설정
	var gridPros = {
		     useGroupingPanel : false
		   , showRowNumColumn : false
		    , displayTreeOpen : true
		       , enableFilter : true
		     , useContextMenu : false	//컨텍스트 메뉴 사용
	   , enableRightDownFocus : true	//컨텍스트 메뉴를 보기 위해 오른쪽 클릭을 한 경우 클릭 지점이 왼쪽 클릭과 같이 셀 선택을 할지 여부 기본값 : false
		    , groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
		       , headerHeight : 30
			      , rowHeight : 30
		 , fillColumnSizeMode : true
	   //   , enableMouseWheel : false
	   //, enableHScrollByWheel : false
	   //        , scrollHeight : -8
	};

	//그리드 초기화
	function initGrid() {

		AUIGrid.create(   caseGridId,  columnLayout, gridPros);

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
		
		AUIGrid.bind(caseGridId, "sorting", gridSort);


	}// End grid Init

	function fnTargetearch () {
		fnSearchGrid("/rc/trgterList/", "gridSearchForm", targetGridId);
	}


	//그리드 변경 function
	//사건 구분 코드 seVal - F : 정식사건, T: 임시사건 , I : 내사사건
	function fnChoiceGrid(seVal){

		fnMoveGridPage("/rc/getCaseListAjax/", "frmList", caseGridId, 1);
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
	<input type="hidden" id="hidPageBlock" 		name="hidPageBlock" value="50">

	<!-- 그리드 관련 -->
	<input type="hidden" id="hidFormatId" 		name="hidFormatId">

	<input type="hidden" id="hidMenuCd" 		name="hidMenuCd" value="00002">
	<input type="hidden" id="hidRcNo" 			name="hidRcNo">
	<input type="hidden" id="hidCaseRcInputMode"name="hidCaseRcInputMode">
	<input type="hidden" id="hidDeptCd" 		name="hidDeptCd" value="${deptCd}">
	<input type="hidden" id="hidMyCaseSectionCd" name="hidMyCaseSectionCd" value="${myCaseSectionCd}">

	<!--검색박스 -->
    <div class="search_box mb_30">
		<div class="search_in">
			<div class="input_radio4  w_70px t_left" style="width: 100px;margin-right: 0px;">
				<input class="to-labelauty-icon mt_5 labelauty" type="radio" name="radioSearchStdr" id="radioSearchStdrDe" value= "stdrDe" style="display: none;">
					<label for="radioSearchStdrDe">
					<span class="labelauty-unchecked-image"></span>
					<span class="labelauty-checked-image"></span></label>
				<div class="stitle ">접수일자</div>
			</div>
			<div class="r_box ">
				<div class="input_out w_120px  fl">
					<input type="text"	id="textReceiptDeStart" name="textReceiptDeStart" 	class="w_120p input_com_s datetimepicker rc_search" maxlength="10" checkName="접수일자">
					<div id="divReceiptDeStart" class="calendarOverlay"></div>
				</div>
				<div class="sp_tx fl mr_5 ml_5">~</div>
				<div class="input_out  w_120px fl">
					<input type="text"	id="textReceiptDeEnd" 	name="textReceiptDeEnd"		class="w_120p input_com_s datetimepicker rc_search" maxlength="10" checkName="접수일자">
				  	<div id="divReceiptDeEnd" class="calendarOverlay"></div>
				</div>
			</div>
			<div class="input_radio4  w_70px t_left" style="width: 120px;margin-right: 0px;margin-left: 30px;">
				<input class="to-labelauty-icon mt_5 labelauty" type="radio"name="radioSearchStdr"  id="radioSearchStdrNo" value= "stdrNo" style="display: none;">
				<label for="radioSearchStdrNo">
				<span class="labelauty-unchecked-image"></span>
				<span class="labelauty-checked-image"></span></label>
				<select name="selCaseSearchTypeCd" id="selCaseSearchTypeCd" size="1" class="input_com mr_5" style="width: 85px;">
					<option value="R">접수번호</option>
					<option value="C">사건번호</option>
					<option value="I">내사번호</option>
					<option value="T">임시번호</option>
				</select>
			</div>
			<div class="r_box w_180px mr_10" style="width: 260px;">
				<input type="text" id="textSearchYear" 		name="textSearchYear"		class="w_28p input_com_s onlyNumber rc_search"	maxlength="4" placeholder="예)2019" style="width: 68px;">
				-
				<input type="text" id="textSearchNoStart"	name="textSearchNoStart"	class="w_28p input_com_s onlyNumber rc_search"	maxlength="6">
				~
				<input type="text" id="textSearchNoEnd" 	name="textSearchNoEnd"		class="w_30p input_com_s onlyNumber rc_search"	maxlength="6">
			</div>
		</div>
		<div class="go_search2"  id="btnSearch">검색</div>
	</div>
    <!--검색박스 종료-->
</form>

<!-- 탭 메뉴 종료 -->

<!-- 그리드 & 그리드 페이징 -->
<div class="com_box mb_30">
	<div class="tb_01_box">
		<div id="grid_case_list" class="gridResize" style="width:100%; height:600px; margin:0 auto;"></div>
		<div id="grid_case_list_paging" style="width:100%; height:40px;" class="aui-grid-paging-panel my-grid-paging-panel"></div>
	</div>
</div>

