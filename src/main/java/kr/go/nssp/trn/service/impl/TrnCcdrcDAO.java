package kr.go.nssp.trn.service.impl;

import java.util.List;
import java.util.Map;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("TrnCcdrcDAO")
public class TrnCcdrcDAO extends EgovComAbstractDAO {
	/**
	 * 압수물총목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectTrnCcdrcList(Map<String, String> param) throws Exception {
		return list("trn.ccdrc.selectTrnCcdrcList", param);
	}
	
	/**
	 * 압수물총목록 저장
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int mergerTrnCcdrc(Map<String, Object> param) throws Exception {
		return update("trn.ccdrc.mergeTrnCcdrc", param);
	}	
	
	/**
	 * 송치압수물총목록 등록
	 * @param param
	 * @throws Exception
	 */
	public String insertTrnCcdrc(Map<String, Object> param) throws Exception {
		return (String) insert("trn.ccdrc.insertTrnCcdrc", param);
	}
	
	public String insertTrnCcdrcForTrn(Map<String, Object> param) throws Exception {
		return (String) insert("trn.ccdrc.insertTrnCcdrcForTrn", param);
	}
	
	public String insertReTrnCcdrc(Map<String, Object> param) throws Exception {
		return (String) insert("trn.ccdrc.insertReTrnCcdrc", param);
	}
	
	/**
	 * 송치압수물총목록 수정
	 * @param param
	 * @throws Exception
	 */
	public int updateTrnCcdrc(Map<String, Object> param) throws Exception {
		return update("trn.ccdrc.updateTrnCcdrc", param);
	}

	/**
	 * 송치압수물총목록 삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteTrnCcdrc(Map<String, Object> param) throws Exception {
		return update("trn.ccdrc.deleteTrnCcdrc", param);
	}	
}
