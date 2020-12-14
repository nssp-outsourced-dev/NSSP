<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<script type="text/javascript">	
	$(function() {
		$(document).ready(function(){
		    $("input[name=searchNttSj]").keydown(function (key) {		 
		        if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
		        	fnSearch();
		        }
		    });

			<c:if test="${othbcPwFail eq 'Y'}">
				alert("비밀글 비밀번호가 일치하지 않습니다.")
			</c:if>
		});
		
		$("#chkAll").click(function(){
			$("input[name=chkId]").prop("checked", $(this).prop("checked"));
		});
	})

	function fnSearch() {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidPage]").val(1);
		form.attr({"method":"post","action":"<c:url value='/bbs/${bbsId}/list/'/>"});
		form.submit();
	}

	function fnDetail(bbs_sn) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidBbsSn]").val(bbs_sn);
		form.attr({"method":"post","action":"<c:url value='/bbs/${bbsId}/detail/'/>"});
		form.submit();
	}

	function fnLinkPage(page){
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidPage]").val(page);
		form.attr({"method":"post","action":"<c:url value='/bbs/${bbsId}/list/'/>"});
		form.submit();
	}

	function fnAdd() {
		var form = $("form[id=frmList]");
		$("input:hidden[id=hidAddTy]").val("A");
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
</script>

<form id="frmList" name="frmList" method="post" action="<c:url value='/bbs/detail/'/>">
<input type="hidden" id="bbsId" name="bbsId" value="${bbsId}">
<input type="hidden" id="hidAddTy" name="hidAddTy">
<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
<input type="hidden" id="hidBbsSn" name="hidBbsSn">
<input type="hidden" id="hidBbsSn" name="hidBbs">	
<input type="hidden" id="pBlock" name="pBlock" value="${pBlock}">
<input type="hidden" id="hidOthbcPw" name="hidOthbcPw">
<div class="bbs_search_box">
	<div class="tx_um" id="divRecordCount">＊전체 ${paginationInfo.getTotalRecordCount()} | ${paginationInfo.getCurrentPageNo()}/${paginationInfo.getTotalPageCount()} page</div>
	<select name="">
		<option>제목</option>
	</select> 
	<input type="text" id="searchNttSj" name="searchNttSj" maxlength="50" style="width: 250px" placeholder="검색할 키워드를 입력하세요" value="${searchNttSj}">
	<input type="button" value="검색" class="btn icon_n" onclick="fnSearch();">
</div>

<div id="bbs_box">
	<table class="bbs_list">
		<col width="100px">
		<col width="">
		<col width="100px">
		<col width="100px">
		<col width="200px">
		<col width="100px">
		<tbody>
		<thead>
			<tr>
				<th>No.</th>
				<th>제목</th>
				<th>첨부</th>
				<th>작성자</th>
				<th>등록일</th>
				<th>조회</th>
			</tr>
		</thead>
		<tbody>

		<c:if test="${fn:length(bbsList) == 0}">
			<tr><td class="t_center" colspan="7">조회된 결과가 없습니다.</td></tr>
		</c:if>
		<c:forEach var="result" items="${bbsList}" varStatus="status">

		<c:choose>
			<c:when test="${result.OTHBC_YN eq 'Y' || mngr_yn eq 'Y' || result.WRITNG_ID eq esntl_id}">
				<tr onClick="fnDetail('${result.BBS_SN}');">
			</c:when>
			<c:otherwise>
				<tr onClick="fnOthbcPw('${result.BBS_SN}')">
			</c:otherwise>
		</c:choose>	
				<td>
					<c:choose>
						<c:when test="${result.NOTICE_YN eq 'Y'}">
							<div class="notice_icon">공지</div>
						</c:when>
						<c:otherwise>
							${result.RN}
						</c:otherwise>
					</c:choose>
				</td>				
				<td class="t_left <c:if test="${result.DP > 1}">re_box${result.DP}</c:if>">				
					<c:if test="${result.DP > 1}"><img src="/img/icon_re2.png" class="mr_10" alt="" /></c:if>
					${result.NTT_SJ}
					<c:if test="${result.CMNT_CNT > 0}"><span class="font_color2">[${result.CMNT_CNT}]</span> </c:if>
					<c:if test="${result.OTHBC_YN eq 'N'}"><img src="/img/icon_pw.png" class="ml_5" alt=""/></c:if>
					<c:if test="${result.NEW_YN eq 'Y'}"><img src="/img/icon_bbs_new.png" class="ml_5"  alt=""/></c:if>
				</td>
				<td>				
					<c:if test="${result.FILE_CNT > 0}"><img src="/img/icon_file2.png" alt="" /></c:if>				
				</td>
				<td>
					${result.WRITNG_NM}
				</td>
				<td>
					${result.WRITNG_DT}
				</td>
				<td>
					${result.INQIRE_CO}
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>

	<div class="right_btn fr"> 
		<c:if test="${option.WRITNG_AUTHOR_SE eq '0' || mngr_yn eq 'Y'}">
			<a href="javascript:fnAdd();" class="btn_st2 icon_n fl">신규작성</a>
		</c:if>
	</div>


	<div class="pagebox pagebox_bbs">
		<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fnLinkPage"/>
	</div>
</div>
</form>
