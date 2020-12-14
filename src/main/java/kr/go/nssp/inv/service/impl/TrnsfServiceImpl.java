package kr.go.nssp.inv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.nssp.cmmn.service.impl.DocDAO;
import kr.go.nssp.inv.service.TrnsfService;
import kr.go.nssp.utl.Utility;

import org.springframework.stereotype.Service;

@Service("TrnsfService")
public class TrnsfServiceImpl implements TrnsfService {

	@Resource(name = "TrnsfDAO")
	private TrnsfDAO trnsfDAO;
	
	@Resource(name = "docDAO")
	private DocDAO docDAO;
	
	@Override
	public List selectTrnsfList(Map<String, String> param) throws Exception {
		return trnsfDAO.selectTrnsfList(param);
	}
	
	@Override
	public HashMap selectTrnsfInfo(Map<String, String> param) throws Exception {
		return trnsfDAO.selectTrnsfInfo(param);
	}	

	@Override
	public void insertTrnsf(Map<String, Object> param) throws Exception {
		// 이송 등록		
		param.put("TRNSF_SN", trnsfDAO.selectNewTrnsSn());
		trnsfDAO.insertTrnsf(param);
		
		// 접수 또는 입건 update
		/*if(!Utility.nvl(param.get("CASE_NO")).equals("")) {
			trnsfDAO.updateInvPrsctForTrnsf(param);
		}*/
		if(!Utility.nvl(param.get("RC_NO")).equals("")) {
			trnsfDAO.updateRcTmprForTrnsf(param);
		} else {
			throw new Exception("사건정보가 올바르지 않습니다.");
		}		
	}

	@Override
	public int updateTrnsf(Map<String, Object> param) throws Exception {
		return trnsfDAO.updateTrnsf(param);
	}
	
	@Override
	public int deleteTrnsf(Map<String, Object> param) throws Exception {
		int cnt = 0;
		cnt = trnsfDAO.deleteTrnsf(param);
		
		if(cnt > 0) {
			cnt = trnsfDAO.deleteTrnsfForCase(param);
			if(cnt < 1) {
				cnt = trnsfDAO.deleteTrnsfForRc(param);
				if(cnt < 1) {
					throw new Exception("이송삭제(사건진행상태) 중 오류가 발생했습니다.("+param.get("TRNSF_SN")+")");
				}
			} 
		} else {
			throw new Exception("이송삭제 중 오류가 발생했습니다.("+param.get("TRNSF_SN")+")");
		}
		
		return cnt;
	}
}
