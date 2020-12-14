package kr.go.nssp.inv.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.nssp.cmmn.service.impl.DocDAO;
import kr.go.nssp.cmmn.service.impl.FileDAO;
import kr.go.nssp.inv.service.CcdrcService;
import kr.go.nssp.utl.Utility;

import org.springframework.stereotype.Service;

@Service("CcdrcService")
public class CcdrcServiceImpl implements CcdrcService {

	@Resource(name = "CcdrcDAO")
	private CcdrcDAO ccdrcDAO;
	
	@Resource(name = "docDAO")
	private DocDAO docDAO;
	
	@Resource(name = "fileDAO")
	private FileDAO fileDAO;
	
	@Override
	public List selectCcdrcCaseList(Map<String, String> param) throws Exception {
		return ccdrcDAO.selectCcdrcCaseList(param);
	}	
	
	@Override
	public List selectCcdrcList(Map<String, String> param) throws Exception {
		return ccdrcDAO.selectCcdrcList(param);
	}

	@Override
	public List selectCcdrcNoList(Map<String, String> param) throws Exception {
		return ccdrcDAO.selectCcdrcNoList(param);
	}
	
	@Override
	public List<HashMap> selectTelCdList() throws Exception {
		return ccdrcDAO.selectTelCdList();
	}	

	@Override
	public HashMap selectCcdrcTrgterInfo(Map<String, String> param) throws Exception {
		return ccdrcDAO.selectCcdrcTrgterInfo(param);
	}	

	@Override
	public HashMap selectCcdrcTrgterInfoByPk(Map<String, String> param) throws Exception {
		return ccdrcDAO.selectCcdrcTrgterInfoByPk(param);
	}	
	
	@Override
	public List selectCaseTrgterList(Map<String, String> param) throws Exception {
		return ccdrcDAO.selectCaseTrgterList(param);
	}	
	
	@Override
	public HashMap insertCcdrc(Map<String, Object>  param) throws Exception {
		// 신규인 경우, 압수물번호채번, DOC_ID 채번 
		if(Utility.nvl(param.get("CCDRC_NO")).equals("")) {
			param.put("CCDRC_NO", ccdrcDAO.selectNewCcdrNo());
			param.put("NEW_DOC_ID", docDAO.selectDocID());			
			param.put("NEW_FILE_ID", fileDAO.selectFileID());			
		}

		// 압수물 등록
		String ccdrcSn = ccdrcDAO.insertCcdrc(param);
		param.put("CCDRC_SN", ccdrcSn);

		// 압수대상자 등록
		List<HashMap<String, String>> list = (ArrayList<HashMap<String, String>>) param.get("trgterList");
		
		if(list != null && list.size() > 0) {
			for(HashMap<String, String> paramT : list) {
				paramT.put("CCDRC_NO", Utility.nvl(param.get("CCDRC_NO")));
				paramT.put("CCDRC_SN", Utility.nvl(param.get("CCDRC_SN")));
				ccdrcDAO.insertCcdrcTrgter(paramT);
			}
		}
		
		HashMap reMap = new HashMap();
		reMap.put("RC_NO", Utility.nvl(param.get("RC_NO")));
		reMap.put("CASE_NO", Utility.nvl(param.get("CASE_NO")));
		reMap.put("CCDRC_NO", Utility.nvl(param.get("CCDRC_NO")));
		reMap.put("CCDRC_SN", Utility.nvl(param.get("CCDRC_SN")));
		reMap.put("DOC_ID", Utility.nvl(param.get("NEW_DOC_ID"), Utility.nvl(param.get("DOC_ID"))));
		reMap.put("FILE_ID", Utility.nvl(param.get("NEW_FILE_ID"), Utility.nvl(param.get("FILE_ID"))));
		
		return reMap;
		
	}

	@Override
	public int updateCcdrc(Map<String, Object>  param) throws Exception {
		
		// 압수물 수정
		int cnt = ccdrcDAO.updateCcdrc(param);

		// 압수대상자 등록
		List<HashMap<String, String>> list = (ArrayList<HashMap<String, String>>) param.get("trgterList");

		if(list != null && list.size() > 0) {
			// 압수대상자 삭제
			cnt = ccdrcDAO.deleteCcdrcTrgter(param);
			
			for(HashMap<String, String> paramT : list) {
				paramT.put("CCDRC_NO", Utility.nvl(param.get("CCDRC_NO")));
				paramT.put("CCDRC_SN", Utility.nvl(param.get("CCDRC_SN")));
				ccdrcDAO.insertCcdrcTrgter(paramT);
			}
		}
		
		return cnt;
		
	}

	@Override
	public int deleteCcdrc(Map<String, Object>  param) throws Exception {
		return ccdrcDAO.deleteCcdrc(param);
	}
	
	@Override
	public Map<String, String> selectCcdrcDocId(Map<String, Object> param) throws Exception {
		return ccdrcDAO.selectCcdrcDocId(param);
	}		
}
