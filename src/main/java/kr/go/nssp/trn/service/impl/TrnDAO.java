package kr.go.nssp.trn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("TrnDAO")
public class TrnDAO extends EgovComAbstractDAO {
	
	/**
	 * 송치대상 사건목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectCaseListForTrn(Map<String, Object> param) throws Exception {
		return list("trn.selectCaseListForTrn", param);
	}	

	/**
	 * 송치 사건 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public HashMap selectTrnCaseInfo(Map<String, String> param) throws Exception {
		return (HashMap) selectByPk("trn.selectTrnCaseInfo", param);
	}
	
	/**
	 * 사건상세보기 - 송치
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectTrnCaseList(Map<String, String> param) throws Exception {
		return list("trn.selectTrnCaseList", param);
	}
	
	/**
	 * 사건송치부
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectTrnCaseStatList(Map<String, String> param) throws Exception {
		return list("trn.selectTrnCaseStatList", param);
	}	
	
	/**
	 * 발생통계원표부
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectOccZeroStatList(Map<String, String> param) throws Exception {
		return list("trn.selectOccZeroStatList", param);
	}	
	
	/**
	 * 검거통계원표부
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectArrZeroStatList(Map<String, String> param) throws Exception {
		return list("trn.selectArrZeroStatList", param);
	}	
	
	/**
	 * 피의자통계원표부
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectSusZeroStatList(Map<String, String> param) throws Exception {
		return list("trn.selectSusZeroStatList", param);
	}		
	
	/**
	 * 송치피의자 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectTrnSuspctList(Map<String, String> param) throws Exception {
		return list("trn.selectTrnSuspctList", param);
	}
	
	public List selectTrnSuspctListOnly(Map<String, String> param) throws Exception {
		return list("trn.selectTrnSuspctListOnly", param);
	}
	
	/**
	 * 송치피의자별 위반사항 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectTrnVioltList(Map<String, String> param) throws Exception {
		return list("trn.selectTrnVioltList", param);
	}
	
	public List selectTrnVioltListOnly(Map<String, String> param) throws Exception {
		return list("trn.selectTrnVioltListOnly", param);
	}
	
	/**
	 * 송치 관리 목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectTrnList(Map<String, String> param) throws Exception {
		return list("trn.selectTrnList", param);
	}

	/**
	 * 통계원표 목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectTrnZeroNoList(Map<String, String> param) throws Exception {
		return list("trn.selectTrnZeroNoList", param);
	}
	
	/**
	 * 재송치 하기 위해서 원 송치정보 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public HashMap selectTrnInfoForRe(Map<String, Object> param) throws Exception {
		return (HashMap) selectByPk("trn.selectTrnInfoForRe", param);
	}	

	/**
	 * 송치번호 채번
	 * @return
	 * @throws Exception
	 */
	public String selectNewTrnNo() throws Exception {
		return (String) selectByPk("trn.selectNewTrnNo", null);
	}	

	/**
	 * 송치 저장 - 송치사건
	 * @param param
	 * @throws Exception
	 */
	public String insertTrnCase(Map<String, Object> param) throws Exception {
		return (String) insert("trn.insertTrnCase", param);
	}
	
	/**
	 * 재송치 - 송치사건
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String insertReTrnCase(Map<String, Object> param) throws Exception {
		return (String) insert("trn.insertReTrnCase", param);
	}	
	
	/**
	 * 송치 저장 - 사건진행상태 변경 (송치준비중)
	 * @param param
	 * @throws Exception
	 */
	public int updateInvPrsctForTrn(Map<String, Object> param) throws Exception {
		return update("trn.updateInvPrsctForTrn", param);
	}	
	
	/**
	 * 송치완료
	 * @param param
	 * @throws Exception
	 */
	public int updateInvPrsctForTrnSttus(Map<String, Object> param) throws Exception {
		return update("trn.updateInvPrsctForTrnSttus", param);
	}	
	
	/**
	 * 송치종결 처리
	 * @param param
	 * @throws Exception
	 */
	public int updateTrnCaseForEdYn(Map<String, Object> param) throws Exception {
		return update("trn.updateTrnCaseForEdYn", param);
	}
	
	/**
	 * 재송치 후 원 송치번호 비고 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateTrnCaseForReRm(Map<String, Object> param) throws Exception {
		return update("trn.updateTrnCaseForReRm", param);
	}
	
	/**
	 * 송치 수정
	 * @param param
	 * @throws Exception
	 */
	public int updateTrnCase(Map<String, Object> param) throws Exception {
		return update("trn.updateTrnCase", param);
	}

	/**
	 * 송치 삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteTrnCase(Map<String, Object> param) throws Exception {
		return update("trn.deleteTrnCase", param);
	}
	
	/**
	 * 송치 삭제 - 송치피의자 삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteTrnSuspctForUseYn(Map<String, Object> param) throws Exception {
		return update("trn.deleteTrnSuspctForUseYn", param);
	}
	
	/**
	 * 송치 삭제  - 피의자 송치의견 삭제
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteTrnVioltForUseYn(Map<String, Object> param) throws Exception {
		return update("trn.deleteTrnVioltForUseYn", param);
	}	
	
	/**
	 * 송치 삭제 - 압수물총목록 삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteTrnCcdrcForUseYn(Map<String, Object> param) throws Exception {
		return update("trn.deleteTrnCcdrcForUseYn", param);
	}
	
	/**
	 * 송치 삭제 - 사건진행상태 update (이전 진행상태)
	 * @param param
	 * @throws Exception
	 */
	public int deleteTrnCaseForInvPrsct(Map<String, Object> param) throws Exception {
		return update("trn.deleteTrnCaseForInvPrsct", param);
	}
	
