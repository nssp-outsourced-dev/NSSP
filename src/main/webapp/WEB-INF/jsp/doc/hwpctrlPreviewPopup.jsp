<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>웹한글기안기</title>
<script type="text/javascript" src="/js/jquery-1.11.1.js"></script>
<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>
<script type="text/javascript" src="/js/jquery-ui.js"></script>
<script type="text/javascript" src="/js/cubox.js"></script>
<script type="text/javascript" src="/js/cubox.grid.js"></script>
<style type="text/css">
	body {
		font: "나눔고딕", nanumgodic;
		font-size: 1.0em;
		color:#37474f;
	}

	a {
		text-decoration: none;
		color: #37474f;
	}

	.wrapper {
		margin: 0 auto;
		padding: 50px;
	}

	.container {
		position: relative;
		width: 100%;
		background-color: #f0f8ff;
	}

	.lnb_Area {
		float: left;
		width: 230px;
		margin-top: 50px;
		margin-right: 40px;
		background-color: #f7f7f7;
		font-size: 0.8em;
		position: fixed;
	}

	.lnb-list {
		list-style: none;
		margin: 0;
		padding: 16px 12px 16px 16px;
	}

	.lnb-item {
		margin: 8px 0;
		line-height: 16px;
		cursor: pointer;
	}

	.lnb-item:hover {
		color: #333399;
		font-weight: bold;
	}

	.lnb-item.tabOn {
		color: #8b008b;
		font-weight: bold;
	}

	.content {
		float: left;
		margin-left: 270px;
	}

	.canvas_wrap {
		width: 100%;
		height: 100%;
		overflow: hidden;
		top:100px;
	}

	.contents-item {
		border-radius: 15px;
		padding: 10px;
		background-color: #f7f7f7;
		margin-bottom: 30px;
		margin-top: 10px;
		font-size: 0.85em;
	}

	h1.first-type { margin-top: 0px; }
	span.atv { color: #0d904f; }
	span.tag { color: #008000; }
	span.atr { color: #7F007F; }
	span.val { color: #2A00FF; }
	span.imp { color: #ff4500; font-weight:bold; }

	.content_tab {
		margin: 15px 0;
		overflow: hidden;

		/* width: 300px; */
		border-radius: 3px;
		-moz-border-radius: 3px;
		-webkit-border-radius: 3px;
		/* background: #fbfbfb; */
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box
	}

	.content_tab li:first-child { border: 1px solid #9daeff; }
	.content_tab li {
		float: left;
		text-align: center;
		font-size: 0.8em;
		font-weight: bold;
		padding: 9px 0 10px;
		border: 1px solid #9daeff;
		border-left:none;
		/* border-left: 1px solid #c1c9f2; */
	}

	.content_tab .content_tab_list li {	width: 21%; }

	.content_tab_list {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.content_tab a.tabOn { color: #2b7bd6; }

	/* Toolbar Style */
	.hwp_toolbar {
		flex-wrap: nowrap;
		padding-left: 22px;
		box-sizing: border-box;
		position: relative;
		clear: both;
		display: flex;
		width: 100%;
		border-bottom: 1px solid #e0e0e0;
	}

	.hwp_toolbar_sub {
		flex: none;
		height: 25px;
	}

	.hwp_toolbar_title:hover {
		background: #e2e6f1;
		border-color: #96a6cd;
		color: #335095;
	}

	.hwp_toolbar_title {
		position: relative;
		display: inline-block;
		height: 23px;
		line-height: 21px;
		margin: 1px 0;
		padding: 0 14px;
		color: #333;
		border: 1px solid transparent;
		-webkit-border-radius: 2px;
		-moz-border-radius: 2px;
		border-radius: 2px;
		cursor: pointer;
		font-size: 12px;
		box-sizing: border-box;
		background: #fff;
		z-index: 10;
		flex: none;
	}

	.hwp_toolbar_title input {
		overflow: hidden;
	}
</style>

<script type="text/javascript">
	$(document).ready(function() {
		//팝업 종료시 부모창 refresh
		$(window).bind("beforeunload", function (e){
			
			var confirmValue = "문서를 종료하시겠습니까?";
			e.returnValue = confirmValue;
			<c:if test="${fn:length(ifr_id) > 0}">
				if( $("#ifrId").val().substring(0,2) == "fn" ){
					opener.location.href="javascript:"+$("#ifrId").val();
				} else {
					opener.location.href="javascript:document.getElementById('${ifr_id}').contentWindow.fnSearch();";
				} 
			</c:if>
		});

		$("#test_event").click(function(e){

		});
		$("#down_event").click(function(e){
			window.frames['Document_HwpCtrl'].HwpCtrl.SaveDocument($("#fileNm").val()+".hwp", "HWP");
		});
	
	});
</script>
</head>

<body>
	
	<!-- <h3 id="h1_5">Simple Example</h3> -->
	<div id="hwpctrl_Area" class="canvas_wrap">
		<div id="hwp_toolbar" class="hwp_toolbar" style="display:;">
			<div id="hwp_toolbar_open" class="hwp_toolbar_sub">
			
				<div class="hwp_toolbar_title" style="border-color: #333;">
					<span id="down_event">다운로드</span>
				</div>
				<!-- 
				<div class="hwp_toolbar_title" style="border-color: #333;">
					<span id="test_event" onclick="test_event()">기능테스트</span>
				</div>
				 -->
			</div>
		</div>
		
		<input type="hidden" id="formatId"	value="${formatId}"	/>
		<input type="hidden" id="fileNm" 	 />
		
		<iframe id="Document_HwpCtrl" name="Document_HwpCtrl" src="/doc/hwpctrlIframe/" style="width:100%; height:870px;"></iframe>
	</div>
</body>

<script type="text/javascript">
	var pHwpCtrl;

	//한글 파일 호출
	function fnGetInfo() {
		
		var processAfterGet = function(data) {
			if(!fnIsEmpty(data.prFilePath)) {
				pHwpCtrl.Open(data.prFilePath, "HWP", "", function (res) {
					if( res.result ){
						pHwpCtrl.EditMode = 0;
					}
				}, {"UserData" : "testData"});
			}
			
			$("#fileNm").val(data.fileNm);
		}
		
		var param = "formatId="+$("#formatId").val();
		
		ajaxUrl = "<c:url value='/doc/selectHwpctrlPreviewAjax/'/>";			//한글 서식 preview
		
		Ajax.getJson(ajaxUrl, param, processAfterGet);
	}


	//테스트 버튼
	function test_event () {
		//pHwpCtrl.Run("TableCellBlock");
		//pHwpCtrl.Run("TableRightCell");
		var pos = pHwpCtrl.GetPos();
		alert('GetPos : ' + pos.list + ' ' + pos.para + ' ' + pos.pos);
		//fnSetDataList(jsonListd);
		//var sRst = window.frames['Document_HwpCtrl'].HwpCtrl.MoveToField("CCDRC_NM{{"+(parseInt(13)-1)+"}}", false, false, false);
	}
	

	//한글기안기 최초 셋팅 후 호출되는 함수
	function hanCreateEditor(event, ee){
		pHwpCtrl = window.frames['Document_HwpCtrl'].HwpCtrl;  //한글 기안기 컨트롤 설정
		fnGetInfo();	// data 설정
	};
	
	//File Save Event
	$("#save_event").click(function(e){
		window.frames['Document_HwpCtrl'].HwpCtrl.SaveAs("${fileNm}.hwp", "HWP", "autosave:false", function (res) {
			fnSaveHwp (res);
		});
		//document.frames['Document_HwpCtrl'].HwpCtrl.Clear(0);
		//document.frames['Document_HwpCtrl'].HwpCtrl.Save ($("#filePath").val());
	});
</script>

