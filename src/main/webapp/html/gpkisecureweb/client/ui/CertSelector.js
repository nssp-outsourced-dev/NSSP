CertSelect = function(isEmbeded,sessionid){
UI = {};

UI.Event = {
		add: function(action,handler){
			 if (button.addEventListener) {  // all browsers except IE before version 9
				 button.addEventListener (action, handler, false);
            }else {
                if (button.attachEvent) {   // IE before version 9
                    button.attachEvent ("on"+action, handler);
                }
            }
		}
} 

document.oncontextmenu = function (){ return false }; 
document.ondragstart = function (){ return false };
document.onselectstart = function (){ return false };
//var pwCountArr = null;
var checkCount = 0;
var storageWidth = "";
var storageImgSize="";
var popupflag = 0;
var embeded = isEmbeded;
var clickElement = document.getElementById('embededlogin');
var selectedIdx = 0;
	loadJavascript(gpkiScriptBase + "/ui/common.js",loadedWin);
		
	
	var firstFocusElement;
	var __001 ;
	if(!isEmbeded){
		__001 = document.createElement("div");
		__001.id = 'popup';
		__001.style.zIndex = '+1';
		__001.style.width='388px';
		__001.style.marginLeft = '0px';
		__001.style.marginTop = '0px';
		__001.style.visibility ='hidden';
		__001.style.textAlign = 'center';
		__001.style.display ='none';
		
		var __002 = document.createElement("div");
		__002.id = 'popup_drag';
		__002.style.backgroundColor='white';
		__002.style.height ='24px';
		__002.style.marginTop = '0px';
		__002.style.marginLeft = '0px';
		__002.style.marginBottom = '0px';
		__002.style.color ='white';
		__002.style.fontSize='14px';
		__002.style.fontFamily='Malgun Gothic, Dotum, Verdana, sans-serif';
		__002.style.background = 'url("' + gpkiScriptBase + '/image/certificate/pop_tit_bg_01.png")';
		__002.appendChild(document.createTextNode(LangCS.title));
		
		var __003 = document.createElement("div");
		__003.style.border = 'solid 0px #F4F4F4';
		__003.style.backgroundColor='#F4F4F4';
		__003.style.height ='17px';
		__003.style.width = '388px';
		__003.style.textAlign = 'right';
		__003.style.marginTop = '0px';
		//__003.style.marginLeft='1px';
		__003.style.marginRight = '0px';
		__003.style.paddingBottom = '3px';
		__003.style.color = '#666';
		__003.style.fonSize = '10px';
		if(versionUse){
			__003.appendChild(document.createTextNode("ver " + GPKISecureWeb.getAPIVersion()));
			
		}else{
			__003.appendChild(document.createTextNode(''));
		}
		
		__001.appendChild(__002);		
		__001.appendChild(init());
		__001.appendChild(__003);
	}else{
		__001 = init();
		__001.style.position = 'relative';
	}
	
	var overlayCS = document.createElement('div');
	var _resizeOverlayFunction;
	overlayCS.style.zIndex = '524287';
    overlayCS.onclick = null;
	
    overlayCS.style.position = 'fixed';		// modified on 2015.08.17
    overlayCS.style.width = '100%';
    overlayCS.style.height = '100%';
	
   	overlayCS.style.top = '0';
    overlayCS.style.left = '0';
    overlayCS.style.opacity = 0.5;
    overlayCS.style.filter = "alpha(opacity='50')";
    overlayCS.style.backgroundColor = 'black';
    
    if(!embeded){
    	document.getElementsByTagName("body")[0].appendChild(overlayCS);
    }
	
	__001.style.zIndex = '524288';
	if(!embeded){
		document.getElementsByTagName("body")[0].appendChild(__001);
	}else{
		try{
			clickElement.appendChild(__001);
		}catch(err){
			alert(err);
		}			
	}
	
var win;
function loadedWin(){
	win = new Dialog();
}	

function createImgCell(state){
	var url = "";
	switch (state) {
	case "0":
		url = gpkiScriptBase + "/image/certificate/cert/on.png";
		break;
	case "1":
		url = gpkiScriptBase + "/image/certificate/cert/off.png";
		break;
	case "2":
		url = gpkiScriptBase + "/image/certificate/cert/limit.png";
		break;

	default:
		break;
	}
	
	var __002_1 = document.createElement("img");
	
	__002_1.setAttribute("src", url);	
	return __002_1;	
}

var selectedRow,mycerts,CertInfo,selecteRowNum, selectedStorageType  ;


function selectRow(srcElement, target){
	if(selectedRow!=null && typeof(selectedRow)!='undefined' && srcElement!=selectedRow)
		selectedRow.setAttribute('selected',false);
	
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
	if(embeded){
		document.getElementById('gpkiEmObj').setAttribute('idx', selectedRow.getAttribute('CertIndex'));
	}
	if(selectedRow == null){
		alert(ErrorMessage.code30020);
		firstFocusElement.focus();
		return;
	}else{
		if(document.getElementById('passwd') !=null 
				&& typeof(document.getElementById('passwd')!='undefined') 
				&& !document.getElementById('passwd').disabled){
			
			document.getElementById('passwd').focus();
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
		setSelectedMark(releaseColumn,'');		
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

function  createSecurityRow(parent,columns,isheader){
	var pElement, totalString,__001;
	totalString = '';
	
	if(isheader){
		pElement = parent;
	}else{
		
		pElement = document.createElement('div');
		pElement.setAttribute('certIndex',parent.childNodes.length);
		pElement.onclick = function(){
			if(selectedRow==this){
				return; 
			}else{
				selectRow(this);
			} 
		};
		
		pElement.onmouseover = function(){
			setReleaseSectedMark(this);
			if(selectedRow==this){
				return;
			}
			this.style.cursor = 'pointer';
			setSelectedMark(this,'#E3E4FA');			
		};
		var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"\s]/gi;
		var issuer = "";
		var temCn = new Array();
		var cn = "";
		var detailResult = JSON.parse(GPKISecureWeb.GetCertDetailInfo(parent.childNodes.length,10)).ResultMessage; 
		var dnArr = new Array();
		dnArr = detailResult.split(',');
		
		for(i=0; i<=dnArr.length; i++){
			cn = dnArr[i].split('=');
			if(cn[0].toLowerCase() == "cn" ){
				cn = cn[1].replace(regExp,"");
				break;
			}
		}
		if(embeded){
			var emColumns = new Array();
			emColumns[0] = columns[0];
			emColumns[1] = columns[1];
			emColumns[2] = columns[4];
			emColumns[3] = Issuer[cn]+columns[3];
			columns = emColumns;
		}else{
			var popColumns = new Array();
			popColumns[0] = columns[0];
			popColumns[1] = columns[1];
			popColumns[2] = columns[4];
			popColumns[3] = columns[3];
			popColumns[4] = Issuer[cn];
			columns = popColumns;
		}
		parent.appendChild(pElement);
	}
	
	var disColumns = new Array();
	for(var i=0; i<columns.length; i++){
		var __003_01 = document.createElement('div');
		__003_01.style.fontSize='11px';
		__003_01.style.color='#666';
		__003_01.style.fontFamily ='Malgun Gothic, Dotum, Verdana, sans-serif';
		__003_01.style.height='17px';
		__003_01.style.position='relative';
		__003_01.style.textOverflow='ellipsis';
		switch(i){
		case 0:
			__003_01.style.width = (!embeded?'28px':'25px');
			disColumns[i] = columns[i];
			break;
		case 1:
			__003_01.style.width = (!embeded?'120px':'113px');
			if(!embeded && columns[i].length>15){
				disColumns[i] = columns[i].substring(0,15)+'..';
			}else if(embeded && columns[i].length>13){
				disColumns[i] = columns[i].substring(0,13)+'..';
			}else{
				disColumns[i] = columns[i];
			}
			break;
		case 2:
			__003_01.style.width = (!embeded?'70px':'70px');
				disColumns[i] = columns[i];
			break;
		case 3:
			__003_01.style.width = (!embeded?'55px':'55px');
			
			if(embeded && columns[i].length>5){
				disColumns[i] = columns[i].substring(0,5);
			}else{
				disColumns[i] = columns[i];
			}
			break;
		case 4:
			if(isheader){
				__003_01.style.width = '65px';
				__003_01.style.textAlign = 'center';
			}else{
				__003_01.style.width = '70px';
				__003_01.style.textAlign = 'left';
			}
			disColumns[i] = columns[i];
			break;

		default:
			break;
		}
		if (browserType == BROWSER_IE){
			__003_01.style.styleFloat = 'left';
		}else{
			__003_01.style.cssFloat = 'left';
		}
		__003_01.style.overflow = 'hidden';
		__003_01.style.whiteSpace = 'nowrap';
		__003_01.style.fontSize = (!embeded?'11px':'10px');
		
		if(i==0 && !isheader){
			var imgElement = document.createElement('input');
			imgElement.setAttribute('type','image');
			var imgNames = 'cert';
			if(disColumns[i]<3){
				imgNames += '_1024';
				imgNames += (disColumns[i]==0)?'_v':(disColumns[i]==1)?'_u':(disColumns[i]==2)?'_e':'';
			}else{
				imgNames += '_2048';
				imgNames += (disColumns[i]==3)?'_v':(disColumns[i]==4)?'_u':(disColumns[i]==5)?'_e':'';
			}			
			
			imgElement.setAttribute('src', gpkiScriptBase + '/image/certificate/cert/'+imgNames+'.bmp');
			imgElement.style.height='0px';
			imgElement.style.width='0px';
			imgElement.style.padding='0px';	// added on 2015.08.17

			__003_01.style.backgroundImage='url("'+gpkiScriptBase +'/image/certificate/cert/'+imgNames+'.bmp")' ;
			__003_01.style.backgroundRepeat='no-repeat';
			__003_01.style.backgroundSize='18px 13px'; 
			__003_01.style.backgroundPosition='4px 0px';			

			imgElement.onclick = function(){
				if(selectedRow==this.parentNode.parentNode){
					return; 
				}else{
					selectRow(this.parentNode.parentNode);
				} 
			};
			imgElement.onfocus = function(){
				setReleaseSectedMark(this.parentNode.parentNode);
				var certInfo = '';
				if(selectedRow!=null && selectedRow==this.parentNode.parentNode){
					certInfo = selectedRow.getAttribute('alt');
					if(certInfo.indexOf(LangCS.selectedCert)==-1){
						var altName = LangCS.selectedCert+certInfo;
						this.setAttribute('alt',altName);						
						this.parentNode.parentNode.setAttribute('alt',altName);							
					}
					return;
				}else if(selectedRow!=null && selectedRow!=this.parentNode.parentNode){
					certInfo = this.getAttribute('alt');
					certInfo=  certInfo.replace(LangCS.selectedCert,'');
					this.setAttribute('alt',certInfo);							
					this.parentNode.parentNode.setAttribute('alt',certInfo);							
				}
				setSelectedMark(this.parentNode.parentNode,'#E3E4FA');				
			};							
				
			__001 = imgElement; 
			__003_01.appendChild(imgElement);
		}else{
			if(i!=5){
				__003_01.appendChild(document.createTextNode(disColumns[i]));
			}
		}
		
		if(i!=5){
			var enter = (i==4)?"":"\n";
			if(i==0){
				var strStaus = (columns[i]==0)?LangCS.vCertStat1024:(columns[i]==1)?LangCS.uCertStat1024:(columns[i]==2)?LangCS.eCertStat1024:(columns[i]==3)?LangCS.vCertStat2048:(columns[i]==4)?LangCS.uCertStat2048:(columns[i]==5)?LangCS.eCertStat2048:"";
				strStaus +='\n ';
				totalString += strStaus+enter;
			}else{
				totalString += columns[i]+enter;
			}
		}
		
		pElement.appendChild(__003_01);
		
		if(i!=(columns.length-1)){
			var __003_02 = document.createElement('div');
			if (browserType == BROWSER_IE){
				__003_02.style.styleFloat = 'left';
			}else{
				__003_02.style.cssFloat = 'left';
				__003_02.innerHTML = '&nbsp';
			}
			__003_02.style.backgroundColor = '#BBB';
			__003_02.style.width='1px';			
			pElement.appendChild(__003_02);		
		}else{
			var __003_02 = document.createElement('div');
			__003_02.style.clear = 'both';
			pElement.appendChild(__003_02);
			
		}	
	}
	
	if(__001 !=null && typeof(__001)!='undefined'){
		if(pElement.parentNode.childNodes.length==1){
			var datalistDesc = ((popupflag==1)?LangCS.description:'')+LangCS.description2;
			totalString = datalistDesc+totalString;
			popupflag = (popupflag==1)?2:popupflag;
		}		
		__001.setAttribute('alt', totalString);
		__001.setAttribute('title', totalString);
	}
		
	pElement.setAttribute('alt', totalString);
	pElement.setAttribute('title', totalString);
}

function onTableRefresh(StorageElement,certlist){
	checkCount = 0;
	pwCountArr = new Array();
	var tbody = document.getElementById("dataList");
	if ( tbody.hasChildNodes() ){
	    while ( tbody.childNodes.length >= 1 ){
	    	tbody.removeChild( tbody.firstChild );       
	    } 
	}
	
	for(var i=0;i<certlist.length;i++){
		createSecurityRow(tbody,certlist[i],false);
	}
	
	if(certlist.length !=0){
		tbody.childNodes[0].getElementsByTagName('input')[0].focus();
	}
}

function stringToArray(str){
	var mycerts = new Array();
	mycerts = str.split('\$');		
	return mycerts; 
}

var dummy=0;
function runKeyboardSec(){
	if(selectedRow == null){
		alert(ErrorMessage.code30020);
		firstFocusElement.focus();
		return;
	}
	
	if(!embeded){
		document.getElementById('passwd').value='';
		var vkeyObj = document.getElementById('vkeyboard');
		if(vkeyObj==null || typeof(vkeyObj)=='undefined'){
			new vKeyboard(dummy++,document.getElementById('passwd'),encfunc,sessionid).show();
		}else{
			document.getElementById('passwd').disabled = true;
			vkeyObj.style.display='';			
		}
	}
}

function init(){

	var __001_i = document.createElement("DIV");
	__001_i.id = 'gpkiEmObj';
	__001_i.style.border = 'solid 0px #CCC';	
	__001_i.style.padding = (!embeded?'15px 0px 5px 0px':'0px 0px 0px 0px');	
	__001_i.style.width= (!embeded?'388px':'285px');
	__001_i.style.margin='0px';
	__001_i.style.backgroundColor='#F4F4F4';
	
	if(isEmbeded){
		__001 = __001_i; 	
	}
	if(!embeded){
		var __002 = document.createElement("DIV");
		var __002_1 = document.createElement("img");
		
		__002_1.style.width= '369px';
		__002_1.style.height='75px';
		__002_1.style.marginTop='0px';
		__002_1.style.marginLeft='0px';
		__002_1.setAttribute("src", gpkiScriptBase + LogoURL);
		__002.appendChild(__002_1);	
		__001_i.appendChild(__002);
	}

	var __003 = document.createElement("DIV");
	__003.style.border = 'dashed 1px #F4F4F4';
	__003.style.textAlign='left';
	__003.style.height='100px';	
			
	var __003_1 = document.createElement("SPAN");
	__003_1.style.position = 'absolute';
	__003_1.style.height = '20px';
	__003_1.style.borderRadius ='6px';
	__003_1.style.fontSize ='12px';
	__003_1.style.textAlign='left';
	__003_1.style.padding = '0px 5px 0px 5px';
	__003_1.style.marginLeft='20px';	
	__003_1.style.marginTop='1px';
	
	var __003_2 = document.createElement("ul");
	__003_2.id = 'storages';
	__003_2.style.width= (!embeded?'369px':'285px');
	__003_2.style.listStyle = 'none';
	__003_2.style.backgroundColor = 'white';
	__003_2.style.listPosition = 'outside';
	__003_2.style.listImage = 'none';
	__003_2.style.border = 'solid 1px #BBB';	
	__003_2.style.borderRadius = '6.0px';	
	__003_2.style.marginTop=(!embeded?'12px':'0px');	
	__003_2.style.marginBottom=(!embeded?'8px':'0px');	
	__003_2.style.marginLeft=(!embeded?'8px':'0px');	
	__003_2.style.padding = (!embeded?'5.0px 0.0px 5.0px 0.0px':'0.0px');	
	
	var __003_2_0 = document.createElement('li');
	if (browserType == BROWSER_IE){
		__003_2_0.style.styleFloat = 'left';
	}
	else{
		__003_2_0.style.cssFloat = 'left';
	}
	__003_2_0.style.position = 'relative';
	
	
	var __003_2_1 = document.createElement('div');
	__003_2_1.style.zIndex ='+1';
	__003_2_1.style.marginTop = '3px';
	__003_2_1.style.padding = '0.0px';
	__003_2_1.style.marginLeft='5px';
	
	if(storageCount == 6) {
		var imgNames = ['move6','hdd6','token6','smart6','usim6','mobile6'];
		storageWidth = (!embeded?'58px':'45px');
		storageImgSize=(!embeded?'51px':'46px');
	}else{
		var imgNames = ['move','hdd','token','smart','usim'];
		storageWidth = (!embeded?'68px':'53px');
		storageImgSize=(!embeded?'57px':'51px');
	}
	
	//removableDisk
	var __003_2_1_0 = document.createElement('button');
	__003_2_1_0.style.border = 'solid 1px white';
	__003_2_1_0.id ='removeBtn';
	__003_2_1_0.style.backgroundColor = 'white';
	__003_2_1_0.setAttribute('alt',LangCS.removableDisk);
	__003_2_1_0.setAttribute('title',LangCS.removableDisk);
	//__003_2_1_0.style.width=(!embeded?'58px':'45px');
	__003_2_1_0.style.width= storageWidth;
	__003_2_1_0.style.padding = '0.0px';	
	if(!embeded){
		if(storageCount == 5){
			__003_2_1_0.style.marginLeft = '10px';	
		}else if(storageCount == 6){
			__003_2_1_0.style.marginLeft = '3px';	
		}
	}
	__003_2_1_0.onclick = function(){
		// cert List delete_121018 by jLion
		if(!embeded){
			document.getElementById("attachTarget").firstChild.innerHTML=LangCS.CertPassword;
		}
		selecteRowNum = null;
		if(document.getElementById("dataList").hasChildNodes()){
			var tbody = document.getElementById("dataList");
			if ( tbody.hasChildNodes() ){
			    while ( tbody.childNodes.length >= 1 ){
			    	tbody.removeChild( tbody.firstChild );       
			    } 
			}			
		}	
				
		var imgList = document.getElementById('storages').getElementsByTagName('img');
		for(var i=0; i<imgList.length;i++){
			imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_n'+(!embeded?'':'_em')+'.bmp');
			if(smartCertUse == false && i == 4){
				imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
			}
			if(mobileUse == false && i == 5){
				imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
			}
		}
		this.getElementsByTagName('img')[0].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[0]+'_p'+(!embeded?'':'_em')+'.bmp');
		var focusColumn = onRemovableList(this.parentNode); 
		if(focusColumn!=null){
			focusColumn.focus();
		}
	};
	__003_2_1_0.onfocus = function(){
		var imgName = this.getElementsByTagName('img')[0].getAttribute('src');
		if(imgName.indexOf('_p')>-1){
			imgName = LangCS.removableDisk+LangCS.description3;					
		}else{
			imgName = LangCS.removableDisk;
		}
		this.getElementsByTagName('img')[0].setAttribute('alt',imgName);
		this.setAttribute('alt',imgName);
		this.setAttribute('title',imgName);				
	}		
	__003_2_1.appendChild(__003_2_1_0);
	
	var __003_2_1_1 = document.createElement('img');
	__003_2_1_1.style.verticalAlign = 'middle';
	__003_2_1_1.style.border = '0.0px';	
	__003_2_1_1.style.padding = '0.0px';	
	
	// added by gomsugy. 2015.08.26
	__003_2_1_1.style.width= storageImgSize;
	__003_2_1_1.style.height=(!embeded?'60px':'52px');
	__003_2_1_1.setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[0]+'_n'+(!embeded?'':'_em')+'.bmp');
	__003_2_1_1.setAttribute('alt',LangCS.removableDisk);
	__003_2_1_1.onmouseover = function(){	this.style.cursor = 'pointer';	};
	
	__003_2_1_0.appendChild(__003_2_1_1);
	__003_2_0.appendChild(__003_2_1);
	
	//smartCart
	var __003_2_2 = document.createElement('li');
	if (browserType == BROWSER_IE){
		__003_2_2.style.styleFloat = 'left';
	}else{
		__003_2_2.style.cssFloat = 'left';
	}
	__003_2_2.style.position = 'relative';
		
	var __003_2_2_0 = document.createElement('div');
	__003_2_2_0.style.marginTop = '3.0px';	
	__003_2_2_0.style.marginLeft='0px';
	__003_2_2_0.style.padding = '0.0px';
	
	var __003_2_2_1 = document.createElement('button');
	__003_2_2_1.style.border = 'solid 1px white';
	__003_2_2_1.style.backgroundColor = 'white';
	__003_2_2_1.id ='smartBtn';
	//__003_2_2_1.style.width=(!embeded?'58px':'45px');
	__003_2_2_1.style.width= storageWidth;
	__003_2_2_1.style.padding = '0px 0px 0px 0px';
	__003_2_2_1.setAttribute('alt',LangCS.smartCard);
	__003_2_2_1.setAttribute('title',LangCS.smartCard);
	__003_2_2_1.style.padding = '0.0px';
	__003_2_2_1.setAttribute('action','ready');
	__003_2_2_1.onclick = function(e){
		// cert List delete_121018 by jLion
		if(!embeded){
			document.getElementById("attachTarget").firstChild.innerHTML=LangCS.CertPassword;
		}
		selecteRowNum = null;
		if(document.getElementById("dataList").hasChildNodes()){
			var tbody = document.getElementById("dataList");
			if ( tbody.hasChildNodes() ){
			    while ( tbody.childNodes.length >= 1 ){
			    	tbody.removeChild( tbody.firstChild );       
			    } 
			}			
		}		
		
		var imgList = document.getElementById('storages').getElementsByTagName('img');
		for(var i=0; i<imgList.length;i++){
			imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_n'+(!embeded?'':'_em')+'.bmp');
			if(smartCertUse == false && i == 4){
				imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
			}
			if(mobileUse == false && i == 5){
				imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
			}
		}
		this.getElementsByTagName('img')[0].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[3]+'_p'+(!embeded?'':'_em')+'.bmp');
		
		var focusElement = onSMTokenCertList(this.parentNode);
		if(focusElement != null && focusElement != ""){
			focusElement.focus();
		}
	};
	
	__003_2_2_1.onfocus = function(){
				var imgName = this.getElementsByTagName('img')[0].getAttribute('src');
				
				if(imgName.indexOf('_p')>-1){
					imgName = LangCS.smartCard+LangCS.description3;					
				}else{
					imgName = LangCS.smartCard;
				}
				
				this.getElementsByTagName('img')[0].setAttribute('alt',imgName);
				this.setAttribute('alt',imgName);
				this.setAttribute('title',imgName);				
			}		
	
	var __003_2_2_2 = document.createElement('img');
	__003_2_2_2.style.verticalAlign = 'middle';
	__003_2_2_2.style.border = '0.0px';	
	__003_2_2_2.style.padding = '0.0px';
	
	// added by gomsugy. 2015.08.26
	__003_2_2_2.style.width= storageImgSize;
	__003_2_2_2.style.height=(!embeded?'60px':'52px');
	__003_2_2_2.setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[3]+'_n'+(!embeded?'':'_em')+'.bmp');
	__003_2_2_2.setAttribute('title',LangCS.smartCard);
	__003_2_2_1.appendChild(__003_2_2_2);
	__003_2_2_0.appendChild(__003_2_2_1);
	__003_2_2.appendChild(__003_2_2_0);
	
	//token
	var __003_2_3 = document.createElement('li');
	if (browserType == BROWSER_IE){
		__003_2_3.style.styleFloat = 'left';
	}else{
		__003_2_3.style.cssFloat = 'left';
	}
	__003_2_3.style.position = 'relative';
	
	var __003_2_3_0 = document.createElement('div');
	__003_2_3_0.style.marginTop = '3.0px';	
	__003_2_3_0.style.marginLeft='0px';
	__003_2_3_0.style.padding = '0.0px';
	__003_2_3_0.style.marginLeft=(!embeded?'7px':'7px');
	
	var __003_2_3_1 = document.createElement('button');
	__003_2_3_1.style.border = 'solid 1px white';
	__003_2_3_1.style.backgroundColor = 'white';
	__003_2_2_1.id ='token';
	//__003_2_3_1.style.width=(!embeded?'58px':'45px');
	__003_2_3_1.style.width= storageWidth;
	__003_2_3_1.setAttribute('action','ready');
	__003_2_3_1.setAttribute('alt',LangCS.SecureToken);
	__003_2_3_1.setAttribute('title',LangCS.SecureToken);
	__003_2_3_1.style.padding = '0.0px';
	__003_2_3_1.setAttribute('action','ready');
	__003_2_3_1.onclick = function(event){
		if(!embeded){
			document.getElementById("attachTarget").firstChild.innerHTML=LangCS.TokenPinNumber;
		}
		// cert List delete_121018 by jLion
		selecteRowNum = null;
		if(document.getElementById("dataList").hasChildNodes()){
			var tbody = document.getElementById("dataList");
			if ( tbody.hasChildNodes() ){
			    while ( tbody.childNodes.length >= 1 ){
			    	tbody.removeChild( tbody.firstChild );       
			    } 
			}			
		}		
		
		var imgList = document.getElementById('storages').getElementsByTagName('img');
		for(var i=0; i<imgList.length;i++){
			imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_n'+(!embeded?'':'_em')+'.bmp');
			if(smartCertUse == false && i == 4){
				imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
			}
			if(mobileUse == false && i == 5){
				imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
			}
		}
		this.getElementsByTagName('img')[0].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[2]+'_p'+(!embeded?'':'_em')+'.bmp');
		
		event = event||window.event;
		var target = event.target||event.srcElement;
		
		onSeTokenCertList(event);
		

	};	
	__003_2_3_1.onfocus = function(){
				var imgName = this.getElementsByTagName('img')[0].getAttribute('src');
				
				if(imgName.indexOf('_p')>-1)
					imgName = LangCS.SecureToken+LangCS.description3;					
				else
					imgName = LangCS.SecureToken;
				
				this.getElementsByTagName('img')[0].setAttribute('alt',imgName);
				this.setAttribute('alt',imgName);
				this.setAttribute('title',imgName);				
			}		
	
	var __003_2_3_2 = document.createElement('img');
	__003_2_3_2.style.verticalAlign = 'middle';
	__003_2_3_2.style.border = '0.0px';	
	__003_2_3_2.style.padding = '0.0px';	

	// added by gomsugy. 2015.08.26
	__003_2_3_2.style.width= storageImgSize;
	__003_2_3_2.style.height=(!embeded?'60px':'52px');
	__003_2_3_2.setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[2]+'_n'+(!embeded?'':'_em')+'.bmp');
	__003_2_3_2.setAttribute('title',LangCS.SecureToken);
	__003_2_3_0.appendChild(__003_2_3_1);
	__003_2_3_1.appendChild(__003_2_3_2);
	__003_2_3.appendChild(__003_2_3_0);
	
	//hardDisk
	var __003_2_4 = document.createElement('li');
	if (browserType == BROWSER_IE){
		__003_2_4.style.styleFloat = 'left';
	}else{
		__003_2_4.style.cssFloat = 'left';
	}
	__003_2_4.style.position = 'relative';
	
	var __003_2_4_0 = document.createElement('div');
	__003_2_4_0.style.marginTop = '3.0px';	
	__003_2_4_0.style.marginLeft='0px';
	__003_2_4_0.style.padding = '0.0px';
	
	var __003_2_4_1 = document.createElement('button');
	__003_2_4_1.style.border = 'solid 1px white';
	__003_2_4_1.style.backgroundColor ='white';
	__003_2_4_1.style.width=(!embeded?'58px':'45px');
	__003_2_4_1.setAttribute('alt',LangCS.HardDisk );
	__003_2_4_1.setAttribute('title',LangCS.HardDisk);
	__003_2_4_1.style.padding = '0.0px';	
	__003_2_4_1.onclick = function(){
		// cert List delete_121018 by jLion
		if(!embeded){
			document.getElementById("attachTarget").firstChild.innerHTML=LangCS.CertPassword;
		}
		selecteRowNum = null;
		if(document.getElementById("dataList").hasChildNodes()){
			var tbody = document.getElementById("dataList");
			if ( tbody.hasChildNodes() ){
			    while ( tbody.childNodes.length >= 1 ){
			    	tbody.removeChild( tbody.firstChild );       
			    } 
			}			
		}
		var imgList = document.getElementById('storages').getElementsByTagName('img');
		for(var i=0; i<imgList.length;i++){
			imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_n'+(!embeded?'':'_em')+'.bmp');
			if(smartCertUse == false && i == 4){
				imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
			}
			if(mobileUse == false && i == 5){
				imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
			}
		}
		this.getElementsByTagName('img')[0].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[1]+'_p'+(!embeded?'':'_em')+'.bmp');
		
		OnHddCertList(this);
			
		//~! added by gomsugy. 2016.01.13.
		// select first element of CertList
		var certList = document.getElementById("dataList");
		if (certList.hasChildNodes())
			certList.childNodes[0].onclick();
		};
		__003_2_4_1.onfocus = function(){
				var imgName = this.getElementsByTagName('img')[0].getAttribute('src');
				
				if(imgName.indexOf('_p')>-1){
					imgName = LangCS.HardDisk+ LangCS.description3;					
				}else{
					imgName = LangCS.HardDisk;
				}
				
				this.getElementsByTagName('img')[0].setAttribute('alt',imgName);
				this.setAttribute('alt',imgName);
				this.setAttribute('title',imgName);				
			}	
	firstFocusElement = __003_2_4_1;
	
	var __003_2_4_2 = document.createElement('img');	
	__003_2_4_2.style.verticalAlign = 'middle';
	__003_2_4_2.style.border = '0.0px';	
	__003_2_4_2.style.padding = '0.0px';	
	// added by gomsugy. 2015.08.26
	__003_2_4_2.style.width= storageImgSize;
	__003_2_4_2.style.height=(!embeded?'60px':'52px');
	__003_2_4_2.setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[1]+'_n'+(!embeded?'':'_em')+'.bmp');	
	__003_2_4_2.setAttribute('title',LangCS.HardDisk);
	__003_2_4_0.appendChild(__003_2_4_1);
	__003_2_4_1.appendChild(__003_2_4_2);
	__003_2_4.appendChild(__003_2_4_0);
	
	//mobile
	var __003_2_5 = document.createElement('li');
	if (browserType == BROWSER_IE){
		__003_2_5.style.styleFloat = 'left';
	}else{
		__003_2_5.style.cssFloat = 'left';
	}
	__003_2_5.style.position = 'relative';	
	
	var __003_2_5_0 = document.createElement('div');
	__003_2_5_0.style.marginTop = '3.0px';	
	__003_2_5_0.style.marginLeft=(!embeded?'3px':'0px');
	__003_2_5_0.style.padding = '0.0px';
	if(mobileUse == true){
		var __003_2_5_1 = document.createElement('button');
		__003_2_5_1.id = 'mobile';
		//__003_2_5_1.style.width=(!embeded?'58px':'45px');
		__003_2_5_1.style.width=storageWidth;
		__003_2_5_1.style.border = 'solid 1px white';
		__003_2_5_1.style.backgroundColor = 'white';
		
		__003_2_5_1.setAttribute('alt',LangCS.Phone);
		__003_2_5_1.setAttribute('title',LangCS.Phone);
		__003_2_5_1.style.padding = '0.0px';	
		__003_2_5_1.onclick = function(){
			if(!embeded){
				document.getElementById("attachTarget").firstChild.innerHTML=LangCS.CertPassword;
			}
			if(navigator.userAgent.indexOf('Windows')==-1){
				alert(ErrorMessage.code30012);
				return;
			}else if(phoneOpt == 0)			{
				alert(ErrorMessage.code70009);
				return;
			}
				
			// cert List delete_121018 by jLion
			selecteRowNum = null;
			if(document.getElementById("dataList").hasChildNodes()){
				var tbody = document.getElementById("dataList");
				if ( tbody.hasChildNodes() ){
				    while ( tbody.childNodes.length >= 1 ){
				    	tbody.removeChild( tbody.firstChild );       
				    } 
				}			
			}
			// [Disabled access]
			__003_2_5_1.onfocus = function(){
					var imgName = this.getElementsByTagName('img')[0].getAttribute('src');
					
					if(imgName.indexOf('_p')>-1){
						imgName = LangCS.Phone+LangCS.description3;					
					}else{
						imgName = LangCS.Phone;
					}
					
					this.getElementsByTagName('img')[0].setAttribute('alt',imgName);
					this.setAttribute('alt',imgName);
					this.setAttribute('title',imgName);				
				}	
			var imgList = document.getElementById('storages').getElementsByTagName('img');
			for(var i=0; i<imgList.length;i++){
				imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_n'+(!embeded?'':'_em')+'.bmp');
				if(smartCertUse == false && i == 4){
					imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
				}
				if(mobileUse == false && i == 5){
					imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
				}
			}
			this.getElementsByTagName('img')[0].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[5]+'_p'+(!embeded?'':'_em')+'.bmp');
			
			var focusElement = onPhoneCertList(this.parentNode);
			focusElement.focus();		
		};
	}else{
		var __003_2_5_1 = document.createElement('div');
		__003_2_5_1.id = 'mobile';
		//__003_2_5_1.style.width=(!embeded?'58px':'45px');
		__003_2_5_1.style.width=storageWidth;
		__003_2_5_1.style.border = 'solid 1px white';
		__003_2_5_1.style.backgroundColor = 'white';
		
		__003_2_5_1.setAttribute('alt',LangCS.Phone);
		__003_2_5_1.setAttribute('title',LangCS.Phone);
		__003_2_5_1.style.padding = '0.0px';	
	}
	__003_2_5_0.appendChild(__003_2_5_1);
	
	var __003_2_6 = document.createElement('img');	
	__003_2_6.style.verticalAlign = 'middle';
	__003_2_6.style.border = '0.0px';
	__003_2_6.style.padding = '0.0px';	
	// added by gomsugy. 2015.08.26
	__003_2_6.style.width= storageImgSize;
	__003_2_6.style.height=(!embeded?'60px':'52px');
	__003_2_6.setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[5]+'_n'+(!embeded?'':'_em')+'.bmp');
	__003_2_6.setAttribute('title',LangCS.Phone);
	__003_2_6.onmouseover = function(){	this.style.cursor = 'pointer';	};

	__003_2_5_1.appendChild(__003_2_6);
	__003_2_5.appendChild(__003_2_5_0);
	
	//add storage (smartCert)
	var __003_2_8 = document.createElement('li');
	if (browserType == BROWSER_IE){
		__003_2_8.style.styleFloat = 'left';
	}else{
		__003_2_8.style.cssFloat = 'left';
	}
	__003_2_8.style.position = 'relative';
	
	var __003_2_8_0 = document.createElement('div');
	__003_2_8_0.style.marginTop = '3.0px';	
	__003_2_8_0.style.marginLeft='0px';
	__003_2_8_0.style.padding = '0.0px';
	
	if(smartCertUse == true){
	var __003_2_8_1 = document.createElement('button');
	__003_2_8_1.style.border = 'solid 1px white';
	__003_2_8_1.style.backgroundColor ='white';
	__003_2_8_1.style.width= storageWidth;
	__003_2_8_1.setAttribute('alt',LangCS.SmartCert );
	__003_2_8_1.setAttribute('title',LangCS.SmartCert);
	__003_2_8_1.style.padding = '0.0px';	
	__003_2_8_1.onclick = function(){
		// cert List delete_121018 by jLion
		if(!embeded){
			document.getElementById("attachTarget").firstChild.innerHTML=LangCS.CertPassword;
		}
		selecteRowNum = null;
		if(document.getElementById("dataList").hasChildNodes()){
			var tbody = document.getElementById("dataList");
			if ( tbody.hasChildNodes() ){
			    while ( tbody.childNodes.length >= 1 ){
			    	tbody.removeChild( tbody.firstChild );       
			    } 
			}			
		}
		var imgList = document.getElementById('storages').getElementsByTagName('img');
		for(var i=0; i<imgList.length;i++){
			imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_n'+(!embeded?'':'_em')+'.bmp');
			if(smartCertUse == false && i == 4){
				imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
			}
			if(mobileUse == false && i == 5){
				imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_d'+(!embeded?'':'_em')+'.bmp');
			}
		}
		this.getElementsByTagName('img')[0].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[4]+'_p'+(!embeded?'':'_em')+'.bmp');
		
		smartCertList(this);
		};
		__003_2_8_1.onfocus = function(){
				var imgName = this.getElementsByTagName('img')[0].getAttribute('src');
				
				if(imgName.indexOf('_p')>-1){
					imgName = LangCS.SmartCert+LangCS.description3;					
				}else{
					imgName = LangCS.SmartCert;
				}
				
				this.getElementsByTagName('img')[0].setAttribute('alt',imgName);
				this.setAttribute('alt',imgName);
				this.setAttribute('title',imgName);				
			}
	}else{
		var __003_2_8_1 = document.createElement('div');
		__003_2_8_1.style.border = 'solid 1px white';
		__003_2_8_1.style.backgroundColor ='white';
		__003_2_8_1.style.width= storageWidth;
		__003_2_8_1.setAttribute('alt',LangCS.SmartCert );
		__003_2_8_1.setAttribute('title',LangCS.SmartCert);
		__003_2_8_1.style.padding = '0.0px';	
	}
	var __003_2_8_2 = document.createElement('img');	
	__003_2_8_2.style.verticalAlign = 'middle';
	__003_2_8_2.style.border = '0.0px';	
	__003_2_8_2.style.padding = '0.0px';	
	// added by gomsugy. 2015.08.26
	__003_2_8_2.style.width= storageImgSize;
	__003_2_8_2.style.height=(!embeded?'60px':'52px');
	__003_2_8_2.setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[4]+'_n'+(!embeded?'':'_em')+'.bmp');	
	__003_2_8_2.setAttribute('title',LangCS.SmartCert);
	__003_2_8_0.appendChild(__003_2_8_1);
	__003_2_8_1.appendChild(__003_2_8_2);
	__003_2_8.appendChild(__003_2_8_0);
	
	//==========================================================================================================
	__003_2.appendChild(__003_2_0);//move disk
	__003_2.appendChild(__003_2_4);//hdd
	__003_2.appendChild(__003_2_3);//token
	__003_2.appendChild(__003_2_2);//smart card
	__003_2.appendChild(__003_2_8);//smart cert
	if(storageCount == 6){
		__003_2.appendChild(__003_2_5);//mobile
	}
	
	var __003_2_7 = document.createElement('div');
	__003_2_7.style.clear = 'both';
	__003_2_7.style.marginTop = '0px';
	__003_2_7.style.marginBottom = '0px';
	__003_2.appendChild(__003_2_7);	
	
	__003.appendChild(__003_1);	
	__003.appendChild(__003_2);
	
	var __004 = document.createElement("DIV");
		
	__004.style.textAlign='left';
	__004.style.height=(!embeded?'130px':'80px');	
	__004.style.marginTop='0px';
		
	var __004_10 = document.createElement("div");
	__004_10.style.width= (!embeded?'369px':'285px');
	__004_10.style.border = (!embeded?'solid 1px #D1D1D1':'solid 0px #D1D1D1');
	__004_10.style.fontSize = '12px';
	__004_10.style.marginLeft=(!embeded?'8px':'0px');
	__004_10.style.fontFamily ='Malgun Gothic, Dotum, Verdana, sans-serif';
	__004_10.style.color = '#474747';
	__004_10.style.textAlign='center';
	__004.appendChild(__004_10);	
		
	var headerName ;
	if(!embeded){
		headerName = [LangCS.CertStat,LangCS.CertOwner,LangCS.CertExDatae,LangCS.CertUsage, LangCS.CertIssuer];
	}else{
		headerName = [LangCS.CertStat,LangCS.CertOwner,LangCS.CertExDatae,LangCS.CertUsage];
	}
	createSecurityRow(__004_10,headerName,true);
	
	var __004_11 = document.createElement("div");
	__004_11.id = 'dataList';
	__004_11.style.border = (!embeded?'solid 1px #D1D1D1':'solid 0px #D1D1D1');
	__004_11.style.height=(!embeded?'100px':'60px');
	__004_11.style.width= (!embeded?'369px':'285px');
	__004_11.style.backgroundColor = 'white';
	__004_11.style.marginLeft=(!embeded?'8px':'0px');
	__004_11.style.textAlign='left';
	__004_11.style.overflowX = "hidden";
	__004_11.style.fontSize = '8px';
	__004_11.style.overflowY = "scroll";
	__004.appendChild(__004_11);	
		
	var __005 = document.createElement("DIV");
	__005.style.marginLeft='0px';
	__005.style.textAlign='left';
	
	var __005_1 = document.createElement("DIV");
	__005_1.style.textAlign='left';
	__005_1.style.marginTop='3px';
	__005_1.style.marginBottom='7px';
	__005_1.style.marginLeft='8px';
	__005_1.style.width= '371px';
	
	var __005_1_1 = document.createElement('div');
	__005_1_1.style.width = '290px';
	__005_1_1.style.marginTop = '3px';
	if (browserType == BROWSER_IE){
		__005_1_1.style.styleFloat = 'left';
	}else{
		__005_1_1.style.cssFloat = 'left';
	}
	
	__005_1_1.style.padding = '0px 0px 0px 0px';
	__005_1_1.style.marginLeft = '0px';
	__005_1_1.style.color = '#3C4988';
	__005_1_1.style.fontSize='12px';
	__005_1_1.style.fontFamily = 'Malgun Gothic, Dotum, Verdana, sans-serif';
	__005_1_1.appendChild(document.createTextNode(LangCS.CertSearch));
	__005_1.appendChild(__005_1_1);
	
	var __005_1_2 = document.createElement('div');
	if (browserType == BROWSER_IE){
		__005_1_2.style.styleFloat = 'left';
	}else{
		__005_1_2.style.cssFloat = 'left';
	}
	__005_1_2.style.width = '81px';
	__005_1_2.style.marginLeft = '0px';
	__005_1_2.style.textAlign = 'right';
	
	var __005_1_2_1 = document.createElement('BUTTON');
	__005_1_2_1.setAttribute('title', LangCS.FindStat);
	__005_1_2_1.style.background = 'url("' + gpkiScriptBase + '/image/certificate/btn_search.png")';
	__005_1_2_1.style.border = '0px solid gray';
	__005_1_2_1.id='searchBtn';
	__005_1_2_1.onmouseover = function(){
		this.style.cursor = 'pointer';
	}
	__005_1_2_1.style.width = '70.0px';
	__005_1_2_1.style.height = '20.0px';
	__005_1_2_1.style.marginTop ='0px';
	__005_1_2_1.onclick = function(event){
		event = event||window.event;
		var imgList = document.getElementById('storages').getElementsByTagName('img');
		for(var i=0; i<imgList.length;i++){
			imgList[i].setAttribute('src', gpkiScriptBase + '/image/certificate/'+imgNames[i]+'_n.bmp');
		}
		
		loadJavascript(gpkiScriptBase + "/ui/CertSearchWindow.js",onPKCS12FileDialog,event);
	};
	
	__005_1_2.appendChild(__005_1_2_1);
	__005_1.appendChild(__005_1_2);
	
	var __005_1_3 = document.createElement('div');
	__005_1_3.style.clear = 'both';
	__005_1.appendChild(__005_1_3);
	__005.appendChild(__005_1);
	
	var __005_2 = document.createElement("DIV");
	__005_2.id = 'passwdArea';
	__005_2.id = 'attachTarget';
	__005_2.style.padding = '0px 0px 0px 0px';
	__005_2.style.marginLeft='8px';
	__005_2.style.width= '371px';
	
	var __005_2_1 = document.createElement('div');
	__005_2_1.style.padding = '0px 0px 0px 0px';
	//__005_2_1.style.marginTop = '5px';
	__005_2_1.style.width = '30%';
	if (browserType == BROWSER_IE){
		__005_2_1.style.styleFloat = 'left';
	}else{
		__005_2_1.style.cssFloat = 'left';
	}
	__005_2_1.style.fontFamily = 'Malgun Gothic, Dotum, Verdana, sans-serif';
	__005_2_1.style.fontSize ='12px';
	__005_2_1.appendChild(document.createTextNode(LangCS.CertPassword));
	__005_2.appendChild(__005_2_1);
	
	var __005_2_2 = document.createElement('form');
	__005_2_2.style.textAlign = 'right';
	__005_2_2.name = 'passwdForm';
	__005_2_2.onsubmit = function(){return false};
	__005_2_2.style.width = '70%';
	__005_2_2.style.padding = '0px 0px 0px 0px';
	if (browserType == BROWSER_IE){
		__005_2_2.style.styleFloat = 'left';
	}else{
		__005_2_2.style.cssFloat = 'left';
	}
	
	var __005_2_1 = document.createElement('div');
	
	var __005_2_2_1 = document.createElement('INPUT');
	__005_2_2_1.style.width = '100%';
	__005_2_2_1.setAttribute("npkencrypt","re");
	__005_2_2_1.setAttribute('type', 'password');
	__005_2_2_1.id='passwd';
	__005_2_2_1.name='passwd';
	__005_2_2_1.onclick=function(event){
		gpSessionId =sessionid;
		event = event||window.event;
		if(keysecOpt==1){
			loadJavascript(gpkiScriptBase + '/ui/vKeyboardWindow.js',runKeyboardSec);
		}
	};
	__005_2_2_1.onfocus=function(event){
		gpSessionId =sessionid
		if(keysecOpt==1){
			loadJavascript(gpkiScriptBase + '/ui/vKeyboardWindow.js',runKeyboardSec);
		}
	};
	__005_2_2_1.onkeypress=pwdEnterEvent;
	__005_2_2.appendChild(__005_2_2_1);
	__005_2.appendChild(__005_2_2);	
		
	var __005_2_3 = document.createElement('div');
	__005_2_3.style.clear = 'both';
	__005_2.appendChild(__005_2_3);
	__005.appendChild(__005_2);
	
	var __006 = document.createElement("DIV");
	__006.style.width= '371px';
	__006.style.height='30px';
	__006.style.marginTop='8px';
	__006.style.marginLeft='8px';
	__006.style.textAlign='center';
	
	var __006_1 = document.createElement('BUTTON');	
	__006_1.id = 'okBtn';
	__006_1.style.width = '76.0px';
	__006_1.style.height = '26.0px';
	__006_1.style.padding = '0px';
	__006_1.style.border = '0px';
	__006_1.style.fontFamily ='Malgun Gothic, Dotum, Verdana, sans-serif';
	__006_1.style.marginLeft='15px';
	__006_1.style.background = 'url("' + gpkiScriptBase + '/image/certificate/btn_ok.png")';
	__006_1.onclick = function(){onOKClickButton()};
	__006.appendChild(__006_1);
	
	var __006_2 = document.createElement('BUTTON');
	__006_2.id = 'cancelBtn';
	__006_2.style.width = '76.0px';
	__006_2.style.height = '26.0px';
	__006_2.style.padding = '0px';
	__006_2.style.border = '0px';
	__006_2.style.fontFamily ='Malgun Gothic, Dotum, Verdana, sans-serif';
	__006_2.style.marginLeft='15px';
	__006_2.style.background = 'url("' + gpkiScriptBase + '/image/certificate/btn_cancel.png")';
	__006_2.onclick = function(){onCancelClickButton()};
	__006.appendChild(__006_2);
	
	var __006_3 = document.createElement('BUTTON');	
	__006_3.id = 'viewBtn';
	__006_3.style.width = '76px';
	__006_3.style.height = '26px';
	__006_3.style.padding = '0px';
	__006_3.style.border = '0px';
	__006_3.style.fontFamily ='Malgun Gothic, Dotum, Verdana, sans-serif';
	__006_3.style.marginLeft='15px';
	__006_3.style.background = 'url("' + gpkiScriptBase + '/image/certificate/btn_view.png")';
	__006_3.onclick = function(event){
		event = event||window.event;
		loadJavascript(gpkiScriptBase + "/ui/CertViewer.js",showCertView);
		};
	__006.appendChild(__006_3);
	
	if(!embeded){		
		__001_i.appendChild(__003);
		__001_i.appendChild(__004);
		__001_i.appendChild(__005);
		__001_i.appendChild(__006);
	}else{
		__001_i.appendChild(__003_2);
		__001_i.appendChild(__004);		
	}
	
	return __001_i; 
}


