package kr.go.nssp.utl;

import java.util.*;

public class AuthorManager{

	private static AuthorManager authorManager = null;
	private static HashMap<String, HashMap> URL_INFO = new HashMap();
	private static LinkedHashMap<String, List> MENU_INFO = new LinkedHashMap();
	private static LinkedHashMap<String, HashMap> MENU_CL_INFO = new LinkedHashMap();
	private static boolean AUTHOR_AT = false;

	public static synchronized AuthorManager getInstance(){
		if(authorManager == null){
			authorManager = new AuthorManager();
		}
		return authorManager;
	}

	public synchronized HashMap getUrl(String author, String url){
		return URL_INFO.get(author+"_"+url);
	}

	public synchronized void setUrl(String author, String url, HashMap urlList){
		URL_INFO.put(author+"_"+url, urlList);
	}


	public synchronized HashMap getMenuCl(String author, String menuClCd){
		return MENU_CL_INFO.get(author+"_"+menuClCd);
	}

	public synchronized void setMenuCl(String author, String menuClCd, HashMap menuClInfo){
		MENU_CL_INFO.put(author+"_"+menuClCd, menuClInfo);
	}


	public synchronized List getMenu(String author, String menuClCd){
		return MENU_INFO.get(author+"_"+menuClCd);
	}

	public synchronized void setMenu(String author, String menuClCd, List menuList){
		MENU_INFO.put(author+"_"+menuClCd, menuList);
	}

	public synchronized void complete(){
		AUTHOR_AT = true;
	}
	
	public synchronized boolean is(){
		return AUTHOR_AT;
	}

	public synchronized void clear(){
		URL_INFO = new HashMap();
		MENU_INFO = new LinkedHashMap();
		MENU_CL_INFO = new LinkedHashMap();
		AUTHOR_AT = false;
	}
	
	public synchronized List<HashMap> getMENU_CL_INFO(String author) {
		List<HashMap> tMenuClInfo = new ArrayList<HashMap>();
		if(AUTHOR_AT) {		
			Set key = MENU_CL_INFO.keySet();
			for (Iterator iterator = key.iterator(); iterator.hasNext();) {	
				String keyCd = (String) iterator.next();
				if (author !=null && !author.equals("") && keyCd.startsWith(author)) {
					tMenuClInfo.add(MENU_CL_INFO.get(keyCd));
				}			
			}	
		}
		return tMenuClInfo;
	}	
	
	public synchronized HashMap getMENU_INFO(String author) {
		return MENU_INFO;
	}
}
