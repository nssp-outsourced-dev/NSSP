package kr.go.nssp.bbs.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class BbsDAO extends EgovComAbstractDAO {

	public List selectBbsManageList(HashMap map) throws Exception {
		return list("bbs.selectBbsManageList", map);
	}

    public HashMap selectBbsManageDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("bbs.selectBbsManageDetail", map);
    }

	public void insertBbsManage(HashMap map) throws Exception{
	    insert("bbs.insertBbsManage", map);
	}
	
	public void updateBbsManage(HashMap map) throws Exception{
	    update("bbs.updateBbsManage", map);
	}




	public List selectBbsList(HashMap map) throws Exception {
		return list("bbs.selectBbsList", map);
	}

    public HashMap selectBbsDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("bbs.selectBbsDetail", map);
    }
    public List<HashMap> selectBbsPreview(HashMap map) throws Exception {
		return list("bbs.selectBbsPreview", map);
    }
    
	public void insertBbs(HashMap map) throws Exception{
	    insert("bbs.insertBbs", map);
	}
	
	public void updateBbs(HashMap map) throws Exception{
	    update("bbs.updateBbs", map);
	}

	public void deleteBbs(HashMap map) throws Exception{
	    update("bbs.deleteBbs", map);
	}
	public void updateBbsInqireCo(HashMap map) throws Exception{
	    update("bbs.updateBbsInqireCo", map);
	}

	

    public List<HashMap> selectBbsCmntList(HashMap map) throws Exception {
		return list("bbs.selectBbsCmntList", map);
    }

    public HashMap selectBbsCmntDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("bbs.selectBbsCmntDetail", map);
    }

	public void insertBbsCmnt(HashMap map) throws Exception {
	    insert("bbs.insertBbsCmnt", map);
	}

	public void updateBbsCmnt(HashMap map) throws Exception {
	    update("bbs.updateBbsCmnt", map);
	}

	public void deleteBbsCmnt(HashMap map) throws Exception {
	    update("bbs.deleteBbsCmnt", map);
	}

}
