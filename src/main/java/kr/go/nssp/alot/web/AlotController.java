package kr.go.nssp.alot.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.alot.service.AlotService;
import kr.go.nssp.utl.Utility;
import kr.go.nssp.utl.egov.EgovProperties;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


@Controller
@RequestMapping(value = "/alot/")
public class AlotController {

	private String JUSO_CONFIRM_KEY = EgovProperties.getProperty("Globals.JusoConfirmKey");

	@Resource
	private AlotService alotService;


	@RequestMapping(value = "/userListAjax/")
	public ModelAndView userListAjax(HttpServletRequest request) throws Exception  {
        String hidDeptCd = SimpleUtils.default_set(request.getParameter("hidDeptCd"));
        String hidUserId = SimpleUtils.default_set(request.getParameter("hidUserId"));
        String chkAlotJobSe = SimpleUtils.default_set(request.getParameter("chkAlotJobSe"));
        /* 
    	 * 2021.02.17 김지만 수사관 요청 
    	 * 사건배당시 직원 검색 기능 추가
    	 */
        String txtUserNm = SimpleUtils.default_set(request.getParameter("txtUserNm"));

        /**
         * 02101	접수대기
         * 02102	접수승인요청
         * 02103	접수완료
         * 02104	접수반려
         *
         * 02111	임시종결
         * 02112	내사중지
         * 02113	내사종결
         * 02114	이송종결
         *
         * 02121	수사지휘건의
         * 02122	송치준비중
         * 02123	송치종결
         * 02124	기소중지
         * 02125	참고인중지
         *
         * 02131	사건구분변경요청
         * 02132	사건구분변경반려
         *
         * 02141	사건삭제요청
         * 02142	사건삭제
         * 02143	사건삭제반려
         */
    	HashMap map = new HashMap();
    	map.put("dept_cd", hidDeptCd);
    	map.put("esntl_id", hidUserId);
    	map.put("alot_job_se", chkAlotJobSe);
    	/* 
    	 * 2021.02.17 김지만 수사관 요청 
    	 * 사건배당시 직원 검색 기능 추가
    	 */
    	map.put("user_nm", txtUserNm);

    	List<HashMap> result = alotService.getUserList(map);

		return new ModelAndView("ajaxView", "ajaxData", result);
	}

    @RequestMapping(value="/alotPopup/")
    public String alotPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String snNo = SimpleUtils.default_set(request.getParameter("snNo"));
        String gbn = SimpleUtils.default_set(request.getParameter("gbn"));
        String ret = SimpleUtils.default_set(request.getParameter("ret"));

        String result = "1";

		//gbn R(접수), I(입건)
		//ret N(바로저장), Y(리턴값)
    	HashMap map = new HashMap();
		HashMap alotInfo = new HashMap();

		map.put("rc_no", snNo);
		HashMap sttusInfo = alotService.getRcTmprSttus(map);
		if(sttusInfo == null){
			result = "-3";
		}
		alotInfo = alotService.getRcTmprAlotNow(map);

