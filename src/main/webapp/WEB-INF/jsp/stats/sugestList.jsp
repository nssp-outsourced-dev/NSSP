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
		fnMoveGridPage("/invsts/sugestListAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "grdRn", 				headerText : "순번", 			width : 50, editable : false },		
			{ dataField : "grdSugestNo", 		headerText : "지휘번호(접수번호)", 	width : 150,editable : false,
				renderer : {type : "TemplateRenderer",
					aliasFunction : function(rowIndex, columnIndex, value, headerText, item) {//엑셀, PDF 등 내보내기 시 값 가공 함수 
						return fnChangeNo (value); 
					}
				},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			},
			{ dataField : "grdSugestDe", 		headerText : "지휘요구일자", 	width : 130, dataType : "date", formatString : "yyyy-mm-dd", editable : false },
			{ dataField : "grdTrgterNmS", 		headerText : "피의자"	, editable : false },
			{ dataField : "grdVioltRootNm", 	headerText : "죄명"	 , editable : false },
			{ dataField : "grdPresenter", 		headerText : "제출자<span class='point'><img src='/img/icon_dot.png'/></span>", width : 130, editable : true },
			{ dataField : "grdCmndPrsecNm", 	headerText : "지휘검사", 			width : 130, editable : false },
			{ dataField : "grdCmptncExmnNm", 	headerText : "지휘관서", editable : false },
			{ dataField : "grdCmndDe", 			headerText : "지휘일자", 	width : 130, dataType : "date", formatString : "yyyy-mm-dd", editable : false },
			{ dataField : "grdSugestResultNm", 	headerText : "건의결과",  	width : 100, editable : false },
			{ dataField : "grdCaseNo", 			headerText : "사건번호",  	width : 130, editable : false,
				renderer : {type : "TemplateRenderer",
					aliasFunction : function(rowIndex, columnIndex, value, headerText, item) {//엑셀, PDF 등 내보내기 시 값 가공 함수 
						return fnChangeNo (value); 
					}
				},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			},
			{ dataField : "", 		headerText : "수령자", width : 130, editable : false }  
		];
		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			//noDataMessage:"조회 목록이 없습니다.",
			fillColumnSizeMode : true,
			showRowNumColumn : false,
			editBeginMode : "click",
			editable : true
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
				fileName : "지휘건의부_CSV"
			});
		}else{
			AUIGrid.exportToXlsx(myGridID, {
				fileName : "지휘건의부_EXCEL"
			});
		}
	};
	
	/**/
	function fnSaveSugestStats(){
		var editedRowItems = AUIGrid.getEditedRowItems( "#grid_list" );
		if( editedRowItems.length == 0 ){
			alert("수정한 자료가 없습니다.");
			return;
		}
		//console.log(editedRowItems);
		var data = fnAjaxAction( "/invsts/updateSugestStatsAjax/", JSON.stringify({ sList:editedRowItems }) );
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
		<a href="javascript:fnSaveSugestStats();" class="btn_st2 icon_n fl mr_m1">저장</a>
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
