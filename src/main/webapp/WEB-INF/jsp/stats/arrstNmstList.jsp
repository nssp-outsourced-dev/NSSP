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
		fnMoveGridPage("/invsts/arrstNmstListAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "RC_NO", visible : false},
			{ dataField : "RN", 		headerText : "순번", width : 50, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO"},
			{ dataField : "CASE_NO", 		headerText : "제 호", width : 100, 
				renderer : {type : "TemplateRenderer",
					aliasFunction : function(rowIndex, columnIndex, value, headerText, item) {//엑셀, PDF 등 내보내기 시 값 가공 함수 
						return fnChangeNo (value); 
					}
				},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					return fnChangeNo (value);
				}
			},
			{ headerText : "체포 구속",
				children: [
					{ headerText : "취급자",
						children: [
							{ dataField : "TRTMNT_CHFCLRK", headerText : "계장",  	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "CheckBoxEditRenderer",
									checkValue : 'Y',
									unCheckValue : 'N'
								}
							},
							{ dataField : "TRTMNT_DRHF", headerText : "과장",  	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "CheckBoxEditRenderer",
									checkValue : 'Y',
									unCheckValue : 'N'
								}
							},
							{ dataField : "TRTMNT_ISTDR", headerText : "기관장",  	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "CheckBoxEditRenderer",
									checkValue : 'Y',
									unCheckValue : 'N'
								}
							},
							/* { dataField : "TRTMNT_CHFCLRK", headerText : "계장",  	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "ImageRenderer",// 이미지렌더러로 체크박스 모양 만들기
									imgHeight : 20,
									imgTableRef: {
										"Y": "/AUIGrid/images/blue-check.png",
										"N": null,
										"default": null,
									}
								}
							}
							{ dataField : "TRTMNT_DRHF", headerText : "과장", 	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "ImageRenderer",// 이미지렌더러로 체크박스 모양 만들기
									imgHeight : 20,
									imgTableRef: {
										"Y": "/AUIGrid/images/blue-check.png",
										"N": "/AUIGrid/images/accept-not.png",
										"default": null,
									}
								}
							},
							{ dataField : "TRTMNT_ISTDR", headerText : "기관장", 	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "ImageRenderer",// 이미지렌더러로 체크박스 모양 만들기
									imgHeight : 20,
									imgTableRef: {
										"Y": "/AUIGrid/images/blue-check.png",
										"N": null,
										"default": null,
									}
								}
							}, */
						]
					},
					{ dataField : "ARRST_DT", headerText : "연월일 및 유형", width : 120, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO", },
				]
			},
			{ headerText : "석방",
				children: [
					{ headerText : "취급자", 
						children: [
							{ dataField : "TRTMNT2_CHFCLRK", headerText : "계장",  	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "CheckBoxEditRenderer",
									checkValue : 'Y',
									unCheckValue : 'N'
								}
							},
							{ dataField : "TRTMNT2_DRHF", headerText : "과장",  	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "CheckBoxEditRenderer",
									checkValue : 'Y',
									unCheckValue : 'N'
								}
							},
							{ dataField : "TRTMNT2_ISTDR", headerText : "기관장",  	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "CheckBoxEditRenderer",
									checkValue : 'Y',
									unCheckValue : 'N'
								}
							},
							/* { dataField : "TRTMNT2_CHFCLRK", headerText : "계장",  	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "ImageRenderer",// 이미지렌더러로 체크박스 모양 만들기
									imgHeight : 20,
									imgTableRef: {
										"Y": "/AUIGrid/images/blue-check.png",
										"N": null,
									}
								}
							},
							{ dataField : "TRTMNT2_DRHF", headerText : "과장", 	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "ImageRenderer",// 이미지렌더러로 체크박스 모양 만들기
									imgHeight : 20,
									imgTableRef: {
										"Y": "/AUIGrid/images/blue-check.png",
										"N": null,
									}
								}
							},
							{ dataField : "TRTMNT2_ISTDR", headerText : "기관장", 	width : 60, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",
								renderer : {
									type : "ImageRenderer",// 이미지렌더러로 체크박스 모양 만들기
									imgHeight : 20,
									imgTableRef: {
										"Y": "/AUIGrid/images/blue-check.png",
										"N": null,
									}
								}
							}, */
						]
					},
					{ dataField : "RSL_DT", headerText : "연월일시", width : 120, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO", },
					{ dataField : "RSL_RESN_ETC", headerText : "사유", width : 120, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO", },
				]
			},
			{ dataField : "VIOLT_NM", 		headerText : "죄명 및 형명 형기", width : 200, cellMerge : true, mergePolicy:"restrict", mergeRef: "CASE_NO",},
			{ headerText : "인상",
				children: [
					{ dataField : "HEIGHT", headerText : "키", width : 120 },
					{ dataField : "BODY", headerText : "몸집", width : 120 },
					{ dataField : "WIG", headerText : "머리털", width : 120 },
					{ dataField : "EYEBrOW", headerText : "눈섭", width : 120 },
					{ dataField : "MUSTACHE", headerText : "수염", width : 120 },
					{ dataField : "BROW", headerText : "이마", width : 120 },
					{ dataField : "EAR", headerText : "귀", width : 120 },
					{ dataField : "EYE", headerText : "눈", width : 120 },
					{ dataField : "MOUTH", headerText : "입", width : 120 },
					{ dataField : "TEETH", headerText : "이", width : 120 },
					{ dataField : "NOSE", headerText : "코", width : 120 },
					{ dataField : "ASPECT", headerText : "용모", width : 120 },
					{ dataField : "FACE", headerText : "얼굴", width : 120 },
					{ dataField : "FACE_COLOR", headerText : "얼굴색", width : 120 },
					{ dataField : "ETC", headerText : "기타특징", width : 120 },
				]
			},
			{ dataField : "CLOTHING", 		headerText : "착의", width : 50},
			{ headerText : "체포구속된 사람의 인적사항",
				children: [
					{ dataField : "TRGTER_NM", headerText : "성명", width : 120 },
					{ dataField : "TRGTER_RRN", headerText : "주민등록번호", width : 120 },
					{ dataField : "REGBS_ADDR", headerText : "등록기준지", width : 120 },
				]
			},
			{ dataField : "PRE_CONVICTION", 		headerText : "전과, 죄명, 범수", width : 150},
			{ dataField : "COMPLC", 		headerText : "공범 관계자 성명", width : 150},
			{ dataField : "FAMILY_RELATIONS", 		headerText : "가족관계", width : 150},
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			//noDataMessage:"조회 목록이 없습니다.",
			//fillColumnSizeMode : true,
			showRowNumColumn : false,
			enableCellMerge : true,
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
				fileName : "체포구속인명부_CSV"
			});
		}else{
			AUIGrid.exportToXlsx(myGridID, {
				fileName : "체포구속인명부_EXCEL"
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
<input type="hidden" id="hidZrlongSeCd" name="hidZrlongSeCd" value="00774">  <!-- 00773 체포영장 00774 구속영장 -->
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
		<div class="stitle w_100px">체포일자</div>
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
