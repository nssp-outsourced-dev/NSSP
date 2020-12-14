package kr.go.nssp.stats.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.stats.service.InvstsService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/invsts/")
public class InvstsController {

	@Resource
	private CdService cdService;

	@Resource
	private InvstsService invstsService;


	@RequestMapping(value="/zrlongList/")
	public String zrlongList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "stats/zrlongList";
	}

	/**
	 * 체포영장신청부
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/zrlongListAjax/")
	public ModelAndView zrlongListAjax (HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap map = commonUtil.getParameterMapConvert(request);

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))	intPage = Integer.parseInt((String)hidPage);
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
		
		String sortingFields = (String) map.get("fields");		
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}
		
		int list_cnt = 0;
		List<HashMap> list = invstsService.selectStsZrlongList(map);
		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			list = commonUtil.getConvertUnderscoreNameGrid(list);
		}
		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 구속영장신청부
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/zrlongSlist/")
	public String zrlongSlist(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "stats/zrlongSlist";
	}

	/**
	 * 구속영장신청부
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/zrlongSlistAjax/")
	public ModelAndView zrlongSlistAjax (HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap map = commonUtil.getParameterMapConvert(request);

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))	intPage = Integer.parseInt((String)hidPage);
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
		int list_cnt = 0;
		List<HashMap> list = invstsService.selectStsZrlongList(map);
		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			list = commonUtil.getConvertUnderscoreNameGrid(list);
		}
		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 긴급체포원부
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/arrstList/")
	public String arrstList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "stats/arrstList";
	}

	/**
	 * 긴급체포원부
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/arrstListAjax/")
	public ModelAndView arrstListAjax (HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap map = commonUtil.getParameterMapConvert(request);

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))	intPage = Integer.parseInt((String)hidPage);
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
		
		String sortingFields = (String) map.get("fields");		
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}
		
		int list_cnt = 0;
		List<HashMap> list = invstsService.selectStsArrstList(map);
		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			list = commonUtil.getConvertUnderscoreNameGrid(list);
		}
		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 현행범인체포원부
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/arrstTlist/")
	public String arrstTlist(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "stats/arrstTlist";
	}

	/**
	 * 현행범인체포원부
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/arrstTlistAjax/")
	public ModelAndView arrstTlistAjax (HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap map = commonUtil.getParameterMapConvert(request);

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))	intPage = Integer.parseInt((String)hidPage);
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
		
		String sortingFields = (String) map.get("fields");		
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}
		
		int list_cnt = 0;
		List<HashMap> list = invstsService.selectStsArrstList(map);
		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			list = commonUtil.getConvertUnderscoreNameGrid(list);
		}
		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 체포구속영장원부
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/zrlongTlist/")
	public String zrlongTlist(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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
		cMap.put("upper_cd", "00772");
		List<HashMap> zrlongSeList = cdService.getCdList(cMap);
		model.addAttribute("zrlongSeList", zrlongSeList);

		return "stats/zrlongTlist";
	}

	/**
	 * 체포구속영장원부
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/zrlongTlistAjax/")
	public ModelAndView zrlongTlistAjax (HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap map = commonUtil.getParameterMapConvert(request);

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))	intPage = Integer.parseInt((String)hidPage);
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
		
		String sortingFields = (String) map.get("fields");		
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}
		
		int list_cnt = 0;
		List<HashMap> list = invstsService.selectStsZrlongList(map);
		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			list = commonUtil.getConvertUnderscoreNameGrid(list);
		}
		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
	/**
	 * 압수수색검증영장신청부
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/szureList/")
	public String szureList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "stats/szureList";
	}

	/**
	 * 체포구속영장원부
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/szureListAjax/")
	public ModelAndView szureListAjax (HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap map = commonUtil.getParameterMapConvert(request);

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))	intPage = Integer.parseInt((String)hidPage);
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
		
		String sortingFields = (String) map.get("fields");	
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}
		
		int list_cnt = 0;
		List<HashMap> list = invstsService.selectStsSzureList(map);
		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			list = commonUtil.getConvertUnderscoreNameGrid(list);
		}
		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 출석요구통지부
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/atendList/")
	public String atendList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "stats/atendList";
	}

	/**
	 * 출석요구통지부
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/atendListAjax/")
	public ModelAndView atendListAjax (HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap map = commonUtil.getParameterMapConvert(request);

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))	intPage = Integer.parseInt((String)hidPage);
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
		
		String sortingFields = (String) map.get("fields");		
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}
		
		int list_cnt = 0;
		List<HashMap> list = invstsService.selectStsAtendList(map);
		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			list = commonUtil.getConvertUnderscoreNameGrid(list);
		}
		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 압수부 화면
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/ccdrcList/")
	public String ccdrcList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "stats/ccdrcList";
	}

	/**
	 * 압수부 목록 조회
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ccdrcListAjax/")
	public ModelAndView ccdrcListAjax(HttpServletRequest request) throws Exception  {

		String searchCaseNo1 = SimpleUtils.default_set(request.getParameter("searchCaseNo1"));
		String searchCaseNo2 = SimpleUtils.default_set(request.getParameter("searchCaseNo2"));
		String searchCaseNo3 = SimpleUtils.default_set(request.getParameter("searchCaseNo3"));
		String searchTrgterCl = SimpleUtils.default_set(request.getParameter("searchTrgterCl"));
		String searchTrgterNm = SimpleUtils.default_set(request.getParameter("searchTrgterNm"));
		String searchDe1 = SimpleUtils.default_set(request.getParameter("searchDe1"));
		String searchDe2 = SimpleUtils.default_set(request.getParameter("searchDe2"));

		String searchDeptCd = SimpleUtils.default_set(request.getParameter("searchDeptCd"));
		String searchChager = SimpleUtils.default_set(request.getParameter("searchChager"));
		
		String sortingFields = SimpleUtils.default_set(request.getParameter("sortingFields"));

		String chkYn = SimpleUtils.default_set(request.getParameter("chkYn"));
		System.out.println("chkYn : "+request.getParameter("chkYn"));
		System.out.println("chkYn2: "+chkYn);

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
		map.put("chkYn", chkYn);

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
		List<HashMap> list = invstsService.selectStsCcdrcList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 출석요구통지부
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/sugestList/")
	public String sugestList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "stats/sugestList";
	}

	/**
	 * 지휘건의부
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/sugestListAjax/")
	public ModelAndView sugestListAjax(HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap map = commonUtil.getParameterMapConvert(request);

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))	intPage = Integer.parseInt((String)hidPage);
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
		
		String sortingFields = (String) map.get("fields");	
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}
		
		int list_cnt = 0;
		List<HashMap> list = invstsService.selectStsSugestList(map);
		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			list = commonUtil.getConvertUnderscoreNameGrid(list);
		}
		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 피의자소재발견처리부
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/stprscList/")
	public String stprscList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "stats/stprscList";
	}

	/**
	 * 피의자소재발견처리부 목록 조회
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/stprscListAjax/")
	public ModelAndView stprscListAjax(HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap map = commonUtil.getParameterMapConvert(request);

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))	intPage = Integer.parseInt((String)hidPage);
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
		
		String sortingFields = (String) map.get("fields");		
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}
		
		int list_cnt = 0;
		List<HashMap> list = invstsService.selectStprscList(map);
		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			list = commonUtil.getConvertUnderscoreNameGrid(list);
		}
		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 참고인소재발견처리부
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/refeList/")
	public String refeList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "stats/refeList";
	}

	/**
	 * 참고인소재발견처리부 목록 조회
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/refeListAjax/")
	public ModelAndView refeListAjax(HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap map = commonUtil.getParameterMapConvert(request);

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))	intPage = Integer.parseInt((String)hidPage);
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
		
		String sortingFields = (String) map.get("fields");	
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}
		
		int list_cnt = 0;
		List<HashMap> list = invstsService.selectRefeList(map);
		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			list = commonUtil.getConvertUnderscoreNameGrid(list);
		}
		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
	/**
	 * 영상녹화물 관리 대장
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/vdoRecList/")
	public String vdoRecList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
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

		return "stats/vdoRecList";
	}

	/**
	 * 영상녹화물 관리 대장 목록 조회
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/vdoRecListAjax/")
	public ModelAndView vdoRecListAjax(HttpServletRequest request) throws Exception  {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		InvUtil commonUtil = InvUtil.getInstance();
		HashMap map = commonUtil.getParameterMapConvert(request);

		//현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if(!"".equals(hidPage))	intPage = Integer.parseInt((String)hidPage);
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
		
		String sortingFields = (String) map.get("fields");	
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				map.put("dataField", sortingField.get("dataField"));
				map.put("sortType", sortingField.get("sortType"));
			}
		}
		
		int list_cnt = 0;
		List<HashMap> list = invstsService.selectVidoTrplant(map);
		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			list = commonUtil.getConvertUnderscoreNameGrid(list);
		}
		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
}

