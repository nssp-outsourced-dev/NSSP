<%@ page language="java" contentType="text/html;charset=utf-8" isErrorPage="true" %>
<%
	String errmsg = request.getParameter("errmsg") == null?exception.toString():request.getParameter("errmsg");
	errmsg = new String(errmsg.getBytes("8859_1"),"euc-kr");
	errmsg = errmsg.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>","").replaceAll("\r|\n|&nbsp;","");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
	<title>GPKI 사용자용 표준보안API 에러페이지</title>
	<jsp:include page="header.jsp"></jsp:include>
	<!-- <script type="text/javascript" src="../client/var.js"></script>
	<script type="text/javascript" src="../client/install.js"></script>
	<script type="text/javascript" src="../client/GPKIFunc.js"></script>
	<script type="text/javascript" src="../client/object.js"></script> -->
	<script type="text/javascript">
	/* 	Logout(); */
	</script>
</head>

<body>
	<!-- <p><font style="font-size:5;"><b>GPKI 사용자용 표준보안API 오류.</b></font></p> -->
	<h1 style="margin:0 auto; text-align:center;">GPKI 사용자용 표준보안API 오류</h1>
	<table  cellspacing="0" cellpadding="0" style="width:500px; height:80px; margin:0 auto; border: 1px solid black;">
		<tr>
			<td style="background-color:#A198FE;  width=90px; text-align:center;">
				<b>&nbsp;Message</b>
			</td>
			<td>
				&nbsp;<%=errmsg%>
			</td>
		</tr>
	</table>
</body>
</html>