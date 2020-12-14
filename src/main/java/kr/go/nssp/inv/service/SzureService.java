package kr.go.nssp.inv.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SzureService {
	public List selectSzureList(Map<String, Object> param) throws Exception;
	public Map saveSzureReq(Map<String, Object> param) throws Exception;
	public Map saveSzureRst(Map<String, Object> param) throws Exception;
	public Map selectSzureDtl(Map<String, Object> param) throws Exception;
	public List selectSzureAcnutList(Map<String, Object> param) throws Exception;
	public List selectSzureTrgterList(Map<String, Object> param) throws Exception;
	public List selectSzureRstList(Map<String, Object> param) throws Exception;
}
