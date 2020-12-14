package kr.go.nssp.cmmn.service;

import java.util.HashMap;
import java.util.List;

public interface DeptService {

    public List<HashMap> getDeptFullList(HashMap map) throws Exception;

    public List<HashMap> getDeptList(HashMap map) throws Exception;

    public HashMap getDeptDetail(HashMap map) throws Exception;

    public String addDept(HashMap map) throws Exception;

    public void updateDept(HashMap map) throws Exception;

	public int getDeptLowerCd(HashMap map) throws Exception;


}
