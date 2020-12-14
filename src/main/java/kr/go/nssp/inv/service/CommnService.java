package kr.go.nssp.inv.service;

import java.util.List;
import java.util.Map;

public interface CommnService {
	public List selectMyCaseList(Map<String, String> param) throws Exception;
	public List selectCommnList(Map<String, String> param) throws Exception;
	public Map selectCommnInfo(Map<String, String> param) throws Exception;
	public String insertCommn(Map<String, String> param) throws Exception;
	public String insertCommnRe(Map<String, String> param) throws Exception;
	public int updateCommn(Map<String, String> param) throws Exception;
	public int updateCommnResult(Map<String, String> param) throws Exception;
	public int deleteCommn(Map<String, String> param) throws Exception;
}
