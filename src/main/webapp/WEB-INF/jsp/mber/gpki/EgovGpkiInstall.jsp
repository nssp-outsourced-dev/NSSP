<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
	<title>GPKI 사용자용 표준보안API 설치</title>
	<script type="text/javascript" src="./client/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="./client/jquery-ui.min.js"></script>
	<script type="text/javascript" src="/js/gpki/json2.js"></script>
	<script type="text/javascript" src="/js/gpki/var.js"></script>
	<script type="text/javascript" src="/js/gpki/GPKIErrorText.js"></script>
	<script type="text/javascript" src="/js/gpki/GPKISecureWebNP.js"></script>

	<style type="text/css">
		.color_01 {
			color: #39F;
			font-weight: bold;
			font-size: 16px;
		}
		img{border:none;}
		#wrap{margin:0 auto; width:745px;}
		.bg01{ background:url(./image/install/install_bg.gif) no-repeat; width:745px; height:471px;}
		.loding{padding-top:130px; padding-left:290px;}
		.program{ margin-top:80px; margin-left:40px; margin-right:40px;}
		.text_01{
			font-size:12px;
			line-height:20px;
			margin-bottom:20px;
			font-family:"나눔고딕"
		}
		.bg02{width:745px; height:32px;margin-top:50px;}
		.bg_03{width:745px; height:32px;}
		.btn_01{float:right; padding-right:10px;}
		.btn_02{width:98%; padding:10px;}
		.contents{border:#CCC 1px solid; width:705px; padding:20px;}
		.color_02 {
			color: #039;
			font-size: 14px;
			font-weight: bold;
			font-family:"나눔고딕"
		}
	</style>
</head>
<body>
	<div id="wrap">
		<div class="bg01">
			<div class="loding"><img src="./image/install/loading42.gif" alt="" /></div>
			<div class="program">
				<p class="text_01">1. 처음 접속하시는 분은 <strong>[보안경고]</strong>창이 표시되면 반드시 <strong>[예(Y)]</strong>를 누르셔서 프로그램을 설치하셔야 합니다.
					<br />&nbsp;&nbsp;&nbsp;*보안에 필요한 프로그램 설치이므로 <strong>[아니오(N)]</strong>를 선택하시면 서비스를 이용하실 수 없습니다.</p>
				<p class="text_01">2. 보안프로그램 설치중 오류가 발생하거나 장시간 화면이 정지해 있을 경우, 아래의 <strong>[보안프로그램 내려받기]</strong>를<br />
					&nbsp;&nbsp;&nbsp;눌러 다운받으신 프로그램 실행 하여 보안프로그램을 수동설치십시오.</p>
				<p class="text_01">3. 설치예상시간<br />&nbsp;&nbsp;- 컴퓨터 성능에 따라 10초~1분 정도 소요될 수 있습니다.</p>
			</div>
		</div>
		<div class="btn_01">
			<a id="downloadlink"><img src="./image/install/btn_install_down.gif" alt="" /></a>
		</div>

		<div class="bg02">
			<div id="winie" style="display:none">
				<div class="contents">
					<p class="text_01"><span class="color_02">Windows-IE를 사용하시는 경우</span></p>
					<p class="text_01"><span class="color_01">01</span>  브라우저 상단 또는 하단에 "GPKISecureWebXPlugin"을 설치하라는 노란 바가 나타나면, 노란 바의 설치를 클릭하여 "Active X 컨트롤설치…"를 실행 합니다.</p>
					<p class="text_01"><strong><img src="./image/install/install_01_clip_image.jpg" alt="" /></strong></p>
					<p class="text_01">&nbsp;&nbsp;* 키보드로 실행하는 방법<br />
						&nbsp;&nbsp;&nbsp;&nbsp;- Alt+N 키를 누르면 Active X를 실행시킬 수 있도록 포커스가 이동됩니다.<br />
						&nbsp;&nbsp;&nbsp;&nbsp;- 포커스 이동 후 Space 바를 누르고 Active X 컨트롤 설치(이 컴퓨터에 있는 모든 사용자를 위해 이 추가 기능 설치) 메뉴를 <br />
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;방향키로 선택하여 설치하시면 됩니다.</p>
					<p class="text_01"><span class="color_01">02</span> 보안경고 화면에서 [설치] 버튼을 누릅니다. </p>
					<p><img width="550" height="204" src="./image/install/install_01_clip_image002.jpg" alt="" /></p>
					<p class="text_01"><span class="color_01">03</span> 아래 화면과 같이 설치과정이 진행됩니다.</p>
					<p class="text_01" align="center"><img width="306" height="40" src="./image/install/install_01_clip_image002_0000.jpg" alt="" /></p>
					<p class="text_01"><span class="color_01">04</span> 설치 과정 진행 중 '암호화 프로그램이 이미 실행중입니다.열려 있는 프로그램과, 사이트에 연결한 웹 브라우저를 모두 <br />
					닫은후에 다시 프로그램을 삭제해 주시기 바랍니다.' 라는 메지시 박스가 나오면 해당 브라우저를 닫고 다시 시도 하시기 바랍니다. </p>
					<p class="text_01"><span class="color_01">05</span> 설치가 완료되면 Windows XP인 경우 브라우저를 재시작하여 이용하시면 됩니다.<br />
						&nbsp;&nbsp;&nbsp;&nbsp;- 계속 진행이 되지않는 경우에는 수동설치를 해보시기 바랍니다.</p>
				</div>
				<div class="btn_02" align="right"><!-- a href="./client/setup/GPKISecureWebXPlugin.exe"><img src="./image/install/btn_install_down.gif" alt="" /></a--></div>
			</div>

			<div id="winunie" style="display:none">
				<div class="bg_03" >&nbsp;</div>
				<div class="contents">
					<p class="text_01"><span class="color_02">Windows-Chrome, Firefox, Opera를 사용하시는 경우</span></p>
					<p class="text_01"><span class="color_01">01</span>보안 프로그램 내려 받기로 다운로드 받으신 후 [예(Y)]  선택 하여 실행하시기 바랍니다</p>
					<p align="center"><img width="358" height="202" src="./image/install/install_01_clip_image002_0002.jpg" alt="" /></p>
					<p class="text_01"><span class="color_01">02</span> 아래 화면과 같이 설치과정이 진행됩니다.</p>
					<p class="text_01" align="center"><img width="306" height="40" src="./image/install/install_01_clip_image002_0000.jpg" alt="" /></p>
					<p class="text_01"><span class="color_01">03</span> 설치 과정 진행 중 '암호화 프로그램이 이미 실행중입니다. 열려 있는 프로그램과, 사이트에 연결한 웹 브라우저를 모두 <br />
					닫은후에 다시 프로그램을 삭제해 주시기 바랍니다.' 라는 메지시 박스가 나오면 해당 브라우저를 닫고 다시 시도 하시기 바랍니다. </p>
					<p class="text_01"><span class="color_01">04</span> 설치가 완료되면 브라우저를 재시작하여 이용하시면 됩니다.</p>
				</div>
				<div class="btn_02" align="right"><!-- a href="./client/setup/GPKISecureWebXPlugin.exe"><img src="./image/install/btn_install_down.gif" alt="" /></a--></div>
			</div>

			<div id="linuxff" style="display:none">
				<div class="bg_03" >&nbsp;</div>
				<div class="contents">
					<p class="text_01"><span class="color_02">Linux-Firefox를 사용하시는 경우</span></p>
					<p class="text_01"><span class="color_01">01</span> 사용하시는 OS에 맞는 보안프로그램을 다운 받아 설치 하시기 바랍니다.</p>
					<p class="text_01"><span class="color_01">02 </span>보안프로그램 내려받기를 클릭하시면 아래와 같이 진행이 됩니다. [열기(0)]를 선택하시고 설치를 진행 하시거나 [파일저장(S)]을 선택하고 보안프로그램 설치 파일이 저장되면 저장된 파일을 실행 시켜 설치를 진행 합니다. </p>
					<p class="text_01" align="center"><img width="427" height="294" src="./image/install/install_02_clip_image002.jpg" alt="" /></p>
					<p class="text_01"><span class="color_01">03 </span>아래 화면과 같이 설치과정이 진행됩니다.<strong> [Install] </strong>을 선택하시고 설치를  진행합니다<strong>.</strong></p>
					<p class="text_01" align="center"><img width="434" height="137" src="./image/install/install_2_clip_image002.jpg" alt="" /></p>
					<p class="text_01" align="center"><strong><img width="447" height="154" src="./image/install/install_04_clip_image002.jpg" alt="" /></strong></p>
					<p class="text_01" align="center"><strong><img width="445" height="239" src="./image/install/install_04_clip_image002_0000.jpg" alt="" /></strong></p>
					<p class="text_01"><span class="color_01">04</span> 입력창이 나오면 PC 사용자 암호를 입력한 후  <strong>[Authenticate]</strong>버튼을 누릅니다.</p>
					<p class="text_01" align="center"><img width="374" height="254" src="./image/install/install_04_clip_image002_0001.jpg" alt="" /></p>
					<p class="text_01" align="center"><strong><img width="414" height="143" src="./image/install/install_04_clip_image002_0002.jpg" alt="" /></strong></p>
					<p class="text_01"><span class="color_01">05</span> 설치가 완료되면 열려있는 브라우저를 모두 종료한 후 브라우저를 재시작하여 이용하시면 됩니다. </p>
				</div>
				<div class="btn_02" align="right"><!-- a href="./client/setup/GPKISecureWebPlugin-1.0.0.1-1.i386.rpm"><img src="./image/install/btn_ubuntu_down.gif" alt="" /></a></span>&nbsp;&nbsp;<a href="/gpkisecureweb/setup/GPKISecureWebPlugin_1.0.0.1-1_i386.deb"><img src="./image/install/btn_fedora_down.gif" alt="" /></a--></div>
			</div>

			<div id="macsafari" style="display:none">
				<div class="bg_03">&nbsp;</div>
				<div class="contents">
					<p class="text_01"><span class="color_02">Mac-Safari를 사용하시는 경우</span></p>
					<p class="text_01"><span class="color_01">01</span>보안프로그램 내려받기로 다운로드 받으시면 다운로드 창이 나타납니다.</p>
					<p class="text_01" align="center"><img width="252" height="133" src="./image/install/install_04_clip_image002_0003.jpg" alt="" /></p>
					<p class="text_01"><span class="color_01">02 </span>다운로드 받은 보안프로그램을 실행 시키면 아래 하면과 같이 'GPKISecureWebPlugin 설치' 창이 나타납니다. [계속]버튼을 눌러 설치를 진행 합니다.</p>
					<p class="text_01" align="center"><img width="385" height="273" src="./image/install/install_04_clip_image002_0004.jpg" alt="" /></p>
					<p class="text_01"><span class="color_01">03 </span>다음 진행화면에서 [설치]버튼을 누릅니다.</p>
					<p class="text_01" align="center"><img width="395" height="280" src="./image/install/install_04_clip_image002_0005.jpg" alt="" /></p>
					<p class="text_01"><span class="color_01">04</span> 암호 입력창이 나오면 PC 사용자 암호를 입력한 후 [승인]버튼을 누릅니다.</p>
					<p class="text_01" align="center"><img width="254" height="137" src="./image/install/install_04_clip_image002_0006.jpg" alt="" /></p>
					<p class="text_01"><span class="color_01">05 </span>아래 화면과 같이 설치 과장이 진행 됩니다.</p>
					<p class="text_01" align="center"><img width="401" height="285" src="./image/install/install_04_clip_image002_0007.jpg" alt="" /></p>
					<p class="text_01"><span class="color_01">06 </span>설치가 완료되면 브라우저를 재시작하여 이용하세요. (Command+q 키를 눌러 완전히 종료)</p>
				</div>
				<div class="btn_02" align="right"><!-- a href="./client/setup/GPKISecureWebPlugin.pkg"><img src="./image/install/btn_install_down.gif" alt="" /></a--></div>
			</div>
		</div>
	</div>
	<script>
		document.getElementById("downloadlink").href = GPKISecureWeb.DownloadURL+GPKISecureWeb.DownloadWinFileName;
		function getSetupDownLoad(){
			GPKISecureWebUi.downLoadFile();
		}
		$(function(){
			setTimeout("getSetupDownLoad();",200);
			GPKISecureWebUi.setupCheck();
		});

	</script>
</body>

</html>
