package kr.go.nssp.inv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class SugestDAO extends EgovComAbstractDAO {

	public List<HashMap> selectInvPrsctList(HashMap map) {
		return list("sugest.selectInvPrsctList", map);
	}

	public List<HashMap> selectInvPrsctTrgterList(HashMap map) {
		return list("sugest.selectInvPrsctTrgterList", map);
	}

	public List<HashMap> selectInvPrsctArrstList(HashMap map) {
		return list("sugest.selectInvPrsctArrstList", map);
	}

	public List<HashMap> selectInvSugestList(HashMap map) {
		return list("sugest.selectInvSugestList", map);
	}

	public HashMap selectInvSugestDetail(HashMap map) throws Exception{
	    return (HashMap) selectByPk("sugest.selectInvSugestDetail", map);
	}

	public List<HashMap> selectInvSugestCcdrcList(HashMap map) {
		return list("sugest.selectInvSugestCcdrcList", map);
	}

	public String selectInvSugestNo(HashMap map) throws Exception{
	    return (String) selectByPk("sugest.selectInvSugestNo", map);
	}

	public void insertInvSugest(HashMap map) throws Exception{
	    insert("sugest.insertInvSugest", map);
	}

	public int updateInvSugest(HashMap map) throws Exception{
		return update("sugest.updateInvSugest", map);
	}

	public void updateInvSugestDisable(HashMap map) throws Exception{
		update("sugest.updateInvSugestDisable", map);
	}

	public void insertInvSugestCcdrc(HashMap map) throws Exception{
		insert("sugest.insertInvSugestCcdrc", map);
	}

	public void deleteInvSugestCcdrc(HashMap map) throws Exception{
		delete("sugest.deleteInvSugestCcdrc", map);
	}


	public void updateRcTmprSttus(HashMap map) throws Exception{
		update("sugest.updateRcTmprSttus", map);
	}

	public int selectDocChkAjax(HashMap map) throws Exception {
		return (int) selectByPk("sugest.selectDocChkAjax", map);
	}

	public int saveTrgterOrder(Map<String, Object> map) throws Exception {
		return update("sugest.saveTrgterOrder", map);
	}

	/** 
	 * @methodName : updateCmndPrsecNm
	 * @date : 2021.06.25
	 * @author : dgkim
	 * @description : 사건종결 후에도 지휘건의 검사명 수정가능하게끔 조치
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateCmndPrsecNm(Map<String, Object> param) throws Exception {
		return update("sugest.updateCmndPrsecNm", param);
	}
}
