<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>
<style>
.grid_td_left {text-align:left}
</style>
<script type="text/javascript">
	var myGridID;

	$(document).ready(function(){
		initGrid();   // 그리드관련
		gridResize(); // 그리드관련

		$("#btnNew").click(function(){
			$("#txtTrgterNm").focus();
			fnSetValue();
		});
	});

	function initGrid() {
		var columnLayout = [{
				headerText : "구분", dataField : "TRGTER_SE_CD_NM", width: "10%"
			}, {
				headerText : "성명", dataField : "TRGTER_NM", width: "10%"
			}, {
				headerText : "주민번호", 	dataField : "TRGTER_RRN", width: "15%"
			}, {
				headerText : "자택 전화", dataField : "TRGTER_TEL", width: "12%"
			}, {
				headerText : "휴대 전화", dataField : "TRGTER_HP_NO", width: "13%"
			}, {
				headerText : "우편번호", 	dataField : "ADRES_ZIP", width: "10%"
			}, {
				headerText : "주소", dataField : "ADRES_ADDR", style : "grid_td_left", width: "30%"
			}
		];
		var gridPros = {
			showRowNumColumn : true,
			displayTreeOpen : true,
			selectionMode : "singleRow",
			triggerSelectionChangeOnCell : true,
			noDataMessage : "조회 목록이 없습니다.",
			headerHeight : 30,
			rowHeight : 30,
			fillColumnSizeMode : true
		};

		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);
		AUIGrid.bind(myGridID, "cellClick", function(event) {
			var items = event.item;
			fnSetValue(items);
		});

		// 사건대상자 목록
		fnSearchGrid("/inv/ccdrcTrgterListAjax/", "form_detail", myGridID);
		// 압수대상자 상세
		var iUrl = "<c:url value='/inv/ccdrcTrgterInfoByPkAjax/'/>";
		var queryString = {
			hidCcdrcNo : "${hidCcdrcNo}",
			hidCcdrcSn : "${hidCcdrcSn}",
			hidCaseNo : "${hidCaseNo}",
			hidRcNo : "${hidRcNo}",
			hidSzureTrgterCd : "${hidSzureTrgterCd}"
		};
		var processAfterGet = function(data) {
			fnSetValue(data);
		}
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnSetReadOnly(bool) {
		$("#txtTrgterNm").attr("readonly", bool);
		$("#txtTrgterRrn1").attr("readonly", bool);
		$("#txtTrgterRrn2").attr("readonly", bool);
		$("#txtTrgterTel1").attr("readonly", bool);
		$("#txtTrgterTel1").prop("disabled", bool);
		$("#txtTrgterTel2").attr("readonly", bool);
		$("#txtTrgterTel3").attr("readonly", bool);
		$("#txtTrgterHpNo1").attr("readonly", bool);
		$("#txtTrgterHpNo1").prop("disabled", bool);
		$("#txtTrgterHpNo2").attr("readonly", bool);
		$("#txtTrgterHpNo3").attr("readonly", bool);
		$("#btnAddr").prop("disabled", bool);
		$("input:radio[name=rdoTrgterTyCd]").prop("disabled", bool);
	}

	function fnSetValue(oData) {
		if(oData) {
			if(oData.TRGTER_SN) {
				fnSetReadOnly(true);
			} else {
				fnSetReadOnly(false);
			}
			$("#hidTrgterSn").val(oData.TRGTER_SN);
			$("#txtTrgterNm").val(oData.TRGTER_NM);
			$("#txtTrgterRrn1").val(oData.TRGTER_RRN_1);
			$("#txtTrgterRrn2").val(oData.TRGTER_RRN_2);
			$("#txtTrgterTel1").val(oData.TRGTER_TEL_1);
			$("#txtTrgterTel2").val(oData.TRGTER_TEL_2);
			$("#txtTrgterTel3").val(oData.TRGTER_TEL_3);
			$("#txtTrgterHpNo1").val(oData.TRGTER_HP_NO_1);
			$("#txtTrgterHpNo2").val(oData.TRGTER_HP_NO_2);
			$("#txtTrgterHpNo3").val(oData.TRGTER_HP_NO_3);
			$("#txtAdresZip").val(oData.ADRES_ZIP);
			$("#txtAdresAddr").val(oData.ADRES_ADDR);
			if(oData.TRGTER_TY_CD) {
				$("input:radio[name=rdoTrgterTyCd]:input[value="+oData.TRGTER_TY_CD+"]").prop("checked", true);
				$("input:radio[name=rdoTrgterTyCd]:input[value!="+oData.TRGTER_TY_CD+"]").prop("checked", false);
			} else {
				$('input:radio[name=rdoTrgterTyCd]').eq(0).prop("checked", true);
			}
		} else {
			fnSetReadOnly(false);
			$("#hidTrgterSn").val("");
			$("#txtTrgterNm").val("");
			$("#txtTrgterRrn1").val("");
			$("#txtTrgterRrn2").val("");
			$("#txtTrgterTel1").val("");
			$("#txtTrgterTel2").val("");
			$("#txtTrgterTel3").val("");
			$("#txtTrgterHpNo1").val("");
			$("#txtTrgterHpNo2").val("");
			$("#txtTrgterHpNo3").val("");
			$("#txtAdresZip").val("");
			$("#txtAdresAddr").val("");
			$('input:radio[name=rdoTrgterTyCd]').eq(0).prop("checked", true);
		}
	}

	function fnAdd() {
		if(fnIsEmpty($("#txtTrgterNm").val())) {
			alert("대상자 성명/법인명은(는) 필수입력 항목입니다.");
			$("#txtTrgterNm").focus();
			return;
		}
		// 2019-06-03
		if(fnIsEmpty($("#hidTrgterSn").val())) {
			if(!fnIsEmpty($("#txtTrgterRrn1").val()) || !fnIsEmpty($("#txtTrgterRrn2").val())) {
				if($("input:radio[name=rdoTrgterTyCd]:checked").val() == "I") {
					if(!fnCheckJumin()) return;
				} else {
					if(!fnCheckCorpNum()) return;
				}
			}
			if(!fnIsEmpty($("#txtTrgterTel1").val()) || !fnIsEmpty($("#txtTrgterTel2").val()) || !fnIsEmpty($("#txtTrgterTel3").val())) {
				if(!fnCheckTel()) return;
			}
			if(!fnIsEmpty($("#txtTrgterHpNo1").val()) || !fnIsEmpty($("#txtTrgterHpNo2").val()) || !fnIsEmpty($("#txtTrgterHpNo3").val())) {
				if(!fnCheckHpNo()) return;
			}
		}
		/* 2019-05-31
		if(fnIsEmpty($("#txtTrgterRrn1").val())) {
			alert("대상자 주민번호 앞자리은(는) 필수입력 항목입니다.");
			$("#txtTrgterRrn1").focus();
			return;
		}
		if(fnIsEmpty($("#txtTrgterRrn2").val())) {
			alert("대상자 주민번호 뒤자리은(는) 필수입력 항목입니다.");
			$("#txtTrgterRrn2").focus();
			return;
		}*/
		/* 2019-05-22
		if(!fnFormValueCheck("form_detail")) return;

		if(fnIsEmpty($("#hidTrgterSn").val())) {
			if(!fnCheckJumin()) return;
			if(!fnCheckTel()) return;
			if(!fnCheckHpNo()) return;

			if(fnIsEmpty($("#txtAdresAddr").val())) {
				alert("대상자 주소은(는) 필수입력 항목입니다.");
				$("#txtAdresAddr").focus();
				return;
			}
			if(fnIsEmpty($("#txtAdresZip").val())) {
				alert("대상자 우편번호은(는) 필수입력 항목입니다.");
				$("#txtAdresZip").focus();
				return;
			}
		}*/

		parent.ccdrTrgterPop.hide();
	}

	function fnCheckJumin() {
		//주민등록 번호 13자리를 검사한다.
		var fmt = /^\d{6}[1234]\d{6}$/;  //포멧 설정
		var str = $("#txtTrgterRrn1").val() + $("#txtTrgterRrn2").val();
		if (!fmt.test(str)) {
			alert("주민번호 형식에 맞지 않습니다.");
			return false;
		}
		// 생년월일 검사
		var birthYear = (str.charAt(6) <= "2") ? "19" : "20";
		birthYear += str.substr(0, 2);
		var birthMonth = str.substr(2, 2) - 1;
		var birthDate = str.substr(4, 2);
		var birth = new Date(birthYear, birthMonth, birthDate);
		if ( birth.getYear() % 100 != str.substr(0, 2) || birth.getMonth() != birthMonth || birth.getDate() != birthDate) {
			alert("주민번호 앞자리(생년월일)를  정확하게 입력하세요.");
			$("#txtTrgterRrn1").focus();
			return false;
		}
		// Check Sum 코드의 유효성 검사
		var buf = new Array(13);
		for (var i = 0; i < 13; i++) buf[i] = parseInt(str.charAt(i));
		multipliers = [2,3,4,5,6,7,8,9,2,3,4,5];
		for (var sum = 0, i = 0; i < 12; i++) sum += (buf[i] *= multipliers[i]);
		if ((11 - (sum % 11)) % 10 != buf[12]) {
			alert("주민번호를 정확하게 입력하세요.");
			$("#txtTrgterRrn2").focus();
			return false;
		}
		return true;
	}

	function fnCheckCorpNum() {//CorporationNumber
		var fmt = /^\d{13}$/;  //포멧 설정
		var str = $("#txtTrgterRrn1").val() + $("#txtTrgterRrn2").val();
		if (!fmt.test(str)) {
			alert("법인번호 형식에 맞지 않습니다.");
			return false;
		}

		var totalNumber = 0;
        var num = 0;
        for (i = 0; i < str.length-1; i++) {
            if (((i + 1) % 2) == 0) {
                num = parseInt(str.charAt(i)) * 2;
            } else {
                num = parseInt(str.charAt(i)) * 1;
            }
            if (num > 0) {
                totalNumber = totalNumber + num;
            }
        }
		totalNumber = (totalNumber%10 < 10) ? totalNumber%10 : 0;
        if (totalNumber != str.charAt(str.length-1)) {
            alert("유효하지 않은 법인번호입니다.");
            return false;
        }
        return true;
	}

	function fnCheckTel() {
		//var isTel1 = /^(0(2|3[1-3]|4[1-4]|5[1-5]|6[1-4]))$/.test($("#txtTrgterTel1").val());  // 국번
		/* if(!isTel1) {
			alert($("#txtTrgterTel1").attr("checkName")+"를 정확하게 입력하세요.");
			$("#txtTrgterTel1").focus();
			return false;
		} */
		if($("#txtTrgterTel1").val().length == 0) {
			alert($("#txtTrgterTel1").attr("checkName")+"를 선택하세요.");
			$("#txtTrgterTel1").focus();
			return false;
		}
		if($("#txtTrgterTel2").val().length < 3) {
			alert($("#txtTrgterTel2").attr("checkName")+"를 정확하게 입력하세요.");
			$("#txtTrgterTel2").focus();
			return false;
		}
		if($("#txtTrgterTel3").val().length < 4) {
			alert($("#txtTrgterTel3").attr("checkName")+"를 정확하게 입력하세요.");
			$("#txtTrgterTel3").focus();
			return false;
		}
		return true;
	}

	function fnCheckHpNo() {
		//var isTel2 = /^(?:(010)|(01[1|6|7|8|9]))$/.test($("#txtTrgterHpNo1").val());  // 휴대전화
		/*if(!isTel2) {
			alert($("#txtTrgterHpNo1").attr("checkName")+"를 정확하게 입력하세요.");
			$("#txtTrgterHpNo1").focus();
			return false;
		}*/
		if($("#txtTrgterHpNo1").val().length == 0) {
			alert($("#txtTrgterHpNo1").attr("checkName")+"를 선택하세요.");
			$("#txtTrgterHpNo1").focus();
			return false;
		}
		if($("#txtTrgterHpNo2").val().length < 3) {
			alert($("#txtTrgterHpNo2").attr("checkName")+"를 정확하게 입력하세요.");
			$("#txtTrgterHpNo2").focus();
			return false;
		}
		if($("#txtTrgterHpNo3").val().length < 4) {
			alert($("#txtTrgterHpNo3").attr("checkName")+"를 정확하게 입력하세요.");
			$("#txtTrgterHpNo3").focus();
			return false;
		}
		return true;
	}

	function jusoReturnValue (returnValue) {
		$("#txtAdresAddr").val(returnValue.addr);
		$("#txtAdresZip").val(returnValue.zipCd);
	}
