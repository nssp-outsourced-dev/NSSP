package kr.go.nssp.inv.service.impl;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class ArrstDAO extends EgovComAbstractDAO {

	public List selectSuspectList(Map<String, Object> param) throws Exception {
		return list("inv.selectSuspectList", param);
	}

	public List selectArrstList(Map<String, Object> param) throws Exception {
		return list("inv.selectArrstList", param);
	}

	public Map selectArrstDtl(Map<String, Object> param) throws Exception {
		Object o = selectByPk("inv.selectArrstDtl", param);
		if(o == null) {
			return new HashMap();
		} else {
			return (HashMap) o;
		}
	}

	public int insertEmgcArrst(Map<String, Object> param) throws Exception {
		return (int) insert("inv.insertEmgcArrst",param);
	}

	public int updateEmgcArrst(Map<String, Object> param) throws Exception {
		return update("inv.updateEmgcArrst", param);
	}

	public List selectZrlongList(Map<String, Object> param) throws Exception {
		return list("inv.selectZrlongList", param);
	}

	public Map selectZrlongDtl(Map<String, Object> param) throws Exception{
		Object o = selectByPk("inv.selectZrlongDtl", param);
		if(o == null) {
			return new HashMap();
		} else {
			return (HashMap) o;
		}
	}

	public String insertZrlong(Map<String, Object> param) throws Exception {
		return (String) insert("inv.insertZrlong",param);
	}

	public int updateZrlong(Map<String, Object> param) throws Exception {
		return update("inv.updateZrlong", param);
	}

	public int deleteZrlongNeed(Map<String, Object> param) throws Exception {
		return delete("inv.deleteZrlongNeed",param);
	}

	public int insertZrlongNeed(Map<String, Object> param) throws Exception {
		insert("inv.insertZrlongNeed",param);
		return 1;
	}

	public int insertZrlongRst(Map<String, Object> param) throws Exception {
		insert("inv.insertZrlongRst",param);
		return 1;
	}

	public int updateZrlongRst(Map<String, Object> param) throws Exception {
		return update("inv.updateZrlongRst", param);
	}

	public int updateZrlongReqZlNo(Map<String, Object> param) throws Exception {
		return update("inv.updateZrlongReqZlNo", param);
	}

	public int deleteZrlongRst(Map<String, Object> param) throws Exception {
		return delete("inv.deleteZrlongRst", param);
	}

	public List selectZrlongNoChk(Map<String, Object> param) throws Exception {
		return list ("inv.selectZrlongNoChk", param);
	}

	public Map selectStprscDtl(Map<String, Object> param) throws Exception  {
		Object o = selectByPk("inv.selectStprscDtl", param);
		if(o == null) {
			return new HashMap();
		} else {
			return (HashMap) o;
		}
	}

	public List selectStprscSuspectList(Map<String, Object> param) throws Exception {
		return list ("inv.selectStprscSuspectList", param);
	}

	public int saveStprsc(Map<String, Object> param) throws Exception {
		insert("inv.saveStprsc",param);
		return 1;
	}

	public int deleteStprscReport(Map<String, Object> param) throws Exception {
		return delete("inv.deleteStprscReport", param);
	}

	public int saveStprscReport(Map<String, Object> param) throws Exception {
		insert("inv.saveStprscReport", param);
		return 1;
	}

	public List selectStprscReportList(Map<String, Object> param) throws Exception {
		return list ("inv.selectStprscReportList", param);
	}

	public String saveStprscDscvry(Map<String, Object> param) throws Exception {
		return (String) insert("inv.saveStprscDscvry", param);
	}

	public String saveRefeDscvry(Map<String, Object> param) throws Exception {
		return (String) insert("inv.saveRefeDscvry", param);
	}

	public Map selectStprscDscvryDtl(Map<String, Object> param) throws Exception {
		Object o = selectByPk("inv.selectStprscDscvryDtl", param);
		if(o == null) {
			return new HashMap();
		} else {
			return (HashMap) o;
		}
	}

	public int deleteStprscDscvry(Map<String, Object> param) throws Exception {
		return delete("inv.deleteStprscDscvry", param);
	}

	public int deleteRefeDscvry(Map<String, Object> param) throws Exception {
		return delete("inv.deleteRefeDscvry", param);
	}

	public int updateResmptToRcTmpr(Map<String, Object> param) throws Exception {
		return update("inv.updateResmptToRcTmpr", param);
	}

	public List selectRefeSuspectList(Map<String, Object> param) throws Exception {
		return list ("inv.selectRefeSuspectList", param);
	}

	public Map selectRefeDtl(Map<String, Object> param) throws Exception {
		Object o = selectByPk("inv.selectRefeDtl", param);
		if(o == null) {
			return new HashMap();
		} else {
			return (HashMap) o;
		}
	}

	public List selectRefeReportList(Map<String, Object> param) throws Exception {
		return list ("inv.selectRefeReportList", param);
	}

	public Map selectRefeDscvryDtl(Map<String, Object> param) throws Exception {
		Object o = selectByPk("inv.selectRefeDscvryDtl", param);
		if(o == null) {
			return new HashMap();
		} else {
			return (HashMap) o;
		}
	}

	public int selectStprscCnt(Map<String, Object> param) throws Exception {
		return (int) selectByPk("inv.selectStprscCnt", param);
	}

	public int selectRefeCnt(Map<String, Object> param) throws Exception {
		return (int) selectByPk("inv.selectRefeCnt", param);
	}

	public int saveRefestpge(Map<String, Object> param) throws Exception {
		insert("inv.saveRefestpge", param);
		return 1;
	}

	public int deleteRefeReport(Map<String, Object> param) throws Exception {
		return delete("inv.deleteRefeReport", param);
	}

	public int saveRefeReport(Map<String, Object> param) throws Exception {
		insert("inv.saveRefeReport", param);
		return 1;
	}

	public int updateChngPbYnToRcTmpr(Map<String, Object> param) throws Exception {
		return update("inv.updateChngPbYnToRcTmpr", param);
	}

	public Map selectStpDocChkAjax(HashMap map) throws Exception {
		Object o = selectByPk("inv.selectStpDocChkAjax", map);
		if(o == null) {
			return new HashMap();
		} else {
			return (HashMap) o;
		}
	}
}
