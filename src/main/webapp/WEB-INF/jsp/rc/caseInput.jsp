<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript" src="/js/validate/jquery.validate.min.js"></script>
<script type="text/javascript" src="/js/rc.common.js"></script>
<script type="text/javascript" src="/js/rc.validate.js"></script>
<script type="text/javascript">

	var targetPopup;
	var gridTargetList;
	var myGridID = "#grid_target";

	$(function() {

		$(document).ready(function(){
			//fnTargetPopup();
			//fnItemDisabled("T");

			$("#hidGridRowStatus").val("");	//대상자 그리드 로우 상태 초기화
			$(".td_grid").removeClass("height");

			//버튼 숨김 처리
			$("#contentT").hide();
			$("#btnCaseTrnsf").hide();			//타기관 이송
			$("#btnFormalCaseConfirm").hide();	//정식사건접수 승인
			$("#btnFormalCaseRegister").hide();	//정식사건 등록
			$("#btnItivCaseRegister").hide();	//내사사건 등록
			$("#btnAlot").hide();				//담당자 배당

			//첨부파일
			$('#txtFiles').MultiFile({
			    accept: '<c:forEach var="format" items="${formatList}" varStatus="status">${format}<c:if test="${!status.last}">|</c:if></c:forEach>',
                max: 1,
			    list: '#fileList',
			    STRING: {
			        remove: "<img src='/img/icon_x.png' id='btnRemove'>",
			        selected: 'Selecionado: $file',
			        denied: '$ext 는(은) 업로드 할수 없는 파일확장자 입니다.',
			        duplicate: '$file 는(은) 이미 추가된 파일입니다.'
			    }
			});

			initGrid();		//그리드 초기화

			fnDatePickerImg(          "txtRcDe", null, true );	//접수 일시
			fnDatePickerImg("txtOccrrncBeginDe", null, false );	//발생 일시 begin
			fnDatePickerImg(  "txtOccrrncEndDe", null, false );	//발생 일시 end
			//fnDatePickerImg(     "txtCnsltDe", null, false );	//상담 일시

		});

		$("#selInvProvisCd").change(function(){	//수사단서 선택시

			//고소/고발일 경우 사건구분 정식사건으로 고정
			var strSelInvPCd = $("#selInvProvisCd").val();
			if( "00401" == strSelInvPCd || "00402" == strSelInvPCd ){

				$("#hidRcSeCdSub").val("F");
				$("input:radio[name='rdoRcSeCd']:radio[value='F']").prop("checked", true); //사건구분 - 정식 : 체크
				$('input:radio[name=rdoRcSeCd]').attr('disabled', true);
			} else if ( "00403" == strSelInvPCd || "00404" == strSelInvPCd || "00408" == strSelInvPCd || "00405" == strSelInvPCd ) { //신고, 수사의뢰, 첩보, 수사지휘
				$("#hidRcSeCdSub").val("");
				$("input:radio[name='rdoRcSeCd']:radio[value='F']").prop("checked", false); // 선택하기
				$('input:radio[name=rdoRcSeCd]').attr('disabled', false);
				$("input:radio[name='rdoRcSeCd']:radio[value='F']").attr('disabled', false);
			} else {
				$("#hidRcSeCdSub").val("");
				$("input:radio[name='rdoRcSeCd']:radio[value='F']").prop("checked", false); // 선택하기
				$('input:radio[name=rdoRcSeCd]').attr('disabled', false);
				$("input:radio[name='rdoRcSeCd']:radio[value='F']").attr('disabled', true);
			}
		});

		//이메일 도메인 선택시 - 직접 입력으로 변경
		$("#selDomain").change(function(){

			if( "01330" == $("#selDomain option:selected").val() ){
				$("#txtEmailDomain").val("");
				$("#txtEmailDomain").removeAttr("readonly");
			} else {
				$("#txtEmailDomain").val($("#selDomain").text());
				$("#txtEmailDomain").attr({"readonly":"readonly"});
			}
		});

		//담당자 배당 선택시
		$("#btnAlot").click(function(){

			if( "" != $("#hidRcNo").val() && $("#hidRcNo").val().length > 0){
				fnAlotSelect( $("#hidRcNo").val(), 'R', 'N' );
			} else {
				alert("사건정보 저장 후 등록이 가능합니다.")
			}
		});

		//타기관 이송
		$("#btnCaseTrnsf").click(function(){

			if( fnIsEmpty( $("#hidRcNo").val() ) ) {
				alert("사건정보 저장 후 타기관이송이 가능합니다.");
				return;
			}
			if( fnIsEmpty( $("#hidChargerId").val() ) ) {
				alert("배당자 등록 후 타기관이송이 가능합니다.");
				return;
			}
			var sUrl = "<c:url value='/inv/trnsfPopup/'/>";

			trnsfPopup = dhtmlmodal.open('trnsfPopup', 'iframe', sUrl, '타기관이송', 'width=650px,height=410px,center=1,resize=0,scrolling=0')
			trnsfPopup.onclose = function(){

				var iframedoc = this.contentDoc;
				// 이송 ajax
				var str = "";
				var len = iframedoc.getElementsByName("rdoInsttSeCd").length;

				for( var i = 0 ; i < len ; i++ ){
					if( iframedoc.getElementsByName("rdoInsttSeCd")[i].checked ){
						str = iframedoc.getElementsByName("rdoInsttSeCd")[i].value;
						break;
					}
				}

				var iUrl = "<c:url value='/inv/addTrnsfRcAjax/'/>";
				var queryString = {
									hidRcNo : $("#hidRcNo").val()
							   , calTrnsfDe : iframedoc.getElementById("calTrnsfDe").value
					         , rdoInsttSeCd : str
							   , txtInsttNm : iframedoc.getElementById("txtInsttNm").value
							 , txtInsttDept : iframedoc.getElementById("txtInsttDept").value
                          , txtInsttCharger : iframedoc.getElementById("txtInsttCharger").value
							    , selResnCd : iframedoc.getElementById("selResnCd").value
								, txtResnDc : iframedoc.getElementById("txtResnDc").value
				};

				var processAfterGet = function(data) {
					if( data.result == "1" ){
						alert("이송저장되었습니다.");
						location.href = "<c:url value='/rc/myCaseStatus/'/>";
					} else {
						alert("이송 저장중 오류가 발생하였습니다.");
					}
				};
				Ajax.getJson(iUrl, queryString, processAfterGet);

				return true;
			}
		});

		//정식 사건승인요청
		$("#btnFormalCaseConfirm").click(function(){

			/* prsctPopup = dhtmlmodal.open( 'prsctPopup', 'iframe'
                    , '/inv/prsctPopup/?hidCaseNo='+$("#hidCaseNo").val()+'&hidRcNo='+$("#hidRcNo").val()
                    , '사건승인요청', 'width=1000px,height=700px,center=1,resize=0,scrolling=0'); */

			var processAfterGet = function(data) {
                if( data.result == "1" ){
					$("#btnFormalCaseConfirm").hide();	//정식사건접수 승인 버튼
					alert("정식사건 접수요청이 완료되었습니다.");
				} else {
					alert("정식사건 접수요청중 오류가 발생하였습니다.");
				}
			};

			Ajax.getJson('<c:url value='/inv/savePrsctAjax/'/>', { "hidRcNo" : $("#hidRcNo").val(), "hidSanctnId" : "hidSanctnId" }, processAfterGet);

		});

		//정식사건 등록
		$("#btnFormalCaseRegister").click(function(){
			var processAfterGet = function(data) {

			if( data == "0" ){

					$("#btnFormalCaseRegister").hide();	//정식사건 등록
					$("#btnItivCaseRegister").hide();	//내사사건 등록

					$("input:radio[name='rdoRcSeCd']:radio[value='F']").prop("checked", true); // 선택하기

					alert("접수가 완료되었습니다.");

				} else {
					alert("접수중 오류가 발생하였습니다.");
				}
			};

			Ajax.getJson('<c:url value='/rc/updateCaseConfmRequst/'/>', {"rcSeCd":$("#hidRcSeCdSub").val(), "rcNo":$("#hidRcNo").val(), "updateRcSeCd": "F", "progrsSttusCd": "00220", "crud" : "U" }, processAfterGet);
		});

		//내사사건 등록
		$("#btnItivCaseRegister").click(function(){
			var processAfterGet = function(data) {
				if( data == "0" ){
					alert("접수가 완료되었습니다.");
					$("#btnItivCaseRegister").hide();	//내사사건 접수 버튼 hide 처리
					$("input:radio[name='rdoRcSeCd']:radio[value='I']").prop("checked", true); // 선택하기
				} else {
					alert("접수중 오류가 발생하였습니다.");
				}
			};

			Ajax.getJson('<c:url value='/rc/updateCaseConfmRequst/'/>', {"rcSeCd":$("#hidRcSeCdSub").val(), "rcNo":$("#hidRcNo").val(), "updateRcSeCd": "I", "progrsSttusCd": "00210", "crud" : "U" }, processAfterGet);
		});


		//임시접수 취소 요청
		$("#btnTmprRcCancl").click(function(){
			if( confirm("작성중인 임시접수사건을 취소하시겠습니까?") ){
				alert("담당자 승인 후 취소가 완료됩니다.");
			} else {
				alert("취소");
			}
		});


		//접수사건 저장 E:Edit ,C:Complete
		$("#btnCaseSave").click(function(){

			/*
			if( "E" == $("#hidGridRowStatus").val() ){

				alert("작성중인 대상자정보가 있습니다.\n저장 또는 삭제 후 다시 진행해주세요.");
				return;
			}
			*/
			$("#caseForm").submit();
		});


		//작성화면 초기화
		$("#btnCaseInit").click(function(){
			location.reload();
		});

		targetPopup = null;
		//대상자 추가 hidGridRowStatus C:Completion, E:Edit
		$("#btnTargetAdd").click(function(){

			if( targetPopup == null || targetPopup.isClosed == true ) {

				$("#hidGridRowStatus").val("C");
				targetPopup = dhtmlmodal.open('targetInputPopup', 'iframe', '/rc/targetInputPopup/', '대상자 작성', trgterUpdatePopSize);
			}

			/*
			if( "C" == $("#hidGridRowStatus").val() ){ //그리드 로우의 상태가 Completion 일 경우만 진행

				if(confirm("대상자를 추가 하시겠습니까?")){
						//addRow();
						//$("#targetForm")[0].reset(); //form reset

						//fnTargetPopup();
						fnTargetPopup = dhtmlmodal.open('targetInputPopup', 'iframe', '/rc/targetInputPopup/', '대상자 작성', 'width=895px,height=650px,center=1,resize=0,scrolling=1')
						//fnItemDisabled();


						$("#hidGridRowStatus").val("E");
				}
			} else {
				alert("작성중인 대상자 정보가 있습니다. 저장 또는 삭제 후 진행해주세요.");
			}
			*/
		});

		//대상자 삭제
		$("#btnTargetDel").click(function(){

			if( 0 < AUIGrid.getRowCount(myGridID) ){

				if( confirm("선택한대상자를 삭제 하시겠습니까?") ){

					AUIGrid.removeCheckedRows(myGridID);
					//AUIGrid.removeRow(myGridID, "selectedIndex");
					/*
					if( 0 == AUIGrid.getRowCount(myGridID) ){
						$("#hidGridRowStatus").val("C");
						fnItemDisabled("T")
					} */
				}
			} else {
				alert("저장된 대상자가 없습니다.");
			}
		});

	});	// jQuery

	//화면 입력 제한 C: Case, T:Target, A: All
	function fnItemDisabled(val){
		if( val == "C" ){
			$("#divCaseInfo :input").addClass("case_disabled");		//사건 정보
			$('.case_disabled').attr('disabled', true);
		} else if(val == "T"){
			$("#divTargetInfo :input").addClass("target_disabled");	//대상자 정보
			$('.target_disabled').attr('disabled', true);
		} else if(val == "A"){
			$("#divCaseInfo :input").addClass("case_disabled");
			$('.case_disabled').attr('disabled', true);
			$("#divTargetInfo :input").addClass("target_grid_bind");
			$('.target_disabled').attr('disabled', true);
		} else {
			$(  '.case_disabled').attr('disabled', false);
			$('.target_disabled').attr('disabled', false);
		}
	};

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
		    , success : function(result){
		    				if(null != result){
		    					$("#hidFileId").val(result);
		    					return 1;
		    				} else {
		    					return 0;
		    				}
		    			}
		});
	}

	//사건정보 저장
	function fnCaseSaveProcess(){

		var targetListConunt = 0;

		targetListConunt = AUIGrid.getRowCount(myGridID);

		if( 0 == targetListConunt){
			alert("대상자 정보가 존재하지 않습니다.\n대상자 등록 후 진행해주세요.");

			//fnDivOpen("tabT");
			return;
		}

		if( confirm("사건정보를 저장하시겠습니까?") ) {

			if( fnInsertFile() < 1 ){
				alert("첨부파일 저장에 문제가 생겨 사건을 저장하지 못하였습니다.\n사건접수를 작성후 다시 진행해주세요.\n오류가 반복될 경우 관리자에게 문의해주세요");
				return;
			}

			if( fnCaseSave() ){
				alert("저장되었습니다.")
			} else {
				alert("사건 저장에 실패하였습니다.\n사건접수를 다시 진행해주세요.\n오류가 반복될 경우 관리자에게 문의해주세요");
			}
		}

	 }//end fnCaseSaveProcess


	//사건 저장
	function fnCaseSave(){

		var data = {};
		data.caseFormData  = $('#caseForm').serializeFormJSON();
		data.grdTargetList = AUIGrid.getGridData( myGridID );

		var rSave = fnAjaxAction( '/rc/caseSaveAction/', JSON.stringify(data) );

		if( rSave != null && rSave.returnVal > 0 ){

			$("#btnCaseInit").hide();		//초기화
			$("#btnCaseSave").hide();		//사건저장
			$("#btnTargetAdd").hide();		//대상자 추가
			$("#btnTargetDel").hide();		//대상자 삭제
			$("#divTargetComment").hide();	//대상자 추가 comment 숨김

			$("#hidRcNo").val(rSave.rcNo);
			$("#divRcNo").text(rSave.rcNo);
			$("#hidItivNo").val(rSave.itivNo);
			$("#divItivNo").text(rSave.itivNo);
			$("#hidChargerId").val(rSave.chargerId);

			$("#hidRcSeCdSub").val(rSave.rcSeCd);

			fnItemDisabled("A");	//모든정보 disable

			/*	접수기능은 내사건관리에서 처리 2019.07.25
			if( "F" == $("#hidRcSeCdSub").val() ){
				$("#btnFormalCaseConfirm").show();		//정식 사건 등록
			} else if( "T" == $("#hidRcSeCdSub").val() ){
				$("#btnFormalCaseRegister").show();		//정식접수 등록
				$("#btnItivCaseRegister").show();			//내사접수 등록
			} else if( "I" == $("#hidRcSeCdSub").val() ){
				$("#btnFormalCaseRegister").show();		//정식접수 등록
			}

			$("#btnAlot").show();		//배당자 지정
			*/

			$("#btnCaseTrnsf").show();	//사건이송

			//$("#divChargerInfo").text( $("#hidUserNm").val()+"("+$("#hidDeptNm").val()+")"); 	//담당자 정보

			return true;

		} else {
			return false;
		}
	}


	//배당결과
	function fnSelectAlot(snNo, userId, userNm, deptCd, deptNm, alotSeCd){

		if( userId !=null && userId.length > 0 ){

			$("#divChargerInfo").text(deptNm+" "+userNm);
			$("#hidChargerId").val(userId);

		} else {
			alert("담당자 배당에 실패하였습니다.\n다시 진행해주세요.");
		}
	}


	// 행 추가, 삽입
	function addRow() {

		// 그리드의 편집 인푸터가 열린 경우 에디팅 완료 상태로 만듬.
		AUIGrid.forceEditingComplete(myGridID, null);

		var item = new Object();
		var holidays = [6, 7, 13, 14];
		item.name = "";

		for(var i=1; i<=31; i++) {

			if( holidays.indexOf(i) >= 0 ){
				item[ "d" + i ] = "N";
			} else {
				item[ "d" + i ] = "P";
			}
		}
		AUIGrid.addRow(myGridID, item, "last");
	}


	// addRowFinish 이벤트 핸들링
	function auiAddRowHandler(event) {
		// 행 추가 시 추가된 행에 선택자가 이동합니다.
		// 이 때 칼럼은 기존 칼럼 그래도 유지한채 이동함.
		// 원하는 칼럼으로 선택자를 보내 강제로 편집기(inputer) 를 열기 위한 코드
		var selected = AUIGrid.getSelectedIndex(myGridID);
		if( selected.length <= 0 ) {
			return;
		}

		var rowIndex = selected[0];
		var colIndex = AUIGrid.getColumnIndexByDataField(myGridID, "name");
		AUIGrid.setSelectionByIndex(myGridID, rowIndex, colIndex); // name 으로 선택자 이동

		// 빈행 추가 후 isbn 에 인푸터 열기
		AUIGrid.openInputer(myGridID);
	};


	// field enabled, disabled 전환
	function elementsDisabled(disabled) {
		var elementArr = ["input", "select"];
		$(elementArr).each(function(idx, element) {
			$("#addForm " + element + ":visible").each(function() {
				$(this).attr("disabled", disabled);
			});
		})
		// 예외 항목
		$("#userId").attr("disabled", false);
	}

	//그리드 초기화
	function initGrid() {

		//컬럼정보 설정
		var columnLayout = [
			  { dataField : "grdTrgterSeNm"		, headerText : "구분명"		, width : 90	 }
			, { dataField : "grdTrgterTyNm"		, headerText : "대상자 유형"	, width : 90	 }
			, { dataField : "grdTrgterNm"	 	, headerText : "성명/기업명"	, width : 100	 }
			, { dataField : "grdTrgterSeCd"		, headerText : "대상자구분"		, visible : false}
			, { dataField : "grdTrgterTyCd"		, headerText : "대상자 유형"	, visible : false}
			, { dataField : "grdTrgterClCd"		, headerText : "대상자 분류"	, visible : false}
			, { dataField : "grdTrgterEngNm"	, headerText : "성명(영문)"	, visible : false}
			, { dataField : "grdSexdstnCd"		, headerText : "성별"			, visible : false}
			, { dataField : "grdSexdstnNm"		, headerText : "성별"			, visible : true, 	width : 60	}
			, { dataField : "grdTrgterRrn"		, headerText : "주민등록번호"	, visible : true, 	width : 120	}
			, { dataField : "grdTrgterAge"		, headerText : "나이"			, visible : false}
			, { dataField : "grdTrgterClNm"		, headerText : "대상자 분류명"	, width : 100	 }
			, { dataField : "grdHpNo"	 		, headerText : "휴대전화"		, visible : true,	width : 120	}
			, { dataField : "grdHpNoFront"	 	, headerText : "휴대전화"		, visible : false}
			, { dataField : "grdHpNoCenter"	 	, headerText : "휴대전화"		, visible : false}
			, { dataField : "grdHpNoBack"	 	, headerText : "휴대전화"		, visible : false}
			, { dataField : "grdOwnhomTel"		, headerText : "자택전화"		, visible : false}
			, { dataField : "grdOwnhomTelFront"	, headerText : "자택전화 "		, visible : false}
			, { dataField : "grdOwnhomTelCenter", headerText : "자택전화"		, visible : false}
			, { dataField : "grdOwnhomTelBack"	, headerText : "자택전화"		, visible : false}
			, { dataField : "grdWrcTel"	 		, headerText : "직장전화"		, visible : false}
			, { dataField : "grdWrcTelFront"	, headerText : "직장전화"		, visible : false}
			, { dataField : "grdWrcTelCenter"	, headerText : "직장전화"		, visible : false}
			, { dataField : "grdWrcTelBack"	 	, headerText : "직장전화"		, visible : false}
			, { dataField : "grdAgentSeCd"	 	, headerText : "대리인구분"		, visible : false}
			, { dataField : "grdAgentSeNm"	 	, headerText : "대리인구분"		, visible : false}
			, { dataField : "grdAgentNm"	 	, headerText : "대리인명"		, visible : false}
			, { dataField : "grdAgentTel"	 	, headerText : "대리인연락처"	, visible : false}
			, { dataField : "grdAgentTelFront"	, headerText : "대리인연락처1"	, visible : false}
			, { dataField : "grdAgentTelCenter"	, headerText : "대리인연락처2"	, visible : false}
			, { dataField : "grdAgentTelBack"	, headerText : "대리인연락처3"	, visible : false}
			, { dataField : "grdRprsntvNm"	    , headerText : "대표자명"	    , visible : false}
			, { dataField : "grdEtcTel"	 		, headerText : "기타연락처"		, visible : false}
			, { dataField : "grdEtcTelFront"	, headerText : "기타연락처"		, visible : false}
			, { dataField : "grdEtcTelCenter"	, headerText : "기타연락처"		, visible : false}
			, { dataField : "grdEtcTelBack"	 	, headerText : "기타연락처"		, visible : false}
			, { dataField : "grdOccpCd"	 		, headerText : "직업"			, visible : false}
			, { dataField : "grdOccpNm"	 		, headerText : "직업명"		, visible : false}
			, { dataField : "grdWrcNm"	 		, headerText : "직장명"		, visible : false}
			, { dataField : "grdTrgterCprn"		, headerText : "법인번호"		, visible : false}
			, { dataField : "grdTrgterCrn"		, headerText : "사업자번호"		, visible : false}
			, { dataField : "grdWrcZip"	 		, headerText : "직장 우편번호"	, visible : false}
			, { dataField : "grdWrcAddr"	 	, headerText : "직장 주소"		, visible : false}
			, { dataField : "grdAdresZip"	 	, headerText : "주소우편번호"	, visible : false}
			, { dataField : "grdAdresAddr"		, headerText : "주소지 "		, visible : true }
			, { dataField : "grdRegbsZip"	 	, headerText : "등록우편번호"	, visible : false}
			, { dataField : "grdRegbsAddr"		, headerText : "등록지"		, visible : false}
			, { dataField : "grdDwlsitZip"		, headerText : "주거지 우편번호" , visible : false}
			, { dataField : "grdDwlsitAddr"		, headerText : "주거지"		, visible : false}
			, { dataField : "grdEmail"	 		, headerText : "이메일"		, visible : true}
			, { dataField : "grdClsf"	 		, headerText : "직급"		    , visible : true}
			, { dataField : "grdNltyCd"	 		, headerText : "국적"			, visible : false}
			, { dataField : "grdNltyNm"	 		, headerText : "국적명"		, visible : false}
			, { dataField : "grdPasportNo"		, headerText : "여권번호"		, visible : false}
			, { dataField : "grdDocId"	 	  	, headerText : "문서id"		, visible : false}
		];

		//그리드 환경값 설정
		var gridPros = {
			     useGroupingPanel : false
			   , showRowNumColumn : false
			    , displayTreeOpen : true
			       , enableFilter : true
			  	  , selectionMode : "singleRow"	// 선택모드 singleCell(기본값), multipleCells, singleRow
			  	  , noDataMessage : "조회 목록이 없습니다."
	 	  	 , showRowCheckColumn : true	//gird checkbox 여부
			     , useContextMenu : false	//컨텍스트 메뉴 사용
		   , enableRightDownFocus : false	//컨텍스트 메뉴를 보기 위해 오른쪽 클릭을 한 경우 클릭 지점이 왼쪽 클릭과 같이 셀 선택을 할지 여부 기본값 : false
   , triggerSelectionChangeOnCell : true
   			 , fillColumnSizeMode : true
   		  , enableMouseWheel : true
   	   , enableHScrollByWheel : true
   	           , scrollHeight : 20

		};

		gridTargetList = AUIGrid.create(myGridID, columnLayout, gridPros);
	/* 	AUIGrid.bind(myGridID, "cellClick", function(event) {

			$("#targetForm")[0].reset(); //form 초기화

			var items = event.item;
			fn_form_bind ("targetForm",items,"GRID");
		}); */

		AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
			var  items = event.item;

			//fnCaseDetailPopup( rcNo, caseNo );	//사건상세조회 팝업 cubox.js
			items = JSON.stringify (items);
			$("#hidGridRowStatus").val("U");
			targetPopup = dhtmlmodal.open('targetInputUpdatePopup', 'iframe', '/rc/targetInputPopup/?items='+encodeURI(encodeURIComponent(items)), '대상자 수정', trgterUpdatePopSize)
		});

		/*
		// 선택 체인지 이벤트 바인딩
		AUIGrid.bind(myGridID, "selectionChange", function(event) {
			var primeCell = event.primeCell; // 선택 대표 셀
			var item = primeCell.item; // 행 정보
			//setFieldToFormWindow(primeCell, item);

			alert("셀 selectionChange ");
			$("#targetForm")[0].reset(); //form reset
			fn_form_bind ("targetForm",item,"GRID");
		});
		*/
	}
	// End inint grid

