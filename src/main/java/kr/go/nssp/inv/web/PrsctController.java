package kr.go.nssp.inv.web;
import java.lang.ProcessBuilder.Redirect;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.cmmn.service.ExmnService;
import kr.go.nssp.inv.service.PrsctService;
import kr.go.nssp.rc.service.RcService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;

@Controller
@RequestMapping(value = "/inv/")
public class PrsctController {

	@Resource
	private PrsctService prsctService;

	@Resource
	private CdService cdService;

	@Resource
	private ExmnService exmnService;

	@Resource
	private RcService rcService;

	/**
	 * 입건 사건 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/prsctListAjax/")
	@ResponseBody
	public List<HashMap> prsctList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = prsctService.selectPrsctList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

	/**
	 * 입건 사건 상세보기
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/prsctDtlPopup/")
	public String prsctDtl (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00102");
    	model.addAttribute("trgterSeList", cdService.getCdList(cMap));		//대상자 구분 공통코드
    	cMap.put("upper_cd", "00011");
    	model.addAttribute("progrsSttusList", cdService.getCdList(cMap));	//진행상태 공통코드
    	//수사단서 공통코드
    	//접수형태 공통코드
    	cMap.put("start_cd", "00000");
    	model.addAttribute("exmnList", commonUtil.getConvertUnderscoreNameList(exmnService.getExmnFullList(cMap))); //검찰관할코드
		Map map = new HashMap();
		map.put("case_no", request.getParameter("hidCaseNo"));
		map.put("rc_no", request.getParameter("hidRcNo"));
    	List<HashMap> list = prsctService.selectPrsctList(map);
    	HashMap mapDtl = list.size()>0?list.get(0):new HashMap();
    	model.addAttribute("dtl", commonUtil.getConvertUnderscoreName(mapDtl));
		return "inv/pop/prsctDtlPopup";
	}

	/**
	 * 사건인지/입건
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/prsct/")
	public String prsct (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00102");
    	model.addAttribute("trgterSeList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00011");
    	model.addAttribute("progrsSttusList", cdService.getCdList(cMap));
    	cMap.put("upper_cd", "00400");
    	model.addAttribute("invProvisList", cdService.getCdList(cMap));
    	cMap.put("start_cd", "00000");
    	model.addAttribute("exmnList", commonUtil.getConvertUnderscoreNameList(exmnService.getExmnFullList(cMap))); //검찰관할코드
    	model.addAttribute("hidRcNoJson", request.getParameter("hidRcNoJson")); 		//입건조사 화면에서 이동되는 파라미터
    	String strRcNo = SimpleUtils.default_set(request.getParameter("hidRcNo")); 	//내사 화면에서 이동되는 파라미터
    	model.addAttribute("hidRcNo", strRcNo);
    	model.addAttribute("pageNo", "2");
    	if(strRcNo.indexOf("-")>-1) {
    		String arrstrRcNo[] = strRcNo.split("-");
    		model.addAttribute("hidRcNo1", arrstrRcNo[0]);
    		model.addAttribute("hidRcNo2", arrstrRcNo[1]);
    	}
		return "inv/prsct";
	}

	/**
	 * 접수 및 입건 사건 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/rcPrsctListAjax/")
	@ResponseBody
	public List<HashMap> rcPrsctListAjax (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		Object hidRcNoJson = map.get("rc_no_json");
		if(hidRcNoJson != null) {
			JSONParser jsonParser = new JSONParser();
            JSONObject jsonObj = (JSONObject) jsonParser.parse(hidRcNoJson.toString());
            map.put("rc_no_json", jsonObj.get("hidRcNoJson"));
		}
    	List<HashMap> list = prsctService.selectRcPrsctList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

	/**
	 * 관리대상자 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/rcTmprTrgterListAjax/")
	@ResponseBody
	public List<HashMap> rcTmprTrgterList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = prsctService.selectRcTmprTrgterList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

	/**
	 * 입건대상자 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/prsctAditTrgterListAjax/")
	@ResponseBody
	public List<HashMap> prsctTrgterList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = prsctService.selectPrsctAditTrgterList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

	/**
	 * 사건인지/입건 저장
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping (value = "/savePrsctAjax/")
	public ModelAndView savePrsct (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);

        String result = "1";
		try{
			//사건 진행상태 valid
			HashMap rMap = rcService.getCaseInfo((HashMap<String, Object>) map);
			if(rMap == null){
				result = "-2";
			}else{
				String progrs_sttus_cd = (String) rMap.get("PROGRS_STTUS_CD");

				//정식사건승인요청 가능한 진행상태  00201:임시사건 접수 /00216:내사결과 입건/ 00220:정식사건 작성완료/ 00224:정식사건 반려
				if ( "00201".equals(progrs_sttus_cd) || "00216".equals(progrs_sttus_cd)
				   ||"00220".equals(progrs_sttus_cd) || "00224".equals(progrs_sttus_cd)){

					HttpSession session = request.getSession();
			    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
			    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
			    	map.put("esntl_id", esntl_id);
			    	map.put("dept_cd", dept_cd);
					prsctService.savePrsct (map);
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

	/**
	 * 사건인지/입건 승인 완료
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping (value = "/savePrsctCmplAjax/", method=RequestMethod.POST)
	@ResponseBody
	public String savePrsctCmpl (HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception {
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	param.put("esntl_id", esntl_id);
    	param.put("dept_cd", dept_cd);
		String rtnVal = prsctService.savePrsctCmpl (param);
		return rtnVal;
	}

	/**
	 * 사건인지/입건 사건 목록 → 입건 대상자 삭제가능 여부 확인
	 * @return int
	 * @exception Exception
	 */
	@RequestMapping (value = "/prsctProgrsChk/", method=RequestMethod.POST)
	@ResponseBody
	public String prsctProgrsChk (HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getMapToMapConvert(param);
		String returnVal = prsctService.prsctProgrsChk (param);
		return returnVal;
	}