function loadJavascript(URL,callback,event,charet,element) { 
	
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
    
    if(event!=null && typeof(event)!='undefined'){
    	if(element!=null && typeof(element)!='undefined')
    		return callback(event,element);
    	else
    		return callback(event);
    }else
    	return callback();    
}


function showCertView(event){
		
	if(selectedRow == null){
		alert(ErrorMessage.code30020);
		return;
	}
	
	var certview = new CertWindow(selecteRowNum);
	if(selecteRowNum === null || selecteRowNum === ""){
		return false;
	}
	certview.show();
}

function OnHddCertList(target){
	var optPanel = document.getElementById('drivePanel');
	if(optPanel!=null|| typeof(optPanel)=='undefined'){
		optPanel.parentNode.removeChild(optPanel);
	}
	
	selectedStorageType  = 4;
	var nResult = GPKISecureWeb.SetMediaType(4);
	if(nResult != 0){
		makeError("code"+nResult);
		return false;
	}
	var mediaNum = GPKISecureWeb.GetMediaSubCount();
	selectSubMediaName = '';
	GPKISecureWeb.GetMediaSubInfo(0);
	
	target.setAttribute('idx','0');
	
	if(!getCertList(target)){
		this.focus();
		return;
	}

}
//add smartCert
function smartCertList(target){
	var optPanel = document.getElementById('drivePanel');
	if(optPanel!=null|| typeof(optPanel)=='undefined'){
		optPanel.parentNode.removeChild(optPanel);
	}
	
	selectedStorageType  = 7;
	var nResult = GPKISecureWeb.SetMediaType(7);
	if(nResult != 0){
		makeError("code"+nResult);
		return false;
	}
	
	var nResult = GPKISecureWeb.LoadCertList(0);
	if(nResult != 0){
		makeError("code"+nResult);
		return false;
	}
	onSmartCertOK();

}

