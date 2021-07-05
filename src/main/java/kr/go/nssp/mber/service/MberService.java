package kr.go.nssp.mber.service;

import java.util.HashMap;
import java.util.List;

public interface MberService {
    public HashMap userInfo(HashMap map) throws Exception;
    public void userLog(HashMap map) throws Exception;
    public void addAccesLog(HashMap map) throws Exception;
    public String joinUser(HashMap map) throws Exception;
    public List<HashMap> getUserList(HashMap map) throws Exception;
    public void updateUser(HashMap map) throws Exception;
    public void updateEtc(HashMap map) throws Exception;
    public int getUserIdCnt(HashMap map) throws Exception;
	public List getAccesHistList(HashMap map) throws Exception;
    public List<HashMap> getUserListCombo(HashMap map) throws Exception;
    public int setFaceTemplate (HashMap map) throws Exception;
	public List<HashMap> selectFaceTemplate(HashMap map) throws Exception;
	public int deleteBioTmpFile(HashMap map) throws Exception;
	public int updateUserGpkiDn(HashMap map) throws Exception;
	public HashMap gpkiUserInfo(HashMap map) throws Exception;
	public int updateFaceLicense(HashMap map) throws Exception;
	public int updateAllLoginType(HashMap map) throws Exception;
	
	/** 
	 * @methodName : insertAuthorizationLog
	 * @date : 2021.06.24
	 * @author : dgkim
	 * @description : 권한부여이력 저장
	 * @param map
	 * @throws Exception
	 */
	public void insertAuthorizationLog(HashMap map) throws Exception;
	
	/** 
	 * @methodName : selectAuthorizationLog
	 * @date : 2021.06.24
	 * @author : dgkim
	 * @description : 권한부여이력 조회
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectAuthorizationLog(HashMap map) throws Exception;
}
