package kr.go.nssp.rc.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class RcDAO extends EgovComAbstractDAO {

	/**
	 * 접수번호 조회
	 * @return
	 */
	public String selectRcNo() {
		return (String) selectByPk("rc.selectRcNo", "");
	}
	/**
	 * 내사번호 조회
	 * @return
	 */
	public String selectItivNo() {
		return (String) selectByPk("rc.selectItivNo", "");
	}
	
	/**
	 * 사건 목록 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap<String, Object>> selectCaseList(HashMap<String, Object> map) throws Exception {
		return list("rc.selectCaseList", map);
	}
	
	/**
	 * 사건 정보 조회
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectCaseInfo(HashMap<String, Object> map) throws Exception {
		
		return (HashMap<String, Object>) selectByPk("rc.selectCaseInfo", map);
	}
	
	/**
	 * 사건정보 조회 form bind 용
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectCaseInfoByFormBind(HashMap<String, Object> map) throws Exception {
		return (HashMap<String, Object>) selectByPk("rc.selectCaseInfoByFormBind", map);
	}
	/**
	 * 대상자정보 조회 form bind 용
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectTargetInfoByFormBind(HashMap<String, Object> map) throws Exception {
		return (HashMap<String, Object>) selectByPk("rc.selectTargetInfoByFormBind", map);
	}
	
	/**
	 *전체 사건 목록  조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> selectCaseListAll(HashMap<String, Object> map) throws Exception {
		return list("rc.selectCaseListAll", map);
	}
	

	/**
	 *사건 접수 내용 등록
	 * @param map
	 */
	public void insertRcTmpr( Map<String, Object> map) throws Exception {
		insert("rc.insertRcTmpr", map);
	}
	

	/**
	 * 사건 진행 상태 조회
	 * @param map
	 * @return
	 */
	public String selectCaseProgrsStatus(String param) throws Exception {
		
		return (String) selectByPk("rc.selectCaseProgrsStatus", param);
	}
	/**
	 * 내사착수여부 조회
	 * @param map
	 * @return
	 */
	public String selectOutsetReportYN(String param) throws Exception {
		
		return (String) selectByPk("rc.selectOutsetReportYN", param);
	}
	
	/**
	 * 위반죄명 재 정렬
	 * @param map
	 * @return
	 */
	public String selectVioltNmRemark(String param) throws Exception {
		
		return (String) selectByPk("rc.selectVioltNmRemark", param);
	}

	/**
	 *사건 대상자 등록
	 * @param map
	 */
	public int insertRcTmprTrgter(HashMap<String, Object> map) throws Exception  {
		return (int) insert("rc.insertRcTmprTrgter", map);
	}
	
	/**
	 *사건 대상자 등록
	 * @param map
	 */
	public void deleteTargetInfo(HashMap<String, Object> map) throws Exception  {
		delete("rc.deleteTargetInfo", map);
	}

	/**
	 * 접수/내사 대상자 등록
	 * @param map
	 * @throws Exception
	 */
	public void insertRcTmprTrgter(Map<String, Object> map) {
		insert("rc.insertRcTmprTrgter", map);
		
	}

	/**
	 *접수 내사 등록
	 * @param map
	 */
	public void insertRcItiv(HashMap<String, Object> map) throws Exception {
		insert("rc.insertRcItiv", map);
	}
	
	/**
	 *접수 위반사항 등록
	 * @param map
	 */
	public void insertRcTmprViolt(HashMap<String, Object> map) throws Exception {
		insert("rc.insertRcTmprViolt", map);
	}
	
	/**
	 *접수 위반사항 삭제
	 * @param map
	 */
	public void deleteRcTmprViolt(HashMap<String, Object> map) throws Exception {
		delete("rc.deleteRcTmprViolt", map);
	}

	/**
	 * 접수구분 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateReceiptSection(HashMap<String, Object> map) throws Exception {
		update("updateReceiptSection", map);
	}

	/**
	 * 접수구분 변경 이력 등록
	 * @param map
	 */
	public void insertRcTmprHistory(HashMap<String, Object> map) {
		insert("rc.insertRcTmprHistory", map);
	}

	/**
	 * 부서 담당자 조회
	 * @param map
	 * @return
	 */
	public List<HashMap<String, Object>> selectDeptChargerList(HashMap<String, Object> map) {
		return list("rc.selectDeptChargerList", map);
		
	}
	
	/**
	 * 대상자 목록 조회
	 * @param map
	 * @return
	 */
	public List<HashMap> selectTrgterList(HashMap<String, Object> map) {
		return list("rc.selectTrgterList", map);
		
	}
	
	/**
	 * 내사착수 승인정보 조회
	 * @param pMap
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectRcItivOutset(HashMap<String, Object> map) throws Exception {
			return (HashMap<String, Object>) selectByPk("rc.selectRcItivOutset", map);
	}
	
	/**
	 * 내사결과 승인정보 조회
	 * @param pMap
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectRcItivResult(HashMap<String, Object> map) throws Exception {
		return (HashMap<String, Object>) selectByPk("rc.selectRcItivResult", map);
	}

	/**
	 * 임시번호로 사건 정보 조회
	 * @param pMap
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectCaseInfoByTmprNo(HashMap<String, Object> map) throws Exception {
		return (HashMap<String, Object>) selectByPk("rc.selectCaseInfoByTmprNo", map);
	}
	
	/**
	 * 내사 착수 등록
	 * @param map
	 * @throws Exception
	 */
	public void insertRcItivOutset(Map map) throws Exception {
		insert("rc.insertRcItivOutset", map);
	}

	/**
	 * 내사 결과 등록
	 * @param map
	 * @throws Exception
	 */
	public void insertRcItivResult(Map map) throws Exception {
		insert("rc.insertRcItivResult", map);
	}
	
	/**
	 * 내사 착수 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateRcItivOutset(Map map) throws Exception {
		update("rc.updateRcItivOutset", map);
	}
	
	/**
	 * 내사 착수일 반영
	 * @param map
	 * @throws Exception
	 */
	public void updateRcItivOutsetDt(Map map) throws Exception {
		update("rc.updateRcItivOutsetDt", map);
	}
	
	/**
	 * 내사 결과 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateRcItivResult(Map map) throws Exception {
		update("rc.updateRcItivResult", map);
	}
	
	/**
	 * 내사 결과 보고 일시 수정 
	 * by dgkim
	 * @param map
	 * @throws Exception
	 */
	public int updateRcItivResultDt(Map map) throws Exception {
		return update("rc.updateRcItivResultDt", map);
	}

	/**
	 * 사건접수테이블 상태 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateRcTmprSttus(Map map) throws Exception {
		update("rc.updateRcTmprSttus", map);
	}
	
	/**
	 * 사건정보 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateCaseInfo(HashMap<String, Object> map) throws Exception {
		update("rc.updateCaseInfo", map);
	}
	/**
	 * 대상자 정보 수정
	 * @param map
	 * @throws Exception
	 */
	public void updateTargetInfo(HashMap<String, Object> map) throws Exception {
		update("rc.updateTargetInfo", map);
	}

	/**
	 * 접수, 사건, 내사번호 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> selectSnNoDetail(HashMap<String, Object> map) throws Exception {		
		return (HashMap<String, Object>) selectByPk("rc.selectSnNoDetail", map);
	}
	
	/**
	 * 작성사건 결재 정보 update
	 * @param map
	 * @throws Exception
	 */
	public void updateRcTemprSanctn(HashMap<String, Object> map) throws Exception {
		update("rc.updateRcTemprSanctn", map);
	}
	
	/**
	 * 사건 승인  ID 조회
	 * @param map
	 * @return
	 */
	public String selectSanctnId(String param) throws Exception {
		
		return (String) selectByPk("rc.selectSanctnId", param);
	}
	
	/**
	 * 사건 승인  ID 조회
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, String> selectOutsetConfm(String param) throws Exception {
		
		return (HashMap<String, String>) selectByPk("rc.selectOutsetConfm", param);
	}
	
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
	public int updateDe(Map<String, Object> param) throws Exception {
		return update("rc.updateDe", param);
	}
	
	/** 
	 * @methodName : updateOutsetReportDt
	 * @date : 2021.06.29
	 * @author : dgkim
	 * @description : 
	 * 		시스템에서 자동 생성되는 일자가 맞지 않다면 수기로 작성하도록 수정.
	 * 		임시사건 결과 보고일자, 입건일자, 수사재개일자 수기로 작성하게끔 수정.
	 * 		김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateOutsetReportDt(Map<String, Object> param) throws Exception {
		return update("rc.updateOutsetReportDt", param);
	}
	
	/** 
	 * @methodName : updateItivResultRerortDt
	 * @date : 2021.06.29
	 * @author : dgkim
	 * @description : 
	 * 		시스템에서 자동 생성되는 일자가 맞지 않다면 수기로 작성하도록 수정.
	 * 		임시사건 결과 보고일자, 입건일자, 수사재개일자 수기로 작성하게끔 수정.
	 * 		김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateItivResultRerortDt(Map<String, Object> param) throws Exception {
		return update("rc.updateItivResultRerortDt", param);
	}
	
	/** 
	 * @methodName : insertTrgterChghst
	 * @date : 2021.07.09
	 * @author : dgkim
	 * @description : 피의자 정보 변경 이력 추가 (개인정보 보안 지침의 의한 신규 추가)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public void insertTrgterChghstLog(Map<String, Object> param) throws Exception {
		insert("rc.insertTrgterChghstLog", param);
	}
	
	/** 
	 * @methodName : selectTrgterChghst
	 * @date : 2021.07.09
	 * @author : dgkim
	 * @description : 피의자 정보 변경 이력 조회 (개인정보 보안 지침의 의한 신규 추가)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectTrgterChghstLog(Map<String, Object> param) throws Exception {
		return list("rc.selectTrgterChghstLog", param);
	}
}