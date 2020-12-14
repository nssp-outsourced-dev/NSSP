package kr.go.nssp.sanctn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.cmmn.service.impl.FileDAO;
import kr.go.nssp.inv.service.impl.PrsctDAO;
import kr.go.nssp.rc.service.impl.RcDAO;
import kr.go.nssp.sanctn.service.SanctnService;
import kr.go.nssp.utl.Utility;
import kr.go.nssp.utl.egov.EgovProperties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("SanctnService")
public class SanctnServiceImpl implements SanctnService {

	//진행상태
	private String   STTUS_SANCTN_WAIT = EgovProperties.getProperty("Globals.SttusSanctnWait");	 //승인대기
	private String  STTUS_SANCTN_COMPT = EgovProperties.getProperty("Globals.SttusSanctnCompt"); //승인완료
	private String STTUS_SANCTN_RETURN = EgovProperties.getProperty("Globals.SttusSanctnReturn");//반려

	@Resource(name = "sanctnDAO")
	private SanctnDAO sanctnDAO;

	@Resource(name = "fileDAO")
	private FileDAO fileDAO;

	@Resource(name = "prsctDAO")
	private PrsctDAO prsctDAO;
	
	@Resource(name = "rcDAO")
	private RcDAO rcDAO;

	@Autowired
	private DocService docService;

	/**
	 * 승인요청
	 *   sanctn_id : 승인 ID - 2번째 이후만
	 * regist_path : 작성 경로
	 *    esntl_id : 승인요청자 ID
	 *     dept_cd : 승인요청 부서
	 */
	public String insertSanctn(HashMap map) throws Exception {
		HashMap result = sanctnDAO.selectSanctnManageDetail(map);
		String sanctn_id = "";
		if(result == null){
			//최초요청
			sanctn_id = sanctnDAO.selectSanctnID(map);
			map.put("sanctn_id", sanctn_id);
			sanctnDAO.insertSanctn(map);
		}else{
			//2번째이후
			sanctn_id = (String) map.get("sanctn_id");
			//요청자, 요청일시 업데이트
			sanctnDAO.updateSanctn(map);
		}
		map.put("sttus_cd", STTUS_SANCTN_WAIT);
		sanctnDAO.insertSanctnConfm(map);
		return sanctn_id;
	}

	public void updateSanctn(HashMap map) throws Exception {
		sanctnDAO.updateSanctn(map);
	}

	public List<HashMap> getSanctnHistory(HashMap map) throws Exception {
		return sanctnDAO.selectSanctnHistory(map);
	}

	public List<HashMap> getRcTmprList(HashMap map) throws Exception {
		return sanctnDAO.selectRcTmprList(map);
	}

	public HashMap getRcTmprDetail(HashMap map) throws Exception {
		return sanctnDAO.selectRcTmprDetail(map);
	}

	public HashMap selectRcItivResultInfo(HashMap map) throws Exception {
		return sanctnDAO.selectRcItivResultInfo(map);
	}

	public HashMap selectInvAditPrsctInfo(HashMap map) throws Exception {
		return sanctnDAO.selectInvAditPrsctInfo(map);
	}

	public HashMap selectInvPrsctCanclInfo(HashMap map) throws Exception {
		return sanctnDAO.selectInvPrsctCanclInfo(map);
	}

	public HashMap selectTrnCaseInfo(HashMap map) throws Exception {
		return sanctnDAO.selectTrnCaseInfo(map);
	}

	public HashMap selectRcTmprInfo(HashMap map) throws Exception {
		return sanctnDAO.selectRcTmprInfo(map);
	}


