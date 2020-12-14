<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<script type="text/javascript">
	$(function() {
		$("#searchDeptUpCd").change(function(){
			fnUpDeptList($(this).val(), $("#searchDeptCd"));
		});
	
		$(document).ready(function(){
			initGrid();
			<c:if test="${searchDeptUpCd > 0}">
				$("#searchDeptUpCd").val("${searchDeptUpCd}");
				$("#searchDeptUpCd").change();
				$("#searchDeptCd").val("${searchDeptCd}");
			</c:if>
		});
		
		$("#btnDeptSearch").click(function (){
			
			alert("부서찾기 팝업 호출...");
		});
	})

	function fnSearch() {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/member/list/'/>"});
		form.submit();
	}
	
	function fnDetail(esntl_id) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidEsntlID]").val(esntl_id);
		form.attr({"method":"post","action":"<c:url value='/rc/caseRcView/'/>"});
		form.submit();
	}
	
	function fnLinkPage(page){
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidPage]").val(page);
		form.attr({"method":"post","action":"<c:url value='/member/list/'/>"});
		form.submit();
	}
	
	function initGrid() {
		
		var columnLayout = [
			  { dataField : "RN"			 , headerText : "순번"	  , width : 40}
			, { dataField : ""		 		 , headerText : "지연"	  , width : 40}
			, { dataField : ""		 , headerText : "경과"	  , width : 40}
			, { dataField : "WRITNG_DT"		 , headerText : "담당"	  , width : 40}
			, { dataField : "WRITNG_DT"		 , headerText : "구분"	  , width : 40}
			, { dataField : "RC_NO"			 , headerText : "접수번호", width : 80}
			, { dataField : "ITIV_NO"		 , headerText : "내사번호", width : 80}
			, { dataField : "CASE_NO"		 , headerText : "사건번호", width : 80}
			, { dataField : "INV_PROVIS_CD"	 , headerText : "수사단서", width : 80}
			, { dataField : "WRITNG_DT"		 , headerText : "위반사항", width : 80}
			, { dataField : "WRITNG_DT"		 , headerText : "피의자"  , width : 80}
			, { dataField : "WRITNG_DT"		 , headerText : "피해자"  , width : 80}
			, { dataField : "PROGRS_STTUS_CD", headerText : "진행상태", width : 80}
			, { dataField : "WRITNG_DT"		 , headerText : "지휘메모", width : 80}
		];

		var gridPros = {
			useGroupingPanel : true,		
			showRowNumColumn : false,			
			displayTreeOpen : true,			
			groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);

		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
			var items = event.item;
			fnDetail(items.FORMAT_ID);
		});
		

		fnMoveGridPage("/rc/getCaseListAjax/", "frmList", "#grid_list", 1);		
	}
</script>

<div class="table_area">
	<form id="frmList" name="frmList" action="<c:url value='/member/update/'/>">

		<!-- 그리드 paging 관련 -->
		<input type="hidden" id="hidPage"		name="hidPage" 		value="${hidPage}">
		<input type="hidden" id="hidTotCnt" 	name="hidTotCnt" 	value="0">
		<input type="hidden" id="hidPageArea" 	name="hidPageArea" 	value="10">
		<!-- 그리드 관련 -->
		<input type="hidden" id="hidFormatId" 	name="hidFormatId">	

		<p class="sub_head"><span class="txt_subject">검색조건</span>
			<p class="btn_area">
				<input type="button" value="조회" class="btn" onclick="fnSearch();"/>
			</p>
		</p>

		<table width="1000px" class="board" summary="" cellpadding="0" cellspacing="0" >
			<caption>게시판 템플릿 목록</caption>
			<colgroup>
			<col width="100px">
			<col width="px">
			<col width="100px">
			<col width="px">
			</colgroup>
			<tr class="border_bottom_b">
				<th>부서</th>
				<td>
					<input type="text" id="searchUserNm" name="searchUserNm" maxlength="50" style="width:70px;" value="${searchUserNm}">
					<input type="button" id="btnDeptSearch" style="width: 40px" value="찾기">
				</td>
				
				<th>검색기준</th>
				<td>
					접수번호	<input type="radio"	name="radioSearchRcNo">
					접수일자	<input type="radio"	name="radioSearchRcNo">
				</td>
			</tr>
	
			<tr class="border_bottom_b">
				<th>담당자</th>
				<td align="left">
					<select id="searchDeptUpCd" name="searchDeptUpCd" style="width:150px;" <c:if test="${author_cd ne author_mngr_cd && author_cd ne author_mngr_sub}">disabled</c:if>>
						<option value="">==선택하세요==</option>
						<c:forEach var="cd" items="${cdList}">
							<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>	
						</c:forEach>
					</select>
				</td>
				<th>접수번호</th>
				<td>
					<input type="text" id="searchUserNm" name="searchUserNm" maxlength="50" style="width:200px;" value="${searchUserNm}">
				</td>
			</tr>
			<tr class="border_bottom_b">
				<th>대상자명</th>
				<td align="left">
					<input type="text" id="searchUserID" name="searchUserID" maxlength="100" style="width:200px;" value="${searchUserID}">
				</td>
				<th>접수일자</th>
				<td>
					<input type="text" id="searchUserNm" name="searchUserNm" maxlength="50" style="width:200px;" value="${searchUserNm}">
				</td>
			</tr>
			
			<tr class="border_bottom_b">
				<th>진행상태</th>
				<td >
					전체	<input type="radio"	name="progressSttus">
					미처리	<input type="radio"	name="progressSttus">
					처리	<input type="radio"	name="progressSttus">
					반려	<input type="radio"	name="progressSttus">
				</td>
				<th>페이지건수</th>
				<td><!-- 그리드 paging 관련 -->
					<select name="hidPageBlock" id="hidPageBlock">
						<option value="10" <c:if test="${hidPageBlock eq '10'}">selected</c:if>>10</option>
						<option value="20" <c:if test="${hidPageBlock eq '20'}">selected</c:if>>20</option>
						<option value="50" <c:if test="${hidPageBlock eq '50'}">selected</c:if>>50</option>
						<option value="100" <c:if test="${hidPageBlock eq '100'}">selected</c:if>>100</option>
						<option value="200" <c:if test="${hidPageBlock eq '200'}">selected</c:if>>200</option>
						<option value="500" <c:if test="${hidPageBlock eq '500'}">selected</c:if>>500</option>
					</select>
				</td>
			</tr>
		</table>
	
		<p class="sub_head"><span class="txt_subject">검색결과</span>
			<p class="btn_area"></p>
		</p>
	
	</form>
	
	<div style="float:left;">
		<div id="grid_list" style="width:1000px; height:450px; margin:0 auto;"></div>
		<div id="grid_list_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
	</div>
</div>
