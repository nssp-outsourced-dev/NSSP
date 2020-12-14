CertWindow =function (selectCertIdx) {
	var sIndex = selectCertIdx;
	if(sIndex === null || sIndex === ""){
		alert(ErrorMessage.code30020);
		return;
	}
	loadJavascript(gpkiScriptBase + "/ui/common.js",errorWin);
	//loadJavascript(gpkiScriptBase + "/ui/certviewR",errorWin,"ko-KR.js");
	function loadJavascript(URL,callback,langSt) { 
		
	    var xmlhttp = null; 
	    if(window.XMLHttpRequest) { 
	        xmlhttp = new XMLHttpRequest(); 
	    } else { 
	        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
	    } 

		if(langSt==null||typeof(langSt)=='undefined'){
			xmlhttp.open('GET', URL,false);
		}
	    else{
	    	xmlhttp.open('GET', URL+"_"+langSt,false);  
	    }

	    xmlhttp.onreadystatechange = function() { 

	        if(xmlhttp.readyState==4 && xmlhttp.status == 200 && xmlhttp.statusText=='OK') { 
	            responseText = xmlhttp.responseText;
	            
	        } 
	    } 
	    xmlhttp.send('');
	    
	    if(xmlhttp.readyState==4 && xmlhttp.status == 200 && xmlhttp.statusText=='OK') { 
            responseText = xmlhttp.responseText;
        }
	    return eval(responseText);

	}
	function errorWin(){}

	var windowRoot;
	
	var obj = JSON.parse(GPKISecureWeb.GetCertNormalInfo(sIndex));
	var strCertInfo = obj.ResultMessage;
	var arrCertInfo = strCertInfo.split('\$');
	
	var strCertDetailFields = new Array();
	var strCertDetailValues = new Array();
	
	var detailFields = [2,3,4,10,20,21,8,5,24,25,13,16,23,15,26];
	var fobj;
	var vobj;
	for(var i=0; i<detailFields.length;i++){
		fobj = JSON.parse(GPKISecureWeb.GetCertDetailField(sIndex,detailFields[i]));
		strCertDetailFields[i] = fobj.ResultMessage;
		vobj = JSON.parse(GPKISecureWeb.GetCertDetailInfo(sIndex,detailFields[i]));
		strCertDetailValues[i] = vobj.ResultMessage
	}
	
	var __001 = document.createElement("div");
	__001.id = 'cv_popup';
	__001.style.zIndex = '+1';
	__001.style.width='389px';
	__001.style.visibility ='hidden';
	__001.style.borderRadius = '6.0px';	
	__001.style.display ='none';
	
	var __002 = document.createElement("div");
	__002.id = 'cv_popup_drag';
	__002.style.backgroundColor='gray';
	__002.style.height ='24px';
	__002.style.background = 'url("' + gpkiScriptBase + '/image/certificate/pop_tit_bg_01.png")';
	__002.style.borderBottom ='0px';
	__002.style.fontSize ="13px";
	__002.style.fontFamily='Malgun Gothic, Dotum, Verdana, sans-serif';
	__002.style.textAlign = 'center';
	__002.style.verticalAlign = 'middle';
		
	__002.appendChild(document.createTextNode(LangR.CertView));
	
	__001.appendChild(__002);
	
	__001.appendChild(init());
	__001.style.zIndex = '524290';
	
	var overlay = document.createElement('div');
	var _resizeOverlayFunction;
	overlay.style.zIndex = '524289';
	overlay.onclick = null;
	
    	overlay.style.position = 'absolute';
    	overlay.style.width = '100%';
    	overlay.style.height = '100%';
	
   	overlay.style.top = '0';
    overlay.style.left = '0';
    overlay.style.opacity = 0.5;
    overlay.style.filter = "alpha(opacity='50')";
    overlay.style.backgroundColor = 'gray';
    
    document.getElementsByTagName("body")[0].appendChild(overlay);
    
	windowRoot = __001;
	document.getElementsByTagName("body")[0].appendChild(__001);
	
	attachKeyboardNavigator();
	
	

function onCertAlert( ){
	
}
var selectedRow ;

CertWindow.Table = {
	
	selectRow : function(srcElement, target){
		
		if(selectedRow !=null &&  typeof(selectedRow)!='undefined'){
			selectedRow.style.backgroundColor ='white';
		}
		srcElement.style.backgroundColor ='#E3E3E3';
		selectedRow = srcElement;	
		
		if(target.firstChild!=null && typeof(target.firstChild)!='undefined'){
			target.removeChild(target.firstChild);
		}
		
		target.appendChild(document.createTextNode(srcElement.childNodes[1].getElementsByTagName('textarea')[0].value));//outerText));//textContent
		
	}
}

function setReleaseSectedMark(target){		
	var children = target.parentNode.childNodes;
	for(var j=0;j<children.length;j++){
		var releaseColumn =children[j];
		if(target==releaseColumn)
			continue;
		
		setSelectedMark(releaseColumn,'white');		
	}
}

var firstElement,preSelectData ;
function parseInfo(target,valueArea, fieldNames,strData){
	var detailView = target;
	for(i=0;i<fieldNames.length;i++){
		var tmp_0 = document.createElement("tr");
		tmp_0.style.backgroundColor='white';
		tmp_0.onclick = function(){
			CertWindow.Table.selectRow(this,valueArea);
			if(preSelectData!=null && typeof(preSelectData)!='undefined'){
				preSelectData.style.backgroundColor = 'white';
			}
			
			preSelectData = this;
		};
		detailView.appendChild(tmp_0);
		
		var tmp_1 = document.createElement("td");
		tmp_1.style.width ='100px';
		tmp_1.style.fontSize = '12px';
		tmp_1.style.fontFamily = 'Arial, Helvetica, sans-serif,Dotum';
		tmp_1.appendChild(document.createTextNode(fieldNames[i]));		
		tmp_0.appendChild(tmp_1);		
		
		
		var tmp_2 = document.createElement("textarea");
		tmp_2.style.overflow = 'hidden';
		tmp_2.style.fontSize ='12px';
		tmp_2.style.fontFamily = 'Arial, Helvetica, sans-serif, Dotum';
		tmp_2.onfocus = function(){
			CertWindow.Table.selectRow(this.parentNode.parentNode,valueArea);
			this.style.backgroundColor = '#E3E3E3';
			if(preSelectData!=null && typeof(preSelectData)!='undefined'){
				preSelectData.style.backgroundColor = 'white';
			}
			
			preSelectData = this;
		};		
		tmp_2.setAttribute('title',fieldNames[i]+strData[i]);
		tmp_2.style.scrollY = 'none';
		tmp_2.readOnly = true;
		tmp_2.value = strData[i];
		tmp_2.style.width='239px';
		tmp_2.style.border = 'solid 0px white';
		tmp_2.style.scrollY = 'none';
			
		var tmp_3 = document.createElement("td");
		tmp_3.style.width ='240px';
		tmp_3.appendChild(tmp_2);
		tmp_0.appendChild(tmp_3);	
		
		if(i==0){
			tmp_0.style.backgroundColor ='white';			
			firstElement = tmp_2;
		}
	}	
}


function changetab(parent, contents, t){
	var tabChilds = parent.childNodes;
	var contentChilds = contents.childNodes;
	
	for(i=0; i<(tabChilds.length); i++){
		var target;
		target = contentChilds[i];
		
		if(tabChilds[i] == t){
			tabChilds[i].style.backgroundColor ='#fff';							
			target.style.display = '';				
		}else{
			tabChilds[i].style.backgroundColor ='#e9e9e9';					
			target.style.display = 'none';					
		}
	}
}

function init(){
	var __001 = document.createElement("DIV");
	__001.style.width= '389px';
	__001.style.height='490px';
	__001.style.backgroundColor='#F4F4F4';
	
	var __002 = document.createElement("div");
	__002.style.width= '369px';
	__002.style.paddingTop = '8px';
	__002.style.marginLeft='8px';
	__002.style.textAlign='left';	
	__001.appendChild(__002);
	
	var __003 = document.createElement("DIV");	
	__003.style.width= '369px';
	__003.style.height='400px';	
	__003.style.marginTop='0px';
	__003.style.marginLeft='8px';
	__003.style.backgroundColor='#F4F4F4';
	__001.appendChild(__003);
	
		
	var __002_1 = document.createElement("div");
	__002_1.style.marginBottom = '0px';
	__002_1.style.paddingTop = '11px';
	__002_1.style.paddingBottom = '5px';
	
	var __002_1_0 = document.createElement("div");
	__002_1_0.style.width = '55px';
	__002_1_0.style.height = '35px';
	__002_1_0.style.padding = '0px 0px 0px 0px';
	__002_1_0.style.border = '0px solid blue';
	
	
	if (browserType == BROWSER_IE){
		__002_1_0.style.styleFloat = 'left';
	}else{
		__002_1_0.style.cssFloat = 'left';
	}
	
	var __002_1_1 = document.createElement("button");
	__002_1_1.style.height = '27px';
	__002_1_1.style.width = '70px';
	__002_1_1.style.border ='1px solid #BBB';
	__002_1_1.style.backgroundColor = "white";
	__002_1_1.style.fontsize ='12px';
	__002_1_1.onclick = function(e){
		changetab(__002, __003,this )
	};
	__002_1_1.appendChild(document.createTextNode(LangR.tab01));
	__002.appendChild(__002_1_1);
		
	var __002_1_2 = document.createElement("div");//#fff
	if (browserType == BROWSER_IE){
		__002_1_2.style.styleFloat = 'left';
	}else{
		__002_1_2.style.cssFloat = 'left';
	}
	
	var __002_1_3 = document.createElement("button");//#fff
	__002_1_3.id='detailTab';
	__002_1_3.style.width = '70px';
	__002_1_3.style.height = '27px';
	__002_1_3.style.marginLeft = '5px';
	__002_1_3.style.border ='1px solid #BBB';
	__002_1_3.style.backgroundColor = "#e9e9e9";
	__002_1_3.style.fontsize ='12px';
	__002_1_3.onclick = function(e){
		changetab(__002, __003,this ); 
		firstElement.focus();
	};
	__002_1_3.appendChild(document.createTextNode(LangR.tab02));
	__002.appendChild(__002_1_3);
	
	var __002_1_4 = document.createElement('div');
	__002_1_4.style.clear = 'both';
	
	var __003_1 = document.createElement("DIV");
	__003_1.style.border = '#CCC solid 1px';
	__003.appendChild(__003_1);
		
	var __003_1_1 = document.createElement("div");
	__003_1_1.style.padding = '10px 0px 0px 10px';
	__003_1_1.style.margin='0px 0px 0px 0px';
	__003_1_1.style.backgroundColor='#fff';
	__003_1_1.style.textAlign = 'left';
	
	var __003_1_1_0 = document.createElement("button");
	__003_1_1_0.style.border = '#F4F4F4 solid 1px';
	__003_1_1_0.style.width= '360px';
	__003_1_1_0.style.height='330px';
	__003_1_1_0.style.padding = '0px 0px 0px 0px';
	__003_1_1_0.style.marginLeft='3px';
	__003_1_1_0.style.marginTop='3px';
	__003_1_1_0.style.backgroundColor='#F4F4F4';
	__003_1_1_0.style.backgroundColor='#fff';
	__003_1_1_0.appendChild(__003_1_1);
	__003_1.appendChild(__003_1_1_0);
	
	var __003_1_1_1 = document.createElement("img");
	__003_1_1_1.setAttribute('src', gpkiScriptBase + '/image/certificate/cert/cert_2048.bmp');
	__003_1_1.appendChild(__003_1_1_1);
	
	var __003_1_1_2 = document.createElement("SPAN");
	__003_1_1_2.style.marginLeft = '5px';
	__003_1_1_2.style.height='25px';
	__003_1_1_2.style.fontFamily = 'Malgun Gothic, Dotum, Verdana, sans-serif';
	__003_1_1_2.appendChild(document.createTextNode(LangR.CertGF01));
	__003_1_1_2.style.fontSize = '14px';
	__003_1_1.appendChild(__003_1_1_2);
	
	var __003_1_1_3 = document.createElement("SPAN");
	__003_1_1_3.appendChild(document.createTextNode(LangR.CertGF02));
	__003_1_1_3.style.fontFamily = 'Malgun Gothic, Dotum, Verdana, sans-serif';
	__003_1_1_3.style.fontSize = '14px';
	__003_1_1.innerHTML = __003_1_1.innerHTML + "<br><br>";
	__003_1_1.appendChild(__003_1_1_3);
	
	var __003_1_1_4 = document.createElement("SPAN");
	__003_1_1_4.appendChild(document.createTextNode(" "+ arrCertInfo[1]));
	__003_1_1_4.style.fontSize = '12px';
	__003_1_1.innerHTML = __003_1_1.innerHTML + "<br>";
	__003_1_1.appendChild(__003_1_1_4);
	
	var __003_1_1_6 = document.createElement("SPAN");
	__003_1_1_6.style.fontFamily = 'Malgun Gothic, Dotum, Verdana, sans-serif';
	__003_1_1_6.appendChild(document.createTextNode(LangR.CertGF03));//
	__003_1_1_6.style.fontSize = '12px';
	__003_1_1.innerHTML = __003_1_1.innerHTML + "<br><br>";
	__003_1_1.appendChild(__003_1_1_6);
	
	var __003_1_1_7 = document.createElement("SPAN");
	__003_1_1_7.appendChild(document.createTextNode(" "+LangR.CertGF04+arrCertInfo[2]));//
	__003_1_1_7.style.fontSize = '12px';
	__003_1_1.innerHTML = __003_1_1.innerHTML + "<br><br>";
	__003_1_1.appendChild(__003_1_1_7);
	
	var __003_1_1_8 = document.createElement("SPAN");
	__003_1_1_8.appendChild(document.createTextNode(LangR.CertGF05+arrCertInfo[3]));//
	__003_1_1_8.style.fontSize = '12px';
	__003_1_1.innerHTML = __003_1_1.innerHTML + "<br><br>";
	__003_1_1.appendChild(__003_1_1_8);
	
	var __003_1_1_9 = document.createElement("SPAN");
	__003_1_1_9.appendChild(document.createTextNode(LangR.CertGF06+arrCertInfo[4]));//
	__003_1_1_9.style.fontSize = '12px';
	__003_1_1.innerHTML = __003_1_1.innerHTML + "<br><br>";
	__003_1_1.appendChild(__003_1_1_9);
	
	var __003_1_1_7 = document.createElement("SPAN");
	__003_1_1_7.appendChild(document.createTextNode(LangR.CertGF07+arrCertInfo[5]));//
	__003_1_1_7.style.fontSize = '12px';
	__003_1_1.innerHTML = __003_1_1.innerHTML + "<br><br>";
	__003_1_1.appendChild(__003_1_1_7);
	
	var __003_1_1_7 = document.createElement("SPAN");
	//__003_1_1_7.appendChild(document.createTextNode(LangR.CertGF08+arrCertInfo[6]));//
	__003_1_1_7.style.fontSize = '12px';
	__003_1_1.innerHTML = __003_1_1.innerHTML + "<br><br>";
	__003_1_1.appendChild(__003_1_1_7);
	
			
	var __003_1_2 = document.createElement("DIV");
	__003_1_2.style.marginTop ='10px';
	__003_1_2.style.height='40px';
	__003_1_2.style.marginLeft = '140px';
	__003_1_2.style.textAlign='left';
	
	__003_1.appendChild(__003_1_2);
	
	
	var __003_1_2_2 = document.createElement('BUTTON');	
	__003_1_2_2.style.width = '76px';
	__003_1_2_2.style.height = '26px';
	__003_1_2_2.style.border = '0px';
	__003_1_2_2.style.padding = '0px';
	__003_1_2_2.style.marginLeft='120px';
	__003_1_2_2.style.display='none';
	__003_1_2_2.style.background = 'url("' + gpkiScriptBase + '/image/certificate/btn_notice.png")';
	__003_1_2_2.onclick = function(){
		var obj = JSON.parse(GPKISecureWeb.GetCertDetailField(sIndex,31))
		var alertMsg = obj.ResultMessage;
		var valueStarPoint =alertMsg.indexOf("=")+1; 
		alertMsg = LangR.alertMsg +": \n"+alertMsg.substr(valueStarPoint,alertMsg.length);
		
		alert(alertMsg);
		};
	__003_1_2.appendChild(__003_1_2_2);
	
	__003_1.appendChild(__003_1_2);	
	
	
	var __003_2 = document.createElement("DIV");
	__003_2.style.width= '369px';
	__003_2.style.display = 'none';
	__003.appendChild(__003_2);
		
	var __003_2_1 = document.createElement("DIV");
	__003_2_1.style.border = '#CCC solid 1px';
	__003_2_1.style.width= '369px';
	__003_2_1.style.height='270px';
	__003_2_1.style.position = 'relative';
	__003_2_1.style.overflowX = "hidden";
	__003_2_1.style.overflowY = "scroll";
	__003_2.appendChild(__003_2_1);
	
	var __003_2_1_1 = document.createElement("table");
	__003_2_1_1.id = 'certInfotable';
	__003_2_1_1.style.fontSize = '12px';//table-layout: fixed
	
	var __003_2_1_2 = document.createElement("thead");
	__003_2_1_2.style.fontSize = '12.0px';
		
	var __003_2_1_3 = document.createElement("tr");	
	__003_2_1_3.style.textAlign='center';
	var __003_2_1_4 = document.createElement("th");
	var __003_2_1_5 = document.createElement("div");
	__003_2_1_5.appendChild(document.createTextNode(LangR.CertDF01));
	__003_2_1_5.style.width = '100px';
	__003_2_1_5.style.borderWidth = '1.0px';
	__003_2_1_5.style.borderStyle = 'none solid solid none';
	__003_2_1_5.style.borderColor = 'black';
	__003_2_1_5.style.fontSize = '12px'; 
	__003_2_1_5.style.fontFamily = 'Arial, Helvetica, sans-serif,Dotum';
	__003_2_1_5.style.fontWeight = 'normal';
	__003_2_1_4.appendChild(__003_2_1_5);
	__003_2_1_3.appendChild(__003_2_1_4);	
	
	var __003_2_1_6 = document.createElement("th");
	__003_2_1_6.style.width = '240px';
	var __003_2_1_7 = document.createElement("div");
	__003_2_1_7.appendChild(document.createTextNode(LangR.CertDF02));
	__003_2_1_7.style.borderWidth = '1.0px';
	__003_2_1_7.style.width = '240px';
	__003_2_1_7.style.borderStyle = 'none solid solid none';
	__003_2_1_7.style.borderColor = 'black';
	__003_2_1_7.style.fontSize = '12px';
	__003_2_1_7.style.fontFamily = 'Arial, Helvetica, sans-serif, Dotum';
	__003_2_1_7.style.fontWeight = 'normal';
	__003_2_1_6.appendChild(__003_2_1_7);
	__003_2_1_3.appendChild(__003_2_1_6);
	__003_2_1_2.appendChild(__003_2_1_3);
	__003_2_1_1.appendChild(__003_2_1_2);
	
	var __003_2_1_8 = document.createElement("tbody");
	
	__003_2_1_1.appendChild(__003_2_1_8);
	__003_2_1.appendChild(__003_2_1_1);
	
	var __003_2_2 = document.createElement("textarea");
	__003_2_2.style.border = '#CCC solid 1px';
	__003_2_2.style.overflow ='auto';
	__003_2_2.style.backgroundColor = '#E3E3E3';
	__003_2_2.style.fontColor= 'black';
	__003_2_2.style.fontSize = '12px';
	__003_2_2.style.fontFamily = 'Arial, Helvetica, sans-serif, Dotum';
	__003_2_2.style.width= '100%';
	__003_2_2.style.height='110px';
	__003_2_2.style.marginTop='10px';
	__003_2.appendChild(__003_2_2);		
	
	var __004 = document.createElement("DIV");
	__004.style.width= '369px';
	__004.style.height='40px';
	__004.style.marginTop='8px';
	__004.style.marginLeft='8px';	
	__004.style.textAlign='right';
	__001.appendChild(__004);
	
	var __004_1 = document.createElement('BUTTON');
	__004_1.id = 'certViewOk';
	__004_1.style.width = '76px';
	__004_1.style.height = '26px';
	__004_1.style.border = '0px';
	__004_1.style.padding = '0px';
	__004_1.style.margin='0px 30px 0px 0px ';
	__004_1.style.background = 'url("' + gpkiScriptBase + '/image/certificate/btn_ok.png")';
	__004_1.onclick = function(){
		document.getElementsByTagName("body")[0].removeChild(overlay);
		document.getElementsByTagName("body")[0].removeChild(windowRoot);
		if(clickElement!=null && typeof(clickElement)!='undefined')
			clickElement.disabled = false;
	};
	__004.appendChild(__004_1);
	
	parseInfo( __003_2_1_8,__003_2_2,strCertDetailFields,strCertDetailValues);
	return __001;
}

var clickElement;

function attachKeyboardNavigator(){
	var myInput = document.getElementById("certInfotable").getElementsByTagName("tr");

	for(i=1; i<myInput.length; i++){
	    if(myInput[i].addEventListener ) {
	        myInput[i].addEventListener('keydown',keyHandler,false);
	    } else if(myInput[i].attachEvent ) {
	        myInput[i].attachEvent('onkeydown',keyHandler); /* damn IE hack */	        
	    }
	    if(i!=1)
	    	myInput[i].setAttribute('preElement',i-1);
	    	
	    if(i!=(myInput.length-1))
	    	myInput[i].setAttribute('nextElement',i+1);
		}
}

function keyHandler(e) {
	var myInput = document.getElementById("certInfotable").getElementsByTagName("tr");
		var target = e.target||e.srcElement;
		var parent = target.parentNode.parentNode;
		    		
    var TABKEY = 9;
    var Up = 38;
    var Down =40;
    if(e.shiftKey && e.keyCode == TABKEY){
		if (browserType == BROWSER_IE){
			document.getElementById('detailTab').focus();
		}else{
	   		if(e.preventDefault) {
	   			e.preventDefault();
	   		}
	   		document.getElementById('detailTab').focus();
    	}
    	return false;
   	} else if(e.keyCode == TABKEY) {
		if (browserType == BROWSER_IE){
			document.getElementById('certViewOk').focus();
		}else{
    		if(e.preventDefault) {
    			e.preventDefault();
    		}
    		document.getElementById('certViewOk').focus();
    	}
        return false;
    }else if(e.keyCode == Up) {
    	var preNode = parent.getAttribute('preElement');        	
    	if(preNode!=null && typeof(preNode)!='undefined'){
    		myInput[preNode].getElementsByTagName('textarea')[0].focus();      	
    	}
    }else if(e.keyCode == Down) {
    	var nextNode = parent.getAttribute('nextElement');        	
    	if(nextNode!=null && typeof(nextNode)!='undefined'){
    		myInput[nextNode].getElementsByTagName('textarea')[0].focus(); 
    	}
    }
}
return{
 	 show : function(element){
 	 	overlay.style.display = '';
 		__001.style.display = '';
 		new Dialog().show('cv_popup', 'cv_popup_drag', 'screen-center', 0, 0,'');
 		if(element!=null && typeof(element)!='undefined'){
 			clickElement = element;
 		}
 		return windowRoot; 
 	 },
 	 dispose :function(){
 	 	overlay.style.display = 'none';
 		__001.style.display = 'none';	
 	 }
	}
}