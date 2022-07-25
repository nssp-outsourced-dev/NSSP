package kr.go.nssp.cmmn.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.go.nssp.utl.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.utl.egov.EgovProperties;


@Controller
@RequestMapping(value = "/cd/")
public class CdController {

	private String JUSO_CONFIRM_KEY = EgovProperties.getProperty("Globals.JusoConfirmKey");

	@Resource
	private CdService cdService;

	@RequestMapping(value = "/list/")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		return "cd/list";
	}

	@RequestMapping(value = "/cdFullJsonAjax/")
	public ModelAndView cdFullJsonAjax(HttpServletRequest request) throws Exception  {

        String txtUpCd = SimpleUtils.default_set(request.getParameter("txtUpCd"));
		//공백제거
        txtUpCd = txtUpCd.replaceAll("(^\\p{Z}+|\\p{Z}+$)", "");
		List<HashMap> cdList = new ArrayList();
        if(!txtUpCd.isEmpty()){
        	HashMap map = new HashMap();
        	map.put("upper_cd", txtUpCd);
    		cdList = cdService.getCdList(map);
        	cdList = makeListInList(cdList);
        }
		return new ModelAndView("ajaxView", "ajaxData", cdList);
	}

	private List<HashMap> makeListInList(List<HashMap> cdList) throws Exception{
		int cnt = 0;
		List<HashMap> tempList = new ArrayList();
		for(HashMap vMap : cdList){
			cnt = Integer.parseInt(vMap.get("lowerCnt").toString());
        	if(cnt > 0){
        		HashMap map = new HashMap();
            	map.put("upper_cd", vMap.get("cd"));
        		tempList = cdService.getCdList(map);
        		tempList = makeListInList(tempList);
				vMap.put("children", tempList);
        	}
		}
		return cdList;
	}


	@RequestMapping(value = "/cdFullListAjax/")
	public ModelAndView cdFullListAjax(HttpServletRequest request) throws Exception  {
    	HashMap map = new HashMap();
    	map.put("start_cd", "XXXXX");
		List<HashMap> cdFullList = cdService.getCdFullList(map);

		return new ModelAndView("ajaxView", "ajaxData", cdFullList);
	}

	@RequestMapping(value = "/cdListAjax/")
	public ModelAndView cdListAjax(HttpServletRequest request) throws Exception  {
        String txtUpCd = SimpleUtils.default_set(request.getParameter("txtUpCd"));
		//공백제거
        txtUpCd = txtUpCd.replaceAll("(^\\p{Z}+|\\p{Z}+$)", "");

		List<HashMap> cdList = new ArrayList();
        if(!txtUpCd.isEmpty()){
        	HashMap map = new HashMap();
        	map.put("upper_cd", txtUpCd);
    		cdList = cdService.getCdList(map);

    		int cnt = 0;
    		List<HashMap> tempList = new ArrayList();
			for(HashMap vMap : cdList){
				cnt = Integer.parseInt(vMap.get("lowerCnt").toString());
            	if(cnt == 0){
    				vMap.put("children", tempList);
            	}
			}
        }
		return new ModelAndView("ajaxView", "ajaxData", cdList);
	}

	@RequestMapping(value = "/cdDetailAjax/")
	public ModelAndView cdDetailAjax(HttpServletRequest request) throws Exception  {
        String txtCd = SimpleUtils.default_set(request.getParameter("txtCd"));

    	HashMap map = new HashMap();
    	map.put("esntl_cd", txtCd);
		HashMap cMap = cdService.getCdDetail(map);

		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	@RequestMapping("/addAjax/")
	public ModelAndView addAjax(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

        String txtCdNm = SimpleUtils.default_set(request.getParameter("txtCdNm"));
        String txtCdDc = SimpleUtils.default_set(request.getParameter("txtCdDc"));
        String txtUpCd = SimpleUtils.default_set(request.getParameter("txtUpCd"));
        String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";
		try{
			HashMap map = new HashMap();
			map.put("upper_cd", txtUpCd);
			map.put("cd_nm", txtCdNm);
			map.put("cd_dc", txtCdDc);
			map.put("sort_ordr", selSort);
			map.put("esntl_id", esntl_id);
			cdService.addCd(map);
		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping("/updateAjax/")
	public ModelAndView updateAjax(HttpServletRequest request, RedirectAttributes redirectAttr) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

        String hidCd = SimpleUtils.default_set(request.getParameter("hidCd"));
        String txtCdNm = SimpleUtils.default_set(request.getParameter("txtCdNm"));
        String txtCdDc = SimpleUtils.default_set(request.getParameter("txtCdDc"));
        String selUseYn = SimpleUtils.default_set(request.getParameter("selUseYn"));
        String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";

    	HashMap map = new HashMap();
    	map.put("esntl_cd", hidCd);

    	//하위코드가 있는지 확인
    	int cdCnt = 0;
    	if(selUseYn != null && selUseYn.trim().equals("N")) {
    		cdCnt = cdService.getCdLowerCd (map);
    	}
    	if(cdCnt > 0) {
    		result = "-3";
    	} else {
    		HashMap cMap = cdService.getCdDetail(map);
    		if(cMap != null){
    			if(cMap.get("esntlAt").toString().equals("N")) {
    		    	map.put("cd_nm", txtCdNm);
    		    	map.put("cd_dc", txtCdDc);
    		    	map.put("use_yn", selUseYn);
    		    	map.put("sort_ordr", selSort);
    		    	map.put("esntl_id", esntl_id);
    				cdService.updateCd(map);
    			} else {
    		    	map.put("cd_nm", txtCdNm);
    		    	map.put("cd_dc", txtCdDc);
    		    	map.put("sort_ordr", selSort);
    		    	map.put("esntl_id", esntl_id);
    				cdService.updateCd(map);
    			}
    		}else{
    			result = "-1";
    		}
    	}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


    @RequestMapping(value="/selectPopup/")
    public String selectPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
        String hidUpCd = SimpleUtils.default_set(request.getParameter("hidUpCd"));
        String mode = SimpleUtils.default_set(request.getParameter("mode"));
        model.addAttribute("upper_cd", hidUpCd);
        model.addAttribute("mode", mode);
        return "cd/selectPopup";
    }


    @RequestMapping(value="/jusoPopup/")
    public String jusoPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        model.addAttribute("juso_confirm_key", JUSO_CONFIRM_KEY);
        return "cd/jusoPopup";
    }

    @RequestMapping(value = "/cdGridListAjax/")
	public ModelAndView cdGridListAjax(HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception  {
        Object txtUpCd = param.get("txtUpCd");
		List<HashMap> cdList = new ArrayList();
        if(txtUpCd != null){
    		cdList = cdService.getCdGridList(param);
        }
		return new ModelAndView("ajaxView", "ajaxData", cdList);
	}
}
