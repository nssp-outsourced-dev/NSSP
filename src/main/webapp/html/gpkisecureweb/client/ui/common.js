Dialog = function(){// Layer Pop Up
var popup_dragging = false;
var popup_target;
var popup_mouseX;
var popup_mouseY;
var popup_mouseposX;
var popup_mouseposY;
var popup_oldfunction;

function popup_display(x){
  var win = window.open();
}

// ----- popup_mousedown -------------------------------------------------------

function popup_mousedown(e){
  var ie = (browserType == BROWSER_IE);

  if ( ie && window.event.button != 1) return;
  if (!ie && e.button            != 0) return;

  popup_dragging = true;

  popup_target   = this['target'];
  
  popup_mouseX   = ie ? window.event.clientX : e.clientX;
  popup_mouseY   = ie ? window.event.clientY : e.clientY;

  if (ie)
       popup_oldfunction      = document.onselectstart;
  else popup_oldfunction      = document.onmousedown;

  if (ie)
       document.onselectstart = new Function("return false;");
  else document.onmousedown   = new Function("return false;");
  
  if(prcessPath!=null || typeof(prcessPath)!='undefined')
	  document.getElementsByTagName('body')[0].removeChild(prcessPath);
  
}

// ----- popup_mousemove -------------------------------------------------------

function popup_mousemove(e){
  if (!popup_dragging) return;
 
  var ie = (browserType == BROWSER_IE);
  var element = document.getElementById(popup_target);
  var mouseX = ie ? window.event.clientX : e.clientX;
  var mouseY = ie ? window.event.clientY : e.clientY;
  var transX = (element.offsetLeft+mouseX-popup_mouseX);
  var transY = (element.offsetTop +mouseY-popup_mouseY);
	
  element.style.left = transX<0?0:(transX>document.body.clientWidth)?(document.body.clientWidth-10):transX;//(transX<0?0:(transX>document.body.clientWidth-element.clientWidth)?(document.body.clientWidth-element.clientWidth):transX)+'px';
  element.style.top  = transY<0?0:(transY>document.body.clientHeight)?(document.body.clientHeight-10):transY;//(transY<0?0:(transY>document.body.clientHeight-element.clientHeight)?(document.body.clientHeight-element.clientHeight):transY)+'

  popup_mouseX = ie ? window.event.clientX : e.clientX;
  popup_mouseY = ie ? window.event.clientY : e.clientY;
}

// ----- popup_mouseup ---------------------------------------------------------
var prcessPath;
function popup_mouseup(e)
{
  if (!popup_dragging) return;
  popup_dragging = false;
  var element = document.getElementById(popup_target);
  var ie = (browserType == BROWSER_IE);
  var element = document.getElementById(popup_target);
  
  if (ie){
	  document.onselectstart = popup_oldfunction;
  }else{
	  document.onmousedown   = popup_oldfunction;
  }
}

// ----- popup_exit ------------------------------------------------------------

function popup_exit(e){
  var ie = (browserType == BROWSER_IE);

  popup_mouseup(e);
  element.style.visibility = 'hidden';
  element.style.display    = 'none';
}

// ----- popup_show ------------------------------------------------------------

function popup_show(id, drag_id, position, x, y, position_id){
  element      = document.getElementById(id);
  drag_element = document.getElementById(drag_id);

  element.style.position   = "absolute";
  element.style.visibility = "visible";
  element.style.display    = "block";

  if (position == "screen-corner"){
    element.style.left = (document.documentElement.scrollLeft+x)+'px';
    element.style.top  = (document.documentElement.scrollTop +y)+'px';
  }

  if (position == "screen-center"){	  
    element.style.left = (document.documentElement.scrollLeft+(document.body.clientWidth -element.clientWidth )/2+x)+'px';
    element.style.top  = (document.documentElement.scrollTop +(document.body.clientHeight-element.clientHeight)/2+y)+'px';
  }

  if (position == "mouse-corner"){
    element.style.left = (document.documentElement.scrollLeft+popup_mouseposX+x)+'px';
    element.style.top  = (document.documentElement.scrollTop +popup_mouseposY+y)+'px';
  }

  if (position == "mouse-center"){
	element.style.left = (document.documentElement.scrollLeft+popup_mouseposX-element.clientWidth /2+x)+'px';
    element.style.top  = (document.documentElement.scrollTop +popup_mouseposY-element.clientHeight/2+y)+'px';
  }
  
  if (position == "mouse-left"){
    element.style.left = (document.documentElement.scrollLeft+popup_mouseposX-element.clientWidth-x)+'px';
    element.style.top  = (document.documentElement.scrollTop +popup_mouseposY+y)+'px';
  }

  if (position == "element-right" || position == "element-bottom"){
    var position_element = document.getElementById(position_id);

    for (var p = position_element; p; p = p.offsetParent){
    	if (p.style.position != 'absolute'){
          x += p.offsetLeft;
          y += p.offsetTop ;
        }
    }
      
    if (position == "element-right" ){
    	x += position_element.clientWidth;
    }
    if (position == "element-bottom"){
    	y += position_element.clientHeight;
    } 
    element.style.left = x+'px';
    element.style.top  = y+'px';
  }

  drag_element['target']   = id;
  drag_element.onmousedown = popup_mousedown;
}

// ----- popup_mousepos --------------------------------------------------------

function popup_mousepos(e){
  var ie = (browserType == BROWSER_IE);
  
  popup_mouseposX = ie ? window.event.clientX : e.clientX;
  popup_mouseposY = ie ? window.event.clientY : e.clientY;
}

// ----- Attach Events ---------------------------------------------------------

if (navigator.appName == "Microsoft Internet Explorer"){
	// IE 10
	document.attachEvent('onmousedown', popup_mousepos);
}else{
	document.addEventListener('mousedown', popup_mousepos, false);
}

if (navigator.appName == "Microsoft Internet Explorer"){
	// IE 10
	document.attachEvent('onmousemove', popup_mousemove);
}else{
	document.addEventListener('mousemove', popup_mousemove, false);
}

if (navigator.appName == "Microsoft Internet Explorer"){
	 // IE 10
	document.attachEvent('onmouseup', popup_mouseup);
}else{
	document.addEventListener('mouseup', popup_mouseup, false);
}

	return {
		show : function(id, drag_id, position, x, y, position_id){
			popup_show(id, drag_id, position, x, y, position_id);
		}		
	}
}