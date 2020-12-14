SecureTokenWindow =function (certObj) {
	var callback = certObj;
	
	loadJavascript(gpkiScriptBase + "/ui/common.js",errorWin);
	//var LangR = loadJavascript(gpkiScriptBase + "/ui/certviewR",errorWin,"ko-KR.js");
	function loadJavascript(URL,callback,langSt) { 
		var xmlhttp = null; 
		if(window.XMLHttpRequest) { 
			xmlhttp = new XMLHttpRequest(); 
		}else{ 
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
		} 
		if(langSt==null||typeof(langSt)=='undefined'){
			xmlhttp.open('GET', URL,false);
		}else{
			xmlhttp.open('GET', URL+"_"+langSt,false);  
		}
		xmlhttp.onreadystatechange = function(){ 
			if(xmlhttp.readyState==4 && xmlhttp.status == 200 && xmlhttp.statusText=='OK') { 
				responseText = xmlhttp.responseText;
			} 
		} 
		xmlhttp.send('');
		return eval(responseText);
	}
	function errorWin(){}
	var windowRoot;
	var __001 = document.createElement("div");
	__001.id = 'STpopup';
	__001.style.zIndex = '+1';
	__001.style.width='391px';
	__001.style.visibility ='hidden';
	__001.style.textAlign = 'center';
	__001.style.borderRadius = '6.0px';	
	__001.style.display ='none';
	
	var __002 = document.createElement("div");
	__002.id = 'STpopup_drag';
	__002.style.backgroundColor='gray';
	__002.style.height ='24px';
	__002.style.background = 'url("' + gpkiScriptBase + '/image/certificate/pop_tit_bg_01.png")';
	__002.style.borderBottom ='0px';
	__002.style.fontSize = '13px';
	__002.style.fontFamily='Malgun Gothic, Dotum, Verdana, sans-serif';
	__002.style.color ='white';
	
	__002.appendChild(document.createTextNode(tokenStr.tokenWinTitle));
	
	__001.appendChild(__002);
	__001.appendChild(init());
	
	var overlay = document.createElement('div');
	var _resizeOverlayFunction;
	overlay.style.zIndex = '525287';
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
	
	__001.style.zIndex = '525288';
	document.getElementsByTagName("body")[0].appendChild(__001);
	attachKeyboardNavigator();

function onCertAlert( ){
}
var win,selectedRow,preSelectedRow,preSelectedRow2;
function loadedWin(){
	//win = new Dialog();	
}	

var selecteRowNum ;

function selectRow(srcElement, target){
		
	if(selectedRow!=null && typeof(selectedRow)!='undefined' && srcElement!=selectedRow){
		selectedRow.setAttribute('selected',false);
	}
	selectedRow = srcElement;
	setReleaseSectedMark(srcElement);
	srcElement.setAttribute('selected',true);		
	setSelectedMark(srcElement,'#77B1EE');	
	
	var parent = srcElement.parentNode;
	var childs = parent.childNodes;
	for(i=0;i<childs.length;i++){
		if(srcElement==childs[i]){
			selecteRowNum = i;
			break;
		}
	}
}

function checkSelected(element){
	var result = element.getAttribute('selected');
	if(result!=null && typeof(srcElement)!='undefined'){
		return result;
	}else{
		return false;
	}
}

function setReleaseSectedMark(target){		
	var children = target.parentNode.childNodes;
	for(var j=0;j<children.length;j++){
		var releaseColumn =children[j];
		if(selectedRow==releaseColumn || target==releaseColumn){
			continue;
		}
		setSelectedMark(releaseColumn,'white');		
	}
}

function setSelectedMark(target,color){
	target.style.backgroundColor = color;
	var childrend = target.childNodes;
	for(var i=0; i<childrend.length; i++){
		if(i%2==0){
			childrend[i].style.backgroundColor = color;
		}
	}
}

/* data table library */
function  createSecurityRow(parent,columns,isheader,idx){
	var pElement, totalString,__001;
	totalString = '';
	
	if(isheader){
		pElement = parent;
		
		
	}else{		
		pElement = document.createElement('div');
		pElement.style.backgroundColor = 'white';
		pElement.style.height = '20px';
		
		pElement.onclick = function(){
			if(selectedRow==this) 
				return; 
		
			if(preSelectedRow2!=null && typeof(preSelectedRow2)!='undefined' && preSelectedRow2!=preSelectedRow){
				preSelectedRow2.style.backgroundColor = 'white';
			}
			preSelectedRow2 = this.getElementsByTagName('BUTTON')[0];
			preSelectedRow2.setAttribute('idx', idx);
			selectRow(this);
			preSelectedRow2.style.backgroundColor='#77B1EE';
		};
		
		pElement.onmouseover = function(){
			setReleaseSectedMark(this);
			if(preSelectedRow!=null && typeof(preSelectedRow)!='undefined' && preSelectedRow2!=preSelectedRow)
				preSelectedRow.style.backgroundColor = 'white';
			
			if(selectedRow==this)
				return;
			setSelectedMark(this,'#E3E4FA');
			this.style.cursor = 'pointer';
						
			preSelectedRow = this.getElementsByTagName('BUTTON')[0];
			preSelectedRow.style.backgroundColor='#E3E4FA';
		};		
		
		parent.appendChild(pElement);		 
	}
	
	for(var i=0; i<columns.length; i++){
		var __003_01 = document.createElement('div');
		if(!isheader)
			__003_01.style.backgroundColor = 'white';
		__003_01.style.fontSize='11px';
		__003_01.style.height='17px';
		__003_01.style.width = '160px';
		
		if(navigator.appName == "Microsoft Internet Explorer"){
			__003_01.style.styleFloat = 'left';
		}else{
			__003_01.style.cssFloat = 'left';
		}
		__003_01.style.textAlign = 'center';
		__003_01.style.overflow = 'hidden';
				
		if(i==1 && !isheader){
			var selectLayer = document.createElement('button');
			selectLayer.style.width = '158px';
			selectLayer.style.height ='17px';
			selectLayer.style.margin ='0px';
			selectLayer.style.padding ='0px';
			selectLayer.fontSize = '11px';
			selectLayer.style.color = '#666';

			selectLayer.appendChild(document.createTextNode(columns[i]));
			selectLayer.style.backgroundColor='white';
			selectLayer.style.border = 'solid 0px white';
			totalString += columns[i]+" ";		
			selectLayer.onfocus = function(){
				setReleaseSectedMark(this.parentNode.parentNode);
				if(preSelectedRow!=null && typeof(preSelectedRow)!='undefined' && preSelectedRow2!=preSelectedRow)
					preSelectedRow.style.backgroundColor = 'white';
				
				if(selectedRow==this.parentNode.parentNode)
					return;
				
				setSelectedMark(this.parentNode.parentNode,'#E3E4FA');	
				
				
				preSelectedRow = this.parentNode.parentNode.getElementsByTagName('BUTTON')[0];
				preSelectedRow.style.backgroundColor='#E3E4FA';	
			}				
			__003_01.appendChild(selectLayer);
		}else{
			__003_01.appendChild(document.createTextNode(columns[i]));
			__003_01.style.margin ='0 0 0 0';
			__003_01.style.padding ='0 0 0 0';
			__003_01.style.fontSize = '11px';
			__003_01.style.color = '#666';
			totalString += columns[i]+" ";		
		}
				
		pElement.appendChild(__003_01);
		
		if(i!=(columns.length-1)){
			var __003_02 = document.createElement('div');
			if(navigator.appName == "Microsoft Internet Explorer"){
				__003_02.style.styleFloat = 'left';
			}else{
				__003_02.style.cssFloat = 'left';
				__003_02.innerHTML = '&nbsp';
			}
			__003_02.style.backgroundColor = 'white';
			__003_02.style.width='0px';
			__003_02.style.height = '100%';
			pElement.appendChild(__003_02);		
		}else{
			var __003_02 = document.createElement('div');
			__003_02.style.clear = 'both';
			pElement.appendChild(__003_02);			
		}	
	}	
		
	if(__001 !=null && typeof(__001)!='undefined')
		__001.setAttribute('title', totalString);
	
	pElement.setAttribute('title', totalString);
}

var tableobj ;
function init(){

	var winRoot = document.createElement('div');
	winRoot.style.padding = '15px 0px 5px 0px';
	winRoot.style.marginTop='0px';
	winRoot.style.marginLeft='0px';
	winRoot.style.backgroundColor='#F4F4F4';
	winRoot.style.border = '1px solid #CCC';
	
	var __002 = document.createElement('div');
	__002.style.width ='385px';
	winRoot.appendChild(__002);
	
	var __003 =  document.createElement('div');
	__003.style.marginLeft = '20px';
	__003.style.marginTop = '20px';	
	__003.style.width = '340px';
		
	__002.appendChild(__003);
	
	var __003_01 =  document.createElement('div');
	__003_01.id = 'parent';
	__003_01.style.backgroundColor = '#DDD';
	__003_01.style.margin = '0px';
	__003_01.style.padding = '0px';
	__003_01.style.paddingTop = '5px';
	__003.appendChild(__003_01);
	
	var columnNames = [tokenStr.driverName,tokenStr.driverInfo];	
	createSecurityRow(__003_01,columnNames,true,0);	
	
	GPKISecureWeb.SetMediaType(3);			
	var columnData = new Array();
	var obj="";
	for(var i=0;i<GPKISecureWeb.GetMediaSubCount();i++){
		obj = JSON.parse(GPKISecureWeb.GetMediaSubInfo(i));
		columnData[i] = obj.ResultMessage.split(',');
	}
	
	var __003_02 =  document.createElement('div');
	__003_02.style.border = 'solid 1px #CCC';
	__003_02.id='secureTokenList'
	__003_02.style.height = '150px';
	__003_02.style.color = '#666';
	__003_02.style.overflow ='auto';	
	__003.appendChild(__003_02);
		
	for(j=0;j<columnData.length;j++){
		createSecurityRow(__003_02,columnData[j],false,j);
	}
	tableobj = __003_02;
	
	var desc = new Array();
	
	desc[0] = tokenStr.description;
	desc[1] = tokenStr.description2;		
	desc[2] = tokenStr.description3;
	desc[3] = tokenStr.description4;	
	desc[4] = tokenStr.description5;
	desc[5] = tokenStr.description6;
	
	var __004 =  document.createElement('div');
	__004.style.width = '340px';
	__004.style.marginLeft ='20px';
	__004.style.marginTop ='15px';
	__004.style.marginBottom ='15px';
	__002.appendChild(__004);
	
	
	for(var i=0; i<desc.length; i++){
		var __004_01 = document.createElement('div');
		__004_01.style.textAlign = 'left';
		__004_01.style.fontSize = '11px';
		__004_01.style.color = '#666'
		__004_01.style.fontFamily = 'Malgun Gothic, Dotum, Verdana, sans-serif';
		//__004_01.style.marginBottom = '4px';
		__004_01.appendChild(document.createTextNode(desc[i]));
		__004.appendChild(__004_01);		
	}	
	
	var __005 =  document.createElement('div');
	__005.style.width = '340px';
	__005.style.textAlign = 'right';
	__005.style.marginLeft ='20px';
	__005.style.marginBottom ='15px';
	
	var __005_1 =  document.createElement('button');
	__005_1.id ='installSecureDriver';
	__005_1.style.width = '181px';
	__005_1.style.padding = '0px';
	__005_1.style.border = '0px';
	__005_1.style.height = '26px';
	__005_1.style.fontSize = '12px';
	__005_1.style.fontFamily = 'Malgun Gothic, Dotum, Verdana, sans-serif';
	__005_1.style.background = 'url("' + gpkiScriptBase + '/image/certificate/btn_install.png")';
	__005_1.onclick = function(){
		window.open(tokenDriverSetupPage);
	}
	__005.appendChild(__005_1);
	__002.appendChild(__005);
	
	var __006 = document.createElement('div');
	__006.style.width = '340px';
	__006.style.marginTop ='15px';
	__006.style.marginLeft ='20px';
	__006.style.marginRight ='20px';
	__006.style.paddingBottom ='15px';
	__006.style.textAlign = 'right';
	
	winRoot.appendChild(__006);
	
	var __006_01 = document.createElement('button');
	__006_01.id='gp_secure_ok';
	__006_01.style.width = '76px';
	__006_01.style.height = '26px';
	__006_01.style.padding = '0px';
	__006_01.style.border = '0px';
	__006_01.style.padding = '0px 0px 0px 0px';
	__006_01.style.background = 'url("' + gpkiScriptBase + '/image/certificate/btn_ok.png")';
	__006_01.onclick = function(){
		if(preSelectedRow2 ==null || typeof(preSelectedRow2)=='undefined'){
			alert(ErrorMessage.code70007);
			return;
		}
		clickElement.setAttribute('action','end');
		clickElement.setAttribute('idx',preSelectedRow2.getAttribute('idx'));
		document.getElementsByTagName("body")[0].removeChild(overlay);
		document.getElementsByTagName("body")[0].removeChild(__001);
		isFileDialog = false;
		if(clickElement!=null && typeof(clickElement)!='undefined')
			clickElement.disabled = false;	
			callback(clickElement);
	};
		
		
	__006.appendChild(__006_01);
	
	var __006_02 = document.createElement('button');
	__006_02.id = 'secureTokenCancel';
	__006_02.style.marginLeft = '10px';	
	__006_02.style.width = '76px';
	__006_02.style.height = '26px';
	__006_02.style.padding = '0px';
	__006_02.style.border = '0px';
	__006_02.style.padding = '0px 0px 0px 0px';
	__006_02.style.background = 'url("' + gpkiScriptBase + '/image/certificate/btn_cancel.png")';
	__006_02.onclick = function(){
		clickElement.setAttribute('action','end');
		document.getElementsByTagName("body")[0].removeChild(overlay);
		document.getElementsByTagName("body")[0].removeChild(__001);
		isFileDialog = false;
		clickElement.setAttribute('idx',-1);
		
		if(clickElement!=null && typeof(clickElement)!='undefined'){
			clickElement.disabled = false;
		}
		clickElement.focus();
	};		
		
	__006.appendChild(__006_02);
	
	if(tableobj.childNodes[0]!=null && typeof(tableobj.childNodes[0])!='undefined'){
		tableobj.childNodes[0].focus();
	}
	return winRoot;
}

function attachKeyboardNavigator(){
	var myInput = document.getElementById("secureTokenList").getElementsByTagName("button");

	for(i=0; i<myInput.length; i++){
	    if(myInput[i].addEventListener ){
	        myInput[i].addEventListener('keydown',keyHandler,false);
	    }else if(myInput[i].attachEvent ){
	        myInput[i].attachEvent('onkeydown',keyHandler); /* damn IE hack */	        
	    }
	    if(i!=0){
	    	myInput[i].setAttribute('preElement',i-1);
	    }
	    if(i!=(myInput.length-1)){
	    	myInput[i].setAttribute('nextElement',i+1);
	    }
	}
}

function keyHandler(e) {
	var myInput = document.getElementById("secureTokenList").getElementsByTagName("button");
	var target = e.target||e.srcElement;
    var TABKEY = 9;
    var Up = 38;
    var Down =40;
    if(e.shiftKey && e.keyCode == TABKEY){
    	if(navigator.appName == "Microsoft Internet Explorer"){
    		document.getElementById('secureTokenCancel').focus();
    	}
    	else{
	   		if(e.preventDefault) {
	   			e.preventDefault();
	   		}
	   		document.getElementById('secureTokenCancel').focus();
    	}
    	return false;
   	}else if(e.keyCode == TABKEY){
    	if(navigator.appName == "Microsoft Internet Explorer"){
    		document.getElementById('installSecureDriver').focus();
    	}else{
    		if(e.preventDefault){
    			e.preventDefault();
    		}
    		document.getElementById('installSecureDriver').focus();
    	}
        return false;
    }else if(e.keyCode == Up){
    	var preNode = target.getAttribute('preElement');        	
    	if(preNode!=null && typeof(preNode)!='undefined'){
    		myInput[preNode].focus();    
    	}
    	if(e.preventDefault) {
   			e.preventDefault();
   		}else{
   			return false;
   		}
    }else if(e.keyCode == Down) {
		var nextNode = target.getAttribute('nextElement');        	
		if(nextNode!=null && typeof(nextNode)!='undefined'){
			myInput[nextNode].focus();
		}
    	if(e.preventDefault){
   			e.preventDefault();
   		}else{
   			return false;
   		}
    }
}

var clickElement;
	return{

		show : function(target){

			clickElement = target;
			
			overlay.style.display='';
			__001.style.display='';	
			
			new Dialog().show('STpopup', 'STpopup_drag', 'screen-center', 0, 0,'');
			if(clickElement!=null && typeof(clickElement)!='undefined'){
				clickElement.setAttribute('action','process');
			}else{
				alert(tokenStr.alertText);
				return;
			}
			
			var focusElements = tableobj.getElementsByTagName('button');
			if (focusElements == null || focusElements == 'undefined' || focusElements.length == 0) {
				var con_test = confirm(ErrorMessage.code70008);
				if(con_test == true){ 
				  installSecureDriver.onclick();
				}
				else if(con_test == false){
				  return false;
				}
			} else {
				var focusElements = tableobj.getElementsByTagName('button');
				focusElements[0].focus();
			}
			return __001;
		},
		dispose : function(){
			overlay.style.display='none';
			__001.style.display='none';
		}
	}
}