		model.addAttribute("alotInfo", alotInfo);
		model.addAttribute("snNo", snNo);
		model.addAttribute("gbn", gbn);
		model.addAttribute("ret", ret);
		model.addAttribute("result", result);
        return "alot/alotPopup";
    }


	@RequestMapping("/alotAjax/")
	public ModelAndView alotAjax(HttpServletRequest request) throws Exception {
		Utility utl = Utility.getInstance();
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

        String snNo = SimpleUtils.default_set(request.getParameter("snNo"));
        String gbn = SimpleUtils.default_set(request.getParameter("gbn"));
		String hidUserId = SimpleUtils.default_set(request.getParameter("hidUserId"));
		String hidDeptCd = SimpleUtils.default_set(request.getParameter("hidDeptCd"));
		String chkAlotSeCd = SimpleUtils.default_set(request.getParameter("chkAlotSeCd"));

		//gbn R(접수), I(입건)
		//ret N(바로저장), Y(리턴값)
        String result = "1";

        if("A".equals(chkAlotSeCd) || "B".equals(chkAlotSeCd)){
    		try{

    	    	HashMap map = new HashMap();
    			map.put("esntl_id", esntl_id);
    			map.put("alot_dept_cd", hidDeptCd);
    			map.put("alot_user_id", hidUserId);
    			map.put("alot_se_cd", chkAlotSeCd);
    			//gbn R(접수), I(입건)
    			//ret N(바로저장), Y(리턴값)
    			HashMap alotInfo = new HashMap();

	    		map.put("rc_no", snNo);
	    		HashMap sttusInfo = alotService.getRcTmprSttus(map);
	    		if(sttusInfo == null){
	    			result = "-3";
	    		}else{
        			alotService.addRcTmprAlot(map);
	    		}

    		}catch(Exception e){
    			result = "-1";
    		}
        }else{
			result = "-2";
        }

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


    @RequestMapping(value="/historyPopup/")
    public String historyPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));

        model.addAttribute("rcNo", rcNo);
        return "alot/historyPopup";
    }

    @RequestMapping(value="/historyAjax/")
    public ModelAndView historyAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));

    	HashMap map = new HashMap();
		map.put("rc_no", rcNo);
    	List<HashMap> list = alotService.getRcTmprAlotHistory(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
    }

    /**
     * 인수인계 화면
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
	@RequestMapping (value = "/hndvrList/")
	public String hndvrList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "alot/hndvrList";
	}

	/**
	 * 인수인계 처리할  팝업
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value="/hndvrPopup/")
    public String hndvrPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	HttpSession session = request.getSession();
    	String mngr_yn = Utility.nvl(session.getAttribute("mngr_yn").toString());

        String deptCd = Utility.nvl(request.getParameter("deptCd"));
        //String deptNm = Utility.nvl(request.getParameter("deptNm"));
        String deptNm = new String(Utility.nvl(request.getParameter("deptNm")).getBytes("8859_1"), "UTF-8");
        String chargerId = Utility.nvl(request.getParameter("chargerId"));

        //System.out.println("testestste:::"+deptNm);

		model.addAttribute("deptCd", deptCd);
		model.addAttribute("deptNm", deptNm);
		model.addAttribute("chargerId", chargerId);
		model.addAttribute("mngr_yn", mngr_yn);
        return "alot/hndvrPopup";
    }

	/**
	 * 인수인계 목록조회
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hndvrListAjax/")
	public ModelAndView hndvrListAjax(HttpServletRequest request) throws Exception  {

		/*String searchTrnNo1 = SimpleUtils.default_set(request.getParameter("searchTrnNo1"));
		String searchTrnNo2 = SimpleUtils.default_set(request.getParameter("searchTrnNo2"));
		String searchTrnNo3 = SimpleUtils.default_set(request.getParameter("searchTrnNo3"));
		String searchTrgterCl = SimpleUtils.default_set(request.getParameter("searchTrgterCl"));
		String searchTrgterNm = SimpleUtils.default_set(request.getParameter("searchTrgterNm"));
		String searchTrnDe1 = SimpleUtils.default_set(request.getParameter("searchTrnDe1"));
		String searchTrnDe2 = SimpleUtils.default_set(request.getParameter("searchTrnDe2"));*/

		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));
		String searchChager = SimpleUtils.default_set(request.getParameter("searchChager"));

	    String  coldCaseYN = SimpleUtils.default_set(request.getParameter("chkColdCase"));		//미제사건 여부
	    String  stopCaseYN = SimpleUtils.default_set(request.getParameter("chkStopCase"));		//중지사건 여부

	    String  sortingFields = SimpleUtils.default_set(request.getParameter("sortingFields"));
	    
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

		/*map.put("searchTrgterCl", searchTrgterCl);
		map.put("searchTrgterNm", searchTrgterNm);
		map.put("searchTrnDeStart", searchTrnDe1);
		map.put("searchTrnDeEnd", searchTrnDe2);*/
		map.put("searchDeptCd", searchDeptCd);
		map.put("searchChager", searchChager);

		if( null != coldCaseYN && "Y".equals(coldCaseYN) ){	//미제 사건 여부
			map.put( "coldCase", "Y" );
    	}

    	if( null != stopCaseYN && "Y".equals(stopCaseYN) ){	//중지사건 여부
    		map.put( "stopCase", "Y" );
    	}

		/*if(searchTrnNo1.length() == 4){
			if(!searchTrnNo2.isEmpty() && searchTrnNo2 != null){
				map.put("searchTrnNoStart", searchTrnNo1 + "-" + String.format("%06d", Integer.parseInt(searchTrnNo2)));
			}
			if(!searchTrnNo3.isEmpty() && searchTrnNo3 != null){
				map.put("searchTrnNoEnd", searchTrnNo1 + "-" + String.format("%06d", Integer.parseInt(searchTrnNo3)));
			}
		}*/
    	
    	//sorting
    	//System.out.println("sortingFields >>>>>>>>>>>>>> "+sortingFields);
    	if(sortingFields != null && !sortingFields.equals("")) {			
    		Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
    		if(sortingField != null && sortingField.size() > 0 ) {				
    			map.put("dataField", sortingField.get("dataField"));
    			map.put("sortType", sortingField.get("sortType"));
    		}
    	}
    	
    	System.out.println("sortingFields >>>>>>>>>>>>>> " + map);

		int list_cnt = 0;
		List<HashMap> list = alotService.selectHndvrList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 인수인계 처리
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/saveHndvrAjax/")
	public ModelAndView saveHndvrAjax(HttpServletRequest request, @RequestBody HashMap param) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

    	// ★ 승인요청인 자료는 승인자료도 같이 update 처리해야함.(작성부서, 작성자ID)
        String result = "1";

        System.out.println("### 인계처리 param:"+param);

        if(!Utility.nvl(param.get("userId")).equals("") && !Utility.nvl(param.get("deptCd")).equals("")) {
    		try {
    			param.put("esntl_id", esntl_id);
    			int cnt = alotService.saveHndvr(param);
    			if(cnt < 1) {
    				result = "-1";
    			}
    		} catch(Exception e) {
    			result = "-1";
    		}
        } else {
			result = "-2";
        }

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

}
