package kr.go.nssp.alot.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.nssp.alot.service.AlotService;


@Service("AlotService")
public class AlotServiceImpl implements AlotService {

	@Resource(name = "alotDAO")
	private AlotDAO alotDAO;

	public List<HashMap> getRcTmprAlotHistory(HashMap map) throws Exception {
		return alotDAO.selectRcTmprAlotHistory(map);
	}

	public List<HashMap> getUserList(HashMap map) throws Exception {
		return alotDAO.selectUserList(map);
	}

    public HashMap getRcTmprSttus(HashMap map) throws Exception {
		return alotDAO.selectRcTmprSttus(map);
	} 

	public HashMap getRcTmprAlotNow(HashMap map) throws Exception {
		return alotDAO.selectRcTmprAlotNow(map);
	}

	/**
	 * 접수사건 배당
	 * rc_no : 접수번호
	 * case_no : 사건번호
	 * alot_dept_cd : 배당 부서
	 * alot_user_id : 배당자 ID
	 * alot_se_cd : 배당 구분
	 * esntl_id : 사용자 ID
	 */
	public void addRcTmprAlot(HashMap map) throws Exception {
		//이전 배당 disable
		alotDAO.updateRcTmprAlotDisable(map);
		String alot_se_cd = (String) map.get("alot_se_cd");
		if("A".equals(alot_se_cd)){
			alotDAO.insertRcTmprAlot(map);
			alotDAO.updateRcTmprChargerId(map);
		}else if("B".equals(alot_se_cd)){
			map.put("alot_user_id", "");
			alotDAO.insertRcTmprAlot(map);
			alotDAO.updateRcTmprChargerId(map);
		}
	}

	public List<HashMap> selectHndvrList(HashMap map) throws Exception {
		return alotDAO.selectHndvrList(map);
	}
	
	public int saveHndvr(HashMap map) throws Exception {
		List list = new ArrayList();
		list = (List)map.get("alotList");
		System.out.println("### 인수인계 사건 수 list.size(): "+list.size());
		int cnt = list.size();

		List arr = new ArrayList();
		for(int i = 0 ; i < list.size() ; i++) {
			HashMap param = new HashMap();
			param = (HashMap) list.get(i);
			
			arr.add(param.get("RC_NO"));
		}

		map.put("rc_no_arr", arr);
		
		int i = alotDAO.updateRcTmprForHndvr(map);
		System.out.println("### 담당자변경 i : "+i);
		if(list.size() != i) {
			throw new Exception("선택한 사건 수("+list.size()+")와 실제 사건 수("+i+")가 다름");
		}
		
		i = alotDAO.updateRcTmprAlotDisableForHndvr(map);
		System.out.println("### 배당자 사용안함 i : "+i);
		if(list.size() != i) {
			throw new Exception("선택한 사건 수("+list.size()+")와 배당 자료 수("+i+")가 다름");
		}		
		
		alotDAO.insertRcTmprAlotForHndvr(map);
		System.out.println("### 새 담당자 insert ");
		
		int a = alotDAO.updateCmnSanctnManageForHndvr(map);
		System.out.println("### 승인요청 부서변경 a : "+a);
		
		return i;
	}	
}
