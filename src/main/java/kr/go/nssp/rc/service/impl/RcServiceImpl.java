package kr.go.nssp.rc.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.alot.service.impl.AlotDAO;
import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.cmmn.service.FileService;
import kr.go.nssp.inv.service.impl.PrsctDAO;
import kr.go.nssp.rc.service.RcService;
import kr.go.nssp.sanctn.service.SanctnService;
import kr.go.nssp.sanctn.service.impl.SanctnDAO;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;
import kr.go.nssp.utl.egov.EgovProperties;


@Service("RcService")
public class RcServiceImpl implements RcService {

	@Resource(name = "rcDAO")
	private RcDAO rcDAO;

	@Resource(name = "alotDAO")
	private AlotDAO alotDAO;

	@Resource(name = "prsctDAO")
	private PrsctDAO prsctDAO;
	
	@Resource(name = "sanctnDAO")
	private SanctnDAO sanctnDAO;
	
	@Autowired
	private DocService docService;

	@Autowired
	private FileService fileService;
	
	@Autowired
	private SanctnService sanctnService;

	//사건 목록 조회
	@Override
	public List<HashMap<String, Object>> getCaseList(HashMap<String, Object> map) throws Exception {
		return rcDAO.selectCaseList(map);
	}
	
	//사건정보 조회 form bind 
	@Override
	public HashMap<String, Object> getCaseInfoByFormBindAjax (HashMap<String, Object> map) throws Exception {

		return rcDAO.selectCaseInfoByFormBind(map);
	}
	
	//대상자 정보 조회 form bind
	@Override
	public HashMap<String, Object> getTargetInfoByFormBindAjax (HashMap<String, Object> map) throws Exception {

		return rcDAO.selectTargetInfoByFormBind(map);
	}

