<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript" src="/js/gpki/var.js"></script>
<script type="text/javascript" src="/js/gpki/json2.js"></script>
<script type="text/javascript" src="/js/gpki/ui/Issuer.js" ></script>
<script type="text/javascript" src="/js/gpki/ui/CertSelector_ko-KR.js"></script>
<script type="text/javascript" src="/js/gpki/ui/CertSearchWindow_ko-KR.js" ></script>
<script type="text/javascript" src="/js/gpki/ui/CertSearchWindow_ko-KR.js" ></script>
<script type="text/javascript" src="/js/gpki/ui/certviewR_ko-KR.js" ></script>
<script type="text/javascript" src="/js/gpki/ui/pinWindowR_ko-KR.js" ></script>
<script type="text/javascript" src="/js/gpki/ui/SecureTokenWindow_ko-KR.js" ></script>
<script type="text/javascript" src="/js/gpki/GPKIErrorText.js" ></script>
<script type="text/javascript" src="/js/gpki/GPKISecureWebNP.js?jsessionid=${sessionid}"></script>
<link rel="stylesheet" type="text/css" href="/css/gpki/style.css" />
<link rel="stylesheet" type="text/css" href="/css/gpki/gsw-jquery-ui.min.css"/>

<script type="text/javascript">
	$(function() {
		$(document).ready(function(){
			fnIdClear(true);

	        $('#txtUserPw').keyup(function () {
	        	fnUserPwKeyup("txtUserPw", "divUserPw", "hidUserPw");
	        	fnUserRePwKeyup("txtUserPw", "txtUserRePw", "divUserRePw", "hidUserRePw");
	        });

	        $('#txtUserRePw').keyup(function () {
	        	fnUserRePwKeyup("txtUserPw", "txtUserRePw", "divUserRePw", "hidUserRePw");
	        });

	        if(!fnIsEmpty($.trim('${gpkiJoinMsg}'))) {
				if('${gpkiJoinMsg}' == "888") alert("인증서 등록이 완료되었습니다.\n\n관리자의 승인이 완료된 후 로그인 가능합니다.");
				else if ('${gpkiJoinMsg}' == "999") alert("인증서 등록 중 오류가 발생되었습니다.\n\n관리자의 승인 후, 사용자정보 수정화면에서 재등록해 주십시오.");
				fnClose ();
			}
		});
	})

	function fnClose(){
		parent.joinPopup.hide();
	}

	function fnClear(){
		$('#hidEsntlID').val("");

		$('#txtUserId').val("");
		fnIdClear(true);

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
		$('#txtEmail2').val("korea.kr");

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


		//비밀번호 초기화관련
		$('#txtUserPw').val("");
		$('#hidUserPw').val("1");
		$('#divUserPw').html("");
		$('#txtUserRePw').val("");
		$('#hidUserRePw').val("1");
		$('#divUserRePw').html("");
	}

	function fnAdd(){
		if(fnFormValueCheck("addForm")){
			if(!($('#hidUserPw').val() == "0" && $('#hidUserRePw').val() == "0")){
				alert("비밀번호를 정확하게 입력하세요.");
				return;
			}
			if(confirm("가입신청을 진행하시겠습니까?")){
				$('#txtEmail').val($('#txtEmail1').val()+"@"+$('#txtEmail2').val());
				$('#txtHpNo').val($('#txtHpNo1').val()+"-"+$('#txtHpNo2').val()+"-"+$('#txtHpNo3').val());
				$('#txtTelNo').val($('#txtTelNo1').val()+"-"+$('#txtTelNo2').val()+"-"+$('#txtTelNo3').val());

				var iUrl = '<c:url value='/member/joinAjax/'/>';
		 		var queryString =  $('#addForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						//alert("가입신청이 완료되었습니다.\n\r\n\r가입승인이 완료되면 로그인이 가능합니다.");
						//fnClose();
						alert("가입신청이 완료되었습니다.\n\r\n\rGPKI 등록을 시작합니다.\n\r\n\r*GPKI가 없으신 경우, 차후 사용자 정보 수정 화면에서 등록가능합니다.");
						runGPKI();
				    	document.GpkiLoginForm.action = "/member/actionGPKIjoinDN/";
				    	document.GpkiLoginForm.hidGpkiID.value = document.addForm.txtUserId.value;
				    	document.GpkiLoginForm.hidGpkiPw.value = document.addForm.txtUserPw.value;
				    	Login(this,document.getElementById('GpkiLoginForm'),false);
					}else if(data.result == "-2"){
						alert("필수 입력값이 누락되었습니다.");
					}else if(data.result == "-3"){
						alert("동일한 ID가 존재합니다.");
					}else{
						alert("회원가입중 오류가 발생하였습니다.");
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

	/* function fnCheckGpkiDn () {
		if(fnFormValueCheck("addForm")){
			if(!($('#hidUserPw').val() == "0" && $('#hidUserRePw').val() == "0")){
				alert("비밀번호를 정확하게 입력하세요.");
				return;
			}
			if(confirm("가입신청을 진행하시겠습니까?")){
				$('#txtEmail').val($('#txtEmail1').val()+"@"+$('#txtEmail2').val());
				$('#txtHpNo').val($('#txtHpNo1').val()+"-"+$('#txtHpNo2').val()+"-"+$('#txtHpNo3').val());
				$('#txtTelNo').val($('#txtTelNo1').val()+"-"+$('#txtTelNo2').val()+"-"+$('#txtTelNo3').val());

				var iUrl = '<c:url value='/member/joinAjax/'/>';
		 		var queryString =  $('#addForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						alert("가입신청이 완료되었습니다.\n\r\n\rGPKI 등록을 시작합니다.\n\r\n\r*GPKI가 없으신 경우, 차후 사용자 정보 수정 화면에서 등록가능합니다.");
						runGPKI();
				    	document.GpkiLoginForm.action = "/member/actionCheckGPKIDn/";
				    	document.GpkiLoginForm.hidGpkiID.value = document.addForm.txtUserId.value;
				    	document.GpkiLoginForm.hidGpkiPw.value = document.addForm.hidUserPw.value;
				    	Login(this,document.getElementById('GpkiLoginForm'),false);
					}else if(data.result == "-2"){
						alert("필수 입력값이 누락되었습니다.");
					}else if(data.result == "-3"){
						alert("동일한 ID가 존재합니다.");
					}else{
						alert("회원가입중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
            }
		}
	} */

</script>

<!--팝업박스 -->
<div class="popup_body">

	<div class="title_s_st3 "><img src="/img/icon_error.png" alt=""/>  * 는 필수정보로서 반드시 입력하여야 합니다.</div>

	<form id="addForm" name="addForm" method="post">
	<input type="hidden" id="hidEsntlID" name="hidEsntlID">
	<!--테이블 시작 -->
	<div class="tb_01_box">
		<table  class="tb_01">
			<col width="25%"/>
			<col width=""/>
			<tbody>
			<tr>
				<th>사용자 ID<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<input type="text" id="txtUserId" name="txtUserId" maxlength="20" class="w_150px input_com notHangul" check="text" checkName="ID">
					<input type="button" id="btnIdDplct" value="중복확인" class="btn_text" onclick="fnIdDplctCheck();" >
					<input type="button" id="btnIdClear" value="초기화" class="btn_text" onclick="fnIdClear(true);" >
				</td>
			</tr>
			<tr>
				<th>성명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<input type="text" id=txtUserNm name="txtUserNm" maxlength="20" class="w_50p input_com" check="text" checkName="성명">
				</td>
			</tr>
			<tr>
				<th>비밀번호<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<input type="hidden" id="hidUserPw" name="hidUserPw" value="1">
					<input type="password" id="txtUserPw" name="txtUserPw" maxlength="20" class="w_150px input_com " check="text" checkName="비밀번호" style="color: black !important;" />
					<div id="divUserPw" style="display:inline;"></div>
				</td>
			</tr>
			<tr>
				<th>비밀번호 확인<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<input type="hidden" id="hidUserRePw" name="hidUserRePw" value="1">
					<input type="password" id="txtUserRePw" name="txtUserRePw" maxlength="20" class="w_150px input_com " check="text" checkName="비밀번호 확인" style="color: black !important;" />
					<div id="divUserRePw" style="display:inline;"></div>
				</td>
			</tr>
			<tr>
				<th>비밀번호 질문<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<select id="selpwQestnCd" name="selpwQestnCd" class="w_50p input_com" check="text" checkName="비밀번호 질문">
						<option value="">==선택하세요==</option>
						<c:forEach var="cd" items="${qestnList}">
							<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>비밀번호 답변<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<input type="text" id=txtpwQestnAnswer name="txtpwQestnAnswer" maxlength="100" class="w_50p input_com" check="text" checkName="비밀번호 답변">
				</td>
			</tr>
			<tr>
				<th>소속<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<div class="flex_r">
						<input type="text" id="txtDeptNm" name="txtDeptNm" class="w_200px input_com" check="text" checkName="부서" readonly>
						<input type="hidden" id="hidDeptCd" name="hidDeptCd">
						<input type="button" value="조직조회" class="btn_text" onclick="fnDeptSelect();">
					</div>
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
			</tr>
			<tr>
				<th>직책<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<select id="selRspofcCd" name="selRspofcCd" class="w_150px input_com" check="text" checkName="직책">
						<option value="">==선택하세요==</option>
						<c:forEach var="cd" items="${rspofcList}">
							<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>휴대폰<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td>
					<input type="hidden" id="txtHpNo" name="txtHpNo">
					<select id="txtHpNo1" name="txtHpNo1" size="1" class="w_80px input_com mr_5" check="text" checkName="휴대폰">
						<option value="" selected >선택</option>
						<c:forEach var="cd" items="${hpList}">
							<option value="${cd.cdNm}"><c:out value="${cd.cdNm}" /></option>
						</c:forEach>
					</select>
					<input type="text" id="txtHpNo2" name="txtHpNo2" maxlength="4" value='' class="w_80px input_com onlyNumber" check="text" checkName="휴대폰">
					-
					<input type="text" id="txtHpNo3" name="txtHpNo3" maxlength="4" value='' class="w_80px input_com onlyNumber" check="text" checkName="휴대폰">
				</td>
			</tr>
			<tr>
				<th>연락처</th>
				<td>
					<input type="hidden" id="txtTelNo" name="txtTelNo">
					<select id="txtTelNo1" name="txtTelNo1" size="1" class="w_80px input_com mr_5">
						<option value="" selected >선택</option>
						<c:forEach var="cd" items="${telList}">
							<option value="${cd.cdNm}"><c:out value="${cd.cdNm}" /></option>
						</c:forEach>
					</select>
					<input type="text" id="txtTelNo2" name="txtTelNo2" maxlength="4" value='' class="w_80px input_com onlyNumber">
					-
					<input type="text" id="txtTelNo3" name="txtTelNo3" maxlength="4" value='' class="w_80px input_com onlyNumber">
				</td>
			</tr>
			<tr>
				<th>이메일주소</th>
				<td>
					<input type="hidden" id="txtEmail" name="txtEmail">
					<input type="text" id="txtEmail1" name="txtEmail1" maxlength="20" value='' class="w_30p input_com ">
					&#64;
					<input type="text" id="txtEmail2" name="txtEmail2" maxlength="20" value='korea.kr' class="w_30p input_com ">
				</td>
			</tr>
			<tr>
				<th>담당업무</th>
				<td><input type="text" id=txtChrgJob name="txtChrgJob" maxlength="50" class="w_50p input_com"></td>
			</tr>
			<tr>
				<th>주소</th>
				<td>
				<input type="text" id="txtResdncZip" name="txtResdncZip" maxlength="10" class="w_100px input_com" /> <!-- onclick="fnZipPop()" -->
				<input type="button" value="" class="btn_search" onclick="fnZipPop();">
				<input type="text" id="txtResdncAddr" name="txtResdncAddr" maxlength="500" class="w_50p input_com"/>
				</td>
			</tr>
			<tr class="h_40px">
				<th>GPKI등록</th>
				<td>GPKI등록은 가입버튼을 클릭하시면 자동으로 진행됩니다.</td>
			</tr>
		</tbody>
		</table>

			<div class="com_box  t_center mt_10">
				<div class="btn_box">
					<input type="button" id="btnAdd" value="가입" class="btn_st2 icon_n" onclick="fnAdd();">
					<input type="button" id="btnClear" value="초기화" class="btn_st2 icon_n" onclick="fnClear();">
				</div>
			</div>

<!--
		<div class="tb_01_box">
			<table  class="tb_01">
				<col width="15%"/>
				<col width=""/>
				<tbody>
				<tr>
					<th>인증서</th>
					<td>미등록
					<a href=""  class="btn_st1 icon_n  fr">GPKI 인증서 등록</a>
					</td>
				</tr>
				</tbody>
			</table>

			<div class="info_box mt_10">
				<div class="title_s_st2 fl "><img src="/img/title_icon1.png" alt=""/> 개인정보 제공ㆍ활용 동의서 </div>
				<div class="indiv">여기에  class "indiv"의 내용 입력</div>
			</div>
		</div>
-->
	</div>
	</form>
	<form id="GpkiLoginForm" name="GpkiLoginForm" method="post">
		<input type="hidden" name="hidGpkiID" id="hidGpkiID"/>
		<input type="hidden" name="hidGpkiPw" id="hidGpkiPw"/>
		<input disabled type="hidden" name="challenge" value="${challenge}" />
		<input type="hidden" name="sessionid" id="sessionid" value="${sessionid}">
	</form>
<!--팝업박스 -->
</div>