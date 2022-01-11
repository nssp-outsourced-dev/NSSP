package kr.go.nssp.inv.web;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.inv.service.AtendService;
import kr.go.nssp.inv.service.PrsctService;
import kr.go.nssp.inv.service.RcdMgtService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;

@Controller
@RequestMapping(value = "/inv/")
public class RcdMgtController {

	@Resource
	private CdService cdService;
	@Resource
	private PrsctService prsctService;
	@Resource
	private AtendService atendService;
	@Resource
	private DocService docService;
	@Resource
	private RcdMgtService rcdMgtService;

	/**
	 * 조서관리
	 * @return "/inv/rcdMgt/"
	 * @exception Exception
	 */
	@RequestMapping (value = "/rcdMgt/")
	public String  atend (HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {
		HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00102");
    	map.addAttribute("trgterSeList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00011");
    	map.addAttribute("progrsSttusList", cdService.getCdList(cMap));	//진행상태 공통코드
    	map.put("hidRcNo", Utility.nvl(request.getParameter("hidRcNo")));
    	map.put("hidTrgterSn", Utility.nvl(request.getParameter("hidTrgterSn")));

    	HashMap qmap = new HashMap();
    	qmap.put("format_cl_cd", "00445");
    	List<HashMap> formatClList = docService.getFormatClList(qmap);
    	map.addAttribute("formatClList", formatClList);

		return "inv/rcdMgt";
	}
	/**
	 * 사건번호 조회
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping (value = "/rcdMgtDtlAjax/")
	@ResponseBody
	public ModelAndView rcdMgtDtlAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		List<HashMap> list = prsctService.selectPrsctList(map);
    	HashMap detail = list.size()>0?list.get(0):new HashMap();
    	HashMap cMap = new HashMap();
    	cMap.put("detail", commonUtil.getConvertUnderscoreName(detail));
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
	/**
	 * 입건대상자 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/prsctTrgterList/")
	@ResponseBody
	public List<HashMap> prsctTrgterList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = atendService.selectTrgterList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	/**
	 * 상단 사건번호 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/rmCaseListAjax/")
	@ResponseBody
	public List<HashMap> rmCaseList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
		map.put("page_type", "rcdMgt");
    	List<HashMap> list = prsctService.selectCaseList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	
	/**
	 * 조서관리 입건대상자 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
    @RequestMapping(value="/rcdMgtTrgterListAjax/")
    public ModelAndView rcdMgtTrgterListAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	InvUtil commonUtil = InvUtil.getInstance();
        String searchRcNo = SimpleUtils.default_set(request.getParameter("searchRcNo"));
    	HashMap map = new HashMap();
		map.put("rc_no", searchRcNo);
    	List<HashMap> rcTrgterList = atendService.selectRcTrgterList(map);
    	rcTrgterList = commonUtil.getConvertUnderscoreNameGrid(rcTrgterList);

		for(HashMap vMap : rcTrgterList){
			map.put("trgter_sn", vMap.get("grdTrgterSn"));
			map.put("doc_id", vMap.get("grdDocId"));
			map.put("file_id", vMap.get("grdFileId"));

			//수사보고 01345
			//map.put("format_cl_cd", "01345");
        	//List<HashMap> docList1 = atendService.selectRcTrgterDocList(map);

			//입건조서 00445
			//map.put("format_cl_cd", "00445");
			//List<HashMap> docList2 = atendService.selectRcTrgterDocList(map);

			//피의자 구분에 따른 FORMAT_ID
			String strCd = vMap.get("grdTrgterSeCd")==null?"":vMap.get("grdTrgterSeCd").toString();
			String strRcSeCd = vMap.get("grdRcSeCd")==null?"":vMap.get("grdRcSeCd").toString();

			List<String> fm_arr = new ArrayList<String>();
			if(strCd.equals("00697") || strCd.equals("01364") || strCd.equals("01365") ) { // 피의자, 피고발인, 피고소인  2019.09.23 권종열 수사관 요청사항
				fm_arr.add("00000000000000000032");		// 피의자 신문조서
				map.put("format_id_arr", fm_arr);
			} else if (strCd.equals("90000")) {			// 사건기준
				fm_arr.add("00000000000000000138");
				if("F".equals(strRcSeCd)) {
					fm_arr.add("00000000000000000070"); // 수사결과보고서
				}
				map.put("format_id_arr", fm_arr);   	// 수사보고서
			} else {
				fm_arr.add("00000000000000000014"); 	// 진술조서, 피의자/피고발인/피고소인 제외
				map.put("format_id_arr", fm_arr);
			}
			
        	List<HashMap> docList = atendService.selectRcTrgterDocList(map);
			vMap.put("children", commonUtil.getConvertUnderscoreNameGrid(docList));
		}
		return new ModelAndView("ajaxView", "ajaxData", rcTrgterList);
    }


	/**
	 * 사건번호 당 대상자 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/rmTrgterListAjax/")
	@ResponseBody
	public HashMap rmTrgterListAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = atendService.selectTrgterList(map);
    	HashMap rMap = new HashMap ();
    	if(list != null && list.size() > 0) {
    		rMap = commonUtil.getConvertUnderscoreName(list.get(0));
    	}
		return rMap;
	}

	/**
	 * 영상녹화시필요적 고려사항
	 * @return "/inv/recInfoPopup/"
	 * @exception Exception
	 */
	@RequestMapping (value = "/recInfoPopup/")
	public String  recInfoPopup (HttpServletRequest request) throws Exception {
		return "inv/pop/recInfoPopup";
	}

	/**
	 * 수사 재개
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/saveVdoRecAjax/")
	@ResponseBody
    public ModelAndView saveVdoRec (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
        Map map = commonUtil.getParameterMapConvert(request);
        map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	int value = rcdMgtService.saveVdoRec (map);
    	HashMap cMap = new HashMap();
    	cMap.put("rst", value);
    	
    	List<HashMap> list = rcdMgtService.selectVidoTrplant(map);
    	cMap.put("list", commonUtil.getConvertUnderscoreNameGrid(list));
    	
    	HashMap detail = rcdMgtService.selectVidoTrplantDetail(map);
    	cMap.put("rtnValue", commonUtil.getConvertUnderscoreName(detail));
    	
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }
	
	/** 
	 * @methodName : vidoTrplant
	 * @date : 2021.12.20
	 * @author : dgkim
	 * @description : 
	 * @param request
	 * @param response
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/vidoTrplant/")
	public String  vidoTrplant (HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {
		//대상자구분
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00102");
		map.addAttribute("trgterSeList", cdService.getCdList(cMap));
		cMap.put("upper_cd", "00103");
		map.addAttribute("atendNticeCd", cdService.getCdList(cMap));
		map.put("hidRcNo", Utility.nvl(request.getParameter("hidRcNo")));
		map.put("hidTrgterSn", Utility.nvl(request.getParameter("hidTrgterSn")));
		map.put("hidLoginNm",  request.getSession().getAttribute("user_nm"));
		
		return "inv/vidoTrplant";
	}
	
	/** 
	 * @methodName : VidoTrplantAjax
	 * @date : 2021.12.23
	 * @author : dgkim
	 * @description : 영상 녹화 동의서의 별도 메뉴 구현으로 인한 추가 
	 * 					김지만 수사관 요청
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/vidoTrplantAjax/")
	public @ResponseBody List<HashMap> vidoTrplantAjax(HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		map.put("esntl_id", esntl_id);
		map.put("dept_cd", dept_cd);
		List<HashMap> list = (List<HashMap>) rcdMgtService.selectVidoTrplant(map);
		list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}
	
	/** 
	 * @methodName : searchVidoTrplantDetailAjax
	 * @date : 2021.12.23
	 * @author : dgkim
	 * @description : 영상 녹화 동의서의 별도 메뉴 구현으로 인한 상세 추가
						김지만 수사관 요청
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/searchVidoTrplantDetailAjax/")
	public @ResponseBody ModelAndView searchVidoTrplantDetailAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HashMap detail = rcdMgtService.selectVidoTrplantDetail(map);
		detail = commonUtil.getConvertUnderscoreName(detail);
		HashMap cMap = new HashMap();
		cMap.put("detail", detail);
		//cMap.put("docList", docList);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
}
