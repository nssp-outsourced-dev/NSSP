<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.*" %>
<%@ include file="./gpkisecureweb.jsp" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletResponse" %>
<%
	String challenge = gpkiresponse.getChallenge();
	String sessionid = gpkirequest.getSession().getId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
	<title>GPKI 사용자용 표준보안API</title>
	<jsp:include page="header.jsp"></jsp:include>
<!-- 	<script type="text/javascript" src="../client/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="../client/var.js"></script>
	<script type="text/javascript" src="../client/install.js"></script>
	<script type="text/javascript" src="../client/GPKIFunc.js"></script>
	<script type="text/javascript" src="../client/object.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/style.css" /> -->
<script type="text/javascript">
		runGPKI();
</script>
</head>
 
<body onload="Login(this,document.getElementById('popForm'),true)">
	<div class="wrap">
		<div class="header">
			<h1><a href="../index.html"><strong>GPKI 사용자용 표준보안API</strong></a></h1>
		</div>
		<div class="content">
			<div class="course course1">
				<div class="title">
					<h2><span class="subject">1. 사용자 인증 및 보안 세션 만들기</span></h2><br/>
				</div>
				<div class="list_01">
					<ul>
						<li><span class="subject">- 사용자와 서버 인증서 인증 후 보안 세션 만들기 (인증서 로그인)</span><span class="sub"><br/><br/></span></li>
						<li><strong>&nbsp;&nbsp;&nbsp;* Form 객체를 이용한 임베디드 로그인 (LoginEmbedded)</strong></li>
						<li><span>
							&nbsp;&nbsp;&nbsp;브라우저에 Embedded 된 형태로 인증서 사용자 인터페이스가 제공 되며<br/>
							&nbsp;&nbsp;&nbsp;Form 객체를 파라미터로 받아, 로그인 메시지를 생성하여 서버에 전송합니다.<br/>
							&nbsp;&nbsp;&nbsp;서버 인증서를 이용하여 보안 세션 구성을 위한 세션키를 교환 합니다.<br/>
							&nbsp;&nbsp;&nbsp;Form 객체 내 파라미터에 대한 암호화를 지원하지는 않습니다.<br/>
						</span></li>
					</ul>
					<div style="margin-Left:10px; width:290px;height:230px; float:left">
						<div id="embededlogin" > <font size="3" color="red">[삽입 기준 Element]</font></div><br/>
						패스워드 : <input id="passwd" type="password" onkeypress="return embeddedEnterEvent(event)" /><br/>
					</div>
					<div style="height:100px; float:left">
						<div class="form_02" style="width:350px; height:100px;">
							<form action="./createSecureSession_1_1_response.jsp" method="post" name="popForm" id="popForm">
								Form Parameter 01 : <input type="text" name="param01" /><br/>
								Form Parameter 02 : <input type="text" name="param02" /><br/>
								Form Parameter 03 : <input type="text" name="param03" /><br/>
								주민등록번호 : <input type="text" name="ssn" /><br/>
								Replay Attack 방지 : <input disabled type="text" name="challenge" value="<%=challenge%>" /><br/><br/>
								<input type="hidden" name="sessionid" id="sessionid" value="<%=sessionid%>">
							</form>
						</div>
					</div>
					<div style="both:clear"/></div>
					<br/><button onclick="return LoginEmbedded(popForm);" style="margin-Top:30px;margin-left:60px;margin-top:60px; height:30px; width:200px;">보안 세션 요청(로그인)</button>
				</div>
			</div>
		</div>
		<div class="sp"></div>
	</div>
</body>
</html>