function onRemovableList(target){
	selectedStorageType  =1;
		
	var retObjs = showSubMemu(target);
	if(retObjs[0]!=null){	
		target.parentNode.appendChild(retObjs[0]);
		attachKeyboardNavigator(document.getElementById('drivePanel'));
	}
	
	return retObjs[1];
}

function getCertList(target){
	mycerts = new Array();
	var nResult="";
	var SubCountNum = 0;
	var certNum = 0;
	
	if(selectedStorageType == 8){
		var password = target.getAttribute('pin');
		var pfxFilePath = target.getAttribute('filePath');
		var ret = GPKISecureWeb.SetPFXPath(encodeURIComponent(pfxFilePath), password);
		if(ret != 0){
			makeError("code"+nResult);
			return false;
		}
		nResult = GPKISecureWeb.LoadCertList(SubCountNum);
		if(nResult != 0 && isEmbeded ){
			//makeError("code"+nResult);
			return false;
		}else if (nResult != 0 ){
			makeError("code"+nResult);
			return false;
		}
		
		certNum = GPKISecureWeb.GetCertCount(SubCountNum);
	}else{
		SubCountNum = target.getAttribute('idx');
		nResult = GPKISecureWeb.LoadCertList(SubCountNum);
		if(nResult != 0 && isEmbeded ){
			//makeError("code"+nResult);
			return false;
		}else if (nResult != 0 ){
			makeError("code"+nResult);
			return false;
		}
		certNum = GPKISecureWeb.GetCertCount(SubCountNum);
	}
	
	if(certNum == 0 || certNum == 30016){
		var optPanel = document.getElementById('drivePanel');
		if(optPanel!=null|| typeof(optPanel)=='undefined'){
			optPanel.parentNode.removeChild(optPanel);
		}
		alert(ErrorMessage.code30016);
		return false;
	}
	var obj;
	var resultMessage;
	for(var i=0; i<certNum; i++){
		var info = GPKISecureWeb.GetCertListInfo(i);
		obj = JSON.parse(info);
		if(obj.ResultCode == 0) {
			resultMessage = obj.ResultMessage;
		}
		mycerts[i] = stringToArray(resultMessage);
	}
	
	if(target.tagName != 'IMG'){
		var optPanel = document.getElementById('drivePanel');
		
		if(optPanel!=null && typeof(optPanel)!='undefined'){
			var parent = optPanel.parentNode;//li tag							
			parent.removeChild(optPanel);
		}
	}
	
	onTableRefresh(target, mycerts);
	attachKeyboardNavigator(document.getElementById("dataList"));
	return true;
}

