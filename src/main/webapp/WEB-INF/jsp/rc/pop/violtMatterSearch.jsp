<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>
<style type="text/css">
	/* 커스텀 페이징 패널 정의 */
	.my-grid-paging-panel {
		    width : 1000px;
		   margin : 4px auto;
		font-size : 12px;
		   height : 34px;
		 overflow : hidden;
		   border : 1px solid #ccc;
	}
	
	/* aui-grid-paging-number 클래스 재정의*/
	.aui-grid-paging-panel .aui-grid-paging-number {
		border-radius : 4px;
	}
</style>
<script type="text/javascript">
	$(function() {
		initGrid ();
		gridResize ();
		
		$("#btnVioltMatterSearch").click(function(){
			
			alert("위반사항 검색 중입니다.");
		});
		$("#btnVioltMatterConfirm").click(function(){
			
			var activeItems = AUIGrid.getCheckedRowItems("#grid_wrap");
			if (activeItems.length < 1){
				alert('선택된 행이 없습니다.');
				fnClose();
			} else if (confirm('선택한 접수번호를 반영하시겠습니까?')){
				var returnValue = [];
				for (var i in activeItems) {
					returnValue.push(activeItems[i].item);
				}
				//parent.getReturnValue({sType:$("#sType").val(),list:returnValue});
				parent.getReturnValue(returnValue);
				fnClose();
			}
		});
	});
	
	function fnClose(){
		parent.rcTmprPopup.hide();
	}
	
	function initGrid () {
		var columnLayout = [
				{ dataField : "grdRn",   		 headerText : "순번"		, width : 40 }
   			  , { dataField : "grdRcSeCd",   	 headerText : "위반사항 명"	, width : 200,
   					labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
            			return gridComboLabel(rcSeCdList, value)
            		}
			  	}
              , { dataField : "grdProgrsSttusCd",headerText : "적용법률" }
            ]; 
		
		var gridPros = {
			  	  showRowNumColumn : false
		  	   	   , selectionMode : "multipleCells"	// 선택모드 (기본값은 singleCell 임)
		    	   , noDataMessage : "조회 목록이 없습니다."
			  , showRowCheckColumn : true		//gird checkbox 여부
					, headerHeight : 30
		    		   , rowHeight : 30
  			  , fillColumnSizeMode : true
	, triggerSelectionChangeOnCell : true
		};
		
		AUIGrid.create("#grid_wrap",  columnLayout,  gridPros);
	}
	
	function btnClose () {
		this.close ();
	}
	
	function fnSearch () {
		/* if(fnIsEmpty($("#rc_no1").val()) && fnIsEmpty($("#rc_no1").val())) {
			alert ("접수번호를 입력하세요.");
			$("#rc_no1").focus();
			return;
		} */
		fnMoveGridPage("/inv/rcTmprPopList/", "searchForm", "#grid_wrap", 1);
	}
</script>
</head>
<body>
	<div class="popup_body">
		<form id="searchForm">
			<input type="hidden" id="hidPage" 		name="hidPage" 		value="${hidPage}">
			<input type="hidden" id="hidTotCnt" 	name="hidTotCnt" 	value="0">
			<input type="hidden" id="hidPageArea" 	name="hidPageArea" 	value="10">
			<input type="hidden" id="hidPageBlock" 	name="hidPageBlock" value="10">
			<div class="search_box mb_20">
				<div class="inbox03 mb_10">
					<div class="tl_box2">
						<div class="tt2">위반사항 명</div>
						<div class="td4">  
					 	<input type="text" maxlength="30" size="30" class="w_200p input_com_s" value=""></div>
				 	</div>
				</div>
				<input type="button" id="btnVioltMatterSearch"  value="검색" class="btn_st2_2 icon_n">
			 </div>
		</form>
		<!-- 검색박스 -->
    	<div class="com_box">  
			<div class="fr t_right mb_5">
        		<input type="button" id="btnVioltMatterConfirm" value="확인 " class="btn_st4 icon_n">
        	</div>
		</div>
		<!-- 그리드 -->
		<div class="com_box">
			<div id="grid_wrap" class="gridResize tb_01_box" style="width: 100%; height: 250px; float: left; margin-bottom: 0px;"></div>
			<div id="grid_wrap_paging" class="aui-grid-paging-panel my-grid-paging-panel" style="float: left; width: 100%"></div>
		</div>
	</div>
</body>
</html>