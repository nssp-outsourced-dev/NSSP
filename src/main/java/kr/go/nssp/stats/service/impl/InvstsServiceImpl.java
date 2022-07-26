package kr.go.nssp.stats.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.nssp.stats.service.InvstsService;

@Service("InvstsService")
public class InvstsServiceImpl implements InvstsService {

	@Resource(name = "invstsDAO")
	private InvstsDAO invstsDAO;

	@Override
	public List<HashMap> selectStsZrlongList(HashMap map) throws Exception {
		return invstsDAO.selectStsZrlongList(map);
	}
	@Override
	public List<HashMap> selectStsArrstList(HashMap map) throws Exception {
		return invstsDAO.selectStsArrstList(map);
	}
	@Override
	public List<HashMap> selectStsSzureList(HashMap map) throws Exception {
		return invstsDAO.selectStsSzureList(map);
	}
	@Override
	public List<HashMap> selectStsAtendList(HashMap map) throws Exception {
		return invstsDAO.selectStsAtendList(map);
	}
	@Override
	public List<HashMap> selectStsCcdrcList(HashMap map) throws Exception {
		return invstsDAO.selectStsCcdrcList(map);
	}
	@Override
	public List<HashMap> selectStsSugestList(HashMap map) throws Exception {
		return invstsDAO.selectStsSugestList(map);
	}
	@Override
	public List<HashMap> selectStprscList(HashMap map) throws Exception {
		return invstsDAO.selectStprscList(map);
	}
	@Override
	public List<HashMap> selectRefeList(HashMap map) throws Exception {
		return invstsDAO.selectRefeList(map);
	}
	@Override
	public List<HashMap> selectVidoTrplant(HashMap map) throws Exception {
		return invstsDAO.selectVidoTrplant(map);
	}
	
	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.InvstsService#updateAtend(java.util.Map)
	 */
	@Override
	public int updateAtend(List<Map<String, Object>> param) throws Exception {
		int cnt = 0;
		
		if(param.size() > 0 ){
			for(Map<String, Object> map : param) {
				cnt += invstsDAO.updateAtend(map);
			}
			
			if(param.size() != cnt) {
				throw new Exception("저장 중 오류 발생했습니다.");
			}
		}
		
		return cnt;
	}
	
	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.InvstsService#updateSugestStats(java.util.Map)
	 */
	@Override
	public int updateSugestStats(List<HashMap> param) throws Exception {
		int cnt = 0;
		
		if(param.size() > 0 ){
			for(HashMap map : param) {
				cnt += invstsDAO.updateSugestStats(map);
			}
			
			if(param.size() != cnt) {
				throw new Exception("저장 중 오류 발생했습니다.");
			}
		}
		
		return cnt;
	}
	
	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.InvstsService#selectArrstNmstList(java.util.HashMap)
	 */
	@Override
	public List<HashMap> selectArrstNmstList(HashMap map) throws Exception {
		return invstsDAO.selectArrstNmstList(map);
	}
}
