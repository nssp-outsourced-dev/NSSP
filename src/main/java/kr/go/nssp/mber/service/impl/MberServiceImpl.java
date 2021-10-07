package kr.go.nssp.mber.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.go.nssp.mber.service.MberService;

@Service("MberService")
public class MberServiceImpl implements MberService {

	@Resource(name = "mberDAO")
	private MberDAO mberDAO;

    public HashMap userInfo(HashMap map) throws Exception {
        return mberDAO.selectUserInfo(map);
    }

	public void userLog(HashMap map) throws Exception {
        mberDAO.insertUserLog(map);
	}

	public void addAccesLog(HashMap map) throws Exception {
        mberDAO.insertAccesLog(map);
	}

	public String joinUser(HashMap map) throws Exception {
        String esntl_id = mberDAO.selectEsntlID(map);
		map.put("esntl_id", esntl_id);

        mberDAO.insertUser(map);
        return esntl_id;
	}

    public List<HashMap> getUserList(HashMap map) throws Exception {
        return mberDAO.selectUserList(map);
    }

	public void updateUser(HashMap map) throws Exception {
        mberDAO.updateUser(map);
	}

	public void updateEtc(HashMap map) throws Exception {
        mberDAO.updateEtc(map);
	}

    public HashMap getUserIdCnt(HashMap map) throws Exception{
	    return mberDAO.selectUserIdCnt(map);
	}

	public List getAccesHistList(HashMap map) throws Exception {
        return mberDAO.selectAccesHistList(map);
	}
    public List<HashMap> getUserListCombo(HashMap map) throws Exception {
        return mberDAO.selectUserListCombo(map);
    }

	@Override
	public int setFaceTemplate(HashMap map) throws Exception {
		int cnt = mberDAO.selectFaceTemplateCnt(map);
		if(cnt == 0) {
			return mberDAO.insertFaceTemplate(map);
		} else {
			return mberDAO.updateFaceTemplate(map);
		}
	}

	@Override
	public List<HashMap> selectFaceTemplate(HashMap map) throws Exception {
		return mberDAO.selectFaceTemplate(map);
	}

	@Override
	public int deleteBioTmpFile(HashMap map) throws Exception {
		return mberDAO.deleteBioTmpFile(map);
	}

	@Override
	public int updateUserGpkiDn(HashMap map) throws Exception {
		int rtndel = mberDAO.deleteUserGpkiDn(map);
		return mberDAO.updateUserGpkiDn(map);
	}

	@Override
	public HashMap gpkiUserInfo(HashMap map) throws Exception {
		return mberDAO.selectGpkiUserInfo(map);
	}

	@Override
	public int updateFaceLicense(HashMap map) throws Exception {
		return mberDAO.updateFaceLicense(map);
	}

	@Override
	public int updateAllLoginType(HashMap map) throws Exception {
		return mberDAO.updateAllLoginType(map);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.mber.service.MberService#insertAuthorizationLog(java.util.HashMap)
	 */
	@Override
	public void insertAuthorizationLog(HashMap map) throws Exception {
		mberDAO.insertAuthorizationLog(map);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.mber.service.MberService#selectAuthorizationLog(java.util.HashMap)
	 */
	@Override
	public List<HashMap> selectAuthorizationLog(HashMap map) throws Exception {
		return mberDAO.selectAuthorizationLog(map);
	}
}
