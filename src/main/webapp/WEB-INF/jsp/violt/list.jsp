<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<style type="text/css">
.grid_td_left {
	text-align: left
}
</style>
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
		$('#hidVioltCd').val("");
		$('#txtVioltNm').val("");
		$('#txtVioltDc').val("");

		$('#txtVioltCn').text("");

		$('#hidVioltCdDp').val("");

		$('#selSort').val("0");
		$('#selUseYn').val("Y");

		$('#btnClear').hide();
		$('#btnAdd').show();
		$('#btnUpdate').hide();
	}

	function fnDrawTree(){
		var iUrl = '<c:url value='/violt/violtFullListAjax/'/>';
 		var queryString =  "";
 		var processAfterGet = function(data) {

			var sHtml = "";
			var sNode = "";
			var preDp = 0;
			for(var i = 0; i < data.length; i++){
				sRow = data[i];
				sNode = "<a href=\"javascript:fnSearch('"+ sRow.VIOLT_CD +"','"+ sRow.VIOLT_NM +"');\" title=\""+ sRow.VIOLT_NM +"\">"+ sRow.VIOLT_NM +"</a>";
				if(sRow.VIOLT_DP > preDp){
					//최초에 ul 제거
					if(i == 0){
						sHtml += "<li class=\"icon-file\">"+sNode;
					}else{
						sHtml += "<ul><li class=\"icon-file\">"+sNode;
					}
				}else if(sRow.VIOLT_DP < preDp){
					for(var j = sRow.VIOLT_DP+1; j <= preDp; j++){
						sHtml += "</li></ul>";
					}
					if(sRow.VIOLT_DP+1 == preDp){
						sHtml += "</li><li class=\"icon-file\">"+sNode;
					}else{
						sHtml += "</li><li class=\"icon-file\">"+sNode;
					}
				}else if(sRow.VIOLT_DP = preDp){
					sHtml += "</li><li class=\"icon-file\">"+sNode;
				}
				preDp = sRow.VIOLT_DP;
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
				var iUrl = '<c:url value='/violt/addAjax/'/>';
		 		var queryString =  $('#cdForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						fnDrawTree();
						fnSearchGrid("/violt/violtListAjax/", "cdForm", "#grid_list");
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
				var iUrl = '<c:url value='/violt/updateAjax/'/>';
		 		var queryString =  $('#cdForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						fnDrawTree();
						fnSearchGrid("/violt/violtListAjax/", "cdForm", "#grid_list");
					} else if (data.result == "-3") {
						alert("하위 위반사항을 모두 삭제 후 삭제 가능합니다.");
					} else {
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
			}
		}
	}

	function fnSelect(sCd){
		var iUrl = '<c:url value='/violt/violtDetailAjax/'/>';
 		var queryString =  "txtVioltCd=" + sCd;
 		var processAfterGet = function(data) {
			$('#hidVioltCd').val(data.VIOLT_CD);
			$('#txtVioltNm').val(data.VIOLT_NM);
			$('#txtVioltDc').val(data.VIOLT_DC);
			if(data.VIOLT_CN != null){
				$('#txtVioltCn').text(data.VIOLT_CN);
			}else{
				$('#txtVioltCn').text("");
			}

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
			{ dataField : "VIOLT_CD", headerText : "위반코드", width : 100},
			{ dataField : "VIOLT_NM", headerText : "위반명",  width : 150, style : 'grid_td_left'},
			{ dataField : "VIOLT_DC", headerText : "위반설명", width : 100, style : 'grid_td_left'},
			{ dataField : "VIOLT_DP", headerText : "코드깊이", width : 0},
			{ dataField : "VIOLT_UPPER_CD", headerText : "상위코드", width : 0},
			{ dataField : "VIOLT_UPPER_NM", headerText : "상위위반", width : 100},
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
			fnSelect(items.VIOLT_CD);
		});
		fnSearchGrid("/violt/violtListAjax/", "cdForm", "#grid_list");
	}

	function fnSearch(cd, nm){
		$('#divCd').html(cd);
		$('#divCdNm').html(nm);
		$("input:hidden[id=txtVioltUpperCd]").val(cd);
		fnSearchGrid("/violt/violtListAjax/", "cdForm", "#grid_list");
		fnClear();
	}

	function fnSelectRoot(){
		fnSearch('00000', '위반사항관리');
	}
</script>

<div class="box_w2">
	<div class="box_w2_1">
		<div class="tb_01_box">
			<div class="tb_box_ov" style=" min-height: 730px;">
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

		<div class="com_box mb_10">
			<div class="tb_01_box">
				<div id="grid_list" class="gridResize" style="width:100%; height:260px; margin:0 auto;"></div>
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
					<th>상위위반명</th>
					<td>
						<div id="divCdNm"></div>
					</td>
					<th>상위위반코드</th>
					<td>
						<div id="divCd"></div>
						<input type="hidden" id="txtVioltUpperCd" name="txtVioltUpperCd" />
						<input type="hidden" id="hidVioltCd" name="hidVioltCd" />
						<input type="hidden" id="hidVioltCdDp" name="hidVioltCdDp" />
					</td>
				</tr>

				<tr>
					<th>위반명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td><input type="text" id="txtVioltNm" name="txtVioltNm" maxlength="25" class="w_100p input_com" check="text" checkName="위반명"></td>
					<th>위반설명</th>
					<td><input type="text" id="txtVioltDc" name="txtVioltDc" maxlength="200" class="w_100p input_com"></td>
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
				<tr>
					<th>위반사항 상세</th>
					<td colspan="3">
						<textarea id="txtVioltCn" name="txtVioltCn" style="width:100%;height:250px;"></textarea>
					</td>
				</tr>
				</tbody>
				</table>
			</div>
		</div>
		</form>
	</div>
</div>