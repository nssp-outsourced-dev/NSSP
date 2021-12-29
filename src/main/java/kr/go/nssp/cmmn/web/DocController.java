package kr.go.nssp.cmmn.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.cmmn.service.FileService;
import kr.go.nssp.mber.service.MberService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/doc/")
public class DocController {

	@Resource
    private DocService docService;

	@Resource
	private CdService cdService;

	@Resource
    private FileService fileService;
	
	@Resource
	private MberService mberService;

    //확장자 제한
	ArrayList<String> formatList = new ArrayList<String>();

	public DocController(){
		formatList.add("ozr");
		formatList.add("odi");
	}

    @RequestMapping(value="/list/")
    public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		int pageBlock = 50;
        model.addAttribute("hidPageBlock", pageBlock);
        model.addAttribute("formatList", formatList);

		//서식분류
    	HashMap cMap = new HashMap();
    	cMap.put("upper_cd", "00101");
		List<HashMap> formatClList = cdService.getCdList(cMap);
		model.addAttribute("formatClList", formatClList);

        return "doc/list";
    }

	@RequestMapping(value = "/listAjax/")
	public ModelAndView listAjax(HttpServletRequest request) throws Exception  {

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

        String searchFormatNm = SimpleUtils.default_set(request.getParameter("searchFormatNm"));
        String searchFormatClCd = SimpleUtils.default_set(request.getParameter("searchFormatClCd"));

        //현재 페이지 파라메타
        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
        int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));
		if( hidPageBlock== null || hidPageBlock.equals("")){
			hidPageBlock = "10";
		}
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
    	map.put("esntl_id", esntl_id);
    	map.put("format_nm", searchFormatNm);
    	map.put("format_cl_cd", searchFormatClCd);

		int list_cnt = 0;
    	List<HashMap> list = docService.getFormatList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

    	HashMap cMap = new HashMap();
    	cMap.put("list", list);
    	cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

    @RequestMapping(value="/detailAjax/")
    public ModelAndView detailAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String format_id = SimpleUtils.default_set(request.getParameter("hidFormatId"));

    	HashMap map = new HashMap();
    	map.put("format_id", format_id);
    	HashMap result = docService.getFormatDetail(map);

		return new ModelAndView("ajaxView", "ajaxData", result);
    }

	@RequestMapping("/addAjax/")
	public ModelAndView addAjax(HttpServletRequest temp) throws Exception {
        MultipartHttpServletRequest request = (MultipartHttpServletRequest) temp;

		Utility utl = Utility.getInstance();
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

		String hidFormatId = SimpleUtils.default_set(request.getParameter("hidFormatId"));
		String selFormatClCd = SimpleUtils.default_set(request.getParameter("selFormatClCd"));
		String txtFormatNm = SimpleUtils.default_set(request.getParameter("txtFormatNm"));
		String txtFormatDc = SimpleUtils.default_set(request.getParameter("txtFormatDc"));

		String selUseYn = SimpleUtils.default_set(request.getParameter("selUseYn"));
		String selInputYn = SimpleUtils.default_set(request.getParameter("selInputYn"));

        String result = "1";
		try{

	    	HashMap map = new HashMap();
			map.put("format_nm", txtFormatNm);
			map.put("format_dc", txtFormatDc);
			map.put("format_cl_cd", selFormatClCd);

			map.put("use_yn", selUseYn);
			map.put("input_yn", selInputYn);

	    	map.put("esntl_id", esntl_id);

			String file_id = "";
	        if(hidFormatId == null || hidFormatId.equals("")){
	    		file_id = fileService.getFileID();
	        	map.put("file_id", file_id);
				docService.addFormat(map);
	        }else{
	    		map.put("format_id", hidFormatId);
	        	HashMap data = docService.getFormatDetail(map);
	        	if(data != null){
	                file_id = SimpleUtils.default_set((String) data.get("FILE_ID"));
	                docService.updateFormat(map);
	        	}
	        }

			List<MultipartFile> files = request.getFiles("txtFiles");

			//파일선별 및 업로드
			HashMap titleMap = new HashMap();
			titleMap.put("esntl_id", esntl_id);
			String fileTitle = fileService.getUserTitle(titleMap);
			HashMap fMap = utl.parseFileInfo(files, file_id, formatList, esntl_id, fileTitle);

			int fileCount = 0;

			if(SimpleUtils.isStringInteger(fMap.get("fileCount").toString())){
				fileCount = Integer.parseInt(fMap.get("fileCount").toString());
			}

			//업로드 대상 유무
			if(fileCount > 0){
				fMap.put("regist_path", "문서관리");
				fileService.insertFile(fMap);
			}
		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

    @RequestMapping(value="/disableAjax/")
    public ModelAndView disableAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model, RedirectAttributes redirectAttr) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		String hidFormatId = SimpleUtils.default_set(request.getParameter("hidFormatId"));

        String result = "1";
		try{
			HashMap map = new HashMap();
			map.put("format_id", hidFormatId);
			map.put("esntl_id", esntl_id);

			HashMap detail = docService.getFormatDetail(map);

	    	if(detail != null){
	        	docService.deleteFormat(map);
	    	}
		}catch(Exception e){
			result = "-1";
		}

		HashMap ret = new HashMap();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
    }


    @RequestMapping(value="/reportViewPopup/")
    public String reportViewPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String doc_id = SimpleUtils.default_set(request.getParameter("docId"));
        String pblicte_sn = SimpleUtils.default_set(request.getParameter("pblicteSn"));


    	HashMap map = new HashMap();
    	map.put("doc_id", doc_id);
    	map.put("pblicte_sn", pblicte_sn);
    	HashMap result = docService.getDocPblicteDetail(map);

    	String[] pList = {};
    	if(result != null){
    		if(result.get("INPUT_PARAM") != null){
    			String inputParam = (String) result.get("INPUT_PARAM");
    			pList = inputParam.split("&");
    		}
    	}

        model.addAttribute("pList", pList);
        model.addAttribute("result", result);
        model.addAttribute("doc_id", doc_id);
        model.addAttribute("pblicte_sn", pblicte_sn);

    	String ifr_id = SimpleUtils.default_set(request.getParameter("ifrId"));
        model.addAttribute("ifr_id", ifr_id);
        return "doc/reportViewPopup";
    }

    @RequestMapping(value="/reportInputPopup/")
    public String reportInputPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String doc_id = SimpleUtils.default_set(request.getParameter("docId"));
        String pblicte_sn = SimpleUtils.default_set(request.getParameter("pblicteSn"));


    	HashMap map = new HashMap();
    	map.put("doc_id", doc_id);
    	map.put("pblicte_sn", pblicte_sn);
    	HashMap result = docService.getDocPblicteDetail(map);

    	String[] pList = {};
    	if(result != null){
    		if(result.get("INPUT_PARAM") != null){
    			String inputParam = (String) result.get("INPUT_PARAM");
    			pList = inputParam.split("&");
    		}
    	}

        model.addAttribute("pList", pList);
        model.addAttribute("result", result);
        model.addAttribute("doc_id", doc_id);
        model.addAttribute("pblicte_sn", pblicte_sn);

    	String ifr_id = SimpleUtils.default_set(request.getParameter("ifrId"));
        model.addAttribute("ifr_id", ifr_id);
        return "doc/reportInputPopup";
    }



    @RequestMapping(value="/reportListIframe/")
    public String reportListIframe(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String ifr_id = SimpleUtils.default_set(request.getParameter("ifrId"));
    	String doc_id = SimpleUtils.default_set(request.getParameter("docId"));
    	String format_cl_cd = SimpleUtils.default_set(request.getParameter("formatClCd"));
    	String input_param = SimpleUtils.default_set(request.getParameter("inputParam"));

        model.addAttribute("ifr_id", ifr_id);
        model.addAttribute("doc_id", doc_id);
        model.addAttribute("format_cl_cd", format_cl_cd);
        model.addAttribute("input_param", input_param);
        model.addAttribute("owner", "N");
        return "doc/reportList";
    }

    @RequestMapping(value="/reportListOwnerIframe/")
    public String reportListOwnerIframe(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String ifr_id = SimpleUtils.default_set(request.getParameter("ifrId"));
    	String doc_id = SimpleUtils.default_set(request.getParameter("docId"));
    	String format_cl_cd = SimpleUtils.default_set(request.getParameter("formatClCd"));
    	String input_param = SimpleUtils.default_set(request.getParameter("inputParam"));
    	String file_id = SimpleUtils.default_set(request.getParameter("fileId"));

    	HashMap map = new HashMap();
    	map.put("doc_id", doc_id);
    	//본인여부
    	/*
    	HashMap rMap = docService.getDocManageDetail(map);
    	if(rMap != null){
        	String writng_id = rMap.get("WRITNG_ID").toString();
        	if(esntl_id.equals(writng_id)){
                model.addAttribute("owner", "Y");
        	}
    	}
    	*/

        model.addAttribute("ifr_id", ifr_id);
        model.addAttribute("doc_id", doc_id);
        model.addAttribute("format_cl_cd", format_cl_cd);
        model.addAttribute("input_param", input_param);
        model.addAttribute("owner", "Y");
        model.addAttribute("file_id", file_id);


    	HashMap<String, Object> qmap = new HashMap<String, Object>();
    	qmap.put("format_cl_cd", format_cl_cd);
    	List<HashMap> formatClList = docService.getFormatClList(qmap);
		/*
		 * for( int i = 0; i < formatClList.size(); i++ ){ if(
		 * formatClList.get(i).get("FORMAT_ID") !=null && (
		 * formatClList.get(i).get("FORMAT_ID").toString().equals(
		 * "00000000000000000238") ||
		 * formatClList.get(i).get("FORMAT_ID").toString().equals("00000000000000000067"
		 * )) ) { formatClList.remove(i); } }
		 */
        model.addAttribute("formatClList", formatClList);

        return "doc/reportList";
    }



	@RequestMapping(value = "/reportListAjax/")
	public ModelAndView reportListAjax(HttpServletRequest request) throws Exception  {
    	String doc_id = SimpleUtils.default_set(request.getParameter("docId"));
    	String format_cl_cd = SimpleUtils.default_set(request.getParameter("formatClCd"));

    	HashMap map = new HashMap();
    	map.put("doc_id", doc_id);
    	map.put("format_cl_cd", format_cl_cd);

    	List<HashMap> list = docService.getDocList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
	}

	@RequestMapping(value = "/reportListOwnerAjax/")
	public ModelAndView reportListOwnerAjax(HttpServletRequest request) throws Exception  {
    	String doc_id = SimpleUtils.default_set(request.getParameter("docId"));
    	String format_cl_cd = SimpleUtils.default_set(request.getParameter("formatClCd"));
    	String file_id = SimpleUtils.default_set(request.getParameter("fileId"));

    	HashMap map = new HashMap();
    	map.put("doc_id", doc_id);
    	map.put("format_cl_cd", format_cl_cd);
    	map.put("file_id", file_id);

    	List<HashMap> list = docService.getDocOwnerList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
	}

    /**
     * 리포트 생성 처리
     * 중요!!! - DOC_ID는 각 업무에서 바로 생성해서 저장(docService.getDocID())
     *
     * @desc : reportAddAction
     * @param request
     * @param response
     * @param redirectAttr
     * @return
     * @throws Exception
     */
	@RequestMapping("/reportAddAjax/")
	public ModelAndView reportAddAjax(HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttr) throws Exception {

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		String docId = SimpleUtils.default_set(request.getParameter("docId"));
		String formatId = SimpleUtils.default_set(request.getParameter("formatId"));
		String formatClCd = SimpleUtils.default_set(request.getParameter("formatClCd"));
		String inputParam = SimpleUtils.default_set(request.getParameter("inputParam"));
		String inputJson = SimpleUtils.default_set(request.getParameter("inputJson"));

		// 통계원표
		String trnNo = Utility.nvl(request.getParameter("trnNo"));
		String rcNo = Utility.nvl(request.getParameter("rcNo"));
		String trgterSn = Utility.nvl(request.getParameter("trgterSn"));

        String result = "1";
        String input_yn = "N";
        int pblicte_sn = 0;

		try{
			//서식정보 확인
	    	HashMap vMap = new HashMap();
	    	vMap.put("format_id", formatId);
			HashMap data = docService.getFormatDetail(vMap);
			if(data.get("INPUT_YN") != null){
				input_yn = (String) data.get("INPUT_YN");
			}

	    	//마스터 존재여부 확인
	    	vMap.put("doc_id", docId);
	    	HashMap valid1 = docService.getDocManageDetail(vMap);

	    	//마스터 생성
	    	if(valid1 == null){
	        	//docId = docService.getDocID();
	        	vMap.put("doc_id", docId);
	        	vMap.put("regist_path", "생성테스트");
	        	vMap.put("dept_cd", dept_cd);
	        	vMap.put("esntl_id", esntl_id);
				docService.addDocManage(vMap);
	    	}

	    	HashMap map = new HashMap();
			map.put("doc_id", docId);
			map.put("format_id", formatId);
			map.put("input_param", inputParam);
			map.put("input_json", inputJson);

			// 통계원표
			if(!trnNo.equals("")) {
				map.put("TRN_NO", trnNo);
				map.put("RC_NO", rcNo);
				map.put("TRGTER_SN", trgterSn);
			}

	    	map.put("esntl_id", esntl_id);
			pblicte_sn = docService.addDocPblicte(map);

			//수배해제 요구서의 경우 copy
			if(formatId != null && formatId.equals("00000000000000000258")) {
				HashMap cmap = new HashMap();
				cmap.put("doc_id", docId);
				cmap.put("format_id", formatId);
				cmap.put("pblicte_sn", pblicte_sn);
				cmap.put("esntl_id", esntl_id);
				cmap.put("copy_path_format", "00000000000000000179");
				docService.updateDocFilePath(cmap);
			}

		}catch(Exception e){
			result = "-1";
		}


    	HashMap ret = new HashMap();
    	ret.put("result", result);
    	ret.put("doc_id", docId);
    	ret.put("pblicte_sn", pblicte_sn);
    	ret.put("input_yn", input_yn);
		return new ModelAndView("ajaxView", "ajaxData", ret);

	}


	@RequestMapping("/reportUpdateAjax/")
	public ModelAndView reportUpdateAjax(HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttr) throws Exception {

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		String docId = SimpleUtils.default_set(request.getParameter("docId"));
        String pblicte_sn = SimpleUtils.default_set(request.getParameter("pblicteSn"));
		String inputJson = SimpleUtils.default_set(request.getParameter("inputJson"));

        String result = "1";
    	//동일문서 존재여부 확인
    	HashMap map = new HashMap();
    	map.put("doc_id", docId);
    	map.put("pblicte_sn", pblicte_sn);
    	HashMap valid = docService.getDocPblicteDetail(map);

    	if(valid != null){
    		map.put("input_json", inputJson);
        	map.put("esntl_id", esntl_id);
			docService.updateDocPblicte(map);
    	}else{
        	result = "-1";
    	}
    	HashMap ret = new HashMap();
    	ret.put("result", result);
    	ret.put("doc_id", docId);
    	ret.put("pblicte_sn", pblicte_sn);
		return new ModelAndView("ajaxView", "ajaxData", ret);

	}

	@RequestMapping("/reportDelAjax/")
    public ModelAndView reportDelAjax(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

    	String doc_id = SimpleUtils.default_set(request.getParameter("docId"));
    	String pblicte_sn = SimpleUtils.default_set(request.getParameter("pblicteSn"));
        String result = "1";

    	HashMap map = new HashMap();
    	map.put("doc_id", doc_id);
    	map.put("pblicte_sn", pblicte_sn);
    	map.put("esntl_id", esntl_id);
    	HashMap rMap = docService.getDocPblicteDetail(map);
    	if(rMap != null){
        	docService.deleteDocPblicte(map);
    	}else{
        	result = "-1";
    	}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
    }

    @RequestMapping(value="/reportJson/")
    public ModelAndView reportJson(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	String doc_id = SimpleUtils.default_set(request.getParameter("docId"));
    	String pblicte_sn = SimpleUtils.default_set(request.getParameter("pblicteSn"));

    	HashMap map = new HashMap();
    	map.put("doc_id", doc_id);
    	map.put("pblicte_sn", pblicte_sn);
    	HashMap rMap = docService.getDocPblicteDetail(map);
    	String result = "{}";
    	if(rMap != null){
        	if(rMap.get("INPUT_JSON") != null){
        		result = (String) rMap.get("INPUT_JSON");
        	}
    	}
		return new ModelAndView("StringView", "stringData", result);
    }


    @RequestMapping(value="/inqireList/")
    public String inqireList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "doc/inqireList";
    }

	@RequestMapping(value = "/inqireListAjax/")
	public ModelAndView inqireListAjax(HttpServletRequest request) throws Exception  {
    	HashMap map = new HashMap();
    	List<HashMap> list = docService.getFormatInqireList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
	}


    @RequestMapping(value="/reportPreviewPopup/")
    public String reportPreviewPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String format_id = SimpleUtils.default_set(request.getParameter("formatId"));
        model.addAttribute("format_id", format_id);
        return "doc/reportPreviewPopup";
    }

    @RequestMapping(value="/sample/")
    public String sample(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		Utility utl = Utility.getInstance();
        return "doc/sample";
    }





    @RequestMapping(value="/reportCaseListPopup/")
    public String reportCaseListPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));
        model.addAttribute("rcNo", rcNo);
        return "doc/reportCaseListPopup";
    }

    @RequestMapping(value="/reportCaseListAjax/")
    public ModelAndView reportCaseListAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));

        HashMap map = new HashMap();
		map.put("rc_no", rcNo);
    	List<HashMap> list = docService.getCaseDocAllList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
    }

    @RequestMapping(value="/docFilePopup/")
    public String docFileList (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	String format_cl_cd = Utility.nvl(request.getParameter("pDocNo"));
    	String file_id = Utility.nvl(request.getParameter("pFileId"));
    	String format_Id = Utility.nvl(request.getParameter("pFormatId")); 
    	
    	//서식분류
    	HashMap qmap = new HashMap();
    	qmap.put("format_cl_cd", format_cl_cd);
    	List<HashMap> formatClList = docService.getFormatClList(qmap);
        model.addAttribute("formatClList", 	formatClList);
        model.addAttribute("format_cl_cd", 	format_cl_cd);
        model.addAttribute("file_id", 		file_id);
        model.addAttribute("format_Id", 	format_Id);

        return "doc/docFilePopup";
    }

    @RequestMapping("/uploadFile/")
	public String uploadFile(MultipartHttpServletRequest request, @RequestParam Map<String, Object> param, ModelMap model) throws Exception {
    	Utility utl = Utility.getInstance();
		HttpSession session = request.getSession();
	    String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		param.put("esntl_id", esntl_id);

		//권한체크 - 파일 사용여부
		List<MultipartFile> files = request.getFiles("txtFiles");

		String format_cl_cd = Utility.nvl(request.getParameter("hidFormatClCd"));
		String format_Id = Utility.nvl(request.getParameter("hidFormatId"));
		String file_id = Utility.nvl(request.getParameter("hidFileId"));
		if(file_id == null || file_id.trim().equals("")) {
			file_id = fileService.getFileID();
		}

		//파일선별 및 업로드
		HashMap titleMap = new HashMap();
		titleMap.put("esntl_id", param.get("esntl_id"));
		String fileTitle = fileService.getUserTitle(titleMap);

		//업로드 허용 확장자
		ArrayList<String> fileFormatList = new ArrayList<String>();
		fileFormatList.add("hwp");
		fileFormatList.add("pdf");
		fileFormatList.add("xls");
		fileFormatList.add("doc");
		fileFormatList.add("ppt");
		fileFormatList.add("txt");
		fileFormatList.add("jpg");
		fileFormatList.add("png");
		fileFormatList.add("gif");
		fileFormatList.add("xlsx");

		HashMap fMap = utl.parseFileInfo(files, file_id, fileFormatList, esntl_id, fileTitle);

		int fileCount = 0;
		if(SimpleUtils.isStringInteger(fMap.get("fileCount").toString())){
			fileCount = Integer.parseInt(fMap.get("fileCount").toString());
		}
		//업로드 대상 유무
		if(fileCount > 0){
			fMap.put("regist_path", format_cl_cd);
			fMap.put("format_id", format_Id);
			fileService.insertFile(fMap);
		}

		return "redirect:/doc/docFilePopup/?pDocNo="+format_cl_cd+"&pFileId="+file_id;
	}

    /**
	 * 사건번호 당 대상자 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/docFileListAjax/")
	@ResponseBody
	public List<HashMap> docFileList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = docService.selectDocFileList(map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}

	@RequestMapping(value="/hwpctrlPopup/")
    public String reportHwpPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String returnStr = "doc/hwpctrlPopup";
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	
		HashMap userParamMap = new HashMap();
		userParamMap.put("esntl_id", esntl_id);
		
    	HashMap data = mberService.userInfo(userParamMap);
    	
    	String characterTable = "";
    	String[] array_word = null; 
    	
    	if(data.get("CHARACTER_TABLE") !=null ) {
    		
    		characterTable = data.get("CHARACTER_TABLE").toString();
    		
    		//배열에 한글자씩 저장하기
    		System.out.println("특수문자 불러오기::::"+characterTable);
    		array_word = characterTable.split(""); 
    		
    		for(int i=0;i<array_word.length;i++) { 
    			System.out.println(array_word[i]);
    		}
    	}
    	    
		try {			
	        String doc_id = SimpleUtils.default_set(request.getParameter("docId"));
	        String pblicte_sn = SimpleUtils.default_set(request.getParameter("pblicteSn"));
	        String ifrId = SimpleUtils.default_set(request.getParameter("ifrId"));
	        String docType = SimpleUtils.default_set(request.getParameter("doc_type"));

	        HashMap map = new HashMap();
	    	map.put("doc_id", doc_id);
	    	map.put("pblicte_sn", pblicte_sn);

	    	HashMap rMap = docService.getDocPblicteDetail(map);

	    	if(rMap.get("FORMAT_TYPE") != null) {
				if (rMap.get("FORMAT_TYPE").toString().equals("E")) {
					if(rMap.get("FORMAT_ID") != null) {
						returnStr = "doc/hwpF"+rMap.get("FORMAT_ID").toString().substring(rMap.get("FORMAT_ID").toString().length()-4);
					}
				} else if (rMap.get("FORMAT_TYPE").toString().equals("D")) {  //의견서, 범죄인지보고서등과 동일한 양식일 경우
					returnStr = "doc/hwpFmD";
				} else if (rMap.get("FORMAT_TYPE").toString().equals("T")) {  //피의자1명 이상일 경우 피의자 목록 별지 출력
					returnStr = "doc/hwpFmT";
				}
	    	}
	    	
	    	model.addAttribute("fileNm", Utility.nvl(rMap.get("FORMAT_NM")));
	    	model.addAttribute("prDocId", doc_id);
	    	model.addAttribute("prPblicteSn", pblicte_sn);
	    	model.addAttribute("prQuryCo", Utility.nvl(rMap.get("QURY_CO"), "1"));
	    	model.addAttribute("ifr_id", ifrId);
	    	model.addAttribute("characterTable", characterTable);
	    	model.addAttribute("arrayWord", array_word);

	    	if(null != docType && "R".equals(docType)) {
	    		model.addAttribute("prDocType", docType);
	    	}    	
	    	//
	    	model.addAttribute("docHist", docService.selectDocHistList(map));
	    	//
	    	/*System.out.println("fileNm >>> "+Utility.nvl(rMap.get("FORMAT_NM")));
	    	System.out.println("prDocId >>> "+doc_id);
	    	System.out.println("prPblicteSn >>> "+pblicte_sn);
	    	System.out.println("prQuryCo >>> "+Utility.nvl(rMap.get("QURY_CO"), "1"));
	    	System.out.println("ifr_id >>> "+ifrId);*/
		} catch (Exception e) {
			System.out.println("Exception Exception Exception");
			e.printStackTrace();
		}
        return returnStr;
    }

	/**
	 * 한글서식정보 Preview
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/hwpctrlPreviewPopup/")
    public String reportHwpPopupPreview(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        model.addAttribute("formatId", SimpleUtils.default_set(request.getParameter("formatId")));

        return "doc/hwpctrlPreviewPopup";
    }


	/**
	 *  한글서식정보 PreviewAjax
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/selectHwpctrlPreviewAjax/")
	@ResponseBody
    public ModelAndView selectHwpctrlPreviewAjax (HttpServletRequest request) throws Exception {
		String formatId = SimpleUtils.default_set(request.getParameter("formatId"));
		//docId가 있으면
    	HashMap cMap = new HashMap<>();
    	String strBasePath = Utility.HWP_FILE_PATH;

    	String formatNm = docService.getFormatNm(formatId);

    	cMap.put("fileNm", formatNm);
		cMap.put("prInputYn","N");
		cMap.put("prFileNm", "");
		cMap.put("prFilePath", strBasePath + "default/"+formatId+".hwp");

	    return new ModelAndView("ajaxView", "ajaxData", cMap);
    }



	@RequestMapping(value="/hwpctrlIframe/")
    public String hwpctrlframe(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String format_id = SimpleUtils.default_set(request.getParameter("formatId"));
        model.addAttribute("format_id", format_id);
        return "doc/hwpctrlIframe";
    }

	@RequestMapping(value="/hwpctrlmainIframe/")
    public String hwpctrlmain(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		String format_id = SimpleUtils.default_set(request.getParameter("formatId"));
        model.addAttribute("format_id", format_id);
        return "doc/hwpctrlmain";
    }


	/**
	 * 한글 정보 저장
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value="/saveHwpctrlAjax/")
	@ResponseBody
    public ModelAndView saveHwpctrl (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
    	HashMap map = commonUtil.getParameterMapConvert(request);
        map.put("esntl_id", esntl_id);
    	map.put("dept_cd", dept_cd);
    	int value = docService.updateHwpctrlInfo (map);
    	HashMap cMap = new HashMap();
    	cMap.put("rst", value);
        return new ModelAndView("ajaxView", "ajaxData", cMap);
    }

	/**
	 * 한글 서식 정보
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value="/selectHwpctrlAjax/")
	@ResponseBody
    public ModelAndView selectHwpctrl (HttpServletRequest request) throws Exception {
		String     doc_id = SimpleUtils.default_set(request.getParameter("prDocId"));
        String pblicte_sn = SimpleUtils.default_set(request.getParameter("prPblicteSn"));

        HashMap map = new HashMap();
    	map.put("doc_id", doc_id);
    	map.put("pblicte_sn", pblicte_sn);

    	HashMap rMap = docService.getDocPblicteDetail(map);

    	HashMap cMap = new HashMap();
    	if(rMap != null) {
    		String prFileNm = "";
        	String strBasePath = Utility.HWP_FILE_PATH;
    		if(rMap.get("FILE_NM") != null && !rMap.get("FILE_NM").toString().equals("")){
    			prFileNm = (String) rMap.get("FILE_NM");
    			cMap.put("prInputYn", "Y");
    			cMap.put("prFileNm", prFileNm);
    			cMap.put("prFilePath", strBasePath + (rMap.get("FILE_PATH")==null?"":(String) rMap.get("FILE_PATH")));
    		} else {
    			if(rMap.get("INPUT_PARAM") != null){
    				String inputParam = (String) rMap.get("INPUT_PARAM");
        			String[] pList = inputParam.split("&");
        			for(String s : pList) {
        				String[] sList = s.split("=");
        				if(sList != null && sList.length == 2) {
        					rMap.put(sList[0], sList[1]);
        				}
        			}
        			if(rMap.get("FORMAT_TYPE") != null) {
	        			if (rMap.get("FORMAT_TYPE").toString().equals("B")) {  			//list
	        				List<HashMap> dList = docService.getHwpctrlList (rMap);
	        				cMap.put("strInputParam", dList);
	        				cMap.put("prList","Y");
	        			} else if (rMap.get("FORMAT_TYPE").toString().equals("A")) {	//map
	        				HashMap<String, Object> dMap = docService.getHwpctrlDetail (rMap);
	        				cMap.put("strInputParam", dMap);
	        				cMap.put("prList","N");
	        			} else if (rMap.get("FORMAT_TYPE").toString().equals("E") && rMap.get("QURY_CO").toString().equals("1")) { // FORMAT_TYPE = 'E' - list 1개
	        				List<HashMap> dList = docService.getHwpctrlList (rMap);
	        				cMap.put("strInputParam", dList);
	        				cMap.put("prList","Y");
	        			}
        			}


        		}
    			cMap.put("prInputYn","N");
    			cMap.put("prFileNm", "");
    			cMap.put("prFilePath", strBasePath + "default/" + (rMap.get("VW_FORMAT_ID")==null?"":(String) rMap.get("VW_FORMAT_ID"))+".hwp");
    		}
    		//owner, 작성자 또는 관리자 권한 적용
    		HttpSession session = request.getSession();
    	    String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	    String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());
    	    String strUpId = rMap.get("UPDT_ID")==null?(rMap.get("WRITNG_ID")==null?"":(String) rMap.get("WRITNG_ID")):(String) rMap.get("UPDT_ID");

    	    String strOwner = "N";
    	    String docType  = "R";

    	    if(esntl_id.equals(strUpId)) {
    	    	strOwner = "Y";
    	    	 docType = "W";
    	    } else if (mngr_yn.equals("Y")) {
    	    	strOwner = "Y";
    	    	 docType = "W";
    	    }

    	    cMap.put("owner",strOwner);
    	    cMap.put("docType",docType);
    	}
         return new ModelAndView("ajaxView", "ajaxData", cMap);
    }


	/**
	 * 한글 서식 정보 (쿼리 여러개)
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value="/selectHwpctrlMultiAjax/")
	@ResponseBody
    public ModelAndView selectHwpctrlMulti (HttpServletRequest request) throws Exception {
		String doc_id = SimpleUtils.default_set(request.getParameter("prDocId"));
        String pblicte_sn = SimpleUtils.default_set(request.getParameter("prPblicteSn"));
        int qury_co = Integer.parseInt(Utility.nvl(request.getParameter("prQuryCo")));
        HashMap map = new HashMap();
    	map.put("doc_id", doc_id);
    	map.put("pblicte_sn", pblicte_sn);
    	HashMap rMap = docService.getDocPblicteDetail(map);
    	HashMap cMap = new HashMap();
    	if( rMap != null ) {    		
    		try {
    			String strBasePath = Utility.HWP_FILE_PATH;
        		if( rMap.get("FILE_NM") != null && !rMap.get("FILE_NM").toString().equals("") ) {
        			String prFileNm = (String) rMap.get("FILE_NM");
        			cMap.put("prInputYn", "Y");
        			cMap.put("prFileNm", prFileNm);
        			cMap.put("prFilePath", strBasePath + (rMap.get("FILE_PATH")==null?"":(String) rMap.get("FILE_PATH")));
        		} else {          			
        			String strFormatId = rMap.get("FORMAT_ID")==null?"":rMap.get("FORMAT_ID").toString();
        			String strVwFormatId = rMap.get("VW_FORMAT_ID")==null?"":(String) rMap.get("VW_FORMAT_ID");
        			
        			HashMap<String, Object> dMap = new HashMap<String, Object>();
            		for(int i=0; i<qury_co; i++) {
            			if(!strFormatId.equals("")) {
            				if(rMap.get("INPUT_PARAM") != null) {
            					String inputParam = (String) rMap.get("INPUT_PARAM");
                    			String[] pList = inputParam.split("&");
                    			for(String s : pList) {
                    				String[] sList = s.split("=");
                    				if(sList != null && sList.length == 2) {
                    					rMap.put(sList[0], sList[1]);
                    				}
                    			}
                    			rMap.put("FORMAT_ID", strFormatId + "_" + (i+1));
        		    			if(i==0) {
        		    				dMap = docService.getHwpctrlDetail (rMap);
        		    				cMap.put("strInputParam"+(i+1), dMap);
        		    				cMap.put("prList"+(i+1),"N");
        		    			} else {
        		    				List<HashMap> dList = docService.getHwpctrlList (rMap);
        		    				cMap.put("strInputParam"+(i+1), dList);
        		    				cMap.put("prList"+(i+1),"Y");
        		    			}
            				}
            			}
            		}
            		
            		/*43 예외처리 [긴급, 계좌]*/
            		if(dMap != null) {
            			String strZrlongTypeCd = dMap.get("SZURE_ZRLONG_CD")==null?"":(String) dMap.get("SZURE_ZRLONG_CD");
                		if(strZrlongTypeCd.equals("00791")) strVwFormatId += "_A";
                		else if (strZrlongTypeCd.equals("00792")) strVwFormatId += "_B";
            		}            		

            		cMap.put("prInputYn","N");
            		cMap.put("prFileNm", "");
            		cMap.put("prFilePath", strBasePath + "default/" + strVwFormatId +".hwp");
        		}
    		} catch (Exception e) {
    			System.out.println("Exception 확인");
				e.printStackTrace();				
			} 

    		//owner, 작성자 또는 관리자 권한 적용
    		HttpSession session = request.getSession();
    	    String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	    String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());
    	    String strUpId = rMap.get("UPDT_ID")==null?(rMap.get("WRITNG_ID")==null?"":(String) rMap.get("WRITNG_ID")):(String) rMap.get("UPDT_ID");
    	    String strOwner = "N";
    	    String  docType = "R";

    	    //docType - W:Write / R:Read
    	    if(esntl_id.equals(strUpId)) {
    	    	strOwner = "Y";
    	    	 docType = "W";
    	    } else if (mngr_yn.equals("Y")) {
    	    	strOwner = "Y";
    	    	 docType = "W";
    	    }

    	    cMap.put("owner",strOwner);
    	    cMap.put("docType",docType);
    	} else {
    		cMap.put("prInputYn",	"N");
    		cMap.put("prFileNm", 	"");
    		cMap.put("prFilePath", 	"");
    	}
    	
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
	
	
	/** 
	 * @methodName : selectDocHistListAjax
	 * @date : 2021.11.17
	 * @author : dgkim
	 * @description : 
	 * @param request
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/selectDocHistListAjax/")
	public @ResponseBody ModelAndView selectDocHistListAjax(HttpServletRequest request, HttpSession session) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		//String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		HashMap map = commonUtil.getParameterMapConvert(request);
		map.put("esntl_id", esntl_id);
		//map.put("dept_cd", dept_cd);
		List<HashMap> result = docService.selectDocHistList(map);
		//HashMap cMap = new HashMap();
		//cMap.put("rst", value);
		return new ModelAndView("ajaxView", "ajaxData", result);
	}
}

