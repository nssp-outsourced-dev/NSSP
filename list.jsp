<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<style type="text/css">
.grid_td_left {
	text-align: left
}
.aui-grid-button-renderer {
	color: #fff;
    background: #1aa0e6;
}
</style>
<script type="text/javascript">
	$(function() {
		$(document).ready(function(){
			initGrid();
			$('#btnClear').hide();
			$('#btnAdd').show();
			$('#btnUpdate').hide();
 			$('#btnResetPw').hide();
			fnIdClear(true);
		});

	})


	function fnSearch() {
		fnMoveGridPage("/member/listAjax/", "frmList", "#grid_list", 1);
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "RN", headerText : "순번", width : '5%'},
			{ dataField : "ESNTL_ID", headerText : "ESNTL_ID", visible : false},
			{ dataField : "USER_ID", headerText : "ID", width : '10%'},
			{ dataField : "USER_NM", headerText : "성명", width : '10%'},
			{ dataField : "DEPT_NM", headerText : "부서", width : '17%', style : 'grid_td_left'},
			{ dataField : "AUTHOR_NM", headerText : "권한", width : '13%',},
			{ dataField : "RSPOFC_NM", headerText : "직위", width : '10%'},
			{ dataField : "CLSF_NM", headerText : "직급", width : '10%'},
			{ headerText : "비밀번호",
				children: [{
					dataField : "PW_CHANGE_DE", headerText : "변경일자",  width : '10%', dataType : "date", formatString : "yyyy-mm-dd"
				},{
					dataField : "PW_FAILR_CO", headerText : "실패횟수", width : '7%'
				}]
			},{
				dataField : "CONFM_YN",
				headerText : "승인여부",
				width : 100,
				height : 150,
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var template = "";
					if(value == "Y"){
						template += "승인완료";
					}else{
						template += "<a href=\"javascript:void(0);\" onClick=\"fnConfmUser('"+item.ESNTL_ID+"');\" class=\"btn_td2 icon_n fl \">승인대기</a>";
					}
					return template;
				}
			},{
				dataField : "USE_YN",
				headerText : "사용여부",
				width : '7%',
				renderer : {type : "TemplateRenderer"},
				labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
					var template = "";
					if(value == "Y"){
						template += "사용";
					}else{
						template += "사용안함";
					}
					return template;
				}
			},
			{ dataField : "WRITNG_DT", headerText : "등록일시", width : '13%'}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			useGroupingPanel : false,
			showRowNumColumn : false,
			displayTreeOpen : true,
			fillColumnSizeMode : true,
			groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);

		AUIGrid.bind("#grid_list", "cellClick", function(event) {
			var items = event.item;
			fnSelect(items.ESNTL_ID);
		});
		fnMoveGridPage("/member/listAjax/", "frmList", "#grid_list", 1);
	}

	function fnSelect(sCd){
		var iUrl = '<c:url value='/member/detailAjax/'/>';
 		var queryString =  "hidEsntlID=" + sCd;
 		var processAfterGet = function(data) {
			$('#hidEsntlID').val(data.ESNTL_ID);

			$('#txtUserId').val(data.USER_ID);
			fnIdClear(false);

			$('#hidJobCnt').val(data.CF_JOB_CNT); // 2019-08-06
			$('#txtUserNm').val(data.USER_NM);
			$('#txtDeptNm').val(data.DEPT_NM);
			$('#hidDeptCd').val(data.DEPT_CD);
			$('#selClsfCd').val(data.CLSF_CD);
			$('#selRspofcCd').val(data.RSPOFC_CD);
			$('#txtChrgJob').val(data.CHRG_JOB);
			$('#txtResdncZip').val(data.RESDNC_ZIP);
			$('#txtResdncAddr').val(data.RESDNC_ADDR);

			if(data.EMAIL != null){
				$('#txtEmail').val(data.EMAIL);
				var email = data.EMAIL.split("@");
				$('#txtEmail1').val(email[0]);
				$('#txtEmail2').val(email[1]);
			}else{
				$('#txtEmail').val("");
				$('#txtEmail1').val("");
				$('#txtEmail2').val("");
			}

			if(data.HP_NO != null){
				$('#txtHpNo').val(data.HP_NO);
				var hpNo = data.HP_NO.split("-");
				$('#txtHpNo1').val(hpNo[0]);
				$('#txtHpNo2').val(hpNo[1]);
				$('#txtHpNo3').val(hpNo[2]);
			}else{
				$('#txtHpNo').val("");
				$('#txtHpNo1').val("");
				$('#txtHpNo2').val("");
				$('#txtHpNo3').val("");
			}

			if(data.TEL_NO != null){
				$('#txtTelNo').val(data.TEL_NO);
				var telNo = data.TEL_NO.split("-");
				$('#txtTelNo1').val(telNo[0]);
				$('#txtTelNo2').val(telNo[1]);
				$('#txtTelNo3').val(telNo[2]);
			}else{
				$('#txtTelNo').val("");
				$('#txtTelNo1').val("");
				$('#txtTelNo2').val("");
				$('#txtTelNo3').val("");
			}

			$('#selpwQestnCd').val(data.PW_QESTN_CD);
			$('#txtpwQestnAnswer').val(data.PW_QESTN_ANSWER);

			$('#selAuthorCd').val(data.AUTHOR_CD);
			$('#selUseYn').val(data.USE_YN);

 			$('#btnClear').show();
 			$('#btnAdd').hide();
 			$('#btnUpdate').show();

 			//비밀번호 초기화관련
 			var temp = data.PW_CHANGE_DE.substring(0, 4) + "-" + data.PW_CHANGE_DE.substring(4, 6) + "-" + data.PW_CHANGE_DE.substring(6, 8)
 			$('#txtPwChangeDe').val(temp);
 			$('#btnResetPw').show();
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnClear(){
		$('#hidEsntlID').val("");

		$('#txtUserId').val("");
		fnIdClear(true);

		$('#hidJobCnt').val("0");
		$('#txtUserNm').val("");
		$('#txtDeptNm').val("");
		$('#hidDeptCd').val("");
		$('#selClsfCd').val("");
		$('#selRspofcCd').val("");
		$('#txtChrgJob').val("");
		$('#txtResdncZip').val("");
		$('#txtResdncAddr').val("");

		$('#txtEmail').val("");
		$('#txtEmail1').val("");
		$('#txtEmail2').val("");

		$('#txtHpNo').val("");
		$('#txtHpNo1').val("");
		$('#txtHpNo2').val("");
		$('#txtHpNo3').val("");

		$('#txtTelNo').val("");
		$('#txtTelNo1').val("");
		$('#txtTelNo2').val("");
		$('#txtTelNo3').val("");

		$('#selpwQestnCd').val("");
		$('#txtpwQestnAnswer').val("");

		$('#selAuthorCd').val("");
		$('#selUseYn').val("Y");

		$('#btnClear').hide();
		$('#btnAdd').show();
		$('#btnUpdate').hide();

		//비밀번호 초기화관련
		$('#txtPwChangeDe').val("");
		$('#btnResetPw').hide();
	}

	function fnAdd(){
		if(fnFormValueCheck("addForm")){
			if(confirm("저장하시겠습니까?")){
				$('#txtEmail').val($('#txtEmail1').val()+"@"+$('#txtEmail2').val());
				$('#txtHpNo').val($('#txtHpNo1').val()+"-"+$('#txtHpNo2').val()+"-"+$('#txtHpNo3').val());
				$('#txtTelNo').val($('#txtTelNo1').val()+"-"+$('#txtTelNo2').val()+"-"+$('#txtTelNo3').val());

				var iUrl = '<c:url value='/member/addAjax/'/>';
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

	function fnSelectDept(upcd, cd, nm){
		$('#txtDeptNm').val(nm);
		$('#hidDeptCd').val(cd);
	}

	function jusoReturnValue (returnValue) {
		$("#txtResdncAddr").val(returnValue.addr);
		$("#txtResdncZip").val(returnValue.zipCd);
	}

	function fnIdDplctCheck(){
	    if(!/^[a-zA-Z0-9]{8,12}$/.test($("#txtUserId").val())){
            alert("숫자,영문자 조합으로 8~12자리의 ID를 사용할 수 있습니다.");
    		return;
	    }
		var iUrl = '<c:url value='/member/getIdDplctAjax/'/>';
 		var queryString =  $('#addForm').serialize();
 		var processAfterGet = function(data) {
			if(data.result == "1"){
				alert("사용가능한 ID입니다.");
				fnIdClear(false);
			}else{
				alert("입력하신 ID는 사용할 수 없습니다.");
			}
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnIdClear(bln){
		if(bln){
			$('#btnIdDplct').show();
			$('#btnIdClear').hide();
			$('#txtUserId').attr("readonly",false);
		}else{
			$('#btnIdDplct').hide();
			if($('#hidEsntlID').val().length > 0){
				$('#btnIdClear').hide();
			}else{
				$('#btnIdClear').show();
			}
			$('#txtUserId').attr("readonly",true);
		}
	}

	function fnConfmUser(esntlId){
		if(confirm("승인을 진행하시겠습니까?")){
			var iUrl = '<c:url value='/member/confmUserAjax/'/>';
	 		var queryString =  "hidEsntlID="+esntlId;
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					fnSearch();
				}else if(data.result == "-3"){
					alert("권한이 부여되지 않았습니다.\n\r\n\r사용자의 권한을 지정한 후 진행하세요.");
				}else{
					alert("승인중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnResetPw(){
		if(confirm($('#txtUserNm').val()+"("+$('#txtUserId').val()+") 사용자의\n\n비밀번호를 초기화하시겠습니까?")){
			var iUrl = '<c:url value='/member/resetPwAjax/'/>';
	 		var queryString =  $('#addForm').serialize();
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("'"+ data.resetPw + "'로 초기화되었습니다.");
					fnSearch();
					fnClear();
				}else{
					alert("비밀번호 초기화중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	// 2019-08-06
	function fnChngeDept() {
		if(Number($('#hidJobCnt').val()) > 0) {
			alert("수사중인 사건이 존재합니다. 인수인계 처리 후 변경 가능합니다.");
		} else {
			fnDeptSelect();	
		}
	}
	
	// 2019-08-06 fnDeptSelect()과 동일
	/* function fnSearchDept() {
		var searchDeptPopup = dhtmlmodal.open('searchDeptPopup', 'iframe', '/dept/selectPopup/', '부서검색', 'width=450px,height=500px,center=1,resize=0,scrolling=1')
		searchDeptPopup.onclose = function(){
			var iframedoc = this.contentDoc;
			$('#searchDeptNm').val(iframedoc.getElementById("txtCdNm").value);
			$('#searchDeptCd').val(iframedoc.getElementById("txtCd").value);
			return true;
		}
	} */

</script>

<form id="frmList" name="frmList" method="post">
<input type="hidden" id="hidPage" name="hidPage">
<input type="hidden" id="hidTotCnt" name="hidTotCnt" value="0">
<input type="hidden" id="hidPageArea" name="hidPageArea" value="10">
<!--검색박스 -->

<div class="search_box mb_20">
	<div class="search_in">
		<div class="stitle w_40px">ID</div>
        <div class="r_box w_350px">
			<input type="text" id="searchUserID" name="searchUserID" maxlength="20" class="w_100px input_com_s ">
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_70px">사용자명</div>
        <div class="r_box w_350px">
			<input type="text" id="searchUserNm" name="searchUserNm" maxlength="20" class="w_100px input_com_s ">
		</div>
	</div>
	<!-- <div class="search_in">
		<div class="stitle w_40px">부서</div>
		<div class="r_box w_350px">
			<div class="flex_r ">
				<input type="hidden" id="searchDeptCd" name="searchDeptCd">
				<input type="text" id="searchDeptNm" name="searchDeptNm" maxlength="50" size="50" class="w_150px input_com" placeholder="부서선택" readonly>
				<input type="button" value="" class="btn_search mr_10" onclick="fnSearchDept();">
			</div>
		</div>
	</div> -->	
	<div class="search_in">
		<div class="stitle w_40px">권한</div>
		<div class="r_box w_350px">
			<select id="searchAuthorCd" name="searchAuthorCd" class="w_150px fl">
			<option value="">==선택하세요==</option>
			<c:forEach var="cd" items="${authorList}">
				<option value="${cd.AUTHOR_CD}"><c:out value="${cd.AUTHOR_NM}" /></option>
			</c:forEach>
			</select>
		</div>
	</div>
	<div class="search_in">
		<div class="stitle w_70px">조회건수</div>
		<div class="r_box">
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
		<div id="grid_list" class="gridResize" style="width:100%; height:380px; margin:0 auto;"></div>
		<div id="grid_list_paging" style="width:100%; height:40px;"></div>
	</div>
</div>



<form id="addForm" name="addForm" method="post">
<input type="hidden" id="hidEsntlID" name="hidEsntlID">
<input type="hidden" id="hidJobCnt" name="hidJobCnt">
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
			<th>ID<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<div class="flex_r">
					<input type="text" id="txtUserId" name="txtUserId" maxlength="20" class="w_150px input_com" check="text" checkName="ID">
					<input type="button" id="btnIdDplct" value="중복확인" class="btn_text" onclick="fnIdDplctCheck();" >
					<input type="button" id="btnIdClear" value="초기화" class="btn_text" onclick="fnIdClear(true);" >
				</div>
			</td>
			<th>성명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td><input type="text" id=txtUserNm name="txtUserNm" maxlength="20" class="w_150px input_com" check="text" checkName="성명"></td>
		</tr>

		<tr>
			<th>비밀번호 변경일</th>
			<td colspan="3">
				<div class="flex_r">
					<input type="text" id="txtPwChangeDe" name="txtPwChangeDe" class="w_150px input_com" readonly>
					<input type="button" id="btnResetPw" value="비밀번호 초기화" class="btn_text" onclick="fnResetPw();" >
				</div>
			</td>
		</tr>
		<tr>
			<th>비밀번호 질문<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td colspan="3">
				<select id="selpwQestnCd" name="selpwQestnCd" class="w_250px input_com" check="text" checkName="비밀번호 질문">
					<option value="">==선택하세요==</option>
					<c:forEach var="cd" items="${qestnList}">
						<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
			</td>
		</tr>

		<tr>
			<th>비밀번호 답변<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td colspan="3">
				<input type="text" id=txtpwQestnAnswer name="txtpwQestnAnswer" maxlength="100" class="w_250px input_com" check="text" checkName="비밀번호 답변">
			</td>
		</tr>
		<tr>
			<th>부서<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
			<input type="text" id="txtDeptNm" name="txtDeptNm" class="w_250px input_com" check="text" checkName="부서" readonly>
			<input type="hidden" id="hidDeptCd" name="hidDeptCd">
			<input type="button" value="" class="btn_search" onclick="fnChngeDept();">
			</td>
			<th>권한<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<select id="selAuthorCd" name="selAuthorCd" class="w_150px input_com" check="text" checkName="권한">
					<option value="">==선택하세요==</option>
					<c:forEach var="cd" items="${authorList}">
						<option value="${cd.AUTHOR_CD}"><c:out value="${cd.AUTHOR_NM}" /></option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th>직급<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<select id="selClsfCd" name="selClsfCd" class="w_150px input_com" check="text" checkName="직급">
					<option value="">==선택하세요==</option>
					<c:forEach var="cd" items="${clsfList}">
						<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
			</td>
			<th>직위<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<select id="selRspofcCd" name="selRspofcCd" class="w_150px input_com" check="text" checkName="직위">
					<option value="">==선택하세요==</option>
					<c:forEach var="cd" items="${rspofcList}">
						<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
			</td>
		</tr>

		<tr>
			<th>담당업무</th>
			<td><input type="text" id=txtChrgJob name="txtChrgJob" maxlength="50" class="w_250px input_com"></td>
			<th>연락처(사무실)<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<input type="hidden" id="txtTelNo" name="txtTelNo">
				<select id="txtTelNo1" name="txtTelNo1" class="w_80px input_com mr_5" check="text" checkName="연락처(사무실)">
					<option value="">선택</option>
					<c:forEach var="cd" items="${telList}">
						<option value="${cd.cdNm}"><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
				<input type="text" id="txtTelNo2" name="txtTelNo2" maxlength="4" class="w_80px input_com onlyNumber" check="text" checkName="연락처(사무실)"> -
				<input type="text" id="txtTelNo3" name="txtTelNo3" maxlength="4" class="w_80px input_com onlyNumber" check="text" checkName="연락처(사무실)">
			</td>
		</tr>
		<tr>
			<th>주소</th>
			<td colspan="3">
			<input type="text" id="txtResdncZip" name="txtResdncZip" maxlength="10" class="w_100px input_com" onclick="fnZipPop()" readonly>
			<input type="button" value="" class="btn_search" onclick="fnZipPop();">
			<input type="text" id="txtResdncAddr" name="txtResdncAddr" maxlength="500" class="w_50p input_com" readonly>
			</td>
		</tr>
		<tr>
			<th>휴대폰<span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<input type="hidden" id="txtHpNo" name="txtHpNo">
				<select id="txtHpNo1" name="txtHpNo1" class="w_80px input_com mr_5" check="text" checkName="휴대폰">
					<option value="">선택</option>
					<c:forEach var="cd" items="${hpList}">
						<option value="${cd.cdNm}"><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
				<input type="text" id="txtHpNo2" name="txtHpNo2" maxlength="4" class="w_80px input_com onlyNumber" check="text" checkName="휴대폰"> -
				<input type="text" id="txtHpNo3" name="txtHpNo3" maxlength="4" class="w_80px input_com onlyNumber" check="text" checkName="휴대폰">
			</td>
			<th>이메일</th>
			<td>
				<input type="hidden" id="txtEmail" name="txtEmail">
				<input type="text" id="txtEmail1" name="txtEmail1" maxlength="20" value='' class="w_150px input_com">
				&#64;
				<input type="text" id="txtEmail2" name="txtEmail2" maxlength="20" value='' class="w_150px input_com">			
			</td>
		</tr>
		<tr>
			<th>사용여부</th>
			<td colspan="3">
				<select id="selUseYn" name="selUseYn" class="w_80px input_com" check="text" checkName="사용여부">
					<option value="Y">사용</option>
					<option value="N">사용안함</option>
				</select>
			</td>
		</tr>
		</tbody>
		</table>
	</div>
</div>
</form>