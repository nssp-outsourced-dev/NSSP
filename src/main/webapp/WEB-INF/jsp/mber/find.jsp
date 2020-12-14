<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

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

	        fnTabClick("A");
		});
	})

	function fnTabClick(arg){
		fnClear();
		if(arg == "A"){
	    	$("#tabId").attr("class","on");
	    	$("#tabPw").attr("class","");

	    	$("#divIdSearch").show();
	    	$("#divIdResult").hide();

	    	$("#divPwSearch").hide();
	    	$("#divPwResult").hide();
		}else{
        	$("#tabId").attr("class","");
        	$("#tabPw").attr("class","on");

	    	$("#divIdSearch").hide();
	    	$("#divIdResult").hide();
	    	
	    	$("#divPwSearch").show();
	    	$("#divPwResult").hide();	
		}
	}

	function fnClose(){
		parent.findPopup.hide();
	}

	function fnClear(){
		$('#txtUserId').val("");
		$('#txtUserNm').val("");
		$('#txtEmail').val("");
		$('#txtEmail1').val("");
		$('#txtEmail2').val("");

		$('#txtHpNo').val("");
		$('#txtHpNo1').val("");
		$('#txtHpNo2').val("");
		$('#txtHpNo3').val("");

		$("#divUserId").html("");
		$("#divRegDe").html("");
		
		//비밀번호 초기화관련
		$('#txtUserPw').val("");
		$('#hidUserPw').val("1");
		$('#divUserPw').html("");
		$('#txtUserRePw').val("");
		$('#hidUserRePw').val("1");
		$('#divUserRePw').html("");
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

	function fnSearchId(){
		if(fnFormValueCheck("frmSearchId")){
			$('#frmSearchId [name="hidFindNo"]').val("A");
			$('#txtHpNo').val($('#txtHpNo1').val()+"-"+$('#txtHpNo2').val()+"-"+$('#txtHpNo3').val());
			$('#txtEmail').val($('#txtEmail1').val()+"@"+$('#txtEmail2').val());

			var iUrl = '<c:url value='/member/findAjax/'/>';
	 		var queryString = $('#frmSearchId').serialize();
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					$("#divUserId").html(data.USER_ID);
					$("#divRegDe").html("(등록일 : "+data.WRITNG_DE+")");
			    	$("#divIdSearch").hide();
			    	$("#divIdResult").show();
				}else if(data.result == "-2"){
					alert("일치하는 사용자정보가 없습니다.");
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnSearchPw(){
		if(fnFormValueCheck("frmSearchPw")){
			$('#frmSearchPw [name="hidFindNo"]').val("B");				

			var iUrl = '<c:url value='/member/findAjax/'/>';
	 		var queryString = $('#frmSearchPw').serialize();
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
			    	$("#divPwSearch").hide();
			    	$("#divPwResult").show();	
				}else if(data.result == "-2"){
					alert("일치하는 사용자정보가 없습니다.");
				}else if(data.result == "-3"){
					alert("비밀번호 힌트가 일치하지 않습니다.");
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnChangePw(){
		if(fnFormValueCheck("frmSearchPw") && fnFormValueCheck("frmChangePw")){
			if(!($('#hidUserPw').val() == "0" && $('#hidUserRePw').val() == "0")){
				alert("비밀번호를 정확하게 입력하세요.");
				return;
			}

			$('#frmSearchPw [name="hidFindNo"]').val("C");

			var iUrl = '<c:url value='/member/findAjax/'/>';
	 		var queryString =  $('#frmSearchPw').serialize() +"&"+ $('#frmChangePw').serialize();
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					alert("비밀번호가 변경되었습니다.");
					fnClose();
				}else if(data.result == "-2"){
					alert("일치하는 사용자정보가 없습니다.");
				}else if(data.result == "-3"){
					alert("비밀번호 힌트가 일치하지 않습니다.");
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}


</script>

<div class="popup_body">
	<form id="frmSearchId" name="frmSearchId" method="post">
	<input type="hidden" id="hidFindNo" name="hidFindNo" value="">
	<div class="tab_box3">
		<ul>
			<li><a id="tabId" href="javascript:fnTabClick('A');" class="on">아아디 찾기</a></li>
			<li><a id="tabPw" href="javascript:fnTabClick('B');">비밀번호 찾기 </a></li>
		</ul>
	</div>
	<div id="divIdSearch" class="find_gpki_box ">
		<div class="inbox ">
			<div class='input_radio2 '>
				<input name="rd2" type="radio" class="to-labelauty-icon" />본인 GPKI 인증으로 찾기
			</div>
			<div class='input_radio2 '>
				<input class="to-labelauty-icon" type="radio" name="rd2" checked="checked" />본인 등록 정보로 찾기
			</div>
		</div>
		<div class="tb_01_box  mt_5">
			<table class="tb_03">
				<col width="100px" />
				<col width="" />
				<tbody>
					<tr>
						<th>성명</th>
						<td><input type="text" id=txtUserNm name="txtUserNm" class="w_50p input_com  mr_5" check="text" checkName="성명">
						</td>
					</tr>
					<tr>
						<th>휴대폰</th>
						<td>
							<input type="hidden" id="txtHpNo" name="txtHpNo">
							<select id="txtHpNo1" name="txtHpNo1" class="w_80px input_com r_radius_no  l_radius_no mr_5" check="text" checkName="휴대폰">
								<option value="" selected >선택</option>
								<c:forEach var="cd" items="${hpList}">
									<option value="${cd.cdNm}"><c:out value="${cd.cdNm}" /></option>	
								</c:forEach>
							</select>
							<input type="text" id="txtHpNo2" name="txtHpNo2" maxlength="4" class="w_80px input_com rl_radius_no mr_m1 onlyNumber" check="text" checkName="휴대폰"> -
							<input type="text" id="txtHpNo3" name="txtHpNo3" maxlength="4" class="w_80px input_com rl_radius_no mr_m1 onlyNumber" check="text" checkName="휴대폰">
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td>
							<input type="hidden" id="txtEmail" name="txtEmail">
							<input type="text" id="txtEmail1" name="txtEmail1" maxlength="20" value='' class="w_30p input_com " check="text" checkName="이메일">
							&#64;
							<input type="text" id="txtEmail2" name="txtEmail2" maxlength="20" value='' class="w_30p input_com " check="text" checkName="이메일">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="com_box t_center mt_10">
			<a href="javascript:fnSearchId();" class="btn_st2 icon_n">찾기</a>
		</div>
	</div>
	<div id="divIdResult" class="find_gpki_box mt_20">
		<div class="icon">
			<img src="/img/find_icon.png" alt="" />
		</div>
		<div class="tx">
			<Em>아이디 찾기 완료!</Em> 비밀번호 분실 시에는 <br> 비밀번호 찾기를 진행해주세요
		</div>
		<div class="r_inbox  mt_20">
			<div class="tx1">
				아이디는 <em id="divUserId"></em> 입니다.
			</div>
			<div class="tx1" id="divRegDe"></div>
		</div>
	</div>
	</form>

	<form id="frmSearchPw" name="frmSearchPw" method="post">
	<input type="hidden" id="hidFindNo" name="hidFindNo" value="">
	<div id="divPwSearch" class="find_gpki_box ">
		<div class="inbox">
			<div class='input_radio2 '>
				<input name="rd2" type="radio" class="to-labelauty-icon" /> 본인	GPKI 인증으로 찾기
			</div>
			<div class='input_radio2 '>
				<input class="to-labelauty-icon" type="radio" name="rd2" checked="checked" /> 본인 등록 정보로 찾기
			</div>
		</div>
		<div class="tb_01_box  mt_5">
			<table class="tb_03">
				<col width="130px" />
				<col width="" />
				<tbody>
					<tr>
						<th>아이디</th>
						<td><input type="text" id=txtUserId name="txtUserId" check="text" checkName="ID" class="w_50p input_com  mr_5"></td>
					</tr>
					<tr>
						<th>비밀번호 질문</th>
						<td>
							<select id="selpwQestnCd" name="selpwQestnCd" check="text" checkName="비밀번호 질문" class="w_100p input_com r_radius_no  l_radius_no mr_m1">
								<option value="">==선택하세요==</option>
								<c:forEach var="cd" items="${findList}">
									<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>	
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>비밀번호 정답</th>
						<td><input type="text" id=txtpwQestnAnswer name="txtpwQestnAnswer" check="text" checkName="비밀번호 답변" class="w_50p input_com  mr_5"></td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="com_box t_center mt_10">
			<a href="javascript:fnSearchPw();" class="btn_st2 icon_n">찾기</a>
		</div>
	</div>
	</form>

	<form id="frmChangePw" name="frmChangePw" method="post">
	<div id="divPwResult">
		<div class="find_gpki_box mt_20">
			<div class="icon">
				<img src="/img/find_icon.png" alt="" />
			</div>
			<div class="tx">
				<Em>비밀번호 찾기 인증에 성공 하셨습니다.</Em> 비밀번호를 재설정해 주세요.
			</div>
		</div>
	
		<div class="tb_01_box  mt_20">
			<table class="tb_03">
				<col width="150px" />
				<col width="" />
				<tbody>
					<tr>
						<th>새 비밀번호 *</th>
						<td>						
							<input type="hidden" id="hidUserPw" name="hidUserPw" value="1">
							<input type="password" id="txtUserPw" name="txtUserPw" maxlength="20" check="text" checkName="비밀번호" class="w_50p input_com l_radius_no mr_5">
							<div id="divUserPw"></div>
						</td>
					</tr>
					<tr>
						<th>새 비밀번호 확인 *</th>
						<td>
							<input type="hidden" id="hidUserRePw" name="hidUserRePw" value="1">	
							<input type="password" id="txtUserRePw" name="txtUserRePw" maxlength="20" check="text" checkName="비밀번호 확인" class="w_50p input_com l_radius_no  mr_5">
							<div id="divUserRePw"></div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	
		<div class="r_inbox2">
			<ul>
				<li>영문,숫자,특수문자 조합 8~16자리로 설정하세요.</li>	
				<li>개인정보와 관련된 숫자, 연속된 숫자와 같이 쉬운 비밀번호는 다른 사람이 쉽게 알아낼 수 있으니 사용을 자제해 주세요.</li>
			</ul>
		</div>
	
		<div class="com_box t_center mt_10">
			<input type="submit" name="input_button" value="확인" class="btn_st2 icon_n " onclick="fnChangePw();"> <a href="#" class="btn_st2 icon_n">취소</a>
		</div>
	</div>
	</form>	
</div>
