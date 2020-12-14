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
			{ dataField : "cd", headerText : "코드", width : 0},
			{ dataField : "cdNm", headerText : "코드명", width : 300},
			{ dataField : "cdDc", headerText : "코드상세", width : 200},
			{ dataField : "cdDp", headerText : "코드깊이", width : 0},
			{ dataField : "upCd", headerText : "상위코드", width : 0},
			{ dataField : "useYn", headerText : "사용", width : 0},
			{ dataField : "sort", headerText : "정렬", width : 0},
			{ dataField : "lowerCnt", headerText : "하위수", width : 0}
		];

		var gridPros = {
			rowIdField : "cd",
			selectionMode : "singleRow",
			fillColumnSizeMode : true,
			<c:choose>
				<c:when test="${mode eq 'M'}">
					showRowCheckColumn : true,
					showRowAllCheckBox : false,
					rowCheckDisabledFunction : function(rowIndex, isChecked, item) {
						if(item.lowerCnt > 0) {
							return false;
						}
						return true;
					},
				</c:when>
				<c:otherwise>
				</c:otherwise>
			</c:choose>
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
			if(item.lowerCnt > 0) {
				var isOpen = event.item._$isOpen; //현재 오픈됐는지
				var rowIdField = AUIGrid.getProp(myGridID, "rowIdField");
				AUIGrid.expandItemByRowId(myGridID, event.item[rowIdField], !isOpen);
			}else{
				<c:choose>
					<c:when test="${mode eq 'M'}">
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
					</c:when>
					<c:otherwise>
						AUIGrid.bind("#grid_list", "cellDoubleClick", function(event) {
							//fnSelect();
						});
					</c:otherwise>
				</c:choose>
			}

		});

		fnSearchGrid("/cd/cdFullJsonAjax/", "frmList", "#grid_list");
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

		AUIGrid.search(myGridID, "cdNm", $("#searchCdNm").val().trim(), options);
	}

	function fnSelect() {
		var str1 = "";
		var str2 = "";
		<c:choose>
			<c:when test="${mode eq 'M'}">
				var chkItems = AUIGrid.getCheckedRowItems(myGridID);
			</c:when>
			<c:otherwise>
				var chkItems = AUIGrid.getSelectedItems(myGridID);
			</c:otherwise>
		</c:choose>

		if(chkItems.length <= 0 ) {
			alert("코드를 선택하세요.");
			return;
		}

		var ids1 = [];
		var ids2 = [];
		for(var i=0; i<chkItems.length; i++) {
			ids1.push( chkItems[i].item.cd );
			ids2.push( chkItems[i].item.cdNm );
		}
		str1 = ids1.join(":");
		str2 = ids2.join(":");

		$("#txtCd").val(str1);
		$("#txtCdNm").val(str2);

		parent.cdSelectPopup.hide();
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
<input type="hidden" id="txtUpCd" name="txtUpCd" value="${upper_cd}">
<input type="hidden" id="txtCd" name="txtCd" value="">
<input type="hidden" id="txtCdNm" name="txtCdNm" value="">
<div class="popup_body" style="padding : 20px 20px 0px 20px">

	<div class="popup_search_box mb_20">
		<div class="search_in">
			<div class="stitle w_80px ">코드명</div>
			<div class="r_box">
				<input type="text" id="searchCdNm" name="searchCdNm" class="w_90p input_com_s" value="">

			</div>
			<input type="button" name="input_button" value="검색" class="btn_st2_3 icon_n popup_input" onclick="fnSearch();">
		</div>
	</div>

	<!--버튼 -->
	<div class="com_box  t_right">
		<div class="btn_box">
			<input type="button" name="input_button" value="선택 "  class="btn_st4 icon_n fl mr_m1" onclick="fnSelect();">
		</div>
	</div>
	<!--//버튼  -->
	<!--테이블 시작 -->
	<div class="com_box mb_30">
		<div class="tb_01_box">
			<div id="grid_list" style="width:100%; height:400px; margin:0 auto;"></div>
		</div>
	</div>
</div>
</form>
 <!--팝업박스 -->

</body>
</html>