var selectSubMediaName = '';

function showSubMemu(target){
	var focusElement;
	var nResult = GPKISecureWeb.SetMediaType(selectedStorageType);
	if(nResult != 0){
		makeError("code"+nResult);
		return false;
	}
	var optPanel = document.getElementById('drivePanel');
	if(optPanel!=null && typeof(optPanel)!='undefined'){	
		if(target.parentNode.childNodes.length == 2){
			optPanel.parentNode.removeChild(optPanel);
			return [null,target.getElementsByTagName('button')[0]];
		}else{
			optPanel.parentNode.removeChild(optPanel);
		}
		
	}
	var mediaNum = GPKISecureWeb.GetMediaSubCount();
	
	if(mediaNum == 0){
		selectSubMediaName = '';
		alert(ErrorMessage.code30016);
		return [null,null];
	}
	
	if(selectedStorageType==5)
		mediaNum = 1;
	 
	var __001_i = document.createElement('ul');
	__001_i.style.listStyle = 'none';
	__001_i.style.paddingLeft = '0px';
	__001_i.style.marginLeft = '40px';
	__001_i.id = 'drivePanel';
	__001_i.style.color = '#666';	
	__001_i.style.position='absolute';
	__001_i.style.zIndex = '+1';
	__001_i.style.backgroundColor='white';
	__001_i.style.border = 'solid 1px #CCC';
	
	var index = 0;
	for (index=0; index<mediaNum;index++){
		var __002 = document.createElement('li');
		__001_i.appendChild(__002);
		var __002_01 = document.createElement('div');		
		__002_01.onclick = function(e){ 
			selectSubMediaName = this.getAttribute('subMediaName');
			var optPanel = document.getElementById('drivePanel');
			if(selectedStorageType==2){
				loadJavascript(gpkiScriptBase + "/ui/pinWindow.js",actionPassword,target.getElementsByTagName('button')[0],null,this);
				//var optPanel = document.getElementById('drivePanel');
				if(optPanel!=null && typeof(optPanel)!='undefined'){	
					if(target.parentNode.childNodes.length == 2){
						optPanel.parentNode.removeChild(optPanel);
						return [null,target.getElementsByTagName('button')[0]];
					}else{
						optPanel.parentNode.removeChild(optPanel);
					}
				}
			}else{
				optPanel.parentNode.removeChild(optPanel);
				if(!getCertList(this)){
					target.focus();
					return;					
				}
				//~! added by gomsugy. 2016.01.13.
				var certList = document.getElementById("dataList");
				if (certList.hasChildNodes())
					certList.childNodes[0].onclick();				
			}
		};
		__002_01.setAttribute('idx',index);
		__002_01.style.marginTop = '2px';
		__002_01.style.marginLeft = '2px';
		__002_01.style.padding = '0px 0px 0px 0px';
		__002_01.onfocus = function(e){this.style.backgroundColor='#E3E4FA'; };
		__002_01.onblur = function(e){this.style.backgroundColor='white'; };
		__002_01.onmouseover = function(e){
			this.style.cursor = 'pointer';
			this.style.backgroundColor='#E3E4FA'; 
			};
		__002_01.onmouseout = function(e){this.style.backgroundColor='white'; };
		
		var __002_02 = document.createElement('input');		
		__002_02.setAttribute('type','image');
		__002_02.setAttribute('src', gpkiScriptBase + '/image/certificate/cert/driver.png');
		__002_02.style.padding = '0px';
		__002_01.style.backgroundImage='url("'+gpkiScriptBase +'/image/certificate/cert/driver.png")' ;
		__002_01.style.backgroundRepeat='no-repeat';
		__002_01.style.backgroundPosition='4px 4px';
		__002_01.style.backgroundSize='16px 16px'; 
		__002_01.style.fontSize='12px'; 
		__002_01.style.fontFamily='Malgun Gothic, Dotum, Verdana, sans-serif';
		__002_01.style.paddingLeft='30px';
		__002_02.style.height='0px';
		__002_02.style.width='0px';
		__002_02.onfocus = function(e){this.parentNode.style.backgroundColor='#E3E4FA'; };
		__002_02.onblur = function(e){this.parentNode.style.backgroundColor='white'; };
		__002_02.onmouseover = function(e){this.parentNode.style.backgroundColor='#E3E4FA'; };
		__002_02.onmouseout = function(e){this.parentNode.style.backgroundColor='white'; };
		
		__002_01.appendChild(__002_02);
		
		var obj = JSON.parse(GPKISecureWeb.GetMediaSubInfo(index));
		var dataVaule = obj.ResultMessage;
		__001_i.style.width=((dataVaule.length<8)?'130px':(dataVaule.length<16)?'200px':(dataVaule.length<24)?'300px':'400px');					
		
		__002_01.setAttribute('subMediaName',dataVaule);
		__002_02.setAttribute('alt',dataVaule);
		__002_01.appendChild(document.createTextNode(dataVaule));	
		
		__002.appendChild(__002_01);
		
		if(index==0){
			focusElement =__002_02; 
		}
	}
	
	return [__001_i,focusElement];
}

