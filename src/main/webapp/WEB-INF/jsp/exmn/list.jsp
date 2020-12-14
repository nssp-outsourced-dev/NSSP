<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<link href="/jq/fileacc/css/file.css" rel="stylesheet" type="text/css">
<script src="/jq/fileacc/js/jquery-explr-1.4.js"></script>
<script type="text/javascript">

	var myGridID;

	$(document).ready(function(){
		$('#btnClear').hide();
		$('#btnAdd').hide();
		$('#btnUpdate').hide();

		initGrid();
		fnDrawTree();
		fnSelectRoot();
	});

	function fnClear(){
		$('#hidExmnCd').val("");
		$('#txtExmnNm').val("");
		$('#txtCmptncDc').val("");

		$('#hidExmnCdDp').val("");

		$('#selSort').val("0");
		$('#selUseYn').val("Y");

		$('#btnClear').hide();
		$('#btnAdd').show();
		$('#btnUpdate').hide();
	}

	function fnDrawTree(){
		var iUrl = '<c:url value='/exmn/exmnFullListAjax/'/>';
 		var queryString =  "";
 		var processAfterGet = function(data) {

			var sHtml = "";
			var sNode = "";
			var preDp = 0;
			for(var i = 0; i < data.length; i++){
				sRow = data[i];
				sNode = "<a href=\"javascript:fnSearch('"+ sRow.EXMN_CD +"','"+ sRow.EXMN_NM +"');\" title=\""+ sRow.EXMN_NM +"\">"+ sRow.EXMN_NM +"</a>";
				if(sRow.EXMN_DP > preDp){
					//최초에 ul 제거
					if(i == 0){
						sHtml += "<li class=\"icon-file\">"+sNode;
					}else{
						sHtml += "<ul><li class=\"icon-file\">"+sNode;
					}
				}else if(sRow.EXMN_DP < preDp){
					for(var j = sRow.EXMN_DP+1; j <= preDp; j++){
						sHtml += "</li></ul>";
					}
					if(sRow.EXMN_DP+1 == preDp){
						sHtml += "</li><li class=\"icon-file\">"+sNode;
					}else{
						sHtml += "</li><li class=\"icon-file\">"+sNode;
					}
				}else if(sRow.EXMN_DP = preDp){
					sHtml += "</li><li class=\"icon-file\">"+sNode;
				}
				preDp = sRow.EXMN_DP;
			}
			for(var k= 1; k <= preDp; k++){
				if(k == preDp){
					//마지막에 ul 제거
					sHtml += "</li>";
				}else{
					sHtml += "</li></ul>";
				}
			}

			$("#tree").html(sHtml);
	        $("#tree").explr();
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnAdd(){
		if(fnFormValueCheck("cdForm")){
			if(confirm($('#divCdNm').html()+"\n\r\n\r하위에 신규코드를 추가하시겠습니까?")){
				var iUrl = '<c:url value='/exmn/addAjax/'/>';
		 		var queryString =  $('#cdForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						fnDrawTree();
						fnSearchGrid("/exmn/exmnListAjax/", "cdForm", "#grid_list");
						fnClear();
					}else{
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
			}
		}
	}

	function fnUpdate(){
		if(fnFormValueCheck("cdForm")){
			if(confirm("수정하시겠습니까?")){
				var iUrl = '<c:url value='/exmn/updateAjax/'/>';
		 		var queryString =  $('#cdForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						fnDrawTree();
						fnSearchGrid("/exmn/exmnListAjax/", "cdForm", "#grid_list");
					} else if (data.result == "-3") {
						alert("하위 코드를 모두 삭제 후 삭제 가능합니다.");
					} else{
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
			}
		}
	}

	function fnSelect(sCd){
		var iUrl = '<c:url value='/exmn/exmnDetailAjax/'/>';
 		var queryString =  "txtExmnCd=" + sCd;
 		var processAfterGet = function(data) {
			$('#hidExmnCd').val(data.EXMN_CD);
			$('#txtExmnNm').val(data.EXMN_NM);
			$('#txtCmptncDc').val(data.EXMN_CMPTNC_DC);

			$('#selSort').val(data.SORT_ORDR);
 			$('#selUseYn').val(data.USE_YN);

 			$('#btnClear').show();
 			$('#btnAdd').hide();
 			$('#btnUpdate').show();
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "EXMN_CD", headerText : "검찰코드", width : 100},
			{ dataField : "EXMN_NM", headerText : "검찰명", width : 150},
			{ dataField : "EXMN_CMPTNC_DC", headerText : "관할구역", width : 100},
			{ dataField : "EXMN_DP", headerText : "코드깊이", width : 0},
			{ dataField : "EXMN_UPPER_CD", headerText : "상위코드", width : 0},
			{ dataField : "EXMN_UPPER_NM", headerText : "상위부서", width : 100},
			{ dataField : "USE_YN", headerText : "사용", width : 50},
			{ dataField : "SORT_ORDR", headerText : "정렬", width : 50}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true,
			showRowNumColumn : false,
			enableRightDownFocus : true // 기본값 : false
		};
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);

		AUIGrid.bind("#grid_list", "cellClick", function(event) {
			var items = event.item;
			fnSelect(items.EXMN_CD);
		});
		fnSearchGrid("/exmn/exmnListAjax/", "cdForm", "#grid_list");
	}

	function fnSearch(cd, nm){
		$('#divCd').html(cd);
		$('#divCdNm').html(nm);
		$("input:hidden[id=txtExmnUpperCd]").val(cd);
		fnSearchGrid("/exmn/exmnListAjax/", "cdForm", "#grid_list");
		fnClear();
	}

	function fnSelectRoot(){
		fnSearch('00000', '관할구역관리');
	}
</script>

<div class="box_w2">
	<div class="box_w2_1">
		<div class="tb_01_box">
			<div class="tb_box_ov" style=" min-height: 700px;">
				<ul id="tree">
				</ul>
			</div>
		</div>
	</div>

	<div class="box_w2_2">
		<div class="com_box  t_right">
			<div class="btn_box">
			<a href="javascript:void(0);" id="btnSelectRoot" onClick="fnSelectRoot();" class="btn_st2 icon_n fl mr_m1">최상위 선택</a>
			</div>
		</div>

		<div class="com_box mb_30">
			<div class="tb_01_box">
				<div id="grid_list" class="gridResize" style="width:100%; height:470px; margin:0 auto;"></div>
			</div>
		</div>

		<form id="cdForm" name="cdForm" method="post">
		<!--본문시작 -->
		<!--버튼 -->
		<div class="com_box  t_right">
			<div class="btn_box">
			<a href="javascript:void(0);" id="btnClear" onClick="fnClear();" class="btn_st2 icon_n fl mr_m1">신규</a>
			<a href="javascript:void(0);" id="btnAdd" onClick="fnAdd();" class="btn_st2 icon_n fl mr_m1">추가</a>
			<a href="javascript:void(0);" id="btnUpdate" onClick="fnUpdate();" class="btn_st2 icon_n fl mr_m1">수정</a>
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
					<th>상위검찰명</th>
					<td>
						<div id="divCdNm"></div>
					</td>
					<th>상위검찰코드</th>
					<td>
						<div id="divCd"></div>
						<input type="hidden" id="txtExmnUpperCd" name="txtExmnUpperCd" />
						<input type="hidden" id="hidExmnCd" name="hidExmnCd" />
						<input type="hidden" id="hidExmnCdDp" name="hidExmnCdDp" />
					</td>
				</tr>

				<tr>
					<th>검찰명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td><input type="text" id="txtExmnNm" name="txtExmnNm" maxlength="25" class="w_100p input_com" check="text" checkName="검찰명"></td>
					<th>관할구역</th>
					<td><input type="text" id="txtCmptncDc" name="txtCmptncDc" maxlength="200" class="w_100p input_com"></td>
				</tr>
				<tr>
					<th>사용여부<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td>
						<select id="selUseYn" name="selUseYn" class="w_80px input_com" check="text" checkName="사용여부">
							<option value="Y">사용</option>
							<option value="N">미사용</option>
						</select>
					</td>
					<th>출력순서<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td>
						<select id="selSort" name="selSort" class="w_80px input_com" check="text" checkName="출력순서">
							<c:forEach var="idx" begin="0" end="50" >
								<option value="${idx}">${idx}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				</tbody>
				</table>
			</div>
		</div>
		</form>
	</div>
</div>