	public void updateRcTmpr(HashMap map) throws Exception {
		Utility utl = Utility.getInstance();
		String[] sanctn_id_arr = (String[]) map.get("sanctn_id_arr");
		String sttus_cd = utl.nvl( map.get("sttus_cd") );
		String esntl_id = utl.nvl( map.get("esntl_id") );

		for(String sanctn_id:sanctn_id_arr) {
			HashMap input = new HashMap();
			input.putAll(map);
			input.put("sanctn_id", sanctn_id);
			HashMap result = sanctnDAO.selectRcTmprDetail(input);

			/**
			 * 00205 내사착수 승인요청
			 * 00211 내사착수
			 * 00212 내사착수 반려
			 */
			if(result != null){
				String progrs_sttus_cd = utl.nvl(result.get("PROGRS_STTUS_CD"));
				if("00205".equals(progrs_sttus_cd)){
					//승인
					if(sttus_cd.equals(STTUS_SANCTN_COMPT)){
						sanctnDAO.updateSanctnConfm(input);

						//승인 종결처리
						String rc_no = utl.nvl(result.get("RC_NO"));
						HashMap proc = new HashMap();
						proc.put("rc_no", rc_no);
						proc.put("esntl_id", esntl_id);
						proc.put("progrs_sttus_cd", "00211");
						sanctnDAO.updateRcTmpr(proc);
						
						/*  */
						rcDAO.updateRcItivOutsetDt(proc);
						
						//승인완료시 마스터에 업데이트 기록
						sanctnDAO.updateSanctn(input);
					//반려
					}else{
						//반려의견 적용
						sanctnDAO.updateSanctnConfm(input);

						String rc_no = utl.nvl(result.get("RC_NO"));
						HashMap proc = new HashMap();
						proc.put("rc_no", rc_no);
						proc.put("esntl_id", esntl_id);
						proc.put("progrs_sttus_cd", "00212");
						sanctnDAO.updateRcTmpr(proc);

					}
				}
			}

		}
	}

	// 내사결과
	public List<HashMap> selectItivResultList(HashMap map) throws Exception {
		return sanctnDAO.selectItivResultList(map);
	}

	public int confirmItivResult(HashMap map) throws Exception {
		Utility utl = Utility.getInstance();
		String[] sanctn_id_arr = (String[]) map.get("sanctn_id_arr");
		String sttus_cd = utl.nvl(map.get("sttus_cd"));
		String esntl_id = utl.nvl(map.get("esntl_id"));

		int re_cnt = 0;

		for(String sanctn_id:sanctn_id_arr) {
			HashMap input = new HashMap();
			input.putAll(map);
			input.put("sanctn_id", sanctn_id);
			System.out.println("### 내사결과 input : "+input);
			HashMap result = sanctnDAO.selectRcItivResultInfo(input);
			System.out.println("### 내사결과 result : "+result);

			/**
			 * 00213 내사결과 승인요청
			 * 00214 내사종결
			 * 00215 내사중지
			 * 00216 내사결과 입건
			 * 00217 내사결과 반려
			 */
			if(result != null){
				if("00213".equals(utl.nvl(result.get("PROGRS_STTUS_CD")))){
					//승인 또는 반려(반려의견) 적용
					re_cnt = sanctnDAO.updateSanctnConfm(input);
					if(re_cnt < 1) throw new Exception();

					HashMap proc = new HashMap();
					proc.put("rc_no", utl.nvl(result.get("RC_NO")));
					proc.put("esntl_id", esntl_id);
					proc.put("itiv_no", utl.nvl(result.get("ITIV_NO")));//내사 결과 보고 일시 수정 by dgkim

					//승인
					if(sttus_cd.equals(STTUS_SANCTN_COMPT)){
						//임시접수에 사건진행상태 update
						if("00214".equals(utl.nvl(result.get("ITIV_RESULT_CD")))){
							proc.put("progrs_sttus_cd", "00214");
						} else if("00215".equals(utl.nvl(result.get("ITIV_RESULT_CD")))){
							proc.put("progrs_sttus_cd", "00215");
						} else if("00216".equals(utl.nvl(result.get("ITIV_RESULT_CD")))){
							proc.put("progrs_sttus_cd", "00216");
						}
						re_cnt = sanctnDAO.updateRcTmpr(proc);
						if(re_cnt < 1) throw new Exception();
						
						//내사 결과 보고 일시 수정 by dgkim start
						re_cnt = rcDAO.updateRcItivResultDt(proc);
						if(re_cnt < 1) throw new Exception();
						//내사 결과 보고 일시 수정 by dgkim end
						
						//승인완료시 마스터에 업데이트 기록
						re_cnt = sanctnDAO.updateSanctn(input);
						if(re_cnt < 1) throw new Exception();
					//반려
					}else{
						proc.put("progrs_sttus_cd", "00217");
						re_cnt = sanctnDAO.updateRcTmpr(proc);
						if(re_cnt < 1) throw new Exception();
					}
				} else {
					re_cnt = -1;
				}
			} else {
				re_cnt = -1;
			}
		}

		return re_cnt;

	}

