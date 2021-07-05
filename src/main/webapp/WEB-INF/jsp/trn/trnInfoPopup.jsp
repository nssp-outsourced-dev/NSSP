<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>
<style type="text/css">
.grid_td_left {text-align:left}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		initGrid();
		
		/*  */
		$("#saveBtn").on("click", function(){
			var editedRowItems = AUIGrid.getEditedRowItems( "#gridTrnList" );
			console.log(editedRowItems);
			
			if( editedRowItems.length == 0 ){
				alert("수정한 자료가 없습니다.");
				return;
			}
			
			var data = fnAjaxAction( "/trn/updateTrnDeAjax/", JSON.stringify({ sList:editedRowItems }) );
			if( data.result == "1" ){
				alert("저장 되었습니다.");
				fnSearchGrid("/trn/trnCaseListPopAjax/", "frmList", "#gridTrnList");

				//$("#hidTrnNo").val(items.TRN_NO);
				fnSearchGrid("/trn/trnSuspctListPopAjax/", "frmList", "#gridSuspctList");
			} else {
				alert("저장중 오류가 발생했습니다.");
			}
		});
	});
	
	function initGrid() {
		var columnLayoutV = [{
				headerText : "순번", dataField : "RNUM", width : 40, editable : false
			}, {
				headerText : "송치번호", dataField : "CV_TRN_NO", width : 90, editable : false
			}, {
				/*  */
				headerText : "송치일자<span class='point'><img src='/img/icon_dot.png'/></span>", 	dataField : "TRN_DE", width : 90, dataType : "date", formatString : "yyyy-mm-dd", editable : true
			}, {
				headerText : "관할검찰", 	dataField : "CMPTNC_EXMN_NM", width : 130, editable : false
			}, {				
				headerText : "증거품", 	dataField : "EVDENC_DC", width : 110, style : "grid_td_left", editable : false
			}, {				
				headerText : "비고", 	dataField : "TRN_RM", width : 110, style : "grid_td_left", editable : false
			}, {
				headerText : "발생원표번호", 	dataField : "OCCRRNC_ZERO_NO", width : 90, editable : false
			}, {
				headerText : "검거원표번호", 	dataField : "ARREST_ZERO_NO", width : 90, editable : false
			}, {				
				headerText : "종결여부", 	dataField : "ED_YN", width : 50, editable : false
			}
		];			
		var columnLayoutT = [{
				headerText : "순번", dataField : "SORT_ORDR", width : 40, cellMerge : true, mergeRef : "TRGTER_SN", mergePolicy : "restrict", editable : false
			}, {
				headerText : "성명", dataField : "TRGTER_NM", width : 80, cellMerge : true, mergeRef : "TRGTER_SN", mergePolicy : "restrict", editable : false
			}, {
				headerText : "주민번호", 	dataField : "TRGTER_RRN", width : 120, cellMerge : true, mergeRef : "TRGTER_SN", mergePolicy : "restrict", editable : false
			}, {
				headerText : "신병상태", 	dataField : "IMPR_STTUS_NM", width : 90, cellMerge : true, mergeRef : "TRGTER_SN", mergePolicy : "restrict", editable : false
			}, {
				headerText : "구속영장청구번호", dataField : "ARSTT_RQEST_NO", width : 130, cellMerge : true, mergeRef : "TRGTER_SN", mergePolicy : "restrict", editable : false
			}, {
				headerText : "지문원지작성번호", dataField : "FNGPRT_FORMS_NO", width : 130, cellMerge : true, mergeRef : "TRGTER_SN", mergePolicy : "restrict", editable : false
			}, {
				headerText : "피의자원표번호", dataField : "SUSPCT_ZERO_NO", width : 117, cellMerge : true, mergeRef : "TRGTER_SN", mergePolicy : "restrict", editable : false
			}, {
				headerText : "통신사실청구번호", dataField : "COMMN_FACT_RQEST_NO", width : 122, cellMerge : true, mergeRef : "TRGTER_SN", mergePolicy : "restrict", editable : false
			}, {
				headerText : "위반죄명", dataField : "VIOLT_NM", width : 150, style : "grid_td_left", editable : false
			}, {
				headerText : "송치의견", dataField : "TRN_OPINION_NM", width : 120, editable : false
			}
		];
		var gridPros = {
			selectionMode : "singleRow",
			fillColumnSizeMode : true,
			showRowNumColumn : false,
			noDataMessage : "조회 목록이 없습니다.",
			enableCellMerge : true,
			cellMergePolicy : "withNull",
			headerHeight : 30,
			rowHeight: 30,
			editBeginMode : "click",
			editable : true,
		};
		AUIGrid.create("#gridTrnList", columnLayoutV, gridPros);
		AUIGrid.create("#gridSuspctList", columnLayoutT, gridPros);

		AUIGrid.bind("#gridTrnList", "ready", function(event) {
			var gdata = AUIGrid.getGridData("#gridTrnList");
			if(gdata.length > 0) {
				$("#hidTrnNo").val(gdata[0].TRN_NO);
				$("#spTrnNo").html(" (송치번호:"+gdata[0].CV_TRN_NO+")");
				fnSearchGrid("/trn/trnSuspctListPopAjax/", "frmList", "#gridSuspctList");
			}
		});
		AUIGrid.bind("#gridTrnList", "cellClick", function(event) {
			var items = event.item;
			$("#hidTrnNo").val(items.TRN_NO);
			$("#spTrnNo").html(" (송치번호: "+items.CV_TRN_NO+")");
			fnSearchGrid("/trn/trnSuspctListPopAjax/", "frmList", "#gridSuspctList");
		});
		
		fnSearchGrid("/trn/trnCaseListPopAjax/", "frmList", "#gridTrnList");

		//$("#hidTrnNo").val(items.TRN_NO);
		fnSearchGrid("/trn/trnSuspctListPopAjax/", "frmList", "#gridSuspctList");
	}
