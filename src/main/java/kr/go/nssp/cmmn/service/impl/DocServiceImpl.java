package kr.go.nssp.cmmn.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.trn.service.impl.TrnDAO;
import kr.go.nssp.utl.Utility;
import kr.go.nssp.utl.egov.EgovProperties;

@Service("DocService")
public class DocServiceImpl implements DocService {

	@Resource(name = "docDAO")
	private DocDAO docDAO;

	@Resource(name = "TrnDAO")
	private TrnDAO trnDAO;

    public List<HashMap> getFormatList(HashMap map) throws Exception {
        return docDAO.selectFormatList(map);
    }

    public List<HashMap> getFormatInqireList(HashMap map) throws Exception {
        return docDAO.selectFormatInqireList(map);
    }

    public List<HashMap> getFormatClList(HashMap map) throws Exception {
        return docDAO.selectFormatClList(map);
    }

    public HashMap getFormatDetail(HashMap map) throws Exception {
        return docDAO.selectFormatDetail(map);
    }

	public String addFormat(HashMap map) throws Exception {
		String format_id = docDAO.selectFormatID();
		map.put("format_id", format_id);
		docDAO.insertFormatManage(map);
		return format_id;
	}

	public void updateFormat(HashMap map) throws Exception {
		docDAO.updateFormatManage(map);
	}

	public void deleteFormat(HashMap map) throws Exception {
		docDAO.deleteFormatManage(map);
	}


    public List<HashMap> getDocList(HashMap map) throws Exception {
        return docDAO.selectDocList(map);
    }

    public List<HashMap> getDocOwnerList(HashMap map) throws Exception {
        return docDAO.selectDocOwnerList(map);
    }

    public HashMap getDocManageDetail(HashMap map) throws Exception {
        return docDAO.selectDocManageDetail(map);
    }

    //문서발행 상세
    public HashMap getDocPblicteDetail(HashMap map) throws Exception {
    	HashMap rMap = docDAO.selectDocPblicteDetail(map);
    	//파일이 존재하는지 확인
    	String strPath = rMap != null ? ( rMap.get("FILE_PATH") == null ? "" : (String) rMap.get("FILE_PATH") ) : "";

    	System.out.println("##### DocServiceImpl getDocPblicteDetail()::::");

    	String realPath = Utility.HWP_FILE_PATH + strPath;
		System.out.println("##### realPath::::"+realPath);

		File uFile = new File(realPath);

		System.out.println("##### uFile::::"+uFile.exists());
		System.out.println("##### RELATIVE_PATH_PREFIX::::"+EgovProperties.RELATIVE_PATH_PREFIX);
		System.out.println("##### DocServiceImpl  End");

    	/*if(!strPath.trim().equals("")) {	//경로 확인 못함
    		String realPath = Utility.HWP_FILE_PATH + strPath;
    		System.out.println("sjdkajdkasjdl::::" + realPath);
    		File uFile = new File(realPath);
    		boolean fileCheck = false;
    		if (uFile.exists())
				fileCheck = true;
    		System.out.println("dsldkdklsakdlskadksldkldsak2:::"+uFile.isFile());
    		if(!fileCheck){
    			rMap.put("FILE_NM", "");
    			rMap.put("FILE_PATH", "");
    			rMap.put("FILE_MG", "");
    		}
    	}*/
        return rMap;
    }

	public String getDocID() throws Exception {
		return docDAO.selectDocID();
	}

	public String  getFormatNm(String FormatNm) throws Exception {
		return docDAO.selectFormatNm(FormatNm);
	}

	public void addDocManage(HashMap map) throws Exception {
		docDAO.insertDocManage(map);
	}

	public void updateDocManage(HashMap map) throws Exception {
		docDAO.updateDocManage(map);
	}

	public void deleteDocManage(HashMap map) throws Exception {
		docDAO.deleteDocManage(map);
	}