	// 입건승인
	public List<HashMap> selectInvPrsctList(HashMap map) throws Exception {
		return sanctnDAO.selectInvPrsctList(map);
	}

	public int confirmInvPrsct(HashMap map) throws Exception {
		Utility utl = Utility.getInstance();
		String[] sanctn_id_arr = (String[]) map.get("sanctn_id_arr");
		String sttus_cd = utl.nvl(map.get("sttus_cd"));
		String esntl_id = utl.nvl(map.get("esntl_id"));
		String dept_cd = utl.nvl(map.get("dept_cd"));

		int re_cnt = 0;

		for(String sanctn_id:sanctn_id_arr) {
			HashMap input = new HashMap();
			input.putAll(map);
			input.put("sanctn_id", sanctn_id);
			input.put("for_sanctn", "Y");
			HashMap result = sanctnDAO.selectInvAditPrsctInfo(input);

			System.out.println("### 입건승인 result:"+result);

			/**
			 * 00222 정식접수(입건) 승인요청
			 * 00223 정식접수(입건) 승인
			 * 00224 정식접수(입건) 반려
			 */
			if(result != null){
				if("00222".equals(utl.nvl(result.get("PROGRS_STTUS_CD")))){
					//승인 또는 반려(반려의견) 적용
					re_cnt = sanctnDAO.updateSanctnConfm(input);
					if(re_cnt < 1) throw new Exception();

					HashMap proc = new HashMap();
					proc.put("esntl_id", esntl_id);
					proc.put("dept_cd", dept_cd);

					//승인
					if(sttus_cd.equals(STTUS_SANCTN_COMPT)){
						String rtnCaseNo = utl.nvl(result.get("CASE_NO"));
						proc.put("case_no", rtnCaseNo);
						proc.put("rc_no", result.get("RC_NO"));
						proc.put("progrs_sttus_cd","00223");	/*입건처리*/
						proc.put("cmptnc_exmn_cd",result.get("CMPTNC_EXMN_CD"));
						proc.put("crmnl_fact",result.get("CRMNL_FACT"));
						proc.put("adit_prsct_id", result.get("ADIT_PRSCT_ID"));
						if(rtnCaseNo.equals("")) {
							//rtnCaseNo = prsctDAO.insertPrsctToAdit(proc);
							proc.put("case_no", rtnCaseNo);
						} else {
							prsctDAO.updatePrsct(proc);
						}
						if(!rtnCaseNo.equals("")) {
							prsctDAO.updateAditPrsctMng(proc);
							//prsctDAO.updateRcTempToAdit(proc);
							//trgter List
							List trgList = prsctDAO.selectAditPrsctTrgter (proc);
							if (trgList.size() > 0) {
								for(Object obj : trgList) {
									if(obj != null) {
										Map tgMap = (HashMap) obj;
										tgMap.put("case_no", rtnCaseNo);
										tgMap.put("rc_no", tgMap.get("RC_NO"));
										tgMap.put("trgter_sn", tgMap.get("TRGTER_SN"));
										tgMap.put("esntl_id", esntl_id);
										tgMap.put("doc_id", docService.getDocID());
										//prsctDAO.insertPrsctTrgter(tgMap);
									}
								}
							}
							//INV_PRSCT_ALOT, 배당부서
							prsctDAO.insertAlot (proc);
							//INV_PRSCT_VIOLT 위반사항
							prsctDAO.insertVilot (proc);
						}

						//승인완료시 마스터에 업데이트 기록
						re_cnt = sanctnDAO.updateSanctn(input);
						if(re_cnt < 1) throw new Exception();
					//반려
					}else{
						proc.put("progrs_sttus_cd", "00224");
						proc.put("rc_no", result.get("RC_NO"));
						proc.put("adit_prsct_id", result.get("ADIT_PRSCT_ID"));

						re_cnt = sanctnDAO.updateRcTmpr(proc);
						if(re_cnt < 1) throw new Exception();

						re_cnt = sanctnDAO.updateInvAditPrsctManage(proc);
						if(re_cnt < 1) throw new Exception();
					}
				} else {
					re_cnt = -1;
				}
			} else {
				re_cnt = -1;
			}
		}

		return re_cnt;

	}


