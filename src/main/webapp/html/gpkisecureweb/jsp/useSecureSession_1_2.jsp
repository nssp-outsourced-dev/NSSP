<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.*" %>
<%@ include file="./gpkisecureweb.jsp" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletResponse" %>
<%
	String sessionid = session.getId();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
	<title>GPKI 사용자용 표준보안API</title>
	<jsp:include page="header.jsp"></jsp:include>
	<!-- <script type="text/javascript" src="../client/jquery-1.7.1.min.js"></script>
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
					<h2><span class="subject">2. 보안 세션(세션키)을 이용한 암호 메시지 (송수신 자료 암호화)</span><br/></h2>
				</div>
				<div class="list_01">
					<ul>
						<li><span class="subject">- 클라이언트에서 암호화 메시지 만들어 서버에서 복호화 하기</span><span class="sub"><br/><br/></span></li>
						<li><strong>&nbsp;&nbsp;&nbsp;* URL Link 내 파라미터 암호화 하기 (EncryptLink)</strong></li>
						<li><span>&nbsp;&nbsp;&nbsp;URL Link 에 포함된 파라미터를 암호화하여 URL Target 위치로 전송합니다.</span><br/></li>
					</ul>
					<div class="form_01">
						<br/>암호화 하고자 하는 데이터 : param1=1234& param2=354345</p><br/><br/><br/><br/><br/><br/><br/>
						<a href="./createSecureSession_1_1_response.jsp?param1=123&param2=354345" onclick="return EncryptLink(this,null,'<%=sessionid%>');">보안 세션 암호화</a>
					</div>
				</div>
			</div>
			<div class="sp"></div>
		</div>
	</div>
</body>
</html>
