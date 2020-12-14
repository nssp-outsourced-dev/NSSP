package kr.go.nssp.stats.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class StatsDAO extends EgovComAbstractDAO {

	public List selectCaseManageList(HashMap map) throws Exception {
		return list("stats.selectCaseManageList", map);
	}
	public List selectCrimeCaseList(HashMap map) throws Exception {
		return list("stats.selectCrimeCaseList", map);
	}
	public List selectItivCaseList(HashMap map) throws Exception {
		return list("stats.selectItivCaseList", map);
	}
	
	//메인 사건현황
	public HashMap selectCaseSttusSum(HashMap map) throws Exception {
	    return (HashMap) selectByPk("stats.selectCaseSttusSum", map);
	}
	//메인 접수사건 현황
	public HashMap selectRcCaseSttusSum(HashMap map) throws Exception {
		return (HashMap) selectByPk("stats.selectRcCaseSttusSum", map);
	}
	
	/**
	 * 범죄사건부 피의자 검사처분 및 판결 결과 수정
	 * @param param
	 * @throws Exception
	 */
	public int updateCrimeCaseSuspct( Map<String, Object> param ) throws Exception {
		return update( "stats.updateCrimeCaseSuspct", param );
	}
}
