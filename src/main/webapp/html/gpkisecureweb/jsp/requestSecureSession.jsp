<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.*" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletResponse" %>
<%@ include file="./gpkisecureweb.jsp" %>
<%
	String challenge = gpkiresponse.getChallenge();
	String sessionid = request.getParameter("rnd");
	sessionid = sessionid.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","").replaceAll("\r|\n|&nbsp;","");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
	<title>GPKI 사용자용 표준보안API</title>
	<jsp:include page="header.jsp"></jsp:include>
	<!-- <script type="text/javascript" src="../client/var.js"></script>
	<script type="text/javascript" src="../client/install.js"></script>
	<script type="text/javascript" src="../client/GPKIFunc.js"></script>
	<script type="text/javascript" src="../client/object.js"></script> -->
</head>

<body>
	<form name="secureSession" action="./responseSecureSession.jsp" method="post">
		<input type="text" name="challenge" width="300px" value="<%=challenge%>" disabled/><br/>
		<input type="hidden" name="sessionid" value="<%=sessionid%>"/>
	</form>
	<script type="text/javascript">
		function bar(arg){};
		function EnvelopedDataII(form)
		{
			var strData;
			var nResult;
			var strReturnData;
			var strSendData; 
			strData = GPKISubmit(form);
			if(GPKISecureWeb.initFlag != 0){
				GPKISecureWebUi.InitCheck();
				if(GPKISecureWeb.initFlag != 0){
					return false;
				}
			}
	
			var sessionID = "";
				if( form.sessionid.value != null)
					sessionID = form.sessionid.value;

			if( GPKISecureWeb.SetSessionID(sessionID) != 0) {
				return;
			}

			nResult = GPKISecureWeb.EnvelopData(SiteID+sessionID, strData);
			strReturnData = GPKISecureWeb.GetReturnData();
			var obj = JSON.parse(strReturnData);

			if( nResult == 0 ) {
				//alert("EnvelopData success");
				document.gpkiForm.encryptedData.value = obj.ResultMessage;
				document.gpkiForm.method = form.method;
				document.gpkiForm.action = form.action;
				document.gpkiForm.submit();	
			} else {
				if( nResult != 106)
					alert(strReturnData);
			}
		}
		EnvelopedDataII(secureSession);
	</script>
</html>
