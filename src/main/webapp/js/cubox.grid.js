
/**
 * grid(paging) 페이지 이동 *
 * paging에 사용할 form 필수 항목
 * - hidPage : 현재 페이지
 * - hidPageArea : 페이지 숫자수
 * - hidPageBlock : 한 페이지 row수
 * - hidTotCnt : 전체 row수
 * */
function fnMoveGridPage(url, form, grid, sPage) {
	if(url == "/juso/jusoListAjax/") { if($.isFunction(fnValiJusoSearch)) { if(!fnValiJusoSearch()) return; } }
	$('#'+ form +' [name="hidPage"]').val(sPage);
	fnSearchGridPage(url, form, grid);
}

/**
 * grid(paging) search *
 * paging에 사용할 form 필수 항목
 * - hidPage : 현재 페이지
 * - hidPageArea : 페이지 숫자수
 * - hidPageBlock : 한 페이지 row수
 * - hidTotCnt : 전체 row수
 * */
function fnSearchGridPage(url, form, grid){
	// ajax 요청 전 그리드에 로더 표시
	var param = $('#' + form).serialize();
	$.ajax({
		url : url,
		dataType : 'json',
		type : 'POST',
		async : true,
		data : param,
		beforeSend:function(){
			AUIGrid.showAjaxLoader(grid); // 로더 시작
		},
		success : function(data) {
	      	// 그리드 데이터
			$('#'+ form +' [name="hidTotCnt"]').val(data.cnt);
	      	var gridData = data.list;
		    // 그리드에 데이터 세팅
	    	AUIGrid.setGridData(grid, gridData);
	    	/*
	    	 * 2021.09.15
	    	 * coded by dgkim
	    	 * no data 메세지 때문에 좌우 스크룰 활성되지 않는 현상 방지를 위해 안보이게 처리
	    	 * */
	    	//$(grid).find(".aui-grid-nodata-msg-layer").text("");
	    	$(grid).find(".aui-grid-nodata-msg-layer").hide();
		},
		complete:function(){
			AUIGrid.removeAjaxLoader(grid); // 로더 끝
			fnCreatePagingNavigator(url, form, grid);
			setSorting(grid);
		},
	    error: function(request, errorType)
		{
			try
			{
				if(errorType == 'timeout')
				{
					if(Ajax.timeoverError){
						alert(Ajax.timeoverError);
					}else{
						alert("처리시간이 만료되었습니다. 관리자에게 문의해주세요.");
					}

				} else
				{
					if(Ajax.retrievefailError){
						alert(Ajax.retrievefailError);
					}else{
						alert("자료를 받아올 수 없습니다. 관리자에게 문의해주세요.");
					}
					location.reload();
				}
			}
			catch (e) {
			}
		},
		onError : function(status, e) {
            alert("데이터 요청에 실패하였습니다.\r status : " + status);
 		}
	});
}


