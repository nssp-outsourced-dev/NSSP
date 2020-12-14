package kr.go.nssp.trn.service;

import java.util.List;
import java.util.Map;

public interface TrnRcordService {
	public List selectTrnRcordList(Map<String, String> param) throws Exception;
	public void bringTrnRcord(Map<String, Object> param) throws Exception;
	public int saveTrnRcord(Map<String, Object> param) throws Exception;
	public void insertTrnRcord(Map<String, Object> param) throws Exception;
	public int updateTrnRcord(Map<String, Object> param) throws Exception;
	public int deleteTrnRcord(Map<String, Object> param) throws Exception;
		
}
