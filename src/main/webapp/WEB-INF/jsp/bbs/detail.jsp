<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	pageContext.setAttribute("cr", "\r"); //Space
	pageContext.setAttribute("cn", "\n"); //Enter
	pageContext.setAttribute("crcn", "\r\n"); //Space, Enter
	pageContext.setAttribute("br", "<br/>"); //br 태그
%>
<script type="text/javascript">
	$(document).ready(function(){

		<c:if test="${option.CMNT_YN eq 'Y'}">
			fnCmntList();
		</c:if>
	});

	function fnList() {
		var form = $("form[id=frmDetail]");
		form.attr({"method":"post","action":"<c:url value='/bbs/${bbsId}/list/'/>"});
		form.submit();
	}

	function fnDetail(bbs_sn) {
		var form = $("form[id=frmDetail]");
		$("input:hidden[id=hidBbsSn]").val(bbs_sn);
		form.attr({"method":"post","action":"<c:url value='/bbs/${bbsId}/detail/'/>"});
		form.submit();
	}
	
	function fnUpdate() {
		var form = $("form[id=frmDetail]");
		$("input:hidden[id=hidAddTy]").val("A");
		form.attr({"method":"post","action":"<c:url value='/bbs/${bbsId}/add/'/>"});
		form.submit();
	}

	
	function fnReply() {
		var form = $("form[id=frmDetail]");
		$("input:hidden[id=hidAddTy]").val("R");
		form.attr({"method":"post","action":"<c:url value='/bbs/${bbsId}/add/'/>"});
		form.submit();
	}

	function fnOthbcPw(bbsSn){
		othbcPwPopup = dhtmlmodal.open('othbcPw', 'iframe', '/bbs/othbcPwPopup/', '비공개 비밀번호 입력', 'width=600px,height=150px,center=1,resize=0,scrolling=1')
		othbcPwPopup.onclose = function(){
			var iframedoc = this.contentDoc;
			var sOthbcPw = iframedoc.getElementById("txtOthbcPw").value;
			$("input:hidden[id=hidOthbcPw]").val(sOthbcPw);
			fnDetail(bbsSn);
			return true;
		}
	}
	
