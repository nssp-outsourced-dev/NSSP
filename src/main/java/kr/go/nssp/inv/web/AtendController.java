 package kr.go.nssp.inv.web;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.inv.service.AtendService;
import kr.go.nssp.inv.service.PrsctService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;

@Controller
@RequestMapping(value = "/inv/")
public class AtendController {

	@Autowired
	private AtendService atendService;
	@Resource
	private CdService cdService;
	@Autowired
	private PrsctService prsctService;

	/**
	 * 출석요구관리 화면 이동
	 * @return "/inv/atend/"
	 * @exception Exception
	 */
	@RequestMapping (value = "/atend/")
	public String  atend (HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {
		//대상자구분
    	HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00102");
    	map.addAttribute("trgterSeList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00103");
    	map.addAttribute("atendNticeCd", cdService.getCdList(cMap));
    	map.put("hidRcNo", Utility.nvl(request.getParameter("hidRcNo")));
    	map.put("hidTrgterSn", Utility.nvl(request.getParameter("hidTrgterSn")));
    	map.put("hidLoginNm",  request.getSession().getAttribute("user_nm"));
		return "inv/atendList";
	}
	/**
	 * 사건번호 당 대상자 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/trgterList/")
	@ResponseBody
	public List<HashMap> trgterList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = atendService.selectTrgterList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	/**
	 * 사건번호 당 대상자에 대한 출석 요구 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/atendListAjax/")
	@ResponseBody
	public List<HashMap> atendList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	List<HashMap> list = atendService.selectAtendList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	/**
	 * 사건번호 당 대상자에 대한 출석 요구 저장
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/saveAtendAjax/")
	@ResponseBody
    public ModelAndView saveAtendAjax(HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
        Map map = commonUtil.getParameterMapConvert(request);
    	map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	Map value = atendService.saveAtend (map);
    	HashMap cMap = new HashMap();
    	cMap.put("cnt", value.get("demandSn"));
    	if(value != null && value.get("demandSn") != null) {
    		List<HashMap> list = atendService.selectAtendList(map);
    		cMap.put("list", commonUtil.getConvertUnderscoreNameGrid(list));
    		cMap.put("rtnValue", value);
    	}
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }
	/**
	 * 사건번호 당 대상자에 대한 출석 요구 상세보기
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/searchAtendDetailAjax/")
	@ResponseBody
	public ModelAndView searchAtendDetailAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	HashMap detail = atendService.selectAtendDetail(map);
    	detail = commonUtil.getConvertUnderscoreName(detail);
    	HashMap cMap = new HashMap();
    	cMap.put("detail", detail);
    	//cMap.put("docList", docList);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
	/**
	 * 상단 사건번호 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/atendCaseListAjax/")
	@ResponseBody
	public List<HashMap> atendCaseList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
		Map map = commonUtil.getParameterMapConvert(request);
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	map.put("page_type", "atend");
    	List<HashMap> list = prsctService.selectCaseList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

	/**
	 * 상세보기 팝업 출석요구 목록 이동
	 * @return "/inv/pop/atendPopup"
	 * @exception Exception
	 */
	@RequestMapping (value = "/atendPopup/")
	public String  atendPopup (HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {
		//대상자구분
    	HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00102");
    	map.addAttribute("trgterSeList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00103");	/*출석통지코드*/
    	map.addAttribute("atendNticeCd", cdService.getCdList(cMap));
    	map.put("rcNo", Utility.nvl(request.getParameter("hidRcNo")));
		return "inv/pop/atendPopup";
	}

	/**
	 * 상세보기 팝업 사건번호 당 대상자에 대한 출석 요구 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/atendPopupLstAjax/")
	@ResponseBody
	public List<HashMap> atendPopupLst (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	List<HashMap> list = atendService.selectAtendList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
}
