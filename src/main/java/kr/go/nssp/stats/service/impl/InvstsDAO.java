package kr.go.nssp.stats.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class InvstsDAO extends EgovComAbstractDAO {

	public List selectStsZrlongList(HashMap map) throws Exception {
		return list("invsts.selectStsZrlongList", map);
	}

	public List selectStsArrstList(HashMap map) throws Exception {
		return list("invsts.selectStsArrstList", map);
	}

	public List selectStsSzureList(HashMap map) throws Exception {
		return list("invsts.selectStsSzureList", map);
	}

	public List selectStsAtendList(HashMap map) throws Exception {
		return list("invsts.selectStsAtendList", map);
	}

	public List selectStsCcdrcList(HashMap map) throws Exception {
		return list("invsts.selectStsCcdrcList", map);
	}

	public List<HashMap> selectStsSugestList(HashMap map) throws Exception {
		return list("invsts.selectStsSugestList", map);
	}

	public List<HashMap> selectStprscList(HashMap map) throws Exception {
		return list("invsts.selectStprscList", map);
	}

	public List<HashMap> selectRefeList(HashMap map) throws Exception {
		return list("invsts.selectRefeList", map);
	}

	public List<HashMap> selectVidoTrplant(HashMap map) throws Exception {
		return list("invsts.selectVidoTrplant", map);
	}
	
	/** 
	 * @methodName : updateAtend
	 * @date : 2021.08.02
	 * @author : dgkim
	 * @description : 
	 * 		출석요구통지부 > 출석요구시간 및 결과 수정 기능 추가
	 * 		김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateAtend(Map<String, Object> param) throws Exception {
		return update("invsts.updateAtend", param);
	}

	/** 
	 * @methodName : updateSugestStats
	 * @date : 2021.08.03
	 * @author : dgkim
	 * @description : 
	 * 		지휘건의부 제출자 입력란 추가
	 * 		김지만 수사관 요청
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int updateSugestStats(HashMap map) throws Exception {
		return update("invsts.updateSugestStats", map);
	}
	
	/** 
	 * @methodName : selectArrstNmstList
	 * @date : 2021.08.10
	 * @author : dgkim
	 * @description : 
	 * 		체포구속인명부 메뉴 추가
	 * 		김지만 수사관 요청
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectArrstNmstList(HashMap map) throws Exception {
		return list("invsts.selectArrstNmstList", map);
	}
}		
