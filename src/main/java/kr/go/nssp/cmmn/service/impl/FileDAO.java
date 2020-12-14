package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class FileDAO extends EgovComAbstractDAO {

	public List selectFileList(HashMap map) throws Exception {
		return list("cmmn.file.selectFileList", map);
	}

    public HashMap selectFileDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("cmmn.file.selectFileDetail", map);
    }

    public HashMap selectFileManage(HashMap map) throws Exception {
        return (HashMap)selectByPk("cmmn.file.selectFileManage", map);
    }

	public String selectFileID() throws Exception {
		return (String) selectByPk("cmmn.file.selectFileID", "");
	}
	
	public String selectFileSn(HashMap map) throws Exception {
		return (String) selectByPk("cmmn.file.selectFileSn", map);
	}

	public void insertFileManage(HashMap map) throws Exception {
		insert("cmmn.file.insertFileManage", map);
	}

	public void insertFileDetail(HashMap map) throws Exception {
		insert("cmmn.file.insertFileDetail", map);
	}

	public void updateFileDetail(HashMap map) throws Exception {
		update("cmmn.file.updateFileDetail", map);
	}

	public String selectUserTitle(HashMap map) throws Exception {
		return (String) selectByPk("cmmn.file.selectUserTitle", map);
	}

	public HashMap selectBioFileDetail(HashMap map) throws Exception {
		return (HashMap)selectByPk("cmmn.file.selectBioFileDetail", map);
	}

}
