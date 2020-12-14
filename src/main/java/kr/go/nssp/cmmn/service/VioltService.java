package kr.go.nssp.cmmn.service;

import java.util.HashMap;
import java.util.List;

public interface VioltService {

    public List<HashMap> getVioltFullList(HashMap map) throws Exception;

    public List<HashMap> getVioltList(HashMap map) throws Exception;

    public HashMap getVioltDetail(HashMap map) throws Exception;

    public String addViolt(HashMap map) throws Exception;

    public void updateViolt(HashMap map) throws Exception;

	public int getVioltLowerCd(HashMap map) throws Exception;


}
