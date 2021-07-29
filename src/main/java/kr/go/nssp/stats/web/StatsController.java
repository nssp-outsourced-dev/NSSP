package kr.go.nssp.stats.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.stats.service.StatsService;
import kr.go.nssp.utl.Utility;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/stats/")
public class StatsController {

	@Resource
    private StatsService statsService;

	@Resource
	private CdService cdService;


    @RequestMapping(value="/caseManageList/")
    public String caseManageList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

        return "stats/caseManageList";
    }

	@RequestMapping(value = "/caseManageListAjax/")
	public ModelAndView caseManageListAjax(HttpServletRequest request) throws Exception  {
        String searchRcNo1 = SimpleUtils.default_set(request.getParameter("searchRcNo1"));
        String searchRcNo2 = SimpleUtils.default_set(request.getParameter("searchRcNo2"));
        String searchRcNo3 = SimpleUtils.default_set(request.getParameter("searchRcNo3"));
        String searchCaseNo1 = SimpleUtils.default_set(request.getParameter("searchCaseNo1"));
        String searchCaseNo2 = SimpleUtils.default_set(request.getParameter("searchCaseNo2"));
        String searchCaseNo3 = SimpleUtils.default_set(request.getParameter("searchCaseNo3"));
        String searchTrgterCl = SimpleUtils.default_set(request.getParameter("searchTrgterCl"));
        String searchTrgterNm = SimpleUtils.default_set(request.getParameter("searchTrgterNm"));
        String searchPrsctDe1 = SimpleUtils.default_set(request.getParameter("searchPrsctDe1"));
        String searchPrsctDe2 = SimpleUtils.default_set(request.getParameter("searchPrsctDe2"));

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
		} else {
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
    	map.put("searchPrsctDeStart", searchPrsctDe1);
    	map.put("searchPrsctDeEnd", searchPrsctDe2);
    	map.put("searchDeptCd", searchDeptCd);
    	map.put("searchChager", searchChager);

        if(searchRcNo1.length() == 4){
    		if(!searchRcNo2.isEmpty() && searchRcNo2 != null){
            	map.put("searchRcNoStart", searchRcNo1 + "-" + String.format("%06d", Integer.parseInt(searchRcNo2)));
    		}
    		if(!searchRcNo3.isEmpty() && searchRcNo3 != null){
            	map.put("searchRcNoEnd", searchRcNo1 + "-" + String.format("%06d", Integer.parseInt(searchRcNo3)));
    		}
        }
        if(searchCaseNo1.length() == 4){
    		if(!searchCaseNo2.isEmpty() && searchCaseNo2 != null){
            	map.put("searchCaseNoStart", searchCaseNo1 + "-" + String.format("%06d", Integer.parseInt(searchCaseNo2)));
    		}
    		if(!searchCaseNo3.isEmpty() && searchCaseNo3 != null){
            	map.put("searchCaseNoEnd", searchCaseNo1 + "-" + String.format("%06d", Integer.parseInt(searchCaseNo3)));
    		}
        }
        
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
    	List<HashMap> list = statsService.getCaseManageList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

    	HashMap cMap = new HashMap();
    	cMap.put("list", list);
    	cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}


    @RequestMapping(value="/crimeCaseList/")
    public String crimeCaseList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

        return "stats/crimeCaseList";
    }

	@RequestMapping(value = "/crimeCaseListAjax/")
	public ModelAndView crimeCaseListAjax(HttpServletRequest request) throws Exception  {

        String searchCaseNo1 = SimpleUtils.default_set(request.getParameter("searchCaseNo1"));
        String searchCaseNo2 = SimpleUtils.default_set(request.getParameter("searchCaseNo2"));
        String searchCaseNo3 = SimpleUtils.default_set(request.getParameter("searchCaseNo3"));
        String searchTrgterCl = SimpleUtils.default_set(request.getParameter("searchTrgterCl"));
        String searchTrgterNm = SimpleUtils.default_set(request.getParameter("searchTrgterNm"));
        String searchPrsctDe1 = SimpleUtils.default_set(request.getParameter("searchPrsctDe1"));
        String searchPrsctDe2 = SimpleUtils.default_set(request.getParameter("searchPrsctDe2"));

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
		if( hidPageBlock== null || hidPageBlock.equals("") ){
			//전체조회
			hidPageBlock = "10";
	    	map.put("startRow", "");
	    	map.put("endRow", "");
		} else {
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
    	map.put("searchPrsctDeStart", searchPrsctDe1);
    	map.put("searchPrsctDeEnd", searchPrsctDe2);
    	map.put("searchDeptCd", searchDeptCd);
    	map.put("searchChager", searchChager);

        if(searchCaseNo1.length() == 4){
    		if(!searchCaseNo2.isEmpty() && searchCaseNo2 != null){
            	map.put("searchCaseNoStart", searchCaseNo1 + "-" + String.format("%06d", Integer.parseInt(searchCaseNo2)));
    		}
    		if(!searchCaseNo3.isEmpty() && searchCaseNo3 != null){
            	map.put("searchCaseNoEnd", searchCaseNo1 + "-" + String.format("%06d", Integer.parseInt(searchCaseNo3)));
    		}
        }
        
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
    	List<HashMap> list = statsService.getCrimeCaseList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

    	HashMap cMap = new HashMap();
    	cMap.put("list", list);
    	cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
	
	
	@RequestMapping(value = "/saveCrimeCaseSuspct/")
	public ModelAndView saveCrimeCaseSuspct( HttpServletRequest request, @RequestBody Map<String, Object> param ) throws Exception  {
		HttpSession session = request.getSession();
		String esntl_id = Utility.nvl(session.getAttribute("esntl_id"));
		String result = "1";

		System.out.println("###[saveCrimeCaseSuspct 피의자 검사처분 판결 정보 저장]param:"+param);

		param.put("WRITNG_ID", esntl_id);
		param.put("UPDT_ID"  , esntl_id);

		try {
			statsService.saveCrimeCaseSuspct(param);
		} catch(Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


    @RequestMapping(value="/itivCaseList/")
    public String itivCaseList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

        return "stats/itivCaseList";
    }

	@RequestMapping(value = "/itivCaseListAjax/")
	public ModelAndView itivCaseListAjax(HttpServletRequest request) throws Exception  {
        String searchRcNo1 = SimpleUtils.default_set(request.getParameter("searchRcNo1"));
        String searchRcNo2 = SimpleUtils.default_set(request.getParameter("searchRcNo2"));
        String searchRcNo3 = SimpleUtils.default_set(request.getParameter("searchRcNo3"));
        String searchCaseNo1 = SimpleUtils.default_set(request.getParameter("searchCaseNo1"));
        String searchCaseNo2 = SimpleUtils.default_set(request.getParameter("searchCaseNo2"));
        String searchCaseNo3 = SimpleUtils.default_set(request.getParameter("searchCaseNo3"));
        String searchTrgterCl = SimpleUtils.default_set(request.getParameter("searchTrgterCl"));
        String searchTrgterNm = SimpleUtils.default_set(request.getParameter("searchTrgterNm"));

        String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));
        String searchChager = SimpleUtils.default_set(request.getParameter("searchChager"));

        String searchPrsctDe1 = SimpleUtils.default_set(request.getParameter("searchPrsctDe1"));
        String searchPrsctDe2 = SimpleUtils.default_set(request.getParameter("searchPrsctDe2"));
        
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
		} else {
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
    	map.put("searchDeptCd", searchDeptCd);
    	map.put("searchChager", searchChager);
    	map.put("searchPrsctDeStart", searchPrsctDe1);
    	map.put("searchPrsctDeEnd", searchPrsctDe2);

        if( searchRcNo1.length() == 4 ){
    		if(!searchRcNo2.isEmpty() && searchRcNo2 != null){
            	map.put("searchRcNoStart", searchRcNo1 + "-" + String.format("%06d", Integer.parseInt(searchRcNo2)));
    		}
    		if(!searchRcNo3.isEmpty() && searchRcNo3 != null){
            	map.put("searchRcNoEnd", searchRcNo1 + "-" + String.format("%06d", Integer.parseInt(searchRcNo3)));
    		}
        }
        
        if( searchCaseNo1.length() == 4 ){
    		if( !searchCaseNo2.isEmpty() && searchCaseNo2 != null ){
            	map.put("searchCaseNoStart", searchCaseNo1 + "-" + String.format("%06d", Integer.parseInt(searchCaseNo2)));
    		}
    		if( !searchCaseNo3.isEmpty() && searchCaseNo3 != null ){
            	map.put("searchCaseNoEnd", searchCaseNo1 + "-" + String.format("%06d", Integer.parseInt(searchCaseNo3)));
    		}
        }
        
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
    	List<HashMap> list = statsService.getItivCaseList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

    	HashMap cMap = new HashMap();
    	cMap.put("list", list);
    	cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
	
	/** 
	 * @methodName : updateCmnderAjax
	 * @date : 2021.07.20
	 * @author : dgkim
	 * @description : 
	 * 		사건대장 > 내사사건부 개편으로 인한 지휘자 칼럼 추가 및 업데이트 기능 추가
	 * 		김지만 수사관 요청
	 * @param session
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateCmnderAjax/")
	public ModelAndView updateCmnderAjax(HttpSession session, @RequestBody Map<String, Object> param) throws Exception {
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String result = "1";
		
		try{
			List<Map<String, Object>> list = (List<Map<String, Object>>) param.get("sList");
			for(Map<String, Object> obj : list) {
				obj.put("esntl_id", esntl_id);
			}
			
			statsService.updateCmnder(list);
		}catch (Exception e) {
			result = "-1";
		}

		Map<String, String> ret = new HashMap<String, String>();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}
}