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
					//대상자
					var rlist = data["strInputParam"+k];
					if(rlist.length == 1) {
						fnSetDataMapToList (rlist[0]);
					} else if (rlist.length > 1) {
						fnTrgterListSet (rlist, i);
					}
				} else {
					fnSetDataMap(data["strInputParam"+k]);
				}
			}
		}
	}
	function fnSetDataMapToList(json) {
		$.each(json, function(key, value){
			var cKey = key.replace("_L","");
			if(pHwpCtrl.FieldExist(cKey)){
				pHwpCtrl.PutFieldText(cKey, value);
			}
		});
	}
	var ppos = 1;
	function fnTrgterListSet (rlist, pi) {
		var json = {"TRGTER_NM":"[별지 "+pi+".]","TRGTER_RRN":" 〃","OCCP_NM":" 〃","ADDR":" 〃","E_CNT":"2"};
		if(pi == 2) json = {"ACNUT_NM":"[별지 "+pi+".]","ACNUT_BANK_NO":" 〃","DELNG_PD":" 〃","DELNG_CN":" 〃","E_CNT":"3"};

		fnSetDataMap (json);
	    // 표 만들기
	    pHwpCtrl.SetPos(0,ppos++,0);
	    fnInsertText("[별지 "+pi+".]\r\n\r\n",false);
	    if(pi == 1) {
	    	pHwpCtrl.SetPos(0,ppos++,0);
		    fnInsertText("피       의       자\r\n\r\n",true);
	    }

	    var colArray = new Array(6.11, 29.07, 123.80);
		var rowArray = new Array(6.6,6.6,6.6,6.6);
		var firstCellName = ["RM_L","T1","TRGTER_NM_L","","T2","TRGTER_RRN_L","","T3","OCCP_NM_L","","T4","ADDR_L"];
		if(pi == 2) firstCellName = ["RNM_L","TT1","ACNUT_NM_L","","TT2","ACNUT_BANK_NO_L","","TT3","DELNG_PD_L","","TT4","DELNG_CN_L"];

		for(var i in rlist) {
			pHwpCtrl.SetPos(0,ppos-i,0);
			fnParaSetAct ({"PrevSpacing":0,"NextSpacing":0});
			fnTrgterCreateTable (colArray, rowArray, firstCellName);
			ppos++;
		}
		pHwpCtrl.MovePos(20, 0, 0);
		pHwpCtrl.MovePos(22, 0, 0);
		fnInsertText("\r\n\r\n",false);
		ppos += 2;
		fnSetDataList (rlist);
		
		if(pi > 1) {
			ppos--;
			pHwpCtrl.SetPos(0,ppos,0);
			fnInsertText("\r\n\r\n",false);
		}
	}
	function fnTrgterCreateTable (colArray, rowArray, firstCellName) {
		var dact = pHwpCtrl.CreateAction("TableCreate");
		var dset = dact.CreateSet();
		var darrayset;
		var i;
		var size;
		var sizeChk = ["T2","TT2","TT4"];
		dset.SetItem("Rows", rowArray.length);
		dset.SetItem("Cols", colArray.length);
		dset.SetItem("WidthType", 2);
		dset.SetItem("HeightType", 1);
		dset.CreateItemSet("TableProperties", "Table");
		size = rowArray.length;
		darrayset = dset.CreateItemArray("RowHeight", size);
		for (i = 0; i < size; i++) {
			darrayset.SetItem(i, M2H(rowArray[i]));
		}
		size = colArray.length;
		darrayset = dset.CreateItemArray("ColWidth", size);
		for (i = 0; i < size; i++) {
			darrayset.SetItem(i, M2H(colArray[i]));
		}
		dact.Execute(dset);

		size = firstCellName.length;
		k = 1;
		for(i = 0; i < size; i++) {
			pHwpCtrl.Run("TableCellBlock");
			fnCharSetAct ({"Height":1300,"FaceNameHangul":"휴먼명조"});
		    if(k==i) {
		    	fnParaSetAct ({"AlignType":4});
		    	k += 3;
		    } else if ((k-1)==i) {
		    	fnSetAct ({"CellBorder":{"BorderTypeLeft":0,"BorderTypeTop":0,"BorderTypeBottom":0}});
		    }
		    if($.inArray( firstCellName[i], sizeChk ) == -1) {
		    	fnCharSetAct ({"RatioHangul":95,"SpacingHangul":-4});
		    } else {
		    	fnCharSetAct ({"RatioHangul":95,"SpacingHangul":-40});
		    }
		    fnParaSetAct ({"PrevSpacing":0,"NextSpacing":0});
			pHwpCtrl.SetCurFieldName(firstCellName[i], 1, 0, 0);
			pHwpCtrl.Run("TableRightCell");
			pHwpCtrl.Run("Cancel");
		}
	}
</script>
</html>