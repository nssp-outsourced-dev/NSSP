package kr.go.nssp.main.web;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.*;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.go.nssp.utl.SimpleUtils;
import kr.go.nssp.bbs.service.BbsService;
import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.rc.service.RcService;
import kr.go.nssp.stats.service.StatsService;
import kr.go.nssp.utl.AuthorManager;
import kr.go.nssp.utl.egov.EgovProperties;

@Controller
@RequestMapping(value = "/main/")
public class MainController {

	@Resource
	private RcService rcService;	//사건접수관련 서비스

	@Resource
    private BbsService bbsService;

	@Resource
    private StatsService statsService;

    @RequestMapping(value="/intro/")
    public String intro(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		HashMap<String, Object> pMap = new HashMap<String, Object>();
		pMap.put("startRow", 0);
		pMap.put("endRow", 10);
		pMap.put("esntl_id", esntl_id ); //배당자 ID
		pMap.put("dept_cd", dept_cd ); //배당자 ID

		//접수==>정식사건접수(00223)
		//입건==>수사지휘건의(00230)
		//영장==>송치준비중(00240)
		//송치==>송치완료(00242)
    	HashMap caseSttus = statsService.geCaseSttusSum(pMap);		//사건 현황(접수사건 제외)
    	HashMap rcCaseSttus = statsService.getRcCaseSttusSum(pMap); //접수사건 현황

    	caseSttus.putAll(rcCaseSttus);
   		//F : 정식사건
	  	//T : 임시사건
	  	//I : 내사사건
    	//System.out.println("dddd:::999");
		List<HashMap<String, Object>> caseAList = rcService.getCaseListAll(pMap);

		pMap.put("rc_se_cd", "F" );	//접수 구분 코드
		List<HashMap<String, Object>> caseFList = rcService.getCaseList(pMap);

		pMap.put("rc_se_cd", "T" );	//접수 구분 코드
		List<HashMap<String, Object>> caseTList = rcService.getCaseList(pMap);

		pMap.put("rc_se_cd", "I" );	//접수 구분 코드
		List<HashMap<String, Object>> caseIList = rcService.getCaseList(pMap);

		model.addAttribute("caseSttus", caseSttus);
		model.addAttribute("caseAList", caseAList);
		model.addAttribute("caseFList", caseFList);
		model.addAttribute("caseTList", caseTList);
		model.addAttribute("caseIList", caseIList);

        //공지사항
		HashMap bMap = new HashMap();
    	bMap.put("bbs_id", "00000000000000000001");
    	bMap.put("startRow", 0);
    	bMap.put("endRow", 3);
    	List<HashMap> noticeList = bbsService.getBbsList(bMap);

        //업무알림
    	bMap.put("bbs_id", "00000000000000000002");
    	bMap.put("startRow", 0);
    	bMap.put("endRow", 3);
    	List<HashMap> workList = bbsService.getBbsList(bMap);
    	
    	//문의사항
    	bMap.put("bbs_id", "00000000000000000003");
    	bMap.put("startRow", 0);
    	bMap.put("endRow", 3);
    	List<HashMap> qnaList = bbsService.getBbsList(bMap);
    	
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("workList", workList);
        model.addAttribute("qnaList", qnaList);

        return "main/intro";
    }

}
