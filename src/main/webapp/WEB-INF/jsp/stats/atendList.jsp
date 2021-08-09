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
		fnMoveGridPage("/invsts/atendListAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [
			{dataField : "grdTrgterSn", visible: false},
			{ dataField : "grdRn", 		headerText : "순번", width : 50, editable : false },
			{ dataField : "grdViewSn", 	headerText : "출석요구번호", width : 120, editable : false,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			},
			{ dataField : "grdAtendDemandDt", headerText : "출석요구일시<span class='point'><img src='/img/icon_dot.png'/></span>", editable : true  },
			{ dataField : "grdTrgterSeNm", headerText : "출석자구분", width : 120, editable : false },
			{ dataField : "grdTrgterNm", headerText : "출석자성명", width : 120, editable : false },
			{ dataField : "grdCaseNo", headerText : "사건번호", width : 130, editable : false },
			{ dataField : "grdAtendNticeDe", headerText : "출석요구통지일", width : 140, dataType : "date", formatString : "yyyy-mm-dd", editable : false },
			{ dataField : "grdAtendNticeNm", headerText : "출석요구통지방법", editable : false },
			{ dataField : "grdAtendYn", headerText : "결과<span class='point'><img src='/img/icon_dot.png'/></span>", editable : true,
				labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) { 
					var retStr = "";
					/* for(var i=0, len = resultList.length; i < len; i++) {
						if(resultList[i]["ATEND_YN"] == value) {
							retStr = resultList[i]["ATEND_RST"];
							break;
						}
					} */
					resultList.forEach(function(i){
						if(value == undefined){
							retStr = "";
						} else if(i.ATEND_YN == value){
							retStr = i.ATEND_RST;
							return;
						}
					});
					
					return retStr;// == "" ? value : retStr;
				},
				editRenderer : {// 편집 모드 진입 시 드랍다운리스트 출력하고자 할 때
					type : "DropDownListRenderer",
					showEditorBtn: true,
					showEditorBtnOver: true,
					list : resultList,
					keyField: "ATEND_YN",
					valueField: "ATEND_RST"
				} 
			},
			{ dataField : "grdChargerNm", headerText : "담당자", editable : false }
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			//noDataMessage:"조회 목록이 없습니다.",
			fillColumnSizeMode : true,
			showRowNumColumn : false,
			editBeginMode : "click",
			editable : true,
		};
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var items = event.item;
			fnCaseDetailPopup(items.grdRcNo, "");
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
		fnCaseDetailPopup(items[0].item.grdRcNo, "");
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
				fileName : "출석요구통지부_CSV"
			});
		}else{
			AUIGrid.exportToXlsx(myGridID, {
				fileName : "출석요구통지부_EXCEL"
			});
		}
	};

	/*
		2021.08.02
		coded by dgkim
		출석요구통지부 > 출석요구시간 및 결과 수정 기능 추가
		김지만 수사관 요청
	*/
	var resultList = [
		{"ATEND_YN": "", "ATEND_RST": "선택안함"},
		{"ATEND_YN": "Y", "ATEND_RST": "출석"},
		{"ATEND_YN": "N", "ATEND_RST": "미출석"}
	];
	
	function fnSaveAtend(){
		var editedRowItems = AUIGrid.getEditedRowItems( "#grid_list" );
		if( editedRowItems.length == 0 ){
			alert("수정한 자료가 없습니다.");
			return;
		}
		
		/* 날짜 형식 체크 */
		//날짜시간 정규식(ex: 2020.07.28.12:00)
		//참고 : https://junghn.tistory.com/entry/JavaScript-%EC%9E%90%EB%B0%94%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8%EB%A1%9C-%EB%82%A0%EC%A7%9C-%EC%8B%9C%EA%B0%84-%EC%9C%A0%ED%9A%A8%EC%84%B1-%EC%B2%B4%ED%81%AC-%EB%82%A0%EC%A7%9C-%EC%8B%9C%EA%B0%84-%EC%A0%95%EA%B7%9C%EC%8B%9D-%ED%91%9C%ED%98%84-%EB%B0%A9%EB%B2%95
		var regex = RegExp(/^(19|20)\d{2}.(0[1-9]|1[012]).(0[1-9]|[12][0-9]|3[0-1]).([1-9]|[01][0-9]|2[0-3]):([0-5][0-9])$/);
		var check = true;
		
		editedRowItems.forEach(function(item){
			if( !regex.test(item.grdAtendDemandDt) ){
				alert("날짜 형식이 맞지 않습니다.");
				check = false;
				return;
			}
		});
		
		if( !check ) return;
			
		var data = fnAjaxAction( "/invsts/updateAtendAjax/", JSON.stringify({ sList:editedRowItems }) );
		if( data.result == "1" ){
			alert("저장 되었습니다.");
			fnSearch();
		} else {
			alert("저장중 오류가 발생했습니다.");
		}
	}
</script>

<!--검색박스 -->
<form id="frmList" name="frmList" method="post">

<!-- 그리드 sort 관련 -->
<input type="hidden" id="sortingFields" name="sortingFields"/>
<input type="hidden" id="sortchk" name="sortchk"/>

<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">
<input type="hidden" id="hidZrlongSeCd" name="hidZrlongSeCd" value="">  <!-- 체포영장 00774 구속영장 -->
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
		<div class="stitle w_80px">출석자명</div>
		<div class="r_box w_120px">
			<input type="text" name="searchTrgterNm" maxlength="50" size="50" value="" class="w_180px input_com" placeholder="대상자">
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_100px">통지일자</div>
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
		<a href="javascript:fnSaveAtend();" class="btn_st2 icon_n fl mr_m1">저장</a>
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
