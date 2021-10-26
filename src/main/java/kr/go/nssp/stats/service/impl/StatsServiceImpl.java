package kr.go.nssp.stats.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.go.nssp.stats.service.StatsService;
import kr.go.nssp.utl.egov.EgovProperties;

@Service("StatsService")
public class StatsServiceImpl implements StatsService {

	@Resource(name = "statsDAO")
	private StatsDAO statsDAO;

    public List<HashMap> getCaseManageList(HashMap map) throws Exception {
        return statsDAO.selectCaseManageList(map);
    }

    public List<HashMap> getCrimeCaseList(HashMap map) throws Exception {
        return statsDAO.selectCrimeCaseList(map);
    }

    public List<HashMap> getItivCaseList(HashMap map) throws Exception {
        return statsDAO.selectItivCaseList(map);
    }
    
	//메인 사건현황
    public HashMap geCaseSttusSum(HashMap map) throws Exception {
        return statsDAO.selectCaseSttusSum(map);
    }
    
    //메인 접수사건 현황
    public HashMap getRcCaseSttusSum(HashMap map) throws Exception {
    	return statsDAO.selectRcCaseSttusSum(map);
    }

	@Override
	public int saveCrimeCaseSuspct(Map<String, Object> param) throws Exception {
		
		int cnt = 0;
		
		List list = new ArrayList();
		list = (List)param.get("sList");
		
		if(list.size() > 0 ){
			for(Object obj : list) {
				HashMap map = (HashMap)obj;
				map.put("UPDT_ID", param.get("UPDT_ID"));
				cnt += statsDAO.updateCrimeCaseSuspct(map);
			}
			
			if(list.size() != cnt) {
				throw new Exception("송치피의자 저장 중 오류 발생했습니다.");
			}
		}
		
		return cnt;
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.StatsService#updateCmnder(java.util.Map)
	 */
	@Override
	public int updateCmnder(List<Map<String, Object>> param) throws Exception {
		int cnt = 0;
		
		if(param.size() > 0 ){
			for(Map<String, Object> map : param) {
				cnt += statsDAO.updateCmnder(map);
			}
			
			if(param.size() != cnt) {
				throw new Exception("저장 중 오류 발생했습니다.");
			}
		}
		
		return cnt;
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.StatsService#selectVdecRequstPrmisnReqstList(java.util.Map)
	 */
	@Override
	public List<HashMap> selectVdecRequstPrmisnReqstList(HashMap param) throws Exception {
		return statsDAO.selectVdecRequstPrmisnReqstList(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.StatsService#selectSuspctMatrDscvryList(java.util.HashMap)
	 */
	@Override
	public List selectSuspctMatrDscvryList(HashMap param) throws Exception {
		return statsDAO.selectSuspctMatrDscvryList(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.StatsService#selectCnfscMrnPresvReqstList(java.util.HashMap)
	 */
	@Override
	public List selectCnfscMrnPresvReqstList(HashMap param) throws Exception {
		return statsDAO.selectCnfscMrnPresvReqstList(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.StatsService#selectTrsmrcvComptElcncVrifyExcutFactNticeList(java.util.HashMap)
	 */
	@Override
	public List selectTrsmrcvComptElcncVrifyExcutFactNticeList(HashMap param) throws Exception {
		return statsDAO.selectTrsmrcvComptElcncVrifyExcutFactNticeList(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.StatsService#selectVdecRequstExcutList(java.util.HashMap)
	 */
	@Override
	public List selectVdecRequstExcutList(HashMap param) throws Exception {
		return statsDAO.selectVdecRequstExcutList(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.StatsService#selectVdecRplyRegstrList(java.util.HashMap)
	 */
	@Override
	public List selectVdecRplyRegstrList(HashMap param) throws Exception {
		return statsDAO.selectVdecRplyRegstrList(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.StatsService#selectVdecRequstExcutFactList(java.util.HashMap)
	 */
	@Override
	public List selectVdecRequstExcutFactList(HashMap param) throws Exception {
		return statsDAO.selectVdecRequstExcutFactList(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.stats.service.StatsService#selectVdecRequstPostpneConfmList(java.util.HashMap)
	 */
	@Override
	public List selectVdecRequstPostpneConfmList(HashMap param) throws Exception {
		return statsDAO.selectVdecRequstPostpneConfmList(param);
	}
}
