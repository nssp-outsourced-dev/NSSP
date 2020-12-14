<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.*" %>
<% 
	String sessionid = session.getId();
	String url = javax.servlet.http.HttpUtils.getRequestURL(request).toString();
	session.setAttribute("currentpage",url);
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
	<script type="text/javascript">
		// 가상 키보드 사용을 위한 보안 세션 초기화
		initSecureSession();
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
					<h2><span class="subject">3. 전자서명 메시지 (위변조 방지)</span></h2><br/>
				</div>
				<div class="list_01">
					<ul>
						<li><span class="subject">- 암호화 전자서명 메시지 생성</span><span class="sub"><br/><br/></span></li>
						<li><strong>&nbsp;&nbsp;&nbsp;* 보안세션으로 전자서명 메시지 보호하기 (EncryptedSignData)</strong></li>
						<li><span>&nbsp;&nbsp;&nbsp;클라이언트에서 생성한 암호화된 전자서명 메시지를 서버에서 복호화 한 후 전자서명<br/>
						&nbsp;&nbsp;&nbsp;유효 여부를 확인한다.</li><br/>
					</ul>
						&nbsp;&nbsp;&nbsp;키보드 보안 옵션 : <select id="keysec">
						<option value="1">가상 키보드</option>
						<!-- <option value="2" >키보드 보안</option> -->
						<option value="0" selected="selected">사용하지 않음</option>
					</select>
					<div class="form">
					<form name="encSignSession" action="./createSecureSession_1_1_response.jsp" method="post">
						Form Parameter 01: <input width="100px" name="param01">	<br>
						Form Parameter 02: <input width="100px" name="param02">	<br>
						Form Parameter 03: <input width="100px" name="param03">	<br><br><br><br><br>
						<button onClick="return EncryptedSignData(this,encSignSession)" style="margin-left:30px; height:30px; width:200px;">암호화된 전자서명</button>
						<input type="hidden" name="sessionid" id="sessionid" value="<%=sessionid%>" />
					</form>
				</div>
			</div>
		</div>	
		<div class="sp"></div>
	</div>
</body>
</html>
