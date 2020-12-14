package kr.go.nssp.bbs.service;

import java.util.HashMap;
import java.util.List;

public interface BbsService {
    public List<HashMap> getBbsManageList(HashMap map) throws Exception;
    public HashMap getBbsManageDetail(HashMap map) throws Exception;
	public void addBbsManage(HashMap map) throws Exception;
	public void updateBbsManage(HashMap map) throws Exception;


    public List<HashMap> getBbsList(HashMap map) throws Exception;
    public HashMap getBbsDetail(HashMap map) throws Exception;
    public List<HashMap> getBbsPreview(HashMap map) throws Exception;
	public void addBbs(HashMap map) throws Exception;
	public void updateBbs(HashMap map) throws Exception;
	public void deleteBbs(HashMap map) throws Exception;
	public void updateBbsInqireCo(HashMap map) throws Exception;


    public List<HashMap> getBbsCmntList(HashMap map) throws Exception;
    public HashMap getBbsCmntDetail(HashMap map) throws Exception;
	public void addBbsCmnt(HashMap map) throws Exception;
	public void updateBbsCmnt(HashMap map) throws Exception;
	public void deleteBbsCmnt(HashMap map) throws Exception;

}
