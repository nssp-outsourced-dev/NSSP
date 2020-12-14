<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<style type="text/css">
	.tbLft {text-align: left;}
</style>
<script type="text/javascript">

	var myGridID;
	$(document).ready(function(){
		initGrid();
	});

	function initGrid() {
		var columnLayout = [
			 { dataField : "FORMAT_ID"	, headerText : "FORMAT_ID", width : 0	,   visible : false	}
		   , { dataField : "FORMAT_CL_NM", headerText : "서식분류"	  , width : 250	, cellMerge : true 	}
		   , { dataField : "FORMAT_NM"	, headerText : "서식명"	  , style:'tbLft'}
		   , { dataField : "DOC_SORT"	, headerText : "순번"		  , width : 60	 }
		   , { dataField : "DOC_YN"		, headerText : "DOC_YN"	  , width : 0	,   visible : false	}
		   , {
			   dataField : "INPUT_YN",
			  headerText : "입력폼",
				   width : 60,
				renderer : {type : "TemplateRenderer"},
		   labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								var template = "";
								if( value == "Y" ){
									template += "O";
								} else {
									template += "X";
								}
							
								return template;
						   }
			}
		  , {
			   dataField : "JSON_YN",
			  headerText : "작성여부",
				   width : 100,
				 visible : false,
				renderer : {type : "TemplateRenderer"},
		   labelFunction : function (rowIndex, columnIndex, value, headerText, item ){
								var template = "";
								if( item.CHK_TYPE == "FILE" ) {
									template = "첨부파일";
								} else {
									if( value == "Y" ){
										template += "작성완료";
									} else {
										template += "미작성";
									}
						   		}
						  	 	return template;
						   }
			}
		   ,{
			   dataField : "FILE_NM",
			  headerText : "작성여부",
			       width : 100,
				 visible : true,
				renderer : {type : "TemplateRenderer"},
		   labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
								var template = "";
					
								if( item.grdChkType == "FILE" ){
									template = "첨부파일";
								} else {
									if( value != null && value != "" ){
										template += "작성완료";
									} else {
										template += "미작성";
									}
								}
								return template;
							}
			}
		  , { dataField : "DOC_ID"		  , headerText : "DOC_ID"	 , width : 0, visible : false}
		  , { dataField : "PBLICTE_SN"	  , headerText : "PBLICTE_SN", width : 0, visible : false}
		  , { dataField : "DOC_NO"		  , headerText : "문서번호"	 , width : 0, visible : false}
		  , { dataField : "WRITNG_DEPT_NM",headerText : "소속"		 , width : 0				 }
		  , { dataField : "WRITNG_NM"	  , headerText : "작성자"		 , width : 0, visible : false}
		  , { dataField : "UPDT_DT"	      , headerText : "작성일"  	 , width : 100			 	 }
		  , { 
		      dataField : "CHK_TYPE"	  , headerText : "저장구분"	 , width : 100, style:'tbLft'
		     , renderer : {type : "TemplateRenderer"}
		, labelFunction : function (rowIndex, columnIndex, value, headerText, item ) {
							var template = value + (fnIsEmpty(item.DOC_CL_CD)?"":" ["+item.DOC_CL_CD+"]");
							return template;
						  }
			}
		];

		var gridPros = {
				   headerHeight : 30
	   	   		    , rowHeight : 30
			  , enableCellMerge : true	// 셀 병합 실행
			  , cellMergePolicy : "withNull"
		   , fillColumnSizeMode : true
			 , showRowNumColumn : false
		 , enableRightDownFocus : true 	// 기본값 : false
		};
		
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);

		AUIGrid.bind("#grid_list", "cellDoubleClick", function(event){
			var items = event.item;
			if( event.columnIndex > 1 ){
				if( items.CHK_TYPE == "FILE" ){
					fnDocFileDownload(items.DOC_ID, items.PBLICTE_SN);
				} else {
					parent.fnHwpctrl (items.DOC_ID, items.PBLICTE_SN, items.FORMAT_NM, "${ifr_id}", "R");
					//parent.fnReportView(items.DOC_ID, items.PBLICTE_SN);
				}
			}
		});
		fnSearch();
	}

	function fnSearch(){
		fnSearchGrid("/doc/reportCaseListAjax/", "frmList", "#grid_list");
	}

	/*첨부파일 다운로드*/
	function fnDocFileDownload(sFileID, sFileSn){
		parent.location.href = "<c:url value='/file/getFileBinary/'/>?file_id=" + sFileID + "&file_sn=" + sFileSn;
	}

</script>

<body>

<form id="frmList" name="frmList" method="post">
<input type="hidden" id="rcNo" name="rcNo" value="${rcNo}">
<div class="com_box mb_20">
</div>
<div class="com_box mb_10">
	<div class="tb_01_box">
		<div id="grid_list" style="width:100%; height:450px; margin:0 auto;"></div>
	</div>
</div>
</form>

</body>
</html>
