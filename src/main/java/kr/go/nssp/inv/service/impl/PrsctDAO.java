package kr.go.nssp.inv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class PrsctDAO extends EgovComAbstractDAO {

	public List selectPrsctList(Map<String, Object> param) throws Exception {
		return list("inv.selectPrsctList", param);
	}
	public Map selectAdltPrsctList(Map<String, Object> param) throws Exception {
		Object o = selectByPk("inv.selectAdltPrsctList", param);
		if(o == null) {
			return new HashMap();
		} else {
			return (HashMap) o;
		}
	}
	public List selectRcPrsctList(Map<String, Object> param) throws Exception {
		return list("inv.selectRcPrsctList", param);
	}
	public List selectRcTmprTrgterList(Map<String, Object> param) throws Exception  {
		return list("inv.selectRcTmprTrgterList", param);
	}
	public String prsctProgrsChk(Map<String, Object> param) throws Exception  {
		Object rstObj = selectByPk("inv.prsctProgrsChk", param);
		String rstPg = (rstObj == null)?"":(String) rstObj;
		return rstPg;
	}
	public String selectAditPrsctId() throws Exception {
		return (String) selectByPk("inv.selectAditPrsctId", "");
	}
	public int insertAditPrsctMng(Map<String, Object> param) throws Exception {
		insert("inv.insertAditPrsctMng",param);
		return 1;
	}
	public int updateAditPrsctMng(Map<String, Object> param) throws Exception {
		return update("inv.updateAditPrsctMng",param);
	}
	public int deleteAditPrsct(Map<String, Object> param) throws Exception {
		return delete("inv.deleteAditPrsct",param);
	}
	public int insertAditPrsct(Map<String, Object> param) throws Exception {
		insert("inv.insertAditPrsct",param);
		return 1;
	}
	public int deleteAditPrsctTrgTer(Map<String, Object> param) throws Exception {
		return delete("inv.deleteAditPrsctTrgTer",param);
	}
	public int insertAditPrsctTrgTer(Map<String, Object> param) throws Exception {
		insert("inv.insertAditPrsctTrgTer",param);
		return 1;
	}
	public int updatePrsct(Map<String, Object> param) throws Exception {
		return update("inv.updatePrsct", param);
	}
	public int updatePrsctTrgter(Map<String, Object> param) throws Exception {
		return update ("inv.updatePrsctTrgter", param);
	}
	public List selectProgsToTmpr(Map<String, Object> param) throws Exception {
		return list("inv.selectProgsToTmpr", param);
	}
	public String selectCaseNo() throws Exception {
		return (String) selectByPk("inv.selectCaseNo", new HashMap());
	}
	public int updatePrsctToAdit(Map<String, Object> param) throws Exception {
		return update ("inv.updatePrsctToAdit", param);
	}
	public int updateRcTempSanctn(Map<String, Object> param) throws Exception {
		return update ("inv.updateRcTempSanctn", param);
	}
	public List selectAditPrsctTrgter(Map<String, Object> param) throws Exception {
		return list("inv.selectAditPrsctTrgter", param);
	}
	public List selectPrsctAditTrgterList(Map<String, Object> param) throws Exception {
		return list("inv.selectPrsctAditTrgterList", param);
	}
	public int insertAlot(Map<String, Object> param) throws Exception {
		insert("inv.insertAlot",param);
		return 1;
	}
	public int insertVilot(Map<String, Object> param) throws Exception {
		insert("inv.insertVilot",param);
		return 1;
	}
	public int deleteAditPrsctManage(Map<String, Object> param) throws Exception {
		return delete("inv.deleteAditPrsctManage",param);
	}
	public Map selectDocChk(Map<String, Object> param) throws Exception {
		return (HashMap) selectByPk("inv.selectDocChk", param);
	}
	public Map selectRcTmprChk(Map<String, Object> param) throws Exception {
		return (HashMap) selectByPk("inv.selectRcTmprChk", param);
	}
	public int updatePrsctProgrs(Map<String, Object> param) throws Exception {
		return update("inv.updatePrsctProgrs",param);
	}
	public int insertPrsctCancl(Map<String, Object> param) throws Exception {
		insert("inv.insertPrsctCancl",param);
		return 1;
	}
	public int updatePrsctCancl(Map<String, Object> param) throws Exception {
		return update("inv.updatePrsctCancl",param);
	}
	public List selectCaseList(Map<String, Object> param) throws Exception {
		return list("inv.selectCaseList", param);
	}
	public HashMap selectCaseDocPblicteDetail(Map<String, Object> param) throws Exception {
		Object o = selectByPk("inv.selectCaseDocPblicteDetail", param);
		if(o == null) {
			return null;
		} else {
			return (HashMap) o;
		}
	}
}
