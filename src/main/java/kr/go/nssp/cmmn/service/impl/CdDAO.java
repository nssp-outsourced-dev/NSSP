package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class CdDAO extends EgovComAbstractDAO {

	public List selectCdFullList(HashMap map) throws Exception{
		return list("cmmn.cd.selectCdFullList", map);
	}

	public List selectCdList(HashMap map) throws Exception{
		return list("cmmn.cd.selectCdList", map);
	}

	public List selectCdRelateList(HashMap map) throws Exception{
		return list("cmmn.cd.selectCdRelateList", map);
	}

	public HashMap selectCdDetail(HashMap map) throws Exception{
	    return (HashMap) selectByPk("cmmn.cd.selectCdDetail", map);
	}

	public String selectEsntlCd() throws Exception {
		return (String) selectByPk("cmmn.cd.selectEsntlCd", "");
	}

	public void insertCd(HashMap map) throws Exception{
	    insert("cmmn.cd.insertCd", map);
	}

	public void updateCd(HashMap map) throws Exception{
	    update("cmmn.cd.updateCd", map);
	}

	public List<HashMap> selectCdGridList(Map map) throws Exception {
		return list("cmmn.cd.selectCdGridList", map);
	}

	public int selectCdLowerCd(HashMap map) throws Exception {
		return (int) selectByPk("cmmn.cd.selectCdLowerCd", map);
	}

	public List<HashMap> selectFaceLicenseList(HashMap map) throws Exception {
		return list("cmmn.cd.selectFaceLicenseList", map);
	}

}