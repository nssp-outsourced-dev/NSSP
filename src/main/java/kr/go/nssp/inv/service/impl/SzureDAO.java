package kr.go.nssp.inv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class SzureDAO extends EgovComAbstractDAO {

	public List selectSzureList(Map<String, Object> param) throws Exception {
		return list ("inv.selectSzureList", param);
	}
	public Map selectSzureDtl(Map<String, Object> param) throws Exception {
		Object o = selectByPk("inv.selectSzureDtl", param);
		if(o == null) {
			return new HashMap();
		} else {
			return (HashMap) o;
		}
	}
	public String insertSzureReq(Map<String, Object> param) throws Exception {
		return (String) insert("inv.insertSzureReq", param);
	}
	public int updateSzureReq(Map<String, Object> param) throws Exception {
		return update("inv.updateSzureReq", param);
	}
	public int insertSzureRst(Map<String, Object> param) throws Exception {
		insert("inv.insertSzureRst", param);
		return 1;
	}
	public int updateSzureRst(Map<String, Object> param) throws Exception {
		return update("inv.updateSzureRst", param);
	}
	public int updateSzureReqZlNo(Map<String, Object> param) throws Exception {
		return update("inv.updateSzureReqZlNo", param);
	}
	public int deleteSzureRst(Map<String, Object> param) throws Exception {
		return delete("inv.deleteSzureRst",param);
	}
	public int selectSzureZlNoChk(Map<String, Object> param) throws Exception {
		return (int) selectByPk("inv.selectSzureZlNoChk", param);
	}
	public int deleteSzureAcnut(Map<String, Object> param) throws Exception {
		return delete("inv.deleteSzureAcnut",param);
	}
	public int insertSzureAcnut(Map<String, Object> param) throws Exception {
		insert("inv.insertSzureAcnut", param);
		return 1;
	}
	public List selectSzureAcnutList(Map<String, Object> param) throws Exception {
		return list ("inv.selectSzureAcnutList", param);
	}
	public int deleteSzureTrgter(Map<String, Object> param) throws Exception {
		return delete("inv.deleteSzureTrgter",param);
	}
	public int insertSzureTrgter(Map<String, Object> param) throws Exception {
		insert("inv.insertSzureTrgter", param);
		return 1;
	}
	public List selectSzureTrgterList(Map<String, Object> param) throws Exception {
		return list ("inv.selectSzureTrgterList", param);
	}
	public List selectSzureRstList(Map<String, Object> param) throws Exception {
		return list ("inv.selectSzureRstList", param);
	}
}
