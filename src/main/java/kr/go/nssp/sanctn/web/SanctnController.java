package kr.go.nssp.sanctn.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.inv.service.PrsctService;
import kr.go.nssp.rc.service.RcService;
import kr.go.nssp.sanctn.service.SanctnService;
import kr.go.nssp.utl.RequestUtil;
import kr.go.nssp.utl.Utility;
import kr.go.nssp.utl.egov.EgovProperties;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value="/sanctn/")
public class SanctnController {

	//진행상태
	private String STTUS_SANCTN_WAIT = EgovProperties.getProperty("Globals.SttusSanctnWait");
	private String STTUS_SANCTN_RETURN = EgovProperties.getProperty("Globals.SttusSanctnReturn");
	private String STTUS_SANCTN_COMPT = EgovProperties.getProperty("Globals.SttusSanctnCompt");
	private String PAGE_BLOCK = "50";


	@Resource
	private SanctnService sanctnService;

	@Resource
	private PrsctService prsctService;

	@Resource
	private CdService cdService;
	
	@Resource
	private RcService rcService;

	@RequestMapping(value="/confmPopup/")
	public String confmPopup(HttpServletRequest request, HttpServletResponse responser, ModelMap model) throws Exception {
		String cate = SimpleUtils.default_set(request.getParameter("cate"));
		String chkId = SimpleUtils.default_set(request.getParameter("chkId"));
		String sttusCd = SimpleUtils.default_set(request.getParameter("sttusCd"));
		String cnt = SimpleUtils.default_set(request.getParameter("cnt")); //승인만 처리하기 위한 cnt

		model.addAttribute("cate", cate);
		model.addAttribute("chkId", chkId);
		model.addAttribute("sttusCd", sttusCd);
		model.addAttribute("sttus_sanctn_compt", STTUS_SANCTN_COMPT);
		model.addAttribute("sttus_sanctn_return", STTUS_SANCTN_RETURN);
		model.addAttribute("cnt", cnt);
		
		return "sanctn/confmPopup";
	}

