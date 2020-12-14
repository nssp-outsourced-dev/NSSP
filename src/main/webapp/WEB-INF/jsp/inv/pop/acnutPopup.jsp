<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp" />
<script type="text/javascript">
	$(function() {

	});
	function fnSave () {
		if(fnFormValueCheck ("dtlForm") ) {
			parent.acnutPopup.hide();
		}
	}
	function fnRdoClk (val) {
		if(!fnIsEmpty(val) && val == "01339") {
			$("#txtAcnutNm").prop("readonly", true);
		} else {
			$("#txtAcnutNm").prop("readonly", false);
		}
	}
</script>
</head>
<body>
	<div class="popup_body">
	<form id="dtlForm" onsubmit="return false;">
		<input type="hidden" id="hidRcNo" name="grdRcNo" value="${hidRcNo}"/>
		<input type="hidden" id="hidTrgterSn" name="grdTrgterSn" value = "${hidTrgterSn}" />
		<input type="hidden" id="hidZrlongReqstNo" name="grdZrlongReqstNo" value="${hidZrlongReqstNo}"/>
		<div class="search_box">
			<div class="search_in" style="border-right:0px">
				<div class="stitle w_100px">영장신청번호</div>
				<input type="text" class="w_150px input_com" id="txtZrlongReqstNo" name="txtZrlongReqstNo" value="${hidZrlongReqstNo}" disabled="disabled">
			</div>
		</div>
		<div class="com_box mt_10">
			<div class="title_s_st2 w_50p fl">
				<img src="/img/title_icon1.png" alt="" />계좌정보
			</div>
			<div class="fr t_right">
				<input type="submit" name="input_button" value="확인" class="btn_st4 icon_n" onclick="fnSave ()">
			</div>
		</div>

		<!--테이블 시작 -->
		<div class="com_box mb_10">
		<div class="tb_01_box">
		<table class="tb_03">
			<colgroup>
			<col width="" />
			<col width="" />
			</colgroup>
			<tbody>
				<tr class="h_40px">
					<th>계좌명의인 <img src="/img/point.png" /></th>
					<td>
						<c:forEach var="cd" items="${acnutNmLst}">
							<div class='input_radio2 t_left'>
								<input class="to-labelauty-icon" type="radio" name="grdAcnutNmCd" value="${cd.cd}" <c:if test="${cd.cd eq '01339'}">checked="checked"</c:if> onclick="fnRdoClk('${cd.cd}')" check="radio" checkName="계좌명의인"/>
						    	${cd.cdNm}
						    </div>
						</c:forEach>
						<input type="text" id="txtAcnutNm" name="grdAcnutNm" maxlength="50" class="w_150px input_com ml_10" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th>거래기간</th>
					<td>
						<input type="text" name="grdDelngPd" maxlength="130" class="w_100p input_com">
					</td>
				</tr>
				<tr>
					<th>개설은행/계좌번호 <img src="/img/point.png" /></th>
					<td>
						<div class="flex_r">
							<input type="text" name="grdAcnutBank" maxlength="30" class="input_com mr_5" style="width: 30%">
							<input type="text" name="grdAcnutNo" maxlength="50" class="input_com" style="width:calc(70%- 5px);" check="text" checkName="계좌번호">
						</div>
					</td>
				</tr>
				<tr>
					<th>거래정보등의내용</th>
					<td>
						<input type="text" name="grdDelngCn" maxlength="200" class="w_100p input_com">
					</td>
				</tr>
			</tbody>
		</table>
		</div>
		</div>
	</form>
	</div>
</body>