package kr.go.nssp.inv.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.go.nssp.inv.service.SugestService;
import kr.go.nssp.utl.egov.EgovProperties;

@Service
public class SugestServiceImpl implements SugestService {

	//건의구분 : 수사지휘, 피의자석방, 압수물지휘
	private String SUGGEST_CASE1 = EgovProperties.getProperty("Globals.SuggestCase1");
	private String SUGGEST_CASE2 = EgovProperties.getProperty("Globals.SuggestCase2");
	private String SUGGEST_CASE3 = EgovProperties.getProperty("Globals.SuggestCase3");

	@Resource(name = "sugestDAO")
	private SugestDAO sugestDAO;

	@Autowired
	private ArrstDAO arrstDAO;

	public List<HashMap> getInvPrsctList(HashMap map) throws Exception {
		return sugestDAO.selectInvPrsctList(map);
	}

	public List<HashMap> getInvPrsctTrgterList(HashMap map) throws Exception {
		return sugestDAO.selectInvPrsctTrgterList(map);
	}

	public List<HashMap> getInvPrsctArrstList(HashMap map) throws Exception {
		return sugestDAO.selectInvPrsctArrstList(map);
	}

	public List<HashMap> getInvSugestList(HashMap map) throws Exception {
		return sugestDAO.selectInvSugestList(map);
	}

	public HashMap getInvSugestDetail(HashMap map) throws Exception {
		return sugestDAO.selectInvSugestDetail(map);
	}

	public List<HashMap> getInvSugestCcdrcList(HashMap map) throws Exception {
		return sugestDAO.selectInvSugestCcdrcList(map);
	}

	public String addInvSugest(HashMap map) throws Exception {
		String sugestNo = sugestDAO.selectInvSugestNo(map);
		map.put("sugest_no", sugestNo);
		sugestDAO.insertInvSugest(map);

		String sugest_ty_cd = (String) map.get("sugest_ty_cd");
		if(SUGGEST_CASE1.equals(sugest_ty_cd)){
			String esntl_id = (String) map.get("esntl_id");
			String rc_no = (String) map.get("rc_no");
			HashMap sMap = new HashMap();
			sMap.put("rc_no", rc_no);
			sMap.put("progrs_sttus_cd", "02121");
			sMap.put("esntl_id", esntl_id);
			//지휘건의 진행상태로 변경
			sugestDAO.updateRcTmprSttus(sMap);
		}else if(SUGGEST_CASE3.equals(sugest_ty_cd)){
			String esntl_id = (String) map.get("esntl_id");
			String sugest_no = (String) map.get("sugest_no");
			HashMap sMap = new HashMap();
			sMap.put("sugest_no", sugest_no);
			sMap.put("esntl_id", esntl_id);
			String[] ccdrc_list = (String[]) map.get("ccdrc_list");
			for(String ccdrc_obj:ccdrc_list) {
				String[] ccdrc_val = ccdrc_obj.split(":");
				if(ccdrc_val.length == 2){
					sMap.put("ccdrc_no", ccdrc_val[0]);
					sMap.put("ccdrc_sn", ccdrc_val[1]);
					sugestDAO.insertInvSugestCcdrc(sMap);
				}
			}
		}
		if(sugestNo != null && !sugestNo.trim().equals("")) {
			arrstDAO.updateChngPbYnToRcTmpr (map); //사건 정보 테이블 변경여부 N
		}
		return sugestNo;
	}

	public void updateInvSugest(HashMap map) throws Exception {
		int rtnVal = sugestDAO.updateInvSugest(map);

		String sugest_ty_cd = (String) map.get("sugest_ty_cd");
		if(SUGGEST_CASE3.equals(sugest_ty_cd)){
			String sugest_no = (String) map.get("sugest_no");
			String esntl_id = (String) map.get("esntl_id");
			HashMap sMap = new HashMap();
			sMap.put("sugest_no", sugest_no);
			sMap.put("esntl_id", esntl_id);
			sugestDAO.deleteInvSugestCcdrc(map);

			String[] ccdrc_list = (String[]) map.get("ccdrc_list");
			for(String ccdrc_obj:ccdrc_list) {
				String[] ccdrc_val = ccdrc_obj.split(":");
				sMap.put("ccdrc_no", ccdrc_val[0]);
				sMap.put("ccdrc_sn", ccdrc_val[1]);
				sugestDAO.insertInvSugestCcdrc(sMap);
			}
		}
		if(rtnVal > 0) {
			arrstDAO.updateChngPbYnToRcTmpr (map); //사건 정보 테이블 변경여부 N
		}
	}

	public void updateInvSugestDisable(HashMap map) throws Exception {
		sugestDAO.updateInvSugestDisable(map);
	}

	@Override
	public int selectDocChkAjax(HashMap map) throws Exception {
		return sugestDAO.selectDocChkAjax(map);
	}

	@Override
	public int saveTrgterOrder(Map<String, Object> map) throws Exception {
		int rtn = 0;
		List lst = (List) map.get("sList");
		if(lst!=null) {
			int order = 1;
			for(Object o:lst) {
				if(o!=null) {
					HashMap m = (HashMap) o;
					//System.out.println("mmmmmmm:::"+m);
					HashMap sm = new HashMap ();
					sm.put("sort_ordr",order++);
					sm.put("esntl_id",map.get("esntl_id"));
					sm.put("rc_no",m.get("rcNo"));
					sm.put("trgter_sn",m.get("trgterSn"));
					rtn += sugestDAO.saveTrgterOrder(sm);
				}
			}
		}
		return rtn;
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.inv.service.SugestService#updateCmndPrsecNm(java.util.Map)
	 */
	@Override
	public int updateCmndPrsecNm(List<Map<String, Object>> param) throws Exception {
		int cnt = 0;
		
		if(param.size() > 0 ){
			for(Map<String, Object> map : param) {
				cnt += sugestDAO.updateCmndPrsecNm(map);
			}
			
			if(param.size() != cnt) {
				throw new Exception("저장 중 오류 발생했습니다.");
			}
		}
		
		return cnt;
	}
}
