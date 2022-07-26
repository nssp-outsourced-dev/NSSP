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
	
	/** 
	 * @methodName : updateCmnder
	 * @date : 2021.07.20
	 * @author : dgkim
	 * @description : 
	 * 		사건대장 > 내사사건부 개편으로 인한 지휘자 칼럼 추가 및 업데이트 기능 추가
	 * 		김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateCmnder(List<Map<String, Object>> param) throws Exception;
	
	/** 
	 * @methodName : selectVdecRequstPrmisnReqstList
	 * @date : 2021.08.19
	 * @author : dgkim
	 * @description : 통신사실 확인자료제공 요청허가 신청부(신규 문서 서식)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectVdecRequstPrmisnReqstList(HashMap param) throws Exception;
	
	/** 
	 * @methodName : selectSuspctMatrDscvryList
	 * @date : 2021.09.14
	 * @author : dgkim
	 * @description : 피의자 등 소재발견처리부(신규 문서 서식)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectSuspctMatrDscvryList(HashMap param) throws Exception;
	
	/** 
	 * @methodName : selectCnfscMrnPresvReqstList
	 * @date : 2021.10.05
	 * @author : dgkim
	 * @description : 몰수 부대보전 신청부(신규 문서 서식)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectCnfscMrnPresvReqstList(HashMap param) throws Exception;
	
	/** 
	 * @methodName : selectTrsmrcvComptElcncVrifyExcutFactNticeList
	 * @date : 2021.10.05
	 * @author : dgkim
	 * @description : 송ㆍ수신이 완료된 전기통신에 대한 압수ㆍ수색ㆍ검증 집행사실 통지부(신규 문서 서식)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectTrsmrcvComptElcncVrifyExcutFactNticeList(HashMap param) throws Exception;
	
	/** 
	 * @methodName : selectVdecRequstExcutList
	 * @date : 2021.10.18
	 * @author : dgkim
	 * @description : 통신사실 확인자료제공 요청 집행대장(신규 문서 서식)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectVdecRequstExcutList(HashMap param) throws Exception;
	
	/** 
	 * @methodName : selectVdecRplyRegstrList
	 * @date : 2021.10.18
	 * @author : dgkim
	 * @description : 통신사실 확인자료 회신대장(신규 문서 서식)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectVdecRplyRegstrList(HashMap param) throws Exception;
	
	/** 
	 * @methodName : selectVdecRequstExcutFactList
	 * @date : 2021.10.18
	 * @author : dgkim
	 * @description : 통신사실 확인자료제공 요청 집행사실 통지부(신규 문서 서식)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectVdecRequstExcutFactList(HashMap param) throws Exception;
	
	/** 
	 * @methodName : selectVdecRequstPostpneConfmList
	 * @date : 2021.10.18
	 * @author : dgkim
	 * @description : 통신사실 확인자료제공 요청 집행사실 통지유예 승인신청부(신규 문서 서식)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectVdecRequstPostpneConfmList(HashMap param) throws Exception;
	
	/** 
	 * @methodName : insertStatsOutptHist
	 * @date : 2022.02.09
	 * @author : dgkim
	 * @description : 
	 * @param param
	 * @throws Exception
	 */
	public void insertStatsOutptHist(Map<String, Object> param) throws Exception;
	
	/** 
	 * @methodName : selectStatsOutptHistList
	 * @date : 2022.02.09
	 * @author : dgkim
	 * @description : 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List selectStatsOutptHistList(Map<String, Object> param) throws Exception;
}
