package kr.go.nssp.inv.web;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.inv.service.ArrstService;
import kr.go.nssp.inv.service.PrsctService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;

@Controller
@RequestMapping(value = "/inv/")
public class ArrstController {

	@Resource
	private CdService cdService;
	@Resource
	private ArrstService arrstService;
	@Autowired
	private PrsctService prsctService;

	/**
	 * 체포/구속영장 관리
	 * @return "/inv/arrst/"
	 * @exception Exception
	 */
	@RequestMapping (value = "/zrlong/")
	public String  arrst (HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00102");	//대상자구분
    	map.addAttribute("trgterSeList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00772"); //영장구분
    	map.addAttribute("zrlongSeLst", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00775"); //구속영장구분
    	map.addAttribute("arsttCdLst", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00776"); //필요고려사항
    	map.addAttribute("NeedCnsdrLst", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00789");
    	map.addAttribute("szureZrlongLst", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "01108");  //석방사유
    	map.addAttribute("rslResnList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "01112");  //집행불능사유
    	map.addAttribute("excutSeList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "01338"); //계좌명의인
    	map.addAttribute("acnutNmLst", cdService.getCdList(cMap));

    	/*통신사실허가신청*/
    	List<String> arr = new ArrayList<String>();
    	arr.add("00737");
		cMap.put("upper_cd", "00736");
		cMap.put("cd_not_arr", arr);
		map.addAttribute("reqstResultCdList", cdService.getCdList(cMap));
		cMap.put("upper_cd", "00741");//허가구분
		map.addAttribute("prmisnSeCdLst", cdService.getCdList(cMap));
		cMap.put("upper_cd", "00744");//전기통신사업자
		map.addAttribute("commnBsnmCdLst", cdService.getCdList(cMap));
		cMap.put("upper_cd", "00736");//통신사실 신청 결과 상태
		map.addAttribute("reqstResultCdLst", cdService.getCdList(cMap));
		cMap.put("upper_cd", "00748"); // 통신사실확인 허가신청 기각구분
		map.addAttribute("dsmsslSeCdList", cdService.getCdList(cMap));

		//내사건 관리에서 넘겨받는 값
		map.put("hidRcNo",    Utility.nvl(request.getParameter("hidRcNo")));
    	map.put("hidTrgterSn",  Utility.nvl(request.getParameter("hidTrgterSn")));
    	map.put("hidPageType",  Utility.nvl(request.getParameter("hidPageType")));
    	map.put("hidLoginNm",  request.getSession().getAttribute("user_nm"));
		return "inv/zrlong";
	}

	/**
	 * 긴급체포/현행범인체포관리
	 * @return "/inv/emgcArst/"
	 * @exception Exception
	 */
	@RequestMapping (value = "/emgcArrst/")
	public String  emgcArrst (HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {
		HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00731");	/*체포유형코드*///
    	map.addAttribute("arrstTyList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00759");	//체포자구분코드
    	map.addAttribute("arresterSeList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00102");
    	map.addAttribute("trgterSeList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "01108");  //석방사유
    	map.addAttribute("rslResnList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "02145");  //소재발견 유형
    	map.addAttribute("dscvryTyList", cdService.getCdList(cMap));
    	map.put("hidRcNo",    Utility.nvl(request.getParameter("hidRcNo")));
    	map.put("hidTrgterSn",  Utility.nvl(request.getParameter("hidTrgterSn")));
    	map.put("hidArrstTyCd", Utility.nvl(request.getParameter("hidArrstTyCd")));
    	map.put("hidPageType", Utility.nvl(request.getParameter("hidPageType")));
    	map.put("hidLoginNm",  request.getSession().getAttribute("user_nm"));
		return "inv/emgcArrst";
	}
	/**
	 * 피의자 목록 조회
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/suspectListAjax/")
	@ResponseBody
	public List<HashMap> suspectListAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	map.put("esntl_id", esntl_id);
    	map.put("page_type", "arrst");
    	List<HashMap> list = arrstService.selectSuspectList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	/**
	 * 긴급체포/현행범인체포관리
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/arrstListAjax/")
	@ResponseBody
	public List<HashMap> arrstListAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = arrstService.selectArrstList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	/**
	 * 긴급체포/현행범인체포관리
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/arrstDtlAjax/")
	@ResponseBody
	public Map arrstDtlAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	Map dtlMap = arrstService.selectArrstDtl(map);
    	dtlMap = commonUtil.getConvertUnderscoreName(dtlMap);
		return dtlMap;
	}

	/**
	 * 사건번호 당 대상자에 대한 출석 요구 저장
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/saveEmgcArrstAjax/")
	@ResponseBody
    public ModelAndView saveEmgcArrstAjax(HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	//String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
        Map map = commonUtil.getParameterMapConvert(request);
    	map.put("esntl_id", esntl_id);
    	Map value = arrstService.saveEmgcArrst (map);
    	HashMap cMap = new HashMap();
    	cMap.put("cnt", value.get("arrstSn"));
    	if(value != null && value.get("arrstSn") != null) {
    		List<HashMap> list = arrstService.selectArrstList(map);
    		cMap.put("list", commonUtil.getConvertUnderscoreNameGrid(list));
    		cMap.put("rtnValue", value);
    	}
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }
	/**
	 * 체포/구속영장관리
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/zrlongListAjax/")
	@ResponseBody
	public List<HashMap> zrlongListAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	List<HashMap> list = arrstService.selectZrlongList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	/**
	 * 체포/구속영장 상세 보기
	 * @return Map
	 * @exception Exception
	 */
	@RequestMapping (value = "/zrlongDtlAjax/")
	@ResponseBody
	public Map zrlongDtl (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	Map dtlMap = arrstService.selectZrlongDtl(map);
    	dtlMap = commonUtil.getConvertUnderscoreName(dtlMap);
		return dtlMap;
	}

	/**
	 * 체포/구속영장 피의자 목록 조회
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/suspectZrlongListAjax/")
	@ResponseBody
	public List<HashMap> suspectZrlongListAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	map.put("esntl_id", esntl_id);
    	List<HashMap> list = arrstService.selectSuspectList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

	/**
	 * 피의자 체포/구속영장 저장
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/saveZrlongAjax/")
	@ResponseBody
    public ModelAndView saveZrlongAjax(HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
        Map map = commonUtil.getParameterMapConvert(request);
    	map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	Map value = arrstService.saveZrlong (map);
    	HashMap cMap = new HashMap();
    	cMap.put("rst", value);
    	if(value != null ) {
    		List<HashMap> list = arrstService.selectZrlongList(map);
    		cMap.put("list", commonUtil.getConvertUnderscoreNameGrid(list));
    	}
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }

	/**
	 * 피의자 체포/구속영장 결과 저장
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/saveZrlongRstAjax/")
	@ResponseBody
    public ModelAndView saveZrlongRstAjax(HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
        Map map = commonUtil.getParameterMapConvert(request);
    	map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	Map value = arrstService.saveZrlongRst (map);
    	HashMap cMap = new HashMap();
    	cMap.put("rst", value);
    	if( value != null ) {
    		List<HashMap> list = arrstService.selectZrlongList(map);
    		cMap.put("list", commonUtil.getConvertUnderscoreNameGrid(list));
    	}
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }
	/**
	 * 상단 사건번호 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/arrstCaseListAjax/")
	@ResponseBody
	public List<HashMap> arrstCaseList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		Map map = commonUtil.getParameterMapConvert(request);
		map.put("esntl_id", esntl_id);
		map.put("dept_cd", dept_cd);
		map.put("page_type", "arrst");
    	List<HashMap> list = prsctService.selectCaseList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	/**
	 * 상단 사건번호 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/zrlongCaseListAjax/")
	@ResponseBody
	public List<HashMap> zrlongCaseList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		Map map = commonUtil.getParameterMapConvert(request);
		map.put("esntl_id", esntl_id);
		map.put("dept_cd", dept_cd);
		//영장관리
		map.put("page_type", "zrlong");
    	List<HashMap> list = prsctService.selectCaseList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

	/**
	 * 상세보기 팝업 영장정보 목록 이동
	 * @return "/inv/pop/zrlongPopup"
	 * @exception Exception
	 */
	@RequestMapping (value = "/zrlongPopup/")
	public String  zrlongPopup (HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {
		//대상자구분
		HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00772"); //영장구분
    	map.addAttribute("zrlongSeLst", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00775"); //구속영장구분
    	map.addAttribute("arsttCdLst", cdService.getCdList(cMap));
    	map.put("rcNo", Utility.nvl(request.getParameter("hidRcNo")));
		return "inv/pop/zrlongPopup";
	}

	/**
	 * 상세보기 팝업 사건번호 당 대상자에 대한 영장정보 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/zrlongPopupLstAjax/")
	@ResponseBody
	public List<HashMap> zrlongPopupLst (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
		List<HashMap> list = arrstService.selectZrlongList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

	/**
	 * 압수수색관리 계좌정보 입력 팝업
	 * @return "/inv/acnutPopup/"
	 * @exception Exception
	 */
	@RequestMapping (value = "/acnutPopup/")
	public String  acnutPopup (HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "01338"); //계좌명의인
    	map.addAttribute("acnutNmLst", cdService.getCdList(cMap));
    	map.put("hidRcNo",    Utility.nvl(request.getParameter("hidRcNo")));
    	map.put("hidTrgterSn",  Utility.nvl(request.getParameter("hidTrgterSn")));
    	map.put("hidZrlongReqstNo", Utility.nvl(request.getParameter("hidZrlongReqstNo")));
    	map.put("hidTrgterNm", Utility.nvl(request.getParameter("hidTrgterNm")));
		return "inv/pop/acnutPopup";
	}

	/**
	 * 기소중지자 정보 상세 보기
	 * @return Map
	 * @exception Exception
	 */
	@RequestMapping (value = "/stprscDtlAjax/")
	@ResponseBody
	public Map stprscDtl (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	Map dtlMap = new HashMap();
    	String sType = Utility.nvl(map.get("sel_tab_id"));
    	if(sType.equals("refe")) {
    		dtlMap = arrstService.selectRefeDtl(map);
    	} else {
    		dtlMap = arrstService.selectStprscDtl(map);
    	}
    	dtlMap = commonUtil.getConvertUnderscoreName(dtlMap);
		return dtlMap;
	}

	/**
	 * 기소중지자, 참고자 중지 대상자 목록 조회
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/stprscSuspectListAjax/")
	@ResponseBody
	public List<HashMap> stprscSuspectList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	map.put("esntl_id", esntl_id);
    	map.put("page_type", "arrst");
    	List<HashMap> list = new ArrayList();
    	String psd = Utility.nvl(map.get("sel_tab_id"));
    	if(psd.equals("refe")) {
    		list = arrstService.selectRefeSuspectList(map);
    	} else {
    		list = arrstService.selectStprscSuspectList(map);
    	}
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	/**
	 * 수사 기소중지 보고 목록 조회
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/stprscReportListAjax/")
	@ResponseBody
	public List<HashMap> stprscReportList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		List<HashMap> list = new ArrayList();
		String sType = Utility.nvl(map.get("sel_tab_id"));
    	if(sType.equals("refe")) {
    		list = arrstService.selectRefeReportList(map);
    	} else {
    		list = arrstService.selectStprscReportList(map);
    	}
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	/**
	 * 기소중지 기본정보 저장
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/saveStprscAjax/")
	@ResponseBody
    public ModelAndView saveStprsc(HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
        Map map = commonUtil.getParameterMapConvert(request);
    	map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);

    	int value = 0;
    	String pageType = Utility.nvl(map.get("sel_tab_id"));
    	if(pageType.equals("refe")) {
    		value = arrstService.saveRefestpge (map);
    	} else {
    		value = arrstService.saveStprsc (map);
    	}
    	HashMap cMap = new HashMap();
    	cMap.put("rst", value);
    	if( value > 0 ) {
    		Map dtlMap = new HashMap ();
    		if(pageType.equals("refe")) {
    			dtlMap = arrstService.selectRefeDtl(map);
    		} else {
    			dtlMap = arrstService.selectStprscDtl(map);
    		}
    		cMap.put("data", commonUtil.getConvertUnderscoreName(dtlMap));
    	}
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }
	/**
	 * 수사 기소중지 보고 저장
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping ("/saveStprscReportAjax/")
	public ModelAndView saveStprscReport (HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception {
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	param.put("esntl_id", esntl_id);
    	param.put("dept_cd", dept_cd);
    	int rtnVal = arrstService.saveStprscReport (param);
    	HashMap cMap = new HashMap();
    	if( rtnVal > 0 ) {
    		Map rtnMap = new HashMap ();
    		rtnMap.put("rc_no", Utility.nvl(param.get("hidRcNo")));
    		rtnMap.put("trgter_sn", Utility.nvl(param.get("hidTrgterSn")));
    		String pageType = Utility.nvl(param.get("hidSelTabId"));
    		List<HashMap> list = new ArrayList ();
    		if(pageType.equals("refe")) {
    			list = arrstService.selectRefeReportList(rtnMap);
    		} else {
    			list = arrstService.selectStprscReportList(rtnMap);
    		}
        	cMap.put("list", InvUtil.getInstance().getConvertUnderscoreNameGrid(list));
    	}
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 기소중지 발견 상세 보기
	 * @return Map
	 * @exception Exception
	 */
	@RequestMapping (value = "/stprscDscvryDtlAjax/")
	@ResponseBody
	public Map stprscDscvryDtl (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	Map dtlMap = new HashMap();
    	String sType = Utility.nvl(map.get("sel_tab_id"));
    	if(sType.equals("refe")) {
    		dtlMap = arrstService.selectRefeDscvryDtl(map);
    	} else {
    		dtlMap = arrstService.selectStprscDscvryDtl(map);
    	}
    	dtlMap = commonUtil.getConvertUnderscoreName(dtlMap);
		return dtlMap;
	}

	/**
	 * 기소중지 발견 저장
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/saveStprscDscvryAjax/")
	@ResponseBody
    public ModelAndView saveStprscDscvry (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
        Map map = commonUtil.getParameterMapConvert(request);
        map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	String sType = Utility.nvl(map.get("sel_tab_id"));
    	String value = "";

    	if(sType.equals("refe")) {
    		value = arrstService.saveRefeDscvry (map);
    	} else {
    		value = arrstService.saveStprscDscvry (map);
    	}

    	HashMap cMap = new HashMap();
    	cMap.put("rst", value);
    	if( value != null && value.length() == 11 ) {
    		Map dtlMap = new HashMap ();
    		if(sType.equals("refe")) {
    			dtlMap = arrstService.selectRefeDscvryDtl(map);
    		} else {
    			dtlMap = arrstService.selectStprscDscvryDtl(map);
    		}
    		cMap.put("data", commonUtil.getConvertUnderscoreName(dtlMap));
    	}
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }

	/**
	 * 기소중지 발견 삭제
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/deleteStprscDscvryAjax/")
	@ResponseBody
    public ModelAndView deleteStprscDscvry (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
        Map map = commonUtil.getParameterMapConvert(request);
        map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	String sType = Utility.nvl(map.get("sel_tab_id"));
    	int value = 0;
    	if(sType.equals("refe")) {
    		value = arrstService.deleteRefeDscvry (map);
    	} else {
    		value = arrstService.deleteStprscDscvry (map);
    	}
    	HashMap cMap = new HashMap();
    	cMap.put("rst", value);
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }

	/**
	 * 수사 재개
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/saveResmptAjax/")
	@ResponseBody
    public ModelAndView saveResmpt (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
        Map map = commonUtil.getParameterMapConvert(request);
        map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	int value = arrstService.saveResmpt (map);
    	HashMap cMap = new HashMap();
    	cMap.put("rst", value);
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }

	/**
	 * 기소중지 지명수배 입력 여부 확인
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getStpDocChkAjax/")
	public ModelAndView getStpDocChkAjax (HttpServletRequest request) throws Exception {
	    String hidRcNo = SimpleUtils.default_set(request.getParameter("hidRcNo"));
	    String hidTrgterSn = SimpleUtils.default_set(request.getParameter("hidTrgterSn"));
        Map result = new HashMap();
		try{
	    	HashMap map = new HashMap();
	    	map.put("rc_no" , hidRcNo);
	    	map.put("trgter_sn" , hidTrgterSn);
	    	result = arrstService.getStpDocChkAjax(map);
		}catch(Exception e){
			result = new HashMap();
		}

		return new ModelAndView("ajaxView", "ajaxData", result);
	}
}
