package kr.go.nssp.trn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TrnService {
	public List selectCaseListForTrn(Map<String, Object> param) throws Exception;
	public HashMap selectTrnCaseInfo(Map<String, String> param) throws Exception;
	public List selectTrnCaseList(Map<String, String> param) throws Exception;
	public List<HashMap> selectTrnCaseStatList(HashMap param) throws Exception;
	public List selectTrnSuspctList(Map<String, String> param) throws Exception;
	public List selectTrnSuspctListOnly(Map<String, String> param) throws Exception;
	public List selectTrnVioltList(Map<String, String> param) throws Exception;
	public List selectTrnVioltListOnly(Map<String, String> param) throws Exception;
	public List selectTrnZeroNoList(Map<String, String> param) throws Exception;
	public List selectOccZeroStatList(Map<String, String> param) throws Exception;
	public List selectArrZeroStatList(Map<String, String> param) throws Exception;
	public List selectSusZeroStatList(Map<String, String> param) throws Exception;
	public Map<String, Object> insertTrnCase(Map<String, Object> param) throws Exception;
	public Map<String, Object> insertReTrnCase(Map<String, Object> param) throws Exception;
	public int updateTrnCase(Map<String, Object> param) throws Exception;
	public int deleteTrnCase(Map<String, Object> param) throws Exception;
	public int requstTrnCase(Map<String, Object> param) throws Exception;
	public int cancelTrnAjax(Map<String, Object> param) throws Exception;
	public Map<String, Object> completTrnCase(Map<String, Object> param) throws Exception;
	public int saveTrnSuspct(Map<String, Object> param) throws Exception;
	public int saveTrnViolt(Map<String, Object> param) throws Exception;
	
	
	/** 
	 * @methodName : updateTrnDe
	 * @date : 2021.06.29
	 * @author : dgkim
	 * @description : 
	 * 		송치일자가 맞지 않을시 변경하도록 조치 
	 * 		김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateTrnDe(List<Map<String, Object>> param) throws Exception;
	
	/** 
	 * @methodName : updateZeroNo
	 * @date : 2021.07.19
	 * @author : dgkim
	 * @description : 
	 * 		송치완료 후에도 피의자 원표 번호 수정 가능하도록 조치
	 * 		김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateZeroNo(List<Map<String, Object>> param) throws Exception;
}