</script>

<!--본문시작 -->
<div id="tabsholder">
	<div class="tabnbtn_box" style="margin-top: 20px;">
		<!--텝메뉴
  		<ul class="tabs">
   			<li id="tabC" class="current">사건정보</li>
  			<li id="tabT">대상자정보</li>
  		</ul>
  		-->
		<!--//탭메뉴 -->
	 	<!--버튼 -->
	 	<div class="right_btn"	style="bottom: 0px;margin-bottom: 5px;">
			<a class="btn_st1 icon_n fl mr_m1"	id="btnCaseInit" >초기화</a>
			<a class="btn_st2 icon_n fl mr_m1"	id="btnCaseSave" >저장</a>
			<a class="btn_st2 icon_n fl mr_m1"	id="btnAlot" >담당자 배당</a>
			<a class="btn_st2 icon_n fl"		id="btnCaseTrnsf">타기관 이송</a>
			<a class="btn_st2 icon_n fl"		id="btnFormalCaseConfirm">정식사건 접수 승인</a>

			<a class="btn_st2 icon_n fl"		id="btnFormalCaseRegister">정식접수 등록</a>
			<a class="btn_st2 icon_n fl"		id="btnItivCaseRegister">내사접수 등록</a>
		</div>
		<!--//버튼  -->
	</div>

	<!--테이블 시작 -->
	<div class="contents marginbot">
		<input type="hidden" id="hidSelectAddress" 	name="hidSelectAddress" value="">
		<input type="hidden" id="hidUserNm" 		name="hidUserNm" 		value="${userInfo.USER_NM}">
		<input type="hidden" id="hidDeptNm" 		name="hidDeptNm" 		value="${userInfo.DEPT_NM}">

		<input type="hidden" id="screenClassification" 	name="screenClassification" value="C"><!-- 화면 구분 validate 시 사용 - 작성화면 : C / 수정화면 : U -->

		<form id="caseForm" name="caseForm" method="post" enctype="multipart/form-data">
			<input type="hidden" id="hidAddTy" 			name="hidAddTy" 		value="${hidAddTy}">
			<input type="hidden" id="hidPage" 			name="hidPage" 			value="${hidPage}">
			<input type="hidden" id="hidBbsSn" 			name="hidBbsSn" 		value="${hidBbsSn}">
			<input type="hidden" id="pBlock" 			name="pBlock" 			value="${pBlock}">

			<input type="hidden" id="searchNttSj" 		name="searchNttSj" 		value="${searchNttSj}">

			<input type="hidden" id="hidRcNo" 			name="hidRcNo" 			value="${caseRcInfo.RC_NO}"> 	<!-- 접수번호 -->
			<input type="hidden" id="hidItivNo" 		name="hidItivNo" 		value="${caseRcInfo.ITIV_NO}">	<!-- 내사번호 -->
			<input type="hidden" id="hidCaseNo" 		name="hidCaseNo" 		value="${caseRcInfo.CASE_NO}">	<!-- 사건번호 -->
			<input type="hidden" id="hidProgrsSttusCd" 	name="hidProgrsSttusCd" value="${caseRcInfo.PROGRS_STTUS_CD}">
			<input type="hidden" id="hidChargerId" 		name="hidChargerId" 	value="">
			<input type="hidden" id="hidRcSeCdSub" 		name="hidRcSeCdSub" 	value="">
			<input type="hidden" id="hidFileId" 		name="hidFileId" 		value="">
			<input type="hidden" id="hidGridRowStatus" 	name="hidGridRowStatus" value=""	>	<!--  그리드 로우 상태 -->

			<!-- tabC 사건정보 -->
			<div id="contentC" >
				<div id="divCaseInfo" class="tb_01_box" >
		 			<table class="tb_01">
					    <colgroup>
					    	<col width="150px">
						    <col width="600px" style="min-width: 500px; max-width: 700px;">
						    <col width="150px">
						    <col width="">
					    </colgroup>
					    <tbody>
			     			<tr>
						        <th>접수번호 </th>
						        <td class="t_left">
						        	<div id="divRcNo">
							        	<c:if test="${caseRcInfo.RC_NO != null}">
											${caseRcInfo.RC_NO}
										</c:if>
										<c:if test="${caseRcInfo.RC_NO == null}">
											사건저장 후 확인 가능합니다.
										</c:if>
						        	</div>
								</td>
						        <th>
						        	접수일시<span class="point"><img src="/img/point.png" alt=""></span>
						        </th>
						        <td class="t_left flex_r">
									<!--달력폼-->
									<div class="calendar_box  w_120px  mr_5">
							  			<input type="text" 	 id="txtRcDe"	name="txtRcDe" class="w_100p input_com calendar"	readonly="readonly">
							  			<input type="hidden" id="hidRcDt"	name="hidRcDt" class="w_100p input_com calendar"	readonly="readonly">
									</div>
									<!--//달력폼-->
									<div class="fl">
										<input type="text" 	id="txtRcDeHh" name="txtRcDeHh" class="input_com" onkeyup="fnHHMMChk(event,'HH')" maxlength="2" style="width: 40px;" />:
										<input type="text" 	id="txtRcDeMi" name="txtRcDeMi" class="input_com" onkeyup="fnHHMMChk(event,'MM')" maxlength="2" style="width: 40px;"/>
									</div>
				  				</td>
							</tr>
							<%--
							<tr>
							  	<th>사건번호 </th>
							  	<td>
						        	<div id="divCaseNo">
									  	<c:if test="${caseRcInfo.CASE_NO != null}">
											${caseRcInfo.CASE_NO}
										</c:if>
										<c:if test="${caseRcInfo.CASE_NO == null}">
											사건입건 후 확인 가능합니다
										</c:if>
									</div>
								</td>
								<th>내사번호 </th>
							  	<td>
						        	<div id="divItivNo">
								  		<c:if test="${caseRcInfo.ITIV_NO != null}">
											${caseRcInfo.ITIV_NO}
										</c:if>
										<c:if test="${caseRcInfo.ITIV_NO == null}">
											내사사건 접수 후 확인 가능합니다
										</c:if>
									</div>
								</td>
							</tr>
							 --%>
			    			<tr>
								<th>
									수사단서<span class="point"><img src="/img/point.png" alt=""></span>
								</th>
						        <td class="t_left">
						        	<select id="selInvProvisCd" name="selInvProvisCd" size="1" class="w_100px input_com">
						        		<option value="">=선택=</option>
						            	<c:forEach var="cd" items="${invProvisoList}">
											<option value="${cd.cd}"><c:out value="${cd.cdNm}" /></option>
										</c:forEach>
						          	</select>
						        </td>
						        <th>
						        	사건구분<span class="point"><img src="/img/point.png" alt=""></span>
						        </th>
						        <td class="t_left">
									<div class="input_radio2 t_left">
						            	<input class="to-labelauty-icon labelauty" type="radio" name="rdoRcSeCd" checked="" id="rdoRcSeCdT" value="T" style="display: none;">
						            	<label for="rdoRcSeCdT">
							            	<span class="labelauty-unchecked-image"></span>
							            	<span class="labelauty-checked-image"></span>
						            	</label>
						            	임시
						            </div>
						            <div class="input_radio2 t_left">
						            	<input class="to-labelauty-icon labelauty" type="radio" name="rdoRcSeCd" id="rdoRcSeCdI" value="I" style="display: none;">
						            	<label for="rdoRcSeCdI">
						            		<span class="labelauty-unchecked-image"></span>
						            		<span class="labelauty-checked-image"></span>
						            	</label>
						            	내사
						            </div>
						            <div class="input_radio2 t_left">
						            	<input class="to-labelauty-icon labelauty" type="radio" name="rdoRcSeCd" id="rdoRcSeCdF" value="F" style="display: none;">
						            	<label for="rdoRcSeCdF">
						            		<span class="labelauty-unchecked-image"></span>
						            		<span class="labelauty-checked-image"></span>
						            	</label>
						            	정식
						            </div>
						        </td>
						    </tr>
						    <tr>
			    				<th>대상자<span class="point"><img src="/img/point.png" alt=""></span>
									<!--버튼 -->
			    					<div class="box_w2_top">
			    						<div class="btn_box">
			      							<input type="button" id="btnTargetAdd" value="추가 +" class="btn_st1 icon_n fl mr_2"	style="width: 50px;padding-left: 0px;padding-right: 0px;">
											<input type="button" id="btnTargetDel" value="삭제 -" class="btn_st1 icon_n fl "		style="width: 50px;padding-left: 0px;padding-right: 0px;">
								    	</div>
								    </div>
									<!--//버튼  -->
								</th>
						        <td class="td_grid" colspan="3" style="padding-top: 0px;padding-left: 0px;padding-bottom: 0px;padding-right: 0px;">
						        	<!-- 그리드 -->
									<div id="grid_target"  class="gridResize" style="width: 100%; height: 330px !important; margin: 0px auto; position: relative;"></div>
						        </td>
							</tr>
							<tr>
			       				<th>위반죄명<span class="point"><img src="/img/point.png" alt=""></span></th>
			       				<td colspan="3" class="t_left">
			       					<div class="flex_r">
			         					<input type="text" 		id="txtVioltNm"	name="txtVioltNm"	 value="" class="w_100p input_com" readonly="readonly">
			         					<input type="hidden" 	id="hidVioltCd"	name="hidVioltCd"	 value="" class="w_100p input_com" >
				 						<input type="button" 	value="" class="btn_search"	onclick="fnVioltSelect();" return false">
					  				</div>
			       				</td>
					        </tr>
						<!--
							<tr>
				  				<th>
				  					사건개요<span class="point"><img src="/img/point.png" alt=""></span>
				    			    <br>(수사의뢰 경위)
				    			</th>
				  				<td>
				  					<textarea id="txtCaseSumry"	name="txtCaseSumry"	class="textarea_com w_100p"	maxlength="2000"></textarea>
				  					<span id="txtCaseSumryCounter">###</span>
				  				</td>
				  				<th>입증자료</th>
			  					<td>
			  						<textarea id="txtPrfDta" 	name="txtPrfDta" 	class="textarea_com w_100p"	maxlength="2000"></textarea>
			  						<span id="txtPrfDtaCounter">###</span>
			  					</td>
				  			</tr>
				  		-->
				  			<tr>
			       				<th>발생일시</th>
								<td class="t_left">
							       	<div class=" flex_r">
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
								<th>접수형태 </th>
							   	<td>
							       	<select id="selRcStleCd" name="selRcStleCd" size="1" class="w_150px input_com">
							       		<option value="">=선택=</option>
							            <c:forEach var="cd" items="${rcFormList}">
											<option value="${cd.cd}"><c:out value="${cd.cdNm}"/></option>
										</c:forEach>
			        				</select>
			        			</td>
			     			</tr>
							<tr>
			      				<th>
			      					발생장소
			      				</th>
			     				<td>
									<div class="flex_r">
										<input type="text" 	id="txtOccrrncZip" 	name="txtOccrrncZip"	maxlength="10" size="10" value="" class="w_80px input_com mr_5">
										<input type="text" 	id="txtOccrrncAddr"	name="txtOccrrncAddr"	maxlength="50" size="50" value="" class="w_400px input_com">
										<input type="button"id="Occrrnc" 	value="" class="btn_search" onclick="javascript:fnZipPopConnect(this)">
			      		 			</div>
								</td>
			       		   		<th>관할검찰</th>
			       				<td>
			       					<select id="selCmptncExmnCd" name="selCmptncExmnCd" size="1" class="w_180p input_com">
			           					<option value="">=선택=</option>
										<c:forEach var="cd" items="${exmnList}">
											<option value="${cd.exmnCd}"><c:out value="${cd.exmnNm}" /></option>
										</c:forEach>
			         				</select>
			         			</td>
			       		   		<!-- <th>담당자</th>
					        	<td><div id="divChargerInfo">사건 접수 후 확인 가능합니다</div></td>
					        	-->
			     			</tr>
			     			<tr>
				  				<th>
				  					범죄사실(혐의사실)<br><br>
				  					<span id="txtCrmnlFactCounter">###</span>
								</th>
				  				<td>
				  					<textarea id="txtCrmnlFact"	name="txtCrmnlFact"	class="textarea_com w_100p"	maxlength="2000"></textarea>

				  				</td>
				  				<th>
				  					기타<br><br>
				  					<span id="txtEtcCnCounter">###</span>
				  				</th>
				  				<td>
				  					<textarea id="txtEtcCn"	name="txtEtcCn" 	class="textarea_com w_100p"	maxlength="2000"></textarea>
				  				</td>
				  			</tr>
							<tr>
				  				<th>첨부 파일</th>
								<td style="border-right:none">
										<div id="fileList" class="file"></div><input type="file" id="txtFiles" name="txtFiles" style="height: 22px;">
								</td>
								<td colspan="2" style="border-left:none">
									<p class="dot">사용가능한 확장자 : <c:forEach var="format" items="${formatList}" varStatus="status">${format}<c:if test="${!status.last}">, </c:if></c:forEach></p>
								</td>
				  			</tr>
		   				</tbody>
					</table>
				</div>
			</div><!-- // tabC 사건접수 종료 -->
		</form>
	</div>
</div>