package kr.go.nssp.cmmn.service;

import java.util.HashMap;
import java.util.List;

public interface PolcService {
	public List<HashMap> getPolcFullList(HashMap map) throws Exception;

    public List<HashMap> getPolcList(HashMap map) throws Exception;

    public HashMap getPolcDetail(HashMap map) throws Exception;

    public String addPolc(HashMap map) throws Exception;

    public void updatePolc(HashMap map) throws Exception;

	public int getPolcLowerCd(HashMap map) throws Exception;
}