	// 입건취소
	public List<HashMap> selectInvPrsctCanclList(HashMap map) throws Exception {
		return sanctnDAO.selectInvPrsctCanclList(map);
	}

	public int confirmInvPrsctCancl(HashMap map) throws Exception {
		Utility utl = Utility.getInstance();
		String[] sanctn_id_arr = (String[]) map.get("sanctn_id_arr");
		String sttus_cd = utl.nvl(map.get("sttus_cd"));
		String esntl_id = utl.nvl(map.get("esntl_id"));
		String dept_cd = utl.nvl(map.get("dept_cd"));

		int re_cnt = 0;

		for(String sanctn_id:sanctn_id_arr) {
			HashMap input = new HashMap();
			input.putAll(map);
			input.put("sanctn_id", sanctn_id);
			HashMap result = sanctnDAO.selectInvPrsctCanclInfo(input);

			/**
			 * 00225 정식접수(입건)취소 승인요청
			 * 00226 정식접수(입건)취소 승인
			 * 00227 정식접수(입건)취소 반려
			 */
			if(result != null){
				if("00225".equals(utl.nvl(result.get("PROGRS_STTUS_CD")))){
					//승인 또는 반려(반려의견) 적용
					re_cnt = sanctnDAO.updateSanctnConfm(input);
					if(re_cnt < 1) throw new Exception();

					HashMap proc = new HashMap();
					proc.put(  "case_no", result.get("CASE_NO")  );
					proc.put( "cancl_sn", result.get("CANCL_SN") );
					proc.put("sanctn_id", sanctn_id );
					proc.put( "esntl_id", esntl_id  );
					proc.put(  "dept_cd", dept_cd   );

					//승인
					if( sttus_cd.equals(STTUS_SANCTN_COMPT) ){
						// 입건취소 처리부분
						proc.put( "progrs_sttus_cd", "00226");
						proc.put( "cud_ci", "N" );
						re_cnt = sanctnDAO.updateInvPrsctForProgrsSttus(proc);
						if(re_cnt < 1) throw new Exception();

						re_cnt = sanctnDAO.updateInvPrsctCancl(proc);
						if(re_cnt < 1) throw new Exception();

						//접수 테이블에 CASE_NO 삭제
						re_cnt = sanctnDAO.updateRcTmprCaseNoCancl(proc);
						if(re_cnt < 1) throw new Exception();

						//임시 테이블 삭제
						re_cnt = sanctnDAO.updateInvAditPrsctCancl(proc);
						if(re_cnt < 1) throw new Exception();

						//승인완료시 마스터에 업데이트 기록
						re_cnt = sanctnDAO.updateSanctn(input);
						if(re_cnt < 1) throw new Exception();
					//반려
					} else {
						proc.put("progrs_sttus_cd", "00227");

						re_cnt = sanctnDAO.updateInvPrsctForProgrsSttus(proc);
						if(re_cnt < 1) throw new Exception();

						re_cnt = sanctnDAO.updateInvPrsctCancl(proc);
						if(re_cnt < 1) throw new Exception();
					}
				} else {
					re_cnt = -1;
				}
			} else {
				re_cnt = -1;
			}
		}

		return re_cnt;

	}


