package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.VioltService;


@Service("VioltService")
public class VioltServiceImpl implements VioltService {

	@Resource(name = "violtDAO")
	private VioltDAO violtDAO;

	public List<HashMap> getVioltFullList(HashMap map) throws Exception {
		return violtDAO.selectVioltFullList(map);
	}

	public List<HashMap> getVioltList(HashMap map) throws Exception {
		return violtDAO.selectVioltList(map);
	}

    public List<HashMap> getVioltRelateList(HashMap map) throws Exception {
		return violtDAO.selectVioltRelateList(map);
	}

	public HashMap getVioltDetail(HashMap map) throws Exception {
		return violtDAO.selectVioltDetail(map);
	}

	public String addViolt(HashMap map) throws Exception {
		String violt_cd = violtDAO.selectEsntlViolt();
		map.put("violt_cd", violt_cd);
		violtDAO.insertViolt(map);
		return violt_cd;
	}

	public void updateViolt(HashMap map) throws Exception {
		violtDAO.updateViolt(map);
	}

	@Override
	public int getVioltLowerCd(HashMap map) throws Exception {
		return violtDAO.selectVioltLowerCd (map);
	}

}
