package kr.go.nssp.cmmn.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.cmmn.service.ExmnService;
import kr.go.nssp.utl.egov.EgovProperties;


@Controller
@RequestMapping(value = "/exmn/")
public class ExmnController {

	@Resource
	private ExmnService exmnService;

	@Resource
	private CdService cdService;

	@RequestMapping(value = "/list/")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		//부서구분
    	HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00635");
		List<HashMap> exmnSeList = cdService.getCdList(cMap);

		//관할검찰
    	cMap.put("upper_cd", "00104");
		List<HashMap> exmnList = cdService.getCdList(cMap);

		model.addAttribute("exmnSeList", exmnSeList);
		model.addAttribute("exmnList", exmnList);
		return "exmn/list";
	}

	@RequestMapping(value = "/exmnFullListAjax/")
	public ModelAndView exmnFullListAjax(HttpServletRequest request) throws Exception  {
    	HashMap map = new HashMap();
    	map.put("start_cd", "XXXXX");
		List<HashMap> exmnFullList = exmnService.getExmnFullList(map);

		return new ModelAndView("ajaxView", "ajaxData", exmnFullList);
	}

	@RequestMapping(value = "/exmnListAjax/")
	public ModelAndView exmnListAjax(HttpServletRequest request) throws Exception  {
        String txtExmnUpperCd = SimpleUtils.default_set(request.getParameter("txtExmnUpperCd"));
		//공백제거
        txtExmnUpperCd = txtExmnUpperCd.replaceAll("(^\\p{Z}+|\\p{Z}+$)", "");

		List<HashMap> exmnList = new ArrayList();
        if(!txtExmnUpperCd.isEmpty()){
        	HashMap map = new HashMap();
        	map.put("exmn_upper_cd", txtExmnUpperCd);
    		exmnList = exmnService.getExmnList(map);

    		int cnt = 0;
    		List<HashMap> tempList = new ArrayList();
			for(HashMap vMap : exmnList){
				cnt = Integer.parseInt(vMap.get("LOWER_CNT").toString());
            	if(cnt == 0){
    				vMap.put("children", tempList);
            	}
			}
        }

		return new ModelAndView("ajaxView", "ajaxData", exmnList);
	}


	@RequestMapping(value = "/exmnDetailAjax/")
	public ModelAndView exmnDetailAjax(HttpServletRequest request) throws Exception  {
        String txtExmnCd = SimpleUtils.default_set(request.getParameter("txtExmnCd"));

    	HashMap map = new HashMap();
    	map.put("exmn_cd", txtExmnCd);
		HashMap cMap = exmnService.getExmnDetail(map);

		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	@RequestMapping("/addAjax/")
	public ModelAndView addAjax(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

        String txtExmnNm = SimpleUtils.default_set(request.getParameter("txtExmnNm"));
        String txtCmptncDc = SimpleUtils.default_set(request.getParameter("txtCmptncDc"));

        String txtExmnUpperCd = SimpleUtils.default_set(request.getParameter("txtExmnUpperCd"));
        String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";
		try{
			HashMap map = new HashMap();
			map.put("exmn_upper_cd", txtExmnUpperCd);
	    	map.put("exmn_nm", txtExmnNm);
	    	map.put("exmn_cmptnc_dc", txtCmptncDc);
			map.put("sort_ordr", selSort);
			map.put("esntl_id", esntl_id);
			exmnService.addExmn(map);
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

        String hidExmnCd = SimpleUtils.default_set(request.getParameter("hidExmnCd"));
        String txtExmnNm = SimpleUtils.default_set(request.getParameter("txtExmnNm"));
        String txtCmptncDc = SimpleUtils.default_set(request.getParameter("txtCmptncDc"));
        String selUseYn = SimpleUtils.default_set(request.getParameter("selUseYn"));
        String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";

    	HashMap map = new HashMap();
    	map.put("exmn_cd", hidExmnCd);

    	//하위코드가 있는지 확인
    	int cdCnt = 0;
    	if(selUseYn != null && selUseYn.trim().equals("N")) {
    		cdCnt = exmnService.getExmnLowerCd (map);
    	}
    	if(cdCnt > 0) {
    		result = "-3";
    	} else {
    		HashMap cMap = exmnService.getExmnDetail(map);
    		if(cMap != null){
    	    	map.put("exmn_nm", txtExmnNm);
    	    	map.put("exmn_cmptnc_dc", txtCmptncDc);
    			map.put("use_yn", selUseYn);
    			map.put("sort_ordr", selSort);
    			map.put("esntl_id", esntl_id);
    			exmnService.updateExmn(map);
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
        model.addAttribute("upper_cd", "00000");
        return "exmn/selectPopup";
    }


}
