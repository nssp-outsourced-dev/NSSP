<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<script type="text/javascript">
	$(function() {
		$(document).ready(function(){
			initGrid();
			fnClear();

			var iUrl = '<c:url value='/bbs/addManageAjax/'/>';
	 		var processAfterGet = function(data) {
				if(data.result == "1"){
					fnSearch();
					fnClear();
				}else{
					alert("진행중 오류가 발생하였습니다.");
				}
		    };
			Ajax.setAjaxForm(iUrl, "addForm", processAfterGet);
		});

	})


	function fnSearch() {
		fnSearchGridData("/bbs/manageListAjax/", "#grid_list", "");
	}

	function initGrid() {
		var columnLayout = [
			//{ dataField : "BBS_ID", headerText : "BBS_ID", width : 100, visible : false},
			{ dataField : "BBS_NM", headerText : "게시판명", width : 140},
			{ dataField : "REPLY_YN", headerText : "답변형", width : 60},
			{ dataField : "CMNT_YN", headerText : "덧글형", width : 60},
			{ dataField : "ATCH_FILE_CO", headerText : "첨부파일수", width : 70},
			{ dataField : "USE_YN", headerText : "사용여부", width : 60}
		];

		var gridPros = {
			headerHeight : 30,
			rowHeight: 30,
			fillColumnSizeMode : true,
			useGroupingPanel : false,
			showRowNumColumn : false
		};
		AUIGrid.create("#grid_list", columnLayout, gridPros);

		AUIGrid.bind("#grid_list", "cellClick", function(event) {
			var items = event.item;
			fnSelect(items.BBS_ID);
		});

		fnSearchGridData("/bbs/manageListAjax/", "#grid_list", "");

	}

	function fnSelect(sCd){
		var iUrl = '<c:url value='/bbs/manageDetailAjax/'/>';
 		var queryString =  "hidBbsId=" + sCd;
 		var processAfterGet = function(data) {
			$('#hidBbsId').val(data.BBS_ID);
			$('#txtBbsNm').val(data.BBS_NM);
			$('#txtBbsCn').val(data.BBS_CN);

			$('#divBbsUrl').html("/bbs/"+data.BBS_ID+"/list/<br>/bbs/"+data.BBS_ID+"/detail/<br>/bbs/"+data.BBS_ID+"/add/");

			$('#selReplyYn').val(data.REPLY_YN);
			$('#selUseYn').val(data.USE_YN);
			$('#selCmntYn').val(data.CMNT_YN);

			$('#selAtachFileCo').val(data.ATCH_FILE_CO);

			$('#selWritngAuthorSe').val(data.WRITNG_AUTHOR_SE);
			$('#selInqireAuthorSe').val(data.INQIRE_AUTHOR_SE);
			$('#selCmntWritngAuthorSe').val(data.CMNT_WRITNG_AUTHOR_SE);
			$('#selCmntInqireAuthorSe').val(data.CMNT_INQIRE_AUTHOR_SE);

 			$('#btnClear').show();
 			$('#btnAdd').hide();
 			$('#btnUpdate').show();
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}


	function fnClear(){
		$('#hidBbsId').val("");
		$('#txtBbsNm').val("");
		$('#txtBbsCn').val("");

		$('#divBbsUrl').html("<br>");

		$('#selReplyYn').val("Y");
		$('#selUseYn').val("Y");
		$('#selCmntYn').val("Y");

		$('#selAtachFileCo').val("1");

		$('#selWritngAuthorSe').val("0");
		$('#selInqireAuthorSe').val("0");
		$('#selCmntWritngAuthorSe').val("0");
		$('#selCmntInqireAuthorSe').val("0");

		$('#btnClear').hide();
		$('#btnAdd').show();
		$('#btnUpdate').hide();
	}

	function fnAdd(){
		if(fnFormValueCheck("addForm")){
			if(confirm("저장하시겠습니까?")){
		        $("#addForm").submit();
            }
		}
	}


</script>

<div class="box_w2 mb_50 mt_10">
	<div class="box_w2_1d">
		<div class="box_w2_top">
			<div class="title_s_st2 fl"><img src="/img/title_icon1.png" alt=""/>게시판 목록</div>
		</div>
		<div class="tb_01_box">
			<div id="grid_list" class="gridResize" style="width:100%; height:650px; margin:0 auto;"></div>
		</div>
	</div>

	<div class="box_w2_2d">
		<form id="addForm" name="addForm" method="post" action="<c:url value='/bbs/addManageAjax/'/>">
		<input type="hidden" id="hidBbsId" name="hidBbsId">
		<!--본문시작 -->
		<!--버튼 -->
		<div class="box_w2_top_r">
			<div class="btn_box">
			<a href="javascript:void(0);" id="btnClear" onClick="fnClear();" class="btn_st2 icon_n fl mr_m1">신규</a>
			<a href="javascript:void(0);" id="btnAdd" onClick="fnAdd();" class="btn_st2 icon_n fl mr_m1">추가</a>
			<a href="javascript:void(0);" id="btnUpdate" onClick="fnAdd();" class="btn_st2 icon_n fl mr_m1">수정</a>
			</div>
		</div>

		<!--//버튼  -->
		<!--테이블 시작 -->
		<div class="com_box mb_30">
			<div class="tb_01_box">
				<table class="tb_01">
				<col width="25%"/>
				<col width="25%"/>
				<col width="25%"/>
				<col width="25%"/>
				<tbody>
				<tr>
					<th>게시판명<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td colspan="3"><input type="text" id="txtBbsNm" name="txtBbsNm" maxlength="100" class="w_250px input_com" check="text" checkName="게시판명"></td>
				</tr>
				<tr>
					<th>게시판 URL</th>
					<td colspan="3" id="divBbsUrl" style="height: 80px;"></td>
				</tr>

				<tr>
					<th>게시판소개내용</th>
					<td colspan="3" style="height: 385px;">
						<textarea id="txtBbsCn" name="txtBbsCn" class="textarea_com w_100p" style="height: 380px !important"></textarea>
					</td>
				</tr>
				<tr>
					<th>답글가능여부<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td>
						<select id="selReplyYn" name="selReplyYn" class="w_80px input_com">
							<option value="Y">사용</option>
							<option value="N">미사용</option>
						</select>
					</td>
					<th>덧글가능여부<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td>
						<select id="selCmntYn" name="selCmntYn" class="w_80px input_com">
							<option value="Y">사용</option>
							<option value="N">미사용</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>첨부파일수<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td>
						<select id="selAtachFileCo" name="selAtachFileCo" class="w_80px input_com">
							<c:forEach var="idx" begin="0" end="10" >
								<option value="${idx}">${idx}</option>
							</c:forEach>
						</select>
					</td>
					<th>사용여부<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td>
						<select id="selUseYn" name="selUseYn" class="w_80px input_com">
							<option value="Y">사용</option>
							<option value="N">미사용</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>게시판 글쓰기 권한<span class="point"><img src="/img/point.png"  alt=""/></span></th>
					<td colspan="3">
						<select id="selWritngAuthorSe" name="selWritngAuthorSe" class="w_80px input_com">
							<option value="0">모두</option>
							<option value="1">관리자</option>
						</select>
					</td>
				</tr>
				</tbody>
				</table>
			</div>
		</div>
		</form>
	</div>
</div>
