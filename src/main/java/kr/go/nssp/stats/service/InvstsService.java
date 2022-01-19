package kr.go.nssp.stats.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface InvstsService {

	public List<HashMap> selectStsZrlongList(HashMap map) throws Exception;
	public List<HashMap> selectStsArrstList(HashMap map) throws Exception;
	public List<HashMap> selectStsSzureList(HashMap map) throws Exception;
	public List<HashMap> selectStsAtendList(HashMap map) throws Exception;
	public List<HashMap> selectStsCcdrcList(HashMap map) throws Exception;
	public List<HashMap> selectStsSugestList(HashMap map) throws Exception;
	public List<HashMap> selectStprscList(HashMap map) throws Exception;
	public List<HashMap> selectRefeList(HashMap map) throws Exception;
	public List<HashMap> selectVidoTrplant(HashMap map) throws Exception;

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
	public int updateAtend(List<Map<String, Object>> param) throws Exception;
	
	/** 
	 * @methodName : updateSugestStats
	 * @date : 2021.08.03
	 * @author : dgkim
	 * @description : 
	 * 		지휘건의부 제출자 입력란 추가
	 * 		김지만 수사관 요청
	 * 		지휘건의부 수령자 입력란 추가
	 * 		김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateSugestStats(List<HashMap> param) throws Exception;
	
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
	public List<HashMap> selectArrstNmstList(HashMap map) throws Exception;
}
