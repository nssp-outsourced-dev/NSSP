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
import kr.go.nssp.cmmn.service.VioltService;
import kr.go.nssp.utl.egov.EgovProperties;


@Controller
@RequestMapping(value = "/violt/")
public class VioltController {

	@Resource
	private VioltService violtService;


	@RequestMapping(value = "/list/")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		return "violt/list";
	}


	@RequestMapping(value = "/violtFullJsonAjax/")
	public ModelAndView violtFullJsonAjax(HttpServletRequest request) throws Exception  {

        String txtVioltUpperCd = SimpleUtils.default_set(request.getParameter("txtVioltUpperCd"));
		//공백제거
        txtVioltUpperCd = txtVioltUpperCd.replaceAll("(^\\p{Z}+|\\p{Z}+$)", "");
		List<HashMap> violtList = new ArrayList();
        if(!txtVioltUpperCd.isEmpty()){
        	HashMap map = new HashMap();
        	map.put("violt_upper_cd", txtVioltUpperCd);
    		violtList = violtService.getVioltList(map);
        	violtList = makeListInList(violtList);
        }
		return new ModelAndView("ajaxView", "ajaxData", violtList);
	}

	private List<HashMap> makeListInList(List<HashMap> violtList) throws Exception{
		int cnt = 0;
		List<HashMap> tempList = new ArrayList();
		for(HashMap vMap : violtList){
			cnt = Integer.parseInt(vMap.get("LOWER_CNT").toString());
        	if(cnt > 0){
        		HashMap map = new HashMap();
            	map.put("violt_upper_cd", vMap.get("VIOLT_CD"));
        		tempList = violtService.getVioltList(map);
        		tempList = makeListInList(tempList);
				vMap.put("children", tempList);
        	}
		}
		return violtList;
	}

	@RequestMapping(value = "/violtFullListAjax/")
	public ModelAndView violtFullListAjax(HttpServletRequest request) throws Exception  {
    	HashMap map = new HashMap();
    	map.put("start_cd", "XXXXX");
		List<HashMap> violtFullList = violtService.getVioltFullList(map);

		return new ModelAndView("ajaxView", "ajaxData", violtFullList);
	}

	@RequestMapping(value = "/violtListAjax/")
	public ModelAndView violtListAjax(HttpServletRequest request) throws Exception  {
        String txtVioltUpperCd = SimpleUtils.default_set(request.getParameter("txtVioltUpperCd"));
		//공백제거
        txtVioltUpperCd = txtVioltUpperCd.replaceAll("(^\\p{Z}+|\\p{Z}+$)", "");

		List<HashMap> violtList = new ArrayList();
        if(!txtVioltUpperCd.isEmpty()){
        	HashMap map = new HashMap();
        	map.put("violt_upper_cd", txtVioltUpperCd);
    		violtList = violtService.getVioltList(map);
        }

		return new ModelAndView("ajaxView", "ajaxData", violtList);
	}


	@RequestMapping(value = "/violtDetailAjax/")
	public ModelAndView violtDetailAjax(HttpServletRequest request) throws Exception  {
        String txtVioltCd = SimpleUtils.default_set(request.getParameter("txtVioltCd"));

    	HashMap map = new HashMap();
    	map.put("violt_cd", txtVioltCd);
		HashMap cMap = violtService.getVioltDetail(map);

		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	@RequestMapping("/addAjax/")
	public ModelAndView addAjax(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

        String txtVioltNm = SimpleUtils.default_set(request.getParameter("txtVioltNm"));
        String txtVioltDc = SimpleUtils.default_set(request.getParameter("txtVioltDc"));
        String txtVioltCn = SimpleUtils.default_set(request.getParameter("txtVioltCn"));

        String txtVioltUpperCd = SimpleUtils.default_set(request.getParameter("txtVioltUpperCd"));
        String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";
		try{
			HashMap map = new HashMap();
			map.put("violt_upper_cd", txtVioltUpperCd);
	    	map.put("violt_nm", txtVioltNm);
	    	map.put("violt_dc", txtVioltDc);
	    	map.put("violt_cn", txtVioltCn);
			map.put("sort_ordr", selSort);
			map.put("esntl_id", esntl_id);
			violtService.addViolt(map);
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

        String hidVioltCd = SimpleUtils.default_set(request.getParameter("hidVioltCd"));
        String txtVioltNm = SimpleUtils.default_set(request.getParameter("txtVioltNm"));
        String txtVioltDc = SimpleUtils.default_set(request.getParameter("txtVioltDc"));
        String txtVioltCn = SimpleUtils.default_set(request.getParameter("txtVioltCn"));
        String selUseYn = SimpleUtils.default_set(request.getParameter("selUseYn"));
        String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";

    	HashMap map = new HashMap();
    	map.put("violt_cd", hidVioltCd);

    	//하위코드가 있는지 확인
    	int cdCnt = 0;
    	if(selUseYn != null && selUseYn.trim().equals("N")) {
    		cdCnt = violtService.getVioltLowerCd (map);
    	}
    	if(cdCnt > 0) {
    		result = "-3";
    	} else {
    		HashMap cMap = violtService.getVioltDetail(map);
    		if(cMap != null){
    	    	map.put("violt_nm", txtVioltNm);
    	    	map.put("violt_dc", txtVioltDc);
    	    	map.put("violt_cn", txtVioltCn);
    			map.put("use_yn", selUseYn);
    			map.put("sort_ordr", selSort);
    			map.put("esntl_id", esntl_id);
    			violtService.updateViolt(map);
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
        return "violt/selectPopup";
    }


}