	// 사건송치
	public List<HashMap> selectTrnCaseList(HashMap map) throws Exception {
		return sanctnDAO.selectTrnCaseList(map);
	}

	public int confirmCaseTrn(HashMap map) throws Exception {
		Utility utl = Utility.getInstance();
		String[] sanctn_id_arr = (String[]) map.get("sanctn_id_arr");
		String sttus_cd = utl.nvl(map.get("sttus_cd"));
		String esntl_id = utl.nvl(map.get("esntl_id"));

		int re_cnt = 0;

		for( String sanctn_id:sanctn_id_arr ){
			HashMap input = new HashMap();
			input.putAll(map);
			input.put("sanctn_id", sanctn_id);
			HashMap result = sanctnDAO.selectTrnCaseInfo(input);

			/**
			 * 00241 송치승인요청
			 * 00242 송치
			 * 00243 송치반려
			 */
			if( result != null ){
				if( "00241".equals(utl.nvl(result.get("PROGRS_STTUS_CD"))) ){
					//승인 또는 반려(반려의견) 적용
					re_cnt = sanctnDAO.updateSanctnConfm(input);
					if(re_cnt < 1) throw new Exception();

					HashMap proc = new HashMap();
					proc.put(   "trn_no", utl.nvl(result.get("TRN_NO"))  );
					proc.put(  "case_no", utl.nvl(result.get("CASE_NO")) );
					proc.put( "esntl_id", esntl_id );

					//승인
					if( sttus_cd.equals(STTUS_SANCTN_COMPT) ){
						//승인 종결처리
						proc.put( "progrs_sttus_cd", "00242" );
						re_cnt = sanctnDAO.updateInvPrsctForProgrsSttus(proc);
						if(re_cnt < 1) throw new Exception();

						//승인완료시 마스터에 업데이트 기록
						re_cnt = sanctnDAO.updateSanctn(input);
						if(re_cnt < 1) throw new Exception();
					//반려
					}else{
						proc.put( "progrs_sttus_cd", "00243" );
						re_cnt = sanctnDAO.updateInvPrsctForProgrsSttus(proc);
						if( re_cnt < 1 ) throw new Exception();
					}
				} else {
					re_cnt = -1;
				}
			} else {
				re_cnt = -1;
			}
		}

		return re_cnt;

	}

	// 입건승인/배당 목록
	public List<HashMap> selectPrsctReqList(HashMap map) throws Exception {
		return sanctnDAO.selectPrsctReqList(map);
	}

