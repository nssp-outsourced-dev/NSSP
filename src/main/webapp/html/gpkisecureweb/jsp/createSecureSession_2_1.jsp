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
</head>

<body>
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
						<li><span class="subject">- 서버 인증서 인증 후 보안세션 만들기 (보안 세션만 생성)</span><span class="sub"><br/><br/></span></li>
						<li><strong>* 공개키 암호 메시지 만들기</strong></li>
						<li><span>
							&nbsp;&nbsp;&nbsp;서버 인증서 검증 후 보안 세션 구성을 위한 세션키를 교환 합니다.<br/>
							&nbsp;&nbsp;&nbsp;Form 객체 내 파라미터로 받아 로그인 메시지를 생성하여 서버에 전송합니다.<br/>
							&nbsp;&nbsp;&nbsp;Form 객체 내에 파라미터에 대한 암호화를 지원합니다.<br/></span>
						</li>
					</ul>
					<div class="form" style="width:350px; height:100px;">
					<form action="./createSecureSession_1_1_response.jsp" method="post" name="envJsp" id="envJsp">
						Form Parameter 01: <input width="100px" name="param01"></input><br/>
						Form Parameter 02: <input width="100px" name="param02"></input><br/>
						Form Parameter 03: <input width="100px" name="param03"></input><br/><br/>
						Replay Attack 방지 : <input type="text" name="challenge" width="40px" value="<%=challenge%>" disabled></input><br/><br/><br/>
						<input type="hidden" name="sessionid" id="sessionid" value="<%=sessionid%>"></input>
						<button onclick="return EnvelopedData(envJsp)" style="margin-left:30px; height:30px; width:200px;">보안 세션 요청(로그인)</button>
					</form>
				</div>
			</div>
		</div>
		<div class="sp"></div>
	</div>
</body>
</html>
