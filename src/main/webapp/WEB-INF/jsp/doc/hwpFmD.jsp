<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>

<html lang="ko">
<jsp:include page="./hwpctrlHeader.jsp"/>

<script type="text/javascript">

	function fnSetParam (data) {
		var cnt = parseInt($("#prQuryCo").val());
		for(var i=0; i<cnt; i++) {
			var k = parseInt(i)+1;
			if(!fnIsEmpty(data["prInputYn"]) && data["prInputYn"] == "N") {
				if(!fnIsEmpty(data["prList"+k]) && data["prList"+k] == 'Y') {
					fnTrgterListSet (data["strInputParam"+k]);
				} else {
					fnSetDataMap (data["strInputParam"+k]);
				}
			}
		}
	}
	function fnTrgterListSet (rlist) {
	    var textList = "";
		var fieldList = "";
		var pos = 0;
		var kmap = {
				0:["RM","T1","TRGTER_NM"]
				, 1:["","T2","TRGTER_RRN"]
				, 2:["","T3","ADDR"]
				, 3:["","T4","TEL"]
				, 4:["", "T5", "OCCP_NM"]//직업란 추가로 인한 4번째 추가  by dgkim
		};
		var kmapPos = 0;
		
		for(var i in rlist) {
			var json = rlist[i];
			if(i==0) {
				$.each(json, function(key, value) {
					textList += (json[key] + "\x02");
					fieldList += (key+"{{"+i+"}}\x02");
					pHwpCtrl.MoveToField(key+"{{"+i+"}}", false, false, false);
				});
				
				/* 의견서만 직업란을 추가하도록 수정 by dgkim */
				if("<c:out value='${fileNm}' />" === "의견서"){
					/* if(json.T2.indexOf("법인") == -1){//기업일 경우
						kmapPos = Object.keys(kmap).length;//직업란 추가
					}else{
						kmapPos = (Object.keys(kmap).length) -1;//직업란 제외
					} */
					
					kmapPos = Object.keys(kmap).length;//직업란 추가
					pos = (pHwpCtrl.GetPos().list) + 1 + 7;//인적사항 사이 간격을 없애기위해 처음에만 증가한다
				}else{
					kmapPos = (Object.keys(kmap).length) - 1;//의견서가 아닌 경우 직업란 추가하지 않도록 수정 dy dgkim
					pos = (pHwpCtrl.GetPos().list) + 1 + 4;//인적사항 사이 간격을 없애기위해 처음에만 증가한다
				}
			} else {
				//fnAddRow ();//빈행 행을 만들지 않음
				pHwpCtrl.MovePos(105, 0, 0);
				//pos = (pHwpCtrl.GetPos().list) + 1;
				for(var s = 0; s < kmapPos; s++) {//직업란 추가로 loop의 횟수를 고정값이 아닌 동적으로  수정 by dgkim
					fnAddRow ();
					var karr = kmap[s];
					for(var k in karr) {
						if(s==1 && k==2) {
							fnCharSetAct ({"RatioHangul":95,"SpacingHangul":-10});
						} else {
							fnCharSetAct ({"RatioHangul":100,"SpacingHangul":-4});
						}
						pHwpCtrl.SetPos(pos++,0,0);
						pHwpCtrl.SetCurFieldName(karr[k]);
						
						if("RM" == karr[k]){ pHwpCtrl.Run('ParagraphShapeAlignCenter'); }//인적사항번호 가운데 정렬(참고 : https://www.hancom.com/board/devmanualList.do)
						
						var text = fnIsEmpty(json[karr[k]])?"":json[karr[k]];
						textList += (text+"\x02");
						fieldList += (karr[k]+"{{"+i+"}}\x02");
					}
				}

				/* 기존 소스 */
				/* fnAddRow ();
				pHwpCtrl.MovePos(105, 0, 0);
				pos = (pHwpCtrl.GetPos().list) + 1;
				for(var s = 0; s < Object.keys(kmap).length; s++) {//직업란 추가로 loop의 횟수를 고정값이 아닌 동적으로  수정 by dgkim
					fnAddRow ();
					var karr = kmap[s];
					for(var k in karr) {
						if(s==1 && k==2) {
							fnCharSetAct ({"RatioHangul":95,"SpacingHangul":-10});
						} else {
							fnCharSetAct ({"RatioHangul":100,"SpacingHangul":-4});
						}
						pHwpCtrl.SetPos(pos++,0,0);
						pHwpCtrl.SetCurFieldName(karr[k]);
						var text = fnIsEmpty(json[karr[k]])?"":json[karr[k]];
						textList += (text+"\x02");
						fieldList += (karr[k]+"{{"+i+"}}\x02");
					}
				} */
			}
		}
		pHwpCtrl.PutFieldText(fieldList, textList);
	}
</script>
</html>
