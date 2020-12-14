package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class VioltDAO extends EgovComAbstractDAO {

	public List selectVioltFullList(HashMap map) throws Exception{
		return list("cmmn.violt.selectVioltFullList", map);
	}

	public List selectVioltList(HashMap map) throws Exception{
		return list("cmmn.violt.selectVioltList", map);
	}

	public List selectVioltRelateList(HashMap map) throws Exception{
		return list("cmmn.violt.selectVioltRelateList", map);
	}

	public HashMap selectVioltDetail(HashMap map) throws Exception{
	    return (HashMap) selectByPk("cmmn.violt.selectVioltDetail", map);
	}

	public String selectEsntlViolt() throws Exception {
		return (String) selectByPk("cmmn.violt.selectEsntlViolt", "");
	}

	public void insertViolt(HashMap map) throws Exception{
	    insert("cmmn.violt.insertViolt", map);
	}

	public void updateViolt(HashMap map) throws Exception{
	    update("cmmn.violt.updateViolt", map);
	}

	public int selectVioltLowerCd(HashMap map) throws Exception {
		return (int) selectByPk("cmmn.violt.selectVioltLowerCd", map);
	}

}