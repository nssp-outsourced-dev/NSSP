<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html style="height: 100%">
<head>
<!-- #Real 실서버      10.66.204.43:10020  -->
<!-- #Dev  개발서버   172.16.107.152:9900 -->

<base href="http://172.16.107.152:9900/webhwpctrl/">

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<link rel="stylesheet" href="css/hcwo_hwpctrl.css">
<script type="text/javascript" src="js/libs/jquery/jquery.js"></script>
<script type="text/javascript" src="js/hwpctrlapp/utils/util.js"></script>
<script type="text/javascript" src="js/hwpctrlapp/hwpCtrlApp.js"></script>
<script type="text/javascript" src="js/webhwpctrl.js"></script>
<style>
body {
	overflow: hidden;
	border: 0px solid black;
	margin: 0;
	padding: 0;
}

div {
	margin: 0;
	padding: 0;
	border: 0px solid black;
}
</style>
</head>
<body width="100%" height="100%"
	style="background-color: lightgray; background-size: 100px; background-repeat: no-repeat; background-position: center">
	<div id="hwpctrl" style="width: 100%; height: 100%; overflow: hidden;">
		<!-- ADD IFRAME -->
	</div>

	<script>
		// Set onreisze event
		var resize = function(e) {
			var windowWidth = document.body.innerWidth
					|| document.documentElement.clientWidth
					|| document.body.clientWidth;
			var windowHeight = document.body.innerHeight
					|| document.documentElement.clientHeight
					|| document.body.clientHeight;
			var hwpctrl_panel = document.getElementById("hwpctrl");
			hwpctrl_panel.style.width = (parseInt(windowWidth)) + "px";
			hwpctrl_panel.style.height = (parseInt(windowHeight)) + "px";

			var hwpctrl_frame = document.getElementById("hwpctrl_frame");
			if (hwpctrl_frame != null) {
				hwpctrl_frame.width = parseInt(hwpctrl_panel.style.width);
				hwpctrl_frame.style.width = hwpctrl_panel.style.width;
				hwpctrl_frame.height = parseInt(hwpctrl_panel.style.height);
				hwpctrl_frame.style.height = hwpctrl_panel.style.height;
			}
		}

		window.onresize = resize;
		resize();

		var url = ""
		
		/* #Real  or ncsp.nssc.go.kr:10020
		url="http://10.66.204.43:10020/webhwpctrl/";
		*/
		
		/* #Dev */
		url="http://172.16.107.152:9900/webhwpctrl/";
		
		// Initialize WEBHWP
		var HwpCtrl = BuildWebHwpCtrl("hwpctrl", url, function() { 
					window.parent.hanCreateEditor("webhwpctrl loaded", "*");
				});
	</script>

</body>
</html>
