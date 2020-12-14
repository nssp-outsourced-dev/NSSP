	var Ajax = {};

	Ajax.getJson = function(iUrl, queryString, processAfterGet){
		$.ajax({
			url: iUrl,
			dataType: 'json',
			type: 'post',
			async: false,
			data: queryString,
			timeout: 3000,
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
							//alert("Error: reponse time over");
						}

					} else
					{
						if(Ajax.retrievefailError){
							alert(Ajax.retrievefailError);
						}else{
							alert("자료를 받아올 수 없습니다. 관리자에게 문의해주세요.");
							//alert("Error: retrieve data fail");
						}
						location.reload();
					}
				}
				catch (e) {
				}
			},
			success: function(data)
			{
				if(data != null && data.Error){
						alert(data.Error);
				}else{
					if(typeof processAfterGet === "function"){
						processAfterGet(data);
					}else{
						console.log("not callback!!");
					}
				}
			}
		});
	};

	Ajax.setAjaxForm = function(iUrl, frmName, processAfterGet){
        $("#"+frmName).ajaxForm({
            url : iUrl,
            enctype : "multipart/form-data",
            dataType : "json",
			timeout: 60000,
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
							//alert("Error: reponse time over");
						}

					} else
					{
						if(Ajax.retrievefailError){
							alert(Ajax.retrievefailError);
						}else{
							alert("자료를 받아올 수 없습니다. 관리자에게 문의해주세요.");
							//alert("Error: retrieve data fail");
						}
						location.reload();
					}
				}
				catch (e) {
				}
            },
			success: function(data)
			{
				if(data != null && data.Error){
						alert(data.Error);
				}else{
					if(typeof processAfterGet === "function"){
						processAfterGet(data);
					}else{
						console.log("not callback!!");
					}
				}
			}
		});
	};


	Ajax.getBioJson = function(iUrl, queryString, processAfterGet){
		$.ajax({
			url: iUrl,
			dataType: 'json',
			type: 'post',
			async: true,
			data: queryString,
			//timeout: 6000,   /*3초*/
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
							//alert("Error: reponse time over");
						}

					} else
					{
						if(Ajax.retrievefailError){
							alert(Ajax.retrievefailError);
						}else{
							alert("자료를 받아올 수 없습니다. 관리자에게 문의해주세요.");
							//alert("Error: retrieve data fail");
						}
						location.reload();
					}
				}
				catch (e) {
				}
			},
			success: function(data)
			{
				if(data != null && data.Error){
						alert(data.Error);
				}else{
					if(typeof processAfterGet === "function"){
						processAfterGet(data);
					}else{
						console.log("not callback!!");
					}
				}
			}
		});
	};

	Ajax.setErrorMessage = function (timeover, retrievefail){
		Ajax.timeoverError = timeover;
		Ajax.retrievefailError = retrievefail;
	};

	/*
	 * loading indicator show/hide
	 */
	function showLoading() {
		$.blockUI({
			overlayCSS:{
				backgroundColor:'#ffe',
				opacity: .5
			},
			css:{
				border:'none',
				opacity: .5,
				width:'80px',
				left:'45%'
			},
			message:"<img src='/images/loading_white.gif' width='80px'>"
		});
	}

	function hideLoading() {
		$.unblockUI();
	}


	function fnBrowser(){
	    var agent = navigator.userAgent.toLowerCase(),
	        name = navigator.appName,
	        browser;

	    // MS 계열 브라우저를 구분하기 위함.
	    if(name === 'Microsoft Internet Explorer' || agent.indexOf('trident') > -1 || agent.indexOf('edge/') > -1) {
	        browser = 'ie';
	        if(name === 'Microsoft Internet Explorer') { // IE old version (IE 10 or Lower)
	            agent = /msie ([0-9]{1,}[\.0-9]{0,})/.exec(agent);
	            browser += parseInt(agent[1]);
	        } else { // IE 11+
	            if(agent.indexOf('trident') > -1) { // IE 11
	                browser += 11;
	            } else if(agent.indexOf('edge/') > -1) { // Edge
	                browser = 'edge';
	            }
	        }
	    } else if(agent.indexOf('safari') > -1) { // Chrome or Safari
	        if(agent.indexOf('opr') > -1) { // Opera
	            browser = 'opera';
	        } else if(agent.indexOf('chrome') > -1) { // Chrome
	            browser = 'chrome';
	        } else { // Safari
	            browser = 'safari';
	        }
	    } else if(agent.indexOf('firefox') > -1) { // Firefox
	        browser = 'firefox';
	    }

	    return browser;
	}


	/*
	 * layer
	 */
	function layer_open(el){
		var temp = $('#' + el);
		var bg = temp.prev().hasClass('bg');	//dimmed 레이어를 감지하기 위한 boolean 변수

		if(bg){
			$('.layer').fadeIn();	//'bg' 클래스가 존재하면 레이어가 나타나고 배경은 dimmed 된다.
		}else{
			temp.parent().fadeIn()
		}

		// 화면의 중앙에 레이어를 띄운다.
		//if (temp.outerHeight() < $(document).height() ){
		//	temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
		//}else{
			temp.css('top', '100px');
		//}

		if (temp.outerWidth() < $(document).width() ){
			temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
		}else{
			temp.css('left', '0px');
		}

		temp.find('a.cbtn').click(function(e){
			if(bg){
				$('.layer').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다.
			}else{
				temp.parent().fadeOut()
			}
			e.preventDefault();
		});
	}

	function layer_close(el){
		var temp = $('#' + el);
		var bg = temp.prev().hasClass('bg');	//dimmed 레이어를 감지하기 위한 boolean 변수
		if(bg){
			$('.layer').fadeOut(); //'bg' 클래스가 존재하면 레이어를 사라지게 한다.
		}else{
			temp.parent().fadeOut()
		}
	}

	/*
	 * layer overlay
	 */
	function layerOver_open(el1, el2, ev){
		var divLayer = $('#' + el1);
		var temp = $('#' + el2);

		var sWidth = window.innerWidth;
		var sHeight = window.innerHeight;

		var oWidth = temp.width();
		var oHeight = temp.height();

		// 레이어가 나타날 위치를 셋팅한다.
		var divLeft = ev.clientX;
		var divTop = ev.clientY + 10;

		// 레이어가 화면 크기를 벗어나면 위치를 바꾸어 배치한다.
		if( divLeft + oWidth > sWidth ){
			divLeft -= oWidth + 80;
		}else{
			divLeft += 80;
		}
		//if( divTop + oHeight > sHeight ) divTop -= oHeight;

		//alert(sWidth+","+sHeight+"/"+oWidth+","+oHeight+"/"+ev.clientX+","+ev.clientY+"/"+divLeft+","+divTop);

		// 레이어 위치를 바꾸었더니 상단기준점(0,0) 밖으로 벗어난다면 상단기준점(0,0)에 배치하자.
		if( divLeft > 0 && divTop > 0 ){
			divLayer.css({
				"width": oWidth,
				"height": oHeight,
				"top": divTop,
				"left": divLeft,
				"position": "absolute"
			}).show();
		}

	};

	function layerOver_close(ev){
		$('.layerOver').hide();
		ev.preventDefault();
	};


	function fnToggleLayer(layer, img) {
		if($("#"+layer).css("display") == "none"){
			$("#"+layer).show();
			$("#"+img).attr("src","/css/images/minus.gif");
		}else{
			$("#"+layer).hide();
			$("#"+img).attr("src","/css/images/plus.gif");
		}
	}

	/**
	 * 한글기안기 팝업
	 * @param docId
	 * @param pblicteSn
	 * @param formatNm
	 * @param ifrId	- 한글문서 저장후 그리드에서 작성여부 refresh 처리시 사용
	 * 				  refresh 대상이 iframe이 아니고 funtion이용시 대상 funtion명을 파라미터로 넘긴다.
	 *                ex) "fnSearch()", 단, 'fn'이라는 prefix 필수
	 *
	 * @returns
	 */
	function fnHwpctrl (docId, pblicteSn, formatNm, ifrId, docType){
		//alert(docId +","+ pblicteSn +","+ formatNm)
		var strStatus = "width=1200,height=980,toolbar=no,status=no,location=no,scrollbars=yes,resizable=yes";
		window.open('/doc/hwpctrlPopup/?docId='+docId+'&pblicteSn='+pblicteSn+'&ifrId='+ifrId+'&docType='+docType , formatNm, strStatus);
	}

	function fnOpenWin(valUrl, popNm, valWd, valHt, valscoll){
		strStatus = "width="+valWd+",height="+valHt+",toolbar=no,status=no,scrollbars="+valscoll+",resizable=no";
		var debugWin = window.open(valUrl, popNm, strStatus);
		debugWin.focus;
	}

	function fnOpenWinPosition(valUrl, popNm, valWd, valHt, valscoll, posWd, posHt){
		strStatus = "width="+valWd+",height="+valHt+",top="+posWd+",left="+posHt+",toolbar=no,status=no,scrollbars="+valscoll+",resizable=no";
		var debugWin = window.open(valUrl, popNm, strStatus);
		debugWin.focus;
	}

	//작성문서 미리보기 OZ ver
	function fnReportView(docId, pblicteSn){

		alert("docId" + docId );
		alert("cubox.js fnReportView");
		var strStatus = "width=1000,height=1000,toolbar=no,status=no,location=no,scrollbars=yes,resizable=no";
		window.open('/doc/hwpctrlPopup/?docId='+docId+'&pblicteSn='+pblicteSn+'&ifrId='+ifrId , formatNm, strStatus);
		//window.open('/doc/reportViewPopup/?docId='+docId+'&pblicteSn='+pblicteSn, 'reportView', strStatus);
		/*
		reportViewPopup = dhtmlmodal.open('reportView', 'iframe', '/doc/reportViewPopup/?docId='+docId+'&pblicteSn='+pblicteSn, '문서출력', 'width=1000px,height=800px,center=1,resize=0,scrolling=1')
		reportViewPopup.onclose = function(){
			return true;
		}
		*/
	}

	function fnReportInput(docId, pblicteSn){
		var strStatus = "width=1000,height=1000,toolbar=no,status=no,location=no,scrollbars=yes,resizable=no";
		window.open('/doc/reportInputPopup/?docId='+docId+'&pblicteSn='+pblicteSn, 'reportInput', strStatus);

		/*
		reportViewPopup = dhtmlmodal.open('reportView', 'iframe', '/doc/reportInputPopup/?docId='+docId+'&pblicteSn='+pblicteSn, '문서작성', 'width=1000px,height=800px,center=1,resize=0,scrolling=1')
		reportViewPopup.onclose = function(){
			return true;
		}
		*/
	}

	//서식 미리보기
	function fnReportPreview(formatId){

		var strStatus = "width=1000,height=1000,toolbar=no,status=no,location=no,scrollbars=yes,resizable=no";
		window.open('/doc/hwpctrlPreviewPopup/?formatId='+formatId, 'reportPreview', strStatus);

		/*
		window.open('/doc/reportPreviewPopup/?formatId='+formatId, 'reportPreview', strStatus);
		reportPreviewPopup = dhtmlmodal.open('reportPreview', 'iframe', '/doc/reportPreviewPopup/?formatId='+formatId, '문서양식보기', 'width=1000px,height=800px,center=1,resize=0,scrolling=1')
		reportPreviewPopup.onclose = function(){
			return true;
		}
		*/
	}

	//작성문서 미리보기 OZ ver
	function fnReportViewIfr(ifrId, docId, pblicteSn){
		var strStatus = "width=1000,height=1000,toolbar=no,status=no,location=no,scrollbars=yes,resizable=no";
		window.open('/doc/reportViewPopup/?ifrId='+ifrId+'&docId='+docId+'&pblicteSn='+pblicteSn, 'reportView', strStatus);
	}

	function fnReportInputIfr(ifrId, docId, pblicteSn){
		var strStatus = "width=1000,height=1000,toolbar=no,status=no,location=no,scrollbars=yes,resizable=no";
		window.open('/doc/reportInputPopup/?ifrId='+ifrId+'&docId='+docId+'&pblicteSn='+pblicteSn, 'reportInput', strStatus);
	}

	function fnReportList(ifrId, docId, formatClCd, inputParam, fileId){
		var frm = document.createElement('form');

		var objs1 = document.createElement('input');
		objs1.setAttribute('type', 'hidden');
		objs1.setAttribute('name', 'docId');
		objs1.setAttribute('value', docId);
		frm.appendChild(objs1);

		var objs2 = document.createElement('input');
		objs2.setAttribute('type', 'hidden');
		objs2.setAttribute('name', 'formatClCd');
		objs2.setAttribute('value', formatClCd);
		frm.appendChild(objs2);

		var objs3 = document.createElement('input');
		objs3.setAttribute('type', 'hidden');
		objs3.setAttribute('name', 'inputParam');
		objs3.setAttribute('value', inputParam);
		frm.appendChild(objs3);

		var objs4 = document.createElement('input');
		objs4.setAttribute('type', 'hidden');
		objs4.setAttribute('name', 'ifrId');
		objs4.setAttribute('value', ifrId);
		frm.appendChild(objs4);

		var objs5 = document.createElement('input');
		objs5.setAttribute('type', 'hidden');
		objs5.setAttribute('name', 'fileId');
		objs5.setAttribute('value', fileId);
		frm.appendChild(objs5);

		frm.setAttribute('method', 'post');
		frm.setAttribute('action', "/doc/reportListOwnerIframe/");
		frm.setAttribute('target', ifrId);
		document.body.appendChild(frm);
		frm.submit();
	}

	function fnReportListView(ifrId, docId){
		var frm = document.createElement('form');

		var objs1 = document.createElement('input');
		objs1.setAttribute('type', 'hidden');
		objs1.setAttribute('name', 'docId');
		objs1.setAttribute('value', docId);
		frm.appendChild(objs1);

		var objs2 = document.createElement('input');
		objs2.setAttribute('type', 'hidden');
		objs2.setAttribute('name', 'ifrId');
		objs2.setAttribute('value', ifrId);
		frm.appendChild(objs2);

		frm.setAttribute('method', 'post');
		frm.setAttribute('action', "/doc/reportListIframe/");
		frm.setAttribute('target', ifrId);
		document.body.appendChild(frm);
		frm.submit();
	}

	/**
	 * 숫자 자릿수 맞춤
	 * @param str
	 * @param len
	 * @returns
	 */
	function fnLpad(str, len){
	    str = str + "";
	    while(str.length < len){
	        str = "0"+str;
	    }
	    return str;
	}

	/**
	 * @설명 : 입력값이 Null이거나 빈값인지 체크한다.
	 */
	function fnIsEmpty(inVal) {
		if (new String(inVal).valueOf() == "undefined")
			return true;
		if (inVal == null)
			return true;
		if (inVal == 'null')
			return true;

		var v_ChkStr = new String(inVal);

		if (v_ChkStr == null)
			return true;
		if (v_ChkStr.toString().length == 0)
			return true;
		return false;
	}

	function fnCalendarPopup(ctl, sDate, eDate) {
		var id = $("#"+ctl).attr('id');

		$("#" + id).datepicker({
			dateFormat : 'yy-mm-dd',
			monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
			monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
			dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
			dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
			dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
			changeYear : false,
			changeMonth : false,
			showOtherMonths : true,
			selectOtherMonths : false,
			showOn : 'none'
		});

		if(sDate != "") $("#" + id).datepicker("option", "minDate", sDate);
		if(eDate != "") $("#" + id).datepicker("option", "maxDate", eDate);

		$("#" + id).datepicker('show');
	}


	function fnCalendarReset(ctl) {
		var id = $("#"+ctl).attr('id');
		$("#" + id).val("");
	}

	/**
	 * 주민번호 검증
	 */
	function fnRrnCheck(value) {
		var str = /^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}$/;
		if(!str.test(value)) {
			alert("주민번호 형식이 올바르지 않습니다.");
			return false;
		}
		return true;
	}

	/**
	 * 숫자형식 검증
	 */
	function fnNumberCheck(event){
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 || keyID == 110 || keyID == 190)
			return;
		else
			return false;
	}

	/**
	 * 숫자외에 삭제
	 */
	function fnRemoveChar(event) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 )
			return;
		else
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
	}

	/**
	 * url 형식 체크
	 */
	function fnValidateUrl(strUrl) {
	    //var expUrl = /^(http\:\/\/)?((\w+)[.])+(asia|biz|cc|cn|com|de|eu|in|info|jobs|jp|kr|mobi|mx|name|net|nz|org|travel|tv|tw|uk|us)(\/(\w*))*$/i;
	    var expUrl = /^(https?:\/\/)/;
	    return expUrl.test(strUrl);
	}

	function fnNullCheck(arguments){
	    if ( arguments != "" || arguments != null || arguments != "undefined" || arguments != undefined){
	    	return arguments;
	    }else{
	    	return "";
	    }
	}

	/**
	 * 날짜 형식 체크
	 */
	function fnCheckDate(obj) {
		if(fnIsEmpty(obj.val())) {
			var chk = obj.attr("check");
			if(chk == "text") {
				alert(obj.attr("checkName")+"은(는) 필수입력 항목입니다.");
				return false;
			} else {
				return true;
			}
		}
		// 19xx~ 20xx 년만 가능
		var isDate = /^(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/.test(obj.val().replace(/-/g,""));
		// 2월
		var twoMonth = /^\d{4}(02)\d{1,2}$/.test(obj.val().replace(/-/g,""));
		// 말일
		var twoMLastday = /^\d{4}(02)(0[1-9]|[12][0-9])$/.test(obj.val().replace(/-/g,""));

		if(obj.val() != "" && !isDate) {
			obj.focus();
			obj.select();
			alert(obj.attr("checkName")+"가(이) 날짜 형식이 아닙니다.");
			return false;
		}
		else if(obj.val() != "" && isDate) { // idDate True
			if(twoMonth) { // 그 중 2월이면
				if(!twoMLastday) { // 말일만 한번 더 점검
					obj.focus();
					obj.select();
					alert(obj.attr("checkName")+"가(이) 날짜 형식이 아닙니다.");
					obj.focus();
					return false;
				}
			}
		}
		return true;
	}

	/**
	 * 검색 시작일, 종료일 비교
	 * @param objFrom
	 * @param objTo
	 * @returns {Boolean}
	 */
	function fnCompareDate(objFrom, objTo) {
		if(fnIsEmpty($(objFrom).val()) && fnIsEmpty($(objTo).val())) {
			return true;
		}
		if(fnIsEmpty($(objFrom).val())) {
			alert($(objFrom).attr("checkName") + " 시작일을 입력하세요.");
			return false;
		}
		if(!fnIsEmpty($(objTo).val())) {
			if($(objFrom).val().replace(/\-/g,'') > $(objTo).val().replace(/\-/g,'')) {
				alert($(objFrom).attr("checkName") + " 시작일이 종료일보다 큽니다.")
				return false;
			}
		}
		return true;
	}

	function fnUpCdList(sCd, sObj){
		var iUrl = "/cd/cdListAjax/";
 		var queryString =  "txtUpCd=" + sCd;
 		var processAfterGet = function(data) {
			sObj.html("<option value=''>==선택하세요==</option>");
			if(data.length > 0){
				for(var i = 0; i < data.length; i++){
					sObj.append('<option value="' + data[i].cd + '"> ' + data[i].cdNm + '</option>');
				}
			}
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function fnUpDeptList(sCd, sObj){
		var iUrl = "/dept/deptListAjax/";
 		var queryString =  "txtUpCd=" + sCd;
 		var processAfterGet = function(data) {
			sObj.html("<option value=''>==선택하세요==</option>");
			if(data.length > 0){
				for(var i = 0; i < data.length; i++){
					sObj.append('<option value="' + data[i].cd + '"> ' + data[i].cdNm + '</option>');
				}
			}
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	function exportExcel(formId, ifmId, url) {
		var objForm = document.getElementById(formId);
		var objIfm = document.getElementById(ifmId);
		var defaultTarget = fnIsEmpty(objForm.getAttribute("target"))?'':objForm.getAttribute("target").replace(/^\s+|\s+$/gm,'');

		objForm.target = objIfm.getAttribute("name");
		objForm.action = url;
		objForm.method = "post";
		objForm.submit();

		var strTarget = "_self";
		if(!fnIsEmpty(defaultTarget))
			strTarget = defaultTarget;
		objForm.target = strTarget;

		fnExcelLoading(objIfm, objForm, defaultTarget);
	}

	function fnExcelLoading(objIfm, objForm,defaultTarget) {
		var ObjDiv = document.createElement("div");
		ObjDiv.setAttribute('id', 'ifmExcelLoding');
		ObjDiv.style.width = '100%';
		ObjDiv.style.height = '100%';  /*document.body.clientHeight*/
		ObjDiv.style.position = "absolute";
		ObjDiv.style.left = 0;
		ObjDiv.style.top = 0;
		ObjDiv.style.background = "url('/images/loading_white.gif') center center";
		ObjDiv.style.backgroundRepeat = "no-repeat";
		document.body.appendChild(ObjDiv);

		fnReady(objIfm, objForm, defaultTarget);
	}

	function fnReady(objIfm, objForm, defaultTarget) {
		var obj = objIfm.contentWindow.document;
		var divObj = document.getElementById("ifmExcelLoding");
		if(!fnIsEmpty(obj)) {
			if(obj.readyState == "complete") {
				if(typeof divObj == "object")
					document.body.removeChild(divObj);
			} else {
				obj.onreadystatechange = function() {
					if(obj.readyState == "interactive" || obj.readyState == "complete") {
						if(typeof divObj == "object") {
							document.body.removeChild(divObj);
							obj.onreadystatechange = null;
						}
					}
				};
			}
		} else
			if(typeof divObj == "object")
				document.body.removeChild(divObj);
	}

	function fnFormValueCheck(form){
		var formObj = $("form[id="+form+"]");
		var checkObj = formObj.find("[check]");
		for(var i=0;i<checkObj.length;i++){
			var sObj = checkObj.eq(i);
			var sType = sObj.attr("check");
			var sId = sObj.attr("id");
			var sName = sObj.attr("name");
			if(sType=="text"){
				if(fnIsEmpty(checkObj.eq(i).val())){
					alert(""+checkObj.eq(i).attr("checkName")+" 은(는) 필수입력 항목입니다.");
					checkObj.eq(i).focus();
					return false;
				}
			}else if(sType=="radio"){
				if(!$('input:radio[name='+sName+']').is(':checked')){
				//if(!checkObj.eq(i).is(':checked')){
					alert(""+checkObj.eq(i).attr("checkName")+" 은(는) 필수입력 항목입니다.");
					checkObj.eq(i).focus();
					return false;
				}
			}
		}
		return true;
	}

	//textarea id, 제한 글자 수, 입력 결과 메세지 저장 ID
	function fnLimitString(textid, limit, limitid){
		var text = $('#'+textid).val();
		var textlength = text.length;
		if(textlength > limit){
	        $('#' + limitid).html(''+limit+'자 이상 입력할 수 없습니다.');
	        $('#'+textid).val(text.substr(0,limit));
	        return false;
		}else{
			$('#' + limitid).html('(' + textlength + "/" + limit +')');
			return true;
		}
	}

	function fnImageList(file_id){
		fnOpenWin("/file/imageListPopup/?file_id="+file_id, "ImageList", "1200", "750", "yes");
	}

	//만나이 계산
	function calcAge(birth) {

	    var date = new Date();
	    var year = date.getFullYear();
	    var month = (date.getMonth() + 1);
	    var day = date.getDate();

	    if (month < 10) month = '0' + month;
	    if (day < 10) day = '0' + day;

	    var monthDay = month + day;

	    birth = birth.replace('-', '').replace('-', '');

	    var birthdayy = birth.substr(0, 4);
	    var birthdaymd = birth.substr(4, 4);
	    var age = monthDay < birthdaymd ? year - birthdayy - 1 : year - birthdayy;

	    return age;
	}

	/**
	 * @설명 : 달력표현
	 * @파라미터 : id = input box id
	 */
	function fnDatePicker(id) {
		$("#" + id).datepicker(
				{
					dateFormat : 'yy-mm-dd',
					monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월',
							'8월', '9월', '10월', '11월', '12월' ],
					dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
					changeYear : true,
					changeMonth : true

				});
		//$("#" + id).prop("readOnly", true);
	}

	/**
	 * @설명 : 달력표현(이미지포함)
	 * @파라미터 : id = input box id
	 */
	function fnDatePickerImg(id, date, dafalutDate) {
		if (!fnIsEmpty(date)) {
			$("#" + id).val(date);
		} else if (dafalutDate) {
			$("#" + id).val(fnGetToday(0, 0));
		} else if (!dafalutDate) {
			$("#" + id).val("");
		}
		$("#" + id).datepicker(
				{
					dateFormat : 'yy-mm-dd',
					monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월',
							'9월', '10월', '11월', '12월' ],
					monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월',
							'8월', '9월', '10월', '11월', '12월' ],
					dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
					changeYear : true,
					changeMonth : true,
					showOn : 'both', /*button*/
					buttonImageOnly : false,
					//selectOtherMonths : true,
					buttonImage : "/img/search_calendar.png",
					beforeShow: function() {
				        setTimeout(function(){
				            $('.ui-datepicker').css('z-index', 99999999999999);
				        }, 0);
				    }
				});
		//$("#" + id).prop("readOnly", true);
		//$(".ui-datepicker-trigger").attr("style", "position:absolute; right:1px; top:2px; line-height:24px; width:25px; height:25px; border: 0px; background-color: rgba(255, 255, 255, 0);");
	}

	/**
	 * @설명 : 오늘날짜(달력)
	 */
	// mode = 0 , dayMode = 0 OR 14
	function fnGetToday(mode, dayMode) {
		var d = new Date();
		var year = d.getFullYear();
		var month;
		if (mode == 0) {
			month = (d.getMonth() + 1).toString();
		} else {
			month = d.getMonth() + 1 - mode;

			if (month > 12) {
				month = month - 12;
				year = (year + 1).toString();
			}

			if (month <= 0) {
				month = 12 + month;
				year = (year - 1).toString();
			}

			month = month.toString();
		}
		// day 계산
		var date = d.getDate();

		if (dayMode != '0') {
			var day_last = new Date();
			var day = new Date();

			day_last.setDate(day.getDate() + dayMode);

			month = (day_last.getMonth() + 1).toString();
			date = (day_last.getDate()).toString();
		} else {
			date = d.getDate().toString();
		}
		if (date.length == 1) {
			date = '0' + date;
		}
		if (month.length == 1) {
			month = '0' + month;
		}
		return year + '-' + month + '-' + date;
	}


	function fnRealDatePicker(txtId, divId) {
		$("#" + txtId).click(function(){
			$("#" + divId).toggle();
		});

		var nowDate = new Date();
		var txtDateArr = $("#" + txtId).val().split("-");
		if(txtDateArr.length == 3){
			nowDate = new Date(txtDateArr[0], txtDateArr[1]-1, txtDateArr[2]);
		}

        $("#" + divId).datetimepicker({
            date: nowDate,
            viewMode: 'YMD',
			onOk: function() {
                $("#" + txtId).val(this.getText('YYYY-MM-DD'));
                $("#" + divId).toggle();
			},
            onClear: function() {
                $("#" + txtId).val("");
                $("#" + divId).toggle();
            }
        });
        /*
        var inputDate = $("#" + txtId).focus(function() {
            $('.dropdown', "#" + divId).remove();
            var divDropDown = $('<div class="dropdown"/>').appendTo("#" + divId);
            setTimeout(function(){
                divDropDown.datetimepicker({
                    date: inputDate.data('value') || new Date(),
                    viewMode: 'YMD',
	    			onOk: function() {
                        inputDate.val(this.getText('YYYY-MM-DD'));
                        inputDate.data('value', this.getValue());
                        divDropDown.remove();
	    			},
	                onClear: function() {
                        inputDate.val("");
                        divDropDown.remove();
	                }
                })
            }, 100);
        });
        */
	}


	function fnRealDateTimePicker(txtId, divId) {
		$("#" + txtId).click(function(){
			$("#" + divId).toggle();
		});

		var nowDate = new Date();
		if($("#" + txtId).val().length == 19){
			var txtDateTimeArr = $("#" + txtId).val().split(" ");
			var txtDateArr = txtDateTimeArr[0].split("-");
			var txtTimeArr = txtDateTimeArr[1].split(":");
			nowDate = new Date(txtDateArr[0], txtDateArr[1]-1, txtDateArr[2], txtTimeArr[0], txtTimeArr[1], txtTimeArr[2]);
		}

        $("#" + divId).datetimepicker({
            date: nowDate,
			firstDayOfWeek: 1,
			viewMode: 'YMDHMS',
			onOk: function() {
                //$("#" + txtId).val(this.getText('YYYY-MM-DD hh:mm:ss'));
                $("#" + txtId).val(this.getText().replace(/\//gi,"-"));
                $("#" + divId).toggle();
			},
            onClear: function() {
                $("#" + txtId).val("");
                $("#" + divId).toggle();
            }
        });

        /*
        var inputDateTime = $("#" + txtId).focus(function() {
            $('.dropdown', "#" + divId).remove();
            var divDropDown = $('<div class="dropdown"/>').appendTo("#" + divId);
            setTimeout(function(){
                divDropDown.datetimepicker({
                    date: inputDateTime.data('value') || new Date(),
        			firstDayOfWeek: 1,
        			viewMode: 'YMDHMS',
	    			onOk: function() {
                        inputDateTime.val(this.getText('YYYY-MM-DD hh:mm:ss'));
                        inputDateTime.data('value', this.getValue());
                        divDropDown.remove();
	    			},
	                onClear: function() {
                        inputDateTime.val("");
                        divDropDown.remove();
	                }
                })
            }, 100);
        });*/

	}

	/**
	 * serializeFormJSON : 폼을 json Object로 변환한다.
	 */
	$.fn.serializeFormJSON = function () {

	    var o = {};
	    var a = this.serializeArray();
	    $.each(a, function () {
	    	if (o[this.name]) {
	            if (!o[this.name].push) {
	                o[this.name] = [o[this.name]];
	            }
	            o[this.name].push(this.value || '');
	        } else {
	            o[this.name] = this.value || '';
	        }
	    });
	    return o;
	};

	/**
	 * clearForm : 폼을 reset 한다.
	 */
	$.fn.clearForm = function(pArr) {
		return this.each(function() {
			var type = this.type, tag = this.tagName.toLowerCase(), sName = this.name;
			if (tag === "form") {
				return $(":input", this).clearForm(pArr)
			}
			if( $.inArray( sName, pArr ) == -1 ) {
				if (type === "text" || type === "password" || type === "hidden"
						|| tag === "textarea") {
					this.value = ""
				} else if (type === "checkbox" || type === "radio") {
					this.checked = false
				} else if (tag === "select") {
					this.selectedIndex = -1
				}
			}
		})
	}

	$.fn.resetForm = function() {
		$(this).find("input[type=hidden]").val("");
		return this.each(function() {
			this.reset();
		});
	}

	/*시,분 체크*/
	function fnHHMMChk (event, type) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) return;
		else {
			var tVal = event.target.value;
			if(tVal.length > 1) {
				if(type == 'HH') {
					var regx = /^(2[0-3]|[01][0-9])$/g;
				} else {
					var regx = /^([0-5][0-9])$/g;
				}
				if(!regx.test(tVal)) {
					event.target.value = "";
				}
			} else if (tVal.length < 2) {
				if(type == 'HH') {
					event.target.value = event.target.value.replace(/[^0-2]/g, "");
				} else {
					event.target.value = event.target.value.replace(/[^0-5]/g, "");
				}
			}
		}
	}

	function fnCdSelect(code){
		cdSelectPopup = dhtmlmodal.open('cdSelect', 'iframe', '/cd/selectPopup/?mode=M&hidUpCd='+code, '코드검색', 'width=600px,height=560px,center=1,resize=0,scrolling=1')
		cdSelectPopup.onclose = function(){
			var iframedoc = this.contentDoc;
			var upCd = iframedoc.getElementById("txtUpCd").value;
			var cd = iframedoc.getElementById("txtCd").value;
			var cdNm = iframedoc.getElementById("txtCdNm").value;
			fnSelectCd(upCd, cd, cdNm);
			return true;
		}
	}

	function fnCdSelectSingle(code){
		cdSelectPopup = dhtmlmodal.open('cdSelect', 'iframe', '/cd/selectPopup/?mode=S&hidUpCd='+code, '코드검색', 'width=600px,height=560px,center=1,resize=0,scrolling=1')
		cdSelectPopup.onclose = function(){
			var iframedoc = this.contentDoc;
			var upCd = iframedoc.getElementById("txtUpCd").value;
			var cd = iframedoc.getElementById("txtCd").value;
			var cdNm = iframedoc.getElementById("txtCdNm").value;
			fnSelectCd(upCd, cd, cdNm);
			return true;
		}
	}

	function fnDeptSelect(){
		deptSelectPopup = dhtmlmodal.open('deptSelect', 'iframe', '/dept/selectPopup/', '부서검색', 'width=450px,height=500px,center=1,resize=0,scrolling=1')
		deptSelectPopup.onclose = function(){
			var iframedoc = this.contentDoc;
			var upCd = iframedoc.getElementById("txtDeptUpperCd").value;
			var cd = iframedoc.getElementById("txtCd").value;
			var cdNm = iframedoc.getElementById("txtCdNm").value;
			fnSelectDept(upCd, cd, cdNm);
			return true;
		}
	}

	function fnVioltSelect(){
		violtSelectPopup = dhtmlmodal.open('violtSelect', 'iframe', '/violt/selectPopup/', '위반죄명검색', 'width=1100px,height=700px,center=1,resize=0,scrolling=1')
		violtSelectPopup.onclose = function(){
			var iframedoc = this.contentDoc;
			var upCd = iframedoc.getElementById("txtVioltUpperCd").value;
			var cd = iframedoc.getElementById("txtCd").value;
			var cdNm = iframedoc.getElementById("txtCdNm").value;
			fnSelectViolt(upCd, cd, cdNm);
			return true;
		}
	}


	function fnExmnSelect(){
		exmnSelectPopup = dhtmlmodal.open('exmnSelect', 'iframe', '/exmn/selectPopup/', '검찰검색', 'width=450px,height=500px,center=1,resize=0,scrolling=1')
		exmnSelectPopup.onclose = function(){
			var iframedoc = this.contentDoc;
			var upCd = iframedoc.getElementById("txtExmnUpperCd").value;
			var cd = iframedoc.getElementById("txtCd").value;
			var cdNm = iframedoc.getElementById("txtCdNm").value;
			fnSelectExmn(upCd, cd, cdNm);
			return true;
		}
	}

	function fnPolcSelect(){
		polcSelectPopup = dhtmlmodal.open('polcSelect', 'iframe', '/polc/selectPopup/', '경찰검색', 'width=450px,height=500px,center=1,resize=0,scrolling=1')
		polcSelectPopup.onclose = function(){
			var iframedoc = this.contentDoc;
			var upCd = iframedoc.getElementById("txtPolcUpperCd").value;
			var cd = iframedoc.getElementById("txtCd").value;
			var cdNm = iframedoc.getElementById("txtCdNm").value;
			fnSelectPolc(upCd, cd, cdNm);
			return true;
		}
	}

	function fnAlotSelect(snNo, gbn, ret){
		//gbn R(접수), I(입건)
		//ret N(바로저장), Y(리턴값)
		var vTitle = "";
		if(gbn == "R"){
			vTitle = "접수사건 배당";
		}else if(gbn == "I"){
			vTitle = "정식사건 배당";
		}else{
			return;
		}
		alotSelectPopup = dhtmlmodal.open('alotSelect', 'iframe', '/alot/alotPopup/?snNo='+snNo+"&gbn="+gbn+"&ret="+ret, vTitle, 'width=600px,height=680px,center=1,resize=0,scrolling=1')
		alotSelectPopup.onclose = function(){

			//if(ret == "Y"){
				var iframedoc = this.contentDoc;
				var snNo = iframedoc.getElementById("snNo").value;
				var userId = iframedoc.getElementById("hidUserId").value;
				var deptCd = iframedoc.getElementById("hidDeptCd").value;
				var userNm = iframedoc.getElementById("hidUserNm").value;
				var deptNm = iframedoc.getElementById("hidDeptNm").value;
				var alotSeCds = iframedoc.getElementsByName("chkAlotSeCd");
				var alotSeCd = "";
				for(var i = 0; i < alotSeCds.length; i++){
				    if(alotSeCds[i].checked){
				    	alotSeCd = alotSeCds[i].value;
				    }
				}
				fnSelectAlot(snNo, userId, userNm, deptCd, deptNm, alotSeCd);
			//}
			return true;
		}
	}

	function fnAlotHistory(rcNo){
		alotHistoryPopup = dhtmlmodal.open('alotHistory', 'iframe', '/alot/historyPopup/?rcNo='+ rcNo, '배당이력', 'width=700px,height=430px,center=1,resize=0,scrolling=1')
		alotHistoryPopup.onclose = function(){
			return true;
		}
	}

	function fnDocListPopup(cate, sanctnId){
		comDocListPopup = dhtmlmodal.open('comDocListPopup', 'iframe', '/sanctn/itivOutsetDetailPopup/?cate='+cate+'&sanctnId='+sanctnId, '승인요청 상세내역', 'width=800px,height=450px,center=1,resize=0,scrolling=1')
		comDocListPopup.onclose = function(){
			return true;
		}
	}

	// 승인관리 (송치승인은 해당 화면에서 따로 처리)
	function fnConfmSanctn(cate, sttusCd){

		// 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
		var chkItems = AUIGrid.getItemsByValue("#grid_list", "CHK", "Y");
		//var chkItems = AUIGrid.getCheckedRowItems("#grid_list");//showRowCheckColumn

		if(chkItems.length < 1){
			alert("한 개 이상의 승인건을 선택해야 합니다.");
			return;
		}

		var ids = [];
		
		var cnt01386=0;
		for( var i = 0 ; i < chkItems.length ; i++ ){
			if( chkItems[i].STTUS_CD != "00022" ){
				alert("승인대기 자료만 승인/반려 가능합니다.");
				return;
			}
			if( chkItems[i].CONFM_JOB_SE_CD == "01386" && chkItems[i].PROGRS_STTUS_CD == "02103" ){
				cnt01386++;
			}
			ids.push(chkItems[i].SANCTN_ID); // 아이디만 따로 보관해서 alert 출력
		}
		
		if( chkItems.length > 1 ){
			if( chkItems.length != cnt01386 && cnt01386 > 0 ){
				alert("입건 승인은 동일한 요청 구분에 대해 승인이 가능합니다.\n동일한(입건/내사착수) 요청구분을 선택 후 승인을 진행해주세요.");
				return;
			}
		}
		
		var str = ids.join("X");
		var title ="승인/반려";

		if( cnt01386 > 0 ){
			title ="승인";
		}
		
		sanctnConfmPopup = dhtmlmodal.open('sanctnConfm', 'iframe', '/sanctn/confmPopup/?cate='+cate+'&sttusCd='+ sttusCd +'&chkId='+str+'&cnt='+cnt01386, title, 'width=800px,height=300px,center=1,resize=0,scrolling=1')
		sanctnConfmPopup.onclose = function(){
			fnSearch();
			return true;
		}
	}

	function fnSanctnHistory(sanctnId){
		sanctnHistoryPopup = dhtmlmodal.open('sanctnHistory', 'iframe', '/sanctn/historyPopup/?hidSanctnId='+ sanctnId, '승인이력', 'width=1000px,height=430px,center=1,resize=0,scrolling=1')
		sanctnHistoryPopup.onclose = function(){
			return true;
		}
	}

	function fnZipPop (txtId) {
		var frm = $('<form></form>');
		var objs1 = $('<input type="hidden" name="paramTxtId" value="'+txtId+'">');
		frm.append(objs1);
		fnOpenWin("about:blank", "jusoPop","570","530","no");
		frm.attr({"method":"post","action":"/juso/jusoPopup/","target":"jusoPop"});
		frm.appendTo('body');
		frm.submit();
	}

	function btnUserPop (txtId) {
		userSelectPopup = dhtmlmodal.open('userSelect', 'iframe', '/member/selectPopup/?pId='+txtId, '사용자검색', 'width=850px,height=560px,center=1,resize=0,scrolling=0')
		userSelectPopup.onclose = function() {
			var iframedoc = this.contentDoc;
			var userId = iframedoc.getElementById("hidEsntlId").value;
			var userNm = iframedoc.getElementById("hidUserNm").value;
			var userDeptNm = iframedoc.getElementById("hidDeptNm").value;//소속
			var userClsfNm = iframedoc.getElementById("hidClsfNm").value;//계급
			var userResdncAddr = iframedoc.getElementById("hidResdncAddr").value;//주거지
			var pId    = iframedoc.getElementById("hidParamId").value;
			fnSelectUser(userId, userNm, userDeptNm, userClsfNm, userResdncAddr, pId);
			return true;
		}
	}

	function btnDocFilePop (pDocNo, pFileId, pFormatId) {
		if(fnIsEmpty(pFileId)) {
			alert("파일을 생성하기 위한 정보가 부족합니다.\n\n다시 조회한 후 시도해 주세요.");
			return;
		}
		docFileCmmPopup = dhtmlmodal.open('docFile', 'iframe', encodeURI('/doc/docFilePopup/?pDocNo='+pDocNo+'&pFileId='+pFileId+'&pFormatId='+pFormatId), '작성문서 파일목록', 'width=800px,height=450px,center=1,resize=0,scrolling=1');
		return docFileCmmPopup;
	}

	function fnChangePw(){
		changePwPopup = dhtmlmodal.open('changePw', 'iframe', '/member/changePwPopup/', '비밀번호 변경', 'width=800px,height=250px,center=1,resize=0,scrolling=1')
		changePwPopup.onclose = function() {
			return true;
		}
	}



	function fnUserPwKeyup(pwdInput, pwdText, pwdFlag){
    	var pwd = $('#'+pwdInput).val();
	    if(!/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,16}$/.test(pwd)){
            $('#'+pwdText).html("<font color=red size='2'>숫자+영문자+특수문자 조합으로 8~16자리로 설정하세요.</font>");
    		$('#'+pwdFlag).val("1");
	    }else if(/(\w)\1\1\1/.test(pwd)){
            $('#'+pwdText).html("<font color=red size='2'>같은 문자를 4번 이상 사용하실 수 없습니다.</font>");
    		$('#'+pwdFlag).val("1");
	    }else{
            $('#'+pwdText).html("<font color=green size='2'>사용가능합니다.</font>");
    		$('#'+pwdFlag).val("0");
	    }
	}

	function fnUserRePwKeyup(pwdInput, repwdInput, pwdText, pwdFlag){
    	var pwd = $('#'+pwdInput).val();
    	var repwd = $('#'+repwdInput).val();
        if (pwd != repwd) {
            $('#'+pwdText).html("<font color=red size='2'>비밀번호가 일치하지 않습니다.</font>");
    		$('#'+pwdFlag).val("1");
        }else {
            $('#'+pwdText).html("<font color=green size='2'>사용가능합니다.</font>"); // 클리어
    		$('#'+pwdFlag).val("0");
        }
	}

	function fnUserList(deptCode, sObj){
		var iUrl = "/member/userListComboAjax/";
 		var queryString =  "dept_cd=" + deptCode;
 		var processAfterGet = function(data) {
			sObj.html("<option value=''>==선택하세요==</option>");
			if(data.length > 0){
				for(var i = 0; i < data.length; i++){
					sObj.append('<option value="' + data[i].ESNTL_ID + '"> ' + data[i].USER_NM + '</option>');
				}
			}
	    };
		Ajax.getJson(iUrl, queryString, processAfterGet);
	}

	//사건 상세 팝업 parameter( 접수번호, 사건번호-사건번호는 있을경우만 )
	function fnCaseDetailPopup( rcNo, caseNo ) {
		var caseDetailPopup = dhtmlmodal.open('caseDetailPopup', 'iframe', '/ccc/caseDetailPopup/?rcNo='+rcNo+'&caseNo='+caseNo, '사건상세', 'width=1150px,height=660px,center=1,resize=0,scrolling=0')
	}
	//main화면 사건담당자 조회
	function fnCaseInfoPopup( searchType, searchText ) {
		var caseInfoPopup = dhtmlmodal.open('caseInfoPopup', 'iframe', '/ccc/caseInfoPopup/?hidSearchType='+searchType+'&hidSearchText='+encodeURIComponent(searchText), '사건정보', 'width=1100px,height=450px,center=1,resize=0,scrolling=0')
	}

	function fnChangeNo (noValue) {
		if(!fnIsEmpty(noValue)) {
			var noArr = noValue.split("-");
			if(!fnIsEmpty(noArr) && noArr.length == 2) {
				return noArr[0] + "-" + parseInt(noArr[1]);
			} else {
				return noValue;
			}
		} else {
			return "";
		}
	}

	//한글 서식 저장 
	//boolean autoSave : 자동 저장 여부 [자동:true 수동저장 : false]  
	function fnSaveHwp (res, autoSave ) {
		if(!fnIsEmpty(res.result) && res.result) {
			res.prDocId = $("#prDocId").val();
			res.prPblicteSn = $("#prPblicteSn").val();
			res.prFilePath = res.downloadUrl;
			res.prFileNm = res.fileName;
			res.prFileMg = res.size
			//save
			var processAfterHwp = function(data) {
				if( data.rst > 0){
					if( !autoSave ){
						alert("저장되었습니다.");
					}
				}
			}
			Ajax.getJson("/doc/saveHwpctrlAjax/", res, processAfterHwp);
		}
	}

	$(function() {

		//한글만 입력 가능
		$(".onlyHangul").keyup(function(event){
			if (!(event.keyCode >=37 && event.keyCode<=40)) {
				var inputVal = $(this).val();
				$(this).val(inputVal.replace(/[a-z0-9]/gi,''));
			}
		});

		//영문&숫자만 입력 가능
		$(".notHangul").keyup(function(event){
			if (!(event.keyCode >=37 && event.keyCode<=40)) {
			var inputVal = $(this).val();
			$(this).val(inputVal.replace(/[^a-z0-9]/gi,''));
			}
		});

		//영어만 입력가능
		$(".onlyAlphabet").keyup(function(event){
			if (!(event.keyCode >=37 && event.keyCode<=40)) {
				var inputVal = $(this).val();
				$(this).val(inputVal.replace(/[^a-z]/gi,''));
			}
		});

		//숫자만 입력가능
		$(".onlyNumber").keyup(function(event){
			if (!(event.keyCode >=37 && event.keyCode<=40)) {
				var inputVal = $(this).val();
				$(this).val(inputVal.replace(/[^0-9]/gi,''));
			}
		});

	});

	function fnChkAgentIE () {
		var agent = navigator.userAgent.toLowerCase();
		if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
			return "IE";
		} else {
			return "ELSE";
		}
	}

	/* ContextPath 불러오는 JS c:url 대신 사용가능 */
	function getContextPath(){
		var hostIndex = location.href.indexOf(location.host) + location.host.length
		//return location.href.substring( hostIndex, location.href.indexOf('/',hostIndex + 1) );
		return "";
	};

