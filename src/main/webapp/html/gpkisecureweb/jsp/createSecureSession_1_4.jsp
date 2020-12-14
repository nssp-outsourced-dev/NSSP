<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.*" %>
<%@ include file="./gpkisecureweb.jsp" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletResponse" %>
<%
	String challenge = gpkiresponse.getChallenge();
	String sessionid = gpkirequest.getSession().getId();
	String url = javax.servlet.http.HttpUtils.getRequestURL(request).toString();
	session.setAttribute("currentpage",url);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="no-cache"/>
	<title>GPKI 사용자용 표준보안API</title>
	<jsp:include page="header.jsp"></jsp:include>
<!-- 	<script type="text/javascript" src="../client/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="../client/var.js"></script>
	<script type="text/javascript" src="../client/install.js"></script>
	<script type="text/javascript" src="../client/GPKIFunc.js"></script>
	<script type="text/javascript" src="../client/object.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/style.css" /> -->
	<script type="text/javascript">
			function doAction(target, form){
			if(GPKISecureWeb.InitCheck() == 0){
				GPKISecureWebUi.Init();
				return Login(target, form);
			}else{
				//window.location.href="../install.html";
				 runGPKI();
				return false;
			}
		}
	</script>
</head>

<body>
	<div class="wrap">
		<div class="header">
			<h1><a href="../index.html"><strong>GPKI 사용자용 표준보안API</strong></a></h1>
		</div>
		<div class="content">
			<div class="course course1">
				<div class="title">
					<h2><span class="subject">버튼 클릭 후 인스톨 체크 및 로그인 </span></h2><br/>
				</div>
				<div class="list_01">
					<ul>
						<li><span class="subject">- 사용자와 서버 인증서 인증 후 보안 세션 만들기 (인증서 로그인)</span><span class="sub"><br/><br/></span></li>
						<li><strong>&nbsp;&nbsp;&nbsp;* Form 객체를 이용한 팝업 로그인 (Login)</strong></li>
						<li>
							<span>
								&nbsp;&nbsp;&nbsp;PopUp 형태의 인증서 사용자 인터페이스를 이용하여 사용자 인증서를 선택할 수 있으며,<br/>
								&nbsp;&nbsp;&nbsp;Form 객체를 파라미터로 받아 로그인 메시지를 생성하여 서버에 전송합니다.<br/>
								&nbsp;&nbsp;&nbsp;서버 인증서를 이용하여 전달받은 Form 객체 내 파라미터 값들에 대한 공개키 암호화<br/>
								&nbsp;&nbsp;&nbsp;메시지를 생성합니다.<br/>
								&nbsp;&nbsp;&nbsp;또한, 로그인 이후 보안 세션 구성을 위한 세션키도 암호화 하여 서버와 공유 합니다.<br/>
							</span>
						</li>
					</ul>
					<div class="form" style="width:350px; height:100px;">
						<form action="./createSecureSession_1_1_response.jsp" method="post" name="popForm">
							Form Parameter 01 : <input type="text" name="param01" /><br/>
							Form Parameter 02 : <input type="text" name="param02" /><br/>
							Form Parameter 03 : <input type="text" name="param03" /><br/>
							주민등록번호 : <input type="text" name="ssn" /><br/>
							Replay Attack 방지 : <input disabled type="text" name="challenge" value="<%=challenge%>" /><br/><br/>
							<input type="hidden" name="sessionid" id="sessionid" value="<%=sessionid%>" /><br/>
							<button style="margin-left:30px; height:30px; width:200px;" onclick="return doAction(this,popForm);">보안 세션 요청(로그인)</button>
						</form>
					</div>
				</div>
			</div>
			<div class="sp"></div>
		</div>
	</div>
</body>
</html>

