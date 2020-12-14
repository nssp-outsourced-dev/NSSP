package kr.go.nssp.inv.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public interface AtendService {
	public List selectTrgterList(Map<String, Object> param) throws Exception;
	public List selectAtendList(Map<String, Object> param) throws Exception;
	public Map saveAtend(Map<String, Object> param) throws Exception;
	public HashMap selectAtendDetail(Map<String, Object> param) throws Exception;
	public List<HashMap> selectRcTrgterList(Map<String, Object> param) throws Exception;
	public List<HashMap> selectRcTrgterDocList(Map<String, Object> param) throws Exception;
}
