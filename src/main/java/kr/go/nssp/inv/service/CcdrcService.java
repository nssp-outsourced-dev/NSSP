package kr.go.nssp.inv.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface CcdrcService {
	public List selectCcdrcCaseList(Map<String, String> param) throws Exception;
	public List selectCcdrcList(Map<String, String> param) throws Exception;
	public List selectCcdrcNoList(Map<String, String> param) throws Exception;
	public List<HashMap> selectTelCdList() throws Exception;
	public HashMap selectCcdrcTrgterInfo(Map<String, String> param) throws Exception;
	public HashMap selectCcdrcTrgterInfoByPk(Map<String, String> param) throws Exception;
	public List selectCaseTrgterList(Map<String, String> param) throws Exception;
	public HashMap insertCcdrc(Map<String, Object> param) throws Exception;
	public int updateCcdrc(Map<String, Object> param) throws Exception;
	public int deleteCcdrc(Map<String, Object> param) throws Exception;
	public Map<String, String> selectCcdrcDocId(Map<String, Object> param) throws Exception;
}
