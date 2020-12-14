<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<link rel="stylesheet" type="text/css" href="/css/ay_com.css" media="all">
<link rel="stylesheet" type="text/css" href="/css/jusoPop.css"></link>
<script type="text/javascript" src="/js/jquery-1.11.1.js"></script>
<script type="text/javascript" src="/js/jquery-ui.js"></script>
<script type="text/javascript" src="/js/cubox.js"></script>
<script type="text/javascript" src="/js/cubox.grid.js"></script>
<script type="text/javascript" src="/js/jusoPop.js?jversion=1.01"></script>

<!-- AUIGrid 테마 CSS 파일입니다. 그리드 출력을 위해 꼭 삽입하십시오. -->
<link href="/AUIGrid/AUIGrid_style.css" rel="stylesheet">
<script type="text/javascript" src="/AUIGrid/AUIGridLicense.js"></script>
<script type="text/javascript" src="/AUIGrid/AUIGrid.js"></script>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-text-left {
	text-align:left;
}
/* .my-grid-paging-panel {
	width:1000px;
	margin:4px auto;
	font-size:12px;
	height:38px;
	overflow: hidden;
	border: 1px solid #ccc;
}*/

/* aui-grid-paging-number 클래스 재정의*/
/*.aui-grid-paging-panel .aui-grid-paging-number {
	border-radius : 4px;
} */
</style>
<script type="text/javascript">
$(function(){
	initGrid ();
	$("#searchKeyword").focus();
    $("#searchKeyword").on("keydown", function(event){
    		if (event.which == 13) {
			event.keyCode = 0;
			searchJuso();
		}
    });
	$("#resultData").css("display","none");
	$("#resultList").css("display","none");
});
	function initGrid() {
		var columnLayout = [
							{ dataField : "ADM_CD", 	headerText : "법정동코드", visible :false}, //CMN_LOTNUM_ADDR
							{ dataField : "RN_MGT_SN", 	headerText : "도로명코드", visible :false}, //CMN_ROADNM_CD
							{ dataField : "BD_MGT_SN", 	headerText : "관리번호", 	visible :false},	 //CMN_ROADNM_ADDR
							{ dataField : "RN", 		headerText : "도로명", 	visible :false},
							{ dataField : "ADDR_ADD", 	headerText : "도로명 상세", visible :false},
		        			{ dataField : "NUM", 		headerText : "순번",  	width : 60},
		        			{ dataField : "RN_ADDR", 	headerText : "도로명주소", style : "aui-text-left", wrapText : true,
		        				renderer : { // HTML 템플릿 렌더러 사용
		        					type : "TemplateRenderer"
		        				},
		        				labelFunction : function( rowIndex, columnIndex, value, headerText, item ) {
		        					var sVal = '<div style="font-family:Malgun Gothic, 맑은 고딕, AppleSDGothicNeo-Light,	sans-serif;">'
		        							 + '<font>' + item.RN + ' ' + (fnIsEmpty(item.ADDR_ADD)?"":item.ADDR_ADD) + "</font>";
		        					var sValDtl = '<br/><font style="font-size: 10px;">[지번] '+item.JIBEON_ADDR+'</font></div>';
		        					return sVal + sValDtl;
			            		}
		        			},
		        			{ dataField : "NEW_ZIP_CD", headerText : "우펀번호", 	width : 80}
		        		];
		var gridPros = {
				showRowNumColumn : false,
				displayTreeOpen : true,
				//selectionMode : "multipleCells",	// 선택모드 (기본값은 singleCell 임)
	    		fillColumnSizeMode : true,
	    		wordWrap : true,
				//noDataMessage:"조회 목록이 없습니다.",
				rowHeight : 40,
				headerHeight : 35
		};
		AUIGrid.create("#grid_wrap", columnLayout, gridPros);

		AUIGrid.bind("#grid_wrap", "cellDoubleClick", function(event) {			
			var items = event.item;
			$("#resultData").css("display","block");
	    	$("#resultList").css("display","none");	    	
	    	$("#addrPart1").html(items.RN);
	    	$("#addrPart2").html(items.ADDR_ADD);	    	
	    	$("#zipCd").val(items.NEW_ZIP_CD);	    	
	    	$("#rtAddrDetail").val(items.ADDR_ADD);
	    	$("#rtAddrDetail").focus();
		});
	}
	function fnValiJusoSearch () {
		$("#resultData").hide();
		var frm = $("#mainSearch");
		frm.find("#searchKeyword").val(checkSearchedWord(frm.find("#searchKeyword"))); // 특수문자 및 sql예약어 제거, 20160912
		$("#searchKeyword").val(validateJuso($("#searchKeyword").val())); //공백 및 특수문자 제거
		if(!checkValidate1(frm.find("#searchKeyword"), "검색어")) return false;
		else if(!checkValidate2(frm.find("#searchKeyword").val())) return false;
		$("#searchKeyword").val(regExpCheckJuso($("#searchKeyword").val()));
		checkValidate3(frm.find("#searchKeyword").val());//인천 남구 -> 미추홀구 명칭변경 안내문구
		var vVal = regExpCheckJuso(frm.find("#searchKeyword").val());
		$("#searchKeyword").val(vVal);

		if(!rnSearchType(vVal)) return false;
		if(fnIsEmpty($.trim(vVal))||vVal.length < 2) {
			alert("두 자 이상 입력해 주세요.");
			return false;
		}
		//조회조건 확인
		if( fnIsEmpty($("#rn").val()) && fnIsEmpty($("#emdNm").val()) && fnIsEmpty($("#sggBdNm").val()) ) {
			alert("조회내용을 다시 확인하여 주세요.");
			return false;
		}
		$("#resultData").css("display","none");
		$("#resultList").css("display","block");
		return true;
	}
	function searchJuso(){
		if(fnValiJusoSearch()) {
			//page 옮기기 전에 조회 검증 또 해야 하는데...
			fnMoveGridPage("/juso/jusoListAjax/", "mainSearch", "#grid_wrap", 1);
		}
	}
	function popClose(){
		window.close();
	}
	function addrDetailChk(){
		var evtCode = (window.netscape) ? ev.which : event.keyCode;
		if(evtCode == 63 || evtCode == 35 || evtCode == 38 || evtCode == 43 || evtCode == 92 || evtCode == 34){ // # & + \ " 문자제한
			alert('특수문자 ? # & + \\ " 를 입력 할 수 없습니다.');
			if(event.preventDefault){
				event.preventDefault();
			}else{
				event.returnValue=false;
			}
		}
	}
	function addrDetailChk1(obj){
		if(obj.value.length > 0){
			var expText = "/^[^?#&+\"\\]+$/";
			if(!expText.test(obj.value)){
				alert('특수문자 ? # & + \\ " 를 입력 할 수 없습니다.');
				obj.value="";
			}
		}
	}
	function setParentJuso () {
		var chkVal = $("#rtAddrDetail").val();
		/*if(fnIsEmpty(chkVal)||chkVal.length < 3) {
			alert("주소를 올바르게 입력하여 주십시오.");
			return;
		}*/ /*상세주소 유효성 검사 제거*/
		var addr = $("#addrPart1").html();
		var returnValue = {};
		returnValue.addr = (addr + ' ' + chkVal);
		returnValue.zipCd = $("#zipCd").val();
		returnValue.paramTxtId = '${paramTxtId}';
		window.opener.jusoReturnValue (returnValue);
		popClose ();
	}