<c:if test="${option.CMNT_YN eq 'Y'}">
	function fnCmntList(){
		var iUrl = '<c:url value='/bbs/cmntListAjax/'/>';
 		var queryString =  $('#frmCmnt').serialize();
 		var processAfterGet = function(data) {
 			if(data.result == "1"){
 				innerHtml = "";
 				for(var i = 0; i < data.list.length; i++){
 					cmntData = data.list[i];

					innerHtml += "<div class=\"comment_box\">";
					innerHtml += "	<div class=\"user_tx\">";
					innerHtml += "		<em>"+ cmntData.WRITNG_NM +"</em> "+ cmntData.WRITNG_DT+"";
					innerHtml += "		<div class=\"btnbox\">";
 					if("${esntl_id}" == cmntData.WRITNG_ID){
 	 					innerHtml += "<a href=\"javascript:void(0);\" id=\"btnCmnUpdateUse\" name=\"btnCmnUpdateUse\" data-id=\""+ cmntData.CMNT_SN +"\">수정</a>";
 	 					innerHtml += "<a href=\"javascript:void(0);\" id=\"btnCmnUpdateCancel\" name=\"btnCmnUpdateCancel\" data-id=\""+ cmntData.CMNT_SN +"\" style=\"display:none\">수정취소</a>";
 	 					innerHtml += "<a href=\"javascript:fnCmntDelete('"+ cmntData.CMNT_SN +"');\" id=\"btnCmnDelete\">삭제</a> <br>";
 					}
					innerHtml += "		</div>";
					innerHtml += "	</div>";
 					innerHtml += "	<div class=\"tx_box\" id=\"divCmnt\" name=\"divCmnt\" data-id=\""+ cmntData.CMNT_SN +"\">"+ cmntData.CMNT_CN.replace(/(?:\r\n|\r|\n)/g, '<br />') +"</div>";
					innerHtml += "</div>";
 					
 				}

 				$("#tbCmntList").html(innerHtml);
 			}
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
		
		$("a[name='btnCmnUpdateUse']").click(function() {
		    var cmntSn = $(this).data('id');
			$("input:hidden[id=hidCmntSn]").val(cmntSn);
			var iUrl = '<c:url value='/bbs/cmntDetailAjax/'/>';
	 		var queryString =  $('#frmCmnt').serialize();
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					fnCmntList();

					$("div[name='divCmnt'][data-id="+ cmntSn +"]").attr("class","inputbox");

					innerHtml = "";
 					innerHtml += "<textarea id=\"txtUpdateCmntCn\" name=\"txtUpdateCmntCn\" class=\"intx\">"+ data.detail.CMNT_CN +"</textarea>";
 					innerHtml += "<input type=\"button\" class=\"savebtn\" value=\"수정\" id=\"btnCmnUpdate\" onclick=\"fnCmntUpdate();\">";

 					$("a[name='btnCmnUpdateUse'][data-id="+ cmntSn +"]").hide();
 					$("a[name='btnCmnUpdateCancel'][data-id="+ cmntSn +"]").show();
 					$("div[name='divCmnt'][data-id="+ cmntSn +"]").html(innerHtml);
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		});

		$("a[name='btnCmnUpdateCancel']").click(function() {
		    var cmntSn = $(this).data('id');
			$("input:hidden[id=hidCmntSn]").val(cmntSn);
			var iUrl = '<c:url value='/bbs/cmntDetailAjax/'/>';
	 		var queryString =  $('#frmCmnt').serialize();
	 		var processAfterGet = function(data) {
				if(data.result == "1"){

					$("div[name='divCmnt'][data-id="+ cmntSn +"]").attr("class","tx_box");

					innerHtml = "";
 					innerHtml += ""+ data.detail.CMNT_CN.replace(/(?:\r\n|\r|\n)/g, '<br />') +"";

 					$("a[name='btnCmnUpdateUse'][data-id="+ cmntSn +"]").show();
 					$("a[name='btnCmnUpdateCancel'][data-id="+ cmntSn +"]").hide();
 					$("div[name='divCmnt'][data-id="+ cmntSn +"]").html(innerHtml);
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		});
	}

	function fnCmntAdd(){
		if(fnFormValueCheck("frmCmnt")){
			if(confirm("덧글을 작성하시겠습니까?")){ 
				$("input:hidden[id=hidCmntSn]").val("");	
				var iUrl = '<c:url value='/bbs/cmntAddAjax/'/>';
		 		var queryString =  $('#frmCmnt').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						fnCmntList(); 
						$("#txtCmntCn").val("");
					}else{
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
            }
		}
	}


	function fnCmntUpdate(){
		if(confirm("덧글을 수정하시겠습니까?")){ 
			var iUrl = '<c:url value='/bbs/cmntUpdateAjax/'/>';
	 		var queryString =  $('#frmCmnt').serialize();
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					fnCmntList(); 
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	function fnCmntDelete(cmntSn){
		if(confirm("덧글을 삭제하시겠습니까?")){
			$("input:hidden[id=hidCmntSn]").val(cmntSn);				
			var iUrl = '<c:url value='/bbs/cmntDisableAjax/'/>';
	 		var queryString =  $('#frmCmnt').serialize();
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					fnCmntList(); 
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
           }
	}

</c:if>

</script>

<form id="frmDetail" name="frmDetail" method="post">
<input type="hidden" id="bbsId" name="bbsId" value="${bbsId}">
<input type="hidden" id="hidAddTy" name="hidAddTy">
<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
<input type="hidden" id="hidBbsSn" name="hidBbsSn" value="${result.BBS_SN}">
<input type="hidden" id="pBlock" name="pBlock" value="${pBlock}">
<input type="hidden" id="hidOthbcPw" name="hidOthbcPw">
<input type="hidden" id="searchNttSj" name="searchNttSj" value="${searchNttSj}">

<div id="bbs_box">
	<table class="bbs_view01">
		<col width="200px" />
		<col width="" />
		<col width="200px" />
		<col width="15%" />
		<col width="200px" />
		<col width="10%" />

		<tbody>
			<tr>
				<th height="25">제목</th>
				<td colspan="5" class="line">
					<c:if test="${result.NOTICE_YN eq 'Y'}"><div class="notice_icon">공지</div></c:if>
					${result.NTT_SJ}
				</td>
			</tr>		
			<tr>
				<th height="25">작성자</th>
				<td class="line">${result.WRITNG_NM}</td>
				<th>작성일시</th>
				<td>${result.WRITNG_DT}</td>
				<th>조회 수</th>
				<td>${result.INQIRE_CO}</td>
			</tr>
		<c:if test="${option.ATCH_FILE_CO ne '0'}">
			<tr>
				<th height="25">첨부파일</th>
				<td colspan="5" class="line">
					<iframe id="ifrFile" src="<c:url value='/file/fileListIframe/'/>?ifr_id=ifrFile&file_id=${result.FILE_ID}" scrolling="no" frameborder="0" width="100%" height="0px" ></iframe>
				</td>
			</tr>
		</c:if>
		</tbody>
	</table>
</div>
<div class="table_view_text" style="padding:25px;">
	<c:out escapeXml="false" value="${fn:replace(result.NTT_CN,crcn,br)}"/>
</div>
</form>

<c:if test="${option.CMNT_YN eq 'Y'}">
<form id="frmCmnt" name="frmCmnt" method="post">
<input type="hidden" id="bbsId" name="bbsId" value="${bbsId}">
<input type="hidden" id="hidBbsSn" name="hidBbsSn" value="${result.BBS_SN}">
<input type="hidden" id="hidCmntSn" name="hidCmntSn">
<div class="bbs_re">
	<div id="tbCmntList">
	</div>
	<div class="comment_re">
		<div class="inputbox">
			<textarea id="txtCmntCn" name="txtCmntCn" class="intx" check="text" checkName="덧글 내용"></textarea>
			<input type="button" class="savebtn" value="확인" onclick="fnCmntAdd();" id="btnCmnAdd">
		</div>
	</div>
</div>
</form>
</c:if>




<div class="right_btn fr mb_20 mt_20">
	<a href="javascript:void(0);" id="btnClear" onClick="fnList();" class="btn_st2 icon_n fl mr_m1">목록</a>
	<c:if test="${option.WRITNG_AUTHOR_SE eq '0' || mngr_yn eq 'Y'}">
		<c:if test="${option.REPLY_YN eq 'Y'}">
			<a href="javascript:void(0);" id="btnAdd" onClick="fnReply();" class="btn_st2 icon_n fl mr_m1">답변</a>
		</c:if>
		<c:if test="${result.WRITNG_ID eq esntl_id || mngr_yn eq 'Y'}">
			<a href="javascript:void(0);" id="btnUpdate" onClick="fnUpdate();" class="btn_st2 icon_n fl mr_m1">수정</a>
		</c:if>
	</c:if>
</div>

<div class="com_box  t_right">
	<div class="btn_box">
	</div>
</div>



<c:if test="${fn:length(preview) > 0}">
<div id="bbs_box">
	<table class="bbs_view02">
		<col width="200px" />
		<col width="" />
		<col width="200px" />
		<tbody>
		<c:forEach var="result" items="${preview}" varStatus="status">
			<tr>
				<th height="25">
					<c:choose>
						<c:when test="${result.CATE eq 'PREV'}">
							이전글
						</c:when>
						<c:otherwise>
							다음글
						</c:otherwise>
					</c:choose>
				</th>
				
				<td class="line">
					<c:choose>
						<c:when test="${result.OTHBC_YN eq 'Y' || mngr_yn eq 'Y' || result.WRITNG_ID eq esntl_id}">
							<a href="javascript:fnDetail('${result.BBS_SN}');">${result.NTT_SJ}</a>
						</c:when>
						<c:otherwise>
							<a href="javascript:fnOthbcPw('${result.BBS_SN}');">${result.NTT_SJ}</a>
						</c:otherwise>
					</c:choose>	
					<c:if test="${result.CMNT_CNT > 0}"><span class="font_color2">[${result.CMNT_CNT}]</span> </c:if>
					<c:if test="${result.OTHBC_YN eq 'N'}"><img src="/img/icon_pw.png" class="ml_5" alt=""/></c:if>
					<c:if test="${result.NEW_YN eq 'Y'}"><img src="/img/icon_bbs_new.png" class="ml_5"  alt=""/></c:if>
				</td>
				<td class="line">${result.WRITNG_DT}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</div>
</c:if>

