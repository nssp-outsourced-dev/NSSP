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

		});

	})


	function fnSearch() {
		fnMoveGridPage("/menu/listAjax/", "frmList", "#grid_list", 1);
	}


	function initGrid() {
		var columnLayout = [
			{ dataField : "MENU_CD", headerText : "메뉴코드"},
			{ dataField : "MENU_CL_NM", headerText : "메뉴분류"},
			{ dataField : "CL_SORT_ORDR", headerText : "순서"},
			{ dataField : "MENU_NM", headerText : "메뉴명"},
			{ dataField : "SORT_ORDR", headerText : "순서"},
			{ dataField : "MENU_URL", headerText : "경로"},
			{ dataField : "USE_YN", headerText : "사용여부"},
			{
				dataField : "MENU_CD",
				headerText : "관련화면",
				width : 85,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var template = "";
					template += "<a href=\"javascript:void(0);\" onClick=\"fnRelateAdd('"+value+"');\" class=\"btn_td1 icon_n fl \">관련화면</a>";
					return template;
				}
			}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			useGroupingPanel : false,
			showRowNumColumn : false,
			displayTreeOpen : true,
			groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);

		AUIGrid.bind("#grid_list", "cellClick", function(event) {
			var items = event.item;
			fnSelect(items.MENU_CD);
		});

		fnMoveGridPage("/menu/listAjax/", "frmList", "#grid_list", 1);
	}

	function fnSelect(sCd){
		var iUrl = '<c:url value='/menu/detailAjax/'/>';
 		var queryString =  "hidMenuCd=" + sCd;
 		var processAfterGet = function(data) {
			$('#hidMenuCd').val(data.MENU_CD);
			$('#selMenuClCd').val(data.MENU_CL_CD);
			$('#txtMenuNm').val(data.MENU_NM);
			$('#txtMenuUrl').val(data.MENU_URL);

			$('#selUseYn').val(data.USE_YN);
			$('#selSort').val(data.SORT_ORDR);

 			$('#btnClear').show();
 			$('#btnAdd').hide();
 			$('#btnUpdate').show();
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnClear(){
		$('#hidMenuCd').val("");
		$('#selMenuClCd').val("");
		$('#txtMenuNm').val("");
		$('#txtMenuUrl').val("");
		$('#selUseYn').val("Y");
		$('#selSort').val("1");

		$('#btnClear').hide();
		$('#btnAdd').show();
		$('#btnUpdate').hide();
	}

	function fnAdd(){
		if(fnFormValueCheck("addForm")){
			if(confirm("저장하시겠습니까?")){
				var iUrl = '<c:url value='/menu/addAjax/'/>';
		 		var queryString =  $('#addForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						fnSearch();
						fnClear();
					}else{
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
            }
		}
	}


	function fnMenuClAdd(){
		menuClPopup = dhtmlmodal.open('menuClManage', 'iframe', '/menu/addClPopup/', '메뉴분류 관리', 'width=700px,height=500px,center=1,resize=0,scrolling=1')
		menuClPopup.onclose = function(){
			fnSearch();
			return true;
		}
	}

	function fnRelateAdd(menu_cd){
		relateAddPopup = dhtmlmodal.open('relateAdd', 'iframe', '<c:url value='/menu/addRelatePopup/'/>?hidMenuCd='+menu_cd, '관련화면 등록', 'width=700px,height=500px,center=1,resize=0,scrolling=1')
		relateAddPopup.onclose = function(){
			return true;
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
		<div class="stitle">분류</div>
		<div class="tl_box">
			<select id="searchMenuClCd" name="searchMenuClCd" class="w_150px fl">
			<option value="">==선택하세요==</option>
				<c:forEach var="cd" items="${menuClList}">
					<option value="${cd.MENU_CL_CD}"><c:out value="${cd.MENU_CL_NM}" /></option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div class="inbox08">
		<div class="stitle">메뉴명</div>
		<div class="tl_box">
			<input type="text" id="searchMenuNm" name="searchMenuNm" maxlength="50" class="w_200px input_com_s ">
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

<div class="com_box ">
	<div class="tb_01_box">
		<div id="grid_list" class="gridResize" style="width:100%; height:350px; margin:0 auto;"></div>
		<div id="grid_list_paging" style="width:100%; height:40px;"></div>
	</div>
</div>



<form id="addForm" name="addForm" method="post" action="<c:url value='/menu/addAjax/'/>">
<input type="hidden" id="hidMenuCd" name="hidMenuCd">
<!--본문시작 -->
<!--버튼 -->
<div class="com_box  t_right">
	<div class="btn_box fl">
		<a href="javascript:void(0);" id="btnMenuCl" onClick="fnMenuClAdd();" class="btn_st2_2 icon_n fl mr_5">분류등록</a>
	</div>
	<div class="right_btn fr mb_10">
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
			<th>메뉴분류<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td colspan="3">
				<select id="selMenuClCd" name="selMenuClCd" class="w_150px input_com" check="text" checkName="메뉴분류">
					<option value="">==선택하세요==</option>
					<c:forEach var="cd" items="${menuClList}">
						<option value="${cd.MENU_CL_CD}"><c:out value="${cd.MENU_CL_NM}" /></option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th>메뉴명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td><input type="text" id="txtMenuNm" name="txtMenuNm" maxlength="100" class="w_100p input_com" check="text" checkName="메뉴명"></td>
			<th>메뉴경로<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td><input type="text" id="txtMenuUrl" name="txtMenuUrl" maxlength="100" class="w_100p input_com" check="text" checkName="메뉴경로"></td>
		</tr>
		<tr>
			<th>사용여부<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<select id="selUseYn" name="selUseYn" class="w_80px input_com">
					<option value="Y">사용</option>
					<option value="N">미사용</option>
				</select>
			</td>
			<th>출력순서<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<select id="selSort" name="selSort" class="w_80px input_com">
					<c:forEach var="idx" begin="1" end="50" >
						<option value="${idx}" <c:if test="${idx eq result.SORT_ORDR}">selected</c:if>>${idx}</option>
					</c:forEach>
				</select>
			</td>
		</tr>
	</tbody>
	</table>
</div>
</form>