package kr.go.nssp.stats.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface StatsService {
    public List<HashMap> getCaseManageList(HashMap map) throws Exception;
    public List<HashMap> getCrimeCaseList(HashMap map) throws Exception;
    public List<HashMap> getItivCaseList(HashMap map) throws Exception;

	//메인 사건현황 
    public HashMap geCaseSttusSum(HashMap map) throws Exception;
    //메인 접수사건 현황
    public HashMap getRcCaseSttusSum(HashMap map) throws Exception;
    
    //범죄사건부 판사요지/검사요지 사항 저장
	public int saveCrimeCaseSuspct(Map<String, Object> param) throws Exception; 
	
}
