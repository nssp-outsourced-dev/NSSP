<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/js/gpki/var.js"></script>
<script type="text/javascript" src="/js/gpki/json2.js"></script>
<script type="text/javascript" src="/js/gpki/ui/Issuer.js" ></script>
<script type="text/javascript" src="/js/gpki/ui/CertSelector_ko-KR.js"></script>
<script type="text/javascript" src="/js/gpki/ui/CertSearchWindow_ko-KR.js" ></script>
<script type="text/javascript" src="/js/gpki/ui/CertSearchWindow_ko-KR.js" ></script>
<script type="text/javascript" src="/js/gpki/ui/certviewR_ko-KR.js" ></script>
<script type="text/javascript" src="/js/gpki/ui/pinWindowR_ko-KR.js" ></script>
<script type="text/javascript" src="/js/gpki/ui/SecureTokenWindow_ko-KR.js" ></script>
<script type="text/javascript" src="/js/gpki/GPKIErrorText.js" ></script>
<script type="text/javascript" src="/js/gpki/GPKISecureWebNP.js?jsessionid=${sessionid}"></script>
<link rel="stylesheet" type="text/css" href="/css/gpki/style.css" />
<link rel="stylesheet" type="text/css" href="/css/gpki/gsw-jquery-ui.min.css"/>

