package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class CaseCommnDAO extends EgovComAbstractDAO {

	public List<HashMap> selectCaseInfoList(Map map) throws Exception {
		return list("inv.commn.selectCaseInfoList", map);
	}

}
