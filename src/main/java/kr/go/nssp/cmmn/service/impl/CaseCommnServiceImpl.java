package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.CaseCommnService;

@Service("CaseCommnService")
public class CaseCommnServiceImpl implements CaseCommnService {

	@Resource(name = "caseCommnDAO")
	private CaseCommnDAO caseCommnDAO;

	@Override
	public List<HashMap> selectCaseInfoList(Map map) throws Exception {
		return caseCommnDAO.selectCaseInfoList (map);
	}

}
