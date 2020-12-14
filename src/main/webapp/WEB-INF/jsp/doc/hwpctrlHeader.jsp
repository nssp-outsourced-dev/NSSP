<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>웹한글기안기</title>
<script type="text/javascript" src="/js/jquery-1.11.1.js"></script>
<link type="text/css" href="/css/jquery-ui.css" rel="stylesheet" media="screen"/>
<script type="text/javascript" src="/js/jquery-ui.js"></script>
<script type="text/javascript" src="/js/cubox.js"></script>
<script type="text/javascript" src="/js/cubox.grid.js"></script>
<style type="text/css">
	body {
		font: "나눔고딕", nanumgodic;
		font-size: 1.0em;
		color:#37474f;
	}

	a {
		text-decoration: none;
		color: #37474f;
	}

	.wrapper {
		margin: 0 auto;
		padding: 50px;
	}

	.container {
		position: relative;
		width: 100%;
		background-color: #f0f8ff;
	}

	.lnb_Area {
		float: left;
		width: 230px;
		margin-top: 50px;
		margin-right: 40px;
		background-color: #f7f7f7;
		font-size: 0.8em;
		position: fixed;
	}

	.lnb-list {
		list-style: none;
		margin: 0;
		padding: 16px 12px 16px 16px;
	}

	.lnb-item {
		margin: 8px 0;
		line-height: 16px;
		cursor: pointer;
	}

	.lnb-item:hover {
		color: #333399;
		font-weight: bold;
	}

	.lnb-item.tabOn {
		color: #8b008b;
		font-weight: bold;
	}

	.content {
		float: left;
		margin-left: 270px;
	}

	.canvas_wrap {
		width: 100%;
		height: 100%;
		overflow: hidden;
		top:100px;
	}

	.contents-item {
		border-radius: 15px;
		padding: 10px;
		background-color: #f7f7f7;
		margin-bottom: 30px;
		margin-top: 10px;
		font-size: 0.85em;
	}

	h1.first-type { margin-top: 0px; }
	span.atv { color: #0d904f; }
	span.tag { color: #008000; }
	span.atr { color: #7F007F; }
	span.val { color: #2A00FF; }
	span.imp { color: #ff4500; font-weight:bold; }

	.content_tab {
		margin: 15px 0;
		overflow: hidden;

		/* width: 300px; */
		border-radius: 3px;
		-moz-border-radius: 3px;
		-webkit-border-radius: 3px;
		/* background: #fbfbfb; */
		-moz-box-sizing: border-box;
		-webkit-box-sizing: border-box;
		box-sizing: border-box
	}

	.content_tab li:first-child { border: 1px solid #9daeff; }
	.content_tab li {
		float: left;
		text-align: center;
		font-size: 0.8em;
		font-weight: bold;
		padding: 9px 0 10px;
		border: 1px solid #9daeff;
		border-left:none;
		/* border-left: 1px solid #c1c9f2; */
	}

	.content_tab .content_tab_list li {	width: 21%; }

	.content_tab_list {
		margin: 0;
		padding: 0;
		list-style: none;
	}

	.content_tab a.tabOn { color: #2b7bd6; }

	/* Toolbar Style */
	.hwp_toolbar {
		flex-wrap: nowrap;
		padding-left: 22px;
		box-sizing: border-box;
		position: relative;
		clear: both;
		display: flex;
		width: 100%;
		border-bottom: 1px solid #e0e0e0;
	}

	.hwp_toolbar_sub {
		flex: none;
		height: 25px;
	}

	.hwp_toolbar_title:hover {
		background: #e2e6f1;
		border-color: #96a6cd;
		color: #335095;
	}

	.hwp_toolbar_title {
		position: relative;
		display: inline-block;
		height: 23px;
		line-height: 21px;
		margin: 1px 0;
		padding: 0 14px;
		color: #333;
		border: 1px solid transparent;
		-webkit-border-radius: 2px;
		-moz-border-radius: 2px;
		border-radius: 2px;
		cursor: pointer;
		font-size: 12px;
		box-sizing: border-box;
		background: #fff;
		z-index: 10;
		flex: none;
	}

	.hwp_toolbar_title input {
		overflow: hidden;
	}
</style>

<script type="text/javascript">
$(function() {
	$(document).ready(function() {
		
		//팝업 종료시 부모창 refresh
		$(window).bind("beforeunload", function (e){

			var confirmValue = "문서를 종료하시겠습니까?";
			e.returnValue = confirmValue;
			<c:if test="${fn:length(ifr_id) > 0}">
				if( $("#ifrId").val().substring(0,2) == "fn" ){
					opener.location.href="javascript:"+$("#ifrId").val();
				} else {
					opener.location.href="javascript:document.getElementById('${ifr_id}').contentWindow.fnSearch();";
				}
			</c:if>
		});

		saveInterval = setInterval(function() {
			   //console.log('10분마다');
			   window.frames['Document_HwpCtrl'].HwpCtrl.SaveAs("${fileNm}.hwp", "HWP", "autosave:false", function (res) {
					fnSaveHwp( res, true );
			   });
			}, 600000); 
		
		
		$("#character_table_toolbar").hide();
		$("#character_table_toggle").text("펼치기");
		   
	});
	
	$("#test_event").click(function(e){

	});
	
	$("#down_event").click(function(e){
		window.frames['Document_HwpCtrl'].HwpCtrl.SaveDocument("${fileNm}.hwp", "HWP");
	});
	
	//File Save Event
	$("#save_event").click(function(e){
		window.frames['Document_HwpCtrl'].HwpCtrl.SaveAs("${fileNm}.hwp", "HWP", "autosave:false", function (res) {
			fnSaveHwp( res, false );
		});
		//document.frames['Document_HwpCtrl'].HwpCtrl.Clear(0);
		//document.frames['Document_HwpCtrl'].HwpCtrl.Save ($("#filePath").val());
	});
	
	//print Event
	$("#print_event").click(function(e){
		window.frames['Document_HwpCtrl'].HwpCtrl.PrintDocument()
	});
	
	//print Event
	$("#character_table_event").click(function(e){
		
		if( $("#character_table_toolbar").css("display") == "none" || $("#character_table_toolbar").css("display") == "inline" ){
			
			$("#character_table_toggle").text("펼치기");
			$("#character_table_toolbar").show();
		} else {
			$("#character_table_toggle").text("닫기");
			$("#character_table_toolbar").hide();
		}
	});
	
	
	$('.character').click(function(){
	    var id_check =  $(this).text();
	    var copyText =  $(this).text();
	    
	    copyToClipboard(  $(this).text() );
	});
	
	function copyToClipboard(text) {

		   var textArea = document.createElement( "textarea" );
		   textArea.value = text;
		   document.body.appendChild( textArea );       
		   textArea.select();

		   try {
		      var successful = document.execCommand( 'copy' );
		      var msg = successful ? 'successful' : 'unsuccessful';
		   } catch (err) {
		   }    
		   document.body.removeChild( textArea );
		}
	
});

</script>
</head>

<body>
	<!-- <h3 id="h1_5">Simple Example</h3> -->
	<div id="hwpctrl_Area" class="canvas_wrap">
		<div id="hwp_toolbar" class="hwp_toolbar" style="display:;">
			<div id="hwp_toolbar_open" class="hwp_toolbar_sub">
				<div class="hwp_toolbar_title" style="border-color: #333;">
					<span id="save_event">HWP저장</span>
				</div>
				<div class="hwp_toolbar_title" style="border-color: #333;">
					<span id="down_event">다운로드</span>
				</div>
				<div class="hwp_toolbar_title" style="border-color: #333;">
					<span id="character_table_event">사용자 정의 문자표 : <span id="character_table_toggle">펼치기</span></span>
				</div>
				<!--
				<div class="hwp_toolbar_title" style="border-color: #333;">
					<span id="print_event">인쇄</span>
				</div> 
				-->
				<div id="docTypeMode" class="hwp_toolbar_title" style="margin-left: 350px;">
				</div>
<!-- 				<div id="docTypeMode" class="hwp_toolbar_title" style="margin-left: 350px;">
				</div> -->
				<!--
				<div class="hwp_toolbar_title" style="border-color: #333;">
					<span id="test_event" onclick="test_event()">기능테스트</span>
				</div>
				-->
			</div>
		</div>
		
		<div id="character_table_toolbar" class="hwp_toolbar" style="display:;">
			<div id="hwp_toolbar_open1111" class="hwp_toolbar_sub">
				<table class="bbs_list" style="border-spacing: 0px;">
					<tr>
					<c:forEach var="word" items="${arrayWord}" varStatus="status">
					    <c:if test="${status.index%50==0}">
					        </tr><tr>
					    </c:if>
				        <td class="character" style="border: 1px solid #ccc;width: 19px;height:14px; text-align: center;">${word}</td>
					</c:forEach>
					</tr>
				</table>
			</div>
		</div>

		<input type="hidden" id="prDocId" 	  value="${prDocId}"    />
		<input type="hidden" id="prPblicteSn" value="${prPblicteSn}"/>
		<input type="hidden" id="prQuryCo" 	  value="${prQuryCo}"   />
		<input type="hidden" id="ifrId" 	  value="${ifr_id}" 	/>
		<input type="hidden" id="docType"     value="${prDocType}"  />
		<input type="hidden" id="hidClipboard"     value=""  />

		<iframe id="Document_HwpCtrl" name="Document_HwpCtrl" src="/doc/hwpctrlIframe/" style="width:100%; height:930px;"></iframe>
	</div>
</body>

<script type="text/javascript">

	var pHwpCtrl;

	/*
	 * 쿼리 및 한글 파일 호출
	 */
	function fnGetInfo() {
		var processAfterGet = function(data) {
			if(!fnIsEmpty(data.prFilePath)) {
				pHwpCtrl.Open(data.prFilePath, "HWP", "", function (res) {
					if(res.result) {
						fnSetParam (data);  // 문서마다 만들어야 할 코드

						/*권한이 없을 경우 읽기 전용모드 전환*/
						if( fnIsEmpty(data.owner) || data.owner != "Y" ){
							pHwpCtrl.EditMode = 0;
						}

						/*권한이 없을 경우 읽기 전용모드 전환*/
						if( data.owner == "Y" ){

							//docType - W:Write / R:Read
							if( $("#docType").val() == "R" ){
								pHwpCtrl.EditMode = 0;
							} else {
								pHwpCtrl.EditMode = 1;
							}
						} else {
							pHwpCtrl.EditMode = 0;
						}
						
						pHwpCtrl.EditMode = 1;	//문서작성 

						if( pHwpCtrl.EditMode == 0){
							$("#docTypeMode").text("[읽기모드]입니다");
						} else {
							$("#docTypeMode").text("[문서작성 모드]입니다");
						}
					}
				}, {"UserData" : "testData"});
			}
		}
		var param = "prDocId="+$("#prDocId").val()+"&prPblicteSn="+$("#prPblicteSn").val()+"&prQuryCo="+$("#prQuryCo").val();
		var ajaxUrl = "<c:url value='/doc/selectHwpctrlAjax/'/>";				//단일 쿼리 일때

		if( Number($("#prQuryCo").val()) > 1 ){
			ajaxUrl = "<c:url value='/doc/selectHwpctrlMultiAjax/'/>";			//쿼리가 1개 이상일 경우
		}
		Ajax.getJson(ajaxUrl, param, processAfterGet);
	}

	//한글기안기 최초 셋팅 후 호출되는 함수
	function hanCreateEditor(event, ee){
		pHwpCtrl = window.frames['Document_HwpCtrl'].HwpCtrl;  //한글 기안기 컨트롤 설정
		fnGetInfo();	// data 설정
	};

	function fnSetDataMap(json) {
		$.each(json, function(key, value){
			if(pHwpCtrl.FieldExist(key)){			//헤당 필드가 있을경우
				pHwpCtrl.PutFieldText(key, value);	//설정된 필드 ID에 데이터 입력
			}
		});
	}

	/*
	 * 표의 가장 마지막에 행 추가
	 */
	function fnAddRow () {
		pHwpCtrl.Run("TableCellBlock");		//현재 선택된 셀 블록처리
		pHwpCtrl.Run("TableColPageDown");	//현재 선택된 위치에서 표의 가장 마지막 셀로 커서 이동
		pHwpCtrl.Run("TableAppendRow");		//선택된 셀 아래에 행 추가
		pHwpCtrl.Run("Cancel");				//블록취소
	}

	/*
	 * 현재 위치에서 행 삽입
	 */
	function fnInsertRow () {
		pHwpCtrl.Run("TableCellBlock");
		//pHwpCtrl.Run("TableColPageDown");
		pHwpCtrl.Run("TableAppendRow");
		pHwpCtrl.Run("Cancel");
	}

	/*
	 * 현재 설정된 위치에 한글 text 삽입
	 * Text : 삽일할 text
	 * cnTy : 가운데 정렬 여부
	 */
	function fnInsertText(Text,cnTy){
		if(cnTy) {
			pHwpCtrl.Run('ParagraphShapeAlignCenter');	//중간 정렬
		} else {
			pHwpCtrl.Run('ParagraphShapeAlignLeft');
		}
		var dact = pHwpCtrl.CreateAction("InsertText");
		var dset = dact.CreateSet();
		dset.SetItem("Text", Text);
		dact.Execute(dset);
	}

	/*
	 * mm → point 변환 (한글기안기 스크립트에서는 point 치수 사용)
	 */
	function M2H( num ){
		return Math.floor(num * 283.465);
	}

	function fnSetDataList(jsonList) {
		jsonListd = jsonList;
		var textList = "";
		var fieldList = "";
		for(var i in jsonList) {
			var cChk = true;
			var json = jsonList[i];
			$.each(json, function(key, value) {
				if(!pHwpCtrl.FieldExist(key+"{{"+i+"}}")) {
					var sRst = pHwpCtrl.MoveToField(key+"{{"+(parseInt(i)-1)+"}}", false, false, false);		//해당되는 필드 아이디로 커서 이동
					if(sRst) {
						if(cChk) {
							fnAddRow ();
							cChk = false;
						} else {
							var selectedPos = pHwpCtrl.GetPos(); //현재 캐럿의 위치 정보를 얻어온다.
							pHwpCtrl.MovePos(103, selectedPos.spara, selectedPos.spos); //현재 캐럿이 위치한 셀의 아래쪽
						}
						pHwpCtrl.SetCurFieldName(key); //현재 캐럿 위치의 데이터 필드 이름을 설정한다.
					}
				}
				textList += (jsonList[i][key] + "\x02");
				fieldList += (key+"{{"+i+"}}\x02");
			});
		}
		pHwpCtrl.PutFieldText(fieldList, textList);
	}

	/*
	* 문단모양 설정
	* itmId : Parameter Set ID (38번) 의 Item ID 참조
	* {"PrevSpacing":0,"NextSpacing":0}
	*/
	function fnParaSetAct (setJson) {
		var paraShapeSet = pHwpCtrl.ParaShape;
		$.each(setJson, function(key, value){
			paraShapeSet.SetItem (key, value);
		});
		pHwpCtrl.ParaShape = paraShapeSet;
	}

	/*
	* 글자모양 설정
	* itmId : Parameter Set ID (7번) 의 Item ID 참조
	* {"FaceNameHangul":'휴먼명조',"Height":1300}
	*/
	function fnCharSetAct (setJson) {
		var charShapeSet = pHwpCtrl.CharShape;
		$.each(setJson, function(key, value){
			charShapeSet.SetItem(key, value);
		});
		pHwpCtrl.CharShape = charShapeSet;
	}

	/*
	* 그외 설정
	* actId : Parameter Set ID 참조
	* itmId : Parameter Set ID 의 Item ID 참조
	* {"CellBorderFill":{"ApplyTo":1,"NoNeighborCell":1}}
	*/
	function fnSetAct (setJson) {
		$.each(setJson, function(key, value){
			var bact = pHwpCtrl.CreateAction(key);
			var bset = bact.CreateSet();
			$.each(value, function(key, value){
				bset.SetItem(key, value);
			});
			bact.Execute(bset);
		});
	}

	//테스트 버튼
	function test_event () {
		//pHwpCtrl.Run("TableCellBlock");
		//pHwpCtrl.Run("TableRightCell");
		var pos = pHwpCtrl.GetPos();
		//alert('GetPos : ' + pos.list + ' ' + pos.para + ' ' + pos.pos);
		//fnSetDataList(jsonListd);
		//var sRst = window.frames['Document_HwpCtrl'].HwpCtrl.MoveToField("CCDRC_NM{{"+(parseInt(13)-1)+"}}", false, false, false);
	}
</script>

