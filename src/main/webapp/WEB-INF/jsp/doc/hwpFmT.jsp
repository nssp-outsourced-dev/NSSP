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
		if(rlist.length == 1) {
			fnSetDataMapToList (rlist[0]);
		} else if (rlist.length > 1) {
			var json = {"TRGTER_NM":"[별지]","TRGTER_RRN":" 〃","OCCP_NM":" 〃","ADDR":" 〃","REGBS_ADDR":" 〃"};
			fnSetDataMap (json);
			pHwpCtrl.SetPos(0,0,100);
			fnInsertText("\r\n",false);
			fnInsertText("[별지]\r\n\r\n",false);

			var colArray = new Array(6.11, 29.07, 123.80);
			var rowArray = new Array(6.6,6.6,6.6,6.6);
			var firstCellName = ["RM_L","T1","TRGTER_NM_L","","T2","TRGTER_RRN_L","","T3","ADDR_L","","T4","OCCP_NM_L"];
			for(var i in rlist) {
				fnTrgterCreateTable (colArray, rowArray, firstCellName);
			}
			fnSetDataList (rlist);
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
	function fnTrgterCreateTable (colArray, rowArray, firstCellName) {
		var dact = pHwpCtrl.CreateAction("TableCreate");
		var dset = dact.CreateSet();
		var darrayset;
		var i;
		var size;
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
			pHwpCtrl.SetCurFieldName(firstCellName[i], 1, 0, 0);
			pHwpCtrl.Run("TableRightCell");
		}
		pHwpCtrl.MovePos(3, 0, 0);
	}
</script>
</html>
