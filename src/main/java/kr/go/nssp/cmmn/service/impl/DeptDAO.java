package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class DeptDAO extends EgovComAbstractDAO {

	public List selectDeptFullList(HashMap map) throws Exception{
		return list("cmmn.dept.selectDeptFullList", map);
	}

	public List selectDeptList(HashMap map) throws Exception{
		return list("cmmn.dept.selectDeptList", map);
	}

	public List selectDeptRelateList(HashMap map) throws Exception{
		return list("cmmn.dept.selectDeptRelateList", map);
	}

	public HashMap selectDeptDetail(HashMap map) throws Exception{
	    return (HashMap) selectByPk("cmmn.dept.selectDeptDetail", map);
	}

	public String selectEsntlDept() throws Exception {
		return (String) selectByPk("cmmn.dept.selectEsntlDept", "");
	}

	public void insertDept(HashMap map) throws Exception{
	    insert("cmmn.dept.insertDept", map);
	}

	public void updateDept(HashMap map) throws Exception{
	    update("cmmn.dept.updateDept", map);
	}

	public int selectDeptLowerCd(HashMap map) throws Exception {
		return (int) selectByPk("cmmn.dept.selectDeptLowerCd", map);
	}

}