<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
	var faceing = false;
	$(function() {
		$(document).ready(function(){
			$('#txtID').focus();
		    $("input[name=txtID]").keydown(function (key) {
		        if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
		            fnLogin();
		        }
		    });
		    $("input[name=txtPw]").keydown(function (key) {
		    	if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
		            fnLogin();
		        }
		    });

	        var sUserId = getCookie("cookieLoginUserId");
	        if(sUserId != ""){
		        $("input[id='txtID']").val(sUserId);
	            $("#chkIdSave").attr("checked", true);

	          	//아이디를 저장하기가 체크되어 있을 경우만 GPKI 자동 활성화
				//fnGpkiRun ();
	        }

	        if(!fnIsEmpty($.trim('${gpkiResult}'))) {
	        	if('${gpkiResult}'=="-2") alert("1단계 로그인이 진행되지 않았습니다.\n\nID와 PASSWORD를 입력 후 로그인을 해주세요.");
	        	else alert('등록된 인증서가 아닙니다.\n\n인증서 등록 후 사용하여 주십시오.');
	        }
			if(!fnIsEmpty($.trim('${gpkiReg}'))) alert('${gpkiReg}');
		});
	});

	function fnLogin() {
		if($('#txtID').val() == ""){
			alert('아이디를 입력하세요.');
			$('#txtID').focus();
			return;
		}
		if($('#txtID').val().match(/\s/g)){
			alert('아이디에 공백을 사용할 수 없습니다.');
			$('#txtID').focus();
			return false;
		}
		if($('#txtPw').val() == ""){
			alert('비밀번호를 입력하세요.');
			$('#txtPw').focus();
			return;
		}

        if($("#chkIdSave").is(":checked")) {
            var sUserId = $("input[id='txtID']").val();
            setCookie("cookieLoginUserId", sUserId, 365);
        }else{
            deleteCookie("cookieLoginUserId");
        }

		var iUrl = '<c:url value='/member/loginAjax/'/>';
 		var queryString =  $('#frmLogin').serialize();
 		var processAfterGet = function(data) {
			if(data.result == "1"){
				$(location).attr('href', "/main/intro/");
			}else if(data.result == "-2"){
				alert("존재하지 않는 ID입니다.");
			}else if(data.result == "-3"){
				alert("비밀번호가 일치하지 않습니다.");
			}else if(data.result == "-4"){
				alert("사용이 중지된 사용자입니다.");
			}else if(data.result == "-5"){
				alert("회원가입 승인이 진행되지 않았습니다.");
			}else if(data.result == "-7"){
				alert("1단계 로그인이 완료되었습니다.\n\n2단계 로그인을 진행 해주세요.\n(GPKI, 지문, 얼굴 중 선택하여 로그인을 진행해 주세요.)");
			}else{
				alert("로그인중 오류가 발생하였습니다.");
			}
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnJoin(){
		joinPopup = dhtmlmodal.open('reportInput', 'iframe', '/member/joinPopup/', '사용자 등록', 'width=800px,height=750px,center=1,resize=0,scrolling=1')
		joinPopup.onclose = function(){
			return true;
		}
	}

	function fnFind(){
		findPopup = dhtmlmodal.open('reportInput', 'iframe', '/member/findPopup/', '아이디/비밀번호 찾기', 'width=500px,height=500px,center=1,resize=0,scrolling=1')
		findPopup.onclose = function(){
			return true;
		}
	}

	function setCookie(cookieName, value, exdays){
        var exdate = new Date();
        exdate.setDate(exdate.getDate() + exdays);
        var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
        document.cookie = cookieName + "=" + cookieValue;
    }

    function deleteCookie(cookieName){
        var expireDate = new Date();
        expireDate.setDate(expireDate.getDate() - 1); //어제날짜를 쿠키 소멸날짜로 설정
        document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
    }

    function getCookie(cookieName) {
        cookieName = cookieName + '=';
        var cookieData = document.cookie;
        var start = cookieData.indexOf(cookieName);
        var cookieValue = '';
        if(start != -1){
            start += cookieName.length;
            var end = cookieData.indexOf(';', start);
            if(end == -1)end = cookieData.length;
            cookieValue = cookieData.substring(start, end);
        }
        return unescape(cookieValue);
    }

    function fnFaceLoginBf (pTy) {
    	if(faceing) {
    		alert ("직전에 시도한  생체인식 로그인이 정상 종료되지 않았습니다.\n\n2분 후 다시 시도해주십시오.");
    		return;
    	}    	
		if($("#chkIdSave").is(":checked")) {
    		if(fnIsEmpty($("#txtID").val())) {
    			alert("ID가 확인되지 않습니다. ID를 먼저 입력하여 주십시오.");
    			return;
    		}
    		if(pTy == "fc") fnFaceLogin ();
    		else fnFingerLogin ();
    	} else {
    		//2단계 로그인 시 1단계 로그인이 진행되었는지 체크
    		var processAfterGet = function(data) {
    				if(!fnIsEmpty(data.result)) {
    					if (data.result == "-2") {
    						alert("1단계 로그인이 진행되지 않았습니다.\n\nID와 PASSWORD를 입력 후 로그인을 해주세요.");
    						$('#txtID').focus();
    						return;
    					} else {
    						if(pTy == "fc") fnFaceLogin ();
    						else fnFingerLogin ();
    					}
    				} else {
    					alert("로그인 확인 오류!");
    					return;
    				}
    	    };
    		Ajax.getJson("<c:url value='/member/sessionCheckAjax/'/>", "txtID="+$('#txtID').val(), processAfterGet);
    	}
	}

    function fnFaceLogin () {    	
		<%
			int fCount = 5;
			String fRNDValue = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz";
			int fMAX_LNG = 15;
			StringBuffer fTemp = new StringBuffer();
			java.util.Random frandom = new java.util.Random();
			for(int i=1; i<fCount; i++){
				for(int j=1; j<fMAX_LNG; j++){
					int fRnd = frandom.nextInt(62);
					fTemp.append(fRNDValue.substring(fRnd, fRnd+1));
				}
			}
		%>
		var strCoo = "<%=fTemp%>";
		var esId = "GNRL0000000000000000";

		//alert("strCoo:"+strCoo);

		faceing = true;

		$("#ifameRun").remove();
    	var iframe = $("<iframe id='ifameRun' />").attr("src","cuface://1"+esId+strCoo);
    	$(document).find("body").append(iframe);
		
		var chkBiostep = "";
		if($("#chkIdSave").is(":checked")) {
    		if(fnIsEmpty($("#txtID").val())) {
    			alert("ID가 확인되지 않습니다. ID를 먼저 입력하여 주십시오.");
    			return;
    		}
    		chkBiostep = "1";
    	}

    	setTimeout(function() {
    		var processAfterGet = function(data) {
    			faceing = false;
    			if(!fnIsEmpty(data.rstans) && data.rstans) {
	     			if(!fnIsEmpty(data.result)) {
	     				if(data.result == "1") {
	     					//새로고침 - 메인으로
	     					$(location).attr('href', "/main/intro/");
	     				} else if (data.result == "-2") {
	     					alert("1단계 로그인이 진행되지 않았습니다.\n\nID와 PASSWORD를 입력 후 로그인을 해주세요.");
	     					$('#txtID').focus();
	     					return;
	     				} else {
	     					alert("일치하는 face id 가 없습니다.\n\n다시 시도해 주세요.");
	     				}
	     			} else {
	     				alert("일치하는 face id 가 없습니다.\n\n다시 시도해 주세요.");
	     			}
    			} else {
    				if (data.result == "99999") {
     					alert("시간이 초과되었습니다. 다시 시작하여 주십시오.");
     				}
    				//alert("ID/PASSWORD 로그인 후 게시판에서 얼굴 로그인 설치파일을 설치 후 진행해주세요.");
    			}
    	    };
    		Ajax.getBioJson("<c:url value='/member/faceLoginAjax/'/>", "txtID="+$('#txtID').val()+"&strCoo="+strCoo+"&chkBiostep="+chkBiostep, processAfterGet);
        }, 200);  /*0.2초 후 실행*/
    }

    function fnFingerLogin () {
		<%
			int gCount = 5;
			String gRNDValue = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz";
			int gMAX_LNG = 15;
			StringBuffer gTemp = new StringBuffer();
			java.util.Random grandom = new java.util.Random();
			for(int i=1; i<gCount; i++){
				for(int j=1; j<gMAX_LNG; j++){
					int gRnd = grandom.nextInt(62);
					gTemp.append(gRNDValue.substring(gRnd, gRnd+1));
				}
			}
		%>
		var strCoo = "<%=gTemp%>";
		var esId = "GNRL0000000000000000";
		faceing = true;
    	$("#ifameRun").remove();
    	var iframe = $("<iframe id=\"ifameRun\" />").attr("src","cufinger://1"+esId+strCoo);
    	$(document).find("body").append(iframe);
    	
    	var chkBiostep = "";
		if($("#chkIdSave").is(":checked")) {
    		if(fnIsEmpty($("#txtID").val())) {
    			alert("ID가 확인되지 않습니다. ID를 먼저 입력하여 주십시오.");
    			return;
    		}
    		chkBiostep = "1";
    	}

    	setTimeout(function() {
    		var processAfterGet = function(data) {
    			faceing = false;
    			if(!fnIsEmpty(data.rstans) && data.rstans) {
	     			if(!fnIsEmpty(data.result)) {
	     				if(data.result == "1") {
	     					//새로고침 - 메인으로
	     					$(location).attr('href', "/main/intro/");
	     				} else if (data.result == "-2") {
	     					alert("1단계 로그인이 진행되지 않았습니다.\n\nID와 PASSWORD를 입력 후 로그인을 해주세요.");
	     					$('#txtID').focus();
	     					return;
	     				} else {
	     					alert("일치하는 finger id 가 없습니다.\n\n다시 시도해 주세요.");
	     				}
	     			} else {
	     				alert("일치하는 finger id 가 없습니다.\n\n다시 시도해 주세요.");
	     			}
    			} else {
    				//alert("ID/PASSWORD 로그인 후 게시판에서 지문 로그인 설치파일을 설치 후 진행해주세요.");
    			}
    	    };
    		Ajax.getBioJson("<c:url value='/member/fingerLoginAjax/'/>","txtID="+$('#txtID').val()+"&strCoo="+strCoo+"&chkBiostep="+chkBiostep, processAfterGet);
        }, 500);  /*0.5초 후 실행*/
    }

    function fnGpkiRun () {
    	if($("#chkIdSave").is(":checked")) {
    		if(fnIsEmpty($("#txtID").val())) {
    			alert("ID가 확인되지 않습니다. ID를 먼저 입력하여 주십시오.");
    			return;
    		}
    		document.GpkiLoginForm.hidGpkiID.value = document.frmLogin.txtID.value;
    	} else {
    		document.GpkiLoginForm.hidGpkiID.value = "";
    	}
    	runGPKI();
    	document.GpkiLoginForm.action = "/member/actionCrtfctLogin/";
    	Login(this,document.getElementById('GpkiLoginForm'),false);
    }
</script>

<body>
<div id="login_wrap">
	<form id="frmLogin" name="frmLogin" method="post">
	<div id="inloginbox">
		<div class="topimg"><img src="/img/login_logo.png" width="693" height="65" alt=""/></div>
		<div class="loginbox">
			<div class="fl_box">
				<div class="input_inbox">
					<div class="icon"><img src="/img/login_icon01.png" alt=""/></div>
					<input type="text" id="txtID" name="txtID" placeholder="UserID"  class="login_input_st notHangul" value="" /> <!-- value="systemadmin" -->
				</div>
				<div class="input_inbox">
					<div class="icon"><img src="/img/login_icon02.png" alt=""/></div>
					<input type="password" id="txtPw" name="txtPw"  placeholder="Password"  class="login_input_st" value ="" style="color: #fff"/> <!-- value="nssp1234" -->
				</div>

				<div class="login_btn">
					<a href="javascript:fnLogin();">로그인</a>
				</div>

				<!---->
				<div class=com_box>
					<!--체크1-->
					<div class='input_radio2 t_left' style="padding-top: 5px;">
						<input class='to-labelauty-icon' type="checkbox" id="chkIdSave" name="chkIdSave" value="Y" style="">
						아이디를 저장하기
					</div>
					<div class="join_box" style="border-bottom: 0px; border-top: 0px; width: 120px; padding: 0px; float:right; text-align: center;">
					</div>
					<!--체크2-->
				</div>
			</div>
			<div class="fr_box">
				<a class="icon_login1" onclick="fnGpkiRun(); return false;" id="btnGpkiLg">GPKI 로그인
				</a>
				<a class="icon_login2" onclick="fnFaceLoginBf('fg'); return false;">지문인식 로그인
				</a>
				<a class="icon_login3" onclick="fnFaceLoginBf('fc'); return false;">얼굴인식 로그인
				</a>
			</div>
			<div class="join_box">
				<div class="txbox">ID/PW는 대소문자 구별합니다. 입력 시 유의하세요.<br>

				보안을 위해 이용 후 반드시 로그아웃 해주시기 바랍니다.

				</div>
				<a href="javascript:fnJoin();" class="btnbox"> 사용자등록</a>
			</div>
			<div class="find_box">
				<div class="txbox">아이디/비밀번호를 분실하셨나요? 아이디/비밀번호를 확인하실 수 있습니다.
					</div><a href="javascript:fnFind();" class="btnbox">아이디/비밀번호 찾기</a>
			</div>
		</div>
		<div class="in_box2">© 2019 원자력안전위원회. All Rights Reserved.</div>
	</div>
	</form>

	<!-- 인증서 start -->
	<!--인증서로그인 테이블 시작-->
	<form name="GpkiLoginForm" id="GpkiLoginForm" action ="/member/actionCrtfctLogin/" method="post"> 
		<div style="visibility:hidden;display:none;">
			<input name="iptSubmit2" type="submit" value="전송" title="전송">
			<input disabled type="hidden" name="challenge" value="${challenge}" />
			<input type="hidden" name="sessionid" id="sessionid" value="${sessionid}">
			<input type="hidden" name="hidGpkiID" id="hidGpkiID"/>
			<input type="hidden" name="hidGpkiPw" id="hidGpkiPw"/>
		</div>
	</form>    
    <!--인증서로그인 테이블 끝-->
	<!-- 인증서 end -->
</div>
</body>
</html>