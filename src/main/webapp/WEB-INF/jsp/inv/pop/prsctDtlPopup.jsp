<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp" />
<script type="text/javascript">
	$(function() {
		fnDatePickerImg("txtCanclRequstDt",'${dtl.canclRequstDt}',false);
		fnChkError ();
	});
	function fnChkError () {
		if(fnIsEmpty($("#hidCaseNo").val())) {
			alert("사건번호를 확인할 수 없습니다.");
			parent.prsctDtlMoPopup.hide();
		}
	}
	function prsctCancel () {
		if(!fnIsEmpty($("#txtCaseNo").val()) && $("#hidUseYn").val()!="Y") {
			alert("입건취소 요청중이거나 입건이 취소된 사건입니다.");
			return;
		}
		if(!fnFormValueCheck("dtlForm")) return;
		if(confirm("해당 사건을 입건취소요청 하시겠습니까?")) {
			$("#hidProgrsSttusCd").val("00225"); /*입건취소 요청*/
			$("#hidUseYn").val("Y");
			var iUrl = '<c:url value='/inv/cancelPrsct/'/>';
	 		var queryString =  $('#dtlForm').serialize();
	 		var processAfterGet = function(data) {
	 			if( !fnIsEmpty(data) ) {
		 			if(!fnIsEmpty(data["ERROR"])) {
						alert(data["ERROR"]);
					} else {
						alert("입건 취소 요청 되었습니다.");
					}
		 			//submit
		 			$('#dtlForm').attr('action', '<c:url value='/inv/prsctDtlPopup/'/>');
					$('#dtlForm').submit();
	 			} else {
	 				alert("입건 취소 요청 오류 발생");
	 			}
		    };
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}
</script>
</head>
<body>
	<div class="popup_body">
	<form id="dtlForm" onsubmit="return false;">
		<input type="hidden" id="hidProgrsSttusCd" name="hidProgrsSttusCd"/>
		<input type="hidden" id="hidUseYn" name="hidUseYn" value="${dtl.useYn}"/>
		<input type="hidden" id="hidSanctnId" name="hidSanctnId" value = "${dtl.canclSanctnId}" />
		<input type="hidden" id="hidCanclSn" name="hidCanclSn" value="${dtl.canclSn}"/>
		<input type="hidden" id="hidCaseNo" name="hidCaseNo" value="${dtl.caseNo}"/>
		<input type="hidden" id="hidRcNo" name="hidRcNo" value="${dtl.rcNo}"/>
		<div class="search_box">
			<div class="search_in" style="border-right:0px">
				<div class="stitle w_80px">사건번호</div>
				<input type="text" class="w_150px input_com" id="txtViewCaseNo" name="txtViewCaseNo" value="${dtl.caseNo}" disabled="disabled">
			</div>
			<div class="search_in" style="border-right:0px">
				<div class="stitle w_80px">접수번호</div>
				<input type="text" class="w_150px input_com" id="txtViewRcNo" name="txtViewRcNo" value="${dtl.rcNo}" disabled="disabled">
			</div>
		</div>
		<div class="com_box mt_10">
			<div class="title_s_st2 w_50p fl">
				<img src="/img/title_icon1.png" alt="" />사건정보
			</div>
			<div class="fr t_right">
				<input type="submit" name="input_button" value="입건취소요청" class="btn_st4 icon_n" onclick="prsctCancel ()">
			</div>
		</div>

		<!--테이블 시작 -->
		<div class="com_box mb_10">
		<div class="tb_01_box">
		<table class="tb_03">
			<caption>
			<h4>입건 상세 정보</h4>
			</caption>
			<colgroup>
			<col width="150px" />
			<col width="30%" />
			<col width="150px" />
			<col width="" style="min-width : 250px;"/>
			</colgroup>
			<tbody>
				<tr>
					<th>접수일시</th>
					<td class="t_left">${dtl.RC_WRITNG_DT}</td>
					<th rowspan="9">사건개요(2000자)</th>
					<td rowspan="9" class="h100">
						<textarea disabled="disabled">${dtl.caseSumry}</textarea>
					</td>
				</tr>
				<tr>
					<th>입건일자</th>
					<td>${dtl.prsctDe}</td>
				</tr>
				<tr>
					<th>진행상태</th>
					<td>
						<c:forEach var="cd" items="${progrsSttusList}">
							<c:choose>
								<c:when test="${cd.cd eq dtl.progrsSttusCd}">
									${cd.cdNm}
								</c:when>
							</c:choose>
						</c:forEach>
					</td>
				</tr>
				<tr>
					<th>수사단서</th>
					<td>${dtl.invProvisNm}</td>
				</tr>
				<tr>
					<th>접수형태</th>
					<td>${dtl.rcStleCd}</td>
				</tr>
				<tr>
					<th>사건구분</th>
					<td>
						<c:if test="${dtl.rcSeCd eq 'T'}">임시</c:if>
						<c:if test="${dtl.rcSeCd eq 'F'}">정식</c:if>
						<c:if test="${dtl.rcSeCd eq 'I'}">내사</c:if>
					</td>
				</tr>
				<tr>
					<th>민원인</th>
					<td>${dtl.trgterC}</td>
				</tr>
				<tr>
					<th>대상자</th>
					<td>${dtl.trgterA}</td>
				</tr>
				<tr>
					<th>위반사항</th>
					<td style="line-height: 25px;">${dtl.violtNm}</td>
				</tr>
			</tbody>
		</table>
		</div>
		</div>
		<div class="title_s_st2 fl">
			<img src="/img/title_icon1.png" alt="" />입건취소정보
		</div>
		<div class="com_box mb_20">
			<div class="tb_01_box">
			<table class="tb_03">
				<caption>
				<h4>입건 상세정보</h4>
				</caption>
				<colgroup>
				<col width="130px" />
				<col width="30%" style="min-width : 240px;"/>
				<col width="130px" />
				<col width="" />
				</colgroup>
				<tbody>
					<tr>
						<th>입건취소일시</th>
						<td>
							<div class="calendar_box mr_5 fl" style="width: 130px">
								<input type="text" class="w_100p input_com calendar" id="txtCanclRequstDt"  name="txtCanclRequstDt" check="text" checkName="입건취소일자" value="${dtl.canclRequstDt}">
								<div class="calendar_icon"><img src="/img/search_calendar.png" alt=""/></div>
							</div>
							<div class="fl">
								<input type="text" id="txtCanclRequstDt2" name="txtCanclRequstDt2" class="input_com" onkeyup="fnHHMMChk(event,'HH')" style="width: 40px;" check="text" checkName="입건취소시간" value="${dtl.canclRequstDt2}"/>:
								<input type="text" id="txtCanclRequstDt3" name="txtCanclRequstDt3" class="input_com" onkeyup="fnHHMMChk(event,'MM')" style="width: 40px;" check="text" checkName="입건취소시간" value="${dtl.canclRequstDt3}"/>
							</div>
						</td>
						<th>관할검찰</th>
						<td>
							<c:forEach var="cd" items="${exmnList}">
								<c:choose>
									<c:when test="${cd.exmnCd eq dtl.cmptncExmnCd}">
										${cd.exmnNm}
									</c:when>
								</c:choose>
							</c:forEach>
						</td>
					</tr>
					<tr>
						<th>입건취소사유<br/>(2000자 이내)</th>
						<td colspan="5" class="h100">
							<textarea id="txtCanclCn" name="txtCanclCn" check = "text" checkName = "입건취소사유">${dtl.canclCn}</textarea>
						</td>
					</tr>
				</tbody>
			</table>
			</div>
		</div>
	</form>
	</div>
</body>