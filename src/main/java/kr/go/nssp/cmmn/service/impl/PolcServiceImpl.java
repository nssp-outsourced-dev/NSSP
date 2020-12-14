package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.PolcService;

@Service("PolcService")
public class PolcServiceImpl implements PolcService {

	@Resource(name = "polcDAO")
	private PolcDAO polcDAO;

	public List<HashMap> getPolcFullList(HashMap map) throws Exception {
		return polcDAO.selectPolcFullList(map);
	}

	public List<HashMap> getPolcList(HashMap map) throws Exception {
		return polcDAO.selectPolcList(map);
	}

    public List<HashMap> getPolcRelateList(HashMap map) throws Exception {
		return polcDAO.selectPolcRelateList(map);
	}

	public HashMap getPolcDetail(HashMap map) throws Exception {
		return polcDAO.selectPolcDetail(map);
	}

	public String addPolc(HashMap map) throws Exception {
		String polc_cd = polcDAO.selectEsntlPolc();
		map.put("polc_cd", polc_cd);
		polcDAO.insertPolc(map);
		return polc_cd;
	}

	public void updatePolc(HashMap map) throws Exception {
		polcDAO.updatePolc(map);
	}

	@Override
	public int getPolcLowerCd(HashMap map) throws Exception {
		return polcDAO.selectPolcLowerCd(map);
	}
}
