<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

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
</style>

<script type="text/javascript" src="/js/rc.common.js"></script>
<script type="text/javascript">
	$(function() {

		$(document).ready(function(){
			fnDatePickerImg("textReceiptDeStart", fnGetToday(12, 0), true);	//input Calendar setting
			fnDatePickerImg("textReceiptDeEnd"	, null, true);	//input Calendar setting
			initGrid();			//그리드 초기화
			fnSearchDeptCharger();
			fnChoiceGrid("F");	//화면 초기에 정식사건으로 그리드 지정
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

			if( !fnSearchValidate() ){
				return;
			}

			fnMoveGridPage( "/rc/getCaseListAjax/", "frmList", "#grid_list", 1 );
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
				} else {
					return value;
				}
		    }
		  }
		, { dataField : "CASE_NO"		 , headerText : "사건번호", width : 92
			 , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
									return fnChangeNo (value);
							   }
		  }
		, { dataField : "ITIV_NO"		 , headerText : "내사번호", width : 92
		  , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								return fnChangeNo (value);
						    }
	      }
		, { dataField : "TMPR_NO"		 , headerText : "임시번호", width : 92
		  , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								return fnChangeNo (value);
							}
		  }
		, { dataField : "RC_NO"			 , headerText : "접수번호", width : 92
		  , labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								return fnChangeNo (value);
							}
		  }
		, { dataField : "INV_PROVIS_NM"	 , headerText : "수사단서"	, width : 70 	}
		, { dataField : "RC_SE_NM"	 	 , headerText : "사건구분"	, width : 60 	}
		, { dataField : "SUSPCT"		 , headerText : "피의자 등"	, width : 100
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
		, { dataField : "VIOLT_NM"		 , headerText : "위반죄명", width : 300 }
		, { dataField : "SUFRER"		 , headerText : "고발인 등"  , width : 100
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
		, { dataField : "ALOT_USER_NM"	 , headerText : "담당자"  , width : 92	}
		, { dataField : "RC_DT"			 , headerText : "접수일자", width : 70}
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
	};

	//그리드 초기화 function
	function initGrid() {

		AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var  items = event.item;
			var   rcNo = "";
			var caseNo = "";

			rcNo = items.RC_NO;

			if( null != items.CASE_NO){
				caseNo = items.CASE_NO;
			}

			fnCaseDetailPopup( rcNo, caseNo );	//사건상세조회 팝업 cubox.js
		});
		
		AUIGrid.bind("#grid_list", "sorting", gridSort);
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

		                    for (var count = 0; count < deptChargerList.length; count++ ){
			                    if(count < 1){
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

	//부서 사건 검색
	function fnSearch() {

		fnMoveGridPage("/rc/getCaseListAjax/", "frmList", "#grid_list", 1);
	}

	//사건 상세 조회
	function fnDetail(esntl_id) {

		var form = $("form[id=frmList]");
		$("input:hidden[id=hidEsntlId]").val(esntl_id);
		form.attr({"method":"post","action":"<c:url value='/rc/caseRcDetail/'/>"});
		form.submit();
	}

	//그리드 변경 function
	//사건 구분 코드 seVal - F : 정식사건, T: 임시사건 , I : 내사사건
	function fnChoiceGrid(seVal){

		$("#hidRcSeCd").val(seVal);
		$("a[name=tab]").removeClass("on");
		$("#tab_"+seVal).addClass("on");

		fnMoveGridPage("/rc/getCaseListAjax/", "frmList", "#grid_list", 1);
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

	<input type="hidden" id="hidMenuCd" 	name="hidMenuCd" 	value="00001">


	<!--검색박스 -->
    <div class="search_box mb_30">

		<div class="search_in">
	        <div class="stitle w_100px">부서/담당자</div>
	        	<div class="r_box">
		          <!--찾기 -->
		          <div class="flex_r ">
					<input type="text" 		id="textDeptNm" 	name="textDeptNm" 	value="${deptNm}" maxlength="50" size="50" value="" class="input_com" placeholder="부서" style="width: 200px;">
            		<input type="hidden" 	id="textDeptCd" 	name="textDeptCd"	value="${deptCd}">
            		<input type="button" 	id="btnDeptSearch" 	class="btn_search">
		          <!--//찾기 폼-->
					<select class="w_120px ml_5" id="selectDeptCharger" name="selectDeptCharger">
			     		<option value="">전체</option>
			   		</select>
				</div>
	    	</div>
		</div>
		<div class="search_in" style="padding-left: 10px;">
			<div class="input_radio4  w_70px t_left" style="width: 120px;margin-right: 0px;">
				<input class="to-labelauty-icon mt_5 labelauty" type="radio"name="radioSearchStdr"  id="radioSearchStdrNo" value= "stdrNo" style="display: none;">
				<label for="radioSearchStdrNo">
					<span class="labelauty-unchecked-image"></span>
					<span class="labelauty-checked-image"></span>
				</label>
				<select name="selCaseSearchTypeCd" id="selCaseSearchTypeCd" size="1" class="input_com mr_5" style="width: 85px;!important;height: 23px;">
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
			<div class="input_radio4  w_70px t_left" style="width: 100px;margin-right: 0px;">
				<input class="to-labelauty-icon mt_5 labelauty" type="radio" name="radioSearchStdr" id="radioSearchStdrDe" value= "stdrDe" checked="checked" style="display: none;">
					<label for="radioSearchStdrDe">
					<span class="labelauty-unchecked-image"></span>
					<span class="labelauty-checked-image"></span></label>
				<div class="stitle ">접수일자</div>
			</div>
			<div class="r_box ">
				<div class="input_out w_120px  fl">
					<input type="text"	id="textReceiptDeStart" name="textReceiptDeStart" class="w_120p input_com_s datetimepicker rc_search" maxlength="10" checkName="접수일자">
					<div id="divReceiptDeStart" class="calendarOverlay"></div>
				</div>
				<div class="sp_tx fl mr_5 ml_5">~</div>
				<div class="input_out  w_120px fl">
					<input type="text"	id="textReceiptDeEnd" 	name="textReceiptDeEnd"	class="w_120p input_com_s datetimepicker rc_search" maxlength="10" checkName="접수일자">
				  	<div id="divReceiptDeEnd" class="calendarOverlay"></div>
				</div>
			</div>
		</div>
		<div class="go_search2"  id="btnSearch">검색</div>
	</div>
</form>

<!-- 그리드 & 그리드 페이징 -->
<div class="com_box mb_30">
	<div class="tb_01_box">
		<div id="grid_list" class="gridResize" style="width:100%; height:600px; margin:0 auto;"></div>
		<div id="grid_list_paging" style="width:100%; height:40px;" class="aui-grid-paging-panel my-grid-paging-panel"></div>
	</div>
</div>
