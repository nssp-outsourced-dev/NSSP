package kr.go.nssp.trn.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.sanctn.service.SanctnService;
import kr.go.nssp.trn.service.TrnCcdrcService;
import kr.go.nssp.trn.service.TrnRcordService;
import kr.go.nssp.trn.service.TrnService;
import kr.go.nssp.utl.Utility;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

/**
 * @description : 송치관리
 * @author      : khlee
 * @version     : 1.0
 * @created     : 2019-04-17
 * @modified    :
 */
@Controller
@RequestMapping(value = "/trn/")
public class TrnController {

	@Autowired
	private TrnService trnService;

	@Autowired
	private TrnRcordService trnRcordService;

	@Autowired
	private TrnCcdrcService trnCcdrcService;

	@Autowired
	private SanctnService sanctnService;

	@Autowired
	private CdService cdService;

	@RequestMapping(value="/caseListAjax/")
	@ResponseBody
	public List caseListAjax(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String dept_cd = Utility.nvl(session.getAttribute("dept_cd"));

		/*
		List<String> arr = new ArrayList<String>();
		arr.add("00223"); //입건
		arr.add("00230"); //지휘건의
		arr.add("00240"); //송치준비중
		arr.add("00241"); //송치승인요청
		arr.add("00243"); //송치반려
		*/

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("CHARGER_ID", esntl_id);
		param.put("CHARGER_DEPT_CD", dept_cd);
		//param.put("arr", arr);

		List list = trnService.selectCaseListForTrn(param);
		return list;
	}

	/**
	 * 사건상세보기 송치 탭
	 * @param param
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/trnInfoPopup/")
	public String trnInfoPopup(@RequestParam Map<String, String> param, ModelMap model) throws Exception {
		/*param.put("RC_NO", Utility.nvl(param.get("hidRcNo")));
		List trnInfo = trnService.selectTrnCaseList(param);

		model.put("trnInfo", trnInfo);*/

		model.put("rcNo", Utility.nvl(param.get("rcNo")));

