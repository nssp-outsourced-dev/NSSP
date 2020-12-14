<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1.0">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>특사경 수사시스템</title> -->

<link rel="stylesheet" type="text/css" href="/css/layout.css" media="all">
<link rel="stylesheet" type="text/css" href="/css/content.css" media="all">
<link rel="stylesheet" type="text/css" href="/css/btn.css" media="all">
<link rel="stylesheet" type="text/css" href="/css/ay_com.css" media="all">
<link rel="stylesheet" type="text/css" href="/css/so.css" media="all">
<script type="text/javascript" src="/js/jquery-1.11.1.js"></script>

<!-- 왼쪽메뉴 스크립트 -->
<script src="/jq/leftmenu/jquery.cookie.js"></script>
<script type="text/javascript" src="/jq/leftmenu/jquery.navgoco.js"></script>
<link rel="stylesheet" type="text/css" href="/jq/leftmenu/jquery.navgoco.css" media="screen" />
<script type="text/javascript" id="demo1-javascript">
$(document).ready(function() {
	$("#demo1").navgoco({
		caret: '<span class="caret"></span>',
		accordion: true,
		openClass: 'open',
		save: true,
		cookie: {
			name: 'navgoco',
			expires: false,
			path: '/'
		},
		slide: {
			duration: 400,
			easing: 'swing'
		}
	});


});
</script>
        <script type="text/javascript" src="/jq/check/source/jquery-labelauty.js"></script>
        <link rel="stylesheet" href="/jq/check/source/jquery-labelauty.css" type="text/css" media="screen" charset="utf-8" />
        <link rel="stylesheet" href="/jq/check/source/lby-main.css" type="text/css" media="screen" charset="utf-8" />
        <script>
		$(document).ready(function(){
			$(".to-labelauty").labelauty({ minimum_width: "17px" });
			$(".to-labelauty-icon").labelauty({ label: false });
		});

</script>

        <!-- 팝업레이어 : 작업예정 지우지 마세요 -->
         <!-- <link rel="stylesheet" href="/jq/popup/reveal.css">-->
        <!-- Attach necessary scripts -->
        <!-- <script type="text/javascript" src="jquery-1.4.4.min.js"></script> -->
        <!--<script type="text/javascript" src="http://code.jquery.com/jquery-1.6.min.js"></script>-->
         <!--<script type="text/javascript" src="/jq/popup/jquery.reveal.js"></script>-->

<link rel="stylesheet" href="/jq/popup2/popup1.css" type="text/css" />
<script type="text/javascript" src="/jq/popup2/dhtmlwindow.js"></script>
<script type="text/javascript" src="/jq/popup2/modal.js"></script>

<!-- //팝업레이어 -->

<!-- 상단메뉴 스크립트 -->
<link rel="stylesheet" href="/jq/topmenu/dist/css/superfish.css" media="screen">
<script src="/jq/topmenu/dist/js/hoverIntent.js"></script>
<script src="/jq/topmenu/dist/js/superfish.js"></script>
<script>

(function($){ //create closure so we can safely use $ as alias for jQuery

	$(document).ready(function(){

		// initialise plugin
		var example = $('#example').superfish({
			//add options here if required
		});

		// buttons to demonstrate Superfish's public methods
		$('.destroy').on('click', function(){
			example.superfish('destroy');
		});

		$('.init').on('click', function(){
			example.superfish();
		});

		$('.open').on('click', function(){
			example.children('li:first').superfish('show');
		});

		$('.close').on('click', function(){
			example.children('li:first').superfish('hide');
		});
	});

})(jQuery);


</script>
<link rel="stylesheet" href="/jq/jScrollbar/jquery/jScrollbar.jquery.css" type="text/css" />

<!--텝     -->
<script type="text/javascript" src="/jq/tabs/tytabs.jquery.min.js"></script>
<link href="/jq/tabs/styles.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--
$(document).ready(function(){
	$("#tabsholder").tytabs({
							tabinit:"1",
							fadespeed:"fast"
							});
	$("#tabsholder2").tytabs({
							prefixtabs:"tabz",
							prefixcontent:"contentz",
							classcontent:"tabscontent",
							tabinit:"3",
							catchget:"tab2",
							fadespeed:"normal"
							});
});
-->
</script>


<!--달력  -->
<link rel="stylesheet" type="text/css" href="/jq/calendar/jquery.datetimepicker.css"/>
<link rel="stylesheet" type="text/css" href="/jq/calendar2/dist/jquery.datetimepicker.css"/>
<script type="text/javascript" src="/jq/calendar2/src/jquery.datetimepicker.js"></script>


<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>
<script type="text/javascript" src="/js/jquery-ui.js"></script>
<script type="text/javascript" src="/js/jquery.blockUI.js"></script>
<script type="text/javascript" src="/js/jquery.form.js"></script>
<script type="text/javascript" src="/js/jquery.MetaData.js"></script>
<script type="text/javascript" src="/js/jquery.MultiFile.js"></script>

<script type="text/javascript" src="/js/cubox.js?ver=1.1"></script>
<script type="text/javascript" src="/js/cubox.grid.js?ver=1.1"></script>

<!-- AUIGrid 테마 CSS 파일입니다. 그리드 출력을 위해 꼭 삽입하십시오. -->
<!-- 원하는 테마가 있다면, 다른 파일로 교체 하십시오. -->
<link href="/AUIGrid/AUIGrid_style.css" rel="stylesheet">
<!-- AUIGrid 라이센스 파일입니다. 그리드 출력을 위해 꼭 삽입하십시오. -->
<script type="text/javascript" src="/AUIGrid/AUIGridLicense.js"></script>
<!-- 실제적인 AUIGrid 라이브러리입니다. 그리드 출력을 위해 꼭 삽입하십시오.-->
<script type="text/javascript" src="/AUIGrid/AUIGrid.js"></script>
<script type="text/javascript" src="/AUIGrid/pdfkit/AUIGrid.pdfkit.js"></script>
<!-- 브라우저 다운로딩 할 수 있는 JS 추가 -->
<script type="text/javascript" src="/AUIGrid/pdfkit/FileSaver.min.js"></script>

<script type="text/javascript">
	jQuery.browser = {};
	(function () {
	    jQuery.browser.msie = false;
	    jQuery.browser.version = 0;
	    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
	        jQuery.browser.msie = true;
	        jQuery.browser.version = RegExp.$1;
	    }
	})();

	//grid resize
	$(window).resize(function (){
		$('.gridResize').each(function(){
			var domId = $(this).attr('id');
			if(!fnIsEmpty(domId)){
				AUIGrid.resize("#"+domId);
			}
		});
	})
</script>
</head>