<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<script type="text/javascript">
	$(function() {
		$(document).ready(function(){
			initGrid();
			$('#btnClear').hide();
			$('#btnAdd').show();
			$('#btnUpdate').hide();

			var iUrl = '<c:url value='/doc/addAjax/'/>';
	 		var processAfterGet = function(data) {
				fnSearch();
				fnClear();
		    };
			Ajax.setAjaxForm(iUrl, "addForm", processAfterGet);
			$("#searchFormatNm").keyup(function(event) {
				if(event.keyCode == 13) {
					fnSearch();
				}
			});

		});

	})


	function fnSearch() {
		fnMoveGridPage("/doc/listAjax/", "frmList", "#grid_list", 1);
	}


	function initGrid() {
		var columnLayout = [
			{ dataField : "RN", headerText : "순번", width : 50},
			{ dataField : "FORMAT_ID", headerText : "FORMAT_ID", width : 150, visible : true},
			{ dataField : "FORMAT_CL_NM", headerText : "서식분류", width : 130},
			{ dataField : "FORMAT_NM", headerText : "서식명", width : 200},
			{ dataField : "FORMAT_DC", headerText : "서식설명", width : 100, visible : true},
			{ dataField : "USE_YN", headerText : "사용여부", width : 60},
			{ dataField : "INPUT_YN", headerText : "입력여부", width : 60},
			{ dataField : "WRITNG_NM", headerText : "작성자", width : 80},
			{ dataField : "WRITNG_DT", headerText : "작성일시", width : 130}
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
		AUIGrid.create("#grid_list", columnLayout, gridPros);

		AUIGrid.bind("#grid_list", "cellClick", function(event) {
			var items = event.item;
			fnSelect(items.FORMAT_ID);
		});

		fnMoveGridPage("/doc/listAjax/", "frmList", "#grid_list", 1);
	}

	function fnSelect(sCd){
		var iUrl = '<c:url value='/doc/detailAjax/'/>';
 		var queryString =  "hidFormatId=" + sCd;
 		var processAfterGet = function(data) {
			$('#hidFormatId').val(data.FORMAT_ID);
			$('#selFormatClCd').val(data.FORMAT_CL_CD);
			$('#txtFormatNm').val(data.FORMAT_NM);
			$('#txtFormatDc').val(data.FORMAT_DC);

			$('#selUseYn').val(data.USE_YN);
			$('#selInputYn').val(data.INPUT_YN);

 			$('#btnClear').show();
 			$('#btnAdd').hide();
 			$('#btnUpdate').show();
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnClear(){
		$('#hidFormatId').val("");
		$('#selFormatClCd').val("");
		$('#txtFormatNm').val("");
		$('#txtFormatDc').val("");
		$('#selUseYn').val("Y");
		$('#selInputYn').val("Y");

		$('#btnClear').hide();
		$('#btnAdd').show();
		$('#btnUpdate').hide();
	}

	function fnAdd(){
		if(fnFormValueCheck("addForm")){
			if(confirm("저장하시겠습니까?")){
		        $("#addForm").submit();
            }
		}
	}
</script>


<form id="frmList" name="frmList" method="post">
<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">
<!--검색박스 -->
<div class="search_box mb_30">

	<div class="inbox08">
		<div class="stitle">서식분류</div>
		<div class="tl_box">
			<select id="searchFormatClCd" name="searchFormatClCd" class="w_250px input_com">
				<option value="">==선택하세요==</option>
				<c:forEach var="cd" items="${formatClList}">
					<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div class="inbox08">
		<div class="stitle">서식명</div>
		<div class="tl_box">
			<input type="text" id="searchFormatNm" name="searchFormatNm" maxlength="20" class="w_200px input_com_s ">
    		<input type="text" style="display:none;"/>
		</div>
	</div>
	<div class="inbox08">
		<div class="stitle">조회건수</div>
		<div class="tl_box">
			<select name="hidPageBlock" id="hidPageBlock" class="w_100px fl">
				<option value="5" <c:if test="${hidPageBlock eq '5'}">selected</c:if>>5</option>
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

<div class="com_box mb_10">
	<div class="tb_01_box">
		<div id="grid_list" class="gridResize" style="width:100%; height:380px; margin:0 auto;"></div>
		<div id="grid_list_paging" style="width:100%; height:40px;"></div>
	</div>
</div>



<form id="addForm" name="addForm" method="post" enctype="multipart/form-data" action="<c:url value='/doc/addAjax/'/>">
<!--본문시작 -->
<!--버튼 -->
<div class="com_box  t_right">
	<div class="btn_box">
	<a href="javascript:void(0);" id="btnClear" onClick="fnClear();" class="btn_st2 icon_n fl mr_m1">신규</a>
	<a href="javascript:void(0);" id="btnAdd" onClick="fnAdd();" class="btn_st2 icon_n fl mr_m1">추가</a>
	<a href="javascript:void(0);" id="btnUpdate" onClick="fnAdd();" class="btn_st2 icon_n fl mr_m1">수정</a>
	</div>
</div>

<!--//버튼  -->
<!--테이블 시작 -->
<div class="com_box mb_30">
	<div class="tb_01_box">
		<table  class="tb_01">
		<col width="200px"/>
		<col width=""/>
		<col width="200px"/>
		<col width=""/>
		<tbody>

		<tr>
			<th>서식 분류<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td colspan="3" align="left">
				<input type="hidden" id="hidFormatId" name="hidFormatId">
				<select id="selFormatClCd" name="selFormatClCd" class="w_250px input_com" check="text" checkName="서식 분류">
					<option value="">==선택하세요==</option>
					<c:forEach var="cd" items="${formatClList}">
						<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th>서식 명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td><input type="text" id=txtFormatNm name="txtFormatNm" maxlength="50" class="w_100p input_com" check="text" checkName="서식 명"></td>
			<th>서식 설명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td><input type="text" id="txtFormatDc" name="txtFormatDc" maxlength="200" class="w_100p input_com" check="text" checkName="서식 설명"></td>
		</tr>
		<tr>
			<th>사용여부<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<select id="selUseYn" name="selUseYn" class="w_80px input_com">
					<option value="Y">사용</option>
					<option value="N">미사용</option>
				</select>
			</td>
			<th>입력폼여부<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<select id="selInputYn" name="selInputYn" class="w_80px input_com">
					<option value="Y">사용</option>
					<option value="N">미사용</option>
				</select>
			</td>
		</tr>
	</tbody>
	</table>
</div>
</form>
