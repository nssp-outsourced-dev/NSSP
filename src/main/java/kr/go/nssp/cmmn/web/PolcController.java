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
import kr.go.nssp.cmmn.service.PolcService;


@Controller
@RequestMapping(value = "/polc/")
public class PolcController {

	@Resource
	private PolcService polcService;

	@Resource
	private CdService cdService;

	@RequestMapping(value = "/list/")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		//부서구분
    	HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00635");
		List<HashMap> polcSeList = cdService.getCdList(cMap);

		//관할검찰
    	cMap.put("upper_cd", "00104");
		List<HashMap> polcList = cdService.getCdList(cMap);

		model.addAttribute("polcSeList", polcSeList);
		model.addAttribute("polcList", polcList);
		return "polc/list";
	}

	@RequestMapping(value = "/polcFullListAjax/")
	public ModelAndView polcFullListAjax(HttpServletRequest request) throws Exception  {
		HashMap map = new HashMap();
    	map.put("start_cd", "XXXXX");
		List<HashMap> polcFullList = polcService.getPolcFullList(map);

		return new ModelAndView("ajaxView", "ajaxData", polcFullList);
	}

	@RequestMapping(value = "/polcListAjax/")
	public ModelAndView polcListAjax(HttpServletRequest request) throws Exception  {
        String txtPolcUpperCd = SimpleUtils.default_set(request.getParameter("txtPolcUpperCd"));
		//공백제거
        txtPolcUpperCd = txtPolcUpperCd.replaceAll("(^\\p{Z}+|\\p{Z}+$)", "");

		List<HashMap> polcList = new ArrayList();
        if(!txtPolcUpperCd.isEmpty()){
        	HashMap map = new HashMap();
        	map.put("polc_upper_cd", txtPolcUpperCd);
        	polcList = polcService.getPolcList(map);

    		int cnt = 0;
    		List<HashMap> tempList = new ArrayList();
			for(HashMap vMap : polcList){
				cnt = Integer.parseInt(vMap.get("LOWER_CNT").toString());
            	if(cnt == 0){
    				vMap.put("children", tempList);
            	}
			}
        }

		return new ModelAndView("ajaxView", "ajaxData", polcList);
	}


	@RequestMapping(value = "/polcDetailAjax/")
	public ModelAndView polcDetailAjax(HttpServletRequest request) throws Exception  {
        String txtPolcCd = SimpleUtils.default_set(request.getParameter("txtPolcCd"));

    	HashMap map = new HashMap();
    	map.put("polc_cd", txtPolcCd);
		HashMap cMap = polcService.getPolcDetail(map);

		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	@RequestMapping("/addAjax/")
	public ModelAndView addAjax(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

        String txtPolcNm = SimpleUtils.default_set(request.getParameter("txtPolcNm"));
        String txtCmptncDc = SimpleUtils.default_set(request.getParameter("txtCmptncDc"));

        String txtPolcUpperCd = SimpleUtils.default_set(request.getParameter("txtPolcUpperCd"));
        String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";
		try{
			HashMap map = new HashMap();
			map.put("polc_upper_cd", txtPolcUpperCd);
	    	map.put("polc_nm", txtPolcNm);
	    	map.put("polc_cmptnc_dc", txtCmptncDc);
			map.put("sort_ordr", selSort);
			map.put("esntl_id", esntl_id);
			polcService.addPolc(map);
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

        String hidPolcCd = SimpleUtils.default_set(request.getParameter("hidPolcCd"));
        String txtPolcNm = SimpleUtils.default_set(request.getParameter("txtPolcNm"));
        String txtCmptncDc = SimpleUtils.default_set(request.getParameter("txtCmptncDc"));
        String selUseYn = SimpleUtils.default_set(request.getParameter("selUseYn"));
        String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";

    	HashMap map = new HashMap();
    	map.put("polc_cd", hidPolcCd);

    	//하위코드가 있는지 확인
    	int cdCnt = 0;
    	if(selUseYn != null && selUseYn.trim().equals("N")) {
    		cdCnt = polcService.getPolcLowerCd (map);
    	}
    	if(cdCnt > 0) {
    		result = "-3";
    	} else {
    		HashMap cMap = polcService.getPolcDetail(map);
    		if(cMap != null){
    	    	map.put("polc_nm", txtPolcNm);
    	    	map.put("polc_cmptnc_dc", txtCmptncDc);
    			map.put("use_yn", selUseYn);
    			map.put("sort_ordr", selSort);
    			map.put("esntl_id", esntl_id);
    			polcService.updatePolc(map);
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
        return "polc/selectPopup";
    }


}
