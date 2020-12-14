package kr.go.nssp.cmmn.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class JusoPopDao extends EgovComAbstractDAO {

	public List selectJusoList(Map<String, Object> param) throws Exception  {
		return list("juso.selectJusoList", param);
	}
}
