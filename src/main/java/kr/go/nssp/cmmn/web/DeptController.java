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
import kr.go.nssp.cmmn.service.DeptService;


@Controller
@RequestMapping(value = "/dept/")
public class DeptController {

	@Resource
	private DeptService deptService;

	@Resource
	private CdService cdService;

	@RequestMapping(value = "/list/")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		//부서구분
    	HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00635");
		List<HashMap> deptSeList = cdService.getCdList(cMap);

		model.addAttribute("deptSeList", deptSeList);
		return "dept/list";
	}

	@RequestMapping(value = "/deptFullListAjax/")
	public ModelAndView deptFullListAjax(HttpServletRequest request) throws Exception  {
    	HashMap map = new HashMap();
    	map.put("start_cd", "XXXXX");
		List<HashMap> deptFullList = deptService.getDeptFullList(map);

		return new ModelAndView("ajaxView", "ajaxData", deptFullList);
	}

	@RequestMapping(value = "/deptListAjax/")
	public ModelAndView deptListAjax(HttpServletRequest request) throws Exception  {
        String txtDeptUpperCd = SimpleUtils.default_set(request.getParameter("txtDeptUpperCd"));
		//공백제거
        txtDeptUpperCd = txtDeptUpperCd.replaceAll("(^\\p{Z}+|\\p{Z}+$)", "");

		List<HashMap> deptList = new ArrayList();
        if(!txtDeptUpperCd.isEmpty()){
        	HashMap map = new HashMap();
        	map.put("dept_upper_cd", txtDeptUpperCd);
    		deptList = deptService.getDeptList(map);

    		int cnt = 0;
    		List<HashMap> tempList = new ArrayList();
			for(HashMap vMap : deptList){
				cnt = Integer.parseInt(vMap.get("LOWER_CNT").toString());
            	if(cnt == 0){
    				vMap.put("children", tempList);
            	}
			}
        }

		return new ModelAndView("ajaxView", "ajaxData", deptList);
	}


	@RequestMapping(value = "/deptDetailAjax/")
	public ModelAndView deptDetailAjax(HttpServletRequest request) throws Exception  {
        String txtDeptCd = SimpleUtils.default_set(request.getParameter("txtDeptCd"));

    	HashMap map = new HashMap();
    	map.put("dept_cd", txtDeptCd);
		HashMap cMap = deptService.getDeptDetail(map);

		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	@RequestMapping("/addAjax/")
	public ModelAndView addAjax(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

        String txtDeptNm = SimpleUtils.default_set(request.getParameter("txtDeptNm"));
        String txtDeptFunc = SimpleUtils.default_set(request.getParameter("txtDeptFunc"));
        String txtDeptTelNo = SimpleUtils.default_set(request.getParameter("txtDeptTelNo"));
        String txtDeptFaxNo = SimpleUtils.default_set(request.getParameter("txtDeptFaxNo"));
        String selDeptSeCd = SimpleUtils.default_set(request.getParameter("selDeptSeCd"));
        String txtDeptZip = SimpleUtils.default_set(request.getParameter("txtDeptZip"));
        String txtDeptAddr = SimpleUtils.default_set(request.getParameter("txtDeptAddr"));
        String selExmnCd = SimpleUtils.default_set(request.getParameter("selExmnCd"));

        String txtDeptUpperCd = SimpleUtils.default_set(request.getParameter("txtDeptUpperCd"));
        String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";
		try{
			HashMap map = new HashMap();
			map.put("dept_upper_cd", txtDeptUpperCd);
	    	map.put("dept_nm", txtDeptNm);
	    	map.put("dept_func", txtDeptFunc);
	    	map.put("dept_tel_no", txtDeptTelNo);
	    	map.put("dept_fax_no", txtDeptFaxNo);
	    	map.put("dept_se_cd", selDeptSeCd);
	    	map.put("dept_zip", txtDeptZip);
	    	map.put("dept_addr", txtDeptAddr);
	    	map.put("cmptnc_exmn_cd", selExmnCd);
			map.put("sort_ordr", selSort);
			map.put("esntl_id", esntl_id);
			deptService.addDept(map);
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

        String hidDeptCd = SimpleUtils.default_set(request.getParameter("hidDeptCd"));
        String txtDeptNm = SimpleUtils.default_set(request.getParameter("txtDeptNm"));
        String txtDeptFunc = SimpleUtils.default_set(request.getParameter("txtDeptFunc"));
        String txtDeptTelNo = SimpleUtils.default_set(request.getParameter("txtDeptTelNo"));
        String txtDeptFaxNo = SimpleUtils.default_set(request.getParameter("txtDeptFaxNo"));
        String selDeptSeCd = SimpleUtils.default_set(request.getParameter("selDeptSeCd"));
        String txtDeptZip = SimpleUtils.default_set(request.getParameter("txtDeptZip"));
        String txtDeptAddr = SimpleUtils.default_set(request.getParameter("txtDeptAddr"));
        String selExmnCd = SimpleUtils.default_set(request.getParameter("selExmnCd"));
        String selUseYn = SimpleUtils.default_set(request.getParameter("selUseYn"));
        String selSort = SimpleUtils.default_set(request.getParameter("selSort"));

        String result = "1";

    	HashMap map = new HashMap();
    	map.put("dept_cd", hidDeptCd);

    	//하위 부서 있는지 확인
    	int dpCnt = 0;
    	if(selUseYn != null && selUseYn.trim().equals("N")) {
    		dpCnt = deptService.getDeptLowerCd (map);
    	}
    	if(dpCnt > 0) {
    		result = "-3";
    	} else {
    		HashMap cMap = deptService.getDeptDetail(map);
    		if(cMap != null){
    	    	map.put("dept_nm", txtDeptNm);
    	    	map.put("dept_func", txtDeptFunc);
    	    	map.put("dept_tel_no", txtDeptTelNo);
    	    	map.put("dept_fax_no", txtDeptFaxNo);
    	    	map.put("dept_se_cd", selDeptSeCd);
    	    	map.put("dept_zip", txtDeptZip);
    	    	map.put("dept_addr", txtDeptAddr);
    	    	map.put("cmptnc_exmn_cd", selExmnCd);
    			map.put("use_yn", selUseYn);
    			map.put("sort_ordr", selSort);
    			map.put("esntl_id", esntl_id);
    			deptService.updateDept(map);
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
        return "dept/selectPopup";
    }


}