/**
 * grid page navi.
 * */
	function fnCreatePagingNavigator(url, form, divId) {
		var divPagingId = divId + "_paging";
		var totalRowCount = Number($('#'+ form +' [name="hidTotCnt"]').val());
		var pageBlock = Number($('#'+ form +' [name="hidPageBlock"]').val());
		var pageArea = Number($('#'+ form +' [name="hidPageArea"]').val());
		var goPage = Number($('#'+ form +' [name="hidPage"]').val());
		var retStr = "";

		if(pageBlock == 0){
			retStr += "<div class=\"pagebox\">";
			retStr += "<a href='javascript:void(0);' class='ar1'><img src='/img/al_icon3.png' alt=''/></a>";
			retStr += "<a href='javascript:void(0);' class='ar'><img src='/img/al_icon2.png' alt=''/></a>";
			retStr += "<div class='umbox'>";
			retStr += "<a href='javascript:void(0);' class='on'> 1 </a>";
			retStr += "</div>";
			retStr += "<a href='javascript:void(0);' class='ar'><img src='/img/ar_icon2.png' alt=''/></a>";
			retStr += "<a href='javascript:void(0);' class='ar1'><img src='/img/ar_icon3.png' alt=''/></a>";
			retStr += "</div>";
		}else{
			var totalPage = Math.ceil(totalRowCount / pageBlock);	// 전체 페이지 계산
			var prevPage = parseInt((goPage - 1)/pageArea) * pageArea;
			var nextPage = ((parseInt((goPage - 1)/pageArea)) * pageArea) + pageArea + 1;

			prevPage = Math.max(0, prevPage);
			nextPage = Math.min(nextPage, totalPage);

			var tempPage = 1;
			if(prevPage > 0){
				tempPage = prevPage;
			}

			retStr += "<div class=\"pagebox\">";
			retStr += "<a href='javascript:fnMoveGridPage(\""+ url +"\",\""+ form +"\",\""+ divId +"\",1);' class='ar1'><img src='/img/al_icon3.png' alt=''/></a>";
			retStr += "<a href='javascript:fnMoveGridPage(\""+ url +"\",\""+ form +"\",\""+ divId +"\","+ tempPage +");' class='ar'><img src='/img/al_icon2.png' alt=''/></a>";
			retStr += "<div class='umbox'>";

			for (var i=(prevPage+1), len=(pageArea+prevPage); i<=len; i++) {
				if (goPage == i) {
					retStr += "<a href='javascript:void(0);' class='on'> "+ i +" </a>";
				} else {
					retStr += "<a href='javascript:fnMoveGridPage(\""+ url +"\",\""+ form +"\",\""+ divId +"\","+ i +");'> "+i+" </a>";
				}
				if (i >= totalPage) {
					break;
				}
			}

			retStr += "</div>";
			retStr += "<a href='javascript:fnMoveGridPage(\""+ url +"\",\""+ form +"\",\""+ divId +"\","+ nextPage +");' class='ar'><img src='/img/ar_icon2.png' alt=''/></a>";
			retStr += "<a href='javascript:fnMoveGridPage(\""+ url +"\",\""+ form +"\",\""+ divId +"\","+ totalPage +");' class='ar1'><img src='/img/ar_icon3.png' alt=''/></a>";
			retStr += "</div>";
		}

		$(divPagingId).html(retStr);
	}


/**
 * grid를 조회한다.
 * */
function fnSearchGrid(url, form, grid){
	var param = $('#' + form).serialize();
	$.ajax({
		url : url,
		dataType : 'json',
		type : 'POST',
		async : true,
		data : param,
		beforeSend:function(){
			AUIGrid.showAjaxLoader(grid); // 로더 시작
		},
		success : function(data) {
			// 그리드 데이터
	      	var gridData = data;
	      	// 그리드에 데이터 세팅
	    	AUIGrid.setGridData(grid, gridData);
	    	$(grid).find(".aui-grid-nodata-msg-layer").text("");
		},
		complete:function(){
			AUIGrid.removeAjaxLoader(grid); // 로더 끝
		},
	    error: function(request, errorType)
		{
			try
			{
				if(errorType == 'timeout')
				{
					if(Ajax.timeoverError){
						alert(Ajax.timeoverError);
					}else{
						alert("처리시간이 만료되었습니다. 관리자에게 문의해주세요.");
					}

				} else
				{
					if(Ajax.retrievefailError){
						alert(Ajax.retrievefailError);
					}else{
						alert("자료를 받아올 수 없습니다. 관리자에게 문의해주세요.");
					}
					location.reload();
				}
			}
			catch (e) {
			}
		},
		onError : function(status, e) {
            alert("데이터 요청에 실패하였습니다.\r status : " + status);
 		}
	});
}
/**
 * grid를 조회한다.
 * */
function fnSearchGridData(url, grid, param){
	$.ajax({
		url : url,
		dataType : 'json',
		type : 'POST',
		async : true,
		data : param,
		beforeSend:function(){
			AUIGrid.showAjaxLoader(grid); // 로더 시작
		},
		success : function(data) {
	      	// 그리드 데이터
	      	var gridData = data;
		    // 그리드에 데이터 세팅
	    	AUIGrid.setGridData(grid, gridData);
	    	$(grid).find(".aui-grid-nodata-msg-layer").text("");
		},
		complete:function(){
			AUIGrid.removeAjaxLoader(grid); // 로더 끝
		},
	    error: function(request, errorType)
		{
			try
			{
				if(errorType == 'timeout')
				{
					if(Ajax.timeoverError){
						alert(Ajax.timeoverError);
					}else{
						alert("처리시간이 만료되었습니다. 관리자에게 문의해주세요.");
					}

				} else
				{
					if(Ajax.retrievefailError){
						alert(Ajax.retrievefailError);
					}else{
						alert("자료를 받아올 수 없습니다. 관리자에게 문의해주세요.");
					}
					location.reload();
				}
			}
			catch (e) {
			}
		},
		onError : function(status, e) {
            alert("데이터 요청에 실패하였습니다.\r status : " + status);
 		}
	});
}

