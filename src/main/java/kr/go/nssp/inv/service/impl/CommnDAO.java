package kr.go.nssp.inv.service.impl;

import java.util.List;
import java.util.Map;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

import org.springframework.stereotype.Repository;

@Repository("CommnDAO")
public class CommnDAO extends EgovComAbstractDAO {

	/**
	 * 내사건목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectMyCaseList(Map<String, String> param) throws Exception {
		return list("inv.commn.selectMyCaseList", param);
	}

	/**
	 * 통신사실확인 허가신청 목록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectCommnList(Map<String, String> param) throws Exception {
		return list("inv.commn.selectCommnList", param);
	}
	
	public Map selectCommnInfo(Map<String, String> param) throws Exception {
		return (Map)selectByPk("inv.commn.selectCommnInfo", param);
	}	
	
	/**
	 * 통신사실확인 허가신청 등록
	 * @param param
	 * @throws Exception
	 */
	public String insertCommn(Map<String, String> param) throws Exception {
		return (String) insert("inv.commn.insertCommn", param);
	}

	/**
	 * 통신사실확인 허가 재신청
	 * @param param
	 * @throws Exception
	 */
	public String insertCommnRe(Map<String, String> param) throws Exception {
		return (String) insert("inv.commn.insertCommnRe", param);
	}

	/**
	 * 통신사실확인 허가 재신청여부 수정
	 * @param param
	 * @throws Exception
	 */
	public int updateCommnRe(Map<String, String> param) throws Exception {
		return update("inv.commn.updateCommnRe", param);
	}
	
	/**
	 * 통신사실확인 허가신청 수정
	 * @param param
	 * @throws Exception
	 */
	public int updateCommn(Map<String, String> param) throws Exception {
		return update("inv.commn.updateCommn", param);
	}

	/**
	 * 통신사실확인 허가신청 결과 수정
	 * @param param
	 * @throws Exception
	 */
	public int updateCommnResult(Map<String, String> param) throws Exception {
		return update("inv.commn.updateCommnResult", param);
	}

	/**
	 * 통신사실확인 허가신청 삭제
	 * @param param
	 * @throws Exception
	 */
	public int deleteCommn(Map<String, String> param) throws Exception {
		return update("inv.commn.deleteCommn", param);
	}
}
