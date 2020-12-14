package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class PolcDAO extends EgovComAbstractDAO {
	public List selectPolcFullList(HashMap map) throws Exception{
		return list("cmmn.polc.selectPolcFullList", map);
	}

	public List selectPolcList(HashMap map) throws Exception{
		return list("cmmn.polc.selectPolcList", map);
	}

	public List selectPolcRelateList(HashMap map) throws Exception{
		return list("cmmn.polc.selectPolcRelateList", map);
	}

	public HashMap selectPolcDetail(HashMap map) throws Exception{
	    return (HashMap) selectByPk("cmmn.polc.selectPolcDetail", map);
	}

	public String selectEsntlPolc() throws Exception {
		return (String) selectByPk("cmmn.polc.selectEsntlPolc", "");
	}

	public void insertPolc(HashMap map) throws Exception{
	    insert("cmmn.polc.insertPolc", map);
	}

	public void updatePolc(HashMap map) throws Exception{
	    update("cmmn.polc.updatePolc", map);
	}

	public int selectPolcLowerCd(HashMap map) throws Exception {
		return (int) selectByPk("cmmn.polc.selectPolcLowerCd", map);
	}
}