function onPhoneCertList(target){
	
	selectedStorageType = 5;
	
	var retObjs = showSubMemu(target);
	if(retObjs[0]!=null){	
		target.parentNode.appendChild(retObjs[0]);
		attachKeyboardNavigator(document.getElementById('drivePanel'));
	}
	
	return retObjs[1];	
}

function onPKCS12FileDialog(e){
	e = e||window.event;
	var target = e.target||e.srcElement;
	
	selectedStorageType = 8;
	var nResult = GPKISecureWeb.SetMediaType(8);
	if(nResult != 0){
		makeError("code"+nResult);
		return false;
	}
	
	var optPanel = document.getElementById('drivePanel');
	if(optPanel!=null && typeof(optPanel)!='undefined'){	
		if(target.parentNode.childNodes.length == 2){
			optPanel.parentNode.removeChild(optPanel);
			return [null,target.getElementsByTagName('button')[0]];
		}else{
			optPanel.parentNode.removeChild(optPanel);
		}
	}	
	
	var win = new CertSearchWindow(actionPassword);
	win.show(target);
}

function onSMTokenCertList(target){
		
	selectedStorageType = 2;		
	
	var retObjs = showSubMemu(target);
	if(retObjs[0]!=null){	
		target.parentNode.appendChild(retObjs[0]);
		attachKeyboardNavigator(document.getElementById('drivePanel'));
	}
	
	return retObjs[1];	
}

