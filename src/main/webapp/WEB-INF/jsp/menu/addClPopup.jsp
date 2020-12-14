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
		parent.menuClPopup.hide();
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "MENU_CL_CD", headerText : "코드", width : 0},
			{ dataField : "MENU_CL_NM", headerText : "분류명", width : 230},
			{ dataField : "SORT_ORDR", headerText : "순서", width : 80},
			{ dataField : "USE_YN", headerText : "사용여부", width : 80}
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
			$("input:hidden[id=hidMenuClCd]").val(items.MENU_CL_CD);
			$("input:text[id=txtMenuClNm]").val(items.MENU_CL_NM);
			$("select[id=selUseYn]").val(items.USE_YN);
			$("select[id=selSort]").val(items.SORT_ORDR);

			$("#btnAdd").hide();
			$("#btnUpdate").show();
		});		
		
		fnSearchGrid("/menu/addClListAjax/", "addForm", "#grid_list");
	}

	function fnSearch() {
		fnSearchGrid("/menu/addClListAjax/", "addForm", "#grid_list");
	}

	function fnClear(){
		$("input:hidden[id=hidMenuClCd]").val("");
		$("input:text[id=txtMenuClNm]").val("");
		$("select[id=selUseYn]").val("Y");
		$("select[id=selSort]").val("1");

		$("#btnAdd").show();
		$("#btnUpdate").hide();
	}

	function fnAdd(){
		if(fnFormValueCheck("addForm")){
			if(confirm("저장하시겠습니까?")){ 
				var iUrl = '<c:url value='/menu/addClAjax/'/>';
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

</script>

<body>

<!--팝업박스 -->
<form id="addForm" name="addForm" method="post">
<input type="hidden" id="hidMenuClCd" name="hidMenuClCd" value="">
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
				<th>분류명<span class="point"><img src="/img/point.png"  alt=""/></span> </th>
				<td colspan="3">
					<input type="text" id="txtMenuClNm" name="txtMenuClNm" maxlength="100" class="w_250px input_com" check="text" checkName="분류명">
					<input type="hidden" id="hidMenuClCd" name="hidMenuClCd" value="">
				</td>
			</tr>
			<tr>
				<th>사용여부<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<select id="selUseYn" name="selUseYn">
						<option value="Y" selected>사용</option>
						<option value="N">미사용</option>
					</select>
				</td>
				<th>출력순서<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<select id="selSort" name="selSort">
						<c:forEach var="idx" begin="1" end="50" >
							<option value="${idx}" <c:if test="${idx eq 1}">selected</c:if>>${idx}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			</tbody>
		</table>
		</div> 
	</div> 
	<div class="com_box  t_right">
		<div class="btn_box">
			<input type="button" id="btnAdd" name="input_button" value="추가"  class="btn_st4 icon_n fl mr_m1" onclick="fnAdd();">
			<input type="button" id="btnUpdate" name="input_button" value="수정 "  class="btn_st4 icon_n fl mr_m1" onclick="fnAdd();">
			<input type="button" id="btnReset" name="input_button" value="초기화 "  class="btn_st3 icon_n fl mr_m1" onclick="fnClear();">
		</div>
	</div>
	<!--//버튼  -->	
	<!--테이블 시작 -->
	<div class="com_box mb_30">  
		<div class="tb_01_box">
			<div id="grid_list" style="width:100%; height:250px; margin:0 auto;"></div>
		</div>
	</div> 
</div>
</form>
 <!--팝업박스 -->	

</body>
</html>