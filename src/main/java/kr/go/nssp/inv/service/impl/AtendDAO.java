package kr.go.nssp.inv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class AtendDAO extends EgovComAbstractDAO {

	public List selectTrgterList(Map<String, Object> param) throws Exception {
		return list("inv.selectTrgterList", param);
	}

	public List selectAtendList(Map<String, Object> param) throws Exception {
		return list("inv.selectAtendList", param);
	}

	public int insertAtend(Map<String, Object> param) throws Exception {
		return (int) insert("inv.insertAtend", param);
	}

	public int updateAtend(Map<String, Object> param) throws Exception {
		return update("inv.updateAtend", param);
	}

	public HashMap selectAtendDetail(Map<String, Object> param) throws Exception {
		Object o = selectByPk("inv.selectAtendDetail", param);
		if (o != null) {
			return (HashMap) o;
		} else {
			return new HashMap();
		}
	}

	public List<HashMap> selectRcTrgterList(Map<String, Object> param) throws Exception {
		return list("inv.selectRcTrgterList", param);
	}

	public List<HashMap> selectRcTrgterDocList(Map<String, Object> param) throws Exception {
		return list("inv.selectRcTrgterDocList", param);
	}
}
