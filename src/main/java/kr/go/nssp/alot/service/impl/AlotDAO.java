package kr.go.nssp.alot.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class AlotDAO extends EgovComAbstractDAO {

	public List<HashMap> selectUserList(HashMap map) {
		return list("alot.selectUserList", map);
	}

	public List<HashMap> selectRcTmprAlotHistory(HashMap map) {
		return list("alot.selectRcTmprAlotHistory", map);
	}

	public HashMap selectRcTmprSttus(HashMap map) throws Exception{
		return (HashMap) selectByPk("alot.selectRcTmprSttus", map);
	}

	public HashMap selectRcTmprAlotNow(HashMap map) throws Exception{
		return (HashMap) selectByPk("alot.selectRcTmprAlotNow", map);
	}

	public void insertRcTmprAlot(HashMap map) throws Exception{
		insert("alot.insertRcTmprAlot", map);
	}

	public void updateRcTmprAlotDisable(HashMap map) throws Exception{
		update("alot.updateRcTmprAlotDisable", map);
	}

	public void updateRcTmprChargerId(HashMap map) throws Exception{
		update("alot.updateRcTmprChargerId", map);
	}

	public List<HashMap> selectHndvrList(HashMap map) {
		return list("alot.selectHndvrList", map);
	}
	
	// 2019-08-05 인수인계 (재배당)
	public int updateRcTmprForHndvr(HashMap map) {
		return update("alot.updateRcTmprForHndvr", map);
	}
	
	public int updateRcTmprAlotDisableForHndvr(HashMap map) {
		return update("alot.updateRcTmprAlotDisableForHndvr", map);
	}
	
	public void insertRcTmprAlotForHndvr(HashMap map) throws Exception{
		insert("alot.insertRcTmprAlotForHndvr", map);
	}
	
	public int updateCmnSanctnManageForHndvr(HashMap map) throws Exception{
		return update("alot.updateCmnSanctnManageForHndvr", map);
	}	

}