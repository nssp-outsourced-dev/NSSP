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
		});

	})

	function fnSearch() {
		fnMoveGridPage("/stats/itivCaseListAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "RN", headerText : "순번", width : 50},
			{ dataField : "ITIV_NO", headerText : "내사번호", width : 100,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			},
			/*
				2021.05.24
				by dgkim
				접수번호는 수사업무 시스템에 필요없으므로 안보이게 처리
				시스템상에서는 필요한 데이터 임으로 데이터는 유지하되 화면 에 보이지 안도록 처리
			*/
			/* { dataField : "RC_NO", headerText : "접수번호", width : 100,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			}, */
			/*
				2021.07.12
				by dgkim
				내사사건의 접수일시는 착수일시이기 때문에 접수일시를 착수일시로 사용
			*/
			{ dataField : "ITIV_DT", headerText : "접수일시", width : 100},//{ dataField : "RC_DT", headerText : "접수일시", width : 100},
			{ headerText : "내사 대상자",
				children: [
					{ dataField : "TRGTER_NM", headerText : "성명", width : 100},
					{ dataField : "TRGTER_RRN", headerText : "주민번호", width : 150},
					{ dataField : "DWLSIT_ADDR", headerText : "주소", width : 200, visible : false}, /* 2021-05-06 hsno 주거지가 출력되던 주소 테이블을 안보이도록 처리 */
					{ dataField : "ADRES_ADDR", headerText : "주소", width : 200} /* 2021-05-06 hsno 주소지가 출력되는 주소 테이즐 추가 */
					]
			},
			{ dataField : "OUTSET_RESN", headerText : "내사할 사항(지휘사항 포함)", width : 200},
			/*
				2021.07.12
				by dgkim
				내사사건부 양식 개편으로 인한 사용하지 않음
				내사사건의 접수일시는 착수일시이기 때문에 접수일시를 착수일시로 사용
			*/
			//{ dataField : "ITIV_DT", headerText : "착수일시", width : 100},
			/*
				2021.05.10
				by dgkim
				내사사건부, 처리일시 입건된 사건일 경우 입건일자, 
				미입건사건일 경우 공란으로 수정
			*/
			{ dataField : "ITIV_RESULT_REPORT_DT", headerText : "처리일시", width : 100,},
			{ dataField : "ITIV_RESULT_NM", headerText : "처리결과", width : 200,
				
				/* 2021-04-28 권종열 사무관 요청 hsno 처리결과 테이블에 내사종결시 괄호안에 종결 처분 코드가 나오도록 수정 */
				labelFunction : function( rowIndex, columnIndex, value, headerText, item ){
									var template = "";
									
									if(value != null && value != "" && value != undefined && item.ITIV_RESULT_CD == "00383"){ /* 처리결과가 null, 공백, undefined가 아니고 종결 처분 코드가 내사종결일때 */
										template += value.concat("(", item.ED_DSPS_NM, ")");
									}else if(item.ITIV_RESULT_NM != null && item.ITIV_RESULT_NM != "" && item.ITIV_RESULT_NM != undefined){ /* 처리결과가 null, 공백, undefined일때 */
										template += item.ITIV_RESULT_NM;
									}
									
									return template;
								}},
			{ dataField : "CHARGER_NM", headerText : "담당자", width : 100},
			{ dataField : "CMND_PRSEC_NM", headerText : "지휘자", width : 100},
			{ dataField : "TEMP4", headerText : "비고", width : 100}
		];


		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true,
			useGroupingPanel : false,
			showRowNumColumn : false,
			displayTreeOpen : true,
			groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
		};
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var items = event.item;
			fnCaseDetailPopup(items.RC_NO, "");
		});
		AUIGrid.bind("#grid_list", "sorting", gridSort);
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
				fileName : "내사사건부_CSV"
			});
		}else{
			AUIGrid.exportToXlsx(myGridID, {
				fileName : "내사사건부_EXCEL"
			});
		}
	};

</script>

<!--검색박스 -->
<form id="frmList" name="frmList" method="post">

<!-- 그리드 sort 관련 -->
<input type="hidden" id="sortingFields" name="sortingFields"/>
<input type="hidden" id="sortchk" name="sortchk"/>

<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">
<div class="search_box mb_30">
	<div class="search_in">
		<div class="stitle w_100px">부서/담당자</div>
		<div class="r_box">
			<!--찾기 -->
			<div class="flex_r mb_5 w_120px mr_5">
				<input type="hidden" id="searchDeptCd" name="searchDeptCd">
				<input type="text" id="searchDeptNm" name="searchDeptNm" maxlength="50" size="50" value="" class="w_100p input_com" placeholder="부서" readonly>
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
		<div class="stitle w_100px">착수일자</div>
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
		<a href="javascript:fnExportTo();" class="btn_st2 icon_n fl mr_m1">엑셀출력</a>
		<a href="javascript:fnCaseDetail();" class="btn_st2_2 icon_n fl mr_m1">사건상세보기</a>
	</div>
</div>
<!--//버튼  -->
<!--테이블 시작 -->
<div class="tb_01_box">
	<div id="grid_list" class="gridResize" style="width:100%; height:570px; margin:0 auto;"></div>
	<div id="grid_list_paging" style="width:100%; height:40px;"></div>
</div>
