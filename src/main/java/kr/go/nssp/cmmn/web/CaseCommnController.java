package kr.go.nssp.cmmn.web;

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

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CaseCommnService;
import kr.go.nssp.rc.service.RcService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;

/**
 * @description : 사건 공통
 * @author      : han
 * @version     : 1.0
 * @created     : 2019-05-09
 * @modified    :
 */
@Controller
@RequestMapping(value = "/ccc/")
public class CaseCommnController {

	@Resource
	private RcService rcService;			//사건접수관련 서비스

	@Resource
	private CaseCommnService caseCommnService;

	/**
	 * 내사건목록 팝업 화면 호출
	 * </pre>
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/caseDetailPopup/")
	public String caseDetailPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		String   rcNo = request.getParameter("rcNo");	//접수번호
		String caseNo = request.getParameter("caseNo");	//사건번호
		String itivNo = request.getParameter("itivNo");	//내사번호

		HashMap<String, Object> cMap = new HashMap<String, Object>();
		cMap.put("rc_no", rcNo);
		cMap.put("case_no", caseNo);
		cMap.put("itiv_no", itivNo);

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());
		if(!"Y".equals(mngr_yn)){
			//관리자 아닐시 본인사건만 조회가능
			cMap.put("charger_id", esntl_id);
			cMap.put("charger_dept_cd", dept_cd);
		}

		HashMap<String, Object> caseInfo = rcService.getSnNoDetail(cMap);
		if(caseInfo != null){
			String   v_rcNo = (String) caseInfo.get("RC_NO");
			String v_caseNo = (String) caseInfo.get("CASE_NO");
			String v_itivNo = (String) caseInfo.get("ITIV_NO");

			model.addAttribute(   "rcNo", v_rcNo   );
			model.addAttribute( "caseNo", v_caseNo );
			model.addAttribute( "itivNo", v_itivNo );

			return "cmm/caseDetailPopup";
		} else {
            model.addAttribute("script", "alert('조회한 사건이 없거나 담당사건만 조회할 수 있습니다.'); parent.caseDetailPopup.hide();");

            return "cmm/closePopup";
		}

	}

	/**
	 * main 사건 정보 검색 팝업
	 * </pre>
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping (value = "/caseInfoPopup/")
	public String caseInfoPopup (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		//InvUtil commonUtil = InvUtil.getInstance();
		//Map map = commonUtil.getParameterMapConvert(request);
		//HashMap<String, Object> caseInfo = rcService.getCaseInfoList(map);

		model.addAttribute( "searchType", Utility.nvl(request.getParameter("hidSearchType"))); //검색 구분
		model.addAttribute( "searchText", new String(Utility.nvl(request.getParameter("hidSearchText")).getBytes("8859_1"), "UTF-8")); //검색 단어

		return "cmm/caseInfoPopup";

	}

	/**
	 * 체포/구속영장관리
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/caseInfoListAjax/")
	@ResponseBody
	public List<HashMap> caseInfoList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	List<HashMap> list = caseCommnService.selectCaseInfoList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

}
