package kr.go.nssp.cmmn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface DocService {
    public List<HashMap> getFormatList(HashMap map) throws Exception;

    public List<HashMap> getFormatInqireList(HashMap map) throws Exception;
    public List<HashMap> getFormatClList(HashMap map) throws Exception;
    public HashMap getFormatDetail(HashMap map) throws Exception;
	public String addFormat(HashMap map) throws Exception;
	public void updateFormat(HashMap map) throws Exception;
	public void deleteFormat(HashMap map) throws Exception;

    public List<HashMap> getDocList(HashMap map) throws Exception;
    public List<HashMap> getDocOwnerList(HashMap map) throws Exception;
    public HashMap getDocManageDetail(HashMap map) throws Exception;
    public HashMap getDocPblicteDetail(HashMap map) throws Exception;
	public String getDocID() throws Exception;
	public void addDocManage(HashMap map) throws Exception;
	public void updateDocManage(HashMap map) throws Exception;
	public void deleteDocManage(HashMap map) throws Exception;

	public int addDocPblicte(HashMap map) throws Exception;
	public void updateDocPblicte(HashMap map) throws Exception;
	public void deleteDocPblicte(HashMap map) throws Exception;

    public List<HashMap> getCaseDocAllList(HashMap map) throws Exception;
	public List<HashMap> selectDocFileList(Map map) throws Exception;

	public HashMap getHwpctrlDetail(HashMap map) throws Exception;

	public int updateHwpctrlInfo(HashMap map) throws Exception;

	public List<HashMap> getHwpctrlList(HashMap map) throws Exception;

	public String getFormatNm(String formatId) throws Exception;

	public int updateDocFilePath(HashMap map) throws Exception;
}
