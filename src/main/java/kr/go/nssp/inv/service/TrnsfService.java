package kr.go.nssp.inv.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TrnsfService {
	public List selectTrnsfList(Map<String, String> param) throws Exception;
	public HashMap selectTrnsfInfo(Map<String, String> param) throws Exception;
	public void insertTrnsf(Map<String, Object> param) throws Exception;
	public int updateTrnsf(Map<String, Object> param) throws Exception;
	public int deleteTrnsf(Map<String, Object> param) throws Exception;
}
