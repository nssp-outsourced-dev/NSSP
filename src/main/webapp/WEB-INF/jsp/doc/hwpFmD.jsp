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
		
		for(var i in rlist) {
			var json = rlist[i];
			if(i==0) {
				$.each(json, function(key, value) {
					textList += (json[key] + "\x02");
					fieldList += (key+"{{"+i+"}}\x02");
					pHwpCtrl.MoveToField(key+"{{"+i+"}}", false, false, false);
				});
			} else {
				/* 0번째 데이터와 1번째 데이터간에 간격을 좁게 수정한 소스 */
				//fnAddRow ();//빈행 행을 만들지 않음
				pHwpCtrl.MovePos(105, 0, 0);
				pos = (pHwpCtrl.GetPos().list) + 1 + 6; //연락처 , 직업 추가로 인해 2행이 추가됬으므로 셀은 6개 추가되었음.
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