function onSeTokenCertList(e){
	e = e||window.event;
	var target = e.target||e.srcElement;
	selectedStorageType = 3;
	var optPanel = document.getElementById('drivePanel');
	if(optPanel!=null|| typeof(optPanel)=='undefined'){
		optPanel.parentNode.removeChild(optPanel);
	}
	loadJavascript(gpkiScriptBase + "/ui/SecureTokenWindow.js",actionSeToken,target);
	
}

function actionSeToken(target){
	var win = new SecureTokenWindow(applyCertList);
	win.show(target);
}

function actionPassword(target,element){
	// 1. insert password
	var winPW = new PinWindow(applyCertList);
	winPW.show(target,element);
}

function applyCertList(target,element){
	if(selectedStorageType==2){
		var nReturn = GPKISecureWeb.SetPINNumber(target.getAttribute('pin'));
		if( nReturn != 0 ){
			makeError("code"+nResult);
			target.focus();
			return ;
		}		
	}
	
	var action = target.getAttribute('action');
		
	if(action == 'end'){
		var optPanel = document.getElementById('drivePanel');
		if(optPanel!=null|| typeof(optPanel)=='undefined')
			optPanel.parentNode.removeChild(optPanel);
				
		var certTarget = target;
		
		if(element!=null && typeof(element)!='undefined' ){
			certTarget = element;
		}
		
		if(!getCertList(certTarget)){
			this.focus();
			return;
		}
	
		target.setAttribute('action','ready');
		attachKeyboardNavigator(document.getElementById("dataList"));
		
		//~! added by gomsugy. 2016.01.13.
		var certList = document.getElementById("dataList");
		if (certList.hasChildNodes())
			certList.childNodes[0].onclick();				
	}
	
	return;
}

