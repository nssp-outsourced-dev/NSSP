package kr.go.nssp.sanctn.service;

import java.util.HashMap;
import java.util.List;

public interface SanctnService {
    public String insertSanctn(HashMap map) throws Exception;
    public void updateSanctn(HashMap map) throws Exception;    
    public List<HashMap> getSanctnHistory(HashMap map) throws Exception;

    // 내사착수
    public List<HashMap> getRcTmprList(HashMap map) throws Exception;	
	public HashMap getRcTmprDetail(HashMap map) throws Exception;
	public void updateRcTmpr(HashMap map) throws Exception;
	
	// 내사결과
	public HashMap selectRcItivResultInfo(HashMap map) throws Exception;
	public List<HashMap> selectItivResultList(HashMap map) throws Exception;
	public int confirmItivResult(HashMap map) throws Exception;
	
	// 입건승인
	public HashMap selectInvAditPrsctInfo(HashMap map) throws Exception;
	public List<HashMap> selectInvPrsctList(HashMap map) throws Exception;
	public int confirmInvPrsct(HashMap map) throws Exception;	

	// 입건취소
	public HashMap selectInvPrsctCanclInfo(HashMap map) throws Exception;	
	public List<HashMap> selectInvPrsctCanclList(HashMap map) throws Exception;
	public int confirmInvPrsctCancl(HashMap map) throws Exception;
	
	// 사건송치
	public HashMap selectTrnCaseInfo(HashMap map) throws Exception;	
	public List<HashMap> selectTrnCaseList(HashMap map) throws Exception;
	public int confirmCaseTrn(HashMap map) throws Exception;
	
	// 입건승인/배당
	public HashMap selectRcTmprInfo(HashMap map) throws Exception;
	public List<HashMap> selectPrsctReqList(HashMap map) throws Exception;
	public int confirmCasePrsct(HashMap map) throws Exception;		
	
	// 임시사건 취소승인
	public List<HashMap> selectTmprCanclReqList(HashMap map) throws Exception;
	public int confirmTmprCancl(HashMap map) throws Exception;
		
}
