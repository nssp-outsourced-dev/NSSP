<%@ page contentType="text/html;charset=euc-kr" %>
<%@	page import="java.sql.*, java.io.*, java.net.*, java.util.*" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletResponse" %>
<%@ include file="./gpkisecureweb.jsp" %>
<%
	String challenge = gpkiresponse.getChallenge();
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
	<table width="100%" height="100%" align="center" valign="middle">
		<tr>
			<td align="center" valign="middle">
				<table width="58%" height="200" align="center">
					<tr>
						<td align="center" valign="middle">
							<table height=20" width="600" bgcolor="#A8D170">
								<tr>
									<td valign="middle" align="center">
										<a href="loginJemb.jsp"><font size="3" color="white">&nbsp;임베디드&nbsp;</font></a>&nbsp;<font size="3" color="white">/</font>&nbsp;
										<a href="loginJpop.jsp"><font size="3" color="white">&nbsp;팝업&nbsp;</font></a>&nbsp;<font size="3" color="white">/</font>&nbsp;
										<a href="loginJlink.jsp"><font size="3" color="white">&nbsp;링크&nbsp;</font></a>&nbsp;<font size="3"
										color="white">/</font>&nbsp;
										<a href="envJdata.jsp"><font size="3" color="white">&nbsp;비대칭키 암호화&nbsp;</font></a>&nbsp;<font size="3" color="white">/</font>&nbsp;
										<a href="envSignJData.jsp"><font size="3" color="white">&nbsp;전자서명 + 비대칭키 암호화&nbsp;</font></a>
									</td>
								</tr>
								<tr>
									<td><hr/></td>
								</tr>
								<tr>
									<td align="center" valign="middle">
										<img id="keyboard" src ="" style="width: 380px; height: 112px;" alt=""/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<script type="text/javascript">
		(function() {
			RequestSKeyboard(document.getElementById("keyboard"),"<%=challenge%>");
		})();
	</script>
</body>
</html>
