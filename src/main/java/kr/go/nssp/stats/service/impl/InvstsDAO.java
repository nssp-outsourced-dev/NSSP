package kr.go.nssp.stats.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class InvstsDAO extends EgovComAbstractDAO {

	public List selectStsZrlongList(HashMap map) throws Exception {
		return list("invsts.selectStsZrlongList", map);
	}

	public List selectStsArrstList(HashMap map) throws Exception {
		return list("invsts.selectStsArrstList", map);
	}

	public List selectStsSzureList(HashMap map) throws Exception {
		return list("invsts.selectStsSzureList", map);
	}

	public List selectStsAtendList(HashMap map) throws Exception {
		return list("invsts.selectStsAtendList", map);
	}

	public List selectStsCcdrcList(HashMap map) throws Exception {
		return list("invsts.selectStsCcdrcList", map);
	}

	public List<HashMap> selectStsSugestList(HashMap map) throws Exception {
		return list("invsts.selectStsSugestList", map);
	}

	public List<HashMap> selectStprscList(HashMap map) throws Exception {
		return list("invsts.selectStprscList", map);
	}

	public List<HashMap> selectRefeList(HashMap map) throws Exception {
		return list("invsts.selectRefeList", map);
	}

	public List<HashMap> selectVidoTrplant(HashMap map) throws Exception {
		return list("invsts.selectVidoTrplant", map);
	}

}
