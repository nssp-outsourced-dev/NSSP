<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>

<html lang="ko">
<jsp:include page="./hwpctrlHeader.jsp"/>

<script type="text/javascript">
	// 65.사건송치서
	function fnSetParam (data) {
		//console.log(data);
		var cnt = Number($("#prQuryCo").val());
		for(var i = 0 ; i < cnt ; i++) {
			if(!fnIsEmpty(data["prInputYn"]) && data["prInputYn"] == "N") {
				if(i == 0) {
					var json = data["strInputParam"+(i+1)];
					fnSetDataMap(json);
				} else {
					var jsonList = data["strInputParam"+(i+1)];
					if(jsonList.length > 5) {
						fnSetDataListTrn(jsonList);
						// 대상자 (별지)
						window.frames['Document_HwpCtrl'].HwpCtrl.PutFieldText("TRGTER_NM{{0}}", "(별지)");
						// 의견 (별지)
						var json = data.strInputParam1;
						var str = json.TRN_OPTION_NM_LIST;
						window.frames['Document_HwpCtrl'].HwpCtrl.PutFieldText("TRN_OPTION_NM_LIST", "(별지)");
						window.frames['Document_HwpCtrl'].HwpCtrl.PutFieldText("TRN_OPTION_NM_LIST_ADD", str);
					} else {
						fnSetDataList(jsonList);
					}
				}
			}
		}
	}
	
	function fnSetDataListTrn(jsonList) {
		//var jsonList = data.strInputParam;
		var textList = "";
		var fieldList = "";
		for(var i in jsonList) {
			var cChk = true;
			var json = jsonList[i];
			$.each(json, function(key, value) {
				if(!window.frames['Document_HwpCtrl'].HwpCtrl.FieldExist(key+"_ADD"+"{{"+i+"}}")) {
					var sRst = window.frames['Document_HwpCtrl'].HwpCtrl.MoveToField(key+"_ADD"+"{{"+(parseInt(i)-1)+"}}", false, false, false);
					if(sRst) {
						if(cChk) {
							window.frames['Document_HwpCtrl'].HwpCtrl.Run("TableCellBlock");
							window.frames['Document_HwpCtrl'].HwpCtrl.Run("TableColPageDown");
							window.frames['Document_HwpCtrl'].HwpCtrl.Run("TableAppendRow");
							window.frames['Document_HwpCtrl'].HwpCtrl.Run("Cancel");
							cChk = false;
						} else {
							var selectedPos = window.frames['Document_HwpCtrl'].HwpCtrl.GetPos();
							window.frames['Document_HwpCtrl'].HwpCtrl.MovePos(103, selectedPos.spara, selectedPos.spos);
						}
						window.frames['Document_HwpCtrl'].HwpCtrl.SetCurFieldName(key+"_ADD");
					}
				}
				textList += (jsonList[i][key] + "\x02");
				fieldList += (key+"_ADD"+"{{"+i+"}}\x02");
			});
		}
		
		console.log("fieldList : "+fieldList);
		console.log("textList : "+textList);
		
		window.frames['Document_HwpCtrl'].HwpCtrl.PutFieldText(fieldList, textList);
	}	
</script>
</html>
