package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.ExmnService;


@Service("ExmnService")
public class ExmnServiceImpl implements ExmnService {

	@Resource(name = "exmnDAO")
	private ExmnDAO exmnDAO;

	public List<HashMap> getExmnFullList(HashMap map) throws Exception {
		return exmnDAO.selectExmnFullList(map);
	}

	public List<HashMap> getExmnList(HashMap map) throws Exception {
		return exmnDAO.selectExmnList(map);
	}

    public List<HashMap> getExmnRelateList(HashMap map) throws Exception {
		return exmnDAO.selectExmnRelateList(map);
	}

	public HashMap getExmnDetail(HashMap map) throws Exception {
		return exmnDAO.selectExmnDetail(map);
	}

	public String addExmn(HashMap map) throws Exception {
		String exmn_cd = exmnDAO.selectEsntlExmn();
		map.put("exmn_cd", exmn_cd);
		exmnDAO.insertExmn(map);
		return exmn_cd;
	}

	public void updateExmn(HashMap map) throws Exception {
		exmnDAO.updateExmn(map);
	}

	@Override
	public int getExmnLowerCd(HashMap map) throws Exception {
		return exmnDAO.selectExmnLowerCd (map);
	}

}