/**
 * grid를 조회한다.
 * */
function fnSearchGridAdd(url, form, grid){
	var param = $('#' + form).serialize();
	var gridData = "";
	$.ajax({
		url : url,
		dataType : 'json',
		type : 'POST',
		async : false,
		data : param,
		beforeSend:function(){
			AUIGrid.showAjaxLoader(grid); // 로더 시작
		},
		success : function(data) {
	      	// 그리드 데이터
	      	gridData = data;
		},
		complete:function(){
			AUIGrid.removeAjaxLoader(grid); // 로더 끝
		},
	    error: function(request, errorType)
		{
			try
			{
				if(errorType == 'timeout')
				{
					if(Ajax.timeoverError){
						alert(Ajax.timeoverError);
					}else{
						alert("처리시간이 만료되었습니다. 관리자에게 문의해주세요.");
					}

				} else
				{
					if(Ajax.retrievefailError){
						alert(Ajax.retrievefailError);
					}else{
						alert("자료를 받아올 수 없습니다. 관리자에게 문의해주세요.");
					}
					location.reload();
				}
			}
			catch (e) {
			}
		},
		onError : function(status, e) {
            alert("데이터 요청에 실패하였습니다.\r status : " + status);
 		}
	});
	return gridData;
}


/**
 * grid를 조회한다.
 * */
function fnAddList(url, param){
	var gridData = "";
	$.ajax({
		url : url,
		dataType : 'json',
		type : 'POST',
		async : true,
		data : param,
		beforeSend:function(){
			AUIGrid.showAjaxLoader(grid); // 로더 시작
		},
		success : function(data) {
			// 그리드 데이터
	      	gridData = data;
		},
		complete:function(){
			AUIGrid.removeAjaxLoader(grid); // 로더 끝
		},
	    error: function(request, errorType)
		{
			try
			{
				if(errorType == 'timeout')
				{
					if(Ajax.timeoverError){
						alert(Ajax.timeoverError);
					}else{
						alert("처리시간이 만료되었습니다. 관리자에게 문의해주세요.");
					}

				} else
				{
					if(Ajax.retrievefailError){
						alert(Ajax.retrievefailError);
					}else{
						alert("자료를 받아올 수 없습니다. 관리자에게 문의해주세요.");
					}
					location.reload();
				}
			}
			catch (e) {
			}
		},
		onError : function(status, e) {
            alert("데이터 요청에 실패하였습니다.\r status : " + status);
 		}
	});
	return gridData;
}



/**
 * grid column combo label
 */
function gridComboLabel(keyValueList, value){
	var retStr = "";
	for(var i=0,len=keyValueList.length; i<len; i++) {
		if(keyValueList[i]["cd"] == value) {
			retStr = keyValueList[i]["cdNm"];
			break;
		}
	}
	return retStr;
}

/**
 * grid에서 수정된 row를 반환한다.
 * 추가, 수정, 삭제 로우
 * grid : dom Id
 */
function getGridEditRow(grid){
	// 추가된 행 아이템들(배열)
	var addedRowItems = AUIGrid.getAddedRowItems(grid);
	// 수정된 행 아이템들(배열)
	var editedRowItems = AUIGrid.getEditedRowItems(grid);
	// 삭제된 행 아이템들(배열)
	var removeRowItems = AUIGrid.getRemovedItems("#grid_wrap03");
	var data = new Object();
	data.list = addedRowItems.concat(editedRowItems);
	data.delList = removeRowItems;
	return  data;
}


/**
 * array Object에 gridArray를 추가한다.
 * */
function arrayObjPush(array, gridArray){
	if(gridArray.length > 0){
		//alert('gridArray.length :'+gridArray.length);
		for(i in gridArray){
			//alert('i : '+i+'  '+JSON.stringify(gridArray[i]));
			if(typeof(gridArray[i].item) == undefined || gridArray[i].item == null){
				//alert(1+' : '+JSON.stringify(gridArray[i]));
				array.push(gridArray[i]);
			}else{
				//alert(2);
				array.push(gridArray[i].item);
			}
		}
	}
	return array;
}

