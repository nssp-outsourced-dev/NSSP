<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>특사경 수사시스템</title>
<link rel="stylesheet" type="text/css" href="/css/layout.css" media="all">
<link rel="stylesheet" type="text/css" href="/css/content.css" media="all">
<link rel="stylesheet" type="text/css" href="/css/btn.css" media="all">
<link rel="stylesheet" type="text/css" href="/css/ay_com_report.css" media="all">
<link rel="stylesheet" type="text/css" href="/css/so.css" media="all">

<script type="text/javascript" src="/js/jquery-1.11.1.js"></script>
<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>
<script type="text/javascript" src="/js/jquery-ui.js"></script>
<script type="text/javascript" src="/js/cubox.js"></script>
<script type="text/javascript" src="/js/cubox.grid.js"></script>
<link rel="stylesheet" href="/oz70/ozhviewer/ui.dynatree.css" type="text/css"/>
<script type="text/javascript" src="/oz70/ozhviewer/jquery.dynatree.js" charset="utf-8"></script>
<script type="text/javascript" src="/oz70/ozhviewer/OZJSViewer.js" charset="utf-8"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$(window).bind("beforeunload", function (e){
			<c:if test="${fn:length(ifr_id) > 0}">
				opener.location.href="javascript:document.getElementById('${ifr_id}').contentWindow.fnSearch();";
			</c:if>
		});
	});

	function fnClose(){
		//parent.reportViewPopup.hide();
		self.close();
	}

	function fnInputGo(){
		var form = $("form[id=addForm]");
		form.attr({"method":"post","action":"<c:url value='/doc/reportInputPopup/'/>"});
		form.submit();
	}
</script>
</head>


<body onLoad='window.focus();'>

<form id="addForm" name="addForm" method="post">
<input type="hidden" id="docId" name="docId" value="${result.DOC_ID}">
<input type="hidden" id="pblicteSn" name="pblicteSn" value="${result.PBLICTE_SN}">
<input type="hidden" id="ifrId" name="ifrId" value="${ifr_id}">
<input type="hidden" id="inputJson" name="inputJson">
</form>

<!-- <div class="popup_win_top">
	문서 출력
	<div class="close">
		<a href="javascript:fnClose();"><img src="/img/close_icon.png" alt="" /></a>
	</div>
</div> -->
<!--팝업박스 -->
<div class="popup_body" style="padding: 5px 10px">
	<!--버튼 -->
	<div class="com_box  t_right">
    	<div class="title_s_st3 w_50p t_left"><img src="/img/icon_error.png" alt=""/><span class=fc_blue1>작성된 내용을 확인하고 문서를 출력하세요.</span></div>
<c:if test="${result.INPUT_YN eq 'Y'}">
		<div class="btn_box mr_10">
			<input type="button" name="input_button" value="작성으로 "  class="btn_st4 icon_n fl mr_m1" onclick="fnInputGo();">
		</div>
</c:if>
	</div>
	<!--//버튼  -->
</div>
 <!--팝업박스 -->
 <div id="OZViewer" style="width:97%;height:97%; margin: 10px;"></div>
</body>
</html>
<script type="text/javascript" >
	function SetOZParamters_OZViewer(){
		var oz;
		oz = document.getElementById("OZViewer");
		oz.sendToActionScript("connection.servlet","/oz70/server");
		oz.sendToActionScript("connection.reportname","/ozr/${result.FORMAT_ID}_M.OZR");
		oz.sendToActionScript("connection.pcount","3");

		oz.sendToActionScript("connection.args1","P_URL="+location.protocol + "//" + location.host);
		oz.sendToActionScript("connection.args2","P_DOC_ID=${result.DOC_ID}");
		oz.sendToActionScript("connection.args3","P_PBLICTE_SN=${result.PBLICTE_SN}");

		oz.sendToActionScript("odi.odinames","${result.FORMAT_ID}_M");
		<c:if test="${fn:length(pList) > 0}">
			oz.sendToActionScript("odi.${result.FORMAT_ID}_M.pcount","${fn:length(pList)}");
		</c:if>
		<c:forEach var="str" items="${pList}" varStatus="status">
			oz.sendToActionScript("odi.${result.FORMAT_ID}_M.args${status.count}","${str}");
		</c:forEach>
		oz.sendToActionScript("odi.${result.FORMAT_ID}_M.clientdmtype","Memory");
		oz.sendToActionScript("odi.${result.FORMAT_ID}_M.serverdmtype","Memory");
		oz.sendToActionScript("odi.${result.FORMAT_ID}_M.fetchtype","Concurrent");

		oz.sendToActionScript("toolbar.open","false");
		oz.sendToActionScript("toolbar.print","true");
		oz.sendToActionScript("toolbar.save","true");
		oz.sendToActionScript("toolbar.page","true");
		oz.sendToActionScript("toolbar.option","false");
		oz.sendToActionScript("viewer.viewmode","fittowidth");
		oz.sendToActionScript("viewer.pagedisplay","singlepagecontinuous");

		oz.sendToActionScript("export.applyformat","hwp,pdf,doc,xls");
		oz.sendToActionScript("hml.filename","${result.FORMAT_NM}.hwp");
		oz.sendToActionScript("pdf.filename","${result.FORMAT_NM}.pdf");
		oz.sendToActionScript("doc.filename","${result.FORMAT_NM}.doc");
		oz.sendToActionScript("xls.filename","${result.FORMAT_NM}.xls");

		return true;
	}
	start_ozjs("OZViewer","/oz70/ozhviewer/");
</script>
