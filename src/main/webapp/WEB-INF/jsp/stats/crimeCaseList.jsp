<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>


<script type="text/javascript">
	var myGridID;

	$(function() {
		$(document).ready(function(){
			initGrid();
			fnDatePickerImg("searchPrsctDe1");
			fnDatePickerImg("searchPrsctDe2");

			<c:if test="${mngr_yn ne 'Y'}">
				fnSelectDept("", "${dept_cd}", "${dept_single_nm}")
				//$("#searchChager").val("${esntl_id}");//자신부서의 담당자 모두 검색 가능도록 수정 by dgkim 
				$("#searchDeptNm").attr("disabled",true);
				$("#btnDeptSearch").hide();
				//$("#searchChager").attr("disabled",false);//자신부서의 담당자 모두 검색 가능도록 수정 by dgkim 
			</c:if>
			fnSearch();
			
			AUIGrid.setCellMerge("#grid_list", true);
		});
	})
	
	function fnSearch() {
		fnMoveGridPage("/stats/crimeCaseListAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "CASE_NO", headerText : "사건번호", width : 100, cellMerge : true, editable : false,
				renderer : {type : "TemplateRenderer",
					aliasFunction : function(rowIndex, columnIndex, value, headerText, item) {//엑셀, PDF 등 내보내기 시 값 가공 함수 
						return fnChangeNo (value); 
					}
				},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			},
			{ dataField :      "PRSCT_DE", headerText :     "수리", width : 120, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO", dataType : "date", formatString : "yyyy-mm-dd", editable : false},
			{ dataField : "INV_PROVIS_NM", headerText :     "구분", width :  60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO", editable : false},
			{ dataField :    "CHARGER_NM", headerText : "수사담당자", width : 100, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO", editable : false},
			{ headerText : "피의자",
				children: [
					{ dataField :   "TRGTER_NM", headerText :    "성명", width : 100, editable : false },
					{ dataField :  "TRGTER_RRN"
						, headerText : "주민번호"
						, width : 150
						, editable : false
						, labelFunction : function( rowIndex, columnIndex, value, headerText, item ){
												var template = "";
												if(value != null && value != ""){ /* 2021-04-28 hsno 주민번호의 값이 null이거나 공백일 경우 */
													template += value;
												}else if(item.TRGTER_CPRN != null && item.TRGTER_CPRN != ""){ /* 2021-04-28 hsno 법인번호의 값이 null이거나 공백일 경우 */
													template += item.TRGTER_CPRN;
												}else if(value == null && item.TRGTER_CPRN == null){ /* 2021-04-28 hsno 주민번호와 법인번호 모두 값이 없을때 */
													template += "";
												}
												
												return template;
											}},
					{ dataField :	  "OCCP_NM", headerText :	"직업", width : 100, editable : false }/* , */
					/* { dataField : "DWLSIT_ADDR", headerText :   "주거", width : 150, editable : false } */ /* 2021-04-27 hsno 주거 Text 주석처리 */
				]
			},
			{ dataField : "TEMP1", headerText : "조회", width : 70 , editable : false },
			/* 
				2021.7.27
				범죄사건부 > 죄명이 2번 들어가 있음
				김지만 수사관 요청
			*/
			/* { headerText : "죄명(위반죄명)",
				children: [
					{ dataField :     "VIOLT_NM", headerText : "수리", width : 150 , editable : false, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO"},
					{ dataField : "TRN_VIOLT_NM", headerText : "송치", width : 150 , editable : false, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO"}
				]
			}, */
			{ dataField : "VIOLT_NM", headerText : "죄명(위반죄명)", width : 250 , editable : false },
			{ headerText : "범죄",
				children: [
					{ dataField : "OCCRRNC_BEGIN_DT", headerText : "(발생)일시", width : 120, editable : false, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO" },
					{ dataField :    "OCCRRNC_ADDR" , headerText : "(발생)장소", width : 150, editable : false, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO" }
				]
			},
			{ dataField :     "TEMP2", headerText : "피해정도", width : 80,  editable : false },
			{ dataField : "SUFRER_NM", headerText :  "피해자 등", width : 100, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO", editable : false },
			{ headerText : "체포/구속",
				children: [
					{ dataField : "TEMP22", headerText :    "체포영장", width : 100, editable : false },
					{ dataField : "TEMP23", headerText :    "긴급체포", width : 100, editable : false },
					{ dataField : "TEMP24", headerText : "현행범인체포", width : 100, editable : false },
					{ dataField : "TEMP25", headerText :	"구속영장", width : 100, editable : false },
					{ dataField : "ATTRACT_PLACE", headerText : "인치구금", width : 100, editable : false}
				]
			},
			{ dataField : "RSL_DT", headerText : "석방일시및사유", width : 150, editable : false},
			{ headerText : "송치",
				children: [
					{ dataField : "TRN_DE", headerText : "연월일", width : 100, dataType : "date", formatString : "yyyy-mm-dd", editable : false},
					{ dataField : "TRN_NO", headerText : "번호", width : 100, editable : false, 
						renderer : {type : "TemplateRenderer",
							aliasFunction : function(rowIndex, columnIndex, value, headerText, item) {//엑셀, PDF 등 내보내기 시 값 가공 함수 
								return fnChangeNo (value); 
							}
						},
						labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
							return fnChangeNo (value);
						},
					},
					{ dataField : "TRN_OPINION_NM", headerText : "의견", width : 100, editable : false}
				]
			},
			{ dataField : "CCDRC_NO", headerText :        "압수번호", width : 100, editable : false },
			{ dataField :    "TEMP3", headerText : "수사미결사건철번호", width : 100, editable : false },
			{ headerText : "검사처분",
				children: [
					{ dataField : "PRSEC_DSPS_DE", headerText : "연월일<span class='point'><img src='/img/icon_dot.png'/></span>", width : 100, dataType : "date", formatString : "yyyy-mm-dd", editable : true},
					{ dataField : "PRSEC_DSPS_OUTLINE", headerText : "요지<span class='point'><img src='/img/icon_dot.png'/></span>", width : 100 , editable : true}
				]
			},
			{ headerText : "판결",
				children: [
					{ dataField :      "JUDMN_DE", headerText : "연월일<span class='point'><img src='/img/icon_dot.png'/></span>", width : 100, dataType : "date", formatString : "yyyy-mm-dd", editable : true},
					{ dataField : "JUDMN_OUTLINE", headerText :  "요지<span class='point'><img src='/img/icon_dot.png'/></span>", width : 100 , editable : true}
				]
			},
			{ dataField : "RM", headerText : "비고<span class='point'><img src='/img/icon_dot.png'/></span>", width : 100, editable : true },
			{ headerText : "범죄원표",
				children: [
					{ dataField :  "OCCRRNC_ZERO_NO", headerText : "발생사건표", width : 100, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO", editable : false },
					{ dataField :  "ARREST_ZERO_NO", headerText : "검거사건표", width : 100, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO", editable : false },
					{ dataField : "SUSPCT_ZERO_NO", headerText :  "피의자표",  width : 100, editable : false }
				]
			}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			//fillColumnSizeMode : true,
			useGroupingPanel : false,
			showRowNumColumn : false,
			displayTreeOpen : true,
			editBeginMode : "click",
			editable : true,
			// 셀 병합 실행
			enableCellMerge : true,
			groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
				,cellMergePolicy : "withNull"
		};
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var items = event.item;
			fnCaseDetailPopup(items.RC_NO, "");
		});
		//AUIGrid.bind("#grid_list", "sorting", gridSort);
	}

	function fnSelectDept(upcd, cd, nm){
		$("#searchDeptCd").val(cd);
		$("#searchDeptNm").val(nm);

		fnUserList(cd, $("#searchChager"));
	}

	function fnCaseDetail() {
		var items = AUIGrid.getSelectedItems(myGridID);
		if(items.length <= 0) {
			alert("상세조회할 사건을 선택하세요.");
			return;
		}
		fnCaseDetailPopup(items[0].item.RC_NO, "");
	}

	function fnExportTo() {
		Ajax.getJson("<c:url value='/stats/addStatsOutptHist/'/>", {}, function(data){
			if(data == 1){
				location.href = "/file/excel/?menuCd=00040";
				/* 
				//FileSaver.js 로 로컬 다운로드가능 여부 확인
				if(!AUIGrid.isAvailableLocalDownload(myGridID)) {
					alert("로컬 다운로드 불가능한 브라우저 입니다. 서버 사이드로 전송하여 다운로드 처리하십시오.");
					return;
				}

				var rowCount = AUIGrid.getRowCount(myGridID);

				// 10만행 보다 크다면 CSV로 다운로드 처리
				if(rowCount >= 100000) {
					alert("10만건 이상일 경우  CSV로 데이터를 출력합니다.");
					AUIGrid.exportToCsv(myGridID, {
						fileName : "범죄사건부_CSV"
					});
				}else{
					AUIGrid.exportToXlsx(myGridID, {
						fileName : "범죄사건부_EXCEL"
					});
				}
				 */
			}else {
				alert("출력 이력을 저장하지 못했습니다. 잠시후 다시 시도하십시오.");
			}
		});
	};
	
	//피의자 검사처분 판결 내용 저장
	function fnSaveSuspct() {
		
		//var gData = AUIGrid.getGridData("#grid_list");
		
		var items = AUIGrid.getSelectedItems("#grid_list");
		//console.log(items[0].item.TRN_NO);
		if( fnIsEmpty( items[0].item.TRN_NO ) ){
			alert(items[0].item.TRGTER_NM + "의 송치상태를 선택하세요.");
			return;
		}
		/* if( gData.length > 0 ){
			for( var i in gData ){
				if( fnIsEmpty( gData[i].TRN_NO ) ){
					alert(gData[i].TRGTER_NM + "의 송치상태를 선택하세요.");
					return;
				}
			}
		} */

		var editedRowItems = AUIGrid.getEditedRowItems( "#grid_list" );
		if( editedRowItems.length == 0 ){
			alert("수정한 자료가 없습니다.");
			return;
		}

		var data = fnAjaxAction( "/stats/saveCrimeCaseSuspct/", JSON.stringify({ sList:editedRowItems }) );
		if( data.result == "1" ){
			alert("저장 되었습니다.");
			fnSearch();
		} else {
			alert("피의자 저장중 오류가 발생했습니다.");
		}
	}

</script>

<!--검색박스 -->
<form id="frmList" name="frmList" method="post">

<!-- 그리드 sort 관련 -->
<input type="hidden" id="sortingFields" name="sortingFields"/>
<input type="hidden" id="sortchk"       name="sortchk"/>

<input type="hidden" id="hidPage"     name="hidPage">
<input type="hidden" id="hidTotCnt"   name="hidTotCnt"   value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">
<div class="search_box mb_30">
	<div class="search_in">
		<div class="stitle w_100px">부서/담당자</div>
		<div class="r_box">
			<!--찾기 -->
			<div class="flex_r mb_5 w_120px mr_5">
				<input type="hidden" id="searchDeptCd" name="searchDeptCd">
				<input type="text"   id="searchDeptNm" name="searchDeptNm" maxlength="50" size="50" value="" class="w_100p input_com" placeholder="부서" readonly>
				<input type="button" id="btnDeptSearch" value="" class="btn_search" onclick="fnDeptSelect();">
			</div>
			<select class="w_150px" id="searchChager" name="searchChager">
				<option value="">==선택하세요==</option>
			</select>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_80px">대상자명</div>
		<div class="r_box w_120px">
			<input type="text" name="searchTrgterNm" maxlength="50" size="50" value="" class="w_180px input_com" placeholder="대상자">
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_100px">입건일자</div>
		<div class="r_box">
			<div class="input_out w_120px fl">
				<input type="text" class="w_100p input_com_ca" id="searchPrsctDe1" name="searchPrsctDe1" readonly style="line-height: 40px;">
			</div>
			<div class="input_out fl"> ~ </div>
			<div class="input_out w_120px fl">
				<input type="text" class="w_100p input_com_ca" id="searchPrsctDe2" name="searchPrsctDe2" readonly>
			</div>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_100px">조회건수</div>
		<div class="r_box">
			<select name="hidPageBlock" id="hidPageBlock" class="w_100px">
				<option value="" <c:if test="${hidPageBlock eq ''}">selected</c:if>>==전체==</option>
				<option value="10" <c:if test="${hidPageBlock eq '10'}">selected</c:if>>10</option>
				<option value="20" <c:if test="${hidPageBlock eq '20'}">selected</c:if>>20</option>
				<option value="50" <c:if test="${hidPageBlock eq '50'}">selected</c:if>>50</option>
				<option value="100" <c:if test="${hidPageBlock eq '100'}">selected</c:if>>100</option>
				<option value="200" <c:if test="${hidPageBlock eq '200'}">selected</c:if>>200</option>
				<option value="500" <c:if test="${hidPageBlock eq '500'}">selected</c:if>>500</option>
			</select>
		</div>
	</div>
	<div class="go_search2" onclick="fnSearch();">검색</div>
</div>
</form>
<!--//검색박스 -->

<!--------- 내용--------->
<div class="com_box ">
	<!-- 안내박스  -->
	<div class="title_s_st3 w_50p">
	</div>
	<!-- 안내박스  -->
	<!--버튼 -->
	<div class="right_btn fr mb_10">
		<a href="javascript:fnSaveSuspct();" class="btn_st2 icon_n fl mr_m1">저장</a>
		<a href="javascript:fnExportTo();"   class="btn_st2 icon_n fl mr_m1">엑셀출력</a>
		<a href="javascript:fnCaseDetail();" class="btn_st2_2 icon_n fl mr_m1">사건상세보기</a>
	</div>
</div>
<!--//버튼  -->
<!--테이블 시작 -->
<div class="tb_01_box">
	<div id="grid_list" class="gridResize" style="width:100%; height:570px; margin:0 auto;"></div>
	<div id="grid_list_paging" style="width:100%; height:40px;"></div>
</div>
