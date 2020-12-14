package kr.go.nssp.inv.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface PrsctService {

	public List selectPrsctList(Map<String, Object> param) throws Exception;
	public Map selectAdltPrsctList(Map<String, Object> param) throws Exception;
	public List selectRcTmprTrgterList(Map<String, Object> param) throws Exception;
	public String prsctProgrsChk(Map<String, Object> param) throws Exception;
	public List selectRcPrsctList(Map<String, Object> param) throws Exception;
	public Map savePrsct(Map<String, Object> param) throws Exception;
	public String savePrsctCmpl(Map<String, Object> param) throws Exception;
	public List selectPrsctAditTrgterList(Map<String, Object> param)throws Exception;
	public Map cancelPrsct(Map<String, Object> param) throws Exception;
	public List selectCaseList(Map<String, Object> param) throws Exception;
	public Map selectCaseRpt(HashMap param) throws Exception;
}
