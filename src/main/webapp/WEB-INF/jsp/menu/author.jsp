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

			var iUrl = '<c:url value='/menu/authorAddAjax/'/>';
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					fnSearch();
					fnClear();
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.setAjaxForm(iUrl, "addForm", processAfterGet);
		});

	})


	function fnSearch() {
		fnSearchGridData("/menu/authorListAjax/", "#grid_list", "");
	}

	function fnSearchMenu(cd) {
		fnSearchGridData("/menu/authorMenuListAjax/", "#grid_menu_list", "hidAuthorCd="+cd);
	}


	function initGrid() {
		var columnLayout = [
			{ dataField : "AUTHOR_CD", headerText : "권한코드", width : 100, visible : false},
			{ dataField : "AUTHOR_NM", headerText : "권한명", width : 120},
			{ dataField : "AUTHOR_DC", headerText : "권한설명", width : 100},
			{ dataField : "SORT_ORDR", headerText : "순서", width : 100, visible : false},
			{ dataField : "USE_YN", headerText : "사용여부", width : 80}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true,
			useGroupingPanel : false,
			showRowNumColumn : false
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);

		AUIGrid.bind("#grid_list", "cellClick", function(event) {
			var items = event.item;
			$('#hidAuthorCd').val(items.AUTHOR_CD);
			$('#txtAuthorNm').val(items.AUTHOR_NM);
			$('#txtAuthorDc').val(items.AUTHOR_DC);
			$('#selSort').val(items.SORT_ORDR);
			$('#selUseYn').val(items.USE_YN);

			fnSearchMenu(items.AUTHOR_CD);

 			$('#btnClear').show();
 			$('#btnAdd').hide();
 			$('#btnUpdate').show();
		});

		fnSearchGridData("/menu/authorListAjax/", "#grid_list", "");

		//sub grid
		var columnLayout2 = [
			{
				dataField : "MENU_S_YN",
				headerText : "",
				width: 120,
				headerRenderer : {
					type : "CheckBoxHeaderRenderer",
					dependentMode : true,
					position : "bottom" // 기본값 "bottom"
				},
				renderer : {
					type : "CheckBoxEditRenderer",
					showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
					editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
					checkValue : "Y", // true, false 인 경우가 기본
					unCheckValue : "N"
				}
			},
			{ dataField : "MENU_CD", headerText : "메뉴코드", width : 100, visible : false},
			{ dataField : "MENU_CL_NM", headerText : "메뉴분류", width : 150},
			{ dataField : "MENU_NM", headerText : "메뉴명", width : 300}
		];

		var gridPros2 = {
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true,
			useGroupingPanel : false,
			showRowNumColumn : false,
			rowIdField : "MENU_CD",
			showEditedCellMarker : false,
			//groupingFields : ["MENU_CL_NM"],
			enableCellMerge : true
		};

		AUIGrid.create("#grid_menu_list", columnLayout2, gridPros2);

		fnSearchGridData("/menu/authorMenuListAjax/", "#grid_menu_list", "hidAuthorCd=");
	}

	function fnClear(){
		$('#hidAuthorCd').val("");
		$('#txtAuthorNm').val("");
		$('#txtAuthorDc').val("");
		$('#selUseYn').val("Y");
		$('#selSort').val("1");

		$('#btnClear').hide();
		$('#btnAdd').show();
		$('#btnUpdate').hide();
		fnSearchMenu("");
	}

	function fnAdd(){
		var menuItems = AUIGrid.getItemsByValue("#grid_menu_list", "MENU_S_YN", "Y");
		if(menuItems.length < 1){
			alert("한개이상의 메뉴를 선택해야 합니다.");
			return;
		}

		if(fnFormValueCheck("addForm")){
			if(confirm("저장하시겠습니까?")){
				var ids = [];
				for(var i=0, len=menuItems.length; i<len; i++) {
					ids.push( menuItems[i].MENU_CD ); // 아이디만 따로 보관해서 alert 출력
				}
				var str = ids.join("^");
				$('#hidMenuList').val(str);
		        $("#addForm").submit();
            }
		}
	}

	function fnAuthorClear(){
		if(confirm("권한을 적용하시겠습니까?")){
			var iUrl = '<c:url value='/menu/authorClearAjax/'/>';
	 		var queryString = "";
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					location.reload();
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

</script>

<div class="box_w2 mb_50 mt_10">
	<div class="box_w2_1">
		<div class="box_w2_top">
			<div class="title_s_st2 fl"><img src="/img/title_icon1.png" alt=""/>전체권한</div>
		</div>
		<div class="tb_01_box">
			<div id="grid_list" class="gridResize" style="width:100%; height:650px; margin:0 auto;"></div>
		</div>
	</div>

	<div class="box_w2_2">
		<form id="addForm" name="addForm" method="post" action="<c:url value='/menu/addAjax/'/>">
		<input type="hidden" id="hidAuthorCd" name="hidAuthorCd">
		<input type="hidden" id="hidMenuList" name="hidMenuList">
		<div class="box_w2_top_r">
			<div class="right_btn fr mb_8">
				<a href="javascript:void(0);" id="btnMenuCl" onClick="fnAuthorClear();" class="btn_st2_2 icon_n fl mr_5">권한적용</a>
				<a href="javascript:void(0);" id="btnClear" onClick="fnClear();" class="btn_st2 icon_n fl mr_m1">신규</a>
				<a href="javascript:void(0);" id="btnAdd" onClick="fnAdd();" class="btn_st2 icon_n fl mr_m1">추가</a>
				<a href="javascript:void(0);" id="btnUpdate" onClick="fnAdd();" class="btn_st2 icon_n fl mr_m1">수정</a>
			</div>
		</div>
		<div class="com_box mb_20">
			<div class="tb_01_box">
				<table  class="tb_01">
				<col width="200px"/>
				<col width=""/>
				<col width="200px"/>
				<col width=""/>
				<tbody>

				<tr>
					<th>권한명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td><input type="text" id="txtAuthorNm" name="txtAuthorNm" maxlength="100" class="w_100p input_com" check="text" checkName="권한명"></td>
					<th>권한설명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td><input type="text" id="txtAuthorDc" name="txtAuthorDc" maxlength="100" class="w_100p input_com" check="text" checkName="권한설명"></td>
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
		</div>
		</form>
		<div class="com_box mb_10 ">
			<div class="title_s_st2 w_50p fl"><img src="/img/title_icon1.png" alt=""/>권한에 할당 메뉴</div>
			<div class="title_s_st3"><img src="/img/icon_error.png" alt=""/>해당 권한에서 사용할 메뉴도 선택해 주십시오.</div>
		</div>

		<div class="com_box mb_30">
			<div class="tb_01_box">
				<div id="grid_menu_list" class="gridResize" style="width:100%; height:465px; margin:0 auto;"></div>
			</div>
		</div>
	</div>
</div>
