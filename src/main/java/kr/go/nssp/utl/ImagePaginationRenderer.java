package kr.go.nssp.utl;

import javax.servlet.ServletContext;

import org.springframework.web.context.ServletContextAware;

public class ImagePaginationRenderer extends ImageAbstractPaginationRenderer implements ServletContextAware{

	private ServletContext servletContext;
	
	public ImagePaginationRenderer() {
	
	}
	
	public void initVariables(){

		firstPageLabel    = "<a href=\"#\" onclick=\"{0}({1});return false; \" title=\"처음\" class=\"ar1\"><img src=\"/img/al_icon3.png\" alt=\"\"/></a>";
        previousPageLabel = "<a href=\"#\" onclick=\"{0}({1});return false; \" title=\"이전\" class=\"ar\"><img src=\"/img/al_icon2.png\" alt=\"\"/></a>";
        currentPageLabel  = "<a href=\"javascript:void(0);\" class=\"on\">{0}</a>";
        otherPageLabel    = "<a href=\"#\" onclick=\"{0}({1});return false;\" title=\"{2}\">{2}</a>";
        nextPageLabel     = "<a href=\"#\" onclick=\"{0}({1});return false; \" title=\"다음\" class=\"ar\"><img src=\"/img/ar_icon2.png\" alt=\"\"/></a>";
        lastPageLabel     = "<a href=\"#\" onclick=\"{0}({1});return false; \" title=\"마지막\" class=\"ar1\"><img src=\"/img/ar_icon3.png\" alt=\"\"/></a>";
        
        //추가
        pageStartLabel  = "<div class=\"pagebox\">";
        pageEndLabel  = "</div>";        
        currentPageStartLabel  = "<div class=\"umbox\">";
        currentPageEndLabel  = "</div>";
        
	}
	

	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
		initVariables();
	}

}