package kr.go.nssp.trn.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.nssp.cmmn.service.impl.DocDAO;
import kr.go.nssp.cmmn.service.impl.FileDAO;
import kr.go.nssp.trn.service.TrnService;
import kr.go.nssp.utl.Utility;

import org.springframework.stereotype.Service;

@Service("TrnService")
public class TrnServiceImpl implements TrnService {

	@Resource(name = "TrnDAO")
	private TrnDAO trnDAO;
	
	@Resource(name = "TrnCcdrcDAO")
	private TrnCcdrcDAO trnCcdrcDAO;
	
	@Resource(name = "TrnRcordDAO")
	private TrnRcordDAO trnRcordDAO;
	
	@Resource(name = "docDAO")
	private DocDAO docDAO;
	
	@Resource(name = "fileDAO")
	private FileDAO fileDAO;
	
	@Override
	public List selectCaseListForTrn(Map<String, Object> param) throws Exception {
		return trnDAO.selectCaseListForTrn(param);
	}	
	
	@Override
	public HashMap selectTrnCaseInfo(Map<String, String> param) throws Exception {
		return trnDAO.selectTrnCaseInfo(param);
	}
	
	@Override
	public List selectTrnCaseList(Map<String, String> param) throws Exception {
		return trnDAO.selectTrnCaseList(param);
	}
	
	@Override
    public List<HashMap> selectTrnCaseStatList(HashMap map) throws Exception {
        return trnDAO.selectTrnCaseStatList(map);
    }	

	@Override
	public List selectOccZeroStatList(Map<String, String> param) throws Exception {
		return trnDAO.selectOccZeroStatList(param);
	}		
	
	@Override
	public List selectArrZeroStatList(Map<String, String> param) throws Exception {
		return trnDAO.selectArrZeroStatList(param);
	}		
	
	@Override
	public List selectSusZeroStatList(Map<String, String> param) throws Exception {
		return trnDAO.selectSusZeroStatList(param);
	}		
		
	
	@Override
	public List selectTrnSuspctList(Map<String, String> param) throws Exception {
		return trnDAO.selectTrnSuspctList(param);
	}
	
	@Override
	public List selectTrnSuspctListOnly(Map<String, String> param) throws Exception {
		return trnDAO.selectTrnSuspctListOnly(param);
	}

	@Override
	public List selectTrnVioltList(Map<String, String> param) throws Exception {
		return trnDAO.selectTrnVioltList(param);
	}
	
	@Override
	public List selectTrnVioltListOnly(Map<String, String> param) throws Exception {
		return trnDAO.selectTrnVioltListOnly(param);
	}	
	
	@Override
	public List selectTrnZeroNoList(Map<String, String> param) throws Exception {
		return trnDAO.selectTrnZeroNoList(param);
	}	
	
	@Override
	public Map<String, Object> insertTrnCase(Map<String, Object> param) throws Exception {
		// 송치 등록
		param.put("TRN_NO", trnDAO.selectNewTrnNo());
		param.put("DOC_ID", docDAO.selectDocID());
		param.put("FILE_ID", fileDAO.selectFileID());
		trnDAO.insertTrnCase(param);
		// 송치피의자
		trnDAO.insertTrnSuspct(param);
		// 압수물총목록
		//trnCcdrcDAO.insertTrnCcdrcForTrn(param);
		// 기록목록
		if(trnRcordDAO.selectTrnRcordCount(param) == 0) {
			trnRcordDAO.insertTrnRcord(param);
		}
		//2019-08-30 지휘건의 의견서 복사
		HashMap vMap = new HashMap();
    	vMap.put("doc_id", Utility.nvl(param.get("DOC_ID")));
    	vMap.put("regist_path", "송치저장");
    	vMap.put("dept_cd", Utility.nvl(param.get("DEPT_CD")));
    	vMap.put("esntl_id", Utility.nvl(param.get("WRITNG_ID")));
    	docDAO.insertDocManage(vMap);
    	trnDAO.insertDocPblicteForSugestDoc(param);
		
		// 사건 입건 - 진행상태코드 update
		param.put("PROGRS_STTUS_CD", "02122"); // 송치준비중
		int cnt = trnDAO.updateInvPrsctForTrn(param);
		System.out.println("### 송치저장 > 사건진행상태 변경 cnt : "+ cnt);
		System.out.println("### 송치저장 > param : "+ param);
		return param;
	}
	
	@Override
	public Map<String, Object> insertReTrnCase(Map<String, Object> param) throws Exception {
		int cnt = 0;
		//CASE_NO=2019-000054
		HashMap info = new HashMap();
		info = trnDAO.selectTrnInfoForRe(param); 
		//RC_NO	TRN_YN	TRN_NO	DOC_ID
		//2019-000289	Y	2019-000018	00000000000000002231
		
		if(info == null) {
			throw new Exception("선택한 사건 정보가 존재하지 않습니다.");
		}
		if(!Utility.nvl(info.get("TRN_YN")).equals("Y")) {
			throw new Exception("선택한 사건은 송치된 사건이 아닙니다.");
		}		
		System.out.println("### 재송치 > info:"+info);
		param.put("ORG_TRN_NO", Utility.nvl(info.get("TRN_NO")));
		param.put("ORG_DOC_ID", Utility.nvl(info.get("DOC_ID")));
		param.put("RC_NO", Utility.nvl(info.get("RC_NO")));
		
		// 송치 등록
		param.put("TRN_NO", trnDAO.selectNewTrnNo());
		param.put("DOC_ID", docDAO.selectDocID());
		trnDAO.insertReTrnCase(param);
		// 송치피의자
		trnDAO.insertReTrnSuspct(param);
		// 위반죄명
		trnDAO.insertReTrnViolt(param);
		// 압수물총목록
		trnCcdrcDAO.insertReTrnCcdrc(param);
		// 원 송치번호 비고 update
		cnt = trnDAO.updateTrnCaseForReRm(param);
		System.out.println("### 재송치 > 비고 update cnt : "+cnt);
		
		// 송치문서 copy
		trnDAO.copyTrnCaseDoc(param);
		
		// 사건 입건 - 진행상태코드 update
		param.put("PROGRS_STTUS_CD", "02122"); // 송치준비중
		cnt = trnDAO.updateInvPrsctForTrn(param);
	
		System.out.println("### 재송치 > 사건진행상태 변경 cnt : "+ cnt);
		System.out.println("### 재송치 > param : "+ param);
		return param;
	}	