function gridHeight(grid){
	var height = null;

	if($('#'+grid).next().length == 0){ //해당 그리드가 마지막일때
		var preHeight = 0;
		$('#'+grid).prevAll().each(function(){
			preHeight = preHeight + $(this).height();
		});
		height = $(".subRightCon").height() - preHeight - 70;
	}else{ // 다음 요소가 있을때
		height = 300;
	}

	return height;
}

/**
 * selectionMode : "multipleRows",// 선택모드 인 경우에만 해당
 * */
function getSelectedItem(selectedItems){
	if(selectedItems.length <= 0){
		 alert('선택한 행이 없습니다.')
		 return null;
	 }

	 if(selectedItems.length > 1){
		 alert('한 건만 선택하세요.')
		 return null;
	 }
	 return selectedItems[0].item;
}

/**
 * grid 벨리데이션 체크 ex) gridValidationCheck("gridId", chckCol[]);
 * chckCol[] : check할 컬럼 dataField Array
 *
 * @param formName
 *            form 객체명
 * @return bool
 */
function gridValidationCheck(gridId, chckCol) {
	var rowCount = AUIGrid.getRowCount(gridId);
	var rowIdField = AUIGrid.getProperty(gridId, "rowIdField");
	for(var i=0; i<rowCount; i++) {
		//추가 또는 수정이 아닐 경우는 제외
		//if(!(AUIGrid.isAddedById(gridId, items[i][rowIdField]) || AUIGrid.isEditedById(gridId, items[i][rowIdField])))
		//	continue;
		for(var j in chckCol) {
			AUIGrid.setSelectionByIndex(gridId, i, AUIGrid.getColumnIndexByDataField(gridId, chckCol[j]));
			var selItem = AUIGrid.getSelectedItems(gridId);
			if(fnIsEmpty(selItem[0].item[chckCol[j]])) {
				alert("[" + selItem[0].headerText  + "]이(가) 입력되지 않았습니다.");
				AUIGrid.openInputer(gridId);
				return true;
			}
		}
	}
	return false;
}

//그리드의 수정,추가,삭제 상태값 반환
function getItemState(grid, curItem) {

	var rowIdField = AUIGrid.getProperty(grid, "rowIdField");
	var rowIdValue = curItem[rowIdField];

	// 추가된 행인지 여부 검사.
	var isAdded = AUIGrid.isAddedById(grid, rowIdValue );
	if(isAdded) return "Added";

	// 수정된 행인지 여부 검사
	var isEdited = AUIGrid.isEditedById(grid, rowIdValue );
	if(isEdited) return "Edited";

	// 삭제된 행인지 여부 검사
	var isRemoved = AUIGrid.isRemovedById(grid, rowIdValue );
	if(isRemoved) return "Removed";

	return "Normal";
}

//그리드 목록의 수정,추가 행 반환
function getAddEditItemList(grid) {
	var griedList =  [];
	griedList = griedList.concat(AUIGrid.getEditedRowItems(grid), AUIGrid.getAddedRowItems(grid));
	return griedList;
}

//숫자와 소수점만 입력가능한 에디터 랜더러
var demicalRenderer = {
		type : "InputEditRenderer",
		validator : function(oldValue, newValue, rowItem, dataField) {
			var isValid = false;
			var matcher = /^\d*[0-9](\.\d*[0-9])?$/; // 정규식

			if(matcher.test(newValue) || fnIsEmpty(newValue)) {
				isValid = true;
			}
			// 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
			return { "validate" : isValid, "message"  : "숫자만 입력가능합니다.소숫점" };
		}
}

//숫자만 입력가능
var numberRenderer = {
		type : "InputEditRenderer",
		onlyNumeric : true
}

var dateRegx = /[0-9]{4}-(0[1-9]|1[012])-(0[1-9]|1[0-9]|2[0-9]|3[01])/; //YYY-MM-dd
//달력 랜더러
var calendarRenderer = {
	   	type : "CalendarRenderer",
		defaultFormat : "yyyy.mm.dd.",
		showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
		onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
		showExtraDays : true, // 지난 달, 다음 달 여분의 날짜(days) 출력
		showTodayBtn : true, // 오늘 날짜 선택 버턴 출력
		showUncheckDateBtn : true, // 날짜 선택 해제 버턴 출력
		todayText : "오늘 선택", // 오늘 날짜 버턴 텍스트
		uncheckDateText : "날짜 선택 해제", // 날짜 선택 해제 버턴 텍스트
		uncheckDateValue : "",
		validator : function(oldValue, newValue, item, dataField, fromClipboard) { // 에디팅 유효성 검사
			// 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
			var chk = false;
			if(fnIsEmpty($.trim(newValue)))
				chk = true;
			else
				chk = dateRegx.test(newValue);
			return { "validate" : chk, "message"  : "2016.02.01. 형식으로 입력해주세요." };
		}
}