	public int addDocPblicte(HashMap map) throws Exception {
		int pblicte_sn = docDAO.selectPblicteSn(map);
		map.put("pblicte_sn", pblicte_sn);
		docDAO.insertDocPblicte(map);

		System.out.println(">>>>>>>>>>>>> map:"+map);

		// 발생통계원표 "P_TRN_NO="+data.TRN_NO
		if(map.get("format_id").toString().equals("00000000000000000072")) {
			trnDAO.updateTrnCaseForOccrrncZeroNo(map);
		}
		// 검거통계원표 "P_TRN_NO="+trnNo+"&P_RC_NO="+rcNo+"&P_TRGTER_SN="+trgterSn
		else if(map.get("format_id").toString().equals("00000000000000000073")) {
			trnDAO.updateTrnCaseForArrestZeroNo(map);
		}
		// 피의자통계원표 "P_TRN_NO="+trnNo+"&P_RC_NO="+rcNo+"&P_TRGTER_SN="+trgterSn
		else if(map.get("format_id").toString().equals("00000000000000000074")) {
			map.put("SUSPCT_ZERO_NO", trnDAO.selectNewSuspctZeroNo(map));
			trnDAO.updateTrnSuspctForSuspctZeroNo(map);
		}

		return pblicte_sn;
	}

	public void updateDocPblicte(HashMap map) throws Exception {
		docDAO.updateDocPblicte(map);
	}

	public void deleteDocPblicte(HashMap map) throws Exception {
		docDAO.deleteDocPblicte(map);
	}

    public List<HashMap> getCaseDocAllList(HashMap map) throws Exception {
		return docDAO.selectCaseDocAllList(map);
	}

	@Override
	public List<HashMap> selectDocFileList(Map map) throws Exception {
		return docDAO.selectDocFileList(map);
	}

	@Override
	public HashMap getHwpctrlDetail(HashMap map) throws Exception {
		String strFormatId = map.get("FORMAT_ID")==null?"":map.get("FORMAT_ID").toString();
		if(!strFormatId.trim().equals("")) {
			map.put("format_id", strFormatId);
			return docDAO.getHwpctrlDetail(map);
		} else {
			return new HashMap ();
		}
	}

	@Override
	public int updateHwpctrlInfo(HashMap map) throws Exception {
		String strPath = map.get("file_path")==null?"":map.get("file_path").toString();
		strPath = strPath.substring(strPath.indexOf("get")+4);
		map.put("file_path", strPath);
		
		docDAO.insertCmnDocHist(map);
		
		return docDAO.updateHwpctrlInfo(map);
	}

	@Override
	public List<HashMap> getHwpctrlList(HashMap map) throws Exception {

		String strFormatId = map.get("FORMAT_ID")==null?"":map.get("FORMAT_ID").toString();
		if(!strFormatId.trim().equals("")) {
			map.put("format_id", strFormatId);
			return docDAO.getHwpctrlList(map);
		} else {
			return new ArrayList<HashMap> ();
		}
	}

	@Override
	public int updateDocFilePath(HashMap map) throws Exception {
		HashMap sm = docDAO.selecctDocFilePath(map);
		//System.out.println("aaa::"+sm);
		if(sm != null && sm.size() > 0) {
			map.put("file_path", sm.get("FILE_PATH"));
			map.put("file_nm", sm.get("FILE_NM"));
			map.put("file_mg", sm.get("FILE_MG"));
			return docDAO.updateHwpctrlInfo(map);
		} else {
			return 0;
		}
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.cmmn.service.DocService#selectDocHistList(java.util.HashMap)
	 */
	@Override
	public List<HashMap> selectDocHistList(HashMap map) throws Exception {
		List<HashMap> result = docDAO.selectDocHistList(map);
		
		for(HashMap item : result) {
			item.put("fullFilePath", Utility.HWP_FILE_PATH + String.valueOf(item.get("FILE_PATH")));
		}
		
		return result;
	}
}