</script>
<body>
<form id="frmList" name="frmList" method="post">
<input type="hidden" id="hidTrnNo" name="hidTrnNo">
<input type="hidden" id="hidRcNo" name="hidRcNo" value="${rcNo}">
<%-- <div class="title_s_st2  fl mt_10"><img src="/img/title_icon1.png" alt=""/>송치정보</div>
<div class="com_box ">
          <div class="tb_01_box">
            <table  class="tb_03">
              <col width="10%"/>
              <col width="23%"/>
              <col width="10%"/>
              <col width="23%"/>
			  <col width="10%"/>
              <col width="24%"/>              
              <tbody>
                <tr>
                  <th>송치번호 </th>
                  <td>${trnInfo.TRN_NO}</td>
                  <th>송치일자</th>
                  <td>${trnInfo.TRN_DE}</td>
                  <th>관할검찰</th>
                  <td>${trnInfo.CMPTNC_EXMN_NM}</td>
                </tr>
                <tr>
                  <th>증거품여부 </th>
                  <td>${trnInfo.EVDENC_YN}</td>
                  <th>비고 </th>
                  <td colspan="3">${trnInfo.TRN_RM}</td>
                </tr>
                </tbody>
                </table>
                </div>
                </div> --%>


<div class="com_box ">
	<div class="title_s_st2  fl mt_10">
		<img src="/img/title_icon1.png" alt=""/>송치정보
		<!--버튼 -->
		<a href="javascript:void(0);" class="btn_st2 icon_n fr mr_m1" id="saveBtn">저장</a>
	</div>
	<div class="tb_01_box">
		<div id="gridTrnList" style="width:100%; height:180px; margin:0 auto;"></div>
	</div>
</div>
                
<div class="title_s_st2  mt_10"><img src="/img/title_icon1.png" alt=""/>송치피의자 및 송치의견 <span id="spTrnNo"></span></div>
<div class="com_box">
	<div class="tb_01_box">
		<div id="gridSuspctList" style="width:100%; height:250px; margin:0 auto;"></div>
	</div>
</div>

</form>
</body>
</html>