var myInput;
function attachKeyboardNavigator(target){
			
	myInput = target.getElementsByTagName("input");

	for(i=0; i<myInput.length; i++){
	    if(myInput[i].addEventListener ) {
	        myInput[i].addEventListener('keydown',keyHandler,false);
	    } else if(myInput[i].attachEvent ) {
	        myInput[i].attachEvent('onkeydown',keyHandler); /* damn IE hack */	        
	    }
	    if(i!=0)
	    	myInput[i].setAttribute('preElement',i-1);
	    	
	    if(i!=(myInput.length-1))
	    	myInput[i].setAttribute('nextElement',i+1);
		}
}

function onSmartCertOK(){
		if(!embeded){
			document.getElementsByTagName("body")[0].removeChild(overlayCS);
			document.getElementsByTagName("body")[0].removeChild(__001);
		}
	
		if(clickElement!=null && typeof(clickElement)!='undefined'){
			clickElement.disabled = false;
		}
		cipherAction();
		
	 document.oncontextmenu = function (){ return true }; 
	 document.ondragstart = function (){ return true };
	 document.onselectstart = function (){ return true };
}

function onOKClickButton(){

	if(selectedRow == null){
		alert(ErrorMessage.code30020);
		return;
	}else if(document.getElementById('passwd').value.length == 0){
		alert(ErrorMessage.code70010);
		return;
	}
	var nResult ="";
	var cvalue = document.getElementById('passwd').value;
	if(keysecOpt==0){
		nResult = GPKISecureWeb.SelectCert(selectedRow.getAttribute('CertIndex'),encodeURIComponent(cvalue));
	}else if(keysecOpt==1){
		nResult = GPKISecureWeb.SelectCert(selectedRow.getAttribute('CertIndex'),'');
	}else if(keysecOpt==2){
		nResult = GPKISecureWeb.SelectCertKeyboard(selectedRow.getAttribute('CertIndex'), encodeURIComponent(npPfsCtrl.GetResultField('passwdForm', 'passwd')), encodeURIComponent(npPfsCtrl.GetReplaceField('passwdForm', 'passwd')));
	}else{
		nResult = GPKISecureWeb.SelectCert(selectedRow.getAttribute('CertIndex'),encodeURIComponent(cvalue));
	}
	
	if( nResult == 0 ){
		if(!embeded){
			document.getElementsByTagName("body")[0].removeChild(overlayCS);
			document.getElementsByTagName("body")[0].removeChild(__001);
		}
	
		if(clickElement!=null && typeof(clickElement)!='undefined'){
			clickElement.disabled = false;
		}
		cipherAction();
	}else{
		if(passwordCount!= 0){
			if(selectedIdx == selecteRowNum){
				checkCount++;
				pwCountArr[selectedRow.getAttribute('CertIndex')] = checkCount;
			}else{
				selectedIdx = selecteRowNum;
				if(typeof pwCountArr[selectedRow.getAttribute('CertIndex')] == "undefined" || pwCountArr[selectedRow.getAttribute('CertIndex')] == null){
					checkCount = 1;
					pwCountArr[selectedRow.getAttribute('CertIndex')] = checkCount;
				}else{
					checkCount = pwCountArr[selectedRow.getAttribute('CertIndex')] + 1;
					pwCountArr[selectedRow.getAttribute('CertIndex')] = checkCount;
				}
				
			}
			if(passwordCount !=0 && pwCountArr[selectedRow.getAttribute('CertIndex')] < passwordCount ){
				if(!embeded){
					alert(pwCountArr[selectedRow.getAttribute('CertIndex')] + ErrorMessage.code70015 + passwordCount + ErrorMessage.code70016);
				}else{
					alert(pwCountArr[selectedRow.getAttribute('CertIndex')] + ErrorMessage.code70015);
				}
			}else if(passwordCount !=0 && pwCountArr[selectedRow.getAttribute('CertIndex')] >= passwordCount){
				if(!embeded){
					alert(pwCountArr[selectedRow.getAttribute('CertIndex')] + ErrorMessage.code70015 + ErrorMessage.code70017);
					onCancelClickButton();
				}else{
					alert(checkCount + ErrorMessage.code70015); 
				}
				if(submitUseDN){
					var ret = JSON.parse(GPKISecureWeb.GetCertDetailInfo(selecteRowNum,8));
					if(ret.ResultCode == 0){
						userDN = ret.ResultMessage;
						cipherAction();
					} 
				}
				
				return false;
			}
		}else if (passwordCount == 0 && selectedStorageType == 3){
			makeError("code"+nResult);
				
		}else{
			makeError("code"+nResult);
		}
		document.getElementById('passwd').value = "";
	} 

	 document.oncontextmenu = function (){ return true }; 
	 document.ondragstart = function (){ return true };
	 document.onselectstart = function (){ return true };
}

