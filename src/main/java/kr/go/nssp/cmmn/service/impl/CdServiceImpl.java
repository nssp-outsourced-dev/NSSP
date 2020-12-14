package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.utl.InvUtil;


@Service("CdService")
public class CdServiceImpl implements CdService {

	@Resource(name = "cdDAO")
	private CdDAO cdDAO;

	public List<HashMap> getCdFullList(HashMap map) throws Exception {
		return cdDAO.selectCdFullList(map);
	}

	public List<HashMap> getCdList(HashMap map) throws Exception {
		return cdDAO.selectCdList(map);
	}

    public List<HashMap> getCdRelateList(HashMap map) throws Exception {
		return cdDAO.selectCdRelateList(map);
	}

	public HashMap getCdDetail(HashMap map) throws Exception {
		return cdDAO.selectCdDetail(map);
	}

	public String addCd(HashMap map) throws Exception {
		String esntl_cd = cdDAO.selectEsntlCd();
		map.put("esntl_cd", esntl_cd);
		cdDAO.insertCd(map);
		return esntl_cd;
	}

	public void updateCd(HashMap map) throws Exception {
		cdDAO.updateCd(map);
	}

	@Override
	public List<HashMap> getCdGridList(Map map) throws Exception {
		Map pMap = InvUtil.getInstance().getMapToMapConvert(map);
		return cdDAO.selectCdGridList(pMap);
	}

	@Override
	public int getCdLowerCd(HashMap map) throws Exception {
		return cdDAO.selectCdLowerCd(map);
	}

	@Override
	public List<HashMap> getFaceLicenseList(HashMap map) throws Exception {
		return cdDAO.selectFaceLicenseList(map);
	}

}