<script type="text/javascript">

	$(function() {
		$(document).ready(function(){
			$('#txtFile').MultiFile({
			    accept: '<c:forEach var="format" items="${formatList}" varStatus="status">${format}<c:if test="${!status.last}">|</c:if></c:forEach>',
                max: 1,
			    list: '#fileList',
			    STRING: {
			    	remove: "<input type='button' value='삭제' class='btn_small' id='btnRemove'>",
			        selected: 'Selecionado: $file',
			        denied: '$ext 는(은) 업로드 할수 없는 파일확장자 입니다.',
			        duplicate: '$file 는(은) 이미 추가된 파일입니다.'
			    }
			});

			if(!fnIsEmpty('${rntimg}')) {
				var rntimg = parseInt ('${rntimg}');
				var cvrstcode = parseInt ('${cvrstcode}');				
				if (cvrstcode != 1) alert("이미지가 부적합합니다. 다른 이미지를 사용하여 주십시오.");
				else if(rntimg > 0) alert("이미지가 저장되었습니다.");
				else alert("이미지 저장 중 오류가 발생되었습니다.\n\n다시 저장해주세요.");
			}
			if(!fnIsEmpty('${gpkiReg}')) {
				if('${gpkiReg}' == "888") alert("GPKI가 등록되었습니다.");
				else alert("GPKI가 등록 중 오류가 발생되었습니다.\n\n다시 등록하여 주십시오.");
			}
			
		    $('#characterTableTextarea').on('keyup', function() {

		        if($(this).val().length > 50) {
		        	alert("50개 까지 입력 가능합니다.");
		            $(this).val($(this).val().substring(0, 50));
		        }
		    });

		});
	})

	function fnUpdate(){
		if(fnFormValueCheck("addForm")){
			if(confirm("사용자정보를 수정하시겠습니까?")){
				$('#txtHpNo').val($('#txtHpNo1').val()+"-"+$('#txtHpNo2').val()+"-"+$('#txtHpNo3').val());
				$('#txtTelNo').val($('#txtTelNo1').val()+"-"+$('#txtTelNo2').val()+"-"+$('#txtTelNo3').val());
				$('#txtFaxNo').val($('#txtFaxNo1').val()+"-"+$('#txtFaxNo2').val()+"-"+$('#txtFaxNo3').val());

				$('#hidCharacterTable').val( $("#characterTableTextarea").val() );
				
				var iUrl = '<c:url value='/member/updateSelfAjax/'/>';
		 		var queryString =  $('#addForm').serialize();
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						alert("수정되었습니다.");
					}else{
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);
			}
		}
	}

	function jusoReturnValue (returnValue) {
		$("#txtResdncAddr").val(returnValue.addr);
		$("#txtResdncZip").val(returnValue.zipCd);
	}

	function fnSaveFaceImg (fis) {
		//저장
		setTimeout(function(){
			var str = fis.value;
			var strDiv = $("#fileList").find(".MultiFile-title").text();
			if(fnIsEmpty(str) || fnIsEmpty(strDiv)) {
				//alert("선택된 파일이 없습니다.");
			} else {
				$('#addFaceForm').attr('action', '<c:url value="/member/addFaceImg/"/>');
				showLoading();
				$('#addFaceForm').submit();
			}
		}, 1000);
	}
	function fnFileDel (fileId, fileTy) {
		if(!fnIsEmpty(fileId) && !fnIsEmpty(fileTy)) {
			if(confirm("파일을 삭제 하시겠습니까?")){
		 		var processAfterGet = function(data) {
					if(data.result == "1"){
						alert("삭제되었습니다.");
					}else{
						alert("진행중 오류가 발생하였습니다.");
					}
			    };
				Ajax.getJson('<c:url value="/member/deleteBioTmpFile/"/>', "fileId="+fileId+"&fileTy="+fileTy, processAfterGet);
			}
		}
	}
	function fnFaceCr () {
		<%
			int fCount = 5;
			String fRNDValue = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz";
			int fMAX_LNG = 15;
			StringBuffer fTemp = new StringBuffer();
			java.util.Random frandom = new java.util.Random();
			for(int i=1; i<fCount; i++){
				for(int j=1; j<fMAX_LNG; j++){
					int fRnd = frandom.nextInt(62);
					fTemp.append(fRNDValue.substring(fRnd, fRnd+1));
				}
			}
		%>
		var strCoo = "<%=fTemp%>";
		var esId = $("#hidEsntlID").val();

		if(!fnIsEmpty(esId)) {
			
			/*if(fnChkAgentIE () == "IE") {
				var path = String.fromCharCode(34) + "C:\\NSSP\\cuFace\\CUFaceLogin.exe" + String.fromCharCode(34);
				var WshShell = new ActiveXObject("WScript.Shell");
				var intError = WshShell.Run(path+" /cuface://1"+esId+strCoo, 1, false);
			} else {
				$("#ifameRun").remove();
				var iframe = $("<iframe id=\"ifameRun\" />").attr("src","cuface://2"+esId+strCoo);
				$(document).find("body").append(iframe);
			}*/
			$("#ifameRun").remove();
			var iframe = $("<iframe id=\"ifameRun\" />").attr("src","cuface://2"+esId+strCoo);
			$(document).find("body").append(iframe);

			setTimeout(function() {
	    		var processAfterGet = function(data) {
	    			if(!fnIsEmpty(data.rstans) && data.rstans) {
	    				if(!fnIsEmpty(data.result) && data.result == "1") {
		     				alert("저장되었습니다.")
		     			} else {
		     				alert("오류가 발생되었습니다. 다시 시도하여 주십시오.")
		     			}
	    			}
	    	    };
	    		Ajax.getBioJson("<c:url value='/member/bioDtSaveAjax/'/>", "txtID="+esId + "&strCoo="+strCoo + "&strType=face", processAfterGet);
	        }, 200);  /*0.2초 후 실행*/

		} else {
			alert("사용자 정보를 확인할 수 없습니다.");
		}
	}
	function fnFingerCr () {
		<%
			int gCount = 5;
			String gRNDValue = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz";
			int gMAX_LNG = 15;
			StringBuffer gTemp = new StringBuffer();
			java.util.Random grandom = new java.util.Random();
			for(int i=1; i<gCount; i++) {
				for(int j=1; j<gMAX_LNG; j++){
					int gRnd = grandom.nextInt(62);
					gTemp.append(gRNDValue.substring(gRnd, gRnd+1));
				}
			}
		%>		
		var strCoo = "<%=gTemp%>";
		//alert(">>>> strCoo >>> "+strCoo);
		var esId = $("#hidEsntlID").val();

		if(!fnIsEmpty(esId)) {
			$("#ifameRun").remove();
			var iframe = $("<iframe id=\"ifameRun\" />").attr("src","cufinger://2"+esId+strCoo);
			$(document).find("body").append(iframe);

			var processAfterGet = function(data) {
				if(!fnIsEmpty(data.rstans) && data.rstans) {
					if(!fnIsEmpty(data.result) && data.result == "1") {
	     				alert("저장되었습니다.")
	     			} else {
	     				alert("오류가 발생되었습니다. 다시 시도하여 주십시오.")
	     			}
				}     			
    	    };
    		Ajax.getBioJson("<c:url value='/member/bioDtSaveAjax/'/>", "txtID="+esId + "&strCoo="+strCoo + "&strType=finger", processAfterGet);

		} else {
			alert("사용자 정보를 확인할 수 없습니다.");
		}
	}
	function fnGpkiReg () {
		if(!fnIsEmpty($("#hidGpkiDn").val())) {
			if(!confirm("GPKI를 재등록 하시겠습니까?")) return;
		}
        runGPKI();
        document.GpkiLoginForm.hidGpkiID.value = document.addForm.hidUserId.value;
    	document.GpkiLoginForm.hidGpkiPw.value = document.addForm.hidUserPw.value;
    	document.GpkiLoginForm.action = "/member/actionGPKIreg/";
    	Login(this,document.getElementById('GpkiLoginForm'),false);
	}
	function fnFaceDown (pid, pty) {
		if(fnIsEmpty(pid)) {
			alert("사용자 아이디를 확인할 수 없습니다.");
		} else {
			//location.href = "<c:url value='/file/getBioFileBinary/'/>?esntl_id=" + pid + "&file_ty=" + pty;
			Ajax.getJson("<c:url value='/file/getBioFileBinary/'/>", {"esntl_id": pid, "file_ty": pty}, function(data){
				if(data.result == "1"){
					var format = "data:image/png;base64,";
					var base64 = format + data.image;
					var imgData = atob(base64.split(',')[1]);
					var len = imgData.length;
					var buf = new ArrayBuffer(len);
					var view = new Uint8Array(buf);
					var blob, i;
					
					for(i = 0; i < len; i++){
						view[i] = imgData.charCodeAt(i) & 0xff;
					}
					
					blob = new Blob([view], {type: "application/octet-stream"});
					console.log(view);
					console.log(blob);
					if(window.navigator.msSaveOrOpenBlob){
						window.navigator.msSaveOrOpenBlob(blob, "${sessionScope.esntl_id}" + ".jpg");
					}else{
						var a = document.createElement("a");
						a.style = "display: none";
						a.href = format + data.image;
						a.download = "${sessionScope.esntl_id}" + ".jpg";
						document.body.appendChild(a);
						a.click();
						
						setTimeout(function(){
							document.body.removeChild(a);
						}, 1000);
					}
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
			});
		}		
	}
	
	
	
</script>

<!--본문시작 -->
<!--버튼 -->
<div class="com_box  t_right">
	<div class="btn_box">
	<a href="javascript:void(0);" id="btnUpdate" onClick="fnUpdate();" class="btn_st2 icon_n fl ">수정</a>
	</div>
</div>

<!--//버튼  -->
<!--테이블 시작 -->
<div class="com_box mb_30">
	<div class="tb_01_box">
	<form id="addForm" name="addForm" method="post">
		<input type="hidden" id="hidEsntlID" name="hidEsntlID" value="${result.ESNTL_ID}">
		<input type="hidden" id="hidUserId" name="hidUserId" value="${result.USER_ID}">
		<input type="hidden" id="hidUserPw" name="hidUserPw" value="${result.USER_PW}">
		<input type="hidden" id="hidCharacterTable" name="hidCharacterTable" value="">

		<table  class="tb_01">
		<col width="200px"/>
		<col width=""/>
		<col width="200px"/>
		<col width=""/>
		<tbody>


		<tr>
			<th>ID</th>
			<td>${result.USER_ID}</td>
			<th>성명 <span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td><input type="text" id=txtUserNm name="txtUserNm" maxlength="20" class="w_150px input_com" check="text" checkName="성명" value="${result.USER_NM}"></td>
		</tr>
		<tr>
			<th>비밀번호 변경일</th>
			<td>
				<input type="text" id="txtPwChangeDe" name="txtPwChangeDe" class="w_150px input_com" readonly value="${result.PW_CHANGE_DE}">
				<input type="button" id="btnResetPw" value="비밀번호 변경" class="btn_text" onclick="fnChangePw();" >
			</td>
			<th>로그인 타입</th>
			<td>
				<select id="selLoginTy" name="selLoginTy" class="w_150px input_com" check="text" checkName="로그인 타입">
					<option value="1" <c:if test="${result.LOGIN_TY == null || '1' eq result.LOGIN_TY}">selected</c:if>><c:out value="1단계 로그인" /></option>
					<option value="2" <c:if test="${'2' eq result.LOGIN_TY}">selected</c:if>><c:out value="2단계 로그인" /></option>
				</select>
			</td>
		</tr>
		<tr>
			<th>비밀번호 질문 <span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td colspan="3">
				<select id="selpwQestnCd" name="selpwQestnCd" class="w_250px input_com" check="text" checkName="비밀번호 질문">
					<option value="">==선택하세요==</option>
					<c:forEach var="cd" items="${qestnList}">
						<option value="${cd.cd}" <c:if test="${cd.cd eq result.PW_QESTN_CD}">selected</c:if>><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<th>비밀번호 답변 <span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td colspan="3">
				<input type="text" id=txtpwQestnAnswer name="txtpwQestnAnswer" maxlength="100" class="w_250px input_com" check="text" checkName="비밀번호 답변" value="${result.PW_QESTN_ANSWER}">
			</td>
		</tr>
		<tr>
			<th>부서</th>
			<td>${result.DEPT_NM}</td>
			<th>권한</th>
			<td>${result.AUTHOR_NM}</td>
		</tr>
		<tr>
			<th>직급 <span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<select id="selClsfCd" name="selClsfCd" class="w_150px input_com" check="text" checkName="직급">
					<option value="">==선택하세요==</option>
					<c:forEach var="cd" items="${clsfList}">
						<option value="${cd.cd}" <c:if test="${cd.cd eq result.CLSF_CD}">selected</c:if>><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
			</td>
			<th>직책 <span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td>
				<select id="selRspofcCd" name="selRspofcCd" class="w_150px input_com" check="text" checkName="직책">
					<option value="">==선택하세요==</option>
					<c:forEach var="cd" items="${rspofcList}">
						<option value="${cd.cd}" <c:if test="${cd.cd eq result.RSPOFC_CD}">selected</c:if>><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
			</td>
		</tr>

		<tr>
			<th>담당업무</th>
			<td><input type="text" id=txtChrgJob name="txtChrgJob" maxlength="50" class="w_250px input_com" value="${result.CHRG_JOB}"></td>
			<th>이메일</th>
			<td><input type="text" id=txtEmail name="txtEmail" maxlength="50" class="w_250px input_com" value="${result.EMAIL}"></td>
		</tr>
		<tr>
			<th>주소</th>
			<td colspan="3">
			<input type="text" id="txtResdncZip" name="txtResdncZip" maxlength="10" class="w_100px input_com" value="${result.RESDNC_ZIP}">
			<input type="button" value="" class="btn_search" onclick="fnZipPop();">
			<input type="text" id="txtResdncAddr" name="txtResdncAddr" maxlength="500" class="w_50p input_com" value="${result.RESDNC_ADDR}">
			</td>
		</tr>
		<tr>
			<th>휴대폰 <span class="point"><img src="/img/point.png"  alt=""/></span></th>
			<td colspan="3">
				<c:set var="hpNo" value="${fn:split(result.HP_NO,'-')}" />
				<input type="hidden" id="txtHpNo" name="txtHpNo" value="${result.HP_NO}">
				<select id="txtHpNo1" name="txtHpNo1" size="1" class="w_80px input_com mr_5" check="text" checkName="휴대폰">
					<option value="" selected >선택</option>
					<c:forEach var="cd" items="${hpList}">
						<option value="${cd.cdNm}" <c:if test="${cd.cdNm eq hpNo[0]}">selected</c:if>><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
				<input type="text" id="txtHpNo2" name="txtHpNo2" maxlength="4" value="${hpNo[1]}" class="w_80px input_com onlyNumber" check="text" checkName="휴대폰">
				-
				<input type="text" id="txtHpNo3" name="txtHpNo3" maxlength="4" value="${hpNo[2]}" class="w_80px input_com onlyNumber" check="text" checkName="휴대폰">
			</td>
		</tr>
		<tr>
			<th>연락처(사무실)</th>
			<td>
				<c:set var="telNo" value="${fn:split(result.TEL_NO,'-')}" />
				<input type="hidden" id="txtTelNo" name="txtTelNo" value="${result.TEL_NO}">
				<select id="txtTelNo1" name="txtTelNo1" size="1" class="w_80px input_com mr_5">
					<option value="" selected >선택</option>
					<c:forEach var="cd" items="${telList}">
						<option value="${cd.cdNm}" <c:if test="${cd.cdNm eq telNo[0]}">selected</c:if>><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
				<input type="text" id="txtTelNo2" name="txtTelNo2" maxlength="4" value="${telNo[1]}" class="w_80px input_com onlyNumber">
				-
				<input type="text" id="txtTelNo3" name="txtTelNo3" maxlength="4" value="${telNo[2]}" class="w_80px input_com onlyNumber">
			</td>
			<th>FAX 번호</th>
			<td>
				<c:set var="faxNo" value="${fn:split(result.FAX_NO,'-')}" />
				<input type="hidden" id="txtFaxNo" name="txtFaxNo" value="${result.FAX_NO}">
				<select id="txtFaxNo1" name="txtFaxNo1" size="1" class="w_80px input_com mr_5">
					<option value="" selected >선택</option>
					<c:forEach var="cd" items="${telList}">
						<option value="${cd.cdNm}" <c:if test="${cd.cdNm eq faxNo[0]}">selected</c:if>><c:out value="${cd.cdNm}" /></option>
					</c:forEach>
				</select>
				<input type="text" id="txtFaxNo2" name="txtFaxNo2" maxlength="4" value="${faxNo[1]}" class="w_80px input_com onlyNumber">
				-
				<input type="text" id="txtFaxNo3" name="txtFaxNo3" maxlength="4" value="${faxNo[2]}" class="w_80px input_com onlyNumber">
			</td>
		</tr>
		</tbody>
		</table>
	</form>
	<form id="addFaceForm" name="addFaceForm" method="post" enctype="multipart/form-data">
		<table  class="tb_01" style="margin-top: 10px; border-top: 1px solid #ccc;">
			<col width="200px"/>
			<col width=""/>
			<col width="200px"/>
			<col width=""/>
			<tbody>
				<tr>
					<th>FACE ID 등록</th>
					<td colspan="3">
						<input type="hidden" id="tmpa"/>
						<input type="hidden" id="tmpb"/>
						<input type="button" id="btnFaceCr" value="사진촬영" class="btn_text" onclick="fnFaceCr();" style="float: left; margin-left: 0px;">
						<input type="file" id="txtFile" name="txtFile" value="사진 선택" style="float: left; margin-left: 10px; line-height:32px;" onchange = "fnSaveFaceImg (this)">
						<p class="dot" style="line-height:30px;">&nbsp;&nbsp;등록가능한 확장자 : <c:forEach var="format" items="${formatList}" varStatus="status">${format}<c:if test="${!status.last}">, </c:if></c:forEach></p>
						<c:forEach var="list" items="${faceFileList}" varStatus="status">
							<div id="fileList" class="file mt_5" style="line-height:30px; float: left; width: 100%">
								<input type='button' value='삭제' 	class='btn_text w_50px fl' id='btnRemove' 	onclick="fnFileDel ('${list.ESNTL_ID}','face')" 	style="display: list-item; margin-left: 0px;">
								<input type='button' value='다운로드' 	class='btn_text w_80px fl' id='btnFaceDown' onclick="fnFaceDown('${list.ESNTL_ID}','face')" 	style="display: list-item; margin-left: 5px; border-radius: 3px;">
								<span class="ml_10">face</span> 
							</div>
						</c:forEach>						
					</td>
				<tr>
				<tr>
					<th>FINGER ID 등록</th>
					<td colspan="3">
						<input type="hidden" id="tmpc"/>
						<input type="hidden" id="tmpd"/>
						<input type="button" id="btnFingerCr" value="지문스캔" class="btn_text" onclick="fnFingerCr();" style="float: left; margin-left: 0px;">
						<c:forEach var="list" items="${fingerFileList}" varStatus="status">
							<div id="fgfileList" class="file mt_5" style="line-height:30px; float: left; width: 100%">
								<input type='button' value='삭제' 	class='btn_text w_50px fl' id='btnRemove' 	onclick="fnFileDel ('${list.ESNTL_ID}','finger')" 	style="display: list-item; margin-left: 0px;">
								<span class="ml_10">finger</span> 
							</div>
						</c:forEach>
					</td>
				<tr>
				<tr>
					<th>FACE ID</th>
					<td colspan="3">
						<c:choose>
							<c:when test="${result.UR_FACE_LICENSE != null && result.UR_FACE_LICENSE != ''}">
								${result.UR_FACE_LICENSE}
							</c:when>
							<c:otherwise>
								관리자에게 문의하세요.
							</c:otherwise>
						</c:choose>
					</td>
				<tr>
				<tr>
					<th>GPKI등록</th>
					<td>
						<input type="button" id="btnGpkiReg" class="btn_text" onclick="javascript:fnGpkiReg();" style="float: left; margin-left: 0px;" value="GPKI등록">
						<input type="hidden" id="hidGpkiDn" value="${result.GPKI_DN}" />
						<span style="float: left; line-height: 30px; margin-left: 10px;">
							<c:choose>
								<c:when test="${result.GPKI_DN == null && result.GPKI_DN eq ''}">
									미등록
								</c:when>
								<c:otherwise>
									등록완료
								</c:otherwise>
							</c:choose>
						</span>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
	<form name="GpkiLoginForm" id="GpkiLoginForm" action ="/member/actionGPKIreg/" method="post"> <!-- "<c:url value='/member/actionCrtfctLogin/'/>" -->
		<div style="visibility:hidden;display:none;">
			<input disabled type="hidden" name="challenge" value="${challenge}" />
			<input type="hidden" name="sessionid" id="sessionid" value="${sessionid}">
			<input type="hidden" name="hidGpkiID" id="hidGpkiID"/>
			<input type="hidden" name="hidGpkiPw" id="hidGpkiPw"/>
		</div>
	</form>
	
	<!-- ////////////문자표//////////// -->
	<table  class="tb_01" style="margin-top: 10px; border-top: 1px solid #ccc;">
		<col width="200px"/>
		<col width=""/>
		<col width="200px"/>
		<col width=""/>
		<tbody>
			<tr>
				<th>자주 쓰는 문자표 등록</th>
				<td colspan="3">
					<textarea id="characterTableTextarea" style="width: 1200px;height: 27px;resize: none;font-size: 16px;letter-spacing:10px;" rows="1" cols="45" >${result.CHARACTER_TABLE}</textarea>
				</td>
			</tr>
		</tbody>
	</table>
	
	</div>
</div>





