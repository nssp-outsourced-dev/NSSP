<%@ page language="java" contentType="text/html; charset=utf-8" %>
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
	<script type="text/javascript">
		// 가상 키보드 사용을 위한 보안 세션 초기화
		initSecureSession();
		 function postSignedDataToServer(data) {
			document.gpkiForm.encryptedData.value=data;
			document.gpkiForm.method="post";
			document.gpkiForm.action="./createSecureSession_1_1_response." + serverLangExt;
			document.gpkiForm.submit();
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
				<h2><span class="subject">3. 전자서명 메시지 (위변조 방지)</span></h2><br/>
			</div>
			<div class="list_01">
				<ul>
					<li><span class="subject">- 전자서명 메시지 생성</span><span class="sub"><br/><br/></span></li>
					<li><strong>&nbsp;&nbsp;&nbsp;* 전달 데이터에 전자서명하기 (SignedData)</strong></li>
					<li><span>&nbsp;&nbsp;&nbsp;파라미터로 전달된 파라미터에 대해 웹브라우저에서 전자서명 데이터를 생성합니다.<br/>
						&nbsp;&nbsp;&nbsp;생성된 전자서명 데이터는 결과값으로 리턴됩니다.</li><br/>
				</ul>
					&nbsp;&nbsp;&nbsp;키보드 보안 옵션 : <select id="keysec">
					<option value="1">가상 키보드</option>
					<!-- <option value="2" >키보드 보안</option> -->
						<option value="0" selected="selected">사용하지 않음</option>
				</select><br>
				<div class="form">
					<form name="signSession">
						서명할 데이터 :<input type="text" name="orgData" overflow=hidden height=20px style="width:270px; margin-top:0px;"><br/>
						주민번호 혹은 법인번호 (본인확인용) :<input type="password" name="ssn" id="ssn" overflow=hidden height=20px style="width:250; margin-top:0px;"><br/>
						<!-- name=signedDataValue 로 지정된 input field에 SignedData() 호출 결과값이 저장됨 -->
						전자서명 데이터 :<input type="text" name="signedDataValue" id="signedDataValue" overflow=hidden height=20px style="width:270px; margin-top:0px;"><br/>
						<button onClick="return SignedData(this,document.signSession.orgData.value+'_'+'<%=sessionid%>')" style="margin-left:30px; margin-top:10px; height:30px; width:200px;">전자서명 메시지 생성</button>
						<%-- <input type="hidden" name="sessionid" value="<%=sessionid %>" /> --%>
					</form>
					<button onClick="postSignedDataToServer(signSession.signedDataValue.value);" style="margin-left:30px; margin-top:10px; height:30px; width:200px;">전자서명 메시지 전송</button>
				</div>
			</div>
		</div>	
		<div class="sp"></div>
		</div>
	</div>	
</body>
</html>
