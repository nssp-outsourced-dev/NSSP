<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<style type="text/css">
.tbLft {
	text-align: left;
}
</style>
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
		fnMoveGridPage("/invsts/arrstListAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		/*
			2021.08.02
			coded by dgkim
			양식 변경으로 인한 서식 변경
			원안위도 아래 정확한 내용을 모르기 때문에 화면만 재구성
			정확한 데이터 작업은 추후 진행
			김지만 수사관 요청
		*/
		var columnLayout = [
			{ dataField : "grdRcNo", visible : false},
			{ dataField : "grdRn", 		headerText : "순번", width : 50},
			{ dataField : "grdArrstSn", headerText : "집행번호", width : 80},
			{ dataField : "grdCaseNo", 	headerText : "사건번호", width : 120,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			},
			{ headerText : "피의자",
				children: [
					{ dataField : "grdTrgterNm", headerText : "성명", width : 100},
					{ dataField : "grdTrgterRrn", headerText : "주민등록번호", width : 150},
					{ dataField : "grdOccpNm", headerText : "직업"},
				]
			},
			{ dataField : "grdVioltRootNm", headerText : "죄명", style:'tbLft' },
			{ dataField : "grdWritngDt", headerText : "긴급체포서작성연월일", width : 150},
			{ headerText : "긴급체포",
				children: [
					{ dataField : "grdArrstDt", headerText : "체포일시", width : 120},
					{ dataField : "grdArrstPlace", headerText : "체포장소", width : 120, style:'tbLft'},
					{ dataField : "grdArrester", headerText : "체포자의 집급 및 성명", width : 150},
					{ dataField : "grdAttractDt", headerText : "인치일시", width : 120},
					{ dataField : "grdAttractPlace", headerText : "인치장소", style:'tbLft' },
					{ dataField : "grdCnfnmDt", headerText : "구금일시", width : 120},
					{ dataField : "grdCnfnmPlace", headerText : "구금장소", style:'tbLft' },
					{ headerText : "검사지휘",
						children: [
							{ dataField : "grdSugestResultY", headerText : "승인",  	width : 60,
								renderer : {
									type : "CheckBoxEditRenderer",
									checkValue : 'Y',
									unCheckValue : 'N'
								}
							},
							{ dataField : "grdSugestResultN", headerText : "불승인", 	width : 60,
								renderer : {
									type : "CheckBoxEditRenderer",
									checkValue : 'Y',
									unCheckValue : 'N'
								}
							},
						]
					}
				]
			},
			{ headerText : "석방",
				children: [
					{ dataField : "grdRslDt", headerText : "일시", width : 120},
					{ dataField : "grdRslResn", headerText : "사유", style:'tbLft' }
				]
			},
			{ headerText : "구속영장신청",
				children: [
					{ dataField : "", headerText : "신청부번호" },
					{ dataField : "", headerText : "발부연월일", dataType : "date", formatString : "yyyy-mm-dd"}
				]
			},
			{ dataField : "", headerText : "비고"},
		];
		/* var columnLayout = [
		{ dataField : "grdRn", 		headerText : "순번", width : 50},
		{ dataField : "grdArrstSn", headerText : "진행번호", width : 80},
		{ dataField : "grdCaseNo", 	headerText : "사건번호", width : 120,
			renderer : {type : "TemplateRenderer"},
			labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
				return fnChangeNo (value);
			}
		},
		{ headerText : "피의자",
			children: [
				{ dataField : "grdTrgterNm", headerText : "성명", width : 100},
				{ dataField : "grdTrgterRrn", headerText : "주민등록번호", width : 150},
				{ dataField : "grdOccpNm", headerText : "직업"},
				//{ dataField : "grdDwlsitAddr", headerText : "주거", style:'tbLft' }, //2021-04-27 hsno 주거 Text 주석처리
			]
		},
		{ dataField : "grdVioltRootNm", headerText : "죄명", style:'tbLft' },
		{ dataField : "grdWritngDt", headerText : "긴급체포서작성<br/>연월일", width : 120},
		{ headerText : "긴급체포",
			children: [
				{ dataField : "grdArrstDt", headerText : "체포일시", width : 120},
				{ dataField : "grdArrstPlace", headerText : "체포장소", width : 120, style:'tbLft'},
				{ dataField : "grdArrester", headerText : "체포자의 관직<br/>및 성명", width : 120},
				{ dataField : "grdAttractDt", headerText : "인치일시", width : 120},
				{ dataField : "grdAttractPlace", headerText : "인치장소", style:'tbLft' },
				{ dataField : "grdCnfnmDt", headerText : "구금일시", width : 120},
				{ dataField : "grdCnfnmPlace", headerText : "구금장소", style:'tbLft' },
				{ headerText : "검사지휘",
					children: [
						{ dataField : "grdSugestResultY", headerText : "승인",  	width : 60,
							renderer : {
								type : "CheckBoxEditRenderer",
								checkValue : 'Y',
								unCheckValue : 'N'
							}
						},
						{ dataField : "grdSugestResultN", headerText : "불승인", 	width : 60,
							renderer : {
								type : "CheckBoxEditRenderer",
								checkValue : 'Y',
								unCheckValue : 'N'
							}
						},
					]
				}
			]
		},
		{ headerText : "석방",
			children: [
				{ dataField : "grdRslDt", headerText : "일시", width : 120},
				{ dataField : "grdRslResn", headerText : "사유", style:'tbLft' }
			]
		},
		{ headerText : "구속영장신청",
			children: [
				{ dataField : "grdZrlongReqstYn", headerText : "신청여부" }
			]
		}
	]; */

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			//noDataMessage:"조회 목록이 없습니다.",
			//fillColumnSizeMode : true,
			showRowNumColumn : false
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
				fileName : "긴급체포원부_CSV"
			});
		}else{
			AUIGrid.exportToXlsx(myGridID, {
				fileName : "긴급체포원부_EXCEL"
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
<input type="hidden" id="hidArrstTyCd" name="hidArrstTyCd" value="00732">  <!-- 긴급체포 00733 현행범인체포 -->
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
		<div class="stitle w_100px">작성일자</div>
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
