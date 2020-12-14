PinWindow =function (flowNumber) {
	var CertInfo = flowNumber;
	
	loadJavascript(gpkiScriptBase + "/ui/common.js",errorWin);
	//loadJavascript(gpkiScriptBase + "/ui/pinWindowR",errorWin,null,"ko-KR.js");
	
	function loadJavascript(URL,callback,event,charet) { 
		
	    var xmlhttp = null; 
	    if(window.XMLHttpRequest) { 
	        xmlhttp = new XMLHttpRequest(); 
	    } else { 
	        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
	    } 

			URL = (charet!=null && typeof(charet)!='undefined' &&charet.length!=0)?URL+'_'+charet:URL;
	    xmlhttp.open('GET', URL,false); 

	    xmlhttp.onreadystatechange = function() { 
	        if(xmlhttp.readyState==4 && xmlhttp.status == 200 && xmlhttp.statusText=='OK') { 
	            eval(xmlhttp.responseText);           
	        } 
	    } 
	    xmlhttp.send('');
	 
	    var userAgent = navigator.userAgent;
	    if(userAgent.indexOf('Firefox')>-1 && userAgent.indexOf('3.6.')>-1){
	    	if(xmlhttp.readyState==4 && xmlhttp.status == 200 && xmlhttp.statusText=='OK') { 
	            eval(xmlhttp.responseText);         
	        }
	    }
	    
	    if(event!=null && typeof(event)!='undefined')
	    	return callback(event);
	    else
	    	return callback();

	}
	function errorWin(){}

	var windowRoot;
	
	var __001 = document.createElement("div");
	__001.id = 'ppopup';
	__001.style.zIndex = '+1';
	__001.style.width='263px';
	__001.style.visibility ='hidden';
	__001.style.textAlign = 'center';
	__001.style.borderRadius = '6.0px';	
	__001.style.display ='none';
	
	var __002 = document.createElement("div");
	__002.id = 'ppopup_drag';
	__002.style.backgroundColor='gray';
	__002.style.height ='24px';
	__002.style.background = 'url("' + gpkiScriptBase + '/image/certificate/pop_tit_bg.png")';
	__002.style.borderBottom ='0px';
	__002.style.fontSize = '12px';
	__002.style.fontFamily="Malgun Gothic, Dotum, Verdana, sans-serif";
	__002.style.color="white";
	
	__002.appendChild(document.createTextNode(pinStr.pinWinTitle));
	
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



function onCertAlert( ){
	
}
var win;
function loadedWin(){
	//win = new Dialog();	
}	
	
var selectedRow ;

function  createSecurityRow(parent,columns,isheader){
	var pElement;
	if(isheader)
		pElement = parent;
	else{
		pElement = document.createElement('a');
		pElement.href = '#';
		parent.appendChild(pElement);		
	}
	
	for(i=0; i<columns.length; i++){
		var __003_01 = document.createElement('div');
		__003_01.style.width = '160px';
		if (browserType == BROWSER_IE){
			__003_01.style.styleFloat = 'left';
		}else{
			__003_01.style.cssFloat = 'left';
		}
		__003_01.style.textAlign = 'center';
		__003_01.appendChild(document.createTextNode(columns[i]));
		pElement.appendChild(__003_01);
		
		if(i!=(columns.length-1)){
			var __003_02 = document.createElement('div');
			if (browserType == BROWSER_IE){
				__003_02.style.styleFloat = 'left';
			}else{
				__003_02.style.cssFloat = 'left';
			}
			__003_02.style.backgroundColor = 'black';
			__003_02.style.width='1px';
			__003_02.innerHTML = '&nbsp';
			pElement.appendChild(__003_02);		
		}else{
			var __003_02 = document.createElement('div');
			__003_02.style.clear = 'both';
			pElement.appendChild(__003_02);
		}	
	}	
}

function init(){
		
	var winRoot = document.createElement('div');
	winRoot.id = 'pinDiloag';
	winRoot.style.border = '1px solid #CCC';
	winRoot.style.width = '260px';
	winRoot.style.height ='85px';
	winRoot.style.marginTop='0px';
	winRoot.style.marginLeft='0px';
	winRoot.style.backgroundColor='#E3E3E3';
	
	var __002 = document.createElement('div');
	__002.style.height = '20px';
	__002.style.marginTop = '5px';
		
	var __002_1 = document.createElement('label');
	__002_1.style.fontSize = '12px';
	__002_1.style.fontFamily='Malgun Gothic, Dotum, Verdana, sans-serif';
	__002_1.appendChild(document.createTextNode(pinStr.errMsg));
	__002.appendChild(__002_1);
	winRoot.appendChild(__002);
	
	var __003 = document.createElement('input');
	__003.type = 'password';
	__003.id = 'pn_passwd';
	__003.style.marginTop = '5px';
	__003.style.width = '250px';
	__003.setAttribute('title',pinStr.errMsg);
	__003.style.fontSize = '14px';
	__003.style.fontFamily = 'italic bold 14px arial,serif';
	if(__003.addEventListener ) {
		__003.addEventListener('keydown',keyHandler,false);
    } else if(__003.attachEvent ) {
    	__003.attachEvent('onkeydown',keyHandler); /* damn IE hack */	        
    }
	
	winRoot.appendChild(__003);	
	
	var __004 = document.createElement('div');
	__004.style.maginTop = '5px';
	winRoot.appendChild(__004);
	
	var __004_01 = document.createElement('button');
	__004_01.id = 'pOkAction';
	__004.style.marginTop ='5px';
	__004.style.height ='10px';
	
	__004_01.style.width = '76.0px';
	__004_01.style.height = '26.0px';
	__004_01.style.background = 'url("' + gpkiScriptBase + '/image/certificate/btn_ok.png")';
	__004_01.onclick = function(){
		var value = document.getElementById('pn_passwd')!=null?document.getElementById('pn_passwd').value:null;
		value = ((value==null)&&(typeof(value)=='undefined'))?'':value;
		if(value==''){
			alert(ErrorMessage.code70010);
			document.getElementById('pn_passwd').focus();
			return;
		}
		
		document.getElementsByTagName("body")[0].removeChild(overlay);
		document.getElementsByTagName("body")[0].removeChild(__001);
		isFileDialog = false;
		if(clickElement!=null && typeof(clickElement)!='undefined')
		clickElement.disabled = false;
		clickElement.setAttribute('action','end');
		clickElement.setAttribute('pin',value);
		clickElement.focus();
		
		if(subElement!=null)
			CertInfo(clickElement,subElement);
		else
			CertInfo(clickElement);
	};
		__004.appendChild(__004_01);
		
			
		var __004_02 = document.createElement('button');
		__004_02.style.marginLeft='15px';
		__004_02.style.height='15px';
		__004_02.style.width = '76.0px';
		__004_02.style.height = '26.0px';
		__004_02.style.background = 'url("' + gpkiScriptBase + '/image/certificate/btn_cancel.png")';
		__004_02.onclick = function(){
			clickElement.setAttribute('action','end');
			document.getElementsByTagName("body")[0].removeChild(overlay);
			document.getElementsByTagName("body")[0].removeChild(__001);
			isFileDialog = false;
			if(clickElement!=null && typeof(clickElement)!='undefined')
				clickElement.disabled = false;
			clickElement.focus();
			};
		__004.appendChild(__004_02);
	return winRoot; 
}

function keyHandler(e) {
		
	var target = e.target||e.srcElement;
    var TABKEY = 9;
    var Up = 38;
    var Down =40;
    var enter = 13;
    
    if(e.keyCode == enter){
		if (browserType == BROWSER_IE){
			document.getElementById('pOkAction').onclick();
		}else{
	   		if(e.preventDefault) {
	   			e.preventDefault();
	   		}
	   		document.getElementById('pOkAction').onclick();
    	}
    	return false;
   	}
}

var clickElement;
var subElement=null;

	return{
		show : function(target,subMenuElement){
			if(subMenuElement!=null && typeof(subMenuElement)!='undefined')
				subElement =subMenuElement;
			
			overlay.style.display='';
			__001.style.display='';	
			target.setAttribute('action','process');
			new Dialog().show('ppopup', 'ppopup_drag', 'screen-center', 0, 0,'');
			if(target!=null && typeof(element)!='undefined')
				clickElement = target;
			document.getElementById('pn_passwd').focus();
			return __001;
		},
		dispose : function(){
			overlay.style.display='none';
			__001.style.display='none';
		}
	}
}