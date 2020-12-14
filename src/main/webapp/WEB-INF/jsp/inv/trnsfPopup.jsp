<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp" />
<style>
.grid_td_left {
	text-align: left
}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		fnDatePickerImg("calTrnsfDe", null, false);
		fnUpCdList("00768", $("#selResnCd"));  // 이송사유코드
		
		$('#txtResnDc').keyup(function(){
			fnLimitString('txtResnDc', 200, 'txtResnDcMsg');
		});	
		
		$('#calTrnsfDe').val("${trnsf.TRNSF_DE}");
		$('#selResnCd').val("${trnsf.TRNSF_RESN_CD}");
	});
	
	function fnSave() {
		// 필수 체크
		var str = $("input:radio[name=rdoInsttSeCd]:checked").val();
		if(fnIsEmpty(str)) {
			alert("이송기관구분은(는) 필수입력 항목입니다.");
			$("input:radio[name=rdoInsttSeCd]").focus();
			return;
		}
		if(!fnFormValueCheck("form_detail")) return;
		if(!fnCheckDate($("#calTrnsfDe"))) return;

		parent.trnsfPopup.hide();
	}	
</script>

<body>
<form id="form_detail" name="form_detail" method="post">
	<input type="hidden" id="hidRcNo" name="hidRcNo" value="${hidRcNo}">
	<input type="hidden" id="hidTrgterSn" name="hidTrgterSn">
	<input type="hidden" id="hidTrgterSe" name="hidTrgterSe" value="${hidTrgterSe}">

	<!--팝업박스 -->
	<div class="popup_body">
		<div class="com_box ">
			<div class="title_s_st2 w_50p fl">
				<img src="/img/title_icon1.png" alt="" />타기관 이송 정보
			</div>
			<div class="fr t_right">
			<c:if test="${trnsf.TRNSF_SN eq null}">
				<input type="button" id="btnSave" value="저장" class="btn_st4 icon_n" onclick="fnSave();">
			</c:if>				
			</div>
		</div>
		<!--테이블 시작 -->
		<div class="com_box">
			<div class="tb_01_box">
				<table class="tb_01_h100">
				<col width="17%" />
				<col width="18%" />
				<col width="65%" />
				<tbody>
					<tr>
						<th colspan="2">이송일자<span class="point"><img src="/img/point.png"  alt=""/></span></th>
						<td>
							<div class="calendar_box  w_150px  mr_5">
							<input type="text" name="calTrnsfDe" id="calTrnsfDe" class="w_100p input_com calendar" readonly check="text" checkName="이송일자" value="${trnsf.TRNSF_DE}">
							<!-- <div class="calendar_icon"><img src="/img/search_calendar.png" alt="" /></div> -->
							</div>
						</td>
					</tr>
					<tr class="h_40px">
						<th colspan="2">이송기관구분<span class="point"><img src="/img/point.png"  alt=""/></span></th>
						<td>
							<c:forEach var="list" items="${trnsfInsttSeCdList}" varStatus="status">
							<div class='input_radio2 t_left'><input type="radio" name="rdoInsttSeCd" class="to-labelauty-icon" value="${list.cd}" <c:if test="${trnsf.TRNSF_INSTT_SE_CD eq list.cd}">checked</c:if>>${list.cdNm}</div>
							</c:forEach>
						</td>
					</tr>
					<tr class="h_40px">
						<th rowspan="3">이송기관정보</th>
						<th>기관명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
						<td><input type="text" name="txtInsttNm" id="txtInsttNm" maxlength="50" class="w_100p input_com" check="text" checkName="이송기관명" value="${trnsf.TRNSF_INSTT_NM}"></td>
					</tr>
					<tr class="h_40px">
						<th>부서<span class="point"><img src="/img/point.png"  alt=""/></span></th>
						<td><input type="text" name="txtInsttDept" id="txtInsttDept" maxlength="50" class="w_100p input_com" check="text" checkName="이송기관 부서" value="${trnsf.TRNSF_INSTT_DEPT}"></td>
					</tr>
					<tr class="h_40px">
						<th>담당자<span class="point"><img src="/img/point.png"  alt=""/></span></th>
						<td><input type="text" name="txtInsttCharger" id="txtInsttCharger" maxlength="25" class="w_100p input_com" check="text" checkName="이송기관 담당자" value="${trnsf.TRNSF_INSTT_CHARGER}"></td>
					</tr>
					<tr class="h_40px">
						<th colspan="2" rowspan="2">이송사유<span class="point"><img src="/img/point.png"  alt=""/></span><br/>
							<span id="txtResnDcMsg" style="margin-top:5px;"></span></th>
						<td><select name="selResnCd" id="selResnCd" class="w_200px input_com" check="text" checkName="이송사유"></select></td>
					</tr>
					<tr class="h_80px">
						<td><textarea id="txtResnDc" name="txtResnDc" maxlength="200">${trnsf.TRNSF_RESN_DC}</textarea></td>
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
