package kr.go.nssp.inv.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.inv.service.CommnService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * @description : 통신사실확인 허가신청 관리
 * @author      : khlee
 * @version     : 1.0
 * @created     : 2019-04-04
 * @modified    :
 */
@Controller
@RequestMapping(value = "/inv/")
public class CommnController {

	@Autowired
	private CommnService commnService;

	@Autowired
	private CdService cdService;

	/**
	 * 통신사실확인 허가신청 관리 화면 호출
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/commnManage/")
	public String commnManage(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap param = new HashMap();
		// 통신사실확인 허가신청 결과
		param.put("upper_cd", "00736");
		List<String> arr = new ArrayList<String>();
		arr.add("00737");  // 허가신청
		param.put("cd_not_arr", arr);
		model.addAttribute("reqstResultCdList", cdService.getCdList(param));

		param = new HashMap();
		// 통신사실확인 허가신청 기각구분
		param.put("upper_cd", "00748");
		model.addAttribute("dsmsslSeCdList", cdService.getCdList(param));

		return "inv/commnManage";
	}

	/**
	 * 통신사실확인 허가신청 내역
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	/*@RequestMapping (value = "/commnReqstDtlsIframe/")
	public String commnReqstDtls(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		return "inv/commnReqstDtls";
	}*/

	/**
	 * 통신사실확인 허가신청 결과
	 * </pre>
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	/*@RequestMapping (value = "/commnReqstResultIframe/")
	public String commnReqstResult(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap param = new HashMap();
		// 통신사실확인 허가신청 결과
		param.put("upper_cd", "00736");
		List<String> arr = new ArrayList<String>();
		arr.add("00737");  // 허가신청
		param.put("cd_not_arr", arr);
		model.addAttribute("reqstResultCdList", cdService.getCdList(param));

		param = new HashMap();
		// 통신사실확인 허가신청 기각구분
		param.put("upper_cd", "00748");
		model.addAttribute("dsmsslSeCdList", cdService.getCdList(param));

		return "inv/commnReqstResult";
	}*/

	/**
	 * 내사건목록 팝업 화면 호출
	 * </pre>
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	/*@RequestMapping (value = "/myCaseListPopup/")
	public String myCaseListPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		return "inv/myCaseListPopup";
	}*/

	/**
	 * 대상자목록 팝업 화면 호출
	 * </pre>
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	/*@RequestMapping (value = "/myCaseTrgterListPopup/")
	public String myCaseTrgterListPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model, @RequestParam Map<String, String> requestParam) throws Exception {
		model.addAttribute("hidRcNo", Utility.nvl(request.getParameter("schRcNo")));

		return "inv/myCaseTrgterListPopup";
	}*/

	/**
	 * 내사건목록 검색
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	/*@RequestMapping(value="/myCaseListAjax/")
	@ResponseBody
	public List selectMyCaseList(HttpServletRequest request, @RequestParam Map<String, String> rparam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));

		Map<String, String> param = new HashMap<String, String>();
		param.put("CHARGER_ID", esntl_id);

		if(Utility.nvl(rparam.get("rdoDiv")).equals("R"))
		{
			param.put("RC_NO", Utility.nvl(rparam.get("schRcNo")));
		}
		else if(Utility.nvl(rparam.get("rdoDiv")).equals("C"))
		{
			param.put("RC_NO", Utility.nvl(rparam.get("schRcNo")));
		}
		List list = commnService.selectMyCaseList(param);
		return list;
	}*/