	/**
	 * 사건인지/입건 요청 취소
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping (value = "/cancelPrsct/")
	public ModelAndView cancelPrsct (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	map.put("esntl_id", esntl_id);
		Map returnMap = prsctService.cancelPrsct (map);
		return new ModelAndView("ajaxView", "ajaxData", returnMap);
	}

	/**
	 * 입건 승인 처리 팝업
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/prsctPopup/")
	public String prsctPopup (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00102");
    	model.addAttribute("trgterSeList", cdService.getCdList(cMap));		//대상자 구분 공통코드
    	cMap.put("upper_cd", "00011");
    	model.addAttribute("progrsSttusList", cdService.getCdList(cMap));	//진행상태 공통코드
    	//수사단서 공통코드
    	//접수형태 공통코드
    	cMap.put("start_cd", "00000");
    	model.addAttribute("exmnList", commonUtil.getConvertUnderscoreNameList(exmnService.getExmnFullList(cMap))); //검찰관할코드
		Map map = new HashMap();
		String strCaseNo = Utility.nvl((request.getParameter("hidCaseNo")));
		String strRcNo = Utility.nvl((request.getParameter("hidRcNo")));
		if(strCaseNo != null && !strCaseNo.trim().equals("") && !strCaseNo.trim().equals("undefined")) {
			map.put("case_no", strCaseNo);
		}
		if (strRcNo != null && !strRcNo.trim().equals("")&& !strRcNo.trim().equals("undefined")) {
			map.put("rc_no", strRcNo);
		}
	    Map mapDtl = prsctService.selectAdltPrsctList(map);			/*사건 기본 정보*/
	    model.addAttribute("dtl", commonUtil.getConvertUnderscoreName(mapDtl));

		return "inv/pop/prsctPopup";
	}

	/**
	 * 사건인지보고서
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/caseRptPopup/")
	public String caseRptPopup (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
		
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		HashMap map = commonUtil.getParameterMapConvert(request);
		map.put("esntl_id", esntl_id);
		
		Map returnMap = prsctService.selectCaseRpt (map);
		
		String addParam = "";
		if("R".equals(map.get("doc_type"))) {
			addParam = "&doc_type=R";
		} else {
			addParam = "";
		}
		
		String strp = "?docId="+returnMap.get("docId")+"&pblicteSn="+returnMap.get("pblicteSn");
		String rtnStr = "redirect:/doc/hwpctrlPopup/"+strp+addParam; /*한글*/
		
		/*
		String rtnStr = "redirect:/doc/reportViewPopup/"+strp;
		if(map.get("fm_type") != null && map.get("fm_type").toString().equals("8")) {
			rtnStr = "redirect:/doc/reportInputPopup/"+strp;
		}
		*/
		return rtnStr;
	}
}