		return "trn/trnInfoPopup";
	}

	@RequestMapping(value="/trnCaseListPopAjax/")
	@ResponseBody
	public List trnCaseListPopAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		param.put("RC_NO", Utility.nvl(request.getParameter("hidRcNo")));
		List list = trnService.selectTrnCaseList(param);
		return list;
	}

	@RequestMapping(value="/trnSuspctListPopAjax/")
	@ResponseBody
	public List trnSuspctListPopAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		List list = trnService.selectTrnSuspctListOnly(param);
		return list;
	}

	@RequestMapping(value="/trnVioltListPopAjax/")
	@ResponseBody
	public List trnVioltListPopAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		List list = trnService.selectTrnVioltListOnly(param);
		return list;
	}

	@RequestMapping (value = "/trnList/")
	public String trnList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		return "trn/trnList";
	}

	@RequestMapping(value="/trnCaseListAjax/")
	@ResponseBody
	public List trnCaseListAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));

		param.put("TRN_NO", Utility.nvl(request.getParameter("schTrnNo")));
		param.put("CASE_NO", Utility.nvl(request.getParameter("schCaseNo")));
		param.put("RC_NO", Utility.nvl(request.getParameter("schRcNo")));
		param.put("CHARGER_ID", esntl_id);

		List list = trnService.selectTrnCaseList(param);
		return list;
	}

	/**
	 * 송치관리 화면 호출
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/trnManage/")
	public String trnManage(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String dept_cd = Utility.nvl(session.getAttribute("dept_cd"));

		HashMap param = new HashMap();
		// 신병상태
		param.put("upper_cd", "01090");
		model.addAttribute("code1", Utility.getJsonArrayFromList2(cdService.getCdList(param)));

		// 송치의견
		param.put("upper_cd", "01094");
		model.addAttribute("code2", Utility.getJsonArrayFromList2(cdService.getCdList(param)));

		//String caseNo = Utility.nvl(request.getParameter("hidCaseNo"));
		String rcNo = Utility.nvl(request.getParameter("hidRcNo"));
		String reTrnYn = Utility.nvl(request.getParameter("reTrnYn"));

		// 내사건목록에서 바로가기
		if(!rcNo.equals("")) {
			//param.put("CASE_NO", caseNo);
			param.put("RC_NO", rcNo);
			param.put("CHARGER_ID", esntl_id);
			param.put("WRITNG_ID", esntl_id);
			param.put("WRITNG_DEPT_CD", dept_cd);
			param.put("UPDT_ID", esntl_id);

			HashMap trnInfo = trnService.selectTrnCaseInfo(param);

			//model.addAttribute("hidCaseNo", caseNo);
			model.addAttribute("hidRcNo", rcNo);
			model.addAttribute("info", trnInfo);
		}

		return "trn/trnManage";
	}

	/**
	 * 송치사건 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trnCaseInfoAjax/")
	@ResponseBody
	public HashMap trnInfoAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String dept_cd = Utility.nvl(session.getAttribute("dept_cd"));

		param.put("TRN_NO", Utility.nvl(request.getParameter("schTrnNo")));
		param.put("CASE_NO", Utility.nvl(request.getParameter("schCaseNo")));
		param.put("RC_NO", Utility.nvl(request.getParameter("schRcNo")));
		param.put("SCH_PROGRS_STTUS_CD", Utility.nvl(request.getParameter("schProgrsSttusCd")));
		param.put("CHARGER_ID", esntl_id);

		String str = "";
		if(Utility.nvl(request.getParameter("schTrnNo")).equals("")) {
			Map<String, Object> paramT = new HashMap<String, Object>();
			paramT.put("CASE_NO"  , Utility.nvl(request.getParameter("schCaseNo")));
			paramT.put("RC_NO"    , Utility.nvl(request.getParameter("schRcNo")));
			paramT.put("WRITNG_ID", esntl_id);
			paramT.put("UPDT_ID"  , esntl_id);
			paramT.put("DEPT_CD"  , dept_cd);

			paramT = trnService.insertTrnCase(paramT);
			str = paramT.get("TRN_NO").toString();
			param.put("TRN_NO", str);
		}

		HashMap map = trnService.selectTrnCaseInfo(param);
		if(map == null) {
			map = new HashMap();
			map.put("result", "0");
		} else {
			map.put("result", "1");
			map.put("newTrnNo", str);
		}

		return map;
	}

	/**
	 * 송치피의자 목록 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trnSuspctListAjax/")
	@ResponseBody
	public List trnSuspctListAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		param.put("TRN_NO", Utility.nvl(param.get("schTrnNo")));
		param.put("CASE_NO", Utility.nvl(param.get("schCaseNo")));
		param.put("RC_NO", Utility.nvl(param.get("schRcNo")));

		List list = trnService.selectTrnSuspctList(param);
		return list;
	}

	/**
	 * 송치피의자별 위반사항 목록 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trnVioltListAjax/")
	@ResponseBody
	public List trnVioltListAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		param.put("TRN_NO", Utility.nvl(param.get("schTrnNo")));
		param.put("CASE_NO", Utility.nvl(param.get("schCaseNo")));
		param.put("RC_NO", Utility.nvl(param.get("schRcNo")));
		param.put("TRGTER_SN", Utility.nvl(param.get("schTrgterSn")));

		List list = trnService.selectTrnVioltList(param);
		return list;
	}

	/**
	 * 통계원표 목록
	 * @param request
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trnZeroNoListAjax/")
	@ResponseBody
	public List trnZeroNoListAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		param.put("TRN_NO", Utility.nvl(param.get("schTrnNo"), param.get("hidTrnNo")));

		List list = trnService.selectTrnZeroNoList(param);
		return list;
	}

	/**
	 * 재송치
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addReTrnAjax/")
	public ModelAndView addReTrnAjax(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String dept_cd = Utility.nvl(session.getAttribute("dept_cd"));
		String result = "1";

		Map<String, Object> map = new HashMap<String, Object>();

		try {

			String caseNo = Utility.nvl(request.getParameter("hidCaseNo"));

			System.out.println("###[addReTrnAjax-재송치]caseNo:"+caseNo);
			Map<String, Object> param = new HashMap<String, Object>();

			// 2019-07-30 전체사건조회에서 관리자가 처리함.
			param.put("CASE_NO", caseNo);
			param.put("CHARGER_ID", esntl_id);
			param.put("WRITNG_ID", esntl_id);
			param.put("WRITNG_DEPT_CD", dept_cd);
			param.put("UPDT_ID", esntl_id);

			map = trnService.insertReTrnCase(param);
			System.out.println("###[addReTrnAjax-재송치]map:"+map);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("result", result);
		ret.put("info", map);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


	/**
	 * 송치 등록
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addTrnAjax/")
	public ModelAndView addTrnAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();

		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String dept_cd = Utility.nvl(session.getAttribute("dept_cd"));
		String result = "1";

		System.out.println("###[addTrnAjax-송치저장]reqParam:"+reqParam);
		Map<String, Object> param = new HashMap<String, Object>();

		try {
			param.put("CASE_NO"       , Utility.nvl(reqParam.get("hidCaseNo")));
			param.put("RC_NO"         , Utility.nvl(reqParam.get("hidRcNo")));
			param.put("TRN_DE"        , Utility.nvl(reqParam.get("calTrnDe")));
			param.put("EVDENC_DC"     , Utility.nvl(reqParam.get("txtEvdencDc")));
			param.put("CMPTNC_EXMN_CD", Utility.nvl(reqParam.get("hidCmptncExmnCd")));
			param.put("TRN_RM"        , Utility.nvl(reqParam.get("txtTrnRm")));
			param.put("WRITNG_ID", esntl_id);
			param.put("UPDT_ID"  , esntl_id);
			param.put("DEPT_CD"  , dept_cd);

			param = trnService.insertTrnCase(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);
		ret.put("trnNo", Utility.nvl(param.get("TRN_NO")));
		ret.put("docId", Utility.nvl(param.get("DOC_ID")));
		ret.put("fileId", Utility.nvl(param.get("FILE_ID")));

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 송치 수정
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modTrnAjax/")
	public ModelAndView modTrnAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[modTrnAjax]reqParam:"+reqParam);

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("TRN_NO"       , Utility.nvl(reqParam.get("hidTrnNo")));
			param.put("CASE_NO"       , Utility.nvl(reqParam.get("hidCaseNo")));
			param.put("RC_NO"         , Utility.nvl(reqParam.get("hidRcNo")));
			param.put("TRN_DE"        , Utility.nvl(reqParam.get("calTrnDe")));
			param.put("EVDENC_DC"     , Utility.nvl(reqParam.get("txtEvdencDc")));
			param.put("CMPTNC_EXMN_CD", Utility.nvl(reqParam.get("hidCmptncExmnCd")));
			param.put("TRN_RM"        , Utility.nvl(reqParam.get("txtTrnRm")));
			param.put("UPDT_ID"  , esntl_id);

			trnService.updateTrnCase(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 송치 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delTrnAjax/")
	public ModelAndView delTrnAjax(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("TRN_NO", Utility.nvl(request.getParameter("hidTrnNo")));
			param.put("UPDT_ID" , esntl_id);
			System.out.println("###[delTrnAjax]param:"+param);

			int cnt = trnService.deleteTrnCase(param);

			if(cnt < 1) {
				result = "-1";
			}

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 송치 승인요청
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/askTrnAjax/")
	public ModelAndView askTrnAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String dept_cd = Utility.nvl(session.getAttribute("dept_cd"));
		String result = "1";

		System.out.println("###[askTrnAjax]reqParam:"+reqParam);

		try {
			// 승인요청 공통, 결재ID
			HashMap param2 = new HashMap();
			param2.put("regist_path", "송치 승인요청");
			param2.put("esntl_id", esntl_id);
			param2.put("dept_cd", dept_cd);
			String sanctn_id = sanctnService.insertSanctn(param2);

			Map<String, Object> param = new HashMap<String, Object>();
			param.put("TRN_NO" , Utility.nvl(reqParam.get("hidTrnNo")));
			param.put("CASE_NO", Utility.nvl(reqParam.get("hidCaseNo")));
			param.put("RC_NO", Utility.nvl(reqParam.get("hidRcNo")));
			param.put("SANCTN_ID", sanctn_id);
			param.put("UPDT_ID", esntl_id);

			trnService.requstTrnCase(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 송치완료(송치종결)
	 * @param request
	 * @param reqParam
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/completeTrnAjax/")
	public ModelAndView completeTrnAjax(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String dept_cd = Utility.nvl(session.getAttribute("dept_cd"));
		String result = "1";

		System.out.println("###[completTrnAjax]param:"+param);

		try {
			param.put("TRN_NO" , Utility.nvl(param.get("hidTrnNo")));
			param.put("RC_NO", Utility.nvl(param.get("hidRcNo")));
			param.put("UPDT_ID", esntl_id);

			param = trnService.completTrnCase(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		if(Utility.nvl(param.get("RE_MSG")).equals("")) {
			ret.put("result", result);
		} else {
			ret.put("result", "-1");
			ret.put("message", Utility.nvl(param.get("RE_MSG")));
		}

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


	/**
	 * 송치취소(송치를 송치준비중으로 처리)
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cancelTrnAjax/")
	public ModelAndView cancelTrnAjax(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("TRN_NO", Utility.nvl(request.getParameter("hidTrnNo")));
			param.put("RC_NO", Utility.nvl(request.getParameter("hidRcNo")));
			param.put("UPDT_ID" , esntl_id);
			System.out.println("###[cancelTrnAjax]param:"+param);

			int cnt = trnService.cancelTrnAjax(param);

			if(cnt < 1) {
				result = "-1";
			}

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping("/saveTrnSuspctAjax/")
	public ModelAndView saveTrnSuspctAjax(HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[saveTrnSuspctAjax-송치피의자저장]param:"+param);

		param.put("WRITNG_ID", esntl_id);
		param.put("UPDT_ID"  , esntl_id);

		try {
			trnService.saveTrnSuspct(param);
		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping("/saveTrnVioltAjax/")
	public ModelAndView saveTrnVioltAjax(HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[saveTrnVioltAjax-위반사항저장]param:"+param);

		param.put("WRITNG_ID", esntl_id);
		param.put("UPDT_ID"  , esntl_id);

		try {
			trnService.saveTrnViolt(param);
		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 기록목록관리 화면 호출
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/trnRcordManage/")
	public String trnRcordManage(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		/*HashMap param = new HashMap();
		// 신병상태
		param.put("upper_cd", "01090");
		model.addAttribute("code1", Utility.getJsonArrayFromList2(cdService.getCdList(param)));

		// 송치의견
		param.put("upper_cd", "01094");
		model.addAttribute("code2", Utility.getJsonArrayFromList2(cdService.getCdList(param)));*/

		return "trn/trnRcordManage";
	}

	/**
	 * 송치기록목록 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trnRcordListAjax/")
	@ResponseBody
	public List trnRcordListAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		param.put("CASE_NO", Utility.nvl(param.get("schCaseNo"), param.get("hidCaseNo")));
		param.put("RC_NO", Utility.nvl(param.get("schRcNo"), param.get("hidRcNo")));

		System.out.println("###[trnRcordListAjax-기록목록]param:"+param);
		List list = trnRcordService.selectTrnRcordList(param);
		return list;
	}


	/**
	 * 송치기록목록 가져오기
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/bringTrnRcordAjax/")
	public ModelAndView bringTrnRcordAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[bringTrnRcordAjax-송치기록목록가져오기]reqParam:"+reqParam);

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("RC_NO" , Utility.nvl(reqParam.get("hidRcordRcNo")));
			//param.put("RCORD_NM", Utility.nvl(reqParam.get("txtRcordNm")));
			//param.put("RCORD_STATER", Utility.nvl(reqParam.get("txtRcordStater")));
			//param.put("RCORD_CO", Utility.nvl(reqParam.get("txtRcordCo")));
			//param.put("RCORD_DE", Utility.nvl(reqParam.get("calRcordDe")));
			//param.put("SORT_ORDR", Utility.nvl(reqParam.get("txtRcordSort")));
			param.put("WRITNG_ID", esntl_id);
			param.put("UPDT_ID"  , esntl_id);

			trnRcordService.bringTrnRcord(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 기록목록저장 저장
	 * @param request
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveTrnRcordAjax/")
	public ModelAndView saveTrnRcordAjax(HttpServletRequest request, @RequestBody Map param) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[saveTrnRcordAjax-기록목록저장] param:"+param);

		param.put("WRITNG_ID", esntl_id);

		try {
			trnRcordService.saveTrnRcord(param);
		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 송치기록목록 추가
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addTrnRcordAjax/")
	public ModelAndView addTrnRcordAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[addTrnRcordAjax-송치기록목록저장]reqParam:"+reqParam);

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("RC_NO" , Utility.nvl(reqParam.get("hidRcordRcNo")));
			param.put("RCORD_NM", Utility.nvl(reqParam.get("txtRcordNm")));
			param.put("RCORD_STATER", Utility.nvl(reqParam.get("txtRcordStater")));
			param.put("RCORD_CO", Utility.nvl(reqParam.get("txtRcordCo")));
			param.put("RCORD_DE", Utility.nvl(reqParam.get("calRcordDe")));
			//param.put("SORT_ORDR", Utility.nvl(reqParam.get("txtRcordSort")));
			param.put("WRITNG_ID", esntl_id);
			param.put("UPDT_ID"  , esntl_id);

			trnRcordService.insertTrnRcord(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 송치기록목록 수정
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modTrnRcordAjax/")
	public ModelAndView modTrnRcordAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[addTrnRcordAjax-송치기록목록저장]reqParam:"+reqParam);

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("RC_NO" , Utility.nvl(reqParam.get("hidRcordRcNo")));
			param.put("RCORD_SN", Utility.nvl(reqParam.get("hidRcordSn")));
			param.put("RCORD_NM", Utility.nvl(reqParam.get("txtRcordNm")));
			param.put("RCORD_STATER", Utility.nvl(reqParam.get("txtRcordStater")));
			param.put("RCORD_CO", Utility.nvl(reqParam.get("txtRcordCo")));
			param.put("RCORD_DE", Utility.nvl(reqParam.get("calRcordDe")));
			//param.put("SORT_ORDR", Utility.nvl(reqParam.get("txtRcordSort")));
			param.put("UPDT_ID"  , esntl_id);

			trnRcordService.updateTrnRcord(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 송치기록목록 삭제
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delTrnRcordAjax/")
	public ModelAndView delTrnRcordAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[delTrnRcordAjax-송치기록목록삭제]reqParam-1:"+reqParam);

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("RC_NO" , Utility.nvl(reqParam.get("hidRcordRcNo")));
			param.put("RCORD_SN", Utility.nvl(reqParam.get("hidRcordSn")));
			param.put("UPDT_ID"  , esntl_id);
			System.out.println("###[delTrnRcordAjax-송치기록목록삭제]param-2:"+param);

			trnRcordService.deleteTrnRcord(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 압수물총목록관리 화면 호출
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/trnCcdrcManage/")
	public String trnCcdrcManage(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		/*HashMap param = new HashMap();
		// 신병상태
		param.put("upper_cd", "01090");
		model.addAttribute("code1", Utility.getJsonArrayFromList2(cdService.getCdList(param)));

		// 송치의견
		param.put("upper_cd", "01094");
		model.addAttribute("code2", Utility.getJsonArrayFromList2(cdService.getCdList(param)));*/

		return "trn/trnCcdrcManage";
	}

	/**
	 * 송치압수물총목록 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trnCcdrcListAjax/")
	@ResponseBody
	public List trnCcdrcListAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		param.put("TRN_NO", Utility.nvl(param.get("schTrnNo"), param.get("hidTrnNo")));
		param.put("RC_NO", Utility.nvl(param.get("schRcNo"), param.get("hidRcNo")));
		System.out.println("###[trnCcdrcListAjax-압수물총목록]param:"+param);

		List list = trnCcdrcService.selectTrnCcdrcList(param);
		return list;
	}

	/**
	 * 압수물총목록 저장
	 * @param request
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveTrnCcdrcAjax/")
	public ModelAndView saveTrnCcdrcAjax(HttpServletRequest request, @RequestBody Map param) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[saveTrnCcdrcAjax-압수물총목록저장] param:"+param);

		param.put("WRITNG_ID", esntl_id);

		try {
			trnCcdrcService.saveTrnCcdrc(param);
		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 송치압수물총목록 추가
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addTrnCcdrcAjax/")
	public ModelAndView addTrnCcdrcAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[addTrnCcdrcAjax-송치압수물총목록저장]reqParam:"+reqParam);

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("TRN_NO"      , Utility.nvl(reqParam.get("hidCcdrcTrnNo")));
			param.put("TRN_CCDRC_NM", Utility.nvl(reqParam.get("txtCcdrcNm")));
			param.put("TRN_CCDRC_QY", Utility.nvl(reqParam.get("txtCcdrcQy")));
			param.put("TRN_CCDRC_CO", Utility.nvl(reqParam.get("txtCcdrcCo")));
			param.put("TRN_CCDRC_RM", Utility.nvl(reqParam.get("txtRm")));
			param.put("SORT_ORDR"   , Utility.nvl(reqParam.get("txtCcdrcSort")));
			param.put("WRITNG_ID", esntl_id);
			param.put("UPDT_ID"  , esntl_id);

			trnCcdrcService.insertTrnCcdrc(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 송치압수물총목록 수정
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modTrnCcdrcAjax/")
	public ModelAndView modTrnCcdrcAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[addTrnCcdrcAjax-송치압수물총목록저장]reqParam:"+reqParam);

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("TRN_NO"      , Utility.nvl(reqParam.get("hidCcdrcTrnNo")));
			param.put("TRN_CCDRC_SN", Utility.nvl(reqParam.get("hidCcdrcSn")));
			param.put("TRN_CCDRC_NM", Utility.nvl(reqParam.get("txtCcdrcNm")));
			param.put("TRN_CCDRC_QY", Utility.nvl(reqParam.get("txtCcdrcQy")));
			param.put("TRN_CCDRC_CO", Utility.nvl(reqParam.get("txtCcdrcCo")));
			param.put("TRN_CCDRC_RM", Utility.nvl(reqParam.get("txtRm")));
			param.put("SORT_ORDR"   , Utility.nvl(reqParam.get("txtCcdrcSort")));
			param.put("UPDT_ID"  , esntl_id);

			trnCcdrcService.updateTrnCcdrc(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 송치압수물총목록 삭제
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delTrnCcdrcAjax/")
	public ModelAndView delTrnCcdrcAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[addTrnCcdrcAjax-송치압수물총목록저장]reqParam:"+reqParam);

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("TRN_NO"      , Utility.nvl(reqParam.get("hidCcdrcTrnNo")));
			param.put("TRN_CCDRC_SN", Utility.nvl(reqParam.get("hidCcdrcSn")));
			param.put("UPDT_ID"  , esntl_id);

			trnCcdrcService.deleteTrnCcdrc(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping (value = "/trnCaseStatList/")
	public String trnCaseStatList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String dept_single_nm = SimpleUtils.default_set(session.getAttribute("dept_single_nm").toString());
		String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());
		model.addAttribute("esntl_id", esntl_id);
		model.addAttribute("dept_cd", dept_cd);
		model.addAttribute("dept_single_nm", dept_single_nm);
		model.addAttribute("mngr_yn", mngr_yn);

		int pageBlock = 50;
		model.addAttribute("hidPageBlock", pageBlock);

		//대상자구분
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00102");
		List<HashMap> trgterClList = cdService.getCdList(cMap);
		model.addAttribute("trgterClList", trgterClList);

		return "trn/trnCaseStatList";
	}

	@RequestMapping(value = "/trnCaseStatListAjax/")
	public ModelAndView trnCaseStatListAjax(HttpServletRequest request) throws Exception  {

		String searchTrnNo1 = SimpleUtils.default_set(request.getParameter("searchTrnNo1"));
		String searchTrnNo2 = SimpleUtils.default_set(request.getParameter("searchTrnNo2"));
		String searchTrnNo3 = SimpleUtils.default_set(request.getParameter("searchTrnNo3"));
		String searchTrgterCl = SimpleUtils.default_set(request.getParameter("searchTrgterCl"));
		String searchTrgterNm = SimpleUtils.default_set(request.getParameter("searchTrgterNm"));
		String searchTrnDe1 = SimpleUtils.default_set(request.getParameter("searchTrnDe1"));
		String searchTrnDe2 = SimpleUtils.default_set(request.getParameter("searchTrnDe2"));

		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));
		String searchChager = SimpleUtils.default_set(request.getParameter("searchChager"));
		
		String sortingFields = SimpleUtils.default_set(request.getParameter("sortingFields"));

		HashMap map = new HashMap();

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));
		if( hidPageBlock== null || hidPageBlock.equals("")){
			//전체조회
			hidPageBlock = "10";
			map.put("startRow", "");
			map.put("endRow", "");
		}else{
			//페이징조회
			int pageBlock = Integer.parseInt((String)hidPageBlock);
			//페이지 기본설정
			int pageArea = 10;
			//page
			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(intPage);
			paginationInfo.setRecordCountPerPage(pageBlock);
			paginationInfo.setPageSize(pageArea);
			map.put("startRow", paginationInfo.getFirstRecordIndex());
			map.put("endRow", paginationInfo.getLastRecordIndex());
		}

		map.put("searchTrgterCl", searchTrgterCl);
		map.put("searchTrgterNm", searchTrgterNm);
		map.put("searchTrnDeStart", searchTrnDe1);
		map.put("searchTrnDeEnd", searchTrnDe2);
		map.put("searchDeptCd", searchDeptCd);
		map.put("searchChager", searchChager);

		if(searchTrnNo1.length() == 4){
			if(!searchTrnNo2.isEmpty() && searchTrnNo2 != null){
				map.put("searchTrnNoStart", searchTrnNo1 + "-" + String.format("%06d", Integer.parseInt(searchTrnNo2)));
			}
			if(!searchTrnNo3.isEmpty() && searchTrnNo3 != null){
				map.put("searchTrnNoEnd", searchTrnNo1 + "-" + String.format("%06d", Integer.parseInt(searchTrnNo3)));
			}
		}
		
		//sorting
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}

		int list_cnt = 0;
		List<HashMap> list = trnService.selectTrnCaseStatList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	@RequestMapping (value = "/occZeroStatList/")
	public String occZeroStatList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String dept_single_nm = SimpleUtils.default_set(session.getAttribute("dept_single_nm").toString());
		String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());
		model.addAttribute("esntl_id", esntl_id);
		model.addAttribute("dept_cd", dept_cd);
		model.addAttribute("dept_single_nm", dept_single_nm);
		model.addAttribute("mngr_yn", mngr_yn);

		int pageBlock = 50;
		model.addAttribute("hidPageBlock", pageBlock);

		//대상자구분
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00102");
		List<HashMap> trgterClList = cdService.getCdList(cMap);
		model.addAttribute("trgterClList", trgterClList);

		return "trn/occZeroStatList";
	}

	@RequestMapping(value = "/occZeroStatListAjax/")
	public ModelAndView occZeroStatListAjax(HttpServletRequest request) throws Exception  {

		String searchNo1 = SimpleUtils.default_set(request.getParameter("searchNo1"));
		String searchNo2 = SimpleUtils.default_set(request.getParameter("searchNo2"));
		String searchNo3 = SimpleUtils.default_set(request.getParameter("searchNo3"));
		String searchTrgterCl = SimpleUtils.default_set(request.getParameter("searchTrgterCl"));
		String searchTrgterNm = SimpleUtils.default_set(request.getParameter("searchTrgterNm"));
		String searchDe1 = SimpleUtils.default_set(request.getParameter("searchDe1"));
		String searchDe2 = SimpleUtils.default_set(request.getParameter("searchDe2"));

		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));
		String searchChager = SimpleUtils.default_set(request.getParameter("searchChager"));
		
		String sortingFields = SimpleUtils.default_set(request.getParameter("sortingFields"));

		HashMap map = new HashMap();

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));
		if( hidPageBlock== null || hidPageBlock.equals("")){
			//전체조회
			hidPageBlock = "10";
			map.put("startRow", "");
			map.put("endRow", "");
		}else{
			//페이징조회
			int pageBlock = Integer.parseInt((String)hidPageBlock);
			//페이지 기본설정
			int pageArea = 10;
			//page
			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(intPage);
			paginationInfo.setRecordCountPerPage(pageBlock);
			paginationInfo.setPageSize(pageArea);
			map.put("startRow", paginationInfo.getFirstRecordIndex());
			map.put("endRow", paginationInfo.getLastRecordIndex());
		}

		map.put("searchTrgterCl", searchTrgterCl);
		map.put("searchTrgterNm", searchTrgterNm);
		map.put("searchDeStart", searchDe1);
		map.put("searchDeEnd", searchDe2);
		map.put("searchDeptCd", searchDeptCd);
		map.put("searchChager", searchChager);

		if(searchNo1.length() == 4){
			if(!searchNo2.isEmpty() && searchNo2 != null){
				map.put("searchNoStart", searchNo1 + "-" + String.format("%06d", Integer.parseInt(searchNo2)));
			}
			if(!searchNo3.isEmpty() && searchNo3 != null){
				map.put("searchNoEnd", searchNo1 + "-" + String.format("%06d", Integer.parseInt(searchNo3)));
			}
		}
		
		//sorting
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}

		int list_cnt = 0;
		List<HashMap> list = trnService.selectOccZeroStatList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	@RequestMapping (value = "/arrZeroStatList/")
	public String arrZeroStatList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String dept_single_nm = SimpleUtils.default_set(session.getAttribute("dept_single_nm").toString());
		String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());
		model.addAttribute("esntl_id", esntl_id);
		model.addAttribute("dept_cd", dept_cd);
		model.addAttribute("dept_single_nm", dept_single_nm);
		model.addAttribute("mngr_yn", mngr_yn);

		int pageBlock = 50;
		model.addAttribute("hidPageBlock", pageBlock);

		//대상자구분
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00102");
		List<HashMap> trgterClList = cdService.getCdList(cMap);
		model.addAttribute("trgterClList", trgterClList);

		return "trn/arrZeroStatList";
	}

	@RequestMapping(value = "/arrZeroStatListAjax/")
	public ModelAndView arrZeroStatListAjax(HttpServletRequest request) throws Exception  {

		String searchNo1 = SimpleUtils.default_set(request.getParameter("searchNo1"));
		String searchNo2 = SimpleUtils.default_set(request.getParameter("searchNo2"));
		String searchNo3 = SimpleUtils.default_set(request.getParameter("searchNo3"));
		String searchTrgterCl = SimpleUtils.default_set(request.getParameter("searchTrgterCl"));
		String searchTrgterNm = SimpleUtils.default_set(request.getParameter("searchTrgterNm"));
		String searchDe1 = SimpleUtils.default_set(request.getParameter("searchDe1"));
		String searchDe2 = SimpleUtils.default_set(request.getParameter("searchDe2"));

		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));
		String searchChager = SimpleUtils.default_set(request.getParameter("searchChager"));
		
		String sortingFields = SimpleUtils.default_set(request.getParameter("sortingFields"));

		HashMap map = new HashMap();

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));
		if( hidPageBlock== null || hidPageBlock.equals("")){
			//전체조회
			hidPageBlock = "10";
			map.put("startRow", "");
			map.put("endRow", "");
		}else{
			//페이징조회
			int pageBlock = Integer.parseInt((String)hidPageBlock);
			//페이지 기본설정
			int pageArea = 10;
			//page
			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(intPage);
			paginationInfo.setRecordCountPerPage(pageBlock);
			paginationInfo.setPageSize(pageArea);
			map.put("startRow", paginationInfo.getFirstRecordIndex());
			map.put("endRow", paginationInfo.getLastRecordIndex());
		}

		map.put("searchTrgterCl", searchTrgterCl);
		map.put("searchTrgterNm", searchTrgterNm);
		map.put("searchDeStart", searchDe1);
		map.put("searchDeEnd", searchDe2);
		map.put("searchDeptCd", searchDeptCd);
		map.put("searchChager", searchChager);

		if(searchNo1.length() == 4){
			if(!searchNo2.isEmpty() && searchNo2 != null){
				map.put("searchNoStart", searchNo1 + "-" + String.format("%06d", Integer.parseInt(searchNo2)));
			}
			if(!searchNo3.isEmpty() && searchNo3 != null){
				map.put("searchNoEnd", searchNo1 + "-" + String.format("%06d", Integer.parseInt(searchNo3)));
			}
		}
		
		//sorting
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}

		int list_cnt = 0;
		List<HashMap> list = trnService.selectArrZeroStatList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	@RequestMapping (value = "/susZeroStatList/")
	public String susZeroStatList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String dept_single_nm = SimpleUtils.default_set(session.getAttribute("dept_single_nm").toString());
		String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());
		model.addAttribute("esntl_id", esntl_id);
		model.addAttribute("dept_cd", dept_cd);
		model.addAttribute("dept_single_nm", dept_single_nm);
		model.addAttribute("mngr_yn", mngr_yn);

		int pageBlock = 50;
		model.addAttribute("hidPageBlock", pageBlock);

		//대상자구분
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00102");
		List<HashMap> trgterClList = cdService.getCdList(cMap);
		model.addAttribute("trgterClList", trgterClList);

		return "trn/susZeroStatList";
	}

	@RequestMapping(value = "/susZeroStatListAjax/")
	public ModelAndView susZeroStatListAjax(HttpServletRequest request) throws Exception  {

		String searchNo1 = SimpleUtils.default_set(request.getParameter("searchNo1"));
		String searchNo2 = SimpleUtils.default_set(request.getParameter("searchNo2"));
		String searchNo3 = SimpleUtils.default_set(request.getParameter("searchNo3"));
		String searchTrgterCl = SimpleUtils.default_set(request.getParameter("searchTrgterCl"));
		String searchTrgterNm = SimpleUtils.default_set(request.getParameter("searchTrgterNm"));
		String searchDe1 = SimpleUtils.default_set(request.getParameter("searchDe1"));
		String searchDe2 = SimpleUtils.default_set(request.getParameter("searchDe2"));

		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));
		String searchChager = SimpleUtils.default_set(request.getParameter("searchChager"));
		
		String sortingFields = SimpleUtils.default_set(request.getParameter("sortingFields"));

		HashMap map = new HashMap();

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));
		if( hidPageBlock== null || hidPageBlock.equals("")){
			//전체조회
			hidPageBlock = "10";
			map.put("startRow", "");
			map.put("endRow", "");
		}else{
			//페이징조회
			int pageBlock = Integer.parseInt((String)hidPageBlock);
			//페이지 기본설정
			int pageArea = 10;
			//page
			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(intPage);
			paginationInfo.setRecordCountPerPage(pageBlock);
			paginationInfo.setPageSize(pageArea);
			map.put("startRow", paginationInfo.getFirstRecordIndex());
			map.put("endRow", paginationInfo.getLastRecordIndex());
		}

		map.put("searchTrgterCl", searchTrgterCl);
		map.put("searchTrgterNm", searchTrgterNm);
		map.put("searchDeStart", searchDe1);
		map.put("searchDeEnd", searchDe2);
		map.put("searchDeptCd", searchDeptCd);
		map.put("searchChager", searchChager);

		if(searchNo1.length() == 4){
			if(!searchNo2.isEmpty() && searchNo2 != null){
				map.put("searchNoStart", searchNo1 + "-" + String.format("%06d", Integer.parseInt(searchNo2)));
			}
			if(!searchNo3.isEmpty() && searchNo3 != null){
				map.put("searchNoEnd", searchNo1 + "-" + String.format("%06d", Integer.parseInt(searchNo3)));
			}
		}
		
		//sorting
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}

		int list_cnt = 0;
		List<HashMap> list = trnService.selectSusZeroStatList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
}