	/**
	 * 통신사실확인 허가신청 목록
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/commnListAjax/")
	@ResponseBody
	public List commnListAjax(HttpServletRequest request, @RequestParam Map<String, String> rparam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));

		Map<String, String> param = new HashMap<String, String>();
		param.put("WRITNG_ID", esntl_id);
		param.put("RC_NO", 			Utility.nvl(request.getParameter("hidRcNo")));
		param.put("TRGTER_SN", 		Utility.nvl(request.getParameter("hidTrgterSn")));
		/*내사건 관리에서 넘길때*/
		String sendRcNo = Utility.nvl(request.getParameter("searchRcNo"));
		String sendTrgterSn = Utility.nvl(request.getParameter("searchTrgterSn"));
		if(!sendRcNo.equals("") && !sendTrgterSn.equals("")) {
			param.put("RC_NO", 	sendRcNo);
			param.put("TRGTER_SN", 	sendTrgterSn);
		}
		List list = InvUtil.getInstance().getConvertUnderscoreNameGrid(commnService.selectCommnList(param));
		return list;
	}

	@RequestMapping (value = "/commnInfoAjax/")
	public ModelAndView commnInfoAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		Map<String, String> param = new HashMap<String, String>();
		param.put("WRITNG_ID", esntl_id);
		param.put("PRMISN_PROGRS_NO", Utility.nvl(request.getParameter("hidPrmisnProgrsNo")));
		Map<String, String> map = commnService.selectCommnInfo(param);
		if(map != null) {
			map = InvUtil.getInstance().getConvertUnderscoreName(commnService.selectCommnInfo(param));
		}
		return new ModelAndView("ajaxView", "ajaxData", map);
	}

	/**
	 * 통신사실확인 허가신청 등록
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addCommnAjax/")
	public ModelAndView addCommnAjax(HttpServletRequest request, @RequestParam Map<String, String> requestParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";
		String sKey = "";
		try {
			// 통신사실확인 허가신청 정보
			Map<String, String> param = new HashMap<String, String>();
			param.put("REQST_DE"        , Utility.nvl(requestParam.get("txtReqstDe")));
			param.put("PRMISN_SE_CD"    , Utility.nvl(requestParam.get("selPrmisnSeCd")));
			param.put("COMMN_BSNM"      , Utility.nvl(requestParam.get("txtCommnBsnm")));
			param.put("DTA_SCOPE"       , Utility.nvl(requestParam.get("txtDtaScope")));
			param.put("REQUST_RESN"     , Utility.nvl(requestParam.get("txtRequstResn")));
			param.put("SBSCRBER_RELATE" , Utility.nvl(requestParam.get("txtSbscrberRelate")));
			param.put("RERQEST_RESN"    , Utility.nvl(requestParam.get("txtRerqestResn")));
			param.put("NNPMSNPC_RESN"   , Utility.nvl(requestParam.get("txtNnpmsnpcResn")));
			param.put("EXCUT_DT"        , Utility.nvl(requestParam.get("txtExcutDt")));
			param.put("EXCUT_DT2"       , Utility.nvl(requestParam.get("txtExcutDt2")));
			param.put("EXCUT_DT3"       , Utility.nvl(requestParam.get("txtExcutDt3")));
			param.put("RC_NO"         	, Utility.nvl(requestParam.get("hidRcNo")));
			param.put("TRGTER_SN"       , Utility.nvl(requestParam.get("hidTrgterSn")));
			param.put("WRITNG_ID"       , esntl_id);
			param.put("UPDT_ID"         , esntl_id);
			/*별지 양식*/
			param.put("DTA_SCOPE_ENCLSR_YN"       	, Utility.nvl(requestParam.get("chkDtaScopeEnclsrYn")));
			param.put("REQUST_RESN_ENCLSR_YN"       , Utility.nvl(requestParam.get("chkRequstResnEnclsrYn")));
			param.put("SBSCRBER_RELATE_ENCLSR_YN"	, Utility.nvl(requestParam.get("chkSbscrberRelateEnclsrYn")));
			param.put("RERQEST_RESN_ENCLSR_YN"      , Utility.nvl(requestParam.get("chkRerqestResnEnclsrYn")));
			param.put("NNPMSNPC_RESN_ENCLSR_YN"    	, Utility.nvl(requestParam.get("chkNnpmsnpcResnEnclsrYn")));

			sKey = commnService.insertCommn(param);
			if(Utility.nvl(sKey).equals("")) {
				result = "-1";
			}

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);
		ret.put("key", sKey);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 통신사실확인 허가신청 재신청
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addCommnReAjax/")
	public ModelAndView addCommnReAjax(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";
		String sKey = "";

		try {
			// 통신사실확인 허가신청 정보
			Map<String, String> param = new HashMap<String, String>();
			param.put("ORIGNL_PROGRS_NO", Utility.nvl(request.getParameter("hidPrmisnProgrsNo")));
			param.put("WRITNG_ID", esntl_id);
			param.put("UPDT_ID"  , esntl_id);

			sKey = commnService.insertCommnRe(param);
			if(Utility.nvl(sKey).equals("")) {
				result = "-1";
			}

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);
		ret.put("key", sKey);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 통신사실확인 허가신청 수정
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modCommnAjax/")
	public ModelAndView modCommnAjax(HttpServletRequest request, @RequestParam Map<String, String> requestParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";
		try {
			// 통신사실확인 허가신청 정보
			Map<String, String> param = new HashMap<String, String>();
			param.put("PRMISN_PROGRS_NO", Utility.nvl(requestParam.get("hidPrmisnProgrsNo")));
			param.put("REQST_DE"        , Utility.nvl(requestParam.get("txtReqstDe")));
			param.put("PRMISN_SE_CD"    , Utility.nvl(requestParam.get("selPrmisnSeCd")));
			param.put("COMMN_BSNM"   	, Utility.nvl(requestParam.get("txtCommnBsnm")));
			param.put("DTA_SCOPE"       , Utility.nvl(requestParam.get("txtDtaScope")));
			param.put("REQUST_RESN"     , Utility.nvl(requestParam.get("txtRequstResn")));
			param.put("SBSCRBER_RELATE" , Utility.nvl(requestParam.get("txtSbscrberRelate")));
			param.put("RERQEST_RESN"    , Utility.nvl(requestParam.get("txtRerqestResn")));
			param.put("NNPMSNPC_RESN"   , Utility.nvl(requestParam.get("txtNnpmsnpcResn")));
			param.put("EXCUT_DT"        , Utility.nvl(requestParam.get("txtExcutDt")));
			param.put("EXCUT_DT2"       , Utility.nvl(requestParam.get("txtExcutDt2")));
			param.put("EXCUT_DT3"       , Utility.nvl(requestParam.get("txtExcutDt3")));
			param.put("RC_NO"         	, Utility.nvl(requestParam.get("hidRcNo")));
			param.put("TRGTER_SN"       , Utility.nvl(requestParam.get("hidTrgterSn")));
			param.put("UPDT_ID"         , esntl_id);
			/*별지 양식*/
			param.put("DTA_SCOPE_ENCLSR_YN"       	, Utility.nvl(requestParam.get("chkDtaScopeEnclsrYn")));
			param.put("REQUST_RESN_ENCLSR_YN"       , Utility.nvl(requestParam.get("chkRequstResnEnclsrYn")));
			param.put("SBSCRBER_RELATE_ENCLSR_YN"	, Utility.nvl(requestParam.get("chkSbscrberRelateEnclsrYn")));
			param.put("RERQEST_RESN_ENCLSR_YN"      , Utility.nvl(requestParam.get("chkRerqestResnEnclsrYn")));
			param.put("NNPMSNPC_RESN_ENCLSR_YN"    	, Utility.nvl(requestParam.get("chkNnpmsnpcResnEnclsrYn")));

			int cnt = commnService.updateCommn(param);
			if(cnt < 1) {
				result = "-1";
			}

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);
		ret.put("key", Utility.nvl(requestParam.get("hidPrmisnProgrsNo")));

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 통신사실확인 허가신청 결과 수정
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modCommnResultAjax/")
	public ModelAndView modCommnResultAjax(HttpServletRequest request, @RequestParam Map<String, String> requestParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";
		try {
			// 통신사실확인 허가신청 정보
			Map<String, String> param = new HashMap<String, String>();
			param.put("PRMISN_PROGRS_NO", Utility.nvl(requestParam.get("hidPrmisnProgrsNo")));
			param.put("REQST_RESULT_CD" , Utility.nvl(requestParam.get("rdoReqstResultCd")));
			param.put("UPDT_ID"         , esntl_id);

			if(Utility.nvl(requestParam.get("rdoReqstResultCd")).equals("00738"))  // 허가
			{
				param.put("PRMISN_NO"      , Utility.nvl(requestParam.get("txtPrmisnNo")));
				param.put("PRMISN_RECPT_DE", Utility.nvl(requestParam.get("txtPrmisnRecptDe")));
				param.put("ISUE_DE"        , Utility.nvl(requestParam.get("txtIsueDe")));
			}
			else if(Utility.nvl(requestParam.get("rdoReqstResultCd")).equals("00739"))  // 기각
			{
				param.put("DSMSSL_SE_CD"   , Utility.nvl(requestParam.get("rdoDsmsslSeCd")));
				param.put("DSMSSL_DE"      , Utility.nvl(requestParam.get("txtDsmsslDe")));
				param.put("DSMSSL_RESN"    , Utility.nvl(requestParam.get("txtDsmsslResn")));
			}
			else if(Utility.nvl(requestParam.get("rdoReqstResultCd")).equals("00740")) // 반환
			{
				param.put("RETURN_DE"      , Utility.nvl(requestParam.get("txtReturnDe")));
				param.put("RETURN_RESN"    , Utility.nvl(requestParam.get("txtReturnResn")));
			}

			int cnt = commnService.updateCommnResult(param);
			if(cnt < 1) {
				result = "-1";
			}

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);
		ret.put("key", Utility.nvl(requestParam.get("hidPrmisnProgrsNo")));

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping("/delCommnAjax/")
	public ModelAndView delCommnAjax(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		try {
			Map<String, String> param = new HashMap<String, String>();
			param.put("PRMISN_PROGRS_NO", Utility.nvl(request.getParameter("hidPrmisnProgrsNo")));
			param.put("UPDT_ID", esntl_id);
			System.out.println("###[통신수사 삭제]param:"+param);

			commnService.deleteCommn(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}
}
