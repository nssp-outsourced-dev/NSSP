package kr.go.nssp.inv.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.go.nssp.utl.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.inv.service.ArrstService;
import kr.go.nssp.inv.service.SzureService;
import kr.go.nssp.utl.InvUtil;

@Controller
@RequestMapping(value = "/inv/")
public class SzureController {

	@Resource
	private ArrstService arrstService;
	@Resource
	private SzureService szureService;
	@Resource
	private CdService cdService;

	/**
	 * 압수/수색/검증영장 관리
	 * @return "/inv/szure/"
	 * @exception Exception
	 */
	@RequestMapping (value = "/szure/")
	public String  szure (HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {
		HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00789");
    	map.addAttribute("szureZrlongLst", cdService.getCdList(cMap));
		return "inv/szure";
	}

	/**
	 * 압수/수색/검증영장 피의자 목록 조회
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/suspectSzureListAjax/")
	@ResponseBody
	public List<HashMap> suspectSzureListAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = arrstService.selectSuspectList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

	/**
	 * 피의자별 압수/수색/검증영장 목록 조회
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/szureListAjax/")
	@ResponseBody
	public List<HashMap> szureListAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = szureService.selectSzureList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	/**
	 * 피의자별 압수/수색/검증영장 상세 조회
	 * @return Map
	 * @exception Exception
	 */
	@RequestMapping (value = "/szureDtlAjax/")
	@ResponseBody
	public Map szureDtl (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	Map dtlMap = szureService.selectSzureDtl(map);
    	dtlMap = commonUtil.getConvertUnderscoreName(dtlMap);
		return dtlMap;
	}
	/**
	 * 피의자별 압수/수색/검증영장 결과 조회
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/szureRstListAjax/")
	@ResponseBody
	public List<HashMap> szureRstListAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = szureService.selectSzureRstList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

	/**
	 * 압수/수색/검증영장 신청 저장
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/saveSzureAjax/")
	@ResponseBody
    public ModelAndView saveSzureAjax(HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
        Map map = commonUtil.getParameterMapConvert(request);
    	map.put("esntl_id", esntl_id);
    	Map value = szureService.saveSzureReq (map);
    	HashMap cMap = new HashMap();
    	cMap.put("rst", value);
    	if(value != null ) {
    		List<HashMap> list = szureService.selectSzureList(map);
    		cMap.put("list", commonUtil.getConvertUnderscoreNameGrid(list));
    	}
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }

	/**
	 * 압수/수색/검증영장 결과 저장
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/saveSzureRstAjax/")
	@ResponseBody
    public ModelAndView saveSzureRstAjax(HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
        Map map = commonUtil.getParameterMapConvert(request);
    	map.put("esntl_id", esntl_id);
    	Map value = szureService.saveSzureRst (map);
    	HashMap cMap = new HashMap();
    	cMap.put("rst", value);
    	if(value != null ) {
    		List<HashMap> list = szureService.selectSzureList(map);
    		cMap.put("list", commonUtil.getConvertUnderscoreNameGrid(list));
    	}
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }

	/**
	 * 압수/수색/검증영장 계좌 목록 조회
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value="/szureAcnutListAjax/")
	@ResponseBody
    public ModelAndView szureAcnutList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
        Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = szureService.selectSzureAcnutList(map);
    	if(list != null) {
    		list = commonUtil.getConvertUnderscoreNameGrid(list);
    	}
        return new ModelAndView("ajaxView", "ajaxData", list);
    }

	/**
	 * 압수/수색/검증영장 피의자 목록 조회
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value="/szureTrgterListAjax/")
	@ResponseBody
    public ModelAndView szureTrgterList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
        Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = szureService.selectSzureTrgterList(map);
    	if(list != null) {
    		list = commonUtil.getConvertUnderscoreNameList(list);
    	}
        return new ModelAndView("ajaxView", "ajaxData", list);
    }
}
