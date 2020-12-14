<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/inc/header.jsp" />
<style>
	.trHeight {
		height: 35px;
	}
</style>
<script type="text/javascript">

var myGridID = "#grid_wrap";

	$(function() {

		$(document).ready(function(){

			$('#hidRcNo').val( $('#hidRcNo', parent.document).val() );
			$('#hidCaseNo').val( $('#hidCaseNo', parent.document).val() );

			initGrid();		//그리드 초기화

		});


		//입력/수정 동시 사용을 위한 구분 코드
		$("input[name=rcSectionCd]").click(function(e){

			if( $(this).val() == "정식"){
				$("#alotUserId").prop('disabled', true);
				$("#alotUserId").val("");
				$("#alotUserNm").prop('disabled', true);
				$("#alotUserNm").val("");
			} else {
				$("#alotUserId").prop('disabled', true);
				$("#alotUserId").val("");
				$("#alotUserNm").prop('disabled', true);
				$("#alotUserNm").val("");
			}
		});


	});	// jQuery

	//사건정보 저장

	// addRowFinish 이벤트 핸들링
	function auiAddRowHandler(event) {
		// 행 추가 시 추가된 행에 선택자가 이동합니다.
		// 이 때 칼럼은 기존 칼럼 그래도 유지한채 이동함.
		// 원하는 칼럼으로 선택자를 보내 강제로 편집기(inputer) 를 열기 위한 코드
		var selected = AUIGrid.getSelectedIndex(myGridID);
		if(selected.length <= 0) {
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
			  { dataField : "grdTrgterGroup"	, headerText : "대상자그룹"		, width   : 90
				 ,renderer : {type : "TemplateRenderer"}
			,labelFunction : function( rowIndex, columnIndex, value, headerText, item ){


								if( "suspct-Group" == value ){
									if( "F" == item.grdRcSeCd ){
				  				  	    return "피의자 등";
									} else if( "I" == item.grdRcSeCd ){
				  				  	    return "피내사자 등";
									} else if( "T" == item.grdRcSeCd ){
				  				  	    return "혐의자 등";
									}
				  				} else if( "accs-Group" == value ){
				  				  		return "고발인 등";
				  				}
							 }
			  }
			, { dataField : "grdTrgterSeNm"		, headerText : "대상자구분"		, width   : 90	 }
			, { dataField : "grdTrgterClNm"		, headerText : "대상자 분류"	, visible : false}
			, { dataField : "grdTrgterNm"	 	, headerText : "성명"			, width   : 100	 }
			, { dataField : "grdTrgterTyNm"		, headerText : "유형"			, visible : true , width   : 45}
			, { dataField : "grdTrgterSeCd"		, headerText : "구분"			, visible : false}
			, { dataField : "grdTrgterClCd"		, headerText : "대상자 분류"	, visible : false}
			, { dataField : "grdTrgterTyCd"		, headerText : "대상자 분류"	, visible : false}
			, { dataField : "grdTrgterEngNm"	, headerText : "성명(영문)"	, visible : false}
			, { dataField : "grdSexdstnNm"		, headerText : "성별"			, visible : false}
			, { dataField : "grdTrgterRrn"		, headerText : "주민등록번호"	, visible : false}
			, { dataField : "grdTrgterAge"		, headerText : "나이"			, visible : false}
			, { dataField : "grdHpNo"	 		, headerText : "휴대전화"		, visible : false}
			, { dataField : "grdOwnhomTel"		, headerText : "자택전화"		, visible : false}
			, { dataField : "grdWrcTel"	 		, headerText : "직장전화"		, visible : false}
			, { dataField : "grdEtcTel"	 		, headerText : "기타연락처"		, visible : false}
			, { dataField : "grdOccpCd"	 		, headerText : "직업"			, visible : false}
			, { dataField : "grdOccpNm"	 		, headerText : "직업명"		, visible : false}
			, { dataField : "grdWrcNm"	 		, headerText : "직장명"		, visible : false}
			, { dataField : "grdWrcZip"	 		, headerText : "직장 우편번호"	, visible : false}
			, { dataField : "grdWrcAddr"	 	, headerText : "직장 주소"		, visible : false}
			, { dataField : "grdAdresZip"	 	, headerText : "주소우편번호"	, visible : false}
			, { dataField : "grdAdresAddr"		, headerText : "주소지 "		, visible : false}
			, { dataField : "grdRegbsZip"	 	, headerText : "등록우편번호"	, visible : false}
			, { dataField : "grdRegbsAddr"		, headerText : "등록지"		, visible : false}
			, { dataField : "grdDwlsitZip"		, headerText : "주거지 우편번호" , visible : false}
			, { dataField : "grdDwlsitAddr"		, headerText : "주거지"		, visible : false}
			, { dataField : "grdEmail"	 		, headerText : "이메일"		, visible : false}
			, { dataField : "grdClsf"	 		, headerText : "직급"			, visible : false}
			, { dataField : "grdNltyCd"	 		, headerText : "국적"			, visible : false}
			, { dataField : "grdNltyNm"	 		, headerText : "국적명"		, visible : false}
			, { dataField : "grdPasportNo"		, headerText : "여권번호"		, visible : false}
			, { dataField : "grdDocId"	 	  	, headerText : "문서id"		, visible : false}
			, { dataField : "grdRcSeCd"	 	  	, headerText : "사건구분"		, visible : false}
		];

		//그리드 환경값 설정
		var gridPros = {
			     useGroupingPanel : false
			   , showRowNumColumn : false
			    , displayTreeOpen : true
			       , enableFilter : true
			  	  , selectionMode : "singleRow"	// 선택모드 singleCell(기본값), multipleCells, singleRow
			  	  , noDataMessage : "조회 목록이 없습니다."
	 	  	 , showRowCheckColumn : false	//gird checkbox 여부
			     , useContextMenu : false	//컨텍스트 메뉴 사용
		   , enableRightDownFocus : false	//컨텍스트 메뉴를 보기 위해 오른쪽 클릭을 한 경우 클릭 지점이 왼쪽 클릭과 같이 셀 선택을 할지 여부 기본값 : false
   , triggerSelectionChangeOnCell : true
				   , headerHeight : 30
					  , rowHeight : 30
			 , fillColumnSizeMode : true

		};

		AUIGrid.create(myGridID, columnLayout, gridPros);
		AUIGrid.bind(myGridID, "cellClick", function(event) {

			$("#frmTtarget")[0].reset(); //form 초기화
			//label reset
			$("#divTargetInfo").find("label").each(
			    function(index){
			    	$(this).text("");
			    }
			);
			var items = event.item;
			fn_form_bind ("frmTtarget",items,"GRID");

			//대상자 개인/기업에 따른 정보 분리
			if( "I" == $("#hidTrgterTyCd").val() ){			//개인
				$('.entrprs').css('display', 'none');
				$('.indvdl').css('display', '');
			} else if( "E" == $("#hidTrgterTyCd").val() ){ 	//기업
				$('.indvdl').css('display', 'none');
				$('.entrprs').css('display', '');
			}

			//대리인 있을경우 성명 전화번호 구분자 추가
			if( 0 < $("#labAgentNm").text().length ){
				$("#seAgent").text(" / ");
			}


		});//AUIGrid.bind cellClick end

		AUIGrid.bind("#grid_wrap", "ready", function(event) {
			var gdt = AUIGrid.getGridData(event.pid);
			if(gdt.length > 0) {
				AUIGrid.setSelectionByIndex(event.pid, 0, 5);  //최초 선택된 row 자동 상세 조회
				fn_form_bind ("frmTtarget",gdt[0],"GRID");
			}
		});

		fnMoveGridPage("/rc/getTrgterListAjax/", "frmTtarget", "#grid_wrap", 1);

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


<!--테이블 시작 -->
<div class="contents marginbot">
	<form id="frmTtarget">
		<input type="hidden"	id="hidRcNo" 			name="hidRcNo" 		value="${caseRcInfo.RC_NO}"> 	<!-- 접수번호 -->
		<input type="hidden" 	id="hidItivNo" 			name="hidItivNo" 	value="${caseRcInfo.ITIV_NO}">	<!-- 내사번호 -->
		<input type="hidden" 	id="hidCaseNo" 			name="hidCaseNo" 	value="${caseRcInfo.CASE_NO}">	<!-- 사건번호 -->
		<input type="hidden" 	id="hidDocId" 			name="hidDocId" 	value="${caseRcInfo.DOC_ID}">	<!-- 문서번호 -->
		<input type="hidden" 	id="hidProgrsSttusCd" 	name="hidProgrsSttusCd" 	value="${caseRcInfo.PROGRS_STTUS_CD}"> <!-- 진행상태 -->
		<input type="hidden" 	id="hidTrgterTyCd" 		name="hidTrgterTyCd" 	value=""><!-- 대상자 유형 -->

		<div class="box_w2 mb_50 mt_10">
			<div class="box_w2_1" style="width: 320px;">
				<!-- 그리드 -->
				<div class="tb_01_box">
					<div id="grid_wrap"  class="gridResize" style="width: 100%; height: 570px; margin: 0px auto; position: relative;"></div>
				</div>
				<!-- //그리드 -->
	 		</div>

			<div class="box_w2_2" style="width: 760px;padding-left: 0px;">
				<!--테이블 시작 -->
	 			<div class="tb_01_box"	id="divTargetInfo" >
					<table class="tb_01">
						<colgroup>
							<col width="100px">
				    		<col width="260px">
				    		<col width="100px">
				    		<col width="">
						</colgroup>
						<tbody>
				    		<tr class="trHeight">
								<th>대상자구분</th>
					      		<td>
					      			<label id="labTrgterSeNm"></label>
					       		</td>
					       		<th>대상자유형</th>
						      	<td>
						      		<label id="labTrgterTyNm"></label>
						  		</td>
							</tr>
							<tr class="trHeight">
	   							<th>성명(한글)</th>
	   							<td>
	   								<label id="labTrgterNm"></label>
	   							</td>
								<th>성명(영문)</th>
								<td>
									<label id="labTrgterEngNm"></label>
								</td>
			      			</tr>
			      			<tr class="trHeight entrprs">
								<th>법인번호</th>
						       	<td>
						       		<label id="labTrgterCprn"></label>
							 	</td>
						        <th>대표자</th>
						        <td>
						        	<label id="labRprsntvNm"></label>
						        </td>
								<!--
								<th>사업자번호</th>
						        <td>
						        	<label id="labTrgterCrn"></label>
						        </td> 
						        -->
							</tr>
							<tr class="trHeight indvdl">
								<th>주민등록번호</th>
								<td>
									<label id="labTrgterRrn"></label>
								</td>
								<th>나이 </th>
								<td>
									<label id="labTrgterAge"></label>
								</td>
							</tr>
							<tr class="trHeight indvdl">
	   							<th>대상자분류</th>
						      	<td>
						      		<label id="labTrgterClNm"></label>
						  		</td>
								<th>성별</th>
					        	<td>
					        		<label id="labSexdstnNm"></label>
			            		</td>

							</tr>
	 						<tr class="trHeight indvdl">
	   							<th>휴대전화</th>
				       			<td>
				       				<label id="labHpNo"></label>
				 				</td>
					        	<th>자택전화</th>
					        	<td>
					        		<label id="labOwnhomTel"></label>
								</td>
						    </tr>
							<tr class="trHeight">
						     	<th>직장전화 </th>
						       	<td>
						       		<label id="labWrcTel"></label>
								</td>
	     						<th>기타연락처 </th>
	     						<td>
	     							<label id="labEtcTel"></label>
						  		</td>
							</tr>
							<tr class="trHeight indvdl">
								<th>직업</th>
						       	<td>
						       		<label id="labOccpNm"></label>
							 	</td>
						        <th>직장명</th>
						        <td>
						        	<label id="labWrcNm"></label>
							</tr>
							<tr class="trHeight indvdl">
								<th>직장 주소지</th>
						       	<td colspan="3">
							       	<label id="labWrcZip"></label>
							       	<label id="labWrcAddr"></label>
						        </td>
							</tr>
							<tr class="trHeight">
								<th>대리인구분</th>
						       	<td>
						       		<label id="labAgentSeNm"></label>
							 	</td>
						        <th style="width: 75px;padding-top: 0px;padding-bottom: 0px;">대리인 성명/연락처</th>
						        <td>
						        	<label id="labAgentNm"></label>
						        	<span id="seAgent"></span>
						        	<label id="labAgentTel"></label>
						        </td>
							</tr>

							<tr class="trHeight">
								<th>주소지</th>
								<td colspan="3">
									<label id="labAdresZip"></label>
									<label id="labAdresAddr"></label>
								</td>
							</tr>
							<tr class="trHeight indvdl">
								<th>등록지</th>
					        	<td colspan="3">
					        		<label id="labRegbsZip"></label>
					        		<label id="labRegbsAddr"></label>
					        	</td>
							</tr>
							<tr class="trHeight indvdl">
								<th>주거지</th>
								<td colspan="3">
									<label id="labDwlsitZip"></label>
									<label id="labDwlsitAddr"></label>
								</td>
							</tr>
							<tr class="trHeight">
								<th>이메일</th>
								<td>
									<label id="labEmail"></label>
								</td>
								<th>직급</th>
								<td>
									<label id="labClsf"></label>
								</td>
							</tr>
							<tr class="trHeight indvdl">
								<th>여권번호 </th>
								<td>
									<label id="labPasportNo"></label>
								</td>
								<th>국적 </th>
								<td>
									<label id="labNltyNm"></label>
								</td>
						  	</tr>
			    		</tbody>
					</table><!-- //대상자 정보 입력 table -->
				</div>
			</div>
		</div>
	</form>
</div>
