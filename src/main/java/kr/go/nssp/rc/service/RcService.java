package kr.go.nssp.rc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface RcService {

	/**
	 * 사건 목록 조회
	 * @param map
	 * @return
	 */
	public List<HashMap<String, Object>> getCaseList(HashMap<String, Object> map) throws Exception;
	
	/**
	 * 전체 사건 목록 조회
	 * @param map
	 * @return
	 */
	public List<HashMap<String, Object>> getCaseListAll(HashMap<String, Object> map) throws Exception;
	

	/**
	 * 사건정보 조회 form bind 용
	 * @param map
	 * @return
	 */
	public HashMap<String, Object> getCaseInfoByFormBindAjax(HashMap<String, Object> map) throws Exception;
	
	/**
	 * 대상자 정보 조회 form bind 용
	 * @param map
	 * @return
	 */
	public HashMap<String, Object> getTargetInfoByFormBindAjax(HashMap<String, Object> map) throws Exception;

	/**
	 * 사건정보 업데이트
	 * @param map
	 * @throws Exception
	 */
	public void updateCaseInfo(HashMap<String, Object> map) throws Exception;

	/**
	 * 대상자정보 업데이트
	 * @param map
	 * @throws Exception
	 */
	public void updateTargetInfo(HashMap<String, Object> map) throws Exception;
	
	/**
	 * 접수 사건 등록
	 * @param map
	 * @throws Exception 
	 */
	public HashMap<String, Object> saveRcTmpr( Map<String, Object> param) throws Exception;
	
	/**
	 * 접수사건 상세
	 * @param pMap
	 * @return
	 * @throws Exception 
	 */
	public HashMap<String, Object> getCaseInfo(HashMap<String, Object> map) throws Exception;
	
	/**
	 * 사건 진행상태 조회
	 * @param pMap
	 * @return
	 * @throws Exception 
	 */
	public String getCaseProgrsStatus(String param) throws Exception;
	
	/**
	 * 내사착수여부 조회
	 * @param pMap
	 * @return
	 * @throws Exception 
	 */
	public String getOutsetReportYN(String param) throws Exception;
    
	/**
	 * 내사 일렬번호 조회
	 * @return
	 * @throws Exception
	 */
	public String getRcNo() throws Exception;
	
	/**
	 * 위반죄명 재명명
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String getVioltNmRemark(String param) throws Exception;

	/**
	 * 접수구분 업데이트
	 */
	public void updateReceiptSection(HashMap<String, Object> map) throws Exception;
	
	/**
	 *  부서 담당자 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<HashMap<String, Object>> getDeptChargerList(HashMap<String, Object> pMap) throws Exception;

	/**
	 * 내사착수 승인정보 조회
	 * @param pMap
	 * @return
	 * @throws Exception 
	 */
	public HashMap<String, Object> getRcItivOutset(HashMap<String, Object> map) throws Exception;

	/**
	 * 내사결과 승인정보 조회
	 * @param pMap
	 * @return
	 * @throws Exception 
	 */
	public HashMap<String, Object> getRcItivResult(HashMap<String, Object> map) throws Exception;
	
	/**
	 * 임시번호로 사건조회
	 * @param pMap
	 * @return
	 * @throws Exception 
	 */
	public HashMap<String, Object> getCaseInfoByTmprNo(HashMap<String, Object> map) throws Exception;
	/**
	 * 내사 승인요청 등록
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public void insertRcItivOutset(HashMap<String, Object> map)throws Exception;

	/**
	 * 내사결과요청
	 * @param map
	 * @throws Exception
	 */
	public void insertRcItivResult(HashMap<String, Object> map)throws Exception;

	/**
	 * 내사착수수정
	 * @param map
	 * @throws Exception
	 */
	public void updateRcItivOutset(HashMap<String, Object> map) throws Exception;
	
	/**
	 * 내사결과 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateRcItivResult(HashMap<String, Object> map) throws Exception;

	//사건진행상태 업데이트
	public void updateRcTmprSttus(HashMap<String, Object> map) throws Exception;
	
	/**
	 * 대상자 목록 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> getTrgterList(HashMap<String, Object> pMap) throws Exception;

	/**
	 * 대상자 serial number 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public HashMap<String, Object> getSnNoDetail (HashMap<String, Object> map) throws Exception;

	/**
	 * 대상자 등록
	 * @param map
	 * @throws Exception
	 */
	public void insertRcTmprTrgter(HashMap<String, Object> map)  throws Exception ;
	
	/**
	 * 대상자 삭제
	 * @param map
	 * @throws Exception
	 */
	public void deleteTargetInfo(HashMap<String, Object> map)  throws Exception ;
	
	/**
	 * 작성사건 승인요청
	 * @param map
	 * @throws Exception
	 */
	public void insertCaseConfmReqst(HashMap<String, Object> map)  throws Exception ;

	public void updateCaseToF(HashMap<String, Object> map) throws Exception ;

	public void updateCaseSttusToGetCaseNo(HashMap<String, Object> map) throws Exception;

	public String getSanctnId(String param) throws Exception;
	
	public HashMap<String, String> getOutsetConfmYN(String param) throws Exception;
	
	/** 
	 * @methodName : updateDe
	 * @date : 2021.06.24
	 * @author : dgkim
	 * @description : 
	 * 		시스템에서 자동 생성되는 일자가 맞지 않다면 수기로 작성하도록 수정.
	 * 		임시사건 결과 보고일자, 입건일자, 수사재개일자 수기로 작성하게끔 수정.
	 * 		김지만 수사관 요청
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int updateDe(Map<String, Object> param) throws Exception;
	
	/** 
	 * @methodName : updateOutsetReportDt
	 * @date : 2021.06.29
	 * @author : dgkim
	 * @description : 
	 * 		시스템에서 자동 생성되는 일자가 맞지 않다면 수기로 작성하도록 수정.
	 * 		임시사건 결과 보고일자, 입건일자, 수사재개일자 수기로 작성하게끔 수정.
	 * 		김지만 수사관 요청
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int updateOutsetReportDt(Map<String, Object> param) throws Exception;
	
	/** 
	 * @methodName : updateItivResultRerortDt
	 * @date : 2021.06.29
	 * @author : dgkim
	 * @description : 
	 * 		시스템에서 자동 생성되는 일자가 맞지 않다면 수기로 작성하도록 수정.
	 * 		임시사건 결과 보고일자, 입건일자, 수사재개일자 수기로 작성하게끔 수정.
	 * 		김지만 수사관 요청
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int updateItivResultRerortDt(Map<String, Object> param) throws Exception;
}
