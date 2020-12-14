<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<script type="text/javascript" src="/js/jquery-ui.js"></script>
<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>

<style>

/* 검색박스 스타일 정의 */
.rc_search {
	height: 30px!important;
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
</style>

<script type="text/javascript" src="/js/rc.common.js"></script>
<script type="text/javascript">
	var   caseGridId = "#grid_list";
	var nowBodyMenuVisible = false;

	$(function() {

		$(document).ready(function(){

			fnDatePickerImg("textReceiptDeStart", fnGetToday(12, 0), true);	//input Calendar setting
			fnDatePickerImg("textReceiptDeEnd"	, null, true);	//input Calendar setting
			initGrid();			//그리드 초기화

		  	$('input:radio[name=radioSearchStdr]:input[value=all]').attr("checked", true);
		   	fnSearch();
		});

		// document 이벤트
		$(document).on("click", function(event) {

			if($(event.target).attr("aria-haspopup")) { // 서브 메뉴 아이템 클릭 한 경우
				return;
			}
			hideContextMenu();	//컨텍스트 메뉴 감추기
		});

		//상위코드 조회
		$("#searchDeptUpCd").change(function(){
			fnUpDeptList( $(this).val(), $("#searchDeptCd") );
		});


		//부서 찾기 팝업
		$("#btnDeptSearch").click(function (){
			fnDeptSelect();
		});

		$('#btnSearch').click(function() {

			if( !fnSearchAllValidate() ){
				return;
			}

			fnMoveGridPage( "/rc/getCaseListAjax/", "frmList", caseGridId, 1 );
		});


		//검색 송치사건 체크박스 클릭시
		$('#chkTrnCase').click(function(){

			if ( $("#chkTrnCase").prop("checked") ){
				if( $("#chkColdCase").prop("checked") ){
					$("#chkColdCase").prop('checked', false);
				}
				if( $("#chkStopCase").prop("checked") ){
					$("#chkStopCase").prop('checked', false);
				}
			}
		});

		//검색 미제사건 체크박스 클릭시
		$('#chkColdCase').click(function(){

			if( $("#chkColdCase").prop("checked") ){
				if( $("#chkTrnCase").prop("checked") ){
					$("#chkTrnCase").prop('checked', false);
				}
				if( $("#chkStopCase").prop("checked") ){
					$("#chkStopCase").prop('checked', false);
				}
			}
		});

		//검색 중지사건 체크박스 클릭시
		$('#chkStopCase').click(function(){

			if( $("#chkStopCase").prop("checked") ){
				if( $("#chkTrnCase").prop("checked") ){
					$("#chkTrnCase").prop('checked', false);
				}
				if( $("#chkColdCase").prop("checked") ){
					$("#chkColdCase").prop('checked', false);
				}
			}
		});

	})

	//Aui 그리드 컬럼값 설정
	var columnLayout = [
		  { dataField : "RN"			 , headerText : "순번"	  , width : 30}
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
		, { dataField : "CASE_NO"		 , headerText : "사건번호"	, width : 92
			 , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
		  }
		, { dataField : "ITIV_NO"		 , headerText : "내사번호"	, width : 92
			 , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
		  }
		, { dataField : "TMPR_NO"		 , headerText : "임시번호"	, width : 92
			 , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
		  }
		, { dataField : "RC_NO"			 , headerText : "접수번호"	, width : 92
			 , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
		  }
		, { dataField : "INV_PROVIS_NM"	, headerText : "수사단서"	, width : 70 	}
		, { dataField : "RC_SE_NM"	 	, headerText : "사건구분"	, width : 60	}
		, { dataField : "SUSPCT"		, headerText : "피의자 등"	, width : 100
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
		, { dataField : "VIOLT_NM"	, headerText : "위반죄명" , width : 300 }
		, { dataField : "SUFRER"	, headerText : "고발인 등" , width : 100
		  , labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {

			  					var sufrerArr = !fnIsEmpty(value)?value.split("/"):"";

			  				  	if ( 1 < sufrerArr.length ) {
			  				  	    return sufrerArr[0] + ' 외 '+ (sufrerArr.length-1)+'명';
			  				  	} else if ( 1 == sufrerArr.length && "" != sufrerArr[0] ){
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
		, { dataField : "ALOT_USER_NM"	 , headerText : "담당자"	, width : 92	}
		, { dataField : "RC_DT"			 , headerText : "접수일자", width : 70		}
		, { dataField : "TRN_NO"		 , headerText : "송치번호", width : 70 , visible : false }
	];

	var gridPros = {

			  useGroupingPanel : false
			, showRowNumColumn : false
			 , displayTreeOpen : true
				, headerHeight : 30
				   , rowHeight : 30
		  , fillColumnSizeMode : true
		//    , enableMouseWheel : false
		//, enableHScrollByWheel : false
		//	    , scrollHeight : -8
		      , useContextMenu : true
		, enableRightDownFocus : true
	};

	//그리드 초기화 function
	function initGrid() {

		AUIGrid.create(caseGridId, columnLayout, gridPros);
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

		AUIGrid.bind( caseGridId, "contextMenu", auiGridContextEventHandler );
		
		AUIGrid.bind(caseGridId, "sorting", gridSort);
	}


	//부서 찾기 팝업
	function fnSelectDept(upcd, cd, nm){

		$("#textDeptNm").val(nm);
		$("#textDeptCd").val(cd);

		//담당자 조회
		fnSearchDeptCharger();
	}

	//부서 담당자 조회
	function fnSearchDeptCharger(){

		$.ajax({
       //contentType : "application/x-www-form-urlencoded; charset=UTF-8"
                 url : "/rc/getDeptChargerListAjax/"
          , dataType : "json"
              , type : "post"
             , async : false	//동기: false, 비동기: ture
              , data : { "deptCd" : $("#textDeptCd").val()}
           , success : function(retVal){

						    var deptChargerList = retVal.deptChargerList;

						    $('#selectDeptCharger').empty();

		                    var option = "";

		                    for( var count = 0; count < deptChargerList.length; count++ ){
			                    if( count < 1 ){
			                    	option+='<option value="" >전체</option>'
			                    }
			                    option+="<option value="+deptChargerList[count].ESNTL_ID+" >"+deptChargerList[count].USER_NM+"</option>"
						    }

		                    $('#selectDeptCharger').html(option);
		           	  }

            , error : function(request, status, error){
                		console.log("AJAX_ERROR");
            		  }
        });
	}

	//사건 검색
	function fnSearch() {

		fnMoveGridPage("/rc/getCaseListAjax/", "frmList", caseGridId, 1);
	}

	//사건 상세 조회
	function fnDetail(esntl_id) {

		var form = $("form[id=frmList]");
		$("input:hidden[id=hidEsntlId]").val(esntl_id);
		form.attr({"method":"post","action":"<c:url value='/rc/caseRcDetail/'/>"});
		form.submit();
	}

	// 사건 그리드 컨텍스트 메뉴 감추기
	function hideContextMenu() {

		if( nowBodyMenuVisible ) { // 메뉴 감추기
			$("#bodyMenu").menu("destroy");
			$("#bodyMenu").hide();
			nowBodyMenuVisible= false;
		}
	};

	//사건그리드 컨텍스트 메뉴 이벤트 핸들러
	function auiGridContextEventHandler(event) {

		hideContextMenu();

		if ("02123" == event.item.PROGRS_STTUS_CD){

			if( event.target == "body" ) { // 바디 컨텍스트
				currentRowIndex = event.rowIndex;
				// 사용자가 만든 컨텍스트 메뉴 보이게 하기
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
			}
		}

		return false; // 기본으로 제공되는 컨텍스트 사용 안함.
	};

	// 바디 컨텍스트 메뉴 아이템 선택 핸들러
	function bodyMenuSelectHandler(event, ui) {

		var selectedId = ui.item.prop("id");
		var selectedItems;

		var selectedItems  = AUIGrid.getSelectedItems(caseGridId);

		if (selectedItems.length <= 0 ) {
			alert("없음");
			return;
		}

		var      str = "";
		var   rcSeCd = "";	//접수구분
		var   itivNo = "";	//내사번호
		var   caseNo = "";	//사건번호
		var trgterSn = "";	//대상자 순번
		var progrsSttusCd = "";
		var docId 	 = "";
		var sanctnId = "";
		var invProvisCd = ""; /*수사단서*/
		var i, rowItem, rowInfoObj, rcNo ;

		for( i = 0; i < selectedItems.length; i++) {
			rowInfoObj = selectedItems[i];

				  rcNo = rowInfoObj.item.RC_NO;
				rcSeCd = rowInfoObj.item.RC_SE_CD;
	     progrsSttusCd = rowInfoObj.item.PROGRS_STTUS_CD;
	     		 docId = rowInfoObj.item.DOC_ID;
	     	  sanctnId = rowInfoObj.item.SANCTN_ID;
	       invProvisCd = rowInfoObj.item.INV_PROVIS_CD;
	       		 trnNo = rowInfoObj.item.TRN_NO;

	     	if( null != rowInfoObj.item.CASE_NO ){
				caseNo = rowInfoObj.item.CASE_NO;
     		}
     		if( null != rowInfoObj.item.ITIV_NO ){
				itivNo = rowInfoObj.item.ITIV_NO;
     		}
		}

		switch(selectedId) {

		case "liDelTrnCase": //송치 삭제
			//location.href = "<c:url value='/rc/caseUpdateView/?rcNo="+rcNo+"&rcSeCd="+rcSeCd+"'/>";

			if(confirm("송치된 사건을 삭제 하시겠습니까?")){
				fnDelTrnCase( trnNo );
			} else {
				alert("취소되었습니다.");
			}
			break;
		case "liReTrnCase": //재송치
			//location.href = "<c:url value='/rc/caseUpdateView/?rcNo="+rcNo+"&rcSeCd="+rcSeCd+"'/>";
			if(confirm("송치된 사건을 재송치 하시겠습니까?")){
				fnReTrnCase( caseNo );
			} else {
				alert("취소되었습니다.");
			}
			break;

		default:
			break;
		}
	};

	//송치 삭제
	function fnDelTrnCase( trnNo ){
		var iUrl = "<c:url value='/trn/delTrnAjax/'/>";
		var queryString = {"hidTrnNo" : trnNo};
		var processAfterGet = function(data) {
			if(data.result == "1"){
				alert("삭제되었습니다.");
				fnMoveGridPage( "/rc/getCaseListAjax/", "frmList", caseGridId, $("#hidPage").val());
			} else {
				alert("삭제중 오류가 발생하였습니다.");
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	//재송치
	function fnReTrnCase( caseNo ){
		var iUrl = "<c:url value='/trn/addReTrnAjax/'/>";
		var queryString = {"hidCaseNo" : caseNo};
		var processAfterGet = function(data) {
			if(data.result == "1"){
				alert("재송치가 완료되었습니다.");
				fnMoveGridPage( "/rc/getCaseListAjax/", "frmList", caseGridId, $("#hidPage").val());
			} else {
				alert("재송치 처리중 오류가 발생하였습니다.");
			}
		};
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}


</script>

<form id="frmList" name="frmList">

	<!-- 그리드 sort 관련 -->
	<input type="hidden" id="sortingFields" name="sortingFields"/>
	<input type="hidden" id="sortchk" name="sortchk"/>

	<!-- 그리드 paging 관련 -->
	<input type="hidden" id="hidPage"		name="hidPage" 		value="${hidPage}">
	<input type="hidden" id="hidTotCnt" 	name="hidTotCnt" 	value="0">
	<input type="hidden" id="hidPageArea" 	name="hidPageArea" 	value="10">
	<input type="hidden" id="hidPageBlock" 	name="hidPageBlock" value="50">

	<input type="hidden" id="hidMenuCd" 	name="hidMenuCd" 	value="00070"> <!-- 메뉴구분코드 Controller 에서 사용-->


	<!--검색박스 -->
    <div class="search_box mb_30">
    	<div class="search_in" style="padding-left: 10px;">
			<div class="input_radio4  w_70px t_left" style="width: 70px;margin-right: 0px;">
				<input class="to-labelauty-icon mt_5 labelauty" type="radio"name="radioSearchStdr"  value= "all" style="display: none;">
				<label for="radioSearchStdrNo">
					<span class="labelauty-unchecked-image"></span>
					<span class="labelauty-checked-image"></span>
				</label>
				<div class="stitle ">전체</div>
			</div>
			<div class="input_radio4  w_70px t_left" style="width: 130px;margin-right: 0px;">
				<input class="to-labelauty-icon mt_5 labelauty" type="radio"name="radioSearchStdr"  value= "dept" style="display: none;">
				<label for="radioSearchStdrNo">
					<span class="labelauty-unchecked-image"></span>
					<span class="labelauty-checked-image"></span>
				</label>
		        <div class="stitle w_100px">부서/담당자</div>
		     </div>
		        	<div class="r_box">
			          <!--찾기 -->
			          <div class="flex_r">
						<input type="text" 		id="textDeptNm" 	name="textDeptNm"	value="${deptNm}" maxlength="50" size="50" value="" class="input_com" placeholder="부서" style="width: 200px;">
	            		<input type="hidden" 	id="textDeptCd" 	name="textDeptCd"	value="${deptCd}">
	            		<input type="button" 	id="btnDeptSearch" 	class="btn_search">
			          <!--//찾기 폼-->
						<select class="w_120px ml_5"	id="selectDeptCharger" name="selectDeptCharger">
				     		<option value="">전체</option>
				   		</select>
					</div>
		    	</div>

		</div>
		<div class="search_in" style="padding-left: 10px;">
			<select name="selCaseSearchTypeCd" id="selCaseSearchTypeCd" size="1" class="input_com mr_5" style="width: 85px;!important;height: 23px;">
				<option value="R">접수번호</option>
				<option value="C">사건번호</option>
				<option value="I">내사번호</option>
				<option value="T">임시번호</option>
			</select>

			<div class="r_box w_180px mr_10" style="width: 260px;">
				<input type="text" id="textSearchYear" 		name="textSearchYear"		class="w_28p input_com_s onlyNumber rc_search"	maxlength="4" placeholder="예)2019"  style="width: 68px;">
				-
				<input type="text" id="textSearchNoStart"	name="textSearchNoStart"	class="w_28p input_com_s onlyNumber rc_search"	maxlength="6">
				~
				<input type="text" id="textSearchNoEnd" 	name="textSearchNoEnd"		class="w_30p input_com_s onlyNumber rc_search"	maxlength="6">
			</div>
			<div class="input_radio4  w_70px t_left" style="width: 70px; margin-right: 0px; padding-left: 0px;">
				<div class="stitle ">접수일자</div>
			</div>
			<div class="r_box ">
				<div class="input_out w_110px  fl">
					<input type="text"	id="textReceiptDeStart" name="textReceiptDeStart" class="w_120p input_com_s datetimepicker rc_search" maxlength="10" checkName="접수일자">
					<div id="divReceiptDeStart" class="calendarOverlay"></div>
				</div>
				<div class="sp_tx fl mr_5 ml_5">~</div>
				<div class="input_out  w_110px fl">
					<input type="text"	id="textReceiptDeEnd" 	name="textReceiptDeEnd"	class="w_120p input_com_s datetimepicker rc_search" maxlength="10" checkName="접수일자">
				  	<div id="divReceiptDeEnd" class="calendarOverlay"></div>
				</div>
			</div>
		</div>
		<div class="search_in" style="padding-left: 10px;width: 110px;border-right:0px">
			<div class="input_radio4  w_70px t_left" style="width: 70px;margin-right: 0px;padding-left: 25px;padding-right: 0px">
				<div class="stitle">미제사건</div>
				<input class="to-labelauty-icon ch_st1" type="checkbox" name="chkColdCase" id="chkColdCase" value="Y"/>
			</div>
			<div class="input_radio4  w_70px t_left" style="width: 70px;margin-right: 0px;padding-left: 25px;">
				<div class="stitle">중지사건</div>
				<input class="to-labelauty-icon ch_st1" type="checkbox" name="chkStopCase"	id="chkStopCase"	value="Y"/>
			</div>
		</div>
		<div class="search_in" style="padding-left: 0px;padding-right: 0px;width: 110px;">
			<div class="input_radio4  w_70px t_left" style="width: 70px;margin-right: 0px;padding-left: 25px;">
				<div class="stitle">송치사건</div>
				<input class="to-labelauty-icon ch_st1" type="checkbox" name="chkTrnCase"	id="chkTrnCase"	value="Y"/>
			</div>
		</div>
		<div class="go_search2"  id="btnSearch">검색</div>
	</div>
</form>

<!-- 그리드 & 그리드 페이징 -->
<div class="com_box mb_30">
	<div class="tb_01_box">
		<div id="grid_list" class="gridResize" style="width:100%; height:580px; margin:0 auto;"></div>
		<div id="grid_list_paging" style="width:100%; height:40px;" class="aui-grid-paging-panel my-grid-paging-panel"></div>
	</div>
</div>

<ul id="bodyMenu" class="bodyMenu">
	<li id="liReTrnCase">재송치</li>
	<li id="liDelTrnCase">송치 삭제</li>
</ul>
