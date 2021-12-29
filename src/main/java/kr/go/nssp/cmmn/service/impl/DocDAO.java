package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class DocDAO extends EgovComAbstractDAO {

	public List selectFormatList(HashMap map) throws Exception {
		return list("doc.selectFormatList", map);
	}
	public List selectFormatInqireList(HashMap map) throws Exception {
		return list("doc.selectFormatInqireList", map);
	}
	public List selectFormatClList(HashMap map) throws Exception {
		return list("doc.selectFormatClList", map);
	}

    public HashMap selectFormatDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("doc.selectFormatDetail", map);
    }

	public String selectFormatID() throws Exception {
		return (String) selectByPk("doc.selectFormatID", "");
	}

	public void insertFormatManage(HashMap map) throws Exception{
	    insert("doc.insertFormatManage", map);
	}

	public void updateFormatManage(HashMap map) throws Exception{
	    update("doc.updateFormatManage", map);
	}

	public void deleteFormatManage(HashMap map) throws Exception{
	    update("doc.deleteFormatManage", map);
	}

	public void updateDlbrtInfo(HashMap map) throws Exception{
	    update("doc.updateDlbrtInfo", map);
	}

	public List selectDocList(HashMap map) throws Exception {
		return list("doc.selectDocList", map);
	}

	public List selectDocOwnerList(HashMap map) throws Exception {
		return list("doc.selectDocOwnerList", map);
	}

	public HashMap selectDocManageDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("doc.selectDocManageDetail", map);
	}

	public HashMap selectDocPblicteDetail(HashMap map) throws Exception {
        return (HashMap)selectByPk("doc.selectDocPblicteDetail", map);
	}

	public String selectDocID() throws Exception {
		return (String) selectByPk("doc.selectDocID", "");
	}

	public void insertDocManage(HashMap map) throws Exception {
	    insert("doc.insertDocManage", map);
	}

	public void updateDocManage(HashMap map) throws Exception {
	    update("doc.updateDocManage", map);
	}

	public void deleteDocManage(HashMap map) throws Exception {
	    update("doc.deleteDocManage", map);
	}


	public int selectPblicteSn(HashMap map) throws Exception {
		return (Integer) selectByPk("doc.selectPblicteSn", map);
	}


	public void insertDocPblicte(HashMap map) throws Exception {
	    insert("doc.insertDocPblicte", map);
	}

	public int updateDocPblicte(HashMap map) throws Exception {
	    return update("doc.updateDocPblicte", map);
	}

	public void deleteDocPblicte(HashMap map) throws Exception {
	    update("doc.deleteDocPblicte", map);
	}

	public List selectCaseDocAllList(HashMap map) throws Exception {
		return list("doc.selectCaseDocAllList", map);
	}
	public List<HashMap> selectDocFileList(Map map) throws Exception  {
		return list("doc.selectDocFileList", map);
	}
	public HashMap getHwpctrlDetail(HashMap map) throws Exception {
		return (HashMap) selectByPk("hwp.selectHwp"+map.get("format_id").toString(), map);
	}
	public List getHwpctrlList(HashMap map) throws Exception {
		return list ("hwp.selectHwp"+map.get("format_id").toString(), map);
	}
	public int updateHwpctrlInfo(HashMap map) throws Exception {
		return update("doc.updateHwpctrlInfo", map);
	}

	public String selectFormatNm(String formatNm) throws Exception {
		// TODO Auto-generated method stub
		return (String)selectByPk("doc.selectFormatNm", formatNm);
	}
	public HashMap selecctDocFilePath(HashMap map) throws Exception {
		HashMap m = new HashMap ();
		Object o = selectByPk("doc.selecctDocFilePath", map);
		if(o != null) m = (HashMap) o;
		return m;
	}
	
	/** 
	 * @methodName : insertCmnDocHist
	 * @date : 2021.11.17
	 * @author : dgkim
	 * @description : 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public void insertCmnDocHist(HashMap map) throws Exception {
		insert("doc.insertCmnDocHist", map);
	}
	
	/** 
	 * @methodName : selectDocHistList
	 * @date : 2021.11.17
	 * @author : dgkim
	 * @description : 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectDocHistList(HashMap map) throws Exception {
		return list("doc.selectDocHistList", map);
	}
}
