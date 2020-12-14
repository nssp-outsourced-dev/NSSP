package kr.go.nssp.inv.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.go.nssp.inv.service.RcdMgtService;

@Service
public class RcdMgtServiceImpl implements RcdMgtService {

	@Autowired
	private RcdMgtDAO rcdMgtDAO;

	@Override
	public int saveVdoRec(Map<String, Object> param) throws Exception {
		return rcdMgtDAO.saveVdoRec (param);
	}
}
