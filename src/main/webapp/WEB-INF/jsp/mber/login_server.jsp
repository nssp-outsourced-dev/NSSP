<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%-- <%@ include file="/inc/gpkisecureweb.jsp" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletResponse" %>

<%
	String challenge = gpkiresponse.getChallenge();
	String sessionid = gpkirequest.getSession().getId();
	String url = javax.servlet.http.HttpUtils.getRequestURL(request).toString();
	session.setAttribute("currentpage",url);
%> --%>

<jsp:include page="/inc/header.jsp"/>

<!-- gpki -->
<!-- <script type="text/javascript" src="/js/gpki/EgovGpkiFunction.js"></script>
<script type="text/javascript" src="/js/gpki/EgovGpkiInstall.js"></script>
<script type="text/javascript" src="/js/gpki/EgovGpkiObject.js"></script>
<script type="text/javascript" src="/js/gpki/EgovGpkiVariables.js"></script> -->
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
		        if(key.keyCd == 13){//키가 13이면 실행 (엔터는 13)
		            fnLogin();
		        }
		    });
		    $("input[name=txtPw]").keydown(function (key) {
		        if(key.keyCd == 13){//키가 13이면 실행 (엔터는 13)
		            fnLogin();
		        }
		    });

	        var sUserId = getCookie("cookieLoginUserId");
	        if(sUserId != ""){
		        $("input[id='txtID']").val(sUserId);
	            $("#chkIdSave").attr("checked", true);
	        }

	        if(!fnIsEmpty($.trim('${gpkiResult}'))) alert('${gpkiResult}');
			if(!fnIsEmpty($.trim('${gpkiReg}'))) alert('${gpkiReg}');
		});
	})

	function fnLogin(){
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

        if($("#chkIdSave").is(":checked")){
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
		joinPopup = dhtmlmodal.open('reportInput', 'iframe', '/member/joinPopup/', '사용자 등록', 'width=800px,height=700px,center=1,resize=0,scrolling=1')
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

    function fnFaceLogin () {
    	<%-- <%
			String value = "";
			String cook = request.getHeader("Cookie");
			if(cook != null) {
				Cookie[] cookies = request.getCookies();
				for(Cookie c : cookies) {
					value = c.getValue();
				}
			}
		%>
		var strCoo = "<%=value %>"; --%>
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

		// MS 계열 브라우저를 구분하기 위함.
		//if(fnChkAgentIE () == "IE") {
		//	var path = String.fromCharCode(34) + "C:\\NSSP\\cuFace\\CUFaceLogin.exe" + String.fromCharCode(34);
		//	var WshShell = new ActiveXObject("WScript.Shell");
		//	var intError = WshShell.Run(path+" /cuface://1"+esId+strCoo, 1, false);
		//} else {
			$("#ifameRun").remove();
	    	var iframe = $("<iframe id='ifameRun' />").attr("src","cuface://1"+esId+strCoo);
	    	$(document).find("body").append(iframe);
		//}

    	setTimeout(function() {
    		//alert(5);
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
    				//alert("ID/PASSWORD 로그인 후 게시판에서 얼굴 로그인 설치파일을 설치 후 진행해주세요.");
    			}
    	    };
    		Ajax.getBioJson("<c:url value='/member/faceLoginAjax/'/>", "txtID="+$('#txtID').val() + "&strCoo="+strCoo, processAfterGet);
        }, 200);  /*0.2초 후 실행*/
    }

    function fnFingerLogin () {
    	<%-- <%
			String gvalue = "";
			String gcook = request.getHeader("Cookie");
			if(gcook != null) {
				Cookie[] cookies = request.getCookies();
				for(Cookie c : cookies) {
					gvalue = c.getValue();
				}
			}
		%>
		var strCoo = "<%=gvalue %>"; --%>
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

		//alert("strCoo:"+strCoo);

		faceing = true;
    	$("#ifameRun").remove();
    	var iframe = $("<iframe id=\"ifameRun\" />").attr("src","cufinger://1"+esId+strCoo);
    	$(document).find("body").append(iframe);

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
    		Ajax.getBioJson("<c:url value='/member/fingerLoginAjax/'/>", "txtID="+$('#txtID').val() + "&strCoo="+strCoo, processAfterGet);
        }, 500);  /*0.5초 후 실행*/
    }

    function fnFingerLoginTest () {
    	var processAfterGet = function(data) {
			if(!fnIsEmpty(data.result)) {
				alert("응답 오류!");
			} else {
				alert("로그인 확인 오류!");
				return;
			}
   		};
		Ajax.getBioJson("<c:url value='/member/fingerLoginAjax/'/>", "txtID="+$('#txtID').val()+"&strCoo=aaaaaaaaaaaaaaaaaaaaaaaa", processAfterGet);
    }

    function fnGpkiRun () {
    	//runGPKI("L", document.frmLogin.btnGpkiLg, document.GpkiLoginForm);
    	runGPKI();
    	//initSecureSession();
    	document.GpkiLoginForm.action = "/member/actionCrtfctLogin/";
    	Login(this,document.getElementById('GpkiLoginForm'),false);
    }

    function fnGpkiReg () {
    	if($('#txtID').val() == ""){
			alert('아이디를 입력하세요.\n\n아이디가 없는 경우, 사용자 등록을 먼저 진행해주세요.');
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

        if($("#chkIdSave").is(":checked")){
            var sUserId = $("input[id='txtID']").val();
            setCookie("cookieLoginUserId", sUserId, 365);
        }else{
            deleteCookie("cookieLoginUserId");
        }

        //runGPKI("R", document.frmLogin.btnGpkiReg, document.GpkiLoginForm);
        runGPKI();
      	//initSecureSession();
        document.GpkiLoginForm.hidGpkiID.value = document.frmLogin.txtID.value;
    	document.GpkiLoginForm.hidGpkiPw.value = document.frmLogin.txtPw.value;
    	document.GpkiLoginForm.action = "/member/actionGPKIreg/";
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
						<!-- <a id="btnGpkiReg" href="javascript:fnGpkiReg();" class="btnbox" style="padding: 5px 5px; margin-left: 25px; width: 100%">GPKI 등록</a> -->
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
				<a id="btnGpkiReg" href="javascript:fnGpkiReg();" class="btnbox" style="margin-left: 5px;"> GPKI등록</a>
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
	<form name="GpkiLoginForm" id="GpkiLoginForm" action ="/member/actionCrtfctLogin/" method="post"> <!-- "<c:url value='/member/actionCrtfctLogin/'/>" -->
		<div style="visibility:hidden;display:none;">
			<input name="iptSubmit2" type="submit" value="전송" title="전송">
			<input disabled type="hidden" name="challenge" value="${challenge}" />
			<input type="hidden" name="sessionid" id="sessionid" value="${sessionid}">
			<input type="hidden" name="hidGpkiID" id="hidGpkiID"/>
			<input type="hidden" name="hidGpkiPw" id="hidGpkiPw"/>
			<%-- <input type="hidden" name="sessionid" id="sessionid" value="<%=sessionid%>" /> --%>
		</div>
	</form>
    <%-- <form name="GpkiLoginForm" action ="<c:url value='/member/actionCrtfctLogin'/>" method="post">
		<div style="visibility:hidden;display:none;">
			<input name="iptSubmit2" type="submit" value="전송" title="전송">
		</div>
	    <table width="303" border="0" cellspacing="8" cellpadding="0">
	      <tr>
	        <td width="40%"class="title_left"><img src="<c:url value='/images/egovframework/com/cmm/icon/tit_icon.gif'/>" width="16" height="16" hspace="3" align="middle" alt="gpki_login">&nbsp;인증서 로그인</td>
	      </tr>
	      <tr>
	        <td width="303" height="210" valign="top" style="background:url(<c:url value='/images/egovframework/com/uat/uia/login_bg01.gif'/>) no-repeat;">
	            <table width="303" border="0" align="center" cellpadding="0" cellspacing="0">
	              <tr>
	                <td width="30" height="20"></td>
	              </tr>
	              <tr>
	              	<td>
	                 <table border="0" cellspacing="0" cellpadding="0" align="center">
	                   <tr>
	                   <td>
	                     <!-- 인증서 ActiveX 삽입 -->
	                     <object id="EMX" classid="CLSID:4725E26C-87F5-4D06-B743-A645DC6623D9" width = "285" height = "145">
	                       <param name="GNTYPE"  value=GNCertType>
	                       <param name="WORKDIR"  value=WorkDir>
	                       <param name="CERTTYPE"  value=ReadCertType>
	                       <param name="VALIDCERTOIDINFO"  value=ValidCertInfo>
	                     </object>
	                     <!-- 인증서 ActiveX 삽입 끝-->
	                   </td>
	                   </tr>
	                 </table>
	                </td>
	              </tr>
	            </table>
	           </td>
	          </tr>
	          <tr>
	          	<td>
	            <table>
	              <tr>
	              	<td>
	                 <table border="0" cellspacing="0" cellpadding="0" align="center">
	                   <tr>
	                     <td class="required_text"><label for="pwd">비밀번호&nbsp;&nbsp;
	                     	<input type="password" size="13" maxlength="16" name="pwd" id="pwd" onkeydown="embeddedEnterEvent(this.form)" style="ime-mode: disabled;" tabindex="12">&nbsp;&nbsp;</label>
	                     </td>
	                     <td><span class="button"><a href="#LINK" onClick="LoginEmbedded(document.GpkiLoginForm);" tabindex="13">인증서로그인</a></span>
	                     </td>
	                   </tr>
	                 </table>
	                </td>
	              </tr>
	            </table>
	        </td>
	      </tr>
	    </table>
	    <input name="userSe" type="hidden" value="GNR">
	</form> --%>
    <!--인증서로그인 테이블 끝-->
	<!-- 인증서 end -->


</div>

</body>
</html>