	@Override
	public int updateTrnCase(Map<String, Object> param) throws Exception {
		return trnDAO.updateTrnCase(param);
	}
	
	@Override
	public int deleteTrnCase(Map<String, Object> param) throws Exception {
		int cnt = trnDAO.deleteTrnCase(param);
		trnDAO.deleteTrnSuspctForUseYn(param);
		trnDAO.deleteTrnVioltForUseYn(param);
		trnDAO.deleteTrnCcdrcForUseYn(param);
		// 기록목록은 지휘건의와 같이 사용하므로 삭제하지 않음
		
		if(cnt > 0) {
			cnt = trnDAO.deleteTrnCaseForInvPrsct(param);
			if(cnt < 1) {
				throw new Exception("송치 삭제중(사건진행상태 변경) 오류가 발생했습니다."+param);
			}
		} else {
			throw new Exception("송치 삭제중 오류가 발생했습니다.");
		}
		
		return cnt;
	}
	
	@Override
	public int requstTrnCase(Map<String, Object> param) throws Exception {
		param.put("PROGRS_STTUS_CD", "00241"); // 송치승인요청
		trnDAO.updateInvPrsctForTrn(param);
		return trnDAO.requstTrnCase(param);
	}
	
	@Override
	public Map<String, Object> completTrnCase(Map<String, Object> param) throws Exception {
		// 송치필수 체크
		trnDAO.callProcedureTrnCheck(param);
		int i = 0;
		
		if("".equals(Utility.nvl(param.get("RE_MSG"))) || "지문원지작성번호를 입력하지 않은 송치피의자가 있습니다.".equals(param.get("RE_MSG")) ){
			// 2019-07-24 송치의견에 따라 사건진행상태 update
			//param.put("PROGRS_STTUS_CD", "00242"); // 송치			
			
			//2020.11.19 권종열 요청
			if( "지문원지작성번호를 입력하지 않은 송치피의자가 있습니다.".equals(param.get("RE_MSG"))){
				param.put("RE_MSG","");
			}
				// 2019-07-24 송치의견에 따라 사건진행상태 update
			
			i = trnDAO.updateInvPrsctForTrnSttus(param);
			if(i > 0) {
				i = trnDAO.updateTrnCaseForEdYn(param);
				if(i < 1) {
					throw new Exception();
				}
			} else {
				param.put("RE_MSG", "사건진행상태 변경 중 오류가 발생했습니다.");
			}
		} else {
			System.out.println(param);
		}	
		
		return param;
	}	
	
	@Override
	public int cancelTrnAjax(Map<String, Object> param) throws Exception {
		param.put("PROGRS_STTUS_CD", "02122"); // 송치준비중
		return trnDAO.updateInvPrsctForTrn(param);
	}
	
	@Override
	public int saveTrnSuspct(Map<String, Object> param) throws Exception {
		int cnt = 0;
		
		List list = new ArrayList();
		list = (List)param.get("sList");
		
		if(list.size() > 0) {
			for(Object obj : list) {
				HashMap map = (HashMap)obj;
				map.put("UPDT_ID", param.get("UPDT_ID"));
				cnt += trnDAO.updateTrnSuspct(map);
			}
			
			if(list.size() != cnt) {
				throw new Exception("송치피의자 저장 중 오류 발생했습니다.");
			}
		}
		
		return cnt;
	}	

	@Override
	public int saveTrnViolt(Map<String, Object> param) throws Exception {
		int cnt = 0;
		
		List list = new ArrayList();
		list = (List)param.get("vList");
		System.out.println("##### 송치위반사항 list:"+list);
		
		if(list.size() > 0) {
			for(Object obj : list) {
				HashMap map = (HashMap)obj;
				System.out.println("##### 송치위반사항 (1) map:"+map);
				if(Utility.nvl(map.get("TRN_NO")).equals("")) {
					map.put("TRN_NO", param.get("trnNo"));
				}
				map.put("WRITNG_ID", param.get("WRITNG_ID"));
				map.put("UPDT_ID", param.get("UPDT_ID"));
				System.out.println("##### 송치위반사항 (2) map:"+map);
				cnt += trnDAO.mergerTrnViolt(map);	
				System.out.println("############## cnt:"+cnt);
			}
			
			if(list.size() != cnt) {
				throw new Exception("송치위반사항 저장 중 오류가 발생했습니다.");
			}
		}
		
		return cnt;
	}	
			
}
