package kr.go.nssp.trn.service;

import java.util.List;
import java.util.Map;

public interface TrnCcdrcService {
	public List selectTrnCcdrcList(Map<String, String> param) throws Exception;
	public int saveTrnCcdrc(Map<String, Object> param) throws Exception;
	public void insertTrnCcdrc(Map<String, Object> param) throws Exception;
	public int updateTrnCcdrc(Map<String, Object> param) throws Exception;
	public int deleteTrnCcdrc(Map<String, Object> param) throws Exception;
		
}
