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
}