	/**
	 * 2019-07-23
	 * 임시, 내사, 정식 사건 모두 승인처리함
	 * 사건구분을 변경하는 경우, 승인처리함.
	 * 2019-08-08
	 * 사건진행상태코드 재정비
	 */
	public int confirmCasePrsct(HashMap map) throws Exception {
		Utility utl = Utility.getInstance();
		String[] sanctn_id_arr = (String[]) map.get("sanctn_id_arr");
		String sttus_cd = utl.nvl(map.get("sttus_cd"));
		String esntl_id = utl.nvl(map.get("esntl_id")); //map:{confm_dc=121212, sanctn_id_arr=[Ljava.lang.String;@7fc8defe, sttus_cd=00023, esntl_id=GNRL0000000000000001}

		int re_cnt = 0;

		for( String sanctn_id:sanctn_id_arr ){
			HashMap input = new HashMap();
			input.putAll(map);  //input:{confm_dc=121212, sanctn_id_arr=[Ljava.lang.String;@7fc8defe, sttus_cd=00023, sanctn_id=00000000000000000138, esntl_id=GNRL0000000000000001}
			input.put("sanctn_id", sanctn_id);

			HashMap result = sanctnDAO.selectRcTmprInfo(input); //result:{DOC_ID=00000000000000000726, ITIV_NO=null, SANCTN_ID=00000000000000000138, CMPTNC_EXMN_CD=null, PRSCT_DE=null, RC_NO=2019-000174, PROGRS_STTUS_CD=00222, CASE_NO=null, RC_SE_CD=F, WRITNG_DEPT_CD=00002, REQUST_RC_SE_CD=null, UPDT_ID=GNRL0000000000000082, WRITNG_ID=GNRL0000000000000082, TMPR_NO=null, WRITNG_DT=2019-05-30 18:14:22.0, CRMNL_FACT=친구는 자신이 방사선 물질을 위반하였다고 술에취해 시인하였습니다., UPDT_DT=2019-05-30 18:16:44.0}

			if( result != null ){
				String fr_se_cd = utl.nvl( result.get("RC_SE_CD"));
				String to_se_cd = utl.nvl( result.get("REQUST_RC_SE_CD"), fr_se_cd );
				String progrs_sttus_cd = utl.nvl( result.get("PROGRS_STTUS_CD") );
				String confm_job_se_cd = utl.nvl( result.get("CONFM_JOB_SE_CD") );

				HashMap param = new HashMap();
				param.put("rc_no", utl.nvl(result.get("RC_NO")));
				param.put("to_se_cd", to_se_cd);
				param.put("sttus_cd", sttus_cd);
				param.put("esntl_id", esntl_id);

				/** PROGRS_STTUS_CD : 사건진행상태
				 * 02101	접수대기
				 * 02102	접수승인요청
				 * 02103	접수완료
				 * 02104	접수반려
				 * 02131	사건구분변경요청
				 * 02132	사건구분변경반려
				 */
				 
				/** CONFM_JOB_SE_CD : 승인업무구분코드
				 *  01382	사건작성
				 *  01383	사건구분변경
				 *  01385	내사 착수
				 *  01386	입건
				 */
				
				if( progrs_sttus_cd.equals("02102") ){ 		  
					if( sttus_cd.equals(STTUS_SANCTN_COMPT) ){ //승인
						param.put("progrs_sttus_cd", "02103");//접수완료
						if( to_se_cd.equals("F") ){
							param.put( "case_no", prsctDAO.selectCaseNo() );
						} else if( to_se_cd.equals("I") ){
							//param.put( "itiv_no", sanctnDAO.selectItivNo() );
						} else if( to_se_cd.equals("T") ){
							param.put( "tmpr_no", sanctnDAO.selectTmprNo() );
						}
					} else { //반려
						param.put("progrs_sttus_cd", "02104");
					}
				} else if( progrs_sttus_cd.equals("02131") ){   //사건구분변경요청
					if( sttus_cd.equals(STTUS_SANCTN_COMPT) ){   //승인
						param.put("progrs_sttus_cd", "02103");  //접수완료 //2019-08-21 접수대기에서 접수완료로 변경
						if( to_se_cd.equals("F") ){
							param.put("case_no", prsctDAO.selectCaseNo());
							param.put("trgter_se_cd", "00697"); //피의자
						} else if( to_se_cd.equals("I") ){
							param.put("itiv_no", sanctnDAO.selectItivNo());
							param.put("trgter_se_cd", "01349"); //피내사자
						} else if( to_se_cd.equals("T") ){
							param.put("tmpr_no", sanctnDAO.selectTmprNo());
							param.put("trgter_se_cd", "01358"); //혐의자
						}
					} else { //반려
						param.put("progrs_sttus_cd", "02132");
					}
								                               // 20200723  정식사건 승인 프로세스 추가 - 입건('01386') 및 내사 착수('01385') 코드 추가	
				} else if( progrs_sttus_cd.equals("02103") && confm_job_se_cd.equals("01385") ) { // 진행상태코드가 접수완료('02103') 및 사건구분코드 정식('F')를 체크하여 처리
					if( fr_se_cd.equals("I") ){
						if( sttus_cd.equals(STTUS_SANCTN_COMPT) ){ //승인  
							param.put( "itiv_no", sanctnDAO.selectItivNo() );
							//착수 일시 업데이트
							rcDAO.updateRcItivOutsetDt(param);
						}
						
					} 
				} else if( progrs_sttus_cd.equals("02103") && confm_job_se_cd.equals("01386") ) { // 진행상태코드가 접수완료('02103') 및 사건구분코드 정식('F')를 체크하여 처리
					if( fr_se_cd.equals("F") ){
						if( sttus_cd.equals(STTUS_SANCTN_COMPT) ){ //승인만 처리 반려 처리 없음.	  
							param.put("case_no", prsctDAO.selectCaseNo());
						}
					} 
				} 

				/**
				// 정식사건인 경우
				if(to_se_cd.equals("F"))
				{
					if(sttus_cd.equals(STTUS_SANCTN_COMPT)) { //승인
						param.put("case_no", prsctDAO.selectCaseNo());
						param.put("progrs_sttus_cd", "00223");  //정식사건 승인
						param.put("trgter_se_cd", "00697"); //피의자
					} else { //반려
						if(fr_se_cd.equals("T")) {
							param.put("progrs_sttus_cd", "01375"); //임시사건 정식반려
						} else if(fr_se_cd.equals("I")) {
							param.put("progrs_sttus_cd", "01377"); //내사사건 정식반려
						} else if(fr_se_cd.equals("F")) {
							param.put("progrs_sttus_cd", "00224"); //정식사건 반려
						}
					}
				}
				// 내사사건인 경우
				else if(to_se_cd.equals("I"))
				{
					if(sttus_cd.equals(STTUS_SANCTN_COMPT)) { //승인
						param.put("itiv_no", sanctnDAO.selectItivNo());
						param.put("progrs_sttus_cd", "00211");  //내사착수
						param.put("trgter_se_cd", "01349"); //피내사자
					} else {  //반려
						if(fr_se_cd.equals("T")) {
							param.put("progrs_sttus_cd", "01374"); //임시사건 내사반려
						} else if(fr_se_cd.equals("I")) {
							param.put("progrs_sttus_cd", "00212"); //내사착수 반려
						} else if(fr_se_cd.equals("F")) {
							param.put("progrs_sttus_cd", "01379"); //정식사건 내사반려
						}
					}
				}
				// 임시사건인 경우
				else if(to_se_cd.equals("T"))
				{
					if(sttus_cd.equals(STTUS_SANCTN_COMPT)) { //승인
						param.put("tmpr_no", sanctnDAO.selectTmprNo());
						param.put("progrs_sttus_cd", "01371");  //임시사건 승인
						param.put("trgter_se_cd", "01358"); //혐의자
					} else {  //반려
						if(fr_se_cd.equals("T")) {
							param.put("progrs_sttus_cd", "01372"); //임시사건 반려
						} else if(fr_se_cd.equals("I")) {
							param.put("progrs_sttus_cd", "01376"); //내사사건 임시반려
						} else if(fr_se_cd.equals("F")) {
							param.put("progrs_sttus_cd", "01378"); //정식사건 임시반려
						}
					}
				}*/

				//승인 또는 반려(반려의견) 적용
				re_cnt = sanctnDAO.updateSanctnConfm(input);
				if(re_cnt < 1) throw new Exception();

				//승인시 마스터에 업데이트 기록
				if(sttus_cd.equals(STTUS_SANCTN_COMPT)){
					re_cnt = sanctnDAO.updateSanctn(input);
					if(re_cnt < 1) throw new Exception();
				}

				//사건진행상태 및 번호 채번
				re_cnt = sanctnDAO.updateRcTmprForConfm(param);
				if(re_cnt < 1) throw new Exception();

				//2019-07-25 사건구분이 다른 경우, 피의자 구분 코드 update
				if(sttus_cd.equals(STTUS_SANCTN_COMPT) && !fr_se_cd.equals(to_se_cd)){
					sanctnDAO.updateRcTmprSuspctForSeCd(param);
				}

			} else {
				re_cnt = -1;
			}
		}

		return re_cnt;
	}

