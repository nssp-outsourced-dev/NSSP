<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<style>
input[type=radio] {
  visibility: visible; float: none;
}
</style>

<script type="text/javascript">

var myGridID;
	
	$(document).ready(function(){
		if("${result}" == "-3"){
			alert("진행중인 접수사건을 조회할 수 없습니다.");
			fnClose();
		}else if("${result}" == "-4"){
			alert("진행중인 정식사건을 조회할 수 없습니다.");
			fnClose();			
		}

		initGrid();
		
	});

	function fnClose(){
		parent.alotSelectPopup.hide();
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "ESNTL_ID", headerText : "ESNTL_ID", width : 0},
			{ dataField : "USER_ID", headerText : "아이디", width : 0},
			{ dataField : "DEPT_NM", headerText : "소속", width : 220},
			{ dataField : "USER_NM", headerText : "성명", width : 90},
			{ dataField : "RSPOFC_NM", headerText : "직책", width : 90},
			{ dataField : "CLSF_NM", headerText : "직급", width : 0},
			{ dataField : "ALOT_CNT", headerText : "배당건수(진행중)", width : 130}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,	
			fillColumnSizeMode : true,	
			showRowNumColumn : false,
			showRowCheckColumn : true,
			rowCheckToRadio : true,
			selectionMode : "singleRow",
			showEditedCellMarker : false
		};

		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind("#grid_list", "cellClick", function(event) {
			var items = event.item;
			AUIGrid.setCheckedRowsByValue("#grid_list", "ESNTL_ID", items.ESNTL_ID);
		});			

		fnSearchGrid("/alot/userListAjax/", "frmList", "#grid_list");
	}
	
	function fnSearch() {
		fnSearchGrid("/alot/userListAjax/", "frmList", "#grid_list");
	}

	
	function fnSelectDept(upcd, cd, nm){
		$('#txtDeptNm').val(nm);
		$('#hidDeptCd').val(cd);
		fnSearch();
	}
	
	function fnSelect() {
		var chkItems = AUIGrid.getCheckedRowItems(myGridID);
		if(chkItems.length <= 0 ) {
			alert("배당자를 선택하세요.");
			return;
		}
		var str1 = "";
		var str2 = "";
		var str3 = "";
		var ids1 = [];
		var ids2 = [];
		var ids3 = []; 
		for(var i=0; i<chkItems.length; i++) {
			ids1.push( chkItems[i].item.ESNTL_ID );
			ids2.push( chkItems[i].item.DEPT_NM );
			ids3.push( chkItems[i].item.USER_NM );
		}
		str1 = ids1.join(":");	
		str2 = ids2.join(":");	
		str3 = ids3.join(":");	
		$('#hidUserId').val(str1);
		$('#hidUserNm').val(str2);
		$('#hidDeptNm').val(str3);

		<c:choose>
			<c:when test="${ret eq 'N'}">
				if(confirm("배당을 진행하시겠습니까?")){
					var iUrl = '<c:url value='/alot/alotAjax/'/>';
			 		var queryString =  $('#frmList').serialize();
			 		var processAfterGet = function(data) {
						if(data.result == "1"){
							fnClose();
						}else{
							alert("배당진행중 오류가 발생하였습니다.");
						}
				    };
					Ajax.getJson(iUrl, queryString, processAfterGet);
				}
			</c:when>
			<c:when test="${ret eq 'Y'}">
				fnClose();
			</c:when>
			<c:otherwise>
			</c:otherwise>
		</c:choose>
	}

	function fnClear(){
		$('#hidUserId').val("");
		$('#txtDeptNm').val("");
		$('#hidDeptCd').val("");
		fnSearch();
	}
</script>

<body>

<!--팝업박스 -->
<form id="frmList" name="frmList" method="post">
<input type="hidden" id="snNo" name="snNo" value="${snNo}">
<input type="hidden" id="gbn" name="gbn" value="${gbn}">
<input type="hidden" id="hidUserId" name="hidUserId" value="">
<input type="hidden" id="hidUserNm" name="hidUserNm" value="">
<input type="hidden" id="hidDeptNm" name="hidDeptNm" value="">
<input type="hidden" id="chkAlotSeCd" name="chkAlotSeCd" value="A">
<div class="popup_body">
	<c:if test="${alotInfo != null}">
	<div class="com_box mb_10">
		<div class="tb_01_box">
			<table  class="tb_01">
				<col width="20%"/>
				<col width="40%"/>
				<col width="20%"/>
				<col width="20%"/>
				<tbody>
					<tr>
						<th>진행상태</th>
						<td colspan="3">
						<c:choose>
							<c:when test="${alotInfo.ALOT_SE_CD eq 'A'}">담당자배당완료</c:when>
							<c:when test="${alotInfo.ALOT_SE_CD eq 'B'}">부서배당완료</c:when>
							<c:otherwise>미배당</c:otherwise>
						</c:choose>
						</td>
					</tr>
					<tr>
						<th>담당부서</th>
						<td>${alotInfo.ALOT_DEPT_NM}</td>
						<th>담당자</th>
						<td>
						<c:choose>
							<c:when test="${alotInfo.ALOT_SE_CD eq 'A'}">${alotInfo.ALOT_USER_NM}</c:when>
							<c:otherwise>없음</c:otherwise>
						</c:choose>
						</td>
					</tr>
			</tbody>
			</table>
		</div>
	</div>
	</c:if>

	<div class="com_box mb_10">
		<div class="tb_01_box">
			<table  class="tb_01">
				<col width="20%"/>
				<col width=""/>
				<tr>
					<th>소속</th>
					<td>
						<div class="flex_r">
							<input type="text" id="txtDeptNm" name="txtDeptNm" class="w_250px input_com" check="text" checkName="부서" readonly onfocus="fnDeptSelect();this.blur();" value="${alotInfo.ALOT_DEPT_SINGLE_NM}">	
							<input type="hidden" id="hidDeptCd" name="hidDeptCd" value="${alotInfo.ALOT_DEPT_CD}">
							<input type="button" class="btn_search mr_10" onclick="fnDeptSelect();">
							<%-- <input type="button" value="조직조회" class="btn_text" onclick="fnDeptSelect();"> --%>
						</div>
					</td>
				</tr>
			</tbody>
			</table>
		</div>
	</div>
	<div id="divCharger" class="com_box mb_10">  
		<div class="tb_01_box">
			<div id="grid_list" style="width:100%; height:350px; margin:0 auto;"></div>
		</div>
	</div> 
	<div class="com_box  t_center mt_10">
		<div class="btn_box">
			<input type="button" name="input_button" value="배당완료 " class="btn_st4 icon_n fl mr_m1" onclick="fnSelect();">
		</div>
	</div>
</div>
</form>
 <!--팝업박스 -->	

</body>
</html>
