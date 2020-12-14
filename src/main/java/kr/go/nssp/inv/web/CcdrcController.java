package kr.go.nssp.inv.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.inv.service.CcdrcService;
import kr.go.nssp.utl.Utility;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * @description : 압수물관리
 * @author      : khlee
 * @version     : 1.0
 * @created     : 2019-03-22
 * @modified    :
 */
@Controller
@RequestMapping(value = "/inv/")
public class CcdrcController {

	@Autowired
	private CcdrcService ccdrcService;

	@Autowired
	private CdService cdService;
	
	@RequestMapping(value="/ccdrcCaseListAjax/")
	@ResponseBody
	public List caseListAjax(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String dept_cd = Utility.nvl(session.getAttribute("dept_cd"));
		HashMap param = new HashMap();
		param.put("CHARGER_ID", esntl_id);
		param.put("CHARGER_DEPT_CD", dept_cd);
		
		List list = ccdrcService.selectCcdrcCaseList(param);
		return list;
	}	

	/**
	 * 압수물관리 화면 호출
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/ccdrcManage/")
	public String ccdrcManage(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		model.addAttribute("hidRcNo", Utility.nvl(request.getParameter("hidRcNo")));		
		model.addAttribute("hidCaseNo", Utility.nvl(request.getParameter("hidCaseNo")));		
		return "inv/ccdrcManage";
	}

	/**
	 * 압수번호 선택 화면 호출
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/ccdrcNoListPopup/")
	public String ccdrcNoListPop(HttpServletRequest request, ModelMap model) throws Exception {
		Map<String, String> param = new HashMap<String, String>();
		param.put("CASE_NO", Utility.nvl(request.getParameter("schCaseNo")));
		param.put("RC_NO", Utility.nvl(request.getParameter("schRcNo")));

		List list = ccdrcService.selectCcdrcNoList(param);
		model.addAttribute("ccdrcNoList", list);

		return "inv/ccdrcNoListPopup";
	}

	/**
	 * 압수대상자 화면 호출
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ccdrcTrgterRegPopup/")
	public String ccdrcTrgterRegPopup(HttpServletRequest request, ModelMap model) throws Exception {
		
		HashMap<String, Object> cMap = new HashMap<String, Object>();
    	cMap.put("upper_cd", "00939"); 
    	model.addAttribute("hpNoCdList", cdService.getCdList(cMap)); //휴대폰번호 앞자리

    	model.addAttribute("telCdList", ccdrcService.selectTelCdList()); //전화번호 국번
    	
		model.addAttribute("hidCcdrcNo", Utility.nvl(request.getParameter("schCcdrcNo")));
		model.addAttribute("hidCcdrcSn", Utility.nvl(request.getParameter("schCcdrcSn")));
		model.addAttribute("hidCaseNo", Utility.nvl(request.getParameter("schCaseNo")));
		model.addAttribute("hidRcNo", Utility.nvl(request.getParameter("schRcNo")));
		model.addAttribute("hidSzureTrgterCd", Utility.nvl(request.getParameter("schSzureTrgterCd")));
		model.addAttribute("hidTrgterSe", Utility.nvl(request.getParameter("schTrgterSe")));	//S:피압수자, P:소유자

		return "inv/ccdrcTrgterRegPopup";
	}

	/**
	 * 사건대상자목록 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/ccdrcTrgterListAjax/")
	@ResponseBody
	public List ccdrcTrgterListAjax(HttpServletRequest request) throws Exception {
		Map<String, String> param = new HashMap<String, String>();
		param.put("CASE_NO", Utility.nvl(request.getParameter("hidCaseNo")));
		param.put("RC_NO", Utility.nvl(request.getParameter("hidRcNo")));

		List list = ccdrcService.selectCaseTrgterList(param);

		return list;
	}

	@RequestMapping(value="/ccdrcNoListAjax/")
	@ResponseBody
	public List ccdrcNoListAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		param.put("CASE_NO", Utility.nvl(param.get("schCaseNo"), param.get("hidCaseNo")));
		param.put("RC_NO", Utility.nvl(param.get("schRcNo"), param.get("hidRcNo")));

		List list = ccdrcService.selectCcdrcNoList(param);

		return list;
	}
	
	/**
	 * 압수물목록 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/ccdrcListAjax/")
	@ResponseBody
	public List ccdrcListAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		param.put("RC_NO", Utility.nvl(param.get("schRcNo")));		
		param.put("CASE_NO", Utility.nvl(param.get("schCaseNo")));
		param.put("RC_NO", Utility.nvl(param.get("schRcNo")));
		param.put("CCDRC_NO", Utility.nvl(param.get("schCcdrcNo")));
		System.out.println("[###ccdrcListAjax] param:"+param);

		List list = ccdrcService.selectCcdrcList(param);
		return list;
	}

	/**
	 * 사건대상자 상세정보
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/ccdrcTrgterInfoAjax/")
	@ResponseBody
	public ModelAndView ccdrcTrgterInfoAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		param.put("CCDRC_NO", Utility.nvl(param.get("hidCcdrcNo")));
		param.put("CCDRC_SN", Utility.nvl(param.get("hidCcdrcSn")));
		param.put("CASE_NO", Utility.nvl(param.get("hidCaseNo")));
		param.put("RC_NO", Utility.nvl(param.get("hidRcNo")));
		System.out.println("[ccdrcTrgterInfoAjax] param:"+param);

		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> info = new HashMap<String, String>();

		try {
			// 피압수자
			param.put("TRGTER_SE", "S");
			info = ccdrcService.selectCcdrcTrgterInfo(param);
			if(info == null) {
				info = new HashMap<String, String>();
				info.put("CCDRC_NO", "");
				info.put("CCDRC_SN", "");
				info.put("SZURE_TRGTER_CD", "");
				info.put("CASE_NO", "");
				info.put("RC_NO", "");
				info.put("TRGTER_SN", "");
				info.put("TRGTER_NM", "");
				info.put("TRGTER_RRN", "");
				info.put("TRGTER_TEL", "");
				info.put("TRGTER_HP_NO", "");
				info.put("ADRES_ZIP", "");
				info.put("ADRES_ADDR", "");
			}
			map.put("sInfo", info);

			// 소유자
			info = new HashMap<String, String>();
			param.put("TRGTER_SE", "P");
			info = ccdrcService.selectCcdrcTrgterInfo(param);
			if(info == null) {
				info = new HashMap<String, String>();
				info.put("CCDRC_NO", "");
				info.put("CCDRC_SN", "");
				info.put("SZURE_TRGTER_CD", "00722");
				info.put("CASE_NO", "");
				info.put("RC_NO", "");
				info.put("TRGTER_SN", "");
				info.put("TRGTER_NM", "");
				info.put("TRGTER_RRN", "");
				info.put("TRGTER_TEL", "");
				info.put("TRGTER_HP_NO", "");
				info.put("ADRES_ZIP", "");
				info.put("ADRES_ADDR", "");
			}
			map.put("pInfo", info);

		} catch(Exception e) {
			e.printStackTrace();
		}

		return new ModelAndView("ajaxView", "ajaxData", map);
	}

	@RequestMapping(value="/ccdrcTrgterInfoByPkAjax/")
	@ResponseBody
	public ModelAndView ccdrcTrgterInfoByPkAjax(HttpServletRequest request, @RequestParam Map<String, String> param) throws Exception {
		param.put("CCDRC_NO", Utility.nvl(param.get("hidCcdrcNo")));
		param.put("CCDRC_SN", Utility.nvl(param.get("hidCcdrcSn")));
		param.put("CASE_NO", Utility.nvl(param.get("hidCaseNo")));
		param.put("RC_NO", Utility.nvl(param.get("hidRcNo")));
		param.put("SZURE_TRGTER_CD", Utility.nvl(param.get("hidSzureTrgterCd")));
		System.out.println("###[압수대상자 개별조회]param:"+param);

		Map<String, Object> map = new HashMap<String, Object>();

		try {
			if(!Utility.nvl(param.get("hidSzureTrgterCd")).equals("")) {
				map = ccdrcService.selectCcdrcTrgterInfoByPk(param);
			}
			System.out.println("###[압수대상자 개별조회]map:"+map);
		} catch(Exception e) {
			e.printStackTrace();
		}

		return new ModelAndView("ajaxView", "ajaxData", map);
	}

	/**
	 * 압수물 등록
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addCcdrcAjax/")
	public ModelAndView addCcdrcAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";
		HashMap reMap = new HashMap();

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("CASE_NO"     , Utility.nvl(reqParam.get("hidCaseNo")));
			param.put("RC_NO"       , Utility.nvl(reqParam.get("hidRcNo")));
			param.put("CCDRC_NO"    , Utility.nvl(reqParam.get("hidCcdrcNo")));
			param.put("SZURE_DE"    , Utility.nvl(reqParam.get("calSzureDe")));
			param.put("CCDRC_CL_CD" , Utility.nvl(reqParam.get("selCcdrcClCd")));
			param.put("CCDRC_NM"    , Utility.nvl(reqParam.get("txtCcdrcNm")));
			param.put("CCDRC_QY"    , Utility.nvl(reqParam.get("txtCcdrcQy")));
			param.put("CCDRC_DC"    , Utility.nvl(reqParam.get("txtCcdrcDc")));
			param.put("POLC_OPINION", Utility.nvl(reqParam.get("txtPolcOpinion")));
			param.put("RNDM_PRESENTN_YN", Utility.nvl(reqParam.get("rdoRndmPresentnYn"))); //2019-07-12
			param.put("DSPS_CD"     , Utility.nvl(reqParam.get("selDspsCd")));
			param.put("DSPS_DE"     , Utility.nvl(reqParam.get("calDspsDe")));
			param.put("DSPS_DC"     , Utility.nvl(reqParam.get("txtDspsDc")));
			param.put("DSPS_RM"     , Utility.nvl(reqParam.get("txtDspsRm")));
			param.put("WRITNG_ID"   , esntl_id);
			param.put("UPDT_ID"     , esntl_id);

			List<Map<String, String>> list = setTrgterParams(reqParam, param);

			param.put("trgterList", list);

			// key 받아서 화면으로 넘겨줌
			reMap = ccdrcService.insertCcdrc(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);
		ret.putAll(reMap);
		
		System.out.println("###[addCcdrcAjax-저장후]"+reMap);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 압수물 수정
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modCcdrcAjax/")
	public ModelAndView modCcdrcAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";
		Map<String, Object> param = new HashMap<String, Object>();
		//System.out.println("           [압수물수정] reqParam : "+reqParam);

		try {
			
			param.put("CASE_NO"     , Utility.nvl(reqParam.get("hidCaseNo")));
			param.put("RC_NO"       , Utility.nvl(reqParam.get("hidRcNo")));
			param.put("CCDRC_NO"    , Utility.nvl(reqParam.get("hidCcdrcNo")));
			param.put("CCDRC_SN"    , Utility.nvl(reqParam.get("hidCcdrcSn"))); // insert는 없음
			param.put("SZURE_DE"    , Utility.nvl(reqParam.get("calSzureDe")));
			param.put("CCDRC_CL_CD" , Utility.nvl(reqParam.get("selCcdrcClCd")));
			param.put("CCDRC_NM"    , Utility.nvl(reqParam.get("txtCcdrcNm")));
			param.put("CCDRC_QY"    , Utility.nvl(reqParam.get("txtCcdrcQy")));
			param.put("CCDRC_DC"    , Utility.nvl(reqParam.get("txtCcdrcDc")));
			param.put("POLC_OPINION", Utility.nvl(reqParam.get("txtPolcOpinion")));
			param.put("RNDM_PRESENTN_YN", Utility.nvl(reqParam.get("rdoRndmPresentnYn"))); //2019-07-12
			param.put("DSPS_CD"     , Utility.nvl(reqParam.get("selDspsCd")));
			param.put("DSPS_DE"     , Utility.nvl(reqParam.get("calDspsDe")));
			param.put("DSPS_DC"     , Utility.nvl(reqParam.get("txtDspsDc")));
			param.put("DSPS_RM"     , Utility.nvl(reqParam.get("txtDspsRm")));
			param.put("WRITNG_ID"   , esntl_id);
			param.put("UPDT_ID"     , esntl_id);

			List<Map<String, String>> list = setTrgterParams(reqParam, param);

			param.put("trgterList", list);

			ccdrcService.updateCcdrc(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);
		ret.put("CASE_NO", Utility.nvl(param.get("CASE_NO")));
		ret.put("RC_NO", Utility.nvl(param.get("RC_NO")));
		ret.put("CCDRC_NO", Utility.nvl(param.get("CCDRC_NO")));
		ret.put("CCDRC_SN", Utility.nvl(param.get("CCDRC_SN")));
		ret.put("DOC_ID", Utility.nvl(reqParam.get("hidDocId")));
		ret.put("FILE_ID", Utility.nvl(reqParam.get("hidFileId")));
		System.out.println("###[modCcdrcAjax-수정후]"+ret);
		
		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping("/delCcdrcAjax/")
	public ModelAndView delCcdrcAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";
		
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, String> map = new HashMap<String, String>();
		System.out.println("###[압수물 삭제]reqParam:"+reqParam);

		try {
			param.put("CCDRC_NO"    , Utility.nvl(request.getParameter("hidCcdrcNo")));
			param.put("CCDRC_SN"    , Utility.nvl(request.getParameter("hidCcdrcSn")));
			param.put("UPDT_ID"     , esntl_id);
			System.out.println("###[압수물 삭제]param:"+param);

			ccdrcService.deleteCcdrc(param);
			map = ccdrcService.selectCcdrcDocId(param);
			System.out.println("###[압수물 삭제]map:"+map);
			
			if(map == null) {
				map = new HashMap<String, String>();
				map.put("RC_NO", Utility.nvl(request.getParameter("hidRcNo")));
				map.put("CASE_NO", Utility.nvl(request.getParameter("hidCaseNo")));
				map.put("CCDRC_NO", Utility.nvl(request.getParameter("hidCcdrcNo")));
				map.put("DOC_ID", "");
				map.put("FILE_ID", "");
				System.out.println("###[압수물 삭제]map=null map:"+map);
			}

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);
		ret.putAll(map);
		System.out.println("###[delCcdrcAjax-삭제후]"+ret);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 압수대상자 param setting
	 * @param request
	 * @param param
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, String>> setTrgterParams(Map<String, String> reqParam, Map<String, Object> param) throws Exception {
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		Map<String, String> paramT = null;

		// 소지자 또는 제출자 (업무적으로는 필수사항임)
		//if(!Utility.nvl(reqParam.get("txtSzureTrgterRrn")).equals("")) {
		paramT = new HashMap<String, String>();
		paramT.put("SZURE_TRGTER_CD", Utility.nvl(reqParam.get("selSzureTrgterSe")));
		paramT.put("TRGTER_TY_CD"   , Utility.nvl(reqParam.get("hidSzureTrgterTyCd")));		
		paramT.put("CASE_NO"        , Utility.nvl(reqParam.get("hidCaseNo")));
		paramT.put("RC_NO"          , Utility.nvl(reqParam.get("hidRcNo")));
		paramT.put("TRGTER_SN"      , Utility.nvl(reqParam.get("hidSzureTrgterSn")));

		if(Utility.nvl(reqParam.get("hidSzureTrgterSn")).equals("")) {
			paramT.put("TRGTER_NM"   , Utility.nvl(reqParam.get("txtSzureTrgterNm")));
			paramT.put("TRGTER_RRN"  , Utility.nvl(reqParam.get("txtSzureTrgterRrn")));
			paramT.put("TRGTER_TEL"  , Utility.nvl(reqParam.get("txtSzureTrgterTel")));
			paramT.put("TRGTER_HP_NO", Utility.nvl(reqParam.get("txtSzureTrgterHpNo")));
			paramT.put("ADRES_ZIP"   , Utility.nvl(reqParam.get("txtSzureAdresZip")));
			paramT.put("ADRES_ADDR"  , Utility.nvl(reqParam.get("txtSzureAdresAddr")));
			
		} else {
			paramT.put("TRGTER_NM"   , "");
			paramT.put("TRGTER_RRN"  , "");
			paramT.put("TRGTER_TEL"  , "");
			paramT.put("TRGTER_HP_NO", "");
			paramT.put("ADRES_ZIP"   , "");
			paramT.put("ADRES_ADDR"  , "");
		}

		paramT.put("WRITNG_ID" , Utility.nvl(param.get("WRITNG_ID")));
		paramT.put("UPDT_ID"   , Utility.nvl(param.get("UPDT_ID")));
		list.add(paramT);
		//}

		// 소유자 (업무적으로는 필수사항임)
		//if(!Utility.nvl(reqParam.get("txtSzureTrgterRrn")).equals("")) {
		paramT = new HashMap<String, String>();
		paramT.put("SZURE_TRGTER_CD", Utility.nvl(reqParam.get("hidPosesnTrgterSe")));
		paramT.put("TRGTER_TY_CD"   , Utility.nvl(reqParam.get("hidPosesnTrgterTyCd")));
		paramT.put("CASE_NO"        , Utility.nvl(reqParam.get("hidCaseNo")));
		paramT.put("RC_NO"          , Utility.nvl(reqParam.get("hidRcNo")));
		paramT.put("TRGTER_SN"      , Utility.nvl(reqParam.get("hidPosesnTrgterSn")));

		if(Utility.nvl(reqParam.get("hidPosesnTrgterSn")).equals("")) {
			paramT.put("TRGTER_NM"   , Utility.nvl(reqParam.get("txtPosesnTrgterNm")));
			paramT.put("TRGTER_RRN"  , Utility.nvl(reqParam.get("txtPosesnTrgterRrn")));
			paramT.put("TRGTER_TEL"  , Utility.nvl(reqParam.get("txtPosesnTrgterTel")));
			paramT.put("TRGTER_HP_NO", Utility.nvl(reqParam.get("txtPosesnTrgterHpNo")));
			paramT.put("ADRES_ZIP"   , Utility.nvl(reqParam.get("txtPosesnAdresZip")));
			paramT.put("ADRES_ADDR"  , Utility.nvl(reqParam.get("txtPosesnAdresAddr")));
		} else {
			paramT.put("TRGTER_NM"   , "");
			paramT.put("TRGTER_RRN"  , "");
			paramT.put("TRGTER_TEL"  , "");
			paramT.put("TRGTER_HP_NO", "");
			paramT.put("ADRES_ZIP"   , "");
			paramT.put("ADRES_ADDR"  , "");
		}

		paramT.put("WRITNG_ID" , Utility.nvl(param.get("WRITNG_ID")));
		paramT.put("UPDT_ID"   , Utility.nvl(param.get("UPDT_ID")));
		list.add(paramT);
		//}
		
		//System.out.println("           [압수물대상자] list : "+list);

		return list;
	}
}
