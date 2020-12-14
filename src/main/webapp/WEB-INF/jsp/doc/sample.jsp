<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">


	$(document).ready(function(){
		/*
		* 작성화면에 iframe으로 문서관리 삽입
		* 필요 parameter
		1. iframe name
		2. doc_id(문서아이디) -  각 업무에서 바로 생성해서 저장(docService.getDocID())
		3. format_cl_cd(서식분류코드) - 업무에 해당하는 서식분류
		4. oz param(ozreport param)
		*/

		//작성용
		fnReportList('ifrReport','00000000000000002231','00452','P_TRN_NO=2019-000018');

		//fnReportList('ifrReport','00000000000000000001','00445','P_RC_NO=2018000001&P_TRGTER_SN=13'); //진술조서

		//조회용
		//fnReportListView('ifrReport','00000000000000000001');
	});


	function fnSelectCd(upcd, cd, nm){
		alert("선택:"+upcd+"/"+cd+"/"+nm);
	}
	function fnSelectDept(upcd, cd, nm){
		alert("선택:"+upcd+"/"+cd+"/"+nm);
	}
	function fnSelectExmn(upcd, cd, nm){
		alert("선택:"+upcd+"/"+cd+"/"+nm);
	}
	function fnSelectViolt(upcd, cd, nm){
		alert("선택:"+upcd+"/"+cd+"/"+nm);
	}

	//gbn R(접수), I(입건)
	//ret N(바로저장), Y(리턴값)
	function fnSelectAlot(snNo, userId, userNm, deptCd, deptNm, alotSeCd){
		alert("선택:"+userId+"/"+userNm+"/"+deptCd+"/"+deptNm);
	}
</script>


	<p class="btn_area">
		<input type="button" id="11" value="코드검색" class="btn" onclick="fnCdSelect('00300'); ">
		<input type="button" id="11" value="코드한개검색" class="btn" onclick="fnCdSelectSingle('00300'); ">
		<input type="button" id="22" value="부서검색" class="btn" onclick="fnDeptSelect();">
		<input type="button" id="33" value="검찰검색" class="btn" onclick="fnExmnSelect();">
		<input type="button" id="33" value="위반사항검색" class="btn" onclick="fnVioltSelect();">

		<input type="button" id="33" value="접수배당-저장방식" class="btn" onclick="fnAlotSelect('2019-000121','R','N');">
		<input type="button" id="33" value="접수배당-리턴방식" class="btn" onclick="fnAlotSelect('2019-000121','R','Y');">

		<input type="button" id="33" value="수사배당-저장방식" class="btn" onclick="fnAlotSelect('2019-000121','I','N');">
		<input type="button" id="33" value="수사배당-리턴방식" class="btn" onclick="fnAlotSelect('2019-000121','I','Y');">

		<input type="button" id="33" value="배당이력조회" class="btn" onclick="fnAlotHistory('2019-000121');">
		<input type="button" id="44" value="한글기안기" class="btn" onclick="fnHwpctrl();">

	</p></p>

	<div>
		<!--
		iframe width, height 각 화면에 맞게 직접 지정
		 -->
		<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="1000px" height="350px"></iframe>
	</div>

<script type="text/javascript">
	$(document).ready(function(){


		//달력
		fnRealDatePicker("txtDate1","divCal1");
		fnRealDateTimePicker("txtDate2","divCal2");


	});
	/* function fnHwpctrl () {
		var strStatus = "width=1000,height=1000,toolbar=no,status=no,location=no,scrollbars=yes,resizable=yes";
		//window.open('/doc/hwpctrlPopup/?docId=00000000000000000001&pblicteSn=43', 'reportInput', strStatus);

		window.open('/doc/hwpctrlPopup/?docId=00000000000000000415&pblicteSn=2', 'reportInput', strStatus);
	} */
</script>
<!--검색박스 -->
<div class="search_box mb_30">

	<div class="search_in">
		<div class="stitle w_150px">번호/일자 검색구분</div>
		<div class="r_box  w_300px">
			<div class="tl_box">
				<div class="tt">접수일자</div>
					<div class="td2">
					<div class="input_out w_45p fl">

						<input type="text" class="w_100p input_com_s datetimepicker" id="txtDate1" value="2017-03-02">
						<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" alt=""/></div>
						<div id="divCal1" class="calendarOverlay"></div>

					</div> ~
					<div class="input_out w_45p">

						<input type="text" class="w_200p input_com_s datetimepicker" id="txtDate2" value="2017-03-02 13:20:44">
						<div class="calendar_icon datetimepicker"><img src="/img/search_calendar.png" alt=""/></div>
						<div id="divCal2" class="calendarOverlay"></div>
					</div>
				</div>
			</div>
		</div>

	</div>
	<div class="go_search2">검색</div>
</div>

