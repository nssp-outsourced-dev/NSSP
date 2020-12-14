<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<link href="/jq/fileacc/css/file.css" rel="stylesheet" type="text/css">
<style type="text/css">
.grid_td_left {
	text-align: left
}
</style>
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
		$('#hidCd').val("");
		$('#txtCdNm').val("");
		$('#txtCdDc').val("");
		$('#hidCdDp').val("");

		$('#selSort').val("0");
		$('#selUseYn').attr('disabled', false).val("Y");

		$('#btnClear').hide();
		$('#btnAdd').show();
		$('#btnUpdate').hide();
	}

	function fnDrawTree(){
		var iUrl = '<c:url value='/cd/cdFullListAjax/'/>';
 		var queryString =  "";
 		var processAfterGet = function(data) {
			var sHtml = "";
			var sNode = "";
			var preDp = 0;
			for(var i = 0; i < data.length; i++){
				sRow = data[i];
				sNode = "<a href=\"javascript:fnSearch('"+ sRow.cd +"','"+ sRow.cdNm +"');\" title=\""+ sRow.cdNm +"\">"+ sRow.cdNm +"</a>";
				if(sRow.cdDp > preDp){
					//최초에 ul 제거
					if(i == 0){
						sHtml += "<li class=\"icon-file\">"+sNode;
					}else{
						sHtml += "<ul><li class=\"icon-file\">"+sNode;
					}
				}else if(sRow.cdDp < preDp){
					for(var j = sRow.cdDp+1; j <= preDp; j++){
						sHtml += "</li></ul>";
					}
					if(sRow.cdDp+1 == preDp){
						sHtml += "</li><li class=\"icon-file\">"+sNode;
					}else{
						sHtml += "</li><li class=\"icon-file\">"+sNode;
					}
				}else if(sRow.cdDp = preDp){
					sHtml += "</li><li class=\"icon-file\">"+sNode;
				}
				preDp = sRow.cdDp;
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
				var iUrl = '<c:url value='/cd/addAjax/'/>';
		 		var queryString =  $('#cdForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						fnDrawTree();
						fnSearchGrid("/cd/cdListAjax/", "cdForm", "#grid_list");
						fnClear();
					} else {
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
				var iUrl = '<c:url value='/cd/updateAjax/'/>';
		 		var queryString =  $('#cdForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						fnDrawTree();
						fnSearchGrid("/cd/cdListAjax/", "cdForm", "#grid_list");
					} else if (data.result == "-3") {
						alert("하위 코드를 모두 삭제 후 삭제 가능합니다.");
					} else {
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
			}
		}
	}

	function fnSelect(sCd){
		var iUrl = '<c:url value='/cd/cdDetailAjax/'/>';
 		var queryString =  "txtCd=" + sCd;
 		var processAfterGet = function(data) {
			$('#hidCd').val(data.cd);
			$('#txtCdNm').val(data.cdNm);
			$('#txtCdDc').val((data.cdDc == 'undefined' ? '' : data.cdDc));
			$('#hidCdDp').val(data.cdDp);

			$('#selSort').val(data.sort);
 			if(data.esntlAt == 'Y'){
 				$('#selUseYn').attr('disabled', true).val(data.useYn);
 			}else{
 				$('#selUseYn').attr('disabled', false).val(data.useYn);
 			}

 			$('#btnClear').show();
 			$('#btnAdd').hide();
 			$('#btnUpdate').show();
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "cd", headerText : "코드", width : 100},
			{ dataField : "cdNm", headerText : "코드명", width : 150 , style : 'grid_td_left'},
			{ dataField : "cdDc", headerText : "코드상세", width : 150, style : 'grid_td_left'},
			{ dataField : "cdDp", headerText : "코드깊이", width : 0},
			{ dataField : "upCd", headerText : "상위코드", width : 100},
			{ dataField : "useYn", headerText : "사용", width : 50},
			{ dataField : "sort", headerText : "정렬", width : 50}
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
			fnSelect(items.cd);
		});
		fnSearchGrid("/cd/cdListAjax/", "cdForm", "#grid_list");
	}

	function fnSearch(cd, nm){
		$('#divCd').html(cd);
		$('#divCdNm').html(nm);
		$("input:hidden[id=txtUpCd]").val(cd);
		fnSearchGrid("/cd/cdListAjax/", "cdForm", "#grid_list");
		fnClear();
	}

	function fnSelectRoot(){
		fnSearch('00000', '코드관리');
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
			<a href="javascript:void(0);" id="btnSelectRoot" onClick="fnSearch('00000', '코드관리');" class="btn_st2 icon_n fl mr_m1">최상위 선택</a>
			</div>
		</div>

		<div class="com_box mb_30">
			<div class="tb_01_box">
				<div id="grid_list" class="gridResize" style="width:100%; height:500px; margin:0 auto;"></div>
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
					<th>상위코드명</th>
					<td>
						<div id="divCdNm"></div>
					</td>
					<th>상위코드</th>
					<td>
						<div id="divCd"></div>
						<input type="hidden" id="txtUpCd" name="txtUpCd" />
						<input type="hidden" id="hidCd" name="hidCd" />
						<input type="hidden" id="hidCdDp" name="hidCdDp" />
					</td>
				</tr>

				<tr>
					<th>코드명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td><input type="text" id="txtCdNm" name="txtCdNm" maxlength="100" class="w_100p input_com" check="text" checkName="코드명"></td>
					<th>코드설명</th>
					<td><input type="text" id="txtCdDc" name="txtCdDc" maxlength="1000" class="w_100p input_com"></td>
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



