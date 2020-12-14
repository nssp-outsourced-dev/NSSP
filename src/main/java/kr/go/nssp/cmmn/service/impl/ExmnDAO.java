package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class ExmnDAO extends EgovComAbstractDAO {

	public List selectExmnFullList(HashMap map) throws Exception{
		return list("cmmn.exmn.selectExmnFullList", map);
	}

	public List selectExmnList(HashMap map) throws Exception{
		return list("cmmn.exmn.selectExmnList", map);
	}

	public List selectExmnRelateList(HashMap map) throws Exception{
		return list("cmmn.exmn.selectExmnRelateList", map);
	}

	public HashMap selectExmnDetail(HashMap map) throws Exception{
	    return (HashMap) selectByPk("cmmn.exmn.selectExmnDetail", map);
	}

	public String selectEsntlExmn() throws Exception {
		return (String) selectByPk("cmmn.exmn.selectEsntlExmn", "");
	}

	public void insertExmn(HashMap map) throws Exception{
	    insert("cmmn.exmn.insertExmn", map);
	}

	public void updateExmn(HashMap map) throws Exception{
	    update("cmmn.exmn.updateExmn", map);
	}

	public int selectExmnLowerCd(HashMap map) throws Exception {
		return (int) selectByPk("cmmn.exmn.selectExmnLowerCd", map);
	}

}