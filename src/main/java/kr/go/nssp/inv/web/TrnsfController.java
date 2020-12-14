package kr.go.nssp.inv.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.inv.service.TrnsfService;
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
 * @description : 이송관리
 * @author      : khlee
 * @version     : 1.0
 * @created     : 2019-04-17
 * @modified    :
 */
@Controller
@RequestMapping(value = "/inv/")
public class TrnsfController {

	@Autowired
	private TrnsfService trnsfService;

	@Autowired
	private CdService cdService;

	/**
	 * 이송관리 화면 호출
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/trnsfManage/")
	public String trnsfManage(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap param = new HashMap();
		// 이송기관구분코드
		param.put("upper_cd", "00764");
		model.addAttribute("trnsfInsttSeCdList", cdService.getCdList(param));
		
		return "inv/trnsfManage";
	}
	
	/**
	 * 팝업화면
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/trnsfPopup/")
	public String trnsfPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap param = new HashMap();
		// 이송기관구분코드
		param.put("upper_cd", "00764");
		model.addAttribute("trnsfInsttSeCdList", cdService.getCdList(param));
		
		HashMap map = new HashMap();
		Map<String, String> param2 = new HashMap();
		param2.put("RC_NO", Utility.nvl(request.getParameter("rcNo")));
		map = trnsfService.selectTrnsfInfo(param2);
		model.addAttribute("trnsf", map);
		
		return "inv/trnsfPopup";
	}	
	
	/**
	 * 이송목록 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/trnsfListAjax/")
	@ResponseBody
	public List trnsfListAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		System.out.println("================= trnsfListAjax Start ===================");
		System.out.println("reqParam:"+reqParam);
		Map<String, String> param = new HashMap<String, String>();
		
		String str = Utility.nvl(request.getParameter("txtSchNo1")) + "-" + StringUtils.leftPad(Utility.nvl(request.getParameter("txtSchNo2")), 6, '0');
		if(Utility.nvl(request.getParameter("rdoDiv")).equals("C")) {
			if(!str.replace("-000000", "").equals("")) {
				param.put("CASE_NO", str);
			}
			param.put("PRSCT_DE_FROM", Utility.nvl(request.getParameter("calSchDeFrom")));
			param.put("PRSCT_DE_TO", Utility.nvl(request.getParameter("calSchDeTo")));
		} else {
			if(!str.replace("-000000", "").equals("")) {
				param.put("RC_NO", str);
			}
			param.put("RC_DT_FROM", Utility.nvl(request.getParameter("calSchDeFrom")));
			param.put("RC_DT_TO", Utility.nvl(request.getParameter("calSchDeTo")));
		}
		param.put("TRNSF_DE_FROM", Utility.nvl(request.getParameter("calTrnsfDeFrom")));
		param.put("TRNSF_DE_TO", Utility.nvl(request.getParameter("calTrnsfDeTo")));

		System.out.println("param:"+param);
		System.out.println("================= trnsfListAjax End ===================");
		
		List list = trnsfService.selectTrnsfList(param);
		return list;
	}
	

	/**
	 * 이송 등록
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value={"/addTrnsfAjax", "/addTrnsfRcAjax/"})
	public ModelAndView addTrnsfAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";
		
		System.out.println("###[addTrnsfAjax]reqParam:"+reqParam);

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("RC_NO"              , Utility.nvl(reqParam.get("hidRcNo")));
			param.put("CASE_NO"            , Utility.nvl(reqParam.get("hidCaseNo")));
			param.put("TRNSF_DE"           , Utility.nvl(reqParam.get("calTrnsfDe")));
			param.put("TRNSF_INSTT_SE_CD"  , Utility.nvl(reqParam.get("rdoInsttSeCd")));
			param.put("TRNSF_INSTT_NM"     , Utility.nvl(reqParam.get("txtInsttNm")));
			param.put("TRNSF_INSTT_DEPT"   , Utility.nvl(reqParam.get("txtInsttDept")));
			param.put("TRNSF_INSTT_CHARGER", Utility.nvl(reqParam.get("txtInsttCharger")));
			param.put("TRNSF_RESN_CD"      , Utility.nvl(reqParam.get("selResnCd")));
			param.put("TRNSF_RESN_DC"      , Utility.nvl(reqParam.get("txtResnDc")));
			param.put("WRITNG_ID"          , esntl_id);
			param.put("UPDT_ID"            , esntl_id);

			trnsfService.insertTrnsf(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}	
	
	/**
	 * 이송 등록
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/modTrnsfAjax/")
	public ModelAndView modTrnsfAjax(HttpServletRequest request, @RequestParam Map<String, String> reqParam) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";
		
		System.out.println("###[modTrnsfAjax]reqParam:"+reqParam);

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("TRNSF_SN"           , Utility.nvl(reqParam.get("hidTrnsfSn")));
			param.put("TRNSF_DE"           , Utility.nvl(reqParam.get("calTrnsfDe")));
			param.put("TRNSF_INSTT_SE_CD"  , Utility.nvl(reqParam.get("rdoInsttSeCd")));
			param.put("TRNSF_INSTT_NM"     , Utility.nvl(reqParam.get("txtInsttNm")));
			param.put("TRNSF_INSTT_DEPT"   , Utility.nvl(reqParam.get("txtInsttDept")));
			param.put("TRNSF_INSTT_CHARGER", Utility.nvl(reqParam.get("txtInsttCharger")));
			param.put("TRNSF_RESN_CD"      , Utility.nvl(reqParam.get("selResnCd")));
			param.put("TRNSF_RESN_DC"      , Utility.nvl(reqParam.get("txtResnDc")));
			param.put("UPDT_ID"            , esntl_id);

			trnsfService.updateTrnsf(param);

		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}	
	
	
	@RequestMapping("/delTrnsfAjax/")
	public ModelAndView delTrnsfAjax(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("TRNSF_SN", Utility.nvl(request.getParameter("hidTrnsfSn")));
			param.put("UPDT_ID" , esntl_id);
			System.out.println("###[delTrnsfAjax]param:"+param);

			int cnt = trnsfService.deleteTrnsf(param);
			
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

	
}
