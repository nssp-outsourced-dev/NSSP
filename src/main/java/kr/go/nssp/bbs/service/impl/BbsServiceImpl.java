package kr.go.nssp.bbs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.go.nssp.bbs.service.BbsService;
import kr.go.nssp.utl.egov.EgovProperties;

@Service("BbsService")
public class BbsServiceImpl implements BbsService {

	@Resource(name = "bbsDAO")
	private BbsDAO bbsDAO;

    public List<HashMap> getBbsManageList(HashMap map) throws Exception {
        return bbsDAO.selectBbsManageList(map);
    }

    public HashMap getBbsManageDetail(HashMap map) throws Exception {
        return bbsDAO.selectBbsManageDetail(map);
    }

    public List<HashMap> getBbsPreview(HashMap map) throws Exception {
        return bbsDAO.selectBbsPreview(map);
    }

	public void addBbsManage(HashMap map) throws Exception {
		bbsDAO.insertBbsManage(map);
	}

	public void updateBbsManage(HashMap map) throws Exception {
		bbsDAO.updateBbsManage(map);
	}




    public List<HashMap> getBbsList(HashMap map) throws Exception {
        return bbsDAO.selectBbsList(map);
    }

    public HashMap getBbsDetail(HashMap map) throws Exception {
        return bbsDAO.selectBbsDetail(map);
    }

	public void addBbs(HashMap map) throws Exception {
		bbsDAO.insertBbs(map);
	}

	public void updateBbs(HashMap map) throws Exception {
		bbsDAO.updateBbs(map);
	}

	public void deleteBbs(HashMap map) throws Exception {
		bbsDAO.deleteBbs(map);
	}
	public void updateBbsInqireCo(HashMap map) throws Exception{
		bbsDAO.updateBbsInqireCo(map);
	}


    public List<HashMap> getBbsCmntList(HashMap map) throws Exception {
        return bbsDAO.selectBbsCmntList(map);
    }

    public HashMap getBbsCmntDetail(HashMap map) throws Exception {
        return bbsDAO.selectBbsCmntDetail(map);
    }

	public void addBbsCmnt(HashMap map) throws Exception {
		bbsDAO.insertBbsCmnt(map);
	}

	public void updateBbsCmnt(HashMap map) throws Exception {
		bbsDAO.updateBbsCmnt(map);
	}

	public void deleteBbsCmnt(HashMap map) throws Exception {
		bbsDAO.deleteBbsCmnt(map);
	}

	
}
