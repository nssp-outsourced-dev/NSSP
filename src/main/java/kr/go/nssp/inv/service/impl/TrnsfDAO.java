package kr.go.nssp.inv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("TrnsfDAO")
public class TrnsfDAO extends EgovComAbstractDAO {

	/**
	 * 이송 관리 목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectTrnsfList(Map<String, String> param) throws Exception {
		return list("inv.trnsf.selectTrnsfList", param);
	}
	
	/**
	 * 이송자료 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public HashMap selectTrnsfInfo(Map<String, String> param) throws Exception {
		return (HashMap) selectByPk("inv.trnsf.selectTrnsfInfo", param);
	}
	
	/**
	 * 이송Key 채번
	 * @return
	 * @throws Exception
	 */
	public String selectNewTrnsSn() throws Exception {
		return (String) selectByPk("inv.trnsf.selectNewTrnsSn", null);
	}
	
	/**
	 * 이송 등록
	 * @param param
	 * @throws Exception
	 */
	public String insertTrnsf(Map<String, Object> param) throws Exception {
		return (String) insert("inv.trnsf.insertTrnsf", param);
	}
	
	/**
	 * 이송 등록 - 입건Tab 이송번호 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateInvPrsctForTrnsf(Map<String, Object> param) throws Exception {
		return update("inv.trnsf.updateInvPrsctForTrnsf", param);
	}	
	
	/**
	 * 이송 등록 - 접수Tab 이송번호 udpate
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateRcTmprForTrnsf(Map<String, Object> param) throws Exception {
		return update("inv.trnsf.updateRcTmprForTrnsf", param);
	}		

	/**
	 * 이송 수정
	 * @param param
	 * @throws Exception
	 */
	public int updateTrnsf(Map<String, Object> param) throws Exception {
		return update("inv.trnsf.updateTrnsf", param);
	}

	/**
	 * 이송 삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteTrnsf(Map<String, Object> param) throws Exception {
		return update("inv.trnsf.deleteTrnsf", param);
	}
	
	/**
	 * 이송 삭제 - 사건Tab 진행상태 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteTrnsfForCase(Map<String, Object> param) throws Exception {
		return update("inv.trnsf.deleteTrnsfForCase", param);
	}
	
	/**
	 * 이송 삭제 - 접수Tab 진행상태 update
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int deleteTrnsfForRc(Map<String, Object> param) throws Exception {
		return update("inv.trnsf.deleteTrnsfForRc", param);
	}	
}
