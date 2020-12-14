<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/inc/header.jsp" />

<script type="text/javascript" src="/js/validate/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/rc.common.js"></script>
<script type="text/javascript" src="/js/rc.validate.js"></script>
<script type="text/javascript">

	var gridTargetList;
	var myGridID = "#grid_target";

	$(function() {

		fnDatePickerImg( "txtCnsltDe", null, false );	//상담 일시

		$(document).ready(function(){

			fnDatePickerImg("txtOccrrncBeginDe", null, false );	//발생 일시 begin
			fnDatePickerImg(  "txtOccrrncEndDe", null, false );	//발생 일시 end

			var param = $('#caseBasicInfoForm').serialize();
			var processAfterGet = function(data) {
				fn_form_bind("caseForm", data);
			}

			Ajax.getJson( "<c:url value='/rc/getCaseInfoByFormBindAjax/'/>",	param, processAfterGet );

			$('#txtFiles').MultiFile({
				accept : '<c:forEach var="format" items="${formatList}" varStatus="status">${format}<c:if test="${!status.last}">|</c:if></c:forEach>'
				, list : '#fileList'
				 , max : 1
			,STRING : {
					  remove : "<input type='button' value='삭제' class='btn_small' id='btnRemove'>"
		  		  , selected : 'Sectionlecionado: $file'
					, denied : '$ext 는(은) 업로드 할수 없는 파일확장자 입니다.'
				 , duplicate : '$file 는(은) 이미 추가된 파일입니다.'
				   , toomany : "업로드할 수 있는 최대 갯수는 $max개 입니다."
				}
			});
		});

		$("#btnCaseSave").click(function(){	//저장 버튼 클릭
			$("#caseForm").submit();
		});
	});


	//파일 저장
	function fnInsertFile(){

		var form = $('#caseForm')[0];
		var formData = new FormData(form);

		$.ajax({
			    url : '/rc/uploadFile/'
			, async : false
	  , processData : false
  	  , contentType : false
			 , data : formData
			 , type : 'POST'
		  , success : function(result) {
						if (null != result) {
							$("#hidFileId").val(result);
							return 1;
						} else {
							return 0;
						}
					  }
		});
	}

	function fnUpdate() {

		if (0 < $("#btnRemove").length) {

			if (fnInsertFile() < 1) {
				alert("첨부파일 저장에 문제가 생겨 사건을 저장하지 못하였습니다.\n사건접수를 작성후 다시 진행해주세요.\n오류가 반복될 경우 관리자에게 문의해주세요");
				return;
			}
		}

		if (confirm("사건정보를 수정하시겠습니까?")) {

			var iUrl = '<c:url value='/rc/updateCaseInfoAjax/'/>';
			var queryString = $('#caseForm').serialize() + "&" + $('#caseBasicInfoForm').serialize();
			var processAfterGet = function(data) {
				if (data.result == "1") {
					alert("수정되었습니다.");
					parent.caseUpdatePopup.hide();
				} else {
					alert("진행중 오류가 발생하였습니다.");
				}
			};
			Ajax.getJson(iUrl, queryString, processAfterGet);
		}
	}

	//위반사항결과 리턴
	function fnSelectViolt(upcd, cd, nm){
		$("#txtVioltNm").val(nm);
		$("#hidVioltCd").val(cd);
	}
</script>

