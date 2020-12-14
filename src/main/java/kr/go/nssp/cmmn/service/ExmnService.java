package kr.go.nssp.cmmn.service;

import java.util.HashMap;
import java.util.List;

public interface ExmnService {

    public List<HashMap> getExmnFullList(HashMap map) throws Exception;

    public List<HashMap> getExmnList(HashMap map) throws Exception;

    public HashMap getExmnDetail(HashMap map) throws Exception;

    public String addExmn(HashMap map) throws Exception;

    public void updateExmn(HashMap map) throws Exception;

	public int getExmnLowerCd(HashMap map) throws Exception;


}