	/**
	 * 송치 승인요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int requstTrnCase(Map<String, Object> param) throws Exception {
		return update("trn.requstTrnCase", param);
	}

	
	/**
	 * 송치 등록 - 피의자
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String insertTrnSuspct(Map<String, Object> param) throws Exception {
		return (String) insert("trn.insertTrnSuspct", param);
	}
	
	/**
	 * 재송치 - 피의자
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String insertReTrnSuspct(Map<String, Object> param) throws Exception {
		return (String) insert("trn.insertReTrnSuspct", param);
	}	
	
	/**
	 * 송치피의자 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String insertTrnSuspctInfo(Map<String, Object> param) throws Exception {
		return (String) insert("trn.insertTrnSuspctInfo", param);
	}

	/**
	 * 송치 등록 - 피의자 위반사항
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String insertTrnViolt(Map<String, Object> param) throws Exception {
		return (String) insert("trn.insertTrnViolt", param);
	}
	
	/**
	 * 재송치 - 피의자 위반사항
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String insertReTrnViolt(Map<String, Object> param) throws Exception {
		return (String) insert("trn.insertReTrnViolt", param);
	}		
	
	/**
	 * 송치피의자 위반사항 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String insertTrnVioltInfo(Map<String, Object> param) throws Exception {
		return (String) insert("trn.insertTrnVioltInfo", param);
	}
	
	/**
	 * 송치죄명 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int mergerTrnViolt(Map<String, Object> param) throws Exception {
		return update("trn.mergeTrnViolt", param);
	}	
	
	/**
	 * 송치피의자 수정
	 * @param param
	 * @throws Exception
	 */
	public int updateTrnSuspct(Map<String, Object> param) throws Exception {
		return update("trn.updateTrnSuspct", param);
	}
	
	/**
	 * 송치피의자 삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteTrnSuspct(Map<String, Object> param) throws Exception {
		return update("trn.deleteTrnSuspct", param);
	}
	
	/**
	 * 송치피의자 위반사항 삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteTrnViolt(Map<String, Object> param) throws Exception {
		return update("trn.deleteTrnViolt", param);
	}	

	/**
	 * 송치피의자가 아닌 대상자의 위반사항  삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteTrnVioltForNoSuspct(Map<String, Object> param) throws Exception {
		return update("trn.deleteTrnVioltForNoSuspct", param);
	}
	
	/**
	 * 송치피의자의 위반사항  등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String insertTrnVioltForSuspct(Map<String, Object> param) throws Exception {
		return (String) insert("trn.insertTrnVioltForSuspct", param);
	}
	
	/**
	 * 발생원표번호 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateTrnCaseForOccrrncZeroNo(Map<String, String> param) throws Exception {
		return update("trn.updateTrnCaseForOccrrncZeroNo", param);
	}
	
	/**
	 * 검거원표번호 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateTrnCaseForArrestZeroNo(Map<String, String> param) throws Exception {
		return update("trn.updateTrnCaseForArrestZeroNo", param);
	}

	/**
	 * 피의자원표번호 채번
	 * @return
	 * @throws Exception
	 */
	public String selectNewSuspctZeroNo(Map<String, String> param) throws Exception {
		return (String) selectByPk("trn.selectNewSuspctZeroNo", param);
	}
	
	/**
	 * 피의자원표번호 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateTrnSuspctForSuspctZeroNo(Map<String, String> param) throws Exception {
		return update("trn.updateTrnSuspctForSuspctZeroNo", param);
	}

	/**
	 * 송치완료 전에 송치 데이터 유효성체크
	 * @param param
	 * @throws Exception
	 */
	public void callProcedureTrnCheck(Map<String, Object> param) throws Exception {
		selectByPk("trn.callProcedureTrnCheck", param);
	}
	
	/**
	 * 재송치 - 송치문서 복사
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String copyTrnCaseDoc(Map<String, Object> param) throws Exception {
		insert("trn.insertDocManageForReTrn", param);
		return (String) insert("trn.insertDocPblicteForReTrn", param);
	}

	/**
	 * 지휘건의 의견서 복사
	 * @param param
	 * @throws Exception
	 */
	public void insertDocPblicteForSugestDoc(Map<String, Object> param) throws Exception {
		insert("trn.insertDocPblicteForSugestDoc", param);
	}
	
	/** 
	 * @methodName : updateTrnDe
	 * @date : 2021.06.29
	 * @author : dgkim
	 * @description : 송치일자가 맞지 않을시 변경하도록 조치
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateTrnDe(Map<String, Object> param) throws Exception {
		return update("trn.updateTrnDe", param);
	}
	
	/** 
	 * @methodName : updateTrnCaseZeroNo
	 * @date : 2021.07.19
	 * @author : dgkim
	 * @description : 
	 * 		송치완료 후에도 피의자 원표 번호 수정 가능하도록 조치
	 * 		김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateTrnCaseZeroNo(Map<String, Object> param) throws Exception {
		return update("trn.updateTrnCaseZeroNo", param);
	}
	
	/** 
	 * @methodName : updateTrnSuspctZeroNo
	 * @date : 2021.07.19
	 * @author : dgkim
	 * @description : 
	 * 		송치완료 후에도 피의자 원표 번호 수정 가능하도록 조치
	 * 		김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateTrnSuspctZeroNo(Map<String, Object> param) throws Exception {
		return update("trn.updateTrnSuspctZeroNo", param);
	}
}