//달력 플레이스 홀더 역활
var calendarPlaceholder = function(  rowIndex, columnIndex, value, headerText, item ) {
		return (fnIsEmpty(value))?'YYYY-MM-DD':value;
	}

//체크박스 랜더러
var checkBoxEditRenderer = {
		type : "CheckBoxEditRenderer",
		editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
		checkValue : "Y", // true, false 인 경우가 기본
		unCheckValue : "N"
}

//아이콘팝업 랜더러
var searchIconRenderer = function(clickFunc){
	return {
		type : "IconRenderer",
			iconWidth : 16, // icon 사이즈, 지정하지 않으면 rowHeight에 맞게 기본값 적용됨
			iconHeight : 16,
			iconPosition : "aisle",
			iconTableRef :  { // icon 값 참조할 테이블 레퍼런스
				"default" : iconSearch // default
			},
			onclick :clickFunc
	}
};

//드로그앤드랍 랜더러
var ddlLstRenderer = function(list){
	return {
		type : "DropDownListRenderer",
		list : list,
		keyField : "code", // key 에 해당되는 필드명
		valueField : "codeName" // value 에 해당되는 필드명
	}
}

//파일유무 label function
var fileLabel = function(  rowIndex, columnIndex, value, headerText, item ) {
  	return (fnIsEmpty(value) || value == '0')?"N":"Y";
}

var fileIcon = "../../../img/add_file.png";
var iconSearch = "../../../img/search.png";
var headerIconSearch = '<img src="../../../img/search.png" style="vertical-align:middle;margin:0 4px 0 6px;height:15px;">';
//파일 아이콘처리
var fileIconFunction = function(rowIndex, columnIndex, value, item) {
	return fileIcon;
}

//달력 ctrl+v 용 벨리데이터
/*
 •type : 이벤트 유형
 •rowIndex : 행 인덱스
 •columnIndex : 칼럼 인덱스
 •oldValue : 변경 전 셀 값(value)
 •value : 변경 된 셀 값(value)
 •headerText : 현재 칼럼의 헤더 텍스트
 •item : 해당 행에 출력되고 있는 행 아이템 객체 (Object)
 •dataField : 행 아이템에서 현재 칼럼이 출력되고 있는 데이터의 KeyField
 •isClipboard : 붙여 넣기(Ctrl+V) 로 이벤트가 발생했는지 여부 (Boolean)
 */
var calendarValidator = function(event){
	if(event.isClipboard){
		if(fnIsEmpty($.trim(event.value)))
			return "";
		else {
			if(!dateRegx.test(event.value)) {
				alert('2016-02-01 형식으로 입력해주세요.');
				return event.oldValue;
			} else {
				return event.value;
			}
		}
	} else {
		return event.value;
	}
};

/**
 * grid resize
 * */
function gridResize(){
	$('.gridResize').each(function(){
		var domId = $(this).attr('id');
		if(!fnIsEmpty(domId)){
			AUIGrid.resize("#"+domId);
		}
	});
}

/**
 * json to Form
 * */
