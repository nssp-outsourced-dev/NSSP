package kr.go.nssp.inv.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ArrstService {

	public List selectSuspectList(Map<String, Object> param) throws Exception;
	public List selectArrstList(Map<String, Object> param) throws Exception;
	public Map selectArrstDtl(Map<String, Object> param) throws Exception;
	public Map saveEmgcArrst(Map<String, Object> param) throws Exception;
	public List selectZrlongList(Map<String, Object> param) throws Exception;
	public Map selectZrlongDtl(Map<String, Object> param) throws Exception;
	public Map saveZrlong(Map<String, Object> param) throws Exception;
	public Map saveZrlongRst(Map<String, Object> param) throws Exception;
	public Map selectStprscDtl(Map<String, Object> param) throws Exception;
	public List selectStprscSuspectList(Map<String, Object> param) throws Exception;
	public int saveStprsc(Map<String, Object> param) throws Exception;
	public int saveStprscReport(Map<String, Object> param) throws Exception;
	public List selectStprscReportList(Map<String, Object> param) throws Exception;
	public String saveStprscDscvry(Map<String, Object> param) throws Exception;
	public Map selectStprscDscvryDtl(Map<String, Object> param) throws Exception;
	public int deleteStprscDscvry(Map<String, Object> param) throws Exception;
	public int saveResmpt(Map<String, Object> param) throws Exception;
	public List selectRefeSuspectList(Map<String, Object> param) throws Exception;
	public Map selectRefeDtl(Map<String, Object> param) throws Exception;
	public List selectRefeReportList(Map<String, Object> param) throws Exception;
	public Map selectRefeDscvryDtl(Map<String, Object> param) throws Exception;
	public int saveRefestpge(Map<String, Object> param) throws Exception;
	public String saveRefeDscvry(Map<String, Object> param) throws Exception;
	public int deleteRefeDscvry(Map<String, Object> param) throws Exception;
	public Map getStpDocChkAjax(HashMap map) throws Exception;
}
