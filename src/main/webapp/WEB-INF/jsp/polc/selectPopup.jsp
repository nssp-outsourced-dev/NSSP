<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>


<link href="/jq/fileacc/css/file.css" rel="stylesheet" type="text/css">
<script src="/jq/fileacc/js/jquery-explr-1.4.js"></script>
<script type="text/javascript">

var myGridID;

	$(document).ready(function(){
		fnDrawTree();
	});

	function fnClose(){
		self.close();
	}

	function fnDrawTree(){
		var iUrl = '<c:url value='/polc/polcFullListAjax/'/>';
 		var queryString =  "";
 		var processAfterGet = function(data) {
			var sHtml = "";
			var sNode = "";
			var preDp = 0;
			for(var i = 0; i < data.length; i++){
				sRow = data[i];
				sNode = "<a href=\"javascript:fnSelect('"+ sRow.POLC_CD +"','"+ sRow.POLC_NM +"');\" title=\""+ sRow.POLC_NM +"\">"+ sRow.POLC_NM +"</a>";
				if(sRow.POLC_DP > preDp){
					//최초에 ul 제거
					if(i == 0){
						sHtml += "<li class=\"icon-file\">"+sNode;
					}else{
						sHtml += "<ul><li class=\"icon-file\">"+sNode;
					}
				}else if(sRow.POLC_DP < preDp){
					for(var j = sRow.POLC_DP+1; j <= preDp; j++){
						sHtml += "</li></ul>";
					}
					if(sRow.POLC_DP+1 == preDp){
						sHtml += "</li><li class=\"icon-file\">"+sNode;
					}else{
						sHtml += "</li><li class=\"icon-file\">"+sNode;
					}
				}else if(sRow.POLC_DP = preDp){
					sHtml += "</li><li class=\"icon-file\">"+sNode;
				}
				preDp = sRow.POLC_DP;
			}
			for(var k= 1; k <= preDp; k++){
				if(k == preDp){
					//마지막에 ul 제거
					sHtml += "</li>";
				}else{
					sHtml += "</li></ul>";
				}
			}

			$("#tree").html(sHtml);
	        $("#tree").explr();
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}


	function fnSelect(cd, cdNm) {
		$("#txtCd").val(cd);
		$("#txtCdNm").val(cdNm);

		parent.polcSelectPopup.hide();
	}


</script>
<body>

<!--팝업박스 -->
<form id="frmList" name="frmList" method="post">
<input type="hidden" id="txtPolcUpperCd" name="txtPolcUpperCd" value="${upper_cd}">
<input type="hidden" id="txtCd" name="txtCd" value="">
<input type="hidden" id="txtCdNm" name="txtCdNm" value="">
<div class="popup_body">
	<!--테이블 시작 -->
	<div class="tb_01_box">
		<div class="tb_box_ov" style="height:450px;">
			<ul id="tree">
			</ul>
		</div>
	</div>
</div>
</form>
 <!--팝업박스 -->

</body>
</html>