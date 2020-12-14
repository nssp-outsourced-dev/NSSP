package kr.go.nssp.stats.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.nssp.stats.service.InvstsService;

@Service("InvstsService")
public class InvstsServiceImpl implements InvstsService {

	@Resource(name = "invstsDAO")
	private InvstsDAO invstsDAO;

	@Override
	public List<HashMap> selectStsZrlongList(HashMap map) throws Exception {
		return invstsDAO.selectStsZrlongList(map);
	}
	@Override
	public List<HashMap> selectStsArrstList(HashMap map) throws Exception {
		return invstsDAO.selectStsArrstList(map);
	}
	@Override
	public List<HashMap> selectStsSzureList(HashMap map) throws Exception {
		return invstsDAO.selectStsSzureList(map);
	}
	@Override
	public List<HashMap> selectStsAtendList(HashMap map) throws Exception {
		return invstsDAO.selectStsAtendList(map);
	}
	@Override
	public List<HashMap> selectStsCcdrcList(HashMap map) throws Exception {
		return invstsDAO.selectStsCcdrcList(map);
	}
	@Override
	public List<HashMap> selectStsSugestList(HashMap map) throws Exception {
		return invstsDAO.selectStsSugestList(map);
	}
	@Override
	public List<HashMap> selectStprscList(HashMap map) throws Exception {
		return invstsDAO.selectStprscList(map);
	}
	@Override
	public List<HashMap> selectRefeList(HashMap map) throws Exception {
		return invstsDAO.selectRefeList(map);
	}
	@Override
	public List<HashMap> selectVidoTrplant(HashMap map) throws Exception {
		return invstsDAO.selectVidoTrplant(map);
	}

}
