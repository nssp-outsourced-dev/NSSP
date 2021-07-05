package kr.go.nssp.inv.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SugestService {

	public List<HashMap> getInvPrsctList(HashMap map) throws Exception;

	public List<HashMap> getInvPrsctTrgterList(HashMap map) throws Exception;

	public List<HashMap> getInvPrsctArrstList(HashMap map) throws Exception;

	public List<HashMap> getInvSugestList(HashMap map) throws Exception;

	public HashMap getInvSugestDetail(HashMap map) throws Exception;

	public List<HashMap> getInvSugestCcdrcList(HashMap map) throws Exception;

	public String addInvSugest(HashMap map) throws Exception;

	public void updateInvSugest(HashMap map) throws Exception;

	public void updateInvSugestDisable(HashMap map) throws Exception;

	public int selectDocChkAjax(HashMap map) throws Exception;

	public int saveTrgterOrder(Map<String, Object> map) throws Exception;
	
	/** 
	 * @methodName : updateCmndPrsecNm
	 * @date : 2021.06.25
	 * @author : dgkim
	 * @description : 사건종결 후에도 지휘건의 검사명 수정가능하게끔 조치
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateCmndPrsecNm(List<Map<String, Object>> param) throws Exception;
}
