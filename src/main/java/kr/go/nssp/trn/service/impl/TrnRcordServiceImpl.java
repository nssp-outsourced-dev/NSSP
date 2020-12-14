package kr.go.nssp.trn.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.nssp.cmmn.service.impl.DocDAO;
import kr.go.nssp.trn.service.TrnRcordService;

import org.springframework.stereotype.Service;

@Service("TrnRcordService")
public class TrnRcordServiceImpl implements TrnRcordService {

	@Resource(name = "TrnRcordDAO")
	private TrnRcordDAO trnRcordDAO;
	
	@Resource(name = "docDAO")
	private DocDAO docDAO;
	
	@Override
	public List selectTrnRcordList(Map<String, String> param) throws Exception {
		return trnRcordDAO.selectTrnRcordList(param);
	}	
	
	@Override
	public void bringTrnRcord(Map<String, Object> param) throws Exception {
		trnRcordDAO.deleteTrnRcordForBring(param);
		trnRcordDAO.insertTrnRcordForBring(param);
	}
	
	@Override
	public int saveTrnRcord(Map<String, Object> param) throws Exception {
		int cnt = 0;
		String writngId = (String)param.get("WRITNG_ID");
		int i = 0;
		
		cnt = trnRcordDAO.deleteTrnRcordAll(param);
		System.out.println("[기록목록전체삭제]cnt: "+ cnt);
		
		// 추가
		List list = new ArrayList();
		list = (List)param.get("rList");
		System.out.println("  list.size(): "+list.size());
		cnt = list.size();
		
		for(Object obj : list) {
			Map map = (HashMap) obj;
			map.put("SORT_ORDR", i++);
			map.put("WRITNG_ID", writngId);
			map.put("UPDT_ID", writngId);
			trnRcordDAO.insertTrnRcord(map);
			System.out.println("기록목록 저장결과 [insert]"+i+")"+map);
		}
			
		return cnt;
	}	

	@Override
	public void insertTrnRcord(Map<String, Object> param) throws Exception {
		trnRcordDAO.insertTrnRcord(param);
	}

	@Override
	public int updateTrnRcord(Map<String, Object> param) throws Exception {
		return trnRcordDAO.updateTrnRcord(param);
	}
	
	@Override
	public int deleteTrnRcord(Map<String, Object> param) throws Exception {
		return trnRcordDAO.deleteTrnRcord(param);
	}
}