    @RequestMapping(value="/confmAjax/")
    public ModelAndView confmAjax(HttpServletRequest request, HttpServletResponse responser) throws Exception {
		HttpSession session = request.getSession();
		String   esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String    dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String       cate = SimpleUtils.default_set(request.getParameter("cate"));	// [cate : category]  P=승인 
		String      chkId = SimpleUtils.default_set(request.getParameter("chkId"));
		String rdoSttusCd = SimpleUtils.default_set(request.getParameter("rdoSttusCd"));
		String txtConfmDc = SimpleUtils.default_set(request.getParameter("txtConfmDc"));

		String result = "1";
		int re_cnt = 999;

		System.out.println(">>>>>>>>>> confmAjax 승인/반려 ================ 시작");
		System.out.println(RequestUtil.getParameterMap(request));

		try {
			//String[] sanctn_id_arr = chkId.split("\\^");
			String[] sanctn_id_arr = chkId.split("X");

			//STTUS_SANCTN_COMPT, STTUS_SANCTN_RETURN
			HashMap map = new HashMap();
			map.put("sanctn_id_arr", sanctn_id_arr);
			map.put("esntl_id", esntl_id);
			map.put("sttus_cd", rdoSttusCd);
			map.put("confm_dc", txtConfmDc);

			System.out.println("map : "+map);
			System.out.println("cate : "+cate);
			System.out.println();

			if( "A".equals(cate) ){  	    //내사착수
				sanctnService.updateRcTmpr(map);
			} else if( "B".equals(cate) ){  //내사결과
				re_cnt = sanctnService.confirmItivResult(map);
			} else if( "C".equals(cate) ){  //입건승인
				map.put("dept_cd", dept_cd);
				re_cnt = sanctnService.confirmInvPrsct(map);
				//String rtnVal = prsctService.savePrsctCmpl(map);
			} else if( "D".equals(cate) ){  //입건취소
				re_cnt = sanctnService.confirmInvPrsctCancl(map);
			} else if( "T".equals(cate) ){  //송치
				re_cnt = sanctnService.confirmCaseTrn(map);
			} else if( "P".equals(cate) ){  //임시사건???승인/배당
				re_cnt = sanctnService.confirmCasePrsct(map);  //2019-05-22 승인은 "P"만 사용
			} else if( "S".equals(cate) ){  //임시사건 취소승인
				re_cnt = sanctnService.confirmTmprCancl(map);  //2019-07-29 추가
			}

			if( re_cnt < 1 ){
				result = "-1";
			}
			
		} catch( Exception e ){
			result = "-1";
		}

		HashMap ret = new HashMap();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

    /**
     * 내사착수 상세 팝업(현재 사용하는 곳 없음)
     * @param request
     * @param response
     * @param param
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping(value="/itivOutsetDetailPopup/")
	public String itivOutsetDetailPopup(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> param, ModelMap model) throws Exception {
		String  cate = Utility.nvl(param.get("cate"));
		HashMap pMap = new HashMap();
		pMap.put("sanctn_id", Utility.nvl(param.get("sanctnId")));

		if( "A".equals(cate) ){  //내사착수
			HashMap detail = sanctnService.getRcTmprDetail(pMap);
			model.addAttribute("jobNoTitle", "접수번호");
			model.addAttribute(  "jobNo", Utility.nvl(detail.get("RC_NO")));
			model.addAttribute("jobResn", Utility.nvl(detail.get("OUTSET_RESN")));
			model.addAttribute(  "docId", Utility.nvl(detail.get("DOC_ID")));
		} else if( "B".equals(cate) ){  //내사결과
			HashMap detail = sanctnService.selectRcItivResultInfo(pMap);
			model.addAttribute("jobNoTitle", "접수번호");
			model.addAttribute(  "jobNo", Utility.nvl(detail.get("RC_NO")));
			model.addAttribute("jobResn", Utility.nvl(detail.get("ITIV_CN")));
			model.addAttribute(  "docId", Utility.nvl(detail.get("DOC_ID")));
		} else if( "C".equals(cate) ){  //입건승인
			HashMap detail = sanctnService.selectInvAditPrsctInfo(pMap);
			if(Utility.nvl(detail.get("CASE_NO")).equals("")) {
				model.addAttribute("jobNoTitle", "접수번호");
				model.addAttribute("jobNo", Utility.nvl(detail.get("RC_NO")));
			} else {
				model.addAttribute("jobNoTitle", "접수번호(사건번호)");
				model.addAttribute("jobNo", Utility.nvl(detail.get("RC_NO"))+"("+Utility.nvl(detail.get("CASE_NO"))+")");
			}
			model.addAttribute("docId", Utility.nvl(detail.get("DOC_ID")));
		} else if( "D".equals(cate) ){  //입건취소
			HashMap detail = sanctnService.selectInvPrsctCanclInfo(pMap);
			model.addAttribute("jobNoTitle", "사건번호(접수번호)");
			model.addAttribute("jobNo", Utility.nvl(detail.get("CASE_NO"))+"("+Utility.nvl(detail.get("RC_NO"))+")");
			model.addAttribute("jobResn", Utility.nvl(detail.get("CANCL_CN")));
			model.addAttribute("docId", Utility.nvl(detail.get("DOC_ID")));
		} else if( "T".equals(cate) ){  //송치
			HashMap detail = sanctnService.selectTrnCaseInfo(pMap);
			model.addAttribute("jobNoTitle", "송치번호(사건번호)");
			model.addAttribute("jobNo", Utility.nvl(detail.get("TRN_NO"))+"("+Utility.nvl(detail.get("CASE_NO"))+")");
			model.addAttribute("docId", Utility.nvl(detail.get("DOC_ID")));
		} else if( "P".equals(cate) ){  //입건승인/배당
			HashMap detail = sanctnService.selectRcTmprInfo(pMap);
			if( Utility.nvl(detail.get("CASE_NO")).equals("") ){
				model.addAttribute("jobNoTitle", "접수번호");
				model.addAttribute("jobNo", Utility.nvl(detail.get("RC_NO")));
			} else {
				model.addAttribute("jobNoTitle", "접수번호(사건번호)");
				model.addAttribute("jobNo", Utility.nvl(detail.get("RC_NO"))+"("+Utility.nvl(detail.get("CASE_NO"))+")");
			}
			model.addAttribute("docId", Utility.nvl(detail.get("DOC_ID")));
		}

		return "sanctn/itivOutsetDetailPopup";
	}

	@RequestMapping(value="/historyPopup/")
	public String historyPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String hidSanctnId = SimpleUtils.default_set(request.getParameter("hidSanctnId"));
		model.addAttribute("hidSanctnId", hidSanctnId);
		return "sanctn/historyPopup";
	}

	@RequestMapping(value="/historyAjax/")
	public ModelAndView historyAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String hidSanctnId = SimpleUtils.default_set(request.getParameter("hidSanctnId"));

		HashMap map = new HashMap();
		map.put("sanctn_id", hidSanctnId);
		List<HashMap> list = sanctnService.getSanctnHistory(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
	}


	@RequestMapping(value="/itivOutsetList/")
	public String itivOutsetList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String dept_single_nm = SimpleUtils.default_set(session.getAttribute("dept_single_nm").toString());
		model.addAttribute("dept_cd", dept_cd);
		model.addAttribute("dept_single_nm", dept_single_nm);

		int pageBlock = Integer.parseInt(PAGE_BLOCK);
		model.addAttribute("hidPageBlock", pageBlock);

		//승인상태
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00021");
		List<HashMap> sttusList = cdService.getCdList(cMap);
		model.addAttribute("sttusList", sttusList);
		model.addAttribute("sttus_sanctn_wait", STTUS_SANCTN_WAIT);
		model.addAttribute("sttus_sanctn_compt", STTUS_SANCTN_COMPT);
		model.addAttribute("sttus_sanctn_return", STTUS_SANCTN_RETURN);

		return "sanctn/itivOutsetList";
	}

	@RequestMapping(value = "/itivOutsetListAjax/")
	public ModelAndView itivOutsetListAjax(HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());


		String searchSttusCd = SimpleUtils.default_set(request.getParameter("searchSttusCd"));
		String searchReqDe1 = SimpleUtils.default_set(request.getParameter("searchReqDe1"));
		String searchReqDe2 = SimpleUtils.default_set(request.getParameter("searchReqDe2"));
		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = Utility.nvl(request.getParameter("hidPageBlock"), PAGE_BLOCK);
		int pageBlock = Integer.parseInt((String)hidPageBlock);

		//페이지 기본설정
		int pageArea = 10;

		//page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put("endRow", paginationInfo.getLastRecordIndex());
		map.put("searchSttusCd", searchSttusCd);
		map.put("searchReqDe1", searchReqDe1);
		map.put("searchReqDe2", searchReqDe2);
		map.put("searchDeptCd", searchDeptCd);

		int list_cnt = 0;
		List<HashMap> list = sanctnService.getRcTmprList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 내사결과 목록
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/itivResultList/")
	public String itivResultList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String dept_single_nm = SimpleUtils.default_set(session.getAttribute("dept_single_nm").toString());
		model.addAttribute("dept_cd", dept_cd);
		model.addAttribute("dept_single_nm", dept_single_nm);

		int pageBlock = Integer.parseInt(PAGE_BLOCK);
		model.addAttribute("hidPageBlock", pageBlock);

		//승인상태
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00021");
		List<HashMap> sttusList = cdService.getCdList(cMap);
		model.addAttribute("sttusList", sttusList);
		model.addAttribute("sttus_sanctn_wait", STTUS_SANCTN_WAIT);
		model.addAttribute("sttus_sanctn_compt", STTUS_SANCTN_COMPT);
		model.addAttribute("sttus_sanctn_return", STTUS_SANCTN_RETURN);

		return "sanctn/itivResultList";
	}

	@RequestMapping(value="/itivResultListAjax/")
	public ModelAndView itivResultListAjax(HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		System.out.println(">>>>>>>>>> itivResultListAjax 내사결과 ================ 시작");
		System.out.println(RequestUtil.getParameterMap(request));

		String searchSttusCd = SimpleUtils.default_set(request.getParameter("searchSttusCd"));
		String searchReqDe1 = SimpleUtils.default_set(request.getParameter("searchReqDe1"));
		String searchReqDe2 = SimpleUtils.default_set(request.getParameter("searchReqDe2"));
		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = Utility.nvl(request.getParameter("hidPageBlock"), PAGE_BLOCK);
		int pageBlock = Integer.parseInt((String)hidPageBlock);

		//페이지 기본설정
		int pageArea = 10;

		//page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put("endRow", paginationInfo.getLastRecordIndex());
		map.put("searchSttusCd", searchSttusCd);
		map.put("searchReqDe1", searchReqDe1);
		map.put("searchReqDe2", searchReqDe2);
		map.put("searchDeptCd", searchDeptCd);

		int list_cnt = 0;
		List<HashMap> list = sanctnService.selectItivResultList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 입건승인 목록
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/invPrsctList/")
	public String invPrsctList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String dept_single_nm = SimpleUtils.default_set(session.getAttribute("dept_single_nm").toString());
		model.addAttribute("dept_cd", dept_cd);
		model.addAttribute("dept_single_nm", dept_single_nm);

		int pageBlock = Integer.parseInt(PAGE_BLOCK);
		model.addAttribute("hidPageBlock", pageBlock);

		//승인상태
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00021");
		List<HashMap> sttusList = cdService.getCdList(cMap);
		model.addAttribute("sttusList", sttusList);
		model.addAttribute("sttus_sanctn_wait", STTUS_SANCTN_WAIT);
		model.addAttribute("sttus_sanctn_compt", STTUS_SANCTN_COMPT);
		model.addAttribute("sttus_sanctn_return", STTUS_SANCTN_RETURN);

		return "sanctn/invPrsctList";
	}

	@RequestMapping(value="/invPrsctListAjax/")
	public ModelAndView invPrsctListAjax(HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		System.out.println(">>>>>>>>>> invPrsctListAjax 입건승인 ================ 시작");
		System.out.println(RequestUtil.getParameterMap(request));

		String searchSttusCd = SimpleUtils.default_set(request.getParameter("searchSttusCd"));
		String searchReqDe1 = SimpleUtils.default_set(request.getParameter("searchReqDe1"));
		String searchReqDe2 = SimpleUtils.default_set(request.getParameter("searchReqDe2"));
		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = Utility.nvl(request.getParameter("hidPageBlock"), PAGE_BLOCK);
		int pageBlock = Integer.parseInt((String)hidPageBlock);

		//페이지 기본설정
		int pageArea = 10;

		//page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put("endRow", paginationInfo.getLastRecordIndex());
		map.put("searchSttusCd", searchSttusCd);
		map.put("searchReqDe1", searchReqDe1);
		map.put("searchReqDe2", searchReqDe2);
		map.put("searchDeptCd", searchDeptCd);

		int list_cnt = 0;
		List<HashMap> list = sanctnService.selectInvPrsctList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 입건취소 목록
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/invPrsctCanclList/")
	public String invPrsctCanclList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String dept_single_nm = SimpleUtils.default_set(session.getAttribute("dept_single_nm").toString());
		model.addAttribute("dept_cd", dept_cd);
		model.addAttribute("dept_single_nm", dept_single_nm);

		int pageBlock = Integer.parseInt(PAGE_BLOCK);
		model.addAttribute("hidPageBlock", pageBlock);

		//승인상태
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00021");
		List<HashMap> sttusList = cdService.getCdList(cMap);
		model.addAttribute("sttusList", sttusList);
		model.addAttribute("sttus_sanctn_wait", STTUS_SANCTN_WAIT);
		model.addAttribute("sttus_sanctn_compt", STTUS_SANCTN_COMPT);
		model.addAttribute("sttus_sanctn_return", STTUS_SANCTN_RETURN);

		return "sanctn/invPrsctCanclList";
	}

	@RequestMapping(value="/invPrsctCanclListAjax/")
	public ModelAndView invPrsctCanclListAjax(HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		System.out.println(">>>>>>>>>> invPrsctCanclListAjax 입건취소 ================ 시작");
		System.out.println(RequestUtil.getParameterMap(request));

		String searchSttusCd = SimpleUtils.default_set(request.getParameter("searchSttusCd"));
		String searchReqDe1 = SimpleUtils.default_set(request.getParameter("searchReqDe1"));
		String searchReqDe2 = SimpleUtils.default_set(request.getParameter("searchReqDe2"));
		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = Utility.nvl(request.getParameter("hidPageBlock"), PAGE_BLOCK);
		int pageBlock = Integer.parseInt((String)hidPageBlock);

		//페이지 기본설정
		int pageArea = 10;

		//page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put("endRow", paginationInfo.getLastRecordIndex());
		map.put("searchSttusCd", searchSttusCd);
		map.put("searchReqDe1", searchReqDe1);
		map.put("searchReqDe2", searchReqDe2);
		map.put("searchDeptCd", searchDeptCd);

		int list_cnt = 0;
		List<HashMap> list = sanctnService.selectInvPrsctCanclList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 송치 목록
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/caseTrnList/")
	public String caseTrnList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String dept_single_nm = SimpleUtils.default_set(session.getAttribute("dept_single_nm").toString());
		model.addAttribute("dept_cd", dept_cd);
		model.addAttribute("dept_single_nm", dept_single_nm);

		int pageBlock = Integer.parseInt(PAGE_BLOCK);
		model.addAttribute("hidPageBlock", pageBlock);

		//승인상태
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00021");
		List<HashMap> sttusList = cdService.getCdList(cMap);
		model.addAttribute("sttusList", sttusList);
		model.addAttribute("sttus_sanctn_wait", STTUS_SANCTN_WAIT);
		model.addAttribute("sttus_sanctn_compt", STTUS_SANCTN_COMPT);
		model.addAttribute("sttus_sanctn_return", STTUS_SANCTN_RETURN);

		return "sanctn/caseTrnList";
	}

	@RequestMapping(value = "/caseTrnListAjax/")
	public ModelAndView caseTrnListAjax(HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		System.out.println(">>>>>>>>>> caseTrnListAjax 사건송치 ================ 시작");
		System.out.println(RequestUtil.getParameterMap(request));

		String searchSttusCd = SimpleUtils.default_set(request.getParameter("searchSttusCd"));
		String searchReqDe1 = SimpleUtils.default_set(request.getParameter("searchReqDe1"));
		String searchReqDe2 = SimpleUtils.default_set(request.getParameter("searchReqDe2"));
		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = Utility.nvl(request.getParameter("hidPageBlock"), PAGE_BLOCK);
		int pageBlock = Integer.parseInt((String)hidPageBlock);

		//페이지 기본설정
		int pageArea = 10;

		//page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put("endRow", paginationInfo.getLastRecordIndex());
		map.put("searchSttusCd", searchSttusCd);
		map.put("searchReqDe1", searchReqDe1);
		map.put("searchReqDe2", searchReqDe2);
		map.put("searchDeptCd", searchDeptCd);

		int list_cnt = 0;
		List<HashMap> list = sanctnService.selectTrnCaseList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 입건승인/배당 목록
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/prsctReqList/")
	public String prsctReqList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String dept_single_nm = SimpleUtils.default_set(session.getAttribute("dept_single_nm").toString());
		model.addAttribute("dept_cd", dept_cd);
		model.addAttribute("dept_single_nm", dept_single_nm);

		int pageBlock = Integer.parseInt(PAGE_BLOCK);
		model.addAttribute("hidPageBlock", pageBlock);

		//승인상태
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00021");
		List<HashMap> sttusList = cdService.getCdList(cMap);
		model.addAttribute("sttusList", sttusList);
		model.addAttribute("sttus_sanctn_wait", STTUS_SANCTN_WAIT);
		model.addAttribute("sttus_sanctn_compt", STTUS_SANCTN_COMPT);
		model.addAttribute("sttus_sanctn_return", STTUS_SANCTN_RETURN);

		return "sanctn/prsctReqList";
	}

	@RequestMapping(value="/prsctReqListAjax/")
	public ModelAndView prsctReqListAjax(HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		System.out.println(">>>>>>>>>> prsctReqListAjax 입건승인/배당 ================ 목록조회");
		System.out.println(RequestUtil.getParameterMap(request));

		String searchSttusCd = SimpleUtils.default_set(request.getParameter("searchSttusCd"));
		String  searchReqDe1 = SimpleUtils.default_set(request.getParameter("searchReqDe1"));
		String  searchReqDe2 = SimpleUtils.default_set(request.getParameter("searchReqDe2"));
		String  searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));
		String       chkAlot = SimpleUtils.default_set(request.getParameter("chkAlot")); 	//배당사건 여부
		String sortingFields = SimpleUtils.default_set(request.getParameter("sortingFields"));
		
		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = Utility.nvl(request.getParameter("hidPageBlock"), PAGE_BLOCK);
		int pageBlock = Integer.parseInt((String)hidPageBlock);

		//페이지 기본설정
		int pageArea = 10;

		//page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put(  "endRow", paginationInfo.getLastRecordIndex());
		map.put( "searchSttusCd", searchSttusCd );
		map.put(  "searchReqDe1", searchReqDe1  );
		map.put(  "searchReqDe2", searchReqDe2  );
		map.put(  "searchDeptCd", searchDeptCd  );
		
		if( chkAlot != null && "Y".equals(chkAlot.toUpperCase()) ){
			map.put("alot", "Y" );
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
		List<HashMap> list = sanctnService.selectPrsctReqList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 임시사건 승인처리
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/tmprCanclReqList/")
	public String tmprCanclReqList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String dept_single_nm = SimpleUtils.default_set(session.getAttribute("dept_single_nm").toString());
		model.addAttribute("dept_cd", dept_cd);
		model.addAttribute("dept_single_nm", dept_single_nm);

		int pageBlock = Integer.parseInt(PAGE_BLOCK);
		model.addAttribute("hidPageBlock", pageBlock);

		//승인상태
		HashMap cMap = new HashMap();
		cMap.put("upper_cd", "00021");
		List<HashMap> sttusList = cdService.getCdList(cMap);
		model.addAttribute("sttusList", sttusList);
		model.addAttribute("sttus_sanctn_wait", STTUS_SANCTN_WAIT);
		model.addAttribute("sttus_sanctn_compt", STTUS_SANCTN_COMPT);
		model.addAttribute("sttus_sanctn_return", STTUS_SANCTN_RETURN);

		return "sanctn/tmprCanclReqList";
	}

	@RequestMapping(value="/tmprCanclReqListAjax/")
	public ModelAndView tmprCanclReqListAjax(HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		
		String searchSttusCd = SimpleUtils.default_set(request.getParameter("searchSttusCd"));
		String searchReqDe1 = SimpleUtils.default_set(request.getParameter("searchReqDe1"));
		String searchReqDe2 = SimpleUtils.default_set(request.getParameter("searchReqDe2"));
		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));
		
		String sortingFields = SimpleUtils.default_set(request.getParameter("sortingFields"));

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = Utility.nvl(request.getParameter("hidPageBlock"), PAGE_BLOCK);
		int pageBlock = Integer.parseInt((String)hidPageBlock);

		//페이지 기본설정
		int pageArea = 10;

		//page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put("endRow", paginationInfo.getLastRecordIndex());
		map.put("searchSttusCd", searchSttusCd);
		map.put("searchReqDe1", searchReqDe1);
		map.put("searchReqDe2", searchReqDe2);
		map.put("searchDeptCd", searchDeptCd);
		
		//sorting
		//System.out.println("sortingFields >>>>>>>>>>>>>> "+sortingFields);
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}

		int list_cnt = 0;
		List<HashMap> list = sanctnService.selectTmprCanclReqList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
}
