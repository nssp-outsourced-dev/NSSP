<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/inc/webEditor.jsp"/>
<script type="text/javascript">
	$(function() {
		$(document).ready(function(){

			<c:if test="${mngr_yn eq 'Y'}">
				fnDatePickerImg("txtNoticeBeginDe");
				fnDatePickerImg("txtNoticeEndDe");
				$("#txtNoticeBeginDe").val("${result.NOTICE_BEGIN_DE}");
				$("#txtNoticeEndDe").val("${result.NOTICE_END_DE}");
			</c:if>
			
			$("input:radio[name=rdoOthbcYn]").click(function(){
				if($(this).val() == "Y"){
					$("#trOthbcPw").hide();
					$("#txtOthbcPw").val("");
				}else{
					$("#trOthbcPw").show();
					$("#txtOthbcPw").val("");
				}
			});
			
			<c:if test="${option.ATCH_FILE_CO ne '0'}">
				$('#txtFiles').MultiFile({
				    accept: '<c:forEach var="format" items="${formatList}" varStatus="status">${format}<c:if test="${!status.last}">|</c:if></c:forEach>',
	                max: ${option.ATCH_FILE_CO},
				    list: '#fileList',
				    STRING: {
				        remove: "<img src='/img/icon_x.png' id='btnRemove'>",
				        selected: 'Selecionado: $file',
				        denied: '$ext 는(은) 업로드 할수 없는 파일확장자 입니다.',
				        duplicate: '$file 는(은) 이미 추가된 파일입니다.'
				    }
				});
			</c:if>
		});
	})

	function fnSave(){
		<c:if test="${mngr_yn eq 'Y'}">
		if($('#selNoticeYn').val() == "Y"){
			if($('#txtNoticeBeginDe').val() == ""){
				alert("공지시작일을 선택하세요.");
				return;
			}

			if($('#txtNoticeEndDe').val() == ""){
				alert("공지종료일을 선택하세요.");
				return;
			}
		}
		</c:if>
		
		if($("input:radio[name=rdoOthbcYn]:checked").val() == "N"){
			if($('#txtOthbcPw').val() == ""){
				alert("비밀글 비밀번호를 입력하세요.");
				$('#txtOthbcPw').focus();
				return;
			}			
		}

        oEditors.getById["txtWebEditor"].exec("UPDATE_CONTENTS_FIELD", []);
		if(fnFormValueCheck("addForm")){
			$('#addForm').attr('action', '<c:url value='/bbs/addAction/'/>');
			$('#addForm').submit();
		}
	}

	function fnList(){
		$('#addForm').attr('action', '<c:url value='/bbs/${bbsId}/list/'/>');
		$('#addForm').submit();
	}

	function fnDelete(){
		if(confirm("삭제하시겠습니까?")){
			$('#addForm').attr('action', '<c:url value='/bbs/disableAction/'/>');
			$('#addForm').submit();
		}
	}
</script>

<form id="addForm" name="addForm" method="post" enctype="multipart/form-data">
<input type="hidden" id="bbsId" name="bbsId" value="${bbsId}">
<input type="hidden" id="hidAddTy" name="hidAddTy" value="${hidAddTy}">
<input type="hidden" id="hidPage" name="hidPage" value="${hidPage}">
<input type="hidden" id="hidBbsSn" name="hidBbsSn" value="${hidBbsSn}">
<input type="hidden" id="pBlock" name="pBlock" value="${pBlock}">
<input type="hidden" id="searchNttSj" name="searchNttSj" value="${searchNttSj}">

<div class="tb_01_box">
	<table class="tb_01">
		<col width="150px" />
		<col width="" />
		<col width="150px" />
		<col width="" />
		<tbody>
			<tr class="h_40px">
				<th>제목<span class="point"><img src="/img/point.png"  alt=""/></span></th>
				<td colspan="3">
					<input type="text" id=txtNttSj name="txtNttSj" maxlength="50" class="w_250px input_com" value="${result.NTT_SJ}" check="text" checkName="제목">
				</td>
			</tr>
			<c:if test="${mngr_yn eq 'Y'}">
			<tr class="h_40px">
				<th>공지설정</th>
				<td colspan="3">
					<div class=" flex_r">
						<select id="selNoticeYn" name="selNoticeYn" class="w_80px input_com mr_5">
							<option value="Y" <c:if test="${result.NOTICE_YN eq 'Y'}">selected</c:if>>공지</option>
							<option value="N" <c:if test="${result.NOTICE_YN ne 'Y'}">selected</c:if>>일반</option>
						</select>
						<div class="calendar_box  w_150px  mr_5">
							<input type="text" class="w_100p input_com calendar" id="txtNoticeBeginDe" name="txtNoticeBeginDe" value="" readonly>
						</div> ~&nbsp; 
						<div class="calendar_box  w_150px  mr_5">
							<input type="text" class="w_100p input_com calendar" id="txtNoticeEndDe" name="txtNoticeEndDe" value="" readonly>
						</div>
					</div>
				</td>
			</tr>
			</c:if>
			<tr class="h_40px">
				<th>비밀글 설정</th>
				<td colspan="3">
					<div class='input_radio2 t_left mr_5'>
						<input class="to-labelauty-icon" type="radio" name="rdoOthbcYn" value="Y" <c:if test="${result.OTHBC_YN ne 'N'}">checked</c:if>/> 공개
					</div>
					<div class='input_radio2 t_left mr_5'>
						<input class="to-labelauty-icon" type="radio" name="rdoOthbcYn" value="N" <c:if test="${result.OTHBC_YN eq 'N'}">checked</c:if>/> 비공개
					</div>
				</td>
			</tr>
			<tr class="h_40px" id="trOthbcPw" <c:if test="${result.OTHBC_YN ne 'N'}">style="display:none;"</c:if>>
				<th>비밀글 비밀번호</th>
				<td colspan="3">
					<input type="password" id=txtOthbcPw name="txtOthbcPw" maxlength="20" class="w_150px input_com">
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td colspan="3">
					<textarea id="txtWebEditor" name="txtNttCn" style="width:100%; min-width:100%; display:none;">${result.NTT_CN}</textarea>	
				</td>
			</tr>

		<c:if test="${option.ATCH_FILE_CO ne '0'}">
			<tr>
				<th>저장된 파일</th>
				<td colspan="3">
				<iframe id="ifrFile" src="<c:url value='/file/fileListOwnerIframe/'/>?ifr_id=ifrFile&file_id=${result.FILE_ID}" scrolling="no" frameborder="0" width="100%" height="0px" ></iframe>
				</td>
			</tr>
			<tr>
				<th>첨부 파일</th>
				<td colspan="3">
					<p style="line-height:30px;">사용가능한 확장자 : <c:forEach var="format" items="${formatList}" varStatus="status">${format}<c:if test="${!status.last}">, </c:if></c:forEach></p>
					<input type="file" id="txtFiles" name="txtFiles">
					<div id="fileList" class="file" style="line-height:30px;"></div>
				</td>
			</tr>
		</c:if>
		</tbody>
	</table>
</div>
</form>

<div class="right_btn fr mb_20 mt_20">
	<a href="javascript:void(0);" id="btnClear" onClick="fnList();" class="btn_st2 icon_n fl mr_m1">목록</a>
	<a href="javascript:void(0);" id="btnAdd" onClick="fnSave();" class="btn_st2 icon_n fl mr_m1">저장</a>
	<c:if test="${result!=null}">
		<a href="javascript:void(0);" id="btnUpdate" onClick="fnDelete();" class="btn_st2 icon_n fl mr_m1">삭제</a>
	</c:if>
</div>
