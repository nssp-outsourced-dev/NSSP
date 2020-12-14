package kr.go.nssp.rc.web;


import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.alot.service.AlotService;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.cmmn.service.DeptService;
import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.cmmn.service.ExmnService;
import kr.go.nssp.cmmn.service.FileService;
import kr.go.nssp.mber.service.MberService;
import kr.go.nssp.rc.service.RcService;
import kr.go.nssp.sanctn.service.SanctnService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;
import kr.go.nssp.utl.egov.EgovProperties;

/**
 * 사건 접수(RECEIPT) 관련하여 처리하는 Controller class
 * RECEIPT -> RC 영문약어로 통칭
 * @author sunu
 *
 */
@Controller
@RequestMapping(value = "/rc/")
public class RcController {

	@Resource
	private RcService rcService;			//사건접수관련 서비스
	@Resource
	private CdService cdService;			//공통관리 서비스
	@Resource
	private DeptService deptService;		//부서관리 서비스
	@Resource
	private ExmnService exmnService;		//검찰관리 서비스
	@Resource
    private MberService mberService;		//회원관련 서비스
	@Resource
	private DocService docService;			//문서관련 서비스
	@Resource
    private SanctnService sanctnService;	//승인관련 서비스
	@Resource
	private AlotService alotService;		//배당관련 서비스
	@Resource
	private FileService fileService;		//배당관련 서비스


	private String[] stableRcCodeArr = {"02101", "02104"};
	
	//진행상태
	private String   STTUS_SANCTN_WAIT = EgovProperties.getProperty("Globals.SttusSanctnWait");	 //승인대기
	private String  STTUS_SANCTN_COMPT = EgovProperties.getProperty("Globals.SttusSanctnCompt"); //승인완료
	private String STTUS_SANCTN_RETURN = EgovProperties.getProperty("Globals.SttusSanctnReturn");//반려


	//확장자 제한
	ArrayList<String> formatList = new ArrayList<String>();

	public RcController(){
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
	}

	/**
	 * 전체사건관리 목록
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/allCaseList/")
	public String allCaseList(HttpServletRequest request, ModelMap model, RedirectAttributes redirectAttributes) throws Exception {

		HttpSession session = request.getSession();

		/*
		String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());

		if(!"Y".equals(mngr_yn)){
        	//권한없음
			redirectAttributes.addFlashAttribute("retMessage", "1");
            String referer = request.getHeader("Referer");
            return "redirect:"+ referer;
		}
		 */

		String esntlId = SimpleUtils.default_set( session.getAttribute("esntl_id").toString() );
		String  deptCd = SimpleUtils.default_set( session.getAttribute("dept_cd").toString()  );
		String  deptNm = SimpleUtils.default_set( session.getAttribute("dept_nm").toString()  );

		HashMap<String, Object> cMap = new HashMap<String, Object>();
		cMap.put("upper_cd", "00011");

		model.addAttribute("progrsSttusList", cdService.getCdList(cMap));	//진행상태
		model.addAttribute( "deptCd", deptCd );	//부서 코드
		model.addAttribute( "deptNm", deptNm );	//부서 이름

