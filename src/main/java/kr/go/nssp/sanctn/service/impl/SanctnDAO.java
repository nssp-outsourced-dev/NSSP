package kr.go.nssp.sanctn.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class SanctnDAO extends EgovComAbstractDAO {

	public String selectSanctnID(HashMap map) throws Exception {
		return (String) selectByPk("sanctn.selectSanctnID", map);
	}

	public HashMap selectSanctnManageDetail(HashMap map) throws Exception {
		return (HashMap) selectByPk("sanctn.selectSanctnManageDetail", map);
	}

	public void insertSanctn(HashMap map) throws Exception {
		insert("sanctn.insertSanctn", map);
	}

	public int updateSanctn(HashMap map) throws Exception {
		return update("sanctn.updateSanctn", map);
	}

	public void insertSanctnConfm(HashMap map) throws Exception {
		insert("sanctn.insertSanctnConfm", map);
	}

	public int updateSanctnConfm(HashMap map) throws Exception {
		return update("sanctn.updateSanctnConfm", map);
	}

	public void updateSanctnConfmDisable(HashMap map) throws Exception {
		update("sanctn.updateSanctnConfmDisable", map);
	}

	public List selectSanctnHistory(HashMap map) throws Exception {
		return list("sanctn.selectSanctnHistory", map);
	}

	public List selectRcTmprList(HashMap map) throws Exception {
		return list("sanctn.selectRcTmprList", map);
	}

	public HashMap selectRcTmprDetail(HashMap map) throws Exception {
		return (HashMap) selectByPk("sanctn.selectRcTmprDetail", map);
	}
	
	public String selectItivNo() throws Exception {
		return (String) selectByPk("sanctn.selectItivNo", new HashMap());
	}
	
	public String selectTmprNo() throws Exception {
		return (String) selectByPk("sanctn.selectTmprNo", new HashMap());
	}	

	public int updateRcTmpr(HashMap map) throws Exception {
		return update("sanctn.updateRcTmpr", map);
	}
	
	// 2019-07-24 사건승인
	public int updateRcTmprForConfm(HashMap map) throws Exception {
		return update("sanctn.updateRcTmprForConfm", map);
	}
	// 2020-02-06 내사/임사 정식사건 처리(범죄인지전)
	public int updateRcTmprForConfmF(HashMap map) throws Exception {
		return update("sanctn.updateRcTmprForConfmF", map);
	}
	
	// 2019-07-25 피의자 구분 update
	public int updateRcTmprSuspctForSeCd(HashMap map) throws Exception {
		return update("sanctn.updateRcTmprSuspctForSeCd", map);
	}

	public int updateInvAditPrsctManage(HashMap map) throws Exception {
		return update("sanctn.updateInvAditPrsctManage", map);
	}

	// 내사결과
	public List selectItivResultList(HashMap map) throws Exception {
		return list("sanctn.selectItivResultList", map);
	}

	public HashMap selectRcItivResultInfo(HashMap map) throws Exception {
		return (HashMap) selectByPk("sanctn.selectRcItivResultInfo", map);
	}

	// 입건승인
	public List selectInvPrsctList(HashMap map) throws Exception {
		return list("sanctn.selectInvPrsctList", map);
	}

	public HashMap selectInvAditPrsctInfo(HashMap map) throws Exception {
		return (HashMap) selectByPk("sanctn.selectInvAditPrsctInfo", map);
	}

	// 입건취소
	public List selectInvPrsctCanclList(HashMap map) throws Exception {
		return list("sanctn.selectInvPrsctCanclList", map);
	}

	public HashMap selectInvPrsctCanclInfo(HashMap map) throws Exception {
		return (HashMap) selectByPk("sanctn.selectInvPrsctCanclInfo", map);
	}

	public int updateInvPrsctCancl(HashMap map) throws Exception {
		return update("sanctn.updateInvPrsctCancl", map);
	}

	// 송치
	public List selectTrnCaseList(HashMap map) throws Exception {
		return list("sanctn.selectTrnCaseList", map);
	}

	public HashMap selectTrnCaseInfo(HashMap map) throws Exception {
		return (HashMap) selectByPk("sanctn.selectTrnCaseInfo", map);
	}

	public int updateInvPrsctForProgrsSttus(HashMap map) throws Exception {
		return update("sanctn.updateInvPrsctForProgrsSttus", map);
	}

	public int updateRcTmprCaseNoCancl(HashMap map) throws Exception {
		return update("sanctn.updateRcTmprCaseNoCancl", map);
	}

	public int updateInvAditPrsctCancl(HashMap map) throws Exception {
		return update("sanctn.updateInvAditPrsctCancl", map);
	}

	// 입건승인/배당 
	public List selectPrsctReqList(HashMap map) throws Exception {
		return list("sanctn.selectPrsctReqList", map);
	}
	
	public HashMap selectRcTmprInfo(HashMap map) throws Exception {
		return (HashMap) selectByPk("sanctn.selectRcTmprInfo", map);
	}	
	
	public int updateRcTmprForCaseNo(HashMap map) throws Exception {
		return update("sanctn.updateRcTmprForCaseNo", map);
	}
	
	// 임시사건 취소승인
	public List selectTmprCanclReqList(HashMap map) throws Exception {
		return list("sanctn.selectTmprCanclReqList", map);
	}	
}