	// 임시사건 취소승인
	public List<HashMap> selectTmprCanclReqList(HashMap map) throws Exception {
		return sanctnDAO.selectTmprCanclReqList(map);
	}

	public int confirmTmprCancl(HashMap map) throws Exception {
		Utility utl = Utility.getInstance();
		String[] sanctn_id_arr = (String[]) map.get("sanctn_id_arr");
		String sttus_cd = utl.nvl(map.get("sttus_cd"));
		String esntl_id = utl.nvl(map.get("esntl_id")); //map:{confm_dc=121212, sanctn_id_arr=[Ljava.lang.String;@7fc8defe, sttus_cd=00023, esntl_id=GNRL0000000000000001}

		int re_cnt = 0;

		for(String sanctn_id:sanctn_id_arr) {
			HashMap input = new HashMap();
			input.putAll(map);  //input:{confm_dc=121212, sanctn_id_arr=[Ljava.lang.String;@7fc8defe, sttus_cd=00023, sanctn_id=00000000000000000138, esntl_id=GNRL0000000000000001}
			input.put("sanctn_id", sanctn_id);

			HashMap result = sanctnDAO.selectRcTmprInfo(input); //result:{DOC_ID=00000000000000000726, ITIV_NO=null, SANCTN_ID=00000000000000000138, CMPTNC_EXMN_CD=null, PRSCT_DE=null, RC_NO=2019-000174, PROGRS_STTUS_CD=00222, CASE_NO=null, RC_SE_CD=F, WRITNG_DEPT_CD=00002, REQUST_RC_SE_CD=null, UPDT_ID=GNRL0000000000000082, WRITNG_ID=GNRL0000000000000082, TMPR_NO=null, WRITNG_DT=2019-05-30 18:14:22.0, CRMNL_FACT=친구는 자신이 방사선 물질을 위반하였다고 술에취해 시인하였습니다., UPDT_DT=2019-05-30 18:16:44.0}

			if(result != null) {
				/**
				 * 02141	사건삭제요청
				 * 02142	사건삭제
				 * 02143	사건삭제반려
				 */
				HashMap param = new HashMap();
				param.put("rc_no", utl.nvl(result.get("RC_NO")));
				param.put("sttus_cd", sttus_cd);
				param.put("esntl_id", esntl_id);

				//승인 또는 반려(반려의견) 적용
				re_cnt = sanctnDAO.updateSanctnConfm(input);
				if(re_cnt < 1) throw new Exception();

				if(sttus_cd.equals(STTUS_SANCTN_COMPT)) { //승인
					//승인시 마스터에 업데이트 기록
					re_cnt = sanctnDAO.updateSanctn(input);
					if(re_cnt < 1) throw new Exception();

					param.put("progrs_sttus_cd", "02142");
				} else { //반려
					param.put("progrs_sttus_cd", "02143");
				}

				//사건진행상태 update
				re_cnt = sanctnDAO.updateRcTmpr(param);
				if(re_cnt < 1) throw new Exception();

			} else {
				re_cnt = -1;
			}
		}

		return re_cnt;
	}
}
