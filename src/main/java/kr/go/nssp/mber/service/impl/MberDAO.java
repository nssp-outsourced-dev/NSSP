package kr.go.nssp.mber.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class MberDAO extends EgovComAbstractDAO {
	public List selectUserList(HashMap map) throws Exception {
		return list("mber.selectUserList", map);
	}

    public HashMap selectUserInfo(HashMap map) throws Exception {
        return (HashMap)selectByPk("mber.selectUserInfo", map);
    }

	public void insertUserLog(HashMap map) throws Exception {
		insert("mber.insertUserLog", map);
	}

	public void insertAccesLog(HashMap map) throws Exception {
		insert("mber.insertAccesLog", map);
	}

	public String selectEsntlID(HashMap map) throws Exception {
		return (String) selectByPk("mber.selectEsntlID", map);
	}

	public void insertUser(HashMap map) throws Exception {
		insert("mber.insertUser", map);
	}

	public void updateUser(HashMap map) throws Exception {
		update("mber.updateUser", map);
	}
	public void updateEtc(HashMap map) throws Exception {
		update("mber.updateEtc", map);
	}

	/*
	 * 2021.10.05
	 * coded by dgkim
	 * 이중회원가입 방지(ID, 메일로 판별) 이메일 중복검사 추가
	 * 권종열 사무관 요청
	 * */
	public List<HashMap> selectUserIdCnt(HashMap map) throws Exception {
		//return (HashMap) selectByPk("mber.selectUserIdCnt", map);
		return list("mber.selectUserIdCnt", map);
	}

	public List selectAccesHistList(HashMap map) throws Exception {
		return list("mber.selectAccesHistList", map);
	}

	public List selectUserListCombo(HashMap map) throws Exception {
		return list("mber.selectUserListCombo", map);
	}

	public int selectFaceTemplateCnt(HashMap map) throws Exception {
		return (int) selectByPk("mber.selectFaceTemplateCnt", map);
	}
	public int updateFaceTemplate(HashMap map) throws Exception {
		return update("mber.updateFaceTemplate", map);
	}
	public int insertFaceTemplate(HashMap map) throws Exception {
		insert("mber.insertFaceTemplate", map);
		return 1;
	}

	public List<HashMap> selectFaceTemplate(HashMap map) throws Exception {
		return list("mber.selectFaceTemplate", map);
	}

	public int deleteBioTmpFile(HashMap map) throws Exception {
		return update("mber.deleteBioTmpFile", map);
	}

	public int updateUserGpkiDn(HashMap map) throws Exception {
		return update("mber.updateUserGpkiDn", map);
	}

	public HashMap selectGpkiUserInfo(HashMap map) throws Exception {
		return (HashMap)selectByPk("mber.selectGpkiUserInfo", map);
	}

	public int updateFaceLicense(HashMap map) throws Exception {
		return update("mber.updateFaceLicense", map);
	}

	public int deleteUserGpkiDn(HashMap map) throws Exception {
		return update("mber.deleteUserGpkiDn", map);
	}

	public int updateAllLoginType(HashMap map) throws Exception {
		return update("mber.updateAllLoginType", map);
	}
	
	/** 
	 * @methodName : insertAuthorizationLog
	 * @date : 2021.06.24
	 * @author : dgkim
	 * @description : 권한부여이력 저장
	 * @param map
	 * @throws Exception
	 */
	public void insertAuthorizationLog(HashMap map) throws Exception {
		insert("mber.insertAuthorizationLog", map);
	}
	
	/** 
	 * @methodName : selectAuthorizationLog
	 * @date : 2021.06.24
	 * @author : dgkim
	 * @description : 권한부여이력 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectAuthorizationLog(HashMap map) throws Exception {
		return list("mber.selectAuthorizationLog", map);
	}
}
