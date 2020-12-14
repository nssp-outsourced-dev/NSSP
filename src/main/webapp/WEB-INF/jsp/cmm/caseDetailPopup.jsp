<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/inc/header.jsp" />

<script type="text/javascript">

	var ifrId = "ifrCaseDetail";

	$(function() {

		$(document).ready(function(){
			fnCaseInfoTabOpen('tab1');	//사건정보탭 open
		});

		//탭 클릭시 활성화 이미지 표시
		$("#ulTabMenu>li>a").click(function(){
			$("#ulTabMenu a").removeClass("on");
			$(this).addClass("on");
			fnCaseInfoTabOpen(this.id);
		});


		//탭 메뉴 open
		//탭메뉴의 iframe을 호출하기 위한 url을 작성해주세요
		function fnCaseInfoTabOpen(tabId){

			var url = "";

			if( tabId == "tab1" ){			//사건정보
				url = "/rc/caseInfoIframe/";
			} else if( tabId == "tab2" ){	//대상자정보
				url = "/rc/caseTrgterInfoIframe/";
			} else if( tabId == "tab3" ){	//배당이력
				url = "/alot/historyPopup/?rcNo="+$("#hidRcNo").val() ;
			} else if( tabId == "tab4" ){	//출석요구
				url = "/inv/atendPopup/?rcNo="+$("#hidRcNo").val() ;
			} else if( tabId == "tab5" ){	//지휘건의
				url = "/inv/sugestHistoryPopup/?rcNo="+$("#hidRcNo").val() ;
			} else if( tabId == "tab6" ){	//영장정보
				url = "/inv/zrlongPopup/?rcNo="+$("#hidRcNo").val() ;
			} else if( tabId == "tab7" ){	//송치정보
				url = "/trn/trnInfoPopup/?rcNo="+$("#hidRcNo").val();
			} else if( tabId == "tab8" ){	//문서정보
				url = "/doc/reportCaseListPopup/?rcNo="+$("#hidRcNo").val() ;
			}

			$("#caseDetailFrm").attr("target", ifrId);
			$("#caseDetailFrm").attr("action", url);

			$('#caseDetailFrm').submit();
		}

	});

</script>

<!--팝업박스 -->
<div class="popup_body">
	<!--본문시작 -->
	<div class="tabnbtn_box2">
		<div class="tab_box2">
			<!--텝메뉴 -->
	  		<ul id="ulTabMenu">
	   			<li><a htrf="#" id="tab1" class="on">사건정보</a></li>
	  			<li><a htrf="#" id="tab2">대상자정보</a></li>
	  			<!-- <li><a htrf="#" id="tab3">배당이력</a></li> -->
	  			<li><a htrf="#" id="tab4">출석요구</a></li>
	  			<li><a htrf="#" id="tab5">지휘건의</a></li>
	  			<li><a htrf="#" id="tab6">영장정보</a></li>
	  			<li><a htrf="#" id="tab7">송치정보</a></li>
	  			<li><a htrf="#" id="tab8">문서정보</a></li>
	  		</ul>
			<!--//텝메뉴 -->
		</div>

		<!--테이블 시작 -->
		<div id="divIframe">
			<form id="caseDetailFrm" method="post">
				<input type="hidden"	id="hidRcNo" 		name="hidRcNo" 		value="${rcNo}"> 	<!-- 접수번호 -->
				<input type="hidden"	id="hidItivNo" 		name="hidItivNo" 	value="${itivNo}">	<!-- 내사번호 -->
				<input type="hidden"	id="hidCaseNo" 		name="hidCaseNo" 	value="${caseNo}">	<!-- 사건번호 -->
				<input type="hidden"	id="hidSearchYn" 	name="hidSearchYn" 	value="N">			<!-- 검색여부 -->
			</form>

			<!-- ifrmae -->
			<iframe name="ifrCaseDetail" id="ifrCaseDetail"  style="width  : 100%; height : 755px;"  scrolling="no" ></iframe>
		</div>
</div>