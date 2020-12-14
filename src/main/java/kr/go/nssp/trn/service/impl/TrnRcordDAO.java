package kr.go.nssp.trn.service.impl;

import java.util.List;
import java.util.Map;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("TrnRcordDAO")
public class TrnRcordDAO extends EgovComAbstractDAO {
	/**
	 * 기록목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectTrnRcordList(Map<String, String> param) throws Exception {
		return list("trn.rcord.selectTrnRcordList", param);
	}
	
	/**
	 * 송치기록목록 등록
	 * @param param
	 * @throws Exception
	 */
	public String insertTrnRcord(Map<String, Object> param) throws Exception {
		return (String) insert("trn.rcord.insertTrnRcord", param);
	}
	
	/**
	 * 송치기록목록 가져오기
	 * @param param
	 * @throws Exception
	 */
	public String insertTrnRcordForBring(Map<String, Object> param) throws Exception {
		return (String) insert("trn.rcord.insertTrnRcordForBring", param);
	}		
	
	/**
	 * 송치기록목록 수정
	 * @param param
	 * @throws Exception
	 */
	public int updateTrnRcord(Map<String, Object> param) throws Exception {
		return update("trn.rcord.updateTrnRcord", param);
	}

	/**
	 * 송치기록목록 삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteTrnRcord(Map<String, Object> param) throws Exception {
		return update("trn.rcord.deleteTrnRcord", param);
	}	
	
	public int deleteTrnRcordForBring(Map<String, Object> param) throws Exception {
		return update("trn.rcord.deleteTrnRcordForBring", param);
	}	
	
	public int deleteTrnRcordAll(Map<String, Object> param) throws Exception {
		return delete("trn.rcord.deleteTrnRcordAll", param);
	}	
	
	
	public int selectTrnRcordCount(Map<String, Object> param) throws Exception {
		return (Integer) selectByPk("trn.rcord.selectTrnRcordCount", param);
	}	
	
	
}