function fn_form_bind(form, json, type){
	var text;
	if(json._$uid != null){
		delete json._$uid;
	}
	for(var i in json){
		if(type=="GRID") {
			var cName = (i).replace(/grd/g, "");
		} else {
			var cName = (i).charAt(0).toUpperCase() + (i).slice(1);
		}
		var inputType = $('#'+form).find("input[name='"+('txt'+cName)+"'], input[name='"+('hid'+cName)+"']," +
						"input[name='"+('rdo'+cName)+"'], input[name='"+('chk'+cName)+"']," +
						"select[name='"+('sel'+cName)+"'], textarea[name='"+('txt'+cName)+"']").prop('type');
		switch (inputType) {
		case "text":
			cName = 'txt'+cName;
			break;
		case "hidden":
			cName = 'hid'+cName;
			break;
		case "radio":
			cName = 'rdo'+cName;
			break;
		case "checkbox":
			cName = 'chk'+cName;
			break;
		case "select-one":
			cName = 'sel'+cName;
			break;
		case "textarea":
			cName = 'txt'+cName;
			break;
		default :
			cName = 'lab'+cName;
			break;
		}
		if(inputType == "text"|| inputType == "hidden" ){
			$('#'+form).find("input[name='"+cName+"']").val(json[i]);
		}else if(inputType == "radio"){
			$('#'+form).find("input:radio[name='"+cName+"']").removeAttr('checked');
			$('#'+form).find("input:radio[name='"+cName+"']:radio[value='"+json[i]+"']").prop('checked', true);
		}else if(inputType == "checkbox"){
			$('#'+form).find("input:checkBox[name='"+cName+"']").val(json[i]);
			if(json[i] == null || json[i] == '' || json[i] =='N' ){
				$('#'+form).find("input:checkBox[name='"+cName+"']").prop('checked', false);
			}else{
				$('#'+form).find("input:checkBox[name='"+cName+"']").prop('checked', true);
			}
		}else if(inputType == "select-one"){
			$('#'+form).find("select[name='"+cName+"']").val(json[i]);
		}else if(inputType == "textarea"){
			$('#'+form).find("textarea[name='"+cName+"']").val(json[i]);
		}else{ // label
			if(json[i] != null){
				text = 	$('#'+form).find("label[id='"+cName+"']").text();
				if(text != null || text == ''){
					$('#'+form).find('#'+cName).text('');
				}
				$('#'+form).find('#'+cName).text(json[i]);
			}
		}
	}
}

/**
 * array Object 중복 확인
 */
function uniqueAdd(arrayObjA, arrayObjB, uniqueKey){
	var result = [];
	var list = [];
	for(i in arrayObjB){
		if($.inArray(arrayObjB[i][uniqueKey], list) == -1){
			list.push(arrayObjB[i][uniqueKey]);
		}
	}

	for(i in arrayObjA){
		if($.inArray(arrayObjA[i][uniqueKey], list) == -1){
			result.push(arrayObjA[i]);
		}
	}

	return result;
}

/**
 * @설명 : ajax로 grid data 데이터처리
 * @파라미터 : url - 주소 , data - 데이터
 */
function fnAjaxAction (url, data) {
	var ret = null;
	$.ajax({
		url : url,
		dataType : 'json',
		type : 'POST',
		async : false,
		processData : true,
		data : data,
		contentType : "application/json; charset=UTF-8",
		success : function(json) {
			ret = json;
		},
		error : function(xhr, stat, err) {
	    	 alert("error");
	    	 console.log(err);
	    }
	});
	return ret;
}

/**
 * @설명 : ajax로 grid 공통코드 data 데이터처리
 * @파라미터 : url - 주소 , data - 데이터
 */
function fnAjaxAction2 (data) {
	var ret = null;
	$.ajax({
		url : "/cd/cdGridListAjax/",
		type : 'POST',
		dataType : 'json',
		async : false,
		processData : true,
		data : JSON.stringify(data),
		contentType : "application/json; charset=UTF-8",
		success : function(json) {
			ret = json;
		},
		error : function(xhr, stat, err) {
	    	 alert("error");
	    	 console.log(err);
	    }
	});
	return ret;
}

/**
 * @설명 : 일괄 조회된 코드 목록을 상위코드에 해당되는 목록으로 리턴
 * @파라미터 : codeList - 전체 코드 , preCode - 필터할 코드
 */
function getCodeList(codeList, preCode){
	var codeLst = [];
	for(i in codeList){
		if(codeList[i]['upCd'] == preCode){
			codeLst.push(codeList[i]);
		}
	}
	return codeLst;
}

/**
 * grid setSorting
 * */
function setSorting(gridId) {
	var data = $("#sortingFields").val();	
	if(!fnIsEmpty(data)) {
		$("#sortchk").val("-1");
		AUIGrid.setSorting(gridId, JSON.parse(data));
	}
}

var gridSort = function(event) {
	var dFd = event.sortingFields;
	if(!fnIsEmpty(dFd) && (dFd[0].dataField == 'RN'||dFd[0].dataField == 'CHK'||dFd[0].dataField == 'CONFM_HISTORY'||dFd[0].dataField == 'grdRn'||dFd[0].dataField.indexOf("TEMP")!=-1)) return;
	var sck = $("#sortchk").val();
	if(!fnIsEmpty(sck) && sck == -1) {
		$("#sortchk").val("");
	} else {	
		$("#sortingFields").val(JSON.stringify(event.sortingFields));
		if($.isFunction(fnSearch)) fnSearch();
	}
}