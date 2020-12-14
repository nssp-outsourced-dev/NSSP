package kr.go.nssp.alot.service;

import java.util.HashMap;
import java.util.List;

public interface AlotService {

	public List<HashMap> getUserList(HashMap map) throws Exception;
	public List<HashMap> getRcTmprAlotHistory(HashMap map) throws Exception;

    public HashMap getRcTmprSttus(HashMap map) throws Exception; 
    public HashMap getRcTmprAlotNow(HashMap map) throws Exception;    
    public void addRcTmprAlot(HashMap map) throws Exception;
    
	public List<HashMap> selectHndvrList(HashMap map) throws Exception;
	public int saveHndvr(HashMap map) throws Exception;

}
