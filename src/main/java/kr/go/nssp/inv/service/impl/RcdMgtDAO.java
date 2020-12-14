package kr.go.nssp.inv.service.impl;

import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class RcdMgtDAO extends EgovComAbstractDAO {

	public int saveVdoRec(Map<String, Object> param) throws Exception {
		return update("inv.saveVdoRec", param);
	}

}