<!--본문시작 -->
<div>
	<!--//버튼  -->
	<!--테이블 시작 -->
	<form id="caseBasicInfoForm" name="caseBasicInfoForm" method="post">
		<input type="hidden" id="hidRcNo" 	name="hidRcNo" 	 value="${rcNo}">	<!-- 접수번호 -->
		<input type="hidden" id="hidItivNo" name="hidItivNo" value="${itivNo}">	<!-- 내사번호 -->
		<input type="hidden" id="hidCaseNo" name="hidCaseNo" value="${caseNo}">	<!-- 사건번호 -->
		<input type="hidden" id="hidRcSeCd" name="hidRcSeCd" value="${rcSeCd}">	<!-- 사건구분 -->
		<input type="hidden" id="hidFileId" name="hidFileId" value="">
		<input type="hidden" id="hidSelectAddress" 	name="hidSelectAddress" value="">
		<input type="hidden" id="screenClassification" value="U">
	</form>
	<!--버튼 -->
	<div class="right_btn fr">
		<a class="btn_st2 icon_n fl mr_m1" id="btnCaseSave"  style="margin-bottom: 5px; margin-right: 16px;margin-top: 3px;">저장</a>
	</div>
	<div class="contents marginbot" style="margin-bottom: 0px;margin-left: 14px; ">
		<form id="caseForm" name="caseForm" method="post"enctype="multipart/form-data">
			<!-- 민원인 연락처 -->
			<div id="contentC">
				<div id="divCaseInfo" class="tb_01_box" style="width: 1000px;">
					<table class="tb_01">
						<colgroup>
							<col width="130px">
							<col width="370px">
							<col width="130px">
							<col width="370px">
						</colgroup>
						<tbody>
							<tr>
								<th>접수번호</th>
								<td><label id="labTrimRcNo"></label></td>
								<th>
									<c:choose>
										<c:when test="${ 'INV' eq caseSeCd }">
										입건일시
										</c:when>
										<c:otherwise>
							        	접수일시
										</c:otherwise>
									</c:choose>
								</th>
								<td>
									<!--달력폼-->${rcSeCd}
									<c:choose>
										<c:when test="${ 'INV' eq caseSeCd }">
											<label id="labPrsctDe"></label>
										</c:when>
										<c:otherwise>
											<label id="labRcDt"></label>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
							<tr>
								<th>사건번호</th>
								<td><label id="labTrimCaseNo"></label></td>
								<th>내사번호</th>
								<td><label id="labTrimItivNo"></label></td>
							</tr>
							<tr>
								<th>임시번호</th>
								<td><label id="labTrimTmprNo"></label></td>
								<th>사건구분</th>
								<td class="t_left"><label id="labRcSeNm"></label></td>
							</tr>
							<tr>
								<th>수사단서</th>
								<td class="t_left"><label id="labInvProvisNm"></label></td>
								<th>접수형태</th>
								<td>
									<select id="selRcStleCd" name="selRcStleCd" >
										<option value="">=선택=</option>
										<c:forEach var="cd" items="${rcFormList}">
											<option value="${cd.cd}"><c:out value="${cd.cdNm}"/></option>
										</c:forEach>
									</select>

								</td>
							</tr>
							<tr>
								<th>발생일시</th>
								<td class="t_left" colspan="3">
									<!-- <label id="labOccrrncBeginDt"></label>
									-
									<label id="labOccrrncEndDt"></label> -->
									<div class="flex_r">
										<!--달력폼-->
										<div class="calendar_box  w_120px  mr_5">
								           	<input type="text" 	 id="txtOccrrncBeginDe"	  name="txtOccrrncBeginDe"	class="w_100p input_com calendar"	readonly="readonly" >
								        </div>
										<div class="fl">
											<input type="text"   id="txtOccrrncBeginDeHh" name="txtOccrrncBeginDeHh" class="input_com" onkeyup="fnHHMMChk(event,'HH')" maxlength="2" style="width: 40px;" />:
											<input type="text"   id="txtOccrrncBeginDeMi" name="txtOccrrncBeginDeMi" class="input_com" onkeyup="fnHHMMChk(event,'MM')" maxlength="2" style="width: 40px;"/>
										</div>
								       	~
								        <!--달력폼-->
								       	<div class="calendar_box  w_120px ml_5 mr_5">
									       	<input type="text" 	 id="txtOccrrncEndDe"	  name="txtOccrrncEndDe"	class="w_100p input_com calendar"	readonly="readonly">
								      	</div>
								      	<div class="fl">
											<input type="text"   id="txtOccrrncEndDeHh"   name="txtOccrrncEndDeHh" class="input_com" onkeyup="fnHHMMChk(event,'HH')" maxlength="2" style="width: 40px;" />:
											<input type="text"   id="txtOccrrncEndDeMi"   name="txtOccrrncEndDeMi" class="input_com" onkeyup="fnHHMMChk(event,'MM')" maxlength="2" style="width: 40px;"/>
										</div>
									</div>
								</td>
								<tr>
								<th>
			      					발생장소
			      				</th>
			     				<td colspan="3">
									<div class="flex_r">
										<input type="text" 	id="txtOccrrncZip" 	name="txtOccrrncZip"	maxlength="10" size="10" value="" class="w_80px input_com mr_5" >
										<input type="text" 	id="txtOccrrncAddr"	name="txtOccrrncAddr"	maxlength="50" size="50" value="" class="w_400px input_com" >
										<input type="button"id="Occrrnc" 	value="" class="btn_search" onclick="javascript:fnZipPopConnect(this)">
			      		 			</div>
								</td>
							</tr>
							<tr>
								<th>관할검찰</th>
			       				<td>
			       					<select id="selCmptncExmnCd" name="selCmptncExmnCd" size="1" class="w_180p input_com">
			           					<option value="">=선택=</option>
										<c:forEach var="cd" items="${exmnList}">
											<option value="${cd.exmnCd}"><c:out value="${cd.exmnNm}" /></option>
										</c:forEach>
			         				</select>
			         			</td>
								<th>담당자</th>
								<td><label id="labChargerNm"></label></td>
							</tr>
							<tr>
			       				<th>위반죄명<span class="point"><img src="/img/point.png" alt=""/></span></th>
			       				<td colspan="3" class="t_left">
			       					<div class="flex_r">
			         					<input type="text" 	 id="txtVioltNm"	name="txtVioltNm"	 size="50" value="" class="w_100p input_com" readonly="readonly">
			         					<input type="hidden" id="hidVioltCd"	name="hidVioltCd"	 size="50" value="" class="w_100p input_com" >
				 						<input type="button" value="" class="btn_search"	onclick="fnVioltSelect(); return false;">
					  				</div>
			       				</td>
					        </tr>
							<tr>
								<th>범죄사실<span class="point"><img src="/img/point.png" alt=""></span>
									<br>(혐의사실) <span id="txtCrmnlFactCounter">###</span>
								</th>
								<td>
									<textarea id="txtCrmnlFact" name="txtCrmnlFact" class="textarea_com w_100p"></textarea>
								</td>
								<th>기타
									<br><span id="txtEtcCnCounter">###</span>
								</th>
								<td><textarea id="txtEtcCn" name="txtEtcCn" class="textarea_com w_100p"></textarea></td>
							</tr>

							<!--
							<tr>
								<th>
				  					사건개요<span class="point"><img src="/img/point.png" alt=""></span>
				    			    <br>(수사의뢰 경위)
				    			</th>
				  				<td>
				  					<textarea id="txtCaseSumry" name="txtCaseSumry"	class="textarea_com w_100p" ></textarea>
				  				</td>
				  				<th>입증자료</th>
			  					<td>
			  						<textarea id="txtPrfDta" name="txtPrfDta" class="textarea_com w_100p"></textarea>
			  					</td>
				  			</tr>
				  			-->
							<tr>
								<th>저장된 파일</th>
								<td colspan="3" style="padding-bottom: 0px;">
									<iframe id="ifrFile" src="<c:url value='/file/fileListOwnerIframe/'/>?ifr_id=ifrFile&file_id=${fileId}" scrolling="no" frameborder="0" width="100%" style="height: 30px;"></iframe>
								</td>
							</tr>
							<tr>
								<th>첨부 파일</th>
								<td style="border-right: none">
									<div id="fileList" class="file"></div>
									<input type="file" id="txtFiles" name="txtFiles" style="height: 22px;">
								</td>
								<td colspan="2" style="border-left: none">
									<p class="dot">
										사용가능한 확장자 :
										<c:forEach var="format" items="${formatList}"
											varStatus="status">${format}<c:if test="${!status.last}">, </c:if>
										</c:forEach>
									</p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<!-- // tabC 사건접수 종료 -->
		</form>
	</div>
</div>