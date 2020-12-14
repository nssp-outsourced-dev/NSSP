package kr.go.nssp.bbs.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.*;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.bbs.service.BbsService;
import kr.go.nssp.cmmn.service.FileService;
import kr.go.nssp.utl.Utility;
import kr.go.nssp.utl.egov.EgovProperties;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
@RequestMapping(value = "/bbs/")
public class BbsController {

	@Resource
    private BbsService bbsService;

	@Resource
    private FileService fileService;

    //확장자 제한
	ArrayList<String> formatList = new ArrayList<String>();

	public BbsController(){
		formatList.add("jpg");
		formatList.add("jpeg");
		formatList.add("bmp");
		formatList.add("gif");
		formatList.add("png");
		formatList.add("hwp");
		formatList.add("hwpx");
		formatList.add("pdf");
		formatList.add("xls");
		formatList.add("xlsx");
		formatList.add("zip");
	}

    @RequestMapping(value="/manageList/")
    public String manageList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        model.addAttribute("formatList", formatList);
        return "bbs/manageList";
    }

	@RequestMapping(value = "/manageListAjax/")
	public ModelAndView manageListAjax(HttpServletRequest request) throws Exception  {

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

    	HashMap map = new HashMap();
    	List<HashMap> list = bbsService.getBbsManageList(map);
		return new ModelAndView("ajaxView", "ajaxData", list);
	}

    @RequestMapping(value="/manageDetailAjax/")
    public ModelAndView manageDetailAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String bbs_id = SimpleUtils.default_set(request.getParameter("hidBbsId"));

    	HashMap map = new HashMap();
    	map.put("bbs_id", bbs_id);
    	HashMap result = bbsService.getBbsManageDetail(map);

		return new ModelAndView("ajaxView", "ajaxData", result);
    }

	@RequestMapping("/addManageAjax/")
	public ModelAndView addManageAjax(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

		String hidBbsId = SimpleUtils.default_set(request.getParameter("hidBbsId"));
		String txtBbsNm = SimpleUtils.default_set(request.getParameter("txtBbsNm"));
		String txtBbsCn = SimpleUtils.default_set(request.getParameter("txtBbsCn"));

		String selReplyYn = SimpleUtils.default_set(request.getParameter("selReplyYn"));
		String selUseYn = SimpleUtils.default_set(request.getParameter("selUseYn"));
		String selAtachFileCo = SimpleUtils.default_set(request.getParameter("selAtachFileCo"));

		String selCmntYn = SimpleUtils.default_set(request.getParameter("selCmntYn"));
		String selWritngAuthorSe = SimpleUtils.default_set(request.getParameter("selWritngAuthorSe"));
		String selInqireAuthorSe = SimpleUtils.default_set(request.getParameter("selInqireAuthorSe"));
		String selCmntWritngAuthorSe = SimpleUtils.default_set(request.getParameter("selCmntWritngAuthorSe"));
		String selCmntInqireAuthorSe = SimpleUtils.default_set(request.getParameter("selCmntInqireAuthorSe"));

        String result = "1";
		try{

	    	HashMap map = new HashMap();
			map.put("bbs_nm", txtBbsNm);
			map.put("bbs_cn", txtBbsCn);
			map.put("reply_yn", selReplyYn);
			map.put("atch_file_co", selAtachFileCo);
			map.put("cmnt_yn", selCmntYn);
			map.put("use_yn", selUseYn);
			map.put("writng_author_se", selWritngAuthorSe);
			map.put("inqire_author_se", selInqireAuthorSe);
			map.put("cmnt_writng_author_se", selCmntWritngAuthorSe);
			map.put("cmnt_inqire_author_se", selCmntInqireAuthorSe);
	    	map.put("esntl_id", esntl_id);

	        if(hidBbsId == null || hidBbsId.equals("")){
				bbsService.addBbsManage(map);
	        }else{
	    		map.put("bbs_id", hidBbsId);
	        	HashMap data = bbsService.getBbsManageDetail(map);
	        	if(data != null){
	                bbsService.updateBbsManage(map);
	        	}
	        }
		}catch(Exception e){
			result = "-1";
		}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


    @RequestMapping(value="/{bbsId}/list/")
    public String list(@PathVariable("bbsId") String bbsId, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	//bbs validation
        HashMap valid = fnBbsValidation(bbsId);
        String vResult = (String) valid.get("result");
        HashMap vOption = (HashMap) valid.get("option");
        if(!"1".equals(vResult)){
        	//마스터 사용불가
            return "error/errorPage";
        }

        model.addAttribute("bbsId", bbsId);
        model.addAttribute("option", vOption);


        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());
        model.addAttribute("esntl_id", esntl_id);
        model.addAttribute("mngr_yn", mngr_yn);

        String searchNttSj = SimpleUtils.default_set(request.getParameter("searchNttSj"));

        //현재 페이지 파라메타
        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
        int intPage = 1;
		if(!"".equals(hidPage))
			intPage = Integer.parseInt((String)hidPage);

		String pBlock = SimpleUtils.default_set(request.getParameter("pBlock"));
		if( pBlock== null || pBlock.equals("")){
			pBlock = "13";
		}
		int pageBlock = Integer.parseInt((String)pBlock);

		//페이지 기본설정
		int pageArea = 10;

    	//page
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
    	map.put("bbs_id", bbsId);
    	map.put("startRow", paginationInfo.getFirstRecordIndex());
    	map.put("endRow", paginationInfo.getLastRecordIndex());
    	map.put("esntl_id", esntl_id);
    	map.put("ntt_sj", searchNttSj);


		int list_cnt = 0;
    	List<HashMap> list = bbsService.getBbsList(map);

		if(list.size() > 0){
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
			paginationInfo.setTotalRecordCount(list_cnt);
		}


        model.addAttribute("paginationInfo", paginationInfo);

        model.addAttribute("hidPage", hidPage);
        model.addAttribute("pBlock", pBlock);
        model.addAttribute("bbsList", list);

        model.addAttribute("searchNttSj", searchNttSj);

        //비밀글 비밀번호 실패
        String othbcPwFail = SimpleUtils.default_set(request.getParameter("othbcPwFail"));
        if("Y".equals(othbcPwFail)){
            model.addAttribute("othbcPwFail", "Y");
        }else{
            model.addAttribute("othbcPwFail", "N");
        }

        return "bbs/list";
    }

    @RequestMapping(value="/{bbsId}/detail/")
    public String detail(@PathVariable("bbsId") String bbsId, HttpServletRequest request, HttpServletResponse response, ModelMap model, RedirectAttributes redirectAttr) throws Exception {

    	//bbs validation
        HashMap valid = fnBbsValidation(bbsId);
        String vResult = (String) valid.get("result");
        HashMap vOption = (HashMap) valid.get("option");
        if(!"1".equals(vResult)){
        	//마스터 사용불가
            return "error/errorPage";
        }
        model.addAttribute("bbsId", bbsId);
        model.addAttribute("option", vOption);

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());
        model.addAttribute("esntl_id", esntl_id);
        model.addAttribute("mngr_yn", mngr_yn);

        String hidBbsSn = SimpleUtils.default_set(request.getParameter("hidBbsSn"));
        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		String pBlock = SimpleUtils.default_set(request.getParameter("pBlock"));

    	//검색조건
        String searchNttSj = SimpleUtils.default_set(request.getParameter("searchNttSj"));

		HashMap map = new HashMap();
    	map.put("bbs_id", bbsId);
    	map.put("bbs_sn", hidBbsSn);
    	//조회수
    	bbsService.updateBbsInqireCo(map);

    	HashMap result = bbsService.getBbsDetail(map);
    	List<HashMap> preview = bbsService.getBbsPreview(map);

		//작성자나 관리자는 통과
		String writng_id = (String) result.get("WRITNG_ID");
		if(!"Y".equals(mngr_yn) && !esntl_id.equals(writng_id)){
			//비밀번호 체크
			String othbc_yn = (String) result.get("OTHBC_YN");
			if("N".equals(othbc_yn)){
				Utility utl = Utility.getInstance();
		        //비밀글 비밀번호
		        String hidOthbcPw = SimpleUtils.default_set(request.getParameter("hidOthbcPw"));
		        hidOthbcPw = utl.getSha256Encrypt(hidOthbcPw);
				String othbc_pw = (String) result.get("OTHBC_PW");

				if(!othbc_pw.equals(hidOthbcPw)){
		        	//권한없음
			        redirectAttr.addAttribute("bbsId", bbsId);
					redirectAttr.addAttribute("hidPage", hidPage);
					redirectAttr.addAttribute("pBlock", pBlock);
					redirectAttr.addAttribute("searchNttSj", searchNttSj);
					redirectAttr.addAttribute("othbcPwFail", "Y");
					return "redirect:/bbs/"+bbsId+"/list/";
				}
			}
		}

    	List<HashMap> cmntList = bbsService.getBbsCmntList(map);

        model.addAttribute("hidPage", hidPage);
        model.addAttribute("pBlock", pBlock);
        model.addAttribute("searchNttSj", searchNttSj);

        model.addAttribute("result", result);
        model.addAttribute("preview", preview);

        model.addAttribute("cmntList", cmntList);

        return "bbs/detail";
    }

    @RequestMapping(value="/{bbsId}/add/")
    public String add(@PathVariable("bbsId") String bbsId, HttpServletRequest request, HttpServletResponse response, ModelMap model, RedirectAttributes redirectAttr) throws Exception {

    	//bbs validation
        HashMap valid = fnBbsValidation(bbsId);
        String vResult = (String) valid.get("result");
        HashMap vOption = (HashMap) valid.get("option");
        if(!"1".equals(vResult)){
        	//마스터 사용불가
            return "error/errorPage";
        }
        model.addAttribute("bbsId", bbsId);
        model.addAttribute("option", vOption);

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());
        model.addAttribute("esntl_id", esntl_id);
        model.addAttribute("mngr_yn", mngr_yn);

        //권한체크 - 관리자만 작성
		String writng_author_se = (String) vOption.get("WRITNG_AUTHOR_SE");
		if("1".equals(writng_author_se)){
			if(!"Y".equals(mngr_yn)){
	        	//권한없음
	            return "error/errorPage";
			}
		}

        String hidAddTy = SimpleUtils.default_set(request.getParameter("hidAddTy"));
        String hidBbsSn = SimpleUtils.default_set(request.getParameter("hidBbsSn"));
        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		String pBlock = SimpleUtils.default_set(request.getParameter("pBlock"));
    	//검색조건
        String searchNttSj = SimpleUtils.default_set(request.getParameter("searchNttSj"));

    	if("R".equals(hidAddTy)){
            //권한체크 - 답변 사용여부
    		String reply_yn = (String) vOption.get("REPLY_YN");
    		if(!"Y".equals(reply_yn)){
	        	//답변 사용불가
	            return "error/errorPage";
    		}
    	}else{
			HashMap map = new HashMap();
	    	map.put("bbs_id", bbsId);
	    	map.put("bbs_sn", hidBbsSn);
	    	HashMap result = bbsService.getBbsDetail(map);
	    	if(result != null){

	    		String writng_id = (String) result.get("WRITNG_ID");
	    		//권한체크 - 관리자, 본인확인
	    		if(!"Y".equals(mngr_yn) && !writng_id.equals(esntl_id)){
	                return "error/errorPage";
	    		}

	    		String temp1 = (String) result.get("NOTICE_BEGIN_DE");
	    		if(temp1 != null && temp1.length() == 8){
	    			temp1 = temp1.substring(0, 4) + "-" + temp1.substring(4, 6) + "-" + temp1.substring(6, 8);
	    			result.put("NOTICE_BEGIN_DE", temp1);
	    		}else{
	    			result.put("NOTICE_BEGIN_DE", "");
	    		}

	    		String temp2 = (String) result.get("NOTICE_END_DE");
	    		if(temp2 != null && temp2.length() == 8){
	    			temp2 = temp2.substring(0, 4) + "-" + temp2.substring(4, 6) + "-" + temp2.substring(6, 8);
	    			result.put("NOTICE_END_DE", temp2);
	    		}else{
	    			result.put("NOTICE_END_DE", "");
	    		}
	    	}
	    	List<HashMap> fileList = fileService.getFileList(result);
	        model.addAttribute("result", result);
	        model.addAttribute("fileList", fileList);
    	}

        model.addAttribute("hidPage", hidPage);
        model.addAttribute("pBlock", pBlock);
        model.addAttribute("searchNttSj", searchNttSj);

        model.addAttribute("hidAddTy", hidAddTy);
        model.addAttribute("formatList", formatList);
        model.addAttribute("hidBbsSn", hidBbsSn);

        return "bbs/add";
    }

	@RequestMapping("/addAction/")
	public String addAction(MultipartHttpServletRequest request, RedirectAttributes redirectAttr) throws Exception {

    	//bbs validation
        String bbsId = SimpleUtils.default_set(request.getParameter("bbsId"));
        HashMap valid = fnBbsValidation(bbsId);
        String vResult = (String) valid.get("result");
        HashMap vOption = (HashMap) valid.get("option");
        if(!"1".equals(vResult)){
        	//마스터 사용불가
            return "error/errorPage";
        }
        redirectAttr.addAttribute("bbsId", bbsId);

		Utility utl = Utility.getInstance();
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());

        //권한체크 - 관리자만 작성
		String writng_author_se = (String) vOption.get("WRITNG_AUTHOR_SE");
		if("1".equals(writng_author_se)){
			if(!"Y".equals(mngr_yn)){
	        	//권한없음
	            return "error/errorPage";
			}
		}

        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		String pBlock = SimpleUtils.default_set(request.getParameter("pBlock"));
    	//검색조건
        String searchNttSj = SimpleUtils.default_set(request.getParameter("searchNttSj"));

        String hidAddTy = SimpleUtils.default_set(request.getParameter("hidAddTy"));
        String hidBbsSn = SimpleUtils.default_set(request.getParameter("hidBbsSn"));
		String txtNttSj = SimpleUtils.default_set(request.getParameter("txtNttSj"));
		String txtNttCn = SimpleUtils.default_set(request.getParameter("txtNttCn"));

        String rdoOthbcYn = SimpleUtils.default_set(request.getParameter("rdoOthbcYn"));
        String txtOthbcPw = SimpleUtils.default_set(request.getParameter("txtOthbcPw"));

        //권한체크 - 답변 사용여부
		String reply_yn = (String) vOption.get("REPLY_YN");
		if("R".equals(hidAddTy) && !"Y".equals(reply_yn)){
        	//답변 사용불가
            return "error/errorPage";
		}

		HashMap map = new HashMap();
    	map.put("bbs_id", bbsId);
		map.put("ntt_sj", txtNttSj);
		map.put("ntt_cn", txtNttCn);

		if("Y".equals(rdoOthbcYn)){
			map.put("othbc_yn", "Y");
			map.put("othbc_pw", "");
		}else{
			map.put("othbc_yn", "N");
			map.put("othbc_pw", utl.getSha256Encrypt(txtOthbcPw));
		}

		//공지설정은 관리자만
		if("Y".equals(mngr_yn)){
	        String selNoticeYn = SimpleUtils.default_set(request.getParameter("selNoticeYn"));
	        String txtNoticeBeginDe = SimpleUtils.default_set(request.getParameter("txtNoticeBeginDe"));
	        String txtNoticeEndDe = SimpleUtils.default_set(request.getParameter("txtNoticeEndDe"));
			if("Y".equals(selNoticeYn)){
				map.put("notice_yn", "Y");
				map.put("notice_begin_de", txtNoticeBeginDe);
				map.put("notice_end_de", txtNoticeEndDe);
			}else{
				map.put("notice_yn", "N");
			}
		}

    	map.put("esntl_id", esntl_id);

		String file_id = "";
        if(hidBbsSn == null || hidBbsSn.equals("")){
    		file_id = fileService.getFileID();
        	map.put("file_id", file_id);
    		bbsService.addBbs(map);
        }else{
        	if("R".equals(hidAddTy)){
        		file_id = fileService.getFileID();
            	map.put("file_id", file_id);
				map.put("parent_sn", hidBbsSn);
        		bbsService.addBbs(map);
        	}else{
            	map.put("bbs_sn", hidBbsSn);
            	HashMap result = bbsService.getBbsDetail(map);
            	if(result != null){

    	    		String writng_id = (String) result.get("WRITNG_ID");
    	    		//권한체크 - 관리자, 본인확인
    	    		if(!"Y".equals(mngr_yn) && !writng_id.equals(esntl_id)){
    	                return "error/errorPage";
    	    		}

                    file_id = SimpleUtils.default_set((String) result.get("FILE_ID"));
                    bbsService.updateBbs(map);
            	}
        	}
        }

        //권한체크 - 파일 사용여부
		int atch_file_co = Integer.parseInt(vOption.get("ATCH_FILE_CO").toString());
		if(atch_file_co > 0){
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
				fMap.put("regist_path", "게시판");
				fileService.insertFile(fMap);
			}
		}
		redirectAttr.addAttribute("hidPage", hidPage);
		redirectAttr.addAttribute("pBlock", pBlock);
		redirectAttr.addAttribute("searchNttSj", searchNttSj);

		return "redirect:/bbs/"+bbsId+"/list/";
	}

    @RequestMapping(value="/disableAction/")
    public String disableAction(HttpServletRequest request, RedirectAttributes redirectAttr) throws Exception {

    	//bbs validation
        String bbsId = SimpleUtils.default_set(request.getParameter("bbsId"));
        HashMap valid = fnBbsValidation(bbsId);
        String vResult = (String) valid.get("result");
        HashMap vOption = (HashMap) valid.get("option");
        if(!"1".equals(vResult)){
        	//마스터 사용불가
            return "error/errorPage";
        }
        redirectAttr.addAttribute("bbsId", bbsId);

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());

        //권한체크 - 관리자만 작성
		String writng_author_se = (String) vOption.get("WRITNG_AUTHOR_SE");
		if("1".equals(writng_author_se)){
			if(!"Y".equals(mngr_yn)){
	        	//권한없음
	            return "error/errorPage";
			}
		}

        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		String pBlock = SimpleUtils.default_set(request.getParameter("pBlock"));
    	//검색조건
        String searchNttSj = SimpleUtils.default_set(request.getParameter("searchNttSj"));

        String hidBbsSn = SimpleUtils.default_set(request.getParameter("hidBbsSn"));

		HashMap map = new HashMap();
    	map.put("bbs_id", bbsId);
    	map.put("bbs_sn", hidBbsSn);
		map.put("esntl_id", esntl_id);

    	HashMap result = bbsService.getBbsDetail(map);
    	if(result != null){
    		String writng_id = (String) result.get("WRITNG_ID");
    		//권한체크 - 관리자, 본인확인
    		if(!"Y".equals(mngr_yn) && !writng_id.equals(esntl_id)){
                return "error/errorPage";
    		}
        	bbsService.deleteBbs(map);
    	}

		redirectAttr.addAttribute("hidPage", hidPage);
		redirectAttr.addAttribute("pBlock", pBlock);
		redirectAttr.addAttribute("searchNttSj", searchNttSj);
		return "redirect:/bbs/"+bbsId+"/list/";
    }


	@RequestMapping(value = "/cmntListAjax/")
	public ModelAndView cmntListAjax(HttpServletRequest request) throws Exception  {
        String result = "1";
    	HashMap ret = new HashMap();

    	//bbs validation
        String bbsId = SimpleUtils.default_set(request.getParameter("bbsId"));
        HashMap valid = fnBbsValidation(bbsId);
        String vResult = (String) valid.get("result");
        HashMap vOption = (HashMap) valid.get("option");
        if(!"1".equals(vResult)){
        	//마스터 사용불가
        	result = vResult;
        }else{
            //권한체크 - 덧글가능여부
    		String cmnt_yn = (String) vOption.get("CMNT_YN");
    		if("Y".equals(cmnt_yn)){
	            String hidBbsSn = SimpleUtils.default_set(request.getParameter("hidBbsSn"));
	    		HashMap map = new HashMap();
	        	map.put("bbs_id", bbsId);
	        	map.put("bbs_sn", hidBbsSn);
	        	List<HashMap> list = bbsService.getBbsCmntList(map);
	        	ret.put("list", list);
    		}else{
    			result = "-5";
    		}
        }
    	ret.put("result", result);
		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

    @RequestMapping(value="/cmntDetailAjax/")
    public ModelAndView cmntDetailAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        String result = "1";
    	HashMap ret = new HashMap();

    	//bbs validation
        String bbsId = SimpleUtils.default_set(request.getParameter("bbsId"));
        HashMap valid = fnBbsValidation(bbsId);
        String vResult = (String) valid.get("result");
        HashMap vOption = (HashMap) valid.get("option");
        if(!"1".equals(vResult)){
        	//마스터 사용불가
        	result = vResult;
        }else{
            //권한체크 - 덧글가능여부
    		String cmnt_yn = (String) vOption.get("CMNT_YN");
    		if("Y".equals(cmnt_yn)){
                String hidBbsSn = SimpleUtils.default_set(request.getParameter("hidBbsSn"));
                String hidCmntSn = SimpleUtils.default_set(request.getParameter("hidCmntSn"));
        		HashMap map = new HashMap();
            	map.put("bbs_id", bbsId);
            	map.put("bbs_sn", hidBbsSn);
            	map.put("cmnt_sn", hidCmntSn);
            	HashMap detail = bbsService.getBbsCmntDetail(map);
            	ret.put("detail", detail);
    		}else{
    			result = "-5";
    		}
        }

    	ret.put("result", result);
		return new ModelAndView("ajaxView", "ajaxData", ret);
    }

	@RequestMapping("/cmntAddAjax/")
	public ModelAndView cmntAddAjax( HttpServletRequest request) throws Exception {
        String result = "1";

    	//bbs validation
        String bbsId = SimpleUtils.default_set(request.getParameter("bbsId"));
        HashMap valid = fnBbsValidation(bbsId);
        String vResult = (String) valid.get("result");
        HashMap vOption = (HashMap) valid.get("option");
        if(!"1".equals(vResult)){
        	//마스터 사용불가
        	result = vResult;
        }else{
			try{
	            //권한체크 - 덧글가능여부
	    		String cmnt_yn = (String) vOption.get("CMNT_YN");
	    		if("Y".equals(cmnt_yn)){
	    	        HttpSession session = request.getSession();
	    	    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
	    	        String hidBbsSn = SimpleUtils.default_set(request.getParameter("hidBbsSn"));
	    	        String hidCmntSn = SimpleUtils.default_set(request.getParameter("hidCmntSn"));
	    			String txtCmntCn = SimpleUtils.default_set(request.getParameter("txtCmntCn"));

					HashMap map = new HashMap();
			    	map.put("bbs_id", bbsId);
			    	map.put("bbs_sn", hidBbsSn);
			    	map.put("cmnt_cn", txtCmntCn);
			    	map.put("esntl_id", esntl_id);
		        	bbsService.addBbsCmnt(map);
	    		}else{
	    			result = "-5";
	    		}

			}catch(Exception e){
				result = "-1";
			}
        }

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


	@RequestMapping("/cmntUpdateAjax/")
	public ModelAndView cmntUpdateAjax( HttpServletRequest request) throws Exception {
        String result = "1";

    	//bbs validation
        String bbsId = SimpleUtils.default_set(request.getParameter("bbsId"));
        HashMap valid = fnBbsValidation(bbsId);
        String vResult = (String) valid.get("result");
        HashMap vOption = (HashMap) valid.get("option");
        if(!"1".equals(vResult)){
        	//마스터 사용불가
        	result = vResult;
        }else{

			try{
	            //권한체크 - 덧글가능여부
	    		String cmnt_yn = (String) vOption.get("CMNT_YN");
	    		if("Y".equals(cmnt_yn)){
	                HttpSession session = request.getSession();
	            	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
	            	String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());

	    	        String hidBbsSn = SimpleUtils.default_set(request.getParameter("hidBbsSn"));
	    	        String hidCmntSn = SimpleUtils.default_set(request.getParameter("hidCmntSn"));
	    			String txtUpdateCmntCn = SimpleUtils.default_set(request.getParameter("txtUpdateCmntCn"));
					HashMap map = new HashMap();
			    	map.put("bbs_id", bbsId);
			    	map.put("bbs_sn", hidBbsSn);
			    	map.put("cmnt_cn", txtUpdateCmntCn);
			    	map.put("esntl_id", esntl_id);
			    	map.put("cmnt_sn", hidCmntSn);
		        	HashMap data = bbsService.getBbsCmntDetail(map);
		        	if(data != null){
		        		String writng_id = (String) data.get("WRITNG_ID");
		        		//권한체크 - 관리자, 본인확인
		        		if(!"Y".equals(mngr_yn) && !writng_id.equals(esntl_id)){
			    			result = "-4";
		        		}else{
			        		bbsService.updateBbsCmnt(map);
		        		}
		        	}
	    		}else{
	    			result = "-5";
	    		}
			}catch(Exception e){
				result = "-1";
			}
        }

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

    @RequestMapping(value="/cmntDisableAjax/")
    public ModelAndView cmntDisableAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model, RedirectAttributes redirectAttr) throws Exception {
        String result = "1";

    	//bbs validation
        String bbsId = SimpleUtils.default_set(request.getParameter("bbsId"));
        HashMap valid = fnBbsValidation(bbsId);
        String vResult = (String) valid.get("result");
        HashMap vOption = (HashMap) valid.get("option");
        if(!"1".equals(vResult)){
        	//마스터 사용불가
        	result = vResult;
        }else{
			try{
	            //권한체크 - 덧글가능여부
	    		String cmnt_yn = (String) vOption.get("CMNT_YN");
	    		if("Y".equals(cmnt_yn)){
	                HttpSession session = request.getSession();
	            	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
	            	String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());

	    	        String hidBbsSn = SimpleUtils.default_set(request.getParameter("hidBbsSn"));
	    	        String hidCmntSn = SimpleUtils.default_set(request.getParameter("hidCmntSn"));

					HashMap map = new HashMap();
			    	map.put("bbs_id", bbsId);
			    	map.put("bbs_sn", hidBbsSn);
			    	map.put("esntl_id", esntl_id);
			    	map.put("cmnt_sn", hidCmntSn);
		        	HashMap data = bbsService.getBbsCmntDetail(map);
		        	if(data != null){
		        		String writng_id = (String) data.get("WRITNG_ID");
		        		//권한체크 - 관리자, 본인확인
		        		if(!"Y".equals(mngr_yn) && !writng_id.equals(esntl_id)){
			    			result = "-4";
		        		}else{
			        		bbsService.deleteBbsCmnt(map);
		        		}
		        	}
	    		}else{
	    			result = "-5";
	    		}
			}catch(Exception e){
				result = "-1";
			}
        }

    	HashMap ret = new HashMap();
    	ret.put("result", result);
		return new ModelAndView("ajaxView", "ajaxData", ret);
    }

    @RequestMapping(value="/othbcPwPopup/")
    public String othbcPwPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        return "bbs/othbcPwPopup";
    }



    /**
     * <pre>
     * fnBbsValidation
     * </pre>
     *
     * @desc : 게시판 마스터 검증
     * @param bbs_id
     * @return
     */
    public HashMap fnBbsValidation(String bbs_id){
    	/* result
    	 *
    	 * 1 : success
    	 * -1 : system error
    	 * -2 : bbs not found
    	 * -3 : bbs disabled
    	 * -4 : no author
    	 * -5 : comment disabled
    	 *
    	 */
    	HashMap rMap = new HashMap();
    	String result = "1";
    	HashMap data = new HashMap();
    	try{
            HashMap vMap = new HashMap();
            vMap.put("bbs_id", bbs_id);
        	data = bbsService.getBbsManageDetail(vMap);
        	if(data != null){
        		String use_yn = (String) data.get("USE_YN");
        		if(!use_yn.equals("Y")){
            		result = "-3";
        		}
        	}else{
        		result = "-2";
        	}

    	}catch(Exception ex){
    		result = "-1";
    	}
    	rMap.put("option", data);
    	rMap.put("result", result);
		return rMap;
    }




}

