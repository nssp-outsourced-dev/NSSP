package kr.go.nssp.trn.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.nssp.cmmn.service.impl.DocDAO;
import kr.go.nssp.trn.service.TrnCcdrcService;

import org.springframework.stereotype.Service;

@Service("TrnCcdrcService")
public class TrnCcdrcServiceImpl implements TrnCcdrcService {

	@Resource(name = "TrnCcdrcDAO")
	private TrnCcdrcDAO trnCcdrcDAO;
	
	@Resource(name = "docDAO")
	private DocDAO docDAO;
	
	@Override
	public List selectTrnCcdrcList(Map<String, String> param) throws Exception {
		return trnCcdrcDAO.selectTrnCcdrcList(param);
	}	

	@Override
	public void insertTrnCcdrc(Map<String, Object> param) throws Exception {
		trnCcdrcDAO.insertTrnCcdrc(param);
	}

	@Override
	public int updateTrnCcdrc(Map<String, Object> param) throws Exception {
		return trnCcdrcDAO.updateTrnCcdrc(param);
	}
	
	@Override
	public int deleteTrnCcdrc(Map<String, Object> param) throws Exception {
		return trnCcdrcDAO.deleteTrnCcdrc(param);
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public int saveTrnCcdrc(Map<String, Object> param) throws Exception {
		int cnt = 0;
		
		List list = new ArrayList();
		list = (List)param.get("cList");
		String writngId = (String)param.get("WRITNG_ID");
		
		for(Object obj : list) {
			Map map = (HashMap) obj;
			map.put("WRITNG_ID", writngId);
			map.put("UPDT_ID", writngId);
			int i = trnCcdrcDAO.mergerTrnCcdrc(map);
			System.out.println("압수물총목록 저장결과 "+i+")"+map);
		}
		
		return cnt;
	}	
}
