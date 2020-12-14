package kr.go.nssp.utl;

import java.io.PrintWriter;
import java.nio.file.AccessDeniedException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.mber.service.MberService;
import kr.go.nssp.menu.service.MenuService;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class SessionCheck extends HandlerInterceptorAdapter {
	static final Logger log = LogManager.getLogger();

	AuthorManager authorManager = AuthorManager.getInstance();

	@Resource
    private MenuService menuService;

	@Resource
    private CdService cdService;

	@Resource
    private MberService mberService;

	/**
	 * 세션정보 체크
	 *
	 * @param request
	 * @return
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		//로그인없이 볼수 있는 페이지
		ArrayList<String> freeAccessUrls = new ArrayList<String>();
		freeAccessUrls.add("/member/login/");
		freeAccessUrls.add("/member/loginAjax/");
		freeAccessUrls.add("/member/findPopup/");
		freeAccessUrls.add("/member/findAjax/");
		freeAccessUrls.add("/member/faceTest/");
		freeAccessUrls.add("/member/actionCrtfctLogin/");
		freeAccessUrls.add("/member/actionGPKIreg/");
		freeAccessUrls.add("/member/actionGPKIjoinDN/");

		//faceLogin
		freeAccessUrls.add("/member/sessionCheckAjax/");
		freeAccessUrls.add("/member/faceLogin/");
		freeAccessUrls.add("/member/faceLoginAjax/");
		freeAccessUrls.add("/member/fingerLoginAjax/");
		freeAccessUrls.add("/member/fingerLogin/");

		//회원가입용
		freeAccessUrls.add("/member/joinPopup/");
		freeAccessUrls.add("/member/joinAjax/");
		freeAccessUrls.add("/member/getIdDplctAjax/");
		freeAccessUrls.add("/dept/deptFullListAjax/");
		freeAccessUrls.add("/dept/selectPopup/");
		freeAccessUrls.add("/juso/jusoPopup/");
		freeAccessUrls.add("/juso/jusoListAjax/");

		//권한관계 없이 볼수 있는 페이지
		ArrayList<String> defaultAccessUrls = new ArrayList<String>();
		defaultAccessUrls.add("/main/intro/");
		defaultAccessUrls.add("/main/noticePopup/");

		//로그인
		defaultAccessUrls.add("/member/login/");
		defaultAccessUrls.add("/member/logoutAction/");

		//개인정보수정
		defaultAccessUrls.add("/member/updateSelf/");
		defaultAccessUrls.add("/member/updateSelfAjax/");
		defaultAccessUrls.add("/member/changePwPopup/");
		defaultAccessUrls.add("/member/changePwAjax/");

		//코드, 부서, 검찰, 경찰
		defaultAccessUrls.add("/cd/cdListAjax/");
		defaultAccessUrls.add("/cd/cdFullJsonAjax/");
		defaultAccessUrls.add("/cd/cdGridListAjax/");
		defaultAccessUrls.add("/dept/deptFullListAjax/");
		defaultAccessUrls.add("/exmn/exmnFullListAjax/");
		defaultAccessUrls.add("/violt/violtFullListAjax/");
		defaultAccessUrls.add("/violt/violtFullJsonAjax/");
		defaultAccessUrls.add("/violt/violtDetailAjax/");
		defaultAccessUrls.add("/violt/violtListAjax/");

		defaultAccessUrls.add("/cd/selectPopup/");
		defaultAccessUrls.add("/dept/selectPopup/");
		defaultAccessUrls.add("/exmn/selectPopup/");
		defaultAccessUrls.add("/violt/selectPopup/");
		defaultAccessUrls.add("/polc/selectPopup/");

		//주소검색
		defaultAccessUrls.add("/juso/jusoPopup/");
		defaultAccessUrls.add("/juso/jusoListAjax/");

		//사용자검색 팝업
		defaultAccessUrls.add("/member/selectPopup/");
		defaultAccessUrls.add("/member/userFullListAjax/");

		//내사건목록
		defaultAccessUrls.add("/inv/myCaseListPopup/");
		defaultAccessUrls.add("/inv/myCaseListAjax/");
		defaultAccessUrls.add("/inv/myCaseTrgterListPopup/");

		//사건상세보기
		defaultAccessUrls.add("/inv/caseDtlPopup/");
		defaultAccessUrls.add("/alot/historyPopup/");
		defaultAccessUrls.add("/alot/historyAjax/");
		defaultAccessUrls.add("/inv/sugestHistoryPopup/");
		defaultAccessUrls.add("/inv/sugestHistoryAjax/");
		defaultAccessUrls.add("/trn/trnInfoPopup/");
		defaultAccessUrls.add("/trn/trnCaseListPopAjax/");
		defaultAccessUrls.add("/trn/trnSuspctListPopAjax/");
		defaultAccessUrls.add("/trn/trnVioltListPopAjax/");
		defaultAccessUrls.add("/inv/atendPopup/");
		defaultAccessUrls.add("/inv/zrlongPopup/");
		defaultAccessUrls.add("/inv/zrlongPopupLstAjax/");
		defaultAccessUrls.add("/inv/atendPopupLstAjax/");
		defaultAccessUrls.add("/ccc/caseInfoPopup/");		/*main 좌측 사건조회*/
		defaultAccessUrls.add("/ccc/caseInfoListAjax/");

		//엑셀생성
		defaultAccessUrls.add("/cmm/excel/");

		//파일관련
		defaultAccessUrls.add("/file/imageListPopup/");
		defaultAccessUrls.add("/file/fileListIframe/");
		defaultAccessUrls.add("/file/fileListOwnerIframe/");
		defaultAccessUrls.add("/file/fileDetailPopup/");
		defaultAccessUrls.add("/file/deleteAjax/");
		defaultAccessUrls.add("/file/getFileBinary/");
		defaultAccessUrls.add("/file/getImageBinary/");
		defaultAccessUrls.add("/file/getStreamBinary/");
		defaultAccessUrls.add("/file/getImageBinary/");
		defaultAccessUrls.add("/file/getStreamBinary/");

		//리포트관련
		defaultAccessUrls.add("/doc/reportAddPopup/");
		defaultAccessUrls.add("/doc/reportAddAjax/");
		defaultAccessUrls.add("/doc/reportUpdateAjax/");
		defaultAccessUrls.add("/doc/reportDelAjax/");
		defaultAccessUrls.add("/doc/reportListAjax/");
		defaultAccessUrls.add("/doc/reportListOwnerAjax/");
		defaultAccessUrls.add("/doc/reportViewPopup/");
		defaultAccessUrls.add("/doc/reportInputPopup/");
		defaultAccessUrls.add("/doc/reportListIframe/");
		defaultAccessUrls.add("/doc/reportListOwnerIframe/");
		defaultAccessUrls.add("/doc/reportJson/");
		defaultAccessUrls.add("/doc/reportCaseListPopup/");
		defaultAccessUrls.add("/doc/reportCaseListAjax/");
		defaultAccessUrls.add("/doc/docFilePopup/");
		defaultAccessUrls.add("/doc/uploadFile/");
		defaultAccessUrls.add("/doc/docFileListAjax/");

		//한글서식
		defaultAccessUrls.add("/doc/hwpctrlPopup/");
		defaultAccessUrls.add("/doc/hwpctrlIframe/");
		defaultAccessUrls.add("/doc/hwpctrlmain/");
		defaultAccessUrls.add("/doc/hwpctrlmainIframe/");
		defaultAccessUrls.add("/doc/saveHwpctrlAjax/");
		defaultAccessUrls.add("/doc/selectHwpctrlAjax/");
		defaultAccessUrls.add("/doc/selectHwpctrlMultiAjax/");
		defaultAccessUrls.add("/doc/selectHwpctrlPreviewAjax/");
		defaultAccessUrls.add("/doc/hwpctrlPreviewPopup/");

		//bbs
		defaultAccessUrls.add("/bbs/addAction/");
		defaultAccessUrls.add("/bbs/disableAction/");
		defaultAccessUrls.add("/bbs/cmntListAjax/");
		defaultAccessUrls.add("/bbs/cmntDetailAjax/");
		defaultAccessUrls.add("/bbs/cmntAddAjax/");
		defaultAccessUrls.add("/bbs/cmntUpdateAjax/");
		defaultAccessUrls.add("/bbs/cmntDisableAjax/");
		defaultAccessUrls.add("/bbs/othbcPwPopup/");

		//부서소속원
		defaultAccessUrls.add("/member/userListComboAjax/");

		//승인
		defaultAccessUrls.add("/sanctn/historyPopup/");
		defaultAccessUrls.add("/sanctn/historyAjax/");

		//배당
		defaultAccessUrls.add("/alot/userListAjax/");
		defaultAccessUrls.add("/alot/alotPopup/");
		defaultAccessUrls.add("/alot/alotAjax/");

		//보고서 승인
		defaultAccessUrls.add("/rc/reprtConfmRequestAjax/");
		defaultAccessUrls.add("/rc/updateCaseSttusToGetCaseNo/");

		if(!authorManager.is()){
			setAuthorInfo();
		}

		String uri = request.getServletPath();

		//비로그인
		if (request.getSession().getAttribute("esntl_id") == null) {
			if(freeAccessUrls.contains(uri)){
				return true;
			}else{
				//세션없을시 페이지 종류별 분기처리
				if(uri.contains("Iframe")){
					//iframe 부모창 로그인 이동
					PrintWriter writer = response.getWriter();
					writer.println("<script>parent.location.href='/member/login/';</script>");
				}else if(uri.contains("Popup")){
					//Popup 부모창 로그인 이동
					PrintWriter writer = response.getWriter();
					writer.println("<script>parent.location.href='/member/login/';</script>");
				}else if(uri.contains("Ajax")){
					//ajax 액션X
				}else if(uri.contains("Json")){
					//json 액션X
				}else{
					//로그인 이동
					response.sendRedirect("/member/login/");
				}
				return false;
			}
		//로그인
		}else{

	        String clientIP = request.getRemoteAddr();

			//공통화면 체크
			if(defaultAccessUrls.contains(uri)){
				return true;
			}

			//권한그룹 확인
			String authorCd = (String) request.getSession().getAttribute("author_cd");
			HashMap urlInfo = authorManager.getUrl(authorCd, uri);
			if(urlInfo != null){
				//로그에서 ajax 제외
				if(!uri.contains("Ajax")){
		        	//접근로그
		        	HashMap log = new HashMap();
		        	log.put("esntl_id", request.getSession().getAttribute("esntl_id"));
		        	log.put("menu_cd", urlInfo.get("MENU_CD"));
		        	log.put("acces_url", uri);
		        	log.put("acces_ip", clientIP);
					mberService.addAccesLog(log);
				}
				return true;
			}else{
	            throw new AccessDeniedException("권한이 없습니다.");
				//return true;
			}
		}

	}


	public static String getUserIp(){
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String ip = request.getHeader("X-FORWARDED-FOR");
		if (ip == null) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}

	public void setAuthorInfo() throws Exception {
        HashMap map = new HashMap();
        map.put("use_yn", "Y");
    	List<HashMap> authorList = menuService.getAuthorClList(map);
    	for(HashMap result : authorList){
    		String author_cd = (String) result.get("AUTHOR_CD");

    		//권한별 url정보
        	HashMap sMap = new HashMap();
        	sMap.put("author_cd", author_cd);
        	List<HashMap> urlList = menuService.getAuthorChck(sMap);
    		for(HashMap urlInfo : urlList){
    			String relate_url = (String) urlInfo.get("RELATE_URL");
    	    	authorManager.setUrl(author_cd, relate_url, urlInfo);
    		}

    		//권한별 메뉴정보
        	List<HashMap> menuClList = menuService.getMenuClChck(sMap);
    		for(HashMap clInfo : menuClList){
    			String menu_cl_cd = (String) clInfo.get("MENU_CL_CD");
    			clInfo.put("AUTHOR", author_cd+"_"+menu_cl_cd);
    	    	authorManager.setMenuCl(author_cd, menu_cl_cd, clInfo);  //MENU_CL_CD, MENU_CL_NM, MENU_URL

    			sMap.put("menu_cl_cd", menu_cl_cd);
    	    	List<HashMap> menuList = menuService.getMenuChck(sMap);
    	    	authorManager.setMenu(author_cd, menu_cl_cd, menuList);
    		}
    	}
		authorManager.complete();
	}
}
