<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<!DOCTYPE html>

<html lang="ko">
<jsp:include page="./hwpctrlHeader.jsp"/>

<script type="text/javascript">
	// FORMAT_TYPE : A, B & QURY_CO : 1
	function fnSetParam (data) {
		var cnt = Number($("#prQuryCo").val());
		if(cnt == 1) {
			if(!fnIsEmpty(data.prInputYn) && data.prInputYn == "N") {
				if(!fnIsEmpty(data.prList) && data.prList == 'Y') {
					var jsonList = data.strInputParam;
					fnSetDataList(jsonList);
				} else {
					var json = data.strInputParam;
					fnSetDataMap(json);
				}
			}
		} else if(cnt > 1) {
			// Map이 1개인 경우, 나머지는 List로 처리
			for(var i = 0 ; i < cnt ; i++) {
				if(!fnIsEmpty(data["prInputYn"]) && data["prInputYn"] == "N") {
					if(i == 0) {
						var json = data["strInputParam"+(i+1)];
						fnSetDataMap(json);
					} else {
						var jsonList = data["strInputParam"+(i+1)];
						fnSetDataList(jsonList);
					}
				}
			}
		}
	}

</script>
</html>