	//사건 등록
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public HashMap<String, Object> saveRcTmpr( Map<String, Object> param)  throws Exception {

		int returnVal = 0;
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();

		InvUtil commonUtil = InvUtil.getInstance();

		HashMap caseMap = (HashMap)commonUtil.getMapToMapConvert((HashMap) param.get("caseFormData"));

		String   rcNo = rcDAO.selectRcNo();	//접수번호

		caseMap.put( "esntl_id", param.get("esntl_id"));
		caseMap.put( "writng_dept_cd", param.get("writng_dept_cd"));
		caseMap.put( "rc_no", rcNo);

		String rcSeCd = "";

		if( null != caseMap.get("rc_se_cd") ) {
			rcSeCd = caseMap.get("rc_se_cd").toString();
		} else {
			rcSeCd = caseMap.get("rc_se_cd_sub").toString();
		}

		caseMap.put(   "rc_se_cd", rcSeCd );
		caseMap.put( "charger_id", caseMap.get("esntl_id") );

		rtnMap.put( "chargerId", caseMap.get("esntl_id") );

		/*
		 * old
		 * 각 사건 유형별 접수시 임시/내사/정식 사건의 번호 생성
		 * new (2019.07.26)
		 * 사건접수시 임시번호 또는 내사번호를 생성하지 않는다. 
		 * 각 사건의 승인이 이루어진 후 사건번호가 생성된다.  
		 */
		
		if( "F".equals( rcSeCd ) ) {		//정식사건
			caseMap.put("progrs_sttus_cd", "02103");
		} else if( "I".equals( rcSeCd ) ) {	//내사사건

			/* old
			 * itivNo = rcDAO.selectItivNo();
			 * 
			 * rtnMap.put("itivNo", itivNo); 
			 * caseMap.put("itiv_no", itivNo);
			 * caseMap.put("progrs_sttus_cd", "00210"); 
			 * caseMap.put("doc_id", docService.getDocID());
			 * 
			 * rcDAO.insertRcItiv(caseMap);
			 */

			caseMap.put( "progrs_sttus_cd", "02101" );
			
		} else if( "T".equals( rcSeCd ) ) {	//임시사건
			caseMap.put( "progrs_sttus_cd", "02101" );
		}

		if( null != caseMap.get("case_sumry")) {
			caseMap.put( "case_sumry" , caseMap.get("case_sumry").toString().replace("\r\n","<br>") );
		}
		if( null != caseMap.get("crmnl_fact")) {
			caseMap.put( "crmnl_fact" , caseMap.get("crmnl_fact").toString().replace("\r\n","<br>") );
		}
		if( null != caseMap.get("prf_dta")) {
			caseMap.put( "prf_dta" , caseMap.get("prf_dta").toString().replace("\r\n","<br>") );
		}
		if( null != caseMap.get("etc_cn")) {
			caseMap.put( "etc_cn" , caseMap.get("etc_cn").toString().replace("\r\n","<br>") );
		}
		
		caseMap.put("doc_id", docService.getDocID());	//문서 ID생성

		
		if( "F".equals( rcSeCd ) ) {			//정식사건은 배당자 등록
			caseMap.put(   "alot_se_cd", "A" );	//A: 담당자 배당 완료 코드
			caseMap.put( "alot_user_id", caseMap.get("esntl_id") );		  //배당받은자 ID
			caseMap.put( "alot_dept_cd", caseMap.get("writng_dept_cd") ); //배당받은자 부서 코드
			//caseMap.put(      "case_no", prsctDAO.selectCaseNo());	  //사건번호 채번 2020.07.28 정식사건으로 접수시 승인후 채번하는것으로 변경
			
			caseMap.put( "regist_path", "정식사건 접수" );
			caseMap.put( "dept_cd", caseMap.get("writng_dept_cd") );
			
			alotDAO.insertRcTmprAlot(caseMap);	// 배당 테이블 등록
			
			caseMap.put( "confm_job_se_cd", "01386"); // 승인업무구분 - 입건 (01386)
			insertCaseConfmReqst(caseMap);	          // 정식사건 승인요청
		}
		
		rcDAO.insertRcTmpr(caseMap);			//접수사건 등록

		//위반사항
		String violtCd = caseMap.get("violt_cd").toString();

		if( violtCd != null && violtCd.length() > 0 ) {

			String[] violtCdArr = violtCd.split("/");

			for( int i=0; i < violtCdArr.length; i++ ) {

				caseMap.put( "violt_cd", violtCdArr[i].toString() );
				rcDAO.insertRcTmprViolt(caseMap);	//위반사항 등록
			}
		}

		List targetList = (List) param.get("grdTargetList");

		//대상자 등록
		for( Object o : targetList ) {
			if( o != null ) {
				Map tMap = (HashMap) o;
				if( tMap != null ) {
					tMap = commonUtil.getMapToMapConvert(tMap);

					tMap.put(    "rc_no", rcNo );
					tMap.put( "esntl_id", param.get("esntl_id") );
					tMap.put(   "doc_id", docService.getDocID() ); 	//문서번호
					tMap.put(  "file_id", fileService.getFileID() );//파일ID
					rcDAO.insertRcTmprTrgter(tMap);	//대상자 등록

					returnVal++;
				}
			}
		}

		rtnMap.put(     "rcNo", rcNo );
		rtnMap.put(   "rcSeCd", rcSeCd );
		rtnMap.put("returnVal", returnVal );

		return rtnMap;
	}


	//사건 접수 상세
	@Override
	public HashMap<String, Object> getCaseInfo(HashMap<String, Object> map)  throws Exception {
		return rcDAO.selectCaseInfo(map);
	}
	
	//사건 진행 상태 조회
	@Override
	public String getCaseProgrsStatus(String param)  throws Exception {
		return rcDAO.selectCaseProgrsStatus(param);
	}
	
	//내사착수여부조회
	@Override
	public String getOutsetReportYN(String param)  throws Exception {
		return rcDAO.selectOutsetReportYN(param);
	}

	//접수 번호 조회
	@Override
	public String getRcNo() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	
	//위반죄명 조회
	@Override
	public String getVioltNmRemark(String param) throws Exception {
		// TODO Auto-generated method stub
		return rcDAO.selectVioltNmRemark(param);
	}

	//접수 구분 업데이트
	@Override
	public void updateReceiptSection(HashMap<String, Object> map) throws Exception {

		rcDAO.updateReceiptSection(map);	//접수구분 수정
		//rcDAO.insertRcTmprHistory(map);	//이력 등록
	}

	//전체 사건 목록 조회
	@Override
	public List<HashMap<String, Object>> getCaseListAll(HashMap<String, Object> map) throws Exception {
		return rcDAO.selectCaseListAll(map);
	}
	
	//부서 담당자 조회
	@Override
	public List<HashMap<String, Object>> getDeptChargerList(HashMap<String, Object> map) throws Exception {
		return rcDAO.selectDeptChargerList(map);	
	}

	//내사결과 등록
	@Override
	public void insertRcItivOutset(HashMap<String, Object> map) throws Exception {
   		rcDAO.insertRcItivOutset(map);	//내사착수 등록
	}

	//내사결과 등록
	@Override
	public void insertRcItivResult(HashMap<String, Object> map) throws Exception {
		rcDAO.insertRcItivResult(map);	//내사착수 등록
	}

	// 내사착수 승인요청
	@Override
	public void updateRcItivOutset(HashMap<String, Object> map) throws Exception {
   		rcDAO.updateRcItivOutset(map);
	}

	//내사결과 승인요청
	@Override
	public void updateRcItivResult(HashMap<String, Object> map) throws Exception {
   		
		rcDAO.updateRcItivResult(map);
	}

	//사건진행상태 업데이트
	@Override
	public void updateRcTmprSttus(HashMap<String, Object> map) throws Exception {
		rcDAO.updateRcTmprSttus(map);
	}
	
	//내사착수 승인정보 조회
	@Override
	public HashMap<String, Object> getRcItivOutset(HashMap<String, Object> map)  throws Exception {

		return rcDAO.selectRcItivOutset(map);
	}

	//getRcItivResult
	@Override
	public HashMap<String, Object> getRcItivResult(HashMap<String, Object> map)  throws Exception {
		return rcDAO.selectRcItivResult(map);
	}
	
	//임시번호로 사건정보 조회
	@Override
	public HashMap<String, Object> getCaseInfoByTmprNo(HashMap<String, Object> map)  throws Exception {
		return rcDAO.selectCaseInfoByTmprNo(map);
	}

	//대상자 목록 조회
	@Override
	public List<HashMap> getTrgterList(HashMap<String, Object> map) throws Exception {

		return rcDAO.selectTrgterList(map);
	}

	//사건정보 수정
	@Override
	public void updateCaseInfo(HashMap<String, Object> map) throws Exception {

		//발생 시작일/발생종료일 처리
		String occrrnc_begin_dt = map.get("occrrnc_begin_de").toString()+map.get("occrrnc_begin_de_hh").toString()+map.get("occrrnc_begin_de_mi").toString();;
		String occrrnc_end_dt = map.get("occrrnc_end_de").toString() +map.get("occrrnc_end_de_hh").toString()+map.get("occrrnc_end_de_mi").toString();;
		
		if( occrrnc_begin_dt.length() > 0 ){
			map.put("occrrnc_begin_dt", occrrnc_begin_dt);
		}
		
		if( occrrnc_end_dt.length() > 0 ){
			map.put("occrrnc_end_dt", occrrnc_end_dt);
		}

		rcDAO.updateCaseInfo(map);

		//위반사항
		String violtCd = "";

		if( null != map.get("violt_cd") ){
			
			violtCd = map.get("violt_cd").toString();

			if( violtCd.length() > 0 ){

				String[] violtCdArr=violtCd.split("/");

				rcDAO.deleteRcTmprViolt(map);	//위반사항 등록

				for( int i=0; i < violtCdArr.length; i++ ){

					map.put( "violt_cd", violtCdArr[i].toString() );
					rcDAO.insertRcTmprViolt(map);	//위반사항 등록
				}
			}
		}
	}

	//대상자 정보 수정
	@Override
	public void updateTargetInfo(HashMap<String, Object> map) throws Exception {

		if( null == map.get("sexdstn_cd") || "".equals(map.get("sexdstn_cd").toString()) ){ 	//성별코드 없을 경우 불상 처리
			map.put("sexdstn_cd", "U");
		}
		
		if( null == map.get("agent_se_cd") || "".equals(map.get("agent_se_cd").toString()) ){	//대리인 없음 선택시 대리인정보 null 처리
			map.put( "agent_nm", "" );
			map.put("agent_tel", "" );
		}
		
		rcDAO.updateTargetInfo(map);
	}

	//대상자 serial number 조회
	@Override
	public HashMap<String, Object> getSnNoDetail (HashMap<String, Object> map) throws Exception {
		return rcDAO.selectSnNoDetail(map);
	}

	//대상자 등록
	@Override
	public int insertRcTmprTrgter(HashMap<String, Object> map) throws Exception {
		map.put( "doc_id", docService.getDocID()  ); 
		map.put("file_id", fileService.getFileID()); 
		return rcDAO.insertRcTmprTrgter(map);	//대상자 등록
	}

	//대상자 삭제
	@Override
	public void deleteTargetInfo(HashMap<String, Object> map) throws Exception {
		rcDAO.deleteTargetInfo(map);	//대상자 등록
	}
	
	//작성사건  승인요청
	@Override
	public void insertCaseConfmReqst(HashMap<String, Object> param) throws Exception {
		
		//결재ID 유무 확인
		if( null == param.get("sanctn_id") || "" == param.get("sanctn_id") ){
			
			//최초요청
			String sanctnId = sanctnDAO.selectSanctnID(param);
			param.put("sanctn_id", sanctnId);
			sanctnDAO.insertSanctn(param);
			rcDAO.updateRcTemprSanctn (param);		//결재ID/사건 진행상태 update
		} else {
			//요청자, 요청일시 업데이트
			sanctnDAO.updateSanctn(param);
		}
		
		param.put("sttus_cd", EgovProperties.getProperty("Globals.SttusSanctnWait"));	//승인대기
		
		sanctnDAO.insertSanctnConfm(param);
 	}
	
	//정식사건으로 정보 업데이트
	@SuppressWarnings({ "static-access", "unchecked", "rawtypes" })
	@Override
	public void updateCaseToF(HashMap<String, Object> result) throws Exception {
		Utility utl = Utility.getInstance();
		
		String progrs_sttus_cd = utl.nvl( result.get("progrs_sttus_cd") );
		String case_end_se_change_cd = utl.nvl( result.get("case_end_se_change_cd") );
		String esntlId = utl.nvl( result.get("esntl_id") );
		
		HashMap param = new HashMap();
		
		param.put( "rc_no", utl.nvl( result.get("rc_no") ) );
		param.put( "progrs_sttus_cd", progrs_sttus_cd);
		param.put( "esntl_id", esntlId );
		param.put( "case_end_se_change_cd", case_end_se_change_cd ); //사건 종결코드 범죄인지보고 구분값으로 사용
		param.put( "trgter_se_cd", "00697" ); //피의자
			
		//사건진행상태 및 번호 채번은 인지보고서 작성시  -> 변경로직 사건진행상태만 변경하고 사건번호는 승인시 채번한다.
		sanctnDAO.updateRcTmprForConfmF(param);
		sanctnDAO.updateRcTmprSuspctForSeCd(param);
	}
	
	//작성사건  승인요청
	@SuppressWarnings({ "unchecked", "static-access" })
	@Override
	public void updateCaseSttusToGetCaseNo(HashMap<String, Object> result) throws Exception {
		Utility utl = Utility.getInstance();
		
		String esntlId = utl.nvl(result.get("esntl_id"));
		
		HashMap param = new HashMap();
		
		param.put( "esntl_id", esntlId );
		param.put(    "rc_no", utl.nvl(result.get("rc_no")) );
		param.put(  "case_no", prsctDAO.selectCaseNo() ); //사건번호 생성
		param.put(    "prsct", "Y" );					   //xml에서 사건번호 업데이트 구분하기 위한 구분자	
		param.put( "case_end_se_change_cd", "" ); 	   //사건번호가 없는 정식사건을 체크하기 위한 입력값  제거
			
		//사건진행상태 및 번호 채번은 인지보고서 작성시 
		sanctnDAO.updateRcTmprForConfmF( param );
	}
	
	
	//승인ID조회
	@Override
	public String getSanctnId(String param)  throws Exception {
		return rcDAO.selectSanctnId(param);
	}
	
	
	//착수승인 여부 조회
	@Override
	public HashMap<String, String> getOutsetConfmYN(String param)  throws Exception {
		return rcDAO.selectOutsetConfm(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.rc.service.RcService#updateDe(java.util.HashMap)
	 */
	@Override
	public int updateDe(Map<String, Object> map) throws Exception {
		return rcDAO.updateDe(map);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.rc.service.RcService#updateOutsetReportDt(java.util.Map)
	 */
	@Override
	public int updateOutsetReportDt(Map<String, Object> param) throws Exception {
		return rcDAO.updateOutsetReportDt(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.rc.service.RcService#updateItivResultRerortDt(java.util.Map)
	 */
	@Override
	public int updateItivResultRerortDt(Map<String, Object> param) throws Exception {
		return rcDAO.updateItivResultRerortDt(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.rc.service.RcService#insertTrgterChghst(java.util.Map)
	 */
	@Override
	public void insertTrgterChghstLog(Map<String, Object> param) throws Exception {
		rcDAO.insertTrgterChghstLog(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.rc.service.RcService#selectTrgterChghst(java.util.Map)
	 */
	@Override
	public List<Map<String, Object>> selectTrgterChghstLog(Map<String, Object> param) throws Exception {
		return rcDAO.selectTrgterChghstLog(param);
	}
}
