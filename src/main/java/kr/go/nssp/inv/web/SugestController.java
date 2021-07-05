package kr.go.nssp.inv.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.cmmn.service.FileService;
import kr.go.nssp.inv.service.SugestService;
import kr.go.nssp.trn.service.TrnRcordService;
import kr.go.nssp.utl.Utility;
import kr.go.nssp.utl.egov.EgovProperties;

@Controller
@RequestMapping(value = "/inv/")
public class SugestController {

	//건의구분 : 수사지휘, 피의자석방, 압수물지휘
	private String SUGGEST_CASE1 = EgovProperties.getProperty("Globals.SuggestCase1");
	private String SUGGEST_CASE2 = EgovProperties.getProperty("Globals.SuggestCase2");
	private String SUGGEST_CASE3 = EgovProperties.getProperty("Globals.SuggestCase3");

	@Resource
	private SugestService sugestService;

	@Resource
	private TrnRcordService trnRcordService;

	@Resource
    private DocService docService;

	@Resource
	private FileService fileService;

	@Resource
	private CdService cdService;

	@RequestMapping (value = "/sugest/")
	public String  sugest(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));
        String sugestTyCd = SimpleUtils.default_set(request.getParameter("sugestTyCd"));
        if(sugestTyCd.isEmpty()) sugestTyCd = SUGGEST_CASE1;
		model.addAttribute("rcNo", rcNo);
		model.addAttribute("sugestTyCd", sugestTyCd);

		//건의분류
    	HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "01100");
		List<HashMap> sugestClList = cdService.getCdList(cMap);


		model.addAttribute("sugestClList", sugestClList);

		/** 서식분류
		00458 : 수사지휘
		00459 : 피의자석방
		00460 : 압수물지휘
		 */
		model.addAttribute("format_case1", "00458");
		model.addAttribute("format_case2", "00459");
		model.addAttribute("format_case3", "00460");

		model.addAttribute("suggest_case1", SUGGEST_CASE1);
		model.addAttribute("suggest_case2", SUGGEST_CASE2);
		model.addAttribute("suggest_case3", SUGGEST_CASE3);

		model.addAttribute("hidLoginNm",  request.getSession().getAttribute("user_nm"));
		model.addAttribute("hidLoginDeptNm",  request.getSession().getAttribute("dept_nm"));

		return "inv/sugest";
	}

    @RequestMapping(value="/sugestCaseListAjax/")
    public ModelAndView sugestCaseListAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

    	HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);
		map.put("dept_cd", dept_cd);
    	List<HashMap> list = sugestService.getInvPrsctList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
    }

    @RequestMapping(value="/sugestCaseTrgterListAjax/")
    public ModelAndView sugestCaseTrgterListAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));
    	HashMap map = new HashMap();
		map.put("rc_no", rcNo);
    	List<HashMap> list = sugestService.getInvPrsctTrgterList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
    }

    @RequestMapping(value="/sugestCaseArrstListAjax/")
    public ModelAndView sugestCaseArrstListAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));
    	HashMap map = new HashMap();
		map.put("rc_no", rcNo);
    	List<HashMap> list = sugestService.getInvPrsctArrstList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
    }

    @RequestMapping(value="/sugestListAjax/")
    public ModelAndView sugestListAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));
    	HashMap map = new HashMap();
		map.put("rc_no", rcNo);
    	List<HashMap> list = sugestService.getInvSugestList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
    }

    @RequestMapping(value="/sugestDetailAjax/")
    public ModelAndView sugestDetailAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String sugestNo = SimpleUtils.default_set(request.getParameter("sugestNo"));
    	HashMap map = new HashMap();
		map.put("sugest_no", sugestNo);
    	HashMap result = sugestService.getInvSugestDetail(map);
		return new ModelAndView("ajaxView", "ajaxData", result);
    }

    @RequestMapping(value="/sugestCcdrcListAjax/")
    public ModelAndView sugestCcdrcListAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));
        String sugestNo = SimpleUtils.default_set(request.getParameter("hidSugestNo"));
    	HashMap map = new HashMap();
		map.put("rc_no", rcNo);
		map.put("sugest_no", sugestNo);
    	List<HashMap> list = sugestService.getInvSugestCcdrcList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
    }

	@RequestMapping("/addSugestAjax/")
	public ModelAndView addSugestAjax(HttpServletRequest request) throws Exception {

		Utility utl = Utility.getInstance();
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		String hidSugestNo = SimpleUtils.default_set(request.getParameter("hidSugestNo"));
		String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));

		String hidPkSn = SimpleUtils.default_set(request.getParameter("hidPkSn"));
		String hidCcdrcNo = SimpleUtils.default_set(request.getParameter("hidCcdrcNo"));

		String sugestTyCd = SimpleUtils.default_set(request.getParameter("sugestTyCd"));
		String selSugestClCd = SimpleUtils.default_set(request.getParameter("selSugestClCd"));
		String txtSugestDe = SimpleUtils.default_set(request.getParameter("txtSugestDe"));
		String txtSugestCn = SimpleUtils.default_set(request.getParameter("txtSugestCn"));
		String txtCmndDe = SimpleUtils.default_set(request.getParameter("txtCmndDe"));
		String rdoSugestResultCd = SimpleUtils.default_set(request.getParameter("rdoSugestResultCd"));
		String txtCmndPrsecNm = SimpleUtils.default_set(request.getParameter("txtCmndPrsecNm"));
		String txtCmndCn = SimpleUtils.default_set(request.getParameter("txtCmndCn"));

		String rdoSugestOpinionCd = SimpleUtils.default_set(request.getParameter("rdoSugestOpinionCd"));

        String result = "1";
        String sugest_no = "";
		try{

	    	HashMap map = new HashMap();
			map.put("rc_no", rcNo);
			if(SUGGEST_CASE2.equals(sugestTyCd)){
				String[] pk_val = hidPkSn.split(":");
				if(pk_val.length == 2){
					map.put("trgter_sn", pk_val[0]);
					map.put("arrst_sn", pk_val[1]);
				}else{
					map.put("trgter_sn", "");
					map.put("arrst_sn", "");
				}
			}else{
				map.put("trgter_sn", "");
				map.put("arrst_sn", "");
			}
			if(SUGGEST_CASE3.equals(sugestTyCd)){
				String[] ccdrcList = hidCcdrcNo.split("\\^");
				map.put("ccdrc_list", ccdrcList);
			}else{
				map.put("ccdrc_list", "");
			}
			map.put("sugest_ty_cd", sugestTyCd);
			map.put("sugest_cl_cd", selSugestClCd);
			map.put("sugest_de", txtSugestDe);
			map.put("sugest_cn", txtSugestCn);
			map.put("cmnd_de", txtCmndDe);
			map.put("sugest_result_cd", rdoSugestResultCd);
			map.put("cmnd_prsec_nm", txtCmndPrsecNm);
			map.put("cmnd_cn", txtCmndCn);
	    	map.put("dept_cd", dept_cd);
	    	map.put("esntl_id", esntl_id);
	    	map.put("sugest_opinion_cd", rdoSugestOpinionCd);

	        if(hidSugestNo == null || hidSugestNo.equals("")){
	        	String docId = docService.getDocID();
	        	map.put("doc_id", docId);
	        	map.put("file_id", fileService.getFileID());
	        	sugest_no = sugestService.addInvSugest(map);
	        }else{
	        	sugest_no = hidSugestNo;
	    		map.put("sugest_no", hidSugestNo);
	        	HashMap data = sugestService.getInvSugestDetail(map);
	        	if(data != null){
	        		sugestService.updateInvSugest(map);
	        	}
	        }

		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);
    	ret.put("sugest_no", sugest_no);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


	@RequestMapping("/deleteSugestAjax/")
	public ModelAndView deleteSugestAjax(HttpServletRequest request) throws Exception {
		Utility utl = Utility.getInstance();
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String hidSugestNo = SimpleUtils.default_set(request.getParameter("hidSugestNo"));

        String result = "1";
		try{

	    	HashMap map = new HashMap();
			map.put("sugest_no", hidSugestNo);
        	HashMap data = sugestService.getInvSugestDetail(map);
        	if(data != null){
    	    	map.put("esntl_id", esntl_id);
        		sugestService.updateInvSugestDisable(map);
        	}
		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

    @RequestMapping(value="/sugestHistoryPopup/")
    public String sugestHistoryPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));
        model.addAttribute("rcNo", rcNo);
        return "inv/sugestHistoryPopup";
    }

    @RequestMapping(value="/sugestHistoryAjax/")
    public ModelAndView sugestHistoryAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));

        HashMap map = new HashMap();
		map.put("rc_no", rcNo);
    	List<HashMap> list = sugestService.getInvSugestList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
    }










   	/**
   	 * 송치기록목록 팝업
   	 * @param request
   	 * @param response
   	 * @param model
   	 * @return
   	 * @throws Exception
   	 */
    @RequestMapping(value="/sugestRcordPopup/")
    public String sugestRcordPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));
        model.addAttribute("hidRcordRcNo", rcNo);
        return "inv/sugestRcordPopup";
    }

	/**
	 * 송치기록목록 조회
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="/sugestRcordListAjax/")
	public ModelAndView sugestRcordListAjax(HttpServletRequest request) throws Exception {
	    String hidRcordRcNo = SimpleUtils.default_set(request.getParameter("hidRcordRcNo"));

		HashMap map = new HashMap();
		map.put("RC_NO", hidRcordRcNo);
    	List<HashMap> list = trnRcordService.selectTrnRcordList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
    }

	/**
	 * 송치기록목록 추가
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */

	@RequestMapping("/addSugestRcordAjax/")
	public ModelAndView addSugestRcordAjax(HttpServletRequest request) throws Exception {

	    HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

	    String hidRcordRcNo = SimpleUtils.default_set(request.getParameter("hidRcordRcNo"));
	    String hidRcordSn = SimpleUtils.default_set(request.getParameter("hidRcordSn"));
		String txtRcordNm = SimpleUtils.default_set(request.getParameter("txtRcordNm"));
		String txtRcordStater = SimpleUtils.default_set(request.getParameter("txtRcordStater"));
		String txtRcordCo = SimpleUtils.default_set(request.getParameter("txtRcordCo"));
		String calRcordDe = SimpleUtils.default_set(request.getParameter("calRcordDe"));
		String txtRcordSort = SimpleUtils.default_set(request.getParameter("txtRcordSort"));

        String result = "1";
		try{
			HashMap map = new HashMap();
			map.put("RC_NO" , hidRcordRcNo);
			map.put("RCORD_NM", txtRcordNm);
			map.put("RCORD_STATER", txtRcordStater);
			map.put("RCORD_CO", txtRcordCo);
			map.put("RCORD_DE", calRcordDe);
			map.put("SORT_ORDR", txtRcordSort);
			map.put("WRITNG_ID", esntl_id);
			map.put("UPDT_ID"  , esntl_id);

		    if(hidRcordSn == null || hidRcordSn.equals("")){
				trnRcordService.insertTrnRcord(map);
		    }else{
				map.put("RCORD_SN", hidRcordSn);
				trnRcordService.updateTrnRcord(map);
		    }

		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
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
	@RequestMapping("/deleteSugestRcordAjax/")
	public ModelAndView deleteSugestRcordAjax(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
	    String hidRcordRcNo = SimpleUtils.default_set(request.getParameter("hidRcordRcNo"));
	    String hidRcordSn = SimpleUtils.default_set(request.getParameter("hidRcordSn"));

        String result = "1";
		try{
	    	HashMap map = new HashMap();
	    	map.put("RC_NO" , hidRcordRcNo);
	    	map.put("RCORD_SN", hidRcordSn);
	    	map.put("UPDT_ID"  , esntl_id);
			trnRcordService.deleteTrnRcord(map);
		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 의견서 작성여부 확인
	 * @param request
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/selectDocChkAjax/")
	public ModelAndView selectDocChk (HttpServletRequest request) throws Exception {
	    String hidSugestNo = SimpleUtils.default_set(request.getParameter("hidSugestNo"));
        int result = 0;
		try{
	    	HashMap map = new HashMap();
	    	map.put("SUGEST_NO" , hidSugestNo);
	    	result = sugestService.selectDocChkAjax(map);
		}catch(Exception e){
			result = -1;
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 피의자 순서 변경
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping (value = "/saveTrgterOrder/", method=RequestMethod.POST)
	@ResponseBody
	public int saveTrgterOrder (HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception {
		//System.out.println("11111111111112222222222222222");
		//System.out.println("paramparam:::"+param);
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	param.put("esntl_id", esntl_id);
    	param.put("dept_cd", dept_cd);
		int rtnVal = sugestService.saveTrgterOrder (param);
		return rtnVal;
	}
	
	/** 
	 * @methodName : updateCmndPrsecNmAjax
	 * @date : 2021.06.25
	 * @author : dgkim
	 * @description : 사건종결 후에도 지휘건의 검사명 수정가능하게끔 조치
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateCmndPrsecNmAjax/")
	public ModelAndView updateCmndPrsecNmAjax (HttpSession session, @RequestBody Map<String, Object> param) throws Exception {
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String result = "1";
		
		try {
			List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("sList");
			for(Map<String, Object> obj : list) {
				obj.put("esntl_id", esntl_id);
			}
			
			sugestService.updateCmndPrsecNm(list);
		}catch (Exception e) {
			result = "-1";
		}
		
		HashMap<String, Object> ret = new HashMap<String, Object>();
		ret.put("result", result);
		
		return new ModelAndView("ajaxView", "ajaxData", ret);
	}
}
