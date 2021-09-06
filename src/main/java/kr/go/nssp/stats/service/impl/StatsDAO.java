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
	
	/** 
	 * @methodName : updateCmnder
	 * @date : 2021.07.20
	 * @author : dgkim
	 * @description : 
	 * 		사건대장 > 내사사건부 개편으로 인한 지휘자 칼럼 추가 및 업데이트 기능 추가
	 *		김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateCmnder(Map<String, Object> param) throws Exception {
		return update("stats.updateCmnder", param);
	}
	
	/** 
	 * @methodName : selectVdecRequstPrmisnReqstList
	 * @date : 2021.08.19
	 * @author : dgkim
	 * @description : 통신사실 확인자료제공 요청허가 신청부(신규 문서 서식)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectVdecRequstPrmisnReqstList(HashMap param) throws Exception {
		return list("stats.selectVdecRequstPrmisnReqstList", param);
	}
}
