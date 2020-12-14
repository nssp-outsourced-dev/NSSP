<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">

var myGridID;
	
	$(document).ready(function(){
		initGrid();
		$("#searchCdNm").keydown(function(key) {
			if(key.keyCode == 13) {
				fnSearch();				
			}
		});
	});

	function fnClose(){
		self.close();
	}

	function initGrid() {
		var columnLayout = [
			{ dataField : "VIOLT_CD", headerText : "코드", width : 0},
			{ dataField : "VIOLT_NM", headerText : "코드명", width : 300},
			{ dataField : "VIOLT_DC", headerText : "코드상세", width : 0},
			{ dataField : "VIOLT_DP", headerText : "코드깊이", width : 0},
			{ dataField : "VIOLT_UPPER_CD", headerText : "상위코드", width : 0},
			{ dataField : "USE_YN", headerText : "사용", width : 0},
			{ dataField : "SORT_ORDR", headerText : "정렬", width : 0},
			{ dataField : "LOWER_CNT", headerText : "하위수", width : 0}
		];


		var gridPros = {
			rowIdField : "VIOLT_CD",
			selectionMode : "singleRow",
			fillColumnSizeMode : true,
			showRowCheckColumn : true,
			showRowAllCheckBox : false,
			rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
				if(item.LOWER_CNT > 0) {
					return false;
				}
				return true;
			},
			showRowNumColumn : false,
			treeColumnIndex : 1,
			displayTreeOpen : false
		};
		myGridID = AUIGrid.create("#grid_list", columnLayout, gridPros);

		// 셀클릭 이벤트 바인딩
		AUIGrid.bind(myGridID, "cellClick", function(event) {
			var item = event.item;
			var rowIdField;
			var rowId;
			if(item.LOWER_CNT > 0) {
				var isOpen = event.item._$isOpen; //현재 오픈됐는지
				var rowIdField = AUIGrid.getProp(myGridID, "rowIdField");
				AUIGrid.expandItemByRowId(myGridID, event.item[rowIdField], !isOpen);
			}else{
				rowIdField = AUIGrid.getProp(event.pid, "rowIdField"); // rowIdField 얻기
				rowId = item[rowIdField];
				
				// 이미 체크 선택되었는지 검사
				if(AUIGrid.isCheckedRowById(event.pid, rowId)) {
					// 엑스트라 체크박스 체크해제 추가
					AUIGrid.addUncheckedRowsByIds(event.pid, rowId);
				} else {
					// 엑스트라 체크박스 체크 추가
					AUIGrid.addCheckedRowsByIds(event.pid, rowId);
				}

				var iUrl = '<c:url value='/violt/violtDetailAjax/'/>';
		 		var queryString =  "txtVioltCd=" + item.VIOLT_CD;
		 		var processAfterGet = function(data) {
					if(data.VIOLT_CN != null){
						$('#txtVioltCn').text(data.VIOLT_CN);		
					}else{
						$('#txtVioltCn').text("");			
					}
			    };
				Ajax.getJson(iUrl, queryString, processAfterGet);				
			}
			
		});

		AUIGrid.bind(myGridID, "ready", function(event){
			//AUIGrid.expandItemByRowId(myGridID, ["00002", "00003"], true);
		});

		fnSearchGrid("/violt/violtFullJsonAjax/", "frmList", "#grid_list");
	}

	function fnSearch() {
		if($("#searchCdNm").val().trim() == "") {
			alert("검색 하고자 하는 단어를 입력하십시오.");
			return;
		}

		var options = {
			headerHeight : 30,
			rowHeight: 30,	
			fillColumnSizeMode : true,	
			direction : true, // 검색 방향  (true : 다음, false : 이전 검색)
			caseSensitive : false, // 대소문자 구분 여부 (true : 대소문자 구별, false :  무시)
			wholeWord : false, // 온전한 단어 여부
			wrapSearch : true, // 끝에서 되돌리기 여부
		};

		AUIGrid.search(myGridID, "VIOLT_NM", $("#searchCdNm").val().trim(), options);
	}

	function fnSelect() {
		var str1 = "";
		var str2 = "";
	
		var chkItems = AUIGrid.getCheckedRowItems(myGridID);

		if(chkItems.length <= 0 ) {
			alert("코드를 선택하세요.");
			return;
		}

		var ids1 = []; 
		var ids2 = []; 
		for(var i=0; i<chkItems.length; i++) {
			ids1.push( chkItems[i].item.VIOLT_CD );
			ids2.push( chkItems[i].item.VIOLT_NM );
		}
		str1 = ids1.join("/");
		str2 = ids2.join("/");
		
		$("#txtCd").val(str1);
		$("#txtCdNm").val(str2);

		parent.violtSelectPopup.hide();
	}


	var isExpanded = false;
	function fnExpand() {
		if (!isExpanded) {
			AUIGrid.expandAll(myGridID);
			isExpanded = true;
		} else {
			AUIGrid.collapseAll(myGridID);
			isExpanded = false;
		}
	}
</script>

<body>

<!--팝업박스 -->
<form id="frmList" name="frmList" method="post">
<input type="hidden" id="txtVioltUpperCd" name="txtVioltUpperCd" value="${upper_cd}">
<input type="hidden" id="txtCd" name="txtCd" value="">
<input type="hidden" id="txtCdNm" name="txtCdNm" value="">
<div class="popup_body">

	<div class="popup_search_box mb_20">
		<div class="search_in">
			<div class="stitle w_80px ">코드명</div>
			<div class="r_box">
				<input type="text" id="searchCdNm" name="searchCdNm" class="w_90p input_com_s" value="">
				
			</div>
			<input type="button" name="input_button" value="검색" class="btn_st2_3 icon_n popup_input" onclick="fnSearch();">
		</div>
	</div>

	<!--//버튼  -->	
	<!--테이블 시작 -->
	<div class="box_w2">
		<div class="box_w2_1b">
			<div class="com_box  t_right">
				<div class="btn_box">
					<input type="button" name="input_button" value="선택 "  class="btn_st4 icon_n fl mr_m1" onclick="fnSelect();">
				</div>
			</div>
			<div class="com_box mb_10">  
				<div class="tb_01_box">
					<div id="grid_list" style="width:100%; height:530px; margin:0 auto;"></div>
				</div>
			</div> 
		</div>		
		<div class="box_w2_2b ">
			<div class="com_box mb_10">
				<div class="tb_01_box">
					<textarea id="txtVioltCn" style="width:100%;height:562px;" readonly></textarea>
				</div>
			</div>
		</div>
	</div>
</div>
</form>
 <!--팝업박스 -->	

</body>
</html>
