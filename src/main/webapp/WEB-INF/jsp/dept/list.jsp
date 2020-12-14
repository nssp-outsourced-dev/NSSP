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
		$('#hidDeptCd').val("");
		$('#txtDeptNm').val("");
		$('#txtDeptFunc').val("");

		$('#txtDeptTelNo').val("");
		$('#txtDeptTelNo1').val("");
		$('#txtDeptTelNo2').val("");
		$('#txtDeptTelNo3').val("");

		$('#txtDeptFaxNo').val("");
		$('#txtDeptFaxNo1').val("");
		$('#txtDeptFaxNo2').val("");
		$('#txtDeptFaxNo3').val("");

		$('#txtDeptZip').val("");
		$('#txtDeptAddr').val("");
		$('#selDeptSeCd').val("");
		$('#selExmnCd').val("");
		$('#txtExmnNm').val("");

		$('#hidDeptCdDp').val("");

		$('#selSort').val("0");
		$('#selUseYn').val("Y");

		$('#divWritngDt').html("");

		$('#btnClear').hide();
		$('#btnAdd').show();
		$('#btnUpdate').hide();
	}

	function fnDrawTree(){
		var iUrl = '<c:url value='/dept/deptFullListAjax/'/>';
 		var queryString =  "";
 		var processAfterGet = function(data) {
			var sHtml = "";
			var sNode = "";
			var preDp = 0;
			for(var i = 0; i < data.length; i++){
				sRow = data[i];
				sNode = "<a href=\"javascript:fnSearch('"+ sRow.DEPT_CD +"','"+ sRow.DEPT_NM +"');\" title=\""+ sRow.DEPT_NM +"\">"+ sRow.DEPT_NM +"</a>";
				if(sRow.DEPT_DP > preDp){
					//최초에 ul 제거
					if(i == 0){
						sHtml += "<li class=\"icon-file\">"+sNode;
					}else{
						sHtml += "<ul><li class=\"icon-file\">"+sNode;
					}
				}else if(sRow.DEPT_DP < preDp){
					for(var j = sRow.DEPT_DP+1; j <= preDp; j++){
						sHtml += "</li></ul>";
					}
					if(sRow.DEPT_DP+1 == preDp){
						sHtml += "</li><li class=\"icon-file\">"+sNode;
					}else{
						sHtml += "</li><li class=\"icon-file\">"+sNode;
					}
				}else if(sRow.DEPT_DP = preDp){
					sHtml += "</li><li class=\"icon-file\">"+sNode;
				}
				preDp = sRow.DEPT_DP;
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
				$('#txtDeptTelNo').val($('#txtDeptTelNo1').val()+"-"+$('#txtDeptTelNo2').val()+"-"+$('#txtDeptTelNo3').val());
				$('#txtDeptFaxNo').val($('#txtDeptFaxNo1').val()+"-"+$('#txtDeptFaxNo2').val()+"-"+$('#txtDeptFaxNo3').val());

				var iUrl = '<c:url value='/dept/addAjax/'/>';
		 		var queryString =  $('#cdForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						fnDrawTree();
						fnSearchGrid("/dept/deptListAjax/", "cdForm", "#grid_list");
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
				$('#txtDeptTelNo').val($('#txtDeptTelNo1').val()+"-"+$('#txtDeptTelNo2').val()+"-"+$('#txtDeptTelNo3').val());
				$('#txtDeptFaxNo').val($('#txtDeptFaxNo1').val()+"-"+$('#txtDeptFaxNo2').val()+"-"+$('#txtDeptFaxNo3').val());

				var iUrl = '<c:url value='/dept/updateAjax/'/>';
		 		var queryString =  $('#cdForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						fnDrawTree();
						fnSearchGrid("/dept/deptListAjax/", "cdForm", "#grid_list");
					} else if (data.result == "-3") {
						alert("하위 부서를 모두 삭제 후 삭제 가능합니다.");
					} else{
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
			}
		}
	}

	function fnSelect(sCd){
		var iUrl = '<c:url value='/dept/deptDetailAjax/'/>';
 		var queryString =  "txtDeptCd=" + sCd;
 		var processAfterGet = function(data) {
			$('#hidDeptCd').val(data.DEPT_CD);
			$('#txtDeptNm').val(data.DEPT_NM);
			$('#txtDeptFunc').val(data.DEPT_FUNC);
			$('#hidDeptCdDp').val(data.DEPT_DP);

			if(data.DEPT_TEL_NO != null){
				$('#txtDeptTelNo').val(data.DEPT_TEL_NO);
				var telNo = data.DEPT_TEL_NO.split("-");
				$('#txtDeptTelNo1').val(telNo[0]);
				$('#txtDeptTelNo2').val(telNo[1]);
				$('#txtDeptTelNo3').val(telNo[2]);
			}else{
				$('#txtDeptTelNo').val("");
				$('#txtDeptTelNo1').val("");
				$('#txtDeptTelNo2').val("");
				$('#txtDeptTelNo3').val("");
			}

			if(data.DEPT_FAX_NO != null){
				$('#txtDeptFaxNo').val(data.DEPT_FAX_NO);
				var faxNo = data.DEPT_FAX_NO.split("-");
				$('#txtDeptFaxNo1').val(faxNo[0]);
				$('#txtDeptFaxNo2').val(faxNo[1]);
				$('#txtDeptFaxNo3').val(faxNo[2]);
			}else{
				$('#txtDeptFaxNo').val("");
				$('#txtDeptFaxNo1').val("");
				$('#txtDeptFaxNo2').val("");
				$('#txtDeptFaxNo3').val("");
			}

			$('#txtDeptZip').val(data.DEPT_ZIP);
			$('#txtDeptAddr').val(data.DEPT_ADDR);
			$('#selDeptSeCd').val(data.DEPT_SE_CD);
			$('#selExmnCd').val(data.CMPTNC_EXMN_CD);
			$('#txtExmnNm').val(data.CMPTNC_EXMN_NM);

			$('#selSort').val(data.SORT_ORDR);
 			$('#selUseYn').val(data.USE_YN);

 			$('#divWritngDt').html(data.WRITNG_DT);

 			$('#btnClear').show();
 			$('#btnAdd').hide();
 			$('#btnUpdate').show();
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnSelectExmn(upcd, cd, nm){
		$('#selExmnCd').val(cd);
		$('#txtExmnNm').val(nm);
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "DEPT_CD", headerText : "부서코드", width : 100},
			{ dataField : "DEPT_NM", headerText : "부서명", width : 150},
			{ dataField : "DEPT_SE_NM", headerText : "부서구분", width : 100},
			{ dataField : "DEPT_FUNC", headerText : "부서기능", width : 100},
			{ dataField : "DEPT_DP", headerText : "코드깊이", width : 0},
			{ dataField : "DEPT_UPPER_CD", headerText : "상위코드", width : 0},
			{ dataField : "DEPT_UPPER_NM", headerText : "상위부서", width : 100},
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
			fnSelect(items.DEPT_CD);
		});
		fnSearchGrid("/dept/deptListAjax/", "cdForm", "#grid_list");
	}

	function fnSearch(cd, nm){
		$('#divCd').html(cd);
		$('#divCdNm').html(nm);
		$("input:hidden[id=txtDeptUpperCd]").val(cd);
		fnSearchGrid("/dept/deptListAjax/", "cdForm", "#grid_list");
		fnClear();
	}

	function jusoReturnValue (returnValue) {
		$("#txtDeptAddr").val(returnValue.addr);
		$("#txtDeptZip").val(returnValue.zipCd);
	}
	function fnSelectRoot(){
		fnSearch('00000', '부서관리');
	}
</script>
<div class="box_w2">
	<div class="box_w2_1">
		<div class="tb_01_box">
			<div class="tb_box_ov" style=" min-height: 720px;">
				<ul id="tree">
				</ul>
			</div>
		</div>
	</div>

	<div class="box_w2_2">
		<div class="com_box  t_right">
			<div class="btn_box">
			<a href="javascript:void(0);" id="btnSelectRoot" onClick="fnSearch('00000', '부서관리');" class="btn_st2 icon_n fl mr_m1">최상위 선택</a>
			</div>
		</div>

		<div class="com_box mb_30">
			<div class="tb_01_box">
				<div id="grid_list" class="gridResize" style="width:100%; height:285px; margin:0 auto;"></div>
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
					<th>상위부서명</th>
					<td>
						<div id="divCdNm"></div>
					</td>
					<th>상위부서코드</th>
					<td>
						<div id="divCd"></div>
						<input type="hidden" id="txtDeptUpperCd" name="txtDeptUpperCd" />
						<input type="hidden" id="hidDeptCd" name="hidDeptCd" />
						<input type="hidden" id="hidDeptCdDp" name="hidDeptCdDp" />
					</td>
				</tr>
				<tr>
					<th>부서명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td><input type="text" id="txtDeptNm" name="txtDeptNm" maxlength="20" class="w_100p input_com" check="text" checkName="부서명"></td>
					<th>부서기능</th>
					<td><input type="text" id="txtDeptFunc" name="txtDeptFunc" maxlength="200" class="w_100p input_com"></td>
				</tr>
				<tr>
					<th>연락처</th>
					<td colspan="3">
						<input type="hidden" id="txtDeptTelNo" name="txtDeptTelNo">
						<input type="text" id="txtDeptTelNo1" name="txtDeptTelNo1" maxlength="4" class="w_80px input_com"> -
						<input type="text" id="txtDeptTelNo2" name="txtDeptTelNo2" maxlength="4" class="w_80px input_com"> -
						<input type="text" id="txtDeptTelNo3" name="txtDeptTelNo3" maxlength="4" class="w_80px input_com">
					</td>
				</tr>
				<tr>
					<th>FAX</th>
					<td colspan="3">
						<input type="hidden" id="txtDeptFaxNo" name="txtDeptFaxNo">
						<input type="text" id="txtDeptFaxNo1" name="txtDeptFaxNo1" maxlength="4" class="w_80px input_com"> -
						<input type="text" id="txtDeptFaxNo2" name="txtDeptFaxNo2" maxlength="4" class="w_80px input_com"> -
						<input type="text" id="txtDeptFaxNo3" name="txtDeptFaxNo3" maxlength="4" class="w_80px input_com">
					</td>
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
					<th>주소</th>
					<td colspan="3">
					<input type="text" id="txtDeptZip" name="txtDeptZip" maxlength="10" class="w_100px input_com" > <!-- onclick="fnZipPop()" -->
					<input type="button" value="" class="btn_search" onclick="fnZipPop();">
					<input type="text" id="txtDeptAddr" name="txtDeptAddr" maxlength="500" class="w_50p input_com">
					</td>
				</tr>
				<tr>
					<th>관할검찰</th>
					<td colspan="3">
						<input type="text" id="txtExmnNm" name="txtExmnNm" maxlength="100" class="w_250px input_com" readonly>
						<input type="hidden" id="selExmnCd" name="selExmnCd">
						<input type="button" value="" class="btn_search" onclick="fnExmnSelect();">
					</td>
				</tr>
				<tr>
					<th>부서구분</th>
					<td align="left">
						<select id="selDeptSeCd" name="selDeptSeCd" class="w_150px input_com">
							<option value="">==선택하세요==</option>
							<c:forEach var="cd" items="${deptSeList}">
								<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
							</c:forEach>
						</select>
					</td>
					<th>부서생성일자</th>
					<td colspan="3">
						<div id="divWritngDt"></div>
					</td>
				</tr>
				</tbody>
				</table>
			</div>
		</div>
		</form>
	</div>
</div>
