package kr.go.nssp.cmmn.service;

import java.util.HashMap;
import java.util.List;

public interface FileService {
    public List<HashMap> getFileList(HashMap map) throws Exception;
    public HashMap getFileDetail(HashMap map) throws Exception;
    public HashMap getFileManage(HashMap map) throws Exception;
	public String getFileID() throws Exception;
	public String getFileSn(HashMap map) throws Exception;
	public void insertFile(HashMap map) throws Exception;
    public void updateFileDetail(HashMap map) throws Exception;
    public String getUserTitle(HashMap map) throws Exception;
	public HashMap getBioFileDetail(HashMap map) throws Exception;
}