function clearPasswd(){
	document.getElementById('passwd').value = '';
	document.getElementById('passwd').focus();
}

function onCancelClickButton(){
	var optPanel = document.getElementById('drivePanel');
	if(optPanel!=null|| typeof(optPanel)=='undefined'){
		optPanel.parentNode.removeChild(optPanel);
	}
	
	document.getElementsByTagName("body")[0].removeChild(overlayCS);
	document.getElementsByTagName("body")[0].removeChild(__001);
	if(clickElement!=null && typeof(clickElement)!='undefined'){
		clickElement.disabled = false;
	}
	
	 document.oncontextmenu = function (){ return true }; 
	 document.ondragstart = function (){ return true };
	 document.onselectstart = function (){ return true };
	
}

var clickElement,encfunc;

function keyHandler(e) {
	var target = e.target||e.srcElement;
    var TABKEY = 9;
    var Up = 38;
    var esc =27 ;
    var Down =40;
    if(e.shiftKey && e.keyCode == TABKEY){
		if (browserType == BROWSER_IE){
    		if(selectedStorageType==0){
    			document.getElementById('removeBtn').focus();
    		}else{
    			document.getElementById('stPhone').focus();
    		}
    	}else{
	   		if(e.preventDefault) {
	   			e.preventDefault();
	   		}
	   		if(selectedStorageType==0){
	   			document.getElementById('removeBtn').focus();
	   		}else{
	   			document.getElementById('stPhone').focus();
	   		}
    	}
    	return false;
   	}else if(e.keyCode == TABKEY) {
		if (browserType == BROWSER_IE)
    		if(selectedStorageType==0)
    			document.getElementById('smartBtn').focus();
    		else if(!embeded)
    			document.getElementById('searchBtn').focus();
    		else
    			clickElement.focus();
    	else{
    		if(e.preventDefault) {
    			e.preventDefault();
    		}
    		if(selectedStorageType==0){
    			document.getElementById('smartBtn').focus();
    		}else if(!embeded){
    			document.getElementById('searchBtn').focus();
    		}else{
    			clickElement.focus();
    		}
    	}
        return false;
    }else if(e.keyCode == Up) {
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
    	if(e.preventDefault) {
   			e.preventDefault();
   		}
    	var nextNode = target.getAttribute('nextElement');        	
    	if(nextNode!=null && typeof(nextNode)!='undefined'){
    		myInput[nextNode].focus(); 
    	}
		if(e.preventDefault) {
   			e.preventDefault();
   		}else{
   			return false;
   		}
    }else if(e.keyCode == esc){
      var target = document.getElementById('drivePanel');
    	if(target!=null && typeof(target.id)!='undefined' ){
    		var parentElement = target.parentNode;
    		target.parentNode.removeChild(target);
    		parentElement.getElementsByTagName('button')[0].focus();
    	}    			
    }
}

function pwdEnterEvent(event){
	if (event == undefined){
		event = window.event;
	}
	// Enter Key
	if (event.keyCode == 13){
		onOKClickButton();
	}else{
		return;
	}
}
if(keysecOpt == 2){
	GPKISecureWebUi.KeyboardSecurityLoad();
}
	return{
		setKeyboardSec : function(opt,mEncfunc){
			keysecOpt = opt;
			encfunc = mEncfunc;
		},
		startAction : function(){
			onOKClickButton();
		},			
		show : function(element){
			popupflag = 1;
			overlayCS.style.display='';
			__001.style.display='';	
			if(!embeded){
				win.show('popup', 'popup_drag', 'screen-center', 0, 0,'');
			}
			
			if(element!=null && typeof(element)!='undefined'){
				clickElement = element;
			}
			firstFocusElement.onclick();
			return __001;
		},
		dispose : function(){
			overlayCS.style.display='none';
			__001.style.display='none';
		} 	
		
	}
	
}