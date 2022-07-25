<%@ page import="java.util.ResourceBundle" %>
<!DOCTYPE html>
<%
	ResourceBundle resource = ResourceBundle.getBundle("property.webhwp");

	String webhwp_ip  = resource.getString("Server.hwp");
	String webhwp_url = "http://"+webhwp_ip+"/webhwpctrl/";
%>
<html style="height:100%">
	<head>
		<base href =<%=webhwp_url%>>
		
	    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <title></title>
	    <link rel="stylesheet" href="js/webhwpapp/style/webhwp.css">
	    <link rel="stylesheet" href="js/hwpctrlframe/skins/default/css/hcwo.css">
	    <script type="text/javascript" src="js/hwpctrlapp/utils/util.js"></script>

	    <script type="text/javascript">
	       	window.BaseUrl = "<%=webhwp_url%>";
	    </script>
	
	    <script type="text/javascript" src="js/libs/require/require.js"></script>
	    <script type="text/javascript" src="js/require_config.js"></script>
	    <script type="text/javascript">
	    	require(["js/main-hwpapp.js"]);
	    </script>
	</head>
	<body>
	</body>
</html>