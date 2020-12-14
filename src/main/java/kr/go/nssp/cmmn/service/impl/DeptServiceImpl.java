package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.DeptService;


@Service("DeptService")
public class DeptServiceImpl implements DeptService {

	@Resource(name = "deptDAO")
	private DeptDAO deptDAO;

	public List<HashMap> getDeptFullList(HashMap map) throws Exception {
		return deptDAO.selectDeptFullList(map);
	}

	public List<HashMap> getDeptList(HashMap map) throws Exception {
		return deptDAO.selectDeptList(map);
	}

    public List<HashMap> getDeptRelateList(HashMap map) throws Exception {
		return deptDAO.selectDeptRelateList(map);
	}

	public HashMap getDeptDetail(HashMap map) throws Exception {
		return deptDAO.selectDeptDetail(map);
	}

	public String addDept(HashMap map) throws Exception {
		String dept_cd = deptDAO.selectEsntlDept();
		map.put("dept_cd", dept_cd);
		deptDAO.insertDept(map);
		return dept_cd;
	}

	public void updateDept(HashMap map) throws Exception {
		deptDAO.updateDept(map);
	}

	@Override
	public int getDeptLowerCd(HashMap map) throws Exception {
		return deptDAO.selectDeptLowerCd (map);
	}

}
