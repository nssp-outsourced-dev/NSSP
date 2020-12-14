package kr.go.nssp.cmmn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface CdService {

    public List<HashMap> getCdFullList(HashMap map) throws Exception;

    public List<HashMap> getCdList(HashMap map) throws Exception;

    public List<HashMap> getCdRelateList(HashMap map) throws Exception;

    public HashMap getCdDetail(HashMap map) throws Exception;

    public String addCd(HashMap map) throws Exception;

    public void updateCd(HashMap map) throws Exception;

	public List<HashMap> getCdGridList(Map map) throws Exception;

	public int getCdLowerCd(HashMap map) throws Exception;

	public List<HashMap> getFaceLicenseList(HashMap map) throws Exception;
}