		return "rc/allCaseList";
	}

	/**
	 * 부서사건현황
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/deptCaseStatus/")
	public String deptCaseStatus(HttpServletRequest request, ModelMap model, RedirectAttributes redirectAttributes) throws Exception {

		HttpSession session = request.getSession();

		/*
		String mngr_yn = SimpleUtils.default_set(session.getAttribute("mngr_yn").toString());

		if(!"Y".equals(mngr_yn)){
        	//권한없음
			redirectAttributes.addFlashAttribute("retMessage", "1");
            String referer = request.getHeader("Referer");
            return "redirect:"+ referer;
		}
    	*/

		String esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String  deptCd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());
		String  deptNm = SimpleUtils.default_set(session.getAttribute("dept_nm").toString());

		HashMap<String, Object> cMap = new HashMap<String, Object>();
		cMap.put("upper_cd", "00011");

    	model.addAttribute("progrsSttusList", cdService.getCdList(cMap));	//진행상태
		model.addAttribute( "deptCd", deptCd );	//부서 코드
		model.addAttribute( "deptNm", deptNm );	//부서 이름

    	return "rc/deptCaseStatus";
	}

	/**
	 * 내사건 현황
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/myCaseStatus/")
	public String myCaseStatus(HttpServletRequest request, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
    	String esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());	//사용자 ID
    	String  deptCd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());	//부서코드

    	HashMap<String, Object> cMap = new HashMap<String, Object>();

    	cMap.put("upper_cd", "00011");

    	model.addAttribute("progrsSttusList", cdService.getCdList(cMap) );	//진행상태
    	model.addAttribute("deptCd", deptCd );			//부서코드

    	return "rc/myCaseStatus";
	}

	/**
	 * 내사건관리 목록
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/myCaseList/")
	public String myCaseList(HttpServletRequest request, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());	//사용자 ID
		String  deptCd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());	//부서코드

		HashMap<String, Object> cMap = new HashMap<String, Object>();

		cMap.put("upper_cd", "00011");

		model.addAttribute("progrsSttusList", cdService.getCdList(cMap) );	//진행상태
		model.addAttribute("deptCd", deptCd );			//부서코드
		model.addAttribute("myCaseSectionCd", "Y" );	//내사건 구분 코드

		return "rc/myCaseList";
	}


	/**
	 * 내사건관리 목록
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/rcCaseList/")
	public String rcCaseList(HttpServletRequest request, ModelMap model) throws Exception {

		HttpSession session = request.getSession();
		String esntlId = SimpleUtils.default_set( session.getAttribute("esntl_id").toString() );	//사용자 ID
		String  deptCd = SimpleUtils.default_set( session.getAttribute("dept_cd").toString()  );	//부서코드

		HashMap<String, Object> cMap = new HashMap<String, Object>();

		cMap.put("upper_cd", "00011");

		model.addAttribute("progrsSttusList", cdService.getCdList(cMap) );	//진행상태
		model.addAttribute("deptCd", deptCd );			//부서코드
		model.addAttribute("myCaseSectionCd", "Y" );	//내사건 구분 코드

		return "rc/rcCaseList";
	}

	
	/**
	 * 사건 목록 조회 Ajax
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getCaseListAjax/")
	public ModelAndView getCaseListAjax(HttpServletRequest request) throws Exception  {

        HttpSession session = request.getSession();

    	String esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString()); 	//세션 사용자 고유 ID
    	String	deptCd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString()); 	//세션 부서코드

    	String      searchStdr = SimpleUtils.default_set(request.getParameter("radioSearchStdr"));		//검색기준
    	String myCaseSectionCd = SimpleUtils.default_set(request.getParameter("hidMyCaseSectionCd")); 	//내 사건 구분 코드
    	String caseSearchTypeCd= SimpleUtils.default_set(request.getParameter("selCaseSearchTypeCd")); 	// 사건구분 코드 R : 접수번호 /C:사건번호 /I:내사번호 /T:임시번호
        String  searchFormatNm = SimpleUtils.default_set(request.getParameter("searchFormatNm"));
        String    choiceDeptCd = SimpleUtils.default_set(request.getParameter("textDeptCd"));			//부서코드
        String          rcSeCd = SimpleUtils.default_set(request.getParameter("hidRcSeCd"));			//접수구분코드
        String          menuCd = SimpleUtils.default_set(request.getParameter("hidMenuCd"));			//접수구분코드
        String   choiceCharger = SimpleUtils.default_set(request.getParameter("selectDeptCharger"));	//부서 담당자
        String    progrsStatus = SimpleUtils.default_set(request.getParameter("selectProgrsStatus"));	//진행상태
        String   trgterSection = SimpleUtils.default_set(request.getParameter("selectTrgter"));			//대상자구분
        String          trgter = SimpleUtils.default_set(request.getParameter("textTrgter"));			//대상자
        String    searchStdrNo = SimpleUtils.default_set(request.getParameter("radioSearchStdrNo"));	//접수번호
        String    searchStdrDe = SimpleUtils.default_set(request.getParameter("radioSearchStdrDe"));	//접수일자
        String      searchYear = SimpleUtils.default_set(request.getParameter("textSearchYear"));		//접수번호 년도
        String   searchNoStart = SimpleUtils.default_set(request.getParameter("textSearchNoStart"));	//접수번호 시작
        String     searchNoEnd = SimpleUtils.default_set(request.getParameter("textSearchNoEnd"));		//접수번호 종료
        String  receiptDeStart = SimpleUtils.default_set(request.getParameter("textReceiptDeStart"));	//접수일자 시작
        String    receiptDeEnd = SimpleUtils.default_set(request.getParameter("textReceiptDeEnd"));		//접수일자 종료

        String      coldCaseYN = SimpleUtils.default_set(request.getParameter("chkColdCase"));			//미제사건 여부
        String       trnCaseYN = SimpleUtils.default_set(request.getParameter("chkTrnCase"));			//송치사건 여부
        String      stopCaseYN = SimpleUtils.default_set(request.getParameter("chkStopCase"));			//중지사건 여부
        String        rcCaseYN = SimpleUtils.default_set(request.getParameter("chkRcCase"));			//접수대기 여부

        String   chargeSection = SimpleUtils.default_set(request.getParameter("radioChargeSection"));	//담당자구분
        
        String   sortingFields = SimpleUtils.default_set(request.getParameter("sortingFields"));		//sorting

        //현재 페이지 파라메타
        String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));

        int intPage = 1;

		if( !"".equals(hidPage) )
			intPage = Integer.parseInt((String)hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));

		if( hidPageBlock== null || hidPageBlock.equals("") ){
			hidPageBlock = "5";
		}

		int pageBlock = Integer.parseInt((String)hidPageBlock);

		//페이지 기본설정
		int pageArea = 10;

    	//page
    	PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap<String, Object> pMap = new HashMap<String, Object>();

		pMap.put( "startRow", paginationInfo.getFirstRecordIndex());
		pMap.put(   "endRow", paginationInfo.getLastRecordIndex() );

		pMap.put( "format_nm", searchFormatNm );//
		pMap.put(  "rc_se_cd", rcSeCd );		//접수 구분 코드
		pMap.put(   "menu_cd", menuCd );		//메뉴 코드
		pMap.put(  "esntl_id", esntlId );		//사용자 고유 ID

		switch( menuCd ){		//menuCd - 00001 : 부서 사건현황, 00070 : 전제사건 관리
		    case "00001":
		    	if( null != choiceCharger ) {
					pMap.put( "choiceCharger", choiceCharger );		//사용자 고유 ID
				}
				pMap.put( "dept_cd", choiceDeptCd );
		        break;
		    case "00070":
		    	if( "dept".equals(searchStdr) ) {
		    		if( null != choiceCharger ) {
						pMap.put( "choiceCharger", choiceCharger );	//사용자 고유 ID
					}
					pMap.put( "dept_cd", choiceDeptCd );
		    	}

		    	if( null != coldCaseYN && "Y".equals(coldCaseYN) ){	//미제 사건 여부
		    		pMap.put( "coldCase", "Y" );
		    	}

		    	if( null != trnCaseYN && "Y".equals(trnCaseYN) ){	//송치 사건 여부
		    		pMap.put( "trnCase", "Y" );
		    	}

		    	if( null != stopCaseYN && "Y".equals(stopCaseYN) ){	//중지사건 여부
		    		pMap.put( "stopCase", "Y" );
		    	}
		    	
		    	pMap.put(  "esntl_id", "" );

		        break;
		    case "00072":
		      	if( null != rcCaseYN && "Y".equals(rcCaseYN) ){	//미제 사건 여부
		    		pMap.put( "rcCaseYN", "Y" );
		    	}
		        break;
		    default:
		    	pMap.put(  "dept_cd", deptCd );
		        break;
		}

		//내사건 구분 코드
		if( !myCaseSectionCd.isEmpty() && "Y".equals(myCaseSectionCd) ) {
			pMap.put( "myCaseSectionCd", myCaseSectionCd );
			pMap.put( "dept_cd", SimpleUtils.default_set(session.getAttribute("dept_cd").toString()) );
		}

		//진행상태
		if( !progrsStatus.isEmpty() ){
			pMap.put( "progrs_sttus_cd", progrsStatus );
		}

		//대상자
		if( !trgterSection.isEmpty() ){

			if( "suspect".equals(trgterSection) ){
				pMap.put( trgterSection+"_trgter_nm", trgter );
			} else if( "sufferer".equals(trgterSection) ) {
				pMap.put( trgterSection+"_trgter_nm", trgter );
			}
		}

		//담당자 구분
		if( !chargeSection.isEmpty() ){

			if( "chargePrincipal".equals(chargeSection) ) {
				pMap.put( "MAIN_YN", "Y" );
			} else if( "chargeDeputy".equals(chargeSection) ) {
				pMap.put( "MAIN_YN", "N" );
			}
		}

		//번호/일자 검색 구분
		if( !searchStdr.isEmpty() ){

			if( "stdrNo".equals(searchStdr) || "all".equals(searchStdr) ){		//접수번호

				pMap.put( "caseSearchTypeCd", caseSearchTypeCd );

				if( !searchYear.isEmpty() ){

					if( !searchNoStart.isEmpty() ){
						pMap.put( "searchNoStart", (searchYear+"-"+String.format("%06d", Integer.parseInt(searchNoStart))) );
					}

					if( !searchNoEnd.isEmpty() ){
						pMap.put( "searchNoEnd", (searchYear+"-"+String.format("%06d", Integer.parseInt(searchNoEnd))) );
					}
				}
			}

			if( "stdrDe".equals(searchStdr) || "all".equals(searchStdr) ){		//접수일자

				pMap.put( "receiptDeStart", receiptDeStart );
				pMap.put(   "receiptDeEnd", receiptDeEnd   );
			}
		}
		
		//sorting
		//System.out.println("sortingFields >>>>>>>>>>>>>> "+sortingFields);
		if(sortingFields != null && !sortingFields.equals("")) {			
			Map<String, Object> sortingField = Utility.getGridSortList(sortingFields);
			if(sortingField != null && sortingField.size() > 0 ) {				
				pMap.put("dataField", sortingField.get("dataField"));
				pMap.put("sortType", sortingField.get("sortType"));
			}
		}		

		int caseList_cnt = 0;

		List<HashMap<String, Object>> caseList = null;

		//사건구분코드(rcSeCd) A:전체사건, F:정식사건, I:내사사건, T:임시사건 , R:접수사건
 		if ( "I".equals(rcSeCd) || "T".equals(rcSeCd)  || "R".equals(rcSeCd)|| "S".equals(rcSeCd) ){
			caseList = rcService.getCaseList(pMap);		//접수
		} else {
			caseList = rcService.getCaseListAll(pMap);	//접수 + 사건
		}

		if( caseList.size() > 0 ){
			caseList_cnt = Integer.parseInt(caseList.get(0).get("TOT_CNT").toString());
		}

    	HashMap<String, Object> cMap = new HashMap<String, Object>();

    	cMap.put("list", caseList);
    	cMap.put("cnt", caseList_cnt);

		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 부서 담당자 조회 Ajax
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getDeptChargerListAjax/")
	public ModelAndView getDeptChargerListAjax(HttpServletRequest request) throws Exception  {

		String deptCd = SimpleUtils.default_set(request.getParameter("deptCd"));

		HashMap<String, Object> pMap = new HashMap<String, Object>();

		pMap.put( "dept_cd", deptCd );

		List<HashMap<String, Object>> deptChargerList = rcService.getDeptChargerList(pMap);	//부서 사건 리스트

		HashMap<String, Object> cMap = new HashMap<String, Object>();

 		cMap.put( "deptChargerList", deptChargerList );

		return new ModelAndView( "ajaxView", "ajaxData", cMap );
	}


	/**
	 * 대상자 목록 Ajax
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/getTrgterListAjax/")
	public ModelAndView getTrgterListAjax(HttpServletRequest request) throws Exception  {

		InvUtil commonUtil = InvUtil.getInstance();

		String   rcNo = request.getParameter( "hidRcNo"  );	//접수번호
        String caseNo = request.getParameter( "hidCaseNo");	//사건번호

        HashMap<String,Object> pMap = new HashMap<String,Object>();

        pMap.put(   "rc_no", rcNo   );
        pMap.put( "case_no", caseNo );

		List<HashMap> trgterList = rcService.getTrgterList(pMap);	//내 사건 리스트

		trgterList = commonUtil.getConvertUnderscoreNameGrid(trgterList);

		pMap.put( "list", trgterList );

		return new ModelAndView( "ajaxView", "ajaxData", pMap );
	}

	/**
	 * 사건접수 작성 화면
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/caseInput/")
	public String caseInput(HttpServletRequest request, ModelMap model) throws Exception  {

		HttpSession session = request.getSession();

		InvUtil commonUtil = InvUtil.getInstance();

    	String esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());	//사용자 ID

		String caseRcInputMode = SimpleUtils.default_set(request.getParameter("hidCaseRcInputMode"));
		String rcNo = "";

		rcNo = SimpleUtils.default_set(request.getParameter("hidRcNo"));

		HashMap<String, Object> pMap = new HashMap<>();

		pMap.put("esntl_id", esntlId);

    	HashMap userInfo = mberService.userInfo(pMap);

    	if (userInfo !=null ) {

    		model.addAttribute("userInfo", userInfo);
    	}

		HashMap<String, Object> cMap = new HashMap<String, Object>();

    	cMap.put( "upper_cd", "00400" );									//수사단서 코드
    	model.addAttribute("invProvisoList", cdService.getCdList(cMap) );	//수사단서 목록

    	cMap.put( "upper_cd", "00120" );									//접수형태 코드
    	model.addAttribute("rcFormList", cdService.getCdList(cMap) );		//접수형태 목록

    	cMap.put( "upper_cd", "00140" );									//상담방법 코드
    	model.addAttribute("cnsltMthCdList", cdService.getCdList(cMap) );	//상담방법 목록

    	cMap.put( "upper_cd", "00102" );									//대상자 구분 코드
    	model.addAttribute("trgterSectionCdList",cdService.getCdList(cMap));//대상자 구분 목록

    	cMap.put( "upper_cd", "00270" );									//대상자 분류 코드
    	model.addAttribute("trgterClCdList",cdService.getCdList(cMap));		//대상자 분류 목록

    	cMap.put( "upper_cd", "01324" );									//이메일
    	model.addAttribute("emailList", cdService.getCdList(cMap) );		//이메일 코드 목록

    	cMap.put( "upper_cd", "00470" );									//국번 코드
    	model.addAttribute("telofcnoCdList", cdService.getCdList(cMap) );	//국번코드 목록

    	cMap.put( "upper_cd", "00939" );									//휴대폰번호 앞자리
    	model.addAttribute("hpNoCdList", cdService.getCdList(cMap) );		//휴대폰번호 목록

    	cMap.put("start_cd", "00000");
		model.addAttribute("exmnList", commonUtil.getConvertUnderscoreNameList(exmnService.getExmnFullList(cMap))); //검찰관할코드

		model.addAttribute( "caseRcInputMode", caseRcInputMode );			//사건 입력 모드(작성/수정)
		model.addAttribute( "formatList", formatList );

        return "rc/caseInput";

	}


	/**
	 * 사건 수정 화면
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/caseUpdatePopup/")
	public String caseUpdatePopup(HttpServletRequest request, ModelMap model) throws Exception  {

		InvUtil commonUtil = InvUtil.getInstance();

		String rcNo = request.getParameter("rcNo");		//접수번호
		String progrsSttusCd = request.getParameter("progrsSttusCd");	//사건진행상태

		HashMap<String, Object> cMap = new HashMap<String, Object>();

		cMap.put("rc_no", rcNo );

		HashMap<String, Object>  caseInfo = rcService.getCaseInfo(cMap);	//접수사건의 상세정보

		model.addAttribute("fileId", caseInfo.get("FILE_ID") );	//수사단서 목록

		cMap.put("upper_cd", "00400" );										//수사단서 코드
    	model.addAttribute("invProvisoList", cdService.getCdList(cMap) );	//수사단서 목록

    	cMap.put("upper_cd", "00120" );										//접수형태 코드
    	model.addAttribute("rcFormList", cdService.getCdList(cMap) );		//접수형태 목록

    	cMap.put("upper_cd", "00140" );										//상담방법 코드
    	model.addAttribute("cnsltMthCdList", cdService.getCdList(cMap) );	//상담방법 목록

    	cMap.put("upper_cd", "00470" );										//국번 코드
    	model.addAttribute("telofcnoCdList", cdService.getCdList(cMap) );	//국번코드 목록

    	model.addAttribute( "formatList", formatList );

		cMap.put("start_cd", "00000");
		model.addAttribute("exmnList", commonUtil.getConvertUnderscoreNameList(exmnService.getExmnFullList(cMap))); //검찰관할코드

    	model.put("rcNo", rcNo);
		model.put("progrsSttusCd", progrsSttusCd);

		return "rc/pop/caseUpdate";
	}

	/**
	 * 사건접수 대상자 작성/수정 화면
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetInputPopup/")
	public String targetInputPopup(HttpServletRequest request, ModelMap model) throws Exception  {

		HttpSession session = request.getSession();

		Utility utl = Utility.getInstance();

    	String esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());	//사용자 ID
		String items = SimpleUtils.default_set(request.getParameter("items"));

		String rcNo = SimpleUtils.default_set(request.getParameter("rcNo"));


		if( null != rcNo && rcNo.length() > 0 ) {
			model.addAttribute("rcNo", rcNo);
		} else {

			Map<String, Object> listMapItems = new HashMap();

			if( items != null && items != "" ) {

				items = SimpleUtils.default_set(URLDecoder.decode(items,"UTF-8"));

		    	JSONParser jsonParser  	= new JSONParser();
		        JSONObject jsonObj = (JSONObject) jsonParser.parse(items);
			    listMapItems = utl.getMapFromJsonObject(jsonObj);

		    	//JSONArray ja_items = ((JSONArray) jsonParser.parse(items));
			    //List<Map<String, Object>> listMapItems= utl.getListMapFromJsonArray(ja_items);
			}

			HashMap<String, Object> pMap = new HashMap<>();

			pMap.put("esntl_id", esntlId);

	    	HashMap userInfo = mberService.userInfo(pMap);

	    	if (userInfo !=null ) {

	    		model.addAttribute("userInfo", userInfo);
	    	}

	    	model.addAttribute( "items", listMapItems );				//사건 입력 모드(작성/수정)
		}

		InvUtil commonUtil = InvUtil.getInstance();

		HashMap<String, Object> cMap = new HashMap<String, Object>();

    	cMap.put( "upper_cd", "00102" );									//대상자 구분 코드
    	model.addAttribute("trgterSectionCdList",cdService.getCdList(cMap));//대상자 구분 목록

    	cMap.put( "upper_cd", "00270" );									//대상자 분류 코드
    	model.addAttribute("trgterClCdList",cdService.getCdList(cMap));		//대상자 분류 목록

    	cMap.put( "upper_cd", "01324" );									//이메일
    	model.addAttribute("emailList", cdService.getCdList(cMap) );		//이메일 코드 목록

    	cMap.put( "upper_cd", "00470" );									//국번 코드
    	model.addAttribute("telofcnoCdList", cdService.getCdList(cMap) );	//국번코드 목록

    	cMap.put( "upper_cd", "00939" );									//휴대폰번호 앞자리
    	model.addAttribute("hpNoCdList", cdService.getCdList(cMap) );		//휴대폰번호 목록

        return "rc/pop/targetInput";
	}


	/**
	 * 대상자 추가
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/targetInsertAjax/" , method=RequestMethod.POST)
	@ResponseBody
	public ModelAndView targetInsertAjax(HttpServletRequest request, ModelMap model, @RequestBody Map<String, Object> param) throws Exception  {

		HttpSession session = request.getSession();

    	String esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());	//사용자 ID

		InvUtil commonUtil = InvUtil.getInstance();

		String rcNo = param.get("rcNo").toString();	//접수번호

		HashMap<String, Object> targetInfoMap = (HashMap)commonUtil.getMapToMapConvert((HashMap) param.get("targetInfo"));

		targetInfoMap.put( "rc_no", rcNo );			//접수번호
		targetInfoMap.put( "esntl_id", esntlId );

		int returnVal = 0;
		try {
			rcService.insertRcTmprTrgter(targetInfoMap);	//대상자 등록
			returnVal++;
		} catch (Exception e) {
			returnVal = -1;
		}

		HashMap<String, Object> returnMap = new HashMap<String, Object> ();

		returnMap.put( "returnVal", returnVal );

		return new ModelAndView("ajaxView", "ajaxData", returnMap);
	}


	/**
	 * 대상자 정보 update
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/updateTargetInfoAjax/")
	public ModelAndView updateTargetInfoAjax(HttpServletRequest request) throws Exception {

		Utility utl = Utility.getInstance();

        HttpSession session = request.getSession();

        String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
        String result = "1";

    	InvUtil commonUtil = InvUtil.getInstance();

		HashMap aMap = (HashMap) commonUtil.getParameterMapConvert(request);

		try {
	    	aMap.put( "esntl_id", esntl_id );
         	rcService.updateTargetInfo(aMap);

		} catch( Exception e ){
			result = "-1";
		}

    	HashMap<String, Object> ret = new HashMap<String, Object>();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	/**
	 * 대상자 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/deleteTargetInfoAjax/")
	public ModelAndView deleteTargetInfoAjax(HttpServletRequest request) throws Exception  {

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

    	InvUtil commonUtil = InvUtil.getInstance();

		HashMap pMap = (HashMap) commonUtil.getParameterMapConvert(request);

        String result = "1";

        pMap.put( "esntl_id", esntl_id );

        try {
         	rcService.deleteTargetInfo(pMap);
		} catch ( Exception e ){
			result = "-1";
		}

    	HashMap<String, Object> ret = new HashMap<String, Object>();

    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}


	/**
	 * 대상자 수정 팝업
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/targetUpdatePopup/")
	public String targetUpdatePopup(HttpServletRequest request, ModelMap model) throws Exception  {

		String     rcNo = request.getParameter("rcNo");		//접수번호
		String   caseNo = request.getParameter("caseNo");	//사건번호
		String   rcSeCd = request.getParameter("rcSeCd");	//사건번호
		String trgterSn = request.getParameter("trgterSn");	//대상자 순번
		String progrsSttusCd = request.getParameter("progrsSttusCd");	//진행상태

		HashMap<String, Object> cMap = new HashMap<String, Object>();

    	cMap.put("upper_cd", "00102" );										//대상자 구분 코드
    	model.addAttribute("trgterSectionCdList",cdService.getCdList(cMap));//대상자 구분 목록

    	cMap.put("upper_cd", "00270" );										//대상자 분류 코드
    	model.addAttribute("trgterClCdList",cdService.getCdList(cMap));		//대상자 분류 목록

    	cMap.put("upper_cd", "01324" );										//이메일
    	model.addAttribute("emailList", cdService.getCdList(cMap) );		//이메일 코드 목록

    	cMap.put("upper_cd", "00470" );										//국번 코드
    	model.addAttribute("telofcnoCdList", cdService.getCdList(cMap) );	//국번코드 목록

    	cMap.put("upper_cd", "00939" );										//휴대폰번호 앞자리
    	model.addAttribute("hpNoCdList", cdService.getCdList(cMap) );		//휴대폰번호 목록

		model.put(     "rcNo", rcNo);			//접수번호
		model.put(   "caseNo", caseNo);			//사건번호
		model.put( "trgterSn", trgterSn);		//대상자 순번
		model.put( "progrsSttusCd", progrsSttusCd);

		return "rc/pop/targetUpdate";
	}


	/**
	 * 사건접수 등록
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping (value = "/caseSaveAction/", method=RequestMethod.POST)
	@ResponseBody
	public ModelAndView caseSaveAction (HttpServletRequest request, @RequestBody Map<String, Object> param) throws Exception {

		HttpSession session = request.getSession();

	    String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
	    String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		param.put("esntl_id" ,esntl_id);
		param.put("writng_dept_cd", dept_cd);

		HashMap<String, Object> returnMap = rcService.saveRcTmpr(param);

		return new ModelAndView("ajaxView", "ajaxData", returnMap);
	}


	/**
	 * 사건상세팝업 - 사건정보 iframe
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/caseInfoIframe/")
	public String caseInfoIframe(HttpServletRequest request, ModelMap model) throws Exception  {

		HttpSession session = request.getSession();
		String esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

		String     rcNo = request.getParameter("hidRcNo");		//접수번호
		String   caseNo = request.getParameter("hidCaseNo");	//사건번호
		String   itivNo = request.getParameter("hidItivNo");	//내사번호
		String searchYn = request.getParameter("hidSearchYn");	//검색여부

		HashMap<String, Object> cMap = new HashMap<String, Object>();

		if( "Y" == searchYn ) {
			cMap.put("case_no", caseNo);

		} else {
			cMap.put("rc_no", rcNo);
			cMap.put("case_no", caseNo);
		}

		HashMap<String, Object> caseInfo = rcService.getCaseInfo(cMap);

		model.addAttribute("caseInfo", caseInfo);

		cMap.put("esntl_id", esntlId);

		HashMap userInfo = mberService.userInfo(cMap);

		if( userInfo != null ) {
			model.addAttribute("userInfo", userInfo);
		}

		cMap.put("upper_cd", "00400" );											//수사단서 코드
    	model.addAttribute(     "invProvisoList", cdService.getCdList(cMap) );	//수사단서 목록

    	cMap.put("upper_cd", "00120" );											//접수형태 코드
    	model.addAttribute(         "rcFormList", cdService.getCdList(cMap) );	//접수형태 목록

    	cMap.put("upper_cd", "00140" );											//상담방법 코드
    	model.addAttribute(     "cnsltMthCdList", cdService.getCdList(cMap) );	//상담방법 목록

    	cMap.put("upper_cd", "00470" );											//국번 코드
    	model.addAttribute(     "telofcnoCdList", cdService.getCdList(cMap) );	//국번코드 목록

    	cMap.clear();

		return "rc/iframe/caseInfoIframe";
	}


	/**
	 * 사건상세팝업 - 대상자정보 iframe
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/caseTrgterInfoIframe/")
	public String caseTrgterInfoIframe(HttpServletRequest request, ModelMap model) throws Exception  {

		//HashMap hMap = (HashMap) RequestUtil.getParameterMap(request);

		HttpSession session = request.getSession();
		String esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

		String rcNo = request.getParameter("hidRcNo");
		String caseNo = request.getParameter("hidCaseNo");

		HashMap<String, Object> cMap = new HashMap<String, Object>();

    	cMap.put( "upper_cd", "00102" );										//대상자 구분 코드
    	model.addAttribute("trgterSectionCdList", cdService.getCdList(cMap) );	//대상자 구분 목록

    	cMap.put( "upper_cd", "00270" );										//대상자 분류 코드
    	model.addAttribute(     "trgterClCdList", cdService.getCdList(cMap) );	//대상자 분류 목록

    	cMap.put( "upper_cd", "00300" );										//직업 코드
    	model.addAttribute(         "occpCdList", cdService.getCdList(cMap) );	//직업 분류 목록

    	cMap.put("upper_cd", "00140" );											//국적 코드	생성
    	model.addAttribute(         "nltyCdList", cdService.getCdList(cMap) );	//국적 코드 목록

    	cMap.put( "upper_cd", "00731" );										//체포유형 코드
    	model.addAttribute(   "arrestTypeCdList", cdService.getCdList(cMap) );	//체포유형 목록

    	cMap.put( "upper_cd", "00470" );										//국번 코드
    	model.addAttribute(     "telofcnoCdList", cdService.getCdList(cMap) );	//국번코드 목록

    	cMap.clear();

		return "rc/iframe/caseTrgterInfoIframe";
	}


	/**
	 * 접수 구분 업데이트
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/updateReceiptSectionAjax/")
	public ModelAndView updateReceiptSectionAjax (HttpServletRequest request) throws Exception {

        String      rcCode = SimpleUtils.default_set( request.getParameter("txtRootCode") );	//접수 번호
        String    caseCode = SimpleUtils.default_set( request.getParameter("txtCode") );		//사건 번호
        String sectionCode = SimpleUtils.default_set( request.getParameter("hidSectionCode") );	//접수 구분 코드	F:정식 / I:내사/ T:임시

    	HashMap<String, Object> pMap = new HashMap<String, Object>();

    	pMap.put(   "rc_code", rcCode);
    	pMap.put( "case_code", caseCode);
    	pMap.put(  "rc_se_cd", sectionCode);

    	HashMap<String, Object> rcCaseInfo = new HashMap<>();

    	rcCaseInfo = rcService.getCaseInfo(pMap);	//접수사건의 상세정보

    	if( null == rcCaseInfo ){

    		System.out.println("정보 없음");
    	} else {
    		rcService.updateReceiptSection(pMap);	//접수구분 업데이트
    	}

		return new ModelAndView("ajaxView", "ajaxData", rcCaseInfo);
	}


	/**
	 * 고소,고발 또는 수사이첩 접수부 팝업
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/receptionReprtPopup/")
	public String receptionReprtPopup (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		String  rcNo = request.getParameter("rcNo");
		String docId = request.getParameter("docId");

		model.addAttribute(	 "rcNo", rcNo );
		model.addAttribute( "docId", docId);

		return "rc/pop/receptionReprt";
	}


	/**
	 * 내사 착수보고  팝업
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/itivOutsetReprtPopup/")
	public String itivOutsetReprtPopup (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();

    	String esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String    rcNo = request.getParameter("rcNo");
		String  itivNo = request.getParameter("itivNo");
		String  progrsSttusCd = request.getParameter("progrsSttusCd");

		HashMap<String, Object> pMap = new HashMap<String, Object>();
		pMap.put("rc_no", rcNo);

		HashMap<String, Object> itivOutsetInfo = rcService.getRcItivOutset(pMap);	//접수사건의 상세정보

		if( itivOutsetInfo == null ) {
    		String docId = docService.getDocID();
    		String fileId = fileService.getFileID();
    		pMap.put("doc_id", docId);
    		pMap.put("file_id", fileId);
    		pMap.put("esntl_id", esntlId);

    		rcService.insertRcItivOutset(pMap);

    		model.addAttribute("docId", docId);
    		model.addAttribute("fileId", fileId);
    	} else {
    		model.addAttribute( "docId", itivOutsetInfo.get("DOC_ID")  );
    		model.addAttribute("fileId", itivOutsetInfo.get("FILE_ID") );
    	}
		String outsetConfmResultYN="";
		
		if( null == itivNo || "".equals( itivNo ) ){
			
			HashMap<String, String> outsetConfmResult = rcService.getOutsetConfmYN(rcNo);
			
			if( null != outsetConfmResult ){
				String confmJobSeCd = outsetConfmResult.get("CONFM_JOB_SE_CD");
				String      sttusCd = outsetConfmResult.get("STTUS_CD");
				
				if ( "01385".equals( confmJobSeCd ) && STTUS_SANCTN_WAIT.equals( sttusCd ) ){
					outsetConfmResultYN = "Y";
				}
				if ( "01385".equals( confmJobSeCd ) && STTUS_SANCTN_RETURN.equals( sttusCd ) ){
					outsetConfmResultYN = "R";
				}
			}
		}
		
		String outsetReportYN = rcService.getOutsetReportYN(rcNo);

    	if( null != outsetReportYN ){
    		model.addAttribute("outset_report_yn", outsetReportYN );
    	}

		model.addAttribute(			 "rcNo", rcNo   );
		model.addAttribute(	   	   "itivNo", itivNo );
		model.addAttribute("itivOutsetInfo", itivOutsetInfo );
		model.addAttribute( "progrsSttusCd", progrsSttusCd	);
		model.addAttribute( "outsetConfmResultYN", outsetConfmResultYN	);

		return "rc/pop/itivOutsetReprt";
	}


	/**
	 * 내사결과보고  팝업
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/itivResultReprtPopup/")
	public String itivResultReprtPopup (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HttpSession session = request.getSession();

    	String esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

    	String           rcNo = request.getParameter("rcNo");
		String         itivNo = request.getParameter("itivNo");
		String  progrsSttusCd = request.getParameter("progrsSttusCd");

		HashMap<String, Object> pMap = new HashMap<String, Object>();

		pMap.put("itiv_no", itivNo);

    	HashMap<String, Object> itivResultInfo = rcService.getRcItivResult(pMap);	//접수사건의 상세정보

    	if( itivResultInfo == null ){

    		String docId = docService.getDocID();
    		String fileId = fileService.getFileID();

    		pMap.put("doc_id", docId );
    		pMap.put("file_id", fileId );
    		pMap.put("esntl_id", esntlId );

    		rcService.insertRcItivResult(pMap);
    		model.addAttribute("docId", docId);
    		model.addAttribute("fileId", fileId);
    	} else {
    		model.addAttribute("docId", itivResultInfo.get("DOC_ID"));
    		model.addAttribute("fileId", itivResultInfo.get("FILE_ID"));
    	}

    	String outsetReportYN = rcService.getOutsetReportYN(rcNo);

    	if( null != outsetReportYN ){
    		model.addAttribute("outsetReportYN", outsetReportYN );
    	}


    	HashMap<String, Object> cMap = new HashMap<String, Object>();

    	cMap.put( "upper_cd", "00600" );

    	List<HashMap> itivEndDspsCdList = cdService.getCdList(cMap);

    	for( int i=0; i<itivEndDspsCdList.size(); i++ ){

    		if( itivEndDspsCdList.get(i).get("cd").equals("00607") ){	//사건중지
    			itivEndDspsCdList.remove(i);
    		}
    		if( itivEndDspsCdList.get(i).get("cd").equals("00608") ){	//관계자 불명
    			itivEndDspsCdList.remove(i);
    		}
    	}

    	model.addAttribute("itivEndDspsCdList", itivEndDspsCdList );	//사건종결처분코드

    	model.addAttribute(  "rcNo", rcNo	);
		model.addAttribute("itivNo", itivNo	);
		model.addAttribute("itivResultInfo", itivResultInfo	);
		model.addAttribute( "progrsSttusCd", progrsSttusCd );

		return "rc/pop/itivResultReprt";
	}
	/**
	 * 임시결과보고  팝업
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/tmprResultReprtPopup/")
	public String tmprResultReprtPopup (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		String          rcNo = request.getParameter("rcNo");			//접수번호
		String        tmprNo = request.getParameter("tmprNo");			//임시번호
		String progrsSttusCd = request.getParameter("progrsSttusCd");	//진행상태코드

		HashMap<String, Object> pMap = new HashMap<String, Object>();

		pMap.put("tmpr_no", tmprNo);

		HashMap<String, Object> tmrpCaseInfo = rcService.getCaseInfoByTmprNo(pMap);	//임시번호로 사건정보 조회

		if( tmrpCaseInfo == null ){
			model.addAttribute("error", "-1");
		} else {
			model.addAttribute("docId", tmrpCaseInfo.get("DOC_ID"));
			model.addAttribute("fileId", tmrpCaseInfo.get("FILE_ID"));
		}

		HashMap<String, Object> cMap = new HashMap<String, Object>();

    	cMap.put( "upper_cd", "00600" );

    	List<HashMap> tmprEndDspsCdList = cdService.getCdList(cMap);

    	for( int i=0; i<tmprEndDspsCdList.size(); i++ ){

    		if( tmprEndDspsCdList.get(i).get("cd").equals("00605") ){	//내사중지
    			tmprEndDspsCdList.remove(i);
    		}
    	}

    	model.addAttribute("tmprEndDspsCdList", tmprEndDspsCdList );	//사건종결처분코드
		model.addAttribute(     "rcNo", rcNo	);
		model.addAttribute(   "tmprNo", tmprNo	);
		model.addAttribute(  "tmrpCaseInfo", tmrpCaseInfo);
		model.addAttribute( "progrsSttusCd", progrsSttusCd );

		return "rc/pop/tmprResultReprt";
	}


	/**
	 * 범죄 인지  팝업
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/crmnlRecognitionPopup/")
	public String crmnlRecognitionPopup (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	String   rcNo = request.getParameter("rcNo");
     	String rcSeCd = request.getParameter("rcSeCd");

    	HashMap<String, Object> pMap = new HashMap<String, Object>();

		pMap.put( "rc_no", rcNo );

    	HashMap<String, Object> caseInfo = rcService.getCaseInfo(pMap);	//사건의 상세정보

    	if( caseInfo != null ) {
    		model.addAttribute( "caseInfo", caseInfo );
    		model.addAttribute( "progrsSttusCd", caseInfo.get("PROGRS_STTUS_CD") );
    	} else {
    		model.addAttribute( "error", "-1" );
    	}

		model.addAttribute(   "rcNo", rcNo   );
		model.addAttribute( "rcSeCd", rcSeCd );

		return "rc/pop/crmnlRecognitionPopup";
	}


	/**
	 * 보고서 승인요청
	 * @return ModelAndView
	 * @exception Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes", "unused" })
	@RequestMapping (value = "/reprtConfmRequestAjax/")
	@ResponseBody
	public ModelAndView reprtConfmRequestAjax(HttpServletRequest request) throws Exception {

		HttpSession session = request.getSession();

		String registPath = "";
		
		String esntlId = SimpleUtils.default_set( session.getAttribute("esntl_id").toString() );
		String  deptCd = SimpleUtils.default_set( session.getAttribute("dept_cd").toString()  );

		InvUtil commonUtil = InvUtil.getInstance();
		HashMap requestMap = (HashMap) commonUtil.getParameterMapConvert(request);

		int result = 1;

		if( null == requestMap ){
			new Exception();
		}

		try {

			Utility utl = Utility.getInstance();

			HashMap paramMap = new HashMap<String, Object>();

			paramMap.put( "esntl_id", esntlId );
			paramMap.put(  "dept_cd", deptCd  );
			paramMap.put(    "rc_no", requestMap.get("rc_no") ); //접수번호
			
			/*
			 * if( "00601".equals(requestMap.get("tmpr_end_dsps_cd")) ){ //00601 : 입건
			 * requestMap.put( "case_end_se_change_cd", "00381"); }
			 */
			
			//보고서 구분 TRR:임시결과보고서 / IOR:내사착수보고서  IRR:내사결과보고서
			if( "TRR".equals(requestMap.get("reprt_se")) ){
				
				paramMap.put(      "progrs_sttus_cd", "02111");	//임시종결
				paramMap.put(             "reprt_se", requestMap.get("reprt_se") );				//사건종결 구분변경
				paramMap.put(           "ed_dsps_cd", requestMap.get("tmpr_end_dsps_cd") );		//임시결과 처분코드
				paramMap.put("case_end_se_change_cd", requestMap.get("case_end_se_change_cd") );//사건종결 구분변경

			} else if( "IOR".equals(requestMap.get("reprt_se")) ){

				if( "Y".equals( requestMap.get("outset_confm_result_yn") ) ){
					//내사 착수 승인 요청 진행
					
					paramMap.put( "confm_job_se_cd", "01385"); // 승인업무구분 - 내사착수 (01385)
					
					String sanctnId = rcService.getSanctnId(  requestMap.get("rc_no").toString() );
					
					paramMap.put("sanctn_id",  sanctnId );	   // 승인 Id
					rcService.insertCaseConfmReqst(paramMap);  // 정식사건 승인요청
					
				} else {	//내사 착수 보고 완료
					paramMap.put("outset_report_yn", "Y");	//내사착수 보고 여부
					rcService.updateRcItivOutset(paramMap);	//내사착수 테이블 update
				}

			} else if( "IRR".equals(requestMap.get("reprt_se")) ){

				paramMap.put(       "itiv_no", requestMap.get("itiv_no") );				//내사번호
				paramMap.put(       "itiv_cn", requestMap.get("itiv_cn") ); 			//사유
				paramMap.put(    "ed_dsps_cd", requestMap.get("itiv_end_dsps_cd") );	//내사결과 처분코드
				paramMap.put("itiv_result_cd", requestMap.get("case_end_se_change_cd"));//내사결과코드
				paramMap.put("case_end_se_change_cd", requestMap.get("case_end_se_change_cd"));//종결결과코드

				//내사종결 코드  - 내사종결 : 00383 / 내사중지 : 00384 / 내사종결 입건 : 00381
				if( "00383".equals( requestMap.get("case_end_se_change_cd")) ){
					paramMap.put("progrs_sttus_cd", "02113");				  // 사건진행상태 - 내사종결

				} else if( "00384".equals(requestMap.get("case_end_se_change_cd")) ){
					paramMap.put("progrs_sttus_cd", "02112");	// 사건진행상태 - 내사중지
				}

				rcService.updateRcItivResult(paramMap);			// 내사결과 테이블 update
			}

			if( !"IOR".equals(requestMap.get("reprt_se")) ){	// 보고승인이 내사착수가 아니라면 진행상태 변경
				//2020.02.06 추가 권종열님 요청
				/*
				 * 2020.07.15 변경 권종열님 요청
				 * - 임시사건 종결이나 내사사건 종결시 정식사건으로 변경되는 경우는
				 * - 종결구분이 정식사건:입건 이 아닌 사건종결 : 입건 으로 선택시 정식으로 변경
				 */
				
				//if( "00381".equals(requestMap.get("case_end_se_change_cd")) ){ //사건종결 : 00385 / 내사사건 : 00382 / 정식사건(입건) : 00381
				
				if( "00385".equals(requestMap.get("case_end_se_change_cd")) || "00383".equals(requestMap.get("case_end_se_change_cd")) ){  
					
					if( "00601".equals(requestMap.get("tmpr_end_dsps_cd")) || "00601".equals(requestMap.get("itiv_end_dsps_cd")) ){   //00601 : 입건
						
						paramMap.put( "case_end_se_change_cd", "00381"); 
						
						rcService.updateCaseToF(paramMap);	// 정식사건으로 변경로직
						
						paramMap.put( "confm_job_se_cd", "01386");	// 승인업무구분 - 입건 (01386)
						rcService.insertCaseConfmReqst(paramMap);	// 정식사건 승인요청
					}
					
				} else {
					rcService.updateRcTmprSttus(paramMap);	// 임시결과/내사착수/내사결과 - 승인없이 사건 진행상태 변경
				}
			}

		} catch(Exception e) {
			result = -1;
		}

		return new ModelAndView("ajaxView", "ajaxData", result);
	}


	/**
	 * 범죄인지에 의한 사건번호 생성및 사건 정보 업데이트
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateCaseSttusToGetCaseNo/")
	@ResponseBody
	public ModelAndView updateCaseSttusToGetCaseNo(HttpServletRequest request, ModelMap model) throws Exception  {

		HttpSession session = request.getSession();

		String esntlId = SimpleUtils.default_set( session.getAttribute("esntl_id").toString() );
		String    rcNo = request.getParameter("rcNo");					 	//접수번호

		HashMap<String, Object> map = new HashMap<String, Object>();

		map.put( "rc_no", rcNo);
		map.put( "esntl_id", esntlId); //사건번호가 없는 정식사건을 체크하기 위한 입력값  제거

		int result = 0;

		try {
			rcService.updateCaseSttusToGetCaseNo(map);
			result = 0;
		 } catch (Exception e) {
			result = -1;
		 }

		 return new ModelAndView("ajaxView", "ajaxData", result);
	}


	/**
	 * 사건 작성/변경/삭제 승인 요청
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateCaseConfmRequst/")
	@ResponseBody
	public ModelAndView updateCaseConfmRequst(HttpServletRequest request, ModelMap model) throws Exception  {

		HttpSession session = request.getSession();

		String  esntlId = SimpleUtils.default_set( session.getAttribute("esntl_id").toString() );
		String   deptCd = SimpleUtils.default_set( session.getAttribute("dept_cd").toString() );

		String rcNo = request.getParameter("rcNo");					 	//접수번호
		String rcSeCd = request.getParameter("rcSeCd");				 	//사건구분
		String progrsSttusCd = request.getParameter("progrsSttusCd");	//사건진행상태
		String sanctnId = request.getParameter("sanctnId");				//결재 ID

		String changeSeCd = request.getParameter("changeSeCd");		  	//변경 사건구분
		String changeProgrsCd = request.getParameter("changeProgrsCd"); //변경 진행 코드
		String confmJobSeCd = request.getParameter("confmJobSeCd");		//승인요청 사건구분
		String direction = request.getParameter("direction");			//접수진행방향

		int result = 0;

		try {

			HashMap<String, Object> map = new HashMap<String, Object>();

			String [] stableCodeArr = null;

			//승인업무 구분 처리
			if( "01382".equals(confmJobSeCd) ) {	//사건작성 : 01382
				stableCodeArr = stableRcCodeArr;
			} else if( "01383".equals(confmJobSeCd) || "01384".equals(confmJobSeCd) ){	//사건 구분변경 : 01383 / 사건삭제 : 01384

				//사건진행 방향에 대한 구분  정방향 : F(Forward), 역방향 : R(Reverse)
				if( null != direction && (direction.equals("R")|| "01384".equals(confmJobSeCd) )){
					stableCodeArr =new String[]{"02103", "02132", "02132"}; //접수완료/사건구분변경반려/사건삭제반려
				} else {
					stableCodeArr= new String[]{"02111", "02113"};			//임시종결/내사종결
				}
			}

			boolean booleanStable = false;
			for( int i = 0; i < stableCodeArr.length;  i++ ){
				if( progrsSttusCd.equals(stableCodeArr[i]) ){
					booleanStable = true;
					break;
				}
			}

			if( !booleanStable) {
				return new ModelAndView("ajaxView", "ajaxData", -2);
			}

			map.put( "esntl_id", esntlId  );	//작성자 ID
			map.put(  "dept_cd", deptCd	  );   	//작성 부서
			map.put(    "rc_no", rcNo	  );	//접수번호
			map.put( "rc_se_cd", rcSeCd	  );	//접수구분값은 앞으로 변경될 값을 넣어준다
			map.put("sanctn_id", sanctnId );	//결재 ID
			map.put( "progrs_sttus_cd", progrsSttusCd );//사건진행상태 코드에 변경될 진행코드를 mapping

			map.put( "requst_rc_se_cd", changeSeCd);	//요청접수 사건 구분
			map.put( "confm_job_se_cd", confmJobSeCd);	//승인요청 사건 구분

			rcService.insertCaseConfmReqst(map);

			//사건진행상태 코드에 변경될 진행코드에 mapping
			if( "01382".equals(confmJobSeCd) ){			//사건작성		- 승인상태코드
				map.put( "progrs_sttus_cd", "02102");	//접수승인요청	- 진행상태코드
			} else if( "01383".equals(confmJobSeCd) ){	//사건구분변경
				map.put( "progrs_sttus_cd", "02131");	//사건구분변경요청
			} else if( "01384".equals(confmJobSeCd) ){	//사건삭제
				map.put( "progrs_sttus_cd", "02141");	//사건삭제요청
			}

			rcService.updateRcTmprSttus(map);
			result = 0;
		 } catch (Exception e) {
			result = -1;
		 }

		 return new ModelAndView("ajaxView", "ajaxData", result);
	}


	/**
	 * 위반죄명코드로 죄명 다시 받아서 리턴
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping (value = "/selectVioltNmRemarkAjax/")
	@ResponseBody
	public ModelAndView selectVioltNmRemarkAjax (HttpServletRequest request) throws Exception {

		String violtCd = request.getParameter("violtCd");

		String violtNm = rcService.getVioltNmRemark(violtCd);	//접수사건의 상세정보

		return new ModelAndView("ajaxView", "ajaxData", violtNm);
	}


	/**
	 * 사건 진행상태 조회
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping (value = "/getCaseProgrsStatusAjax/")
	@ResponseBody
	public ModelAndView getCaseProgrsStatusAjax (HttpServletRequest request) throws Exception {

		String rcNo = "";

 		rcNo = request.getParameter("rcNo");

		String resultStatus = rcService.getCaseProgrsStatus(rcNo);

		return new ModelAndView("ajaxView", "ajaxData", resultStatus);
	}


	/**
	 * 위반사항 검색 팝업
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/violtMatterSearchPopup/")
	public String violtMatterSearchPopup (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HashMap<String, Object> cMap = new HashMap<String, Object>();

		cMap.put("upper_cd", "00011");
		model.addAttribute("progrsSttusList", cdService.getCdList(cMap));

		return "rc/pop/violtMatterSearch";
	}


	/**
	 * 임시접수 취소 요청 팝업
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping (value = "/tmprRcCanclRequestPopup/")
	public String tmprRcCanclRequestPopup (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HashMap<String, Object> cMap = new HashMap<String, Object>();

		cMap.put("upper_cd", "00011");
		model.addAttribute("progrsSttusList", cdService.getCdList(cMap));

		return "rc/pop/tmprRcCanclRequest";
	}


	/**
	 * 사건번호 당 대상자 목록
	 * @return List<HashMap>
	 * @exception Exception
	 */
	@RequestMapping (value = "/trgterList/")
	@ResponseBody
	public List<HashMap> trgterList (HttpServletRequest request) throws Exception {
		InvUtil commonUtil = InvUtil.getInstance();
		Map map = commonUtil.getParameterMapConvert(request);
    	List<HashMap> list = rcService.getTrgterList((HashMap<String, Object>)map);
    	list = commonUtil.getConvertUnderscoreNameGrid(list);
		return list;
	}


	/**
	 * 사건정보 조회
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getCaseInfoByFormBindAjax/")
	@ResponseBody
	public Map getCaseInfoByFormBindAjax(HttpServletRequest request, ModelMap model) throws Exception  {

		InvUtil commonUtil = InvUtil.getInstance();

   		String     rcNo = request.getParameter("hidRcNo");		//접수번호
		String   caseNo = request.getParameter("hidCaseNo");	//사건번호
		String   rcSeCd = request.getParameter("hidRcSeCd");	//사건번호

		HashMap<String, Object> map = new HashMap<String, Object>();

		map.put("rc_no", rcNo);
		map.put("case_no", caseNo);
		map.put("rc_se_cd", rcSeCd);

    	Map dtlMap = rcService.getCaseInfoByFormBindAjax(map);
    	dtlMap = commonUtil.getConvertUnderscoreName(dtlMap);

		return dtlMap;
	}

	/**
	 * 사건정보 수정 Ajax
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("/updateCaseInfoAjax/")
	public ModelAndView updateCaseInfoAjax(HttpServletRequest request) throws Exception {

        HttpSession session = request.getSession();
        InvUtil  commonUtil = InvUtil.getInstance();

    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

		HashMap aMap = (HashMap) commonUtil.getParameterMapConvert(request);	//request param Map형태로 변환

        String result = "1";

		try {
	    	HashMap<String, Object> map = new HashMap<String, Object>();

	    	aMap.put("esntl_id", esntl_id);

        	rcService.updateCaseInfo(aMap);	//사건정보 수정

		} catch (Exception e){
			result = "-1";
		}

    	HashMap<String, Object> ret = new HashMap<String, Object>();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}



	/**
	 * 사건정보 조회
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/getTargetInfoByFormBindAjax/")
	@ResponseBody
	public Map getTargetInfoByFormBindAjax(HttpServletRequest request, ModelMap model) throws Exception  {

		InvUtil commonUtil = InvUtil.getInstance();

   		String     rcNo = request.getParameter("hidRcNo");		//접수번호
		String   caseNo = request.getParameter("hidCaseNo");	//사건번호
		String   rcSeCd = request.getParameter("hidRcSeCd");	//사건번호
		String trgterSn = request.getParameter("hidTrgterSn");	//사건번호
		String progrsSttusCd = request.getParameter("hidProgrsSttusCd");//사건번호

		HashMap<String, Object> map = new HashMap<String, Object>();

		map.put("rc_no", rcNo);
		map.put("case_no", caseNo);
		map.put("rc_se_cd", rcSeCd);
		map.put("trgter_sn", trgterSn);
		map.put("progrs_sttus_cd", progrsSttusCd);

    	Map dtlMap = rcService.getTargetInfoByFormBindAjax(map);
    	dtlMap = commonUtil.getConvertUnderscoreName(dtlMap);

		return dtlMap;
	}


	/**
	 * 작성사건 승인요청
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertCaseConfmReqstAjax/")
	@ResponseBody
	public ModelAndView insertCaseConfmReqst(HttpServletRequest request, ModelMap model) throws Exception  {

		HttpSession session = request.getSession();

		String  esntlId = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String   deptCd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		String     rcNo = request.getParameter("rcNo");		//접수번호
		String   rcSeCd = request.getParameter("rcSeCd");	//사건구분
		String sanctnId = request.getParameter("sanctnId");	//결재 ID
		String progrsSttusCd = request.getParameter("progrsSttusCd");	//사건진행상태

		HashMap<String, Object> map = new HashMap<String, Object>();

		map.put(    "rc_no", rcNo );		//사건번호
		map.put(  "dept_cd", deptCd );   	//작성 부서
		map.put("sanctn_id", sanctnId);		//결재 ID
		map.put( "esntl_id", esntlId );		//작성자
		map.put( "requst_rc_se_cd", rcSeCd);//요청접수 사건 구분
		map.put( "confm_job_se_cd", rcSeCd);//승인요청 사건 구분

		int result = 0;

		try {
			rcService.insertCaseConfmReqst(map);
		} catch (Exception e) {
			result = -1;
		}

		return new ModelAndView("ajaxView", "ajaxData", result);
	}




	/**
	 * 첨부파일 업로드
	 * @param request
	 * @param param
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/uploadFile/")
	public ModelAndView uploadFile(MultipartHttpServletRequest request, @RequestParam Map<String, Object> param, ModelMap model) throws Exception {

		Utility utl = Utility.getInstance();
		HttpSession session = request.getSession();
	    String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		param.put("esntl_id", esntl_id);

		//권한체크 - 파일 사용여부
		List<MultipartFile> files = request.getFiles("txtFiles");

		String file_id = "";
		file_id = fileService.getFileID();

		//파일선별 및 업로드
		HashMap titleMap = new HashMap();
		titleMap.put("esntl_id", param.get("esntl_id"));
		String fileTitle = fileService.getUserTitle(titleMap);
		HashMap fMap = utl.parseFileInfo(files, file_id, formatList, esntl_id, fileTitle);

		int fileCount = 0;

		if(SimpleUtils.isStringInteger(fMap.get("fileCount").toString())){
			fileCount = Integer.parseInt(fMap.get("fileCount").toString());
		}

		//업로드 대상 유무
		if( fileCount > 0 ){
			fMap.put("regist_path", "사건접수");
			fileService.insertFile(fMap);
		}

		return new ModelAndView("ajaxView", "ajaxData", file_id);
	}


}