</script>

<body>
<form id="form_detail" name="form_detail" method="post">
<input type="hidden" id="hidRcNo" name="hidRcNo" value="${hidRcNo}">
<input type="hidden" id="hidCaseNo" name="hidCaseNo" value="${hidCaseNo}">
<input type="hidden" id="hidTrgterSn" name="hidTrgterSn">
<input type="hidden" id="hidTrgterSe" name="hidTrgterSe" value="${hidTrgterSe}">

<!--팝업박스 -->
<div class="popup_body">
	<!--버튼 -->
	<!-- <div class="com_box  t_right">
		<div class="btn_box">
			<input type="hidden" id="txtCdNm" name="txtCdNm" maxlength="50" size="50" onkeypress="press(event);">
			<input type="button" name="input_button" value="검색"  class="btn_st3 icon_n fl mr_5" onclick="fnSearch();">
			<input type="button" name="input_button" value="선택 "  class="btn_st4 icon_n fl " onclick="fnSelect();">
		</div>
	</div> -->
	<!--//버튼  -->
	<div class="com_box ">
		<div class="title_s_st2 w_50p fl"><img src="/img/title_icon1.png" alt=""/>사건대상자 목록</div>
	</div>
	<!--테이블 시작 -->
	<div class="com_box mb_30">
		<div class="tb_01_box">
			<div id="grid_list" class="gridResize" style="width:100%; height:200px; margin:0 auto;"></div>
		</div>
	</div>

	<div class="com_box ">
		<div class="title_s_st2 w_50p fl"><img src="/img/title_icon1.png" alt=""/>압수대상자 상세정보</div>
		<div class="fr t_right">
			<input type="button" id="btnNew" value="신규" class="btn_st4 icon_n">
			<input type="button" id="btnAdd" value="압수대상자로 등록" class="btn_st4 icon_n" onclick="fnAdd();">
		</div>
	</div>

	<!--테이블 시작 -->
	<div class="com_box mb_5">
		<div class="tb_01_box">
			<table  class="tb_03">
				<colgroup>
					<col width="13%">
					<col width="27%">
					<col width="15%">
					<col width="15%">
					<col width="30%">
				</colgroup>
				<tbody>
					<tr>
						<th>성명/법인명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
						<td>
							<input type="text" id="txtTrgterNm" name="txtTrgterNm" class="w_100p input_com" check="text" checkName="대상자 성명/법인명"/>
						</td>
						<td>
							<div class='input_radio2 t_left'><input type="radio" name="rdoTrgterTyCd" value="I" class="to-labelauty-icon" checked/>개인</div>
							<div class='input_radio2 t_left'><input type="radio" name="rdoTrgterTyCd" value="E" class="to-labelauty-icon"/>법인</div>
						</td>
						<th>주민번호/법인번호</th>
						<td>
							<input type="text" id="txtTrgterRrn1" name="txtTrgterRrn1" class="w_100px input_com" maxlength="6" onkeyup="fnRemoveChar(event);" check="text" checkName="대상자 주민번호 앞자리"/>
							-
							<input type="text" id="txtTrgterRrn2" name="txtTrgterRrn2" class="w_100px input_com" maxlength="7" onkeyup="fnRemoveChar(event);" check="text" checkName="대상자 주민번호 뒤자리"/>
						</td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td colspan="2">
							<select name="txtTrgterTel1" id="txtTrgterTel1" class="w_70px input_com" check="text" checkName="대상자 전화번호 첫번째 자리">
								<option value="">=선택=</option><c:forEach var="cd" items="${telCdList}">
								<option value="${cd.cdNm}"><c:out value="${cd.cdNm}" /></option>
								</c:forEach>
							</select>
							-
							<input type="text" id="txtTrgterTel2" name="txtTrgterTel2" class="w_70px input_com" maxlength="4" onkeyup="fnRemoveChar(event);" check="text" checkName="대상자 전화번호 두번째 자리"/>
							-
							<input type="text" id="txtTrgterTel3" name="txtTrgterTel3" class="w_70px input_com" maxlength="4" onkeyup="fnRemoveChar(event);" check="text" checkName="대상자 전화번호 세번째 자리"/>
						</td>
						<th>휴대번호</th>
						<td>
							<select name="txtTrgterHpNo1" id="txtTrgterHpNo1" class="w_70px input_com" check="text" checkName="대상자 휴대번호 첫번째 자리">
								<option value="">=선택=</option><c:forEach var="cd" items="${hpNoCdList}">
								<option value="${cd.cdNm}"><c:out value="${cd.cdNm}" /></option></c:forEach>
							</select>
							-
							<input type="text" id="txtTrgterHpNo2" name="txtTrgterHpNo2" class="w_70px input_com" maxlength="4" onkeyup="fnRemoveChar(event);" check="text" checkName="대상자 휴대번호 두번째 자리"/>
							-
							<input type="text" id="txtTrgterHpNo3" name="txtTrgterHpNo3" class="w_70px input_com" maxlength="4" onkeyup="fnRemoveChar(event);" check="text" checkName="대상자 휴대번호 세번째 자리"/>
						</td>
					</tr>
					<tr>
						<th>주소</th>
						<td colspan="4"><div class="flex_r">
							<input type="text" id="txtAdresZip" name="txtAdresZip" class="w_80px input_com mr_5" />
							<input type="text" id="txtAdresAddr" name="txtAdresAddr" class="w_60p input_com" />
							<input type="button" id="btnAddr" class="btn_search" onclick="fnZipPop();"/>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!--테이블 시작 -->
</div>
<!--팝업박스 -->
</form>
</body>
</html>