</script>
<title>주소 검색</title>
</head>
<body>
	<div class="pop-address-search" style="width: 100%;">
		<div class="pop-address-search-inner" style="border: 0px currentColor; border-image: none;">
			<div id="serarchContentBox" style="height: 440px;">
				<form name="mainSearch" id="mainSearch" method="post">
					<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
					<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
					<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">
					<input type="hidden" id="hidPageBlock" name="hidPageBlock" value="10">

					<input type="hidden" id="siNm" name="siNm"/>
					<input type="hidden" id="sggNm" name="sggNm"/>
					<input type="hidden" id="rn" name="rn"/>
					<input type="hidden" id="buldMnNm" name="buldMnNm"/>
					<input type="hidden" id="buldSlNo" name="buldSlNo"/>
					<input type="hidden" id="emdNm" name="emdNm"/>
					<input type="hidden" id="lnbrMnNm" name="lnbrMnNm"/>
					<input type="hidden" id="lnbrSlNo" name="lnbrSlNo"/>
					<input type="hidden" id="sggBdNm" name="sggBdNm" />
					<fieldset>
						<legend>도로명주소 검색</legend>
						<span class="wrap">
							<input name="searchKeyword" tabindex="1" title="검색어를 입력하세요" class="popSearchInput" id="searchKeyword" style="font-size: 13px; font-weight: bold; -ms-ime-mode: active;" type="text" placeholder="도로명주소, 건물명 또는 지번입력" value="" >
							<input tabindex="2" title="검색" style="cursor: pointer;" onclick="searchJuso();" type="button">
						</span>
						<a tabindex="3" title="창닫기" class="close" href="javascript:popClose();">닫기</a>
					</fieldset>
					<p class="guide" style="margin-top: 3px;">검색어 예 : 도로명(반포대로 58), 건물명(독립기념관), 지번(삼성동 25)</p>

					<!-- nodata -->
					<!-- <div class="popSearchNoResult" style="margin-top: 10px; margin-bottom: 5px;"></div> -->
					<!-- //nodata -->

					<!-- 검색결과 -->
					<div class="result" id="resultList" style="margin-top: 7px;">
						<div style="margin-top: 10px;">
							<div id="grid_wrap" class="gridResize" style="width: 100%; height: 340px;"></div>
							<!-- <div id="grid_wrap_paging" class="aui-grid-paging-panel my-grid-paging-panel" style="width: 100%; float: left;"></div> -->
							<div id="grid_wrap_paging" style="width:100%; height:40px;  margin-bottom: 0px;" class=""></div>
						</div>
					</div>
				</form>
				<!-- //검색결과 -->

				<!-- 상세주소 -->
				<div class="detail" id="resultData">
					<form id="fmtDetail" onsubmit="return false;">
						<p><strong>상세주소 입력</strong></p>
						<input type="hidden" id="zipCd" name="zipCd"/>
						<table class="data-row">
							<caption>주소 입력</caption>
							<colgroup>
								<col style="width: 20%;">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">도로명주소</th>
									<td id="addrPart1" style="height: 20px; line-height: 20px; font-size: 15px;"></td>
								</tr>
								<tr>
									<!-- //상세주소 입력 -->
									<th scope="row"><label for="inputPopAddress">상세주소입력</label></th>
									<td>
										<input name="rtAddrDetail" title="상세주소" id="rtAddrDetail" style="width: 100%; font-size: 13px;" onkeyup="addrDetailChk1(this);" onkeypress="addrDetailChk();" type="text">
										<div id="addrPart2" style="line-height: 2em; font-size: 13px; margin-top: 5px;"></div>
									</td>
								</tr>
							</tbody>
						</table>
						<div class="btns-submit">
							<a class="btn-bl" href="javascript:setParentJuso();" style="cursor: pointer;">주소입력</a>
						</div>
					</form>
				</div>
			</div>
			<!-- <div class="logo" style="display: block;">&nbsp;</div> -->
		</div>
	</div>
</body>
</html>