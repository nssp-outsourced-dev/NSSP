package kr.go.nssp.menu.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.go.nssp.utl.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.menu.service.MenuService;
import kr.go.nssp.utl.AuthorManager;
import kr.go.nssp.utl.Utility;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/menu/")
public class MenuController {

	@Resource
    private MenuService menuService;

	@Resource
	private CdService cdService;


    @RequestMapping(value="/list/")
    public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		int pageBlock = 50;
        model.addAttribute("hidPageBlock", pageBlock);

    	HashMap tmap = new HashMap();
    	tmap.put("use_yn", "Y");
    	List<HashMap> menuCllist = menuService.getMenuClList(tmap);
        model.addAttribute("menuClList", menuCllist);

        return "menu/list";
    }

	@RequestMapping(value = "/listAjax/")
	public ModelAndView listAjax(HttpServletRequest request) throws Exception  {

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		String searchMenuClCd = SimpleUtils.default_set(request.getParameter("searchMenuClCd"));
		String searchMenuNm = SimpleUtils.default_set(request.getParameter("searchMenuNm"));

        //현재 페이지 파라메타
        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
        int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));
		if( hidPageBlock== null || hidPageBlock.equals("")){
			hidPageBlock = "10";
		}
		int pageBlock = Integer.parseInt((String)hidPageBlock);

		//페이지 기본설정
		int pageArea = 10;

    	//page
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

    	HashMap map = new HashMap();
    	map.put("startRow", paginationInfo.getFirstRecordIndex());
    	map.put("endRow", paginationInfo.getLastRecordIndex());
    	map.put("esntl_id", esntl_id);
		map.put("menu_cl_cd", searchMenuClCd);
		map.put("menu_nm", searchMenuNm);

		int list_cnt = 0;
    	List<HashMap> list = menuService.getMenuList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

    	HashMap cMap = new HashMap();
    	cMap.put("list", list);
    	cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

    @RequestMapping(value="/detailAjax/")
    public ModelAndView detailAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		String hidMenuCd = SimpleUtils.default_set(request.getParameter("hidMenuCd"));

    	HashMap map = new HashMap();
		map.put("menu_cd", hidMenuCd);
    	HashMap result = menuService.getMenuDetail(map);

		return new ModelAndView("ajaxView", "ajaxData", result);
    }

	@RequestMapping("/addAjax/")
	public ModelAndView addAjax(HttpServletRequest request) throws Exception {

		Utility utl = Utility.getInstance();
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

		String hidMenuCd = SimpleUtils.default_set(request.getParameter("hidMenuCd"));
		String selMenuClCd = SimpleUtils.default_set(request.getParameter("selMenuClCd"));
		String txtMenuNm = SimpleUtils.default_set(request.getParameter("txtMenuNm"));
		String txtMenuUrl = SimpleUtils.default_set(request.getParameter("txtMenuUrl"));
		String selUseYn = SimpleUtils.default_set(request.getParameter("selUseYn"));
		String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";
		try{

	    	HashMap map = new HashMap();
			map.put("menu_cd", hidMenuCd);
			map.put("menu_cl_cd", selMenuClCd);
			map.put("menu_nm", txtMenuNm);
			map.put("menu_url", txtMenuUrl);
			map.put("use_yn", selUseYn);
			map.put("sort_ordr", selSort);
	    	map.put("esntl_id", esntl_id);

	        if(hidMenuCd == null || hidMenuCd.equals("")){
				menuService.addMenu(map);
	        }else{
	    		map.put("menu_cd", hidMenuCd);
	        	HashMap data = menuService.getMenuDetail(map);
	        	if(data != null){
	                menuService.updateMenu(map);
	        	}
	        }

		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


    @RequestMapping(value="/addClPopup/")
    public String addClPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "menu/addClPopup";
    }

    @RequestMapping(value="/addClListAjax/")
	public ModelAndView addClListAjax(HttpServletRequest request) throws Exception {
		HashMap map = new HashMap();
    	List<HashMap> result = menuService.getMenuClList(map);
		return new ModelAndView("ajaxView", "ajaxData", result);
    }

	@RequestMapping("/addClAjax/")
	public ModelAndView addClAjax(HttpServletRequest request) throws Exception {

	    HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

	    String hidMenuClCd = SimpleUtils.default_set(request.getParameter("hidMenuClCd"));
		String txtMenuClNm = SimpleUtils.default_set(request.getParameter("txtMenuClNm"));
		String selUseYn = SimpleUtils.default_set(request.getParameter("selUseYn"));
		String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";
		try{

			HashMap map = new HashMap();
			map.put("menu_cl_cd", hidMenuClCd);
			map.put("menu_cl_nm", txtMenuClNm);
			map.put("use_yn", selUseYn);
			map.put("sort_ordr", selSort);

			map.put("esntl_id", esntl_id);

			String file_id = "";
		    if(hidMenuClCd == null || hidMenuClCd.equals("")){
				menuService.addMenuCl(map);
		    }else{
				map.put("menu_cd", hidMenuClCd);
		    	HashMap data = menuService.getMenuClDetail(map);
		    	if(data != null){
		            menuService.updateMenuCl(map);
		    	}
		    }
		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


    @RequestMapping(value="/addRelatePopup/")
    public String addRelatePopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
	    String hidMenuCd = SimpleUtils.default_set(request.getParameter("hidMenuCd"));

		HashMap map = new HashMap();
		map.put("menu_cd", hidMenuCd);
    	HashMap detail = menuService.getMenuDetail(map);
        if(detail == null){
            model.addAttribute("script", "opener.fnSearch();");
            return "cmm/closePopup";
        }
        model.addAttribute("detail", detail);
        model.addAttribute("hidMenuCd", hidMenuCd);
        return "menu/addRelatePopup";
    }

    @RequestMapping(value="/addRelateListAjax/")
	public ModelAndView addRelateListAjax(HttpServletRequest request) throws Exception {
	    String hidMenuCd = SimpleUtils.default_set(request.getParameter("hidMenuCd"));

		HashMap map = new HashMap();
		map.put("menu_cd", hidMenuCd);
    	List<HashMap> list = menuService.getRelateList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
    }

	@RequestMapping("/addRelateAjax/")
	public ModelAndView addRelateAjax(HttpServletRequest request) throws Exception {

	    HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

	    String hidMenuCd = SimpleUtils.default_set(request.getParameter("hidMenuCd"));
	    String hidRelateSn = SimpleUtils.default_set(request.getParameter("hidRelateSn"));
		String txtRelateNm = SimpleUtils.default_set(request.getParameter("txtRelateNm"));
		String txtRelateUrl = SimpleUtils.default_set(request.getParameter("txtRelateUrl"));

        String result = "1";
		try{
			//공백제거
			txtRelateUrl = txtRelateUrl.replaceAll("(^\\p{Z}+|\\p{Z}+$)", "");

			HashMap map = new HashMap();
			map.put("menu_cd", hidMenuCd);
			map.put("relate_url", txtRelateUrl);
			map.put("relate_nm", txtRelateNm);
			map.put("esntl_id", esntl_id);

		    if(hidRelateSn == null || hidRelateSn.equals("")){
				int relateCnt = menuService.getRelateCnt(map);
				if(relateCnt < 1){
					menuService.addRelate(map);
				}else{
					result = "-2";
				}
		    }else{
				map.put("relate_sn", hidRelateSn);
		    	HashMap data = menuService.getRelateDetail(map);
		    	if(data != null){
		            menuService.updateRelate(map);
		    	}else{
		    		result = "-3";
		    	}
		    }

		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping("/deleteRelateAjax/")
	public ModelAndView deleteRelateAjax(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
	    String hidMenuCd = SimpleUtils.default_set(request.getParameter("hidMenuCd"));
	    String hidRelateSn = SimpleUtils.default_set(request.getParameter("hidRelateSn"));

        String result = "1";
		try{
	    	HashMap map = new HashMap();
			map.put("menu_cd", hidMenuCd);
			map.put("relate_sn", hidRelateSn);
	    	menuService.deleteRelate(map);
		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


    @RequestMapping(value="/author/")
    public String author(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "menu/author";
    }

    @RequestMapping(value="/authorListAjax/")
	public ModelAndView authorListAjax(HttpServletRequest request) throws Exception {
    	HashMap map = new HashMap();
    	List<HashMap> result = menuService.getAuthorClList(map);
		return new ModelAndView("ajaxView", "ajaxData", result);
    }

    @RequestMapping(value="/authorMenuListAjax/")
	public ModelAndView authorMenuListAjax(HttpServletRequest request) throws Exception {
		String hidAuthorCd = SimpleUtils.default_set(request.getParameter("hidAuthorCd"));
    	HashMap map = new HashMap();
		map.put("author_cd", hidAuthorCd);
    	List<HashMap> result = menuService.getAuthorList(map);
		return new ModelAndView("ajaxView", "ajaxData", result);
    }

	@RequestMapping("/authorAddAjax/")
	public ModelAndView authorAddAjax(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

		String hidAuthorCd = SimpleUtils.default_set(request.getParameter("hidAuthorCd"));
		String txtAuthorNm = SimpleUtils.default_set(request.getParameter("txtAuthorNm"));
		String txtAuthorDc = SimpleUtils.default_set(request.getParameter("txtAuthorDc"));
		String selUseYn = SimpleUtils.default_set(request.getParameter("selUseYn"));
		String selSort = SimpleUtils.default_set(request.getParameter("selSort"));
		String hidMenuList = SimpleUtils.default_set(request.getParameter("hidMenuList"));

        String result = "1";
		try{

			String[] menuList = hidMenuList.split("\\^");

	    	HashMap map = new HashMap();
	    	map.put("author_nm", txtAuthorNm);
	    	map.put("author_dc", txtAuthorDc);
	    	map.put("use_yn", selUseYn);
	    	map.put("sort_ordr", selSort);
	    	map.put("esntl_id", esntl_id);
	    	map.put("menu_list", menuList);

	        if(hidAuthorCd == null || hidAuthorCd.equals("")){
				menuService.addAuthorCl(map);
	        }else{
				map.put("author_cd", hidAuthorCd);
	        	HashMap data = menuService.getAuthorClDetail(map);
	        	if(data != null){
	                menuService.updateAuthorCl(map);
	        	}
	        }
		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping("/authorClearAjax/")
	public ModelAndView authorClearAjax(HttpServletRequest request) throws Exception {
		String selAuthorCd = SimpleUtils.default_set(request.getParameter("selAuthorCd"));
        String result = "1";
		try{
			AuthorManager authorManager = AuthorManager.getInstance();
			authorManager.clear();
		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

}

