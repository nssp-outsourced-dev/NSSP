<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">

var myGridID;
	
	$(document).ready(function(){
		initGrid();
		fnClear();
	});

	function fnClose(){
		parent.relateAddPopup.hide();
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "RELATE_SN", headerText : "RELATE_SN", width : 0},
			{ dataField : "RELATE_URL", headerText : "URL", width : 250},
			{ dataField : "RELATE_NM", headerText : "화면명", width : 130}
		];

		var gridPros = {	
			headerHeight : 30,
			rowHeight: 30,	
			fillColumnSizeMode : true,	
			showRowNumColumn : false
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);

		AUIGrid.bind("#grid_list", "cellClick", function(event) {
			var items = event.item;
			$("input:hidden[id=hidRelateSn]").val(items.RELATE_SN);
			$("input:text[id=txtRelateNm]").val(items.RELATE_NM);
			$("input:text[id=txtRelateUrl]").val(items.RELATE_URL);

			$("#btnAdd").hide();
			$("#btnUpdate").show();
			$("#btnDel").show();
		});		
		
		fnSearchGrid("/menu/addRelateListAjax/", "addForm", "#grid_list");
	}

	function fnSearch() {
		fnSearchGrid("/menu/addRelateListAjax/", "addForm", "#grid_list");
	}


	function fnClear(){
		$("input:hidden[id=hidRelateSn]").val("");
		$("input:text[id=txtRelateNm]").val("");
		$("input:text[id=txtRelateUrl]").val("");

		$("#btnAdd").show();
		$("#btnUpdate").hide();
		$("#btnDel").hide();
	}

	function fnAdd(){
		if(fnFormValueCheck("addForm")){
			if(confirm("저장하시겠습니까?")){ 
				var iUrl = '<c:url value='/menu/addRelateAjax/'/>';
		 		var queryString =  $('#addForm').serialize();
		 		var processAfterGet = function(data) {
		 			if(data.result == "1"){
		 				fnSearch();
		 				fnClear(); 
		 			}else if(data.result == "-2"){
		 				alert("동일한 URL이 다른 관련화면에 등록되어 있습니다.");
		 			}else if(data.result == "-3"){
		 				alert("자료를 찾을 수 없습니다.");
		 			}else{
		 				alert("진행중 오류가 발생하였습니다.");
		 			}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
            }
		}
	}


	function fnDelete() {
		var form = $("form[id=addForm]");	
		if(confirm("삭제하시겠습니까?")){
			var iUrl = '<c:url value='/menu/deleteRelateAjax/'/>';
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
	
</script>

<body>

<!--팝업박스 -->
<form id="addForm" name="addForm" method="post">
<input type="hidden" id="hidMenuCd" name="hidMenuCd" value="${hidMenuCd}">
<input type="hidden" id="hidRelateSn" name="hidRelateSn" value="">
<div class="popup_body">
	<!--버튼 -->
	<div class="com_box mb_30">
		<div class="tb_01_box">
		<table  class="tb_03">
			<col width="100px"/>
			<col width=""/>
			<col width="100px"/>
			<col width=""/>
			<tbody>
			<tr>
				<th>메뉴분류</th>
				<td>${detail.MENU_CL_NM}</td>
				<th>메뉴명</th>
				<td>${detail.MENU_NM}</td>
			</tr>
			<tr>
				<th>URL<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td colspan="3">
					<input type="text" id="txtRelateUrl" name="txtRelateUrl" maxlength="100" class="w_250px input_com" check="text" checkName="URL">
				</td>
			</tr>
			<tr>
				<th>화면명</th>
				<td colspan="3">
					<input type="text" id="txtRelateNm" name="txtRelateNm" maxlength="100" class="w_250px input_com">
				</td>
			</tr>

			</tbody>
		</table>
		</div> 
	</div> 
	<div class="com_box  t_right">
		<div class="btn_box">
			<input type="button" id="btnReset" name="input_button" value="초기화 "  class="btn_st3 icon_n fl mr_m1" onclick="fnClear();">
			<input type="button" id="btnAdd" name="input_button" value="추가"  class="btn_st4 icon_n fl mr_m1" onclick="fnAdd();">
			<input type="button" id="btnUpdate" name="input_button" value="수정 "  class="btn_st4 icon_n fl mr_m1" onclick="fnAdd();">
			<input type="button" id="btnDel" name="input_button" value="삭제"  class="btn_st4 icon_n fl mr_m1" onclick="fnDelete();">
		</div>
	</div>
	<!--//버튼  -->	
	<!--테이블 시작 -->
	<div class="com_box mb_30">  
		<div class="tb_01_box">
			<div id="grid_list" style="width:100%; height:230px; margin:0 auto;"></div>
		</div>
	</div> 
</div>
</form>
 <!--팝업박스 -->	

</body>
</html>