<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>

<html lang="ko">
<jsp:include page="./hwpctrlHeader.jsp"/>

<script type="text/javascript">
	// 52.압수증명
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
					if(jsonList.length > 7) {
						fnSetDataListCcdrc(jsonList);
					} else {
						fnSetDataList(jsonList);
					}
				}
			}
		}
	}
	
	function fnSetDataListCcdrc(jsonList) {
		//var jsonList = data.strInputParam;
	    var textList = "";
		var fieldList = "";
		var pos = 39;  
		var kmap = ["RN","CCDRC_NM","CCDRC_QY","ETC"];
		for(var i in jsonList) {
			var json = jsonList[i];
			if(i < 7) {
				$.each(json, function(key, value) {
					textList += (json[key] + "\x02");
					fieldList += (key+"{{"+i+"}}\x02");
					pHwpCtrl.MoveToField(key+"{{"+i+"}}", false, false, false);
				});
			} else {
				fnInsertRow ();
				for(var k in kmap) {
					var dact = pHwpCtrl.CreateAction("CharShape");
					var dset = dact.CreateSet();
					dact.Execute(dset);
					pHwpCtrl.SetPos(pos++,0,0); //위치옮기고
					pHwpCtrl.SetCurFieldName(kmap[k]); //ID 셋팅
					var text = fnIsEmpty(json[kmap[k]])?"":json[kmap[k]]; //데이터 셋팅
					textList += (text+"\x02");
					fieldList += (kmap[k]+"{{"+i+"}}\x02");
				}
			}
		}
		pHwpCtrl.PutFieldText(fieldList, textList);
	}	
</script>
</html>
