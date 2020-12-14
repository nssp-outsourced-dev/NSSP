package kr.go.nssp.inv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("CcdrcDAO")
public class CcdrcDAO extends EgovComAbstractDAO {

	public List selectCcdrcCaseList(Map<String, String> param) throws Exception {
		return list("inv.ccdrc.selectCcdrcCaseList", param);
	}
	
	/**
	 * 압수물 목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectCcdrcList(Map<String, String> param) throws Exception {
		return list("inv.ccdrc.selectCcdrcList", param);
	}
	
	/**
	 * 압수번호 목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectCcdrcNoList(Map<String, String> param) throws Exception {
		return list("inv.ccdrc.selectCcdrcNoList", param);
	}
	
	/**
	 * 전화번호 공통코드
	 * @return
	 * @throws Exception
	 */
	public List selectTelCdList() throws Exception {
		return list("inv.ccdrc.selectTelCdList", null);
	}
	
	/**
	 * 압수대상자 상세정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public HashMap selectCcdrcTrgterInfo(Map<String, String> param) throws Exception {
		return (HashMap) selectByPk("inv.ccdrc.selectCcdrcTrgterInfo", param);
	}
	
	/**
	 * 압수대상자 상세정보
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public HashMap selectCcdrcTrgterInfoByPk(Map<String, String> param) throws Exception {
		return (HashMap) selectByPk("inv.ccdrc.selectCcdrcTrgterInfoByPk", param);
	}	
	
	/**
	 * 사건대상자 목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectCaseTrgterList(Map<String, String> param) throws Exception {
		return list("inv.ccdrc.selectCaseTrgterList", param);
	}	
	
	/**
	 * 압수번호 채번
	 * @return
	 * @throws Exception
	 */
	public String selectNewCcdrNo() throws Exception {
		return (String) selectByPk("inv.ccdrc.selectNewCcdrNo", null);
	}

	/**
	 * 압수물 등록
	 * @param param
	 * @throws Exception
	 */
	public String insertCcdrc(Map<String, Object> param) throws Exception {
		return (String) insert("inv.ccdrc.insertCcdrc", param);
	}

	/**
	 * 압수 대상자 등록
	 * @param param
	 * @throws Exception
	 */
	public void insertCcdrcTrgter(Map<String, String> param) throws Exception {
		insert("inv.ccdrc.insertCcdrcTrgter", param);
	}
	
	/**
	 * 압수물 수정
	 * @param param
	 * @throws Exception
	 */
	public int updateCcdrc(Map<String, Object> param) throws Exception {
		return update("inv.ccdrc.updateCcdrc", param);
	}

	/**
	 * 압수 대상자 삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteCcdrcTrgter(Map<String, Object> param) throws Exception {
		return delete("inv.ccdrc.deleteCcdrcTrgter", param);
	}	

	/**
	 * 압수물 삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteCcdrc(Map<String, Object> param) throws Exception {
		return update("inv.ccdrc.deleteCcdrc", param);
	}	
	
	public Map<String, String> selectCcdrcDocId(Map<String, Object> param) throws Exception {
		return (Map) selectByPk("inv.ccdrc.selectCcdrcDocId", param);
	}
	
	
}
