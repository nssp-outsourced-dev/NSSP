package kr.go.nssp.inv.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.cmmn.service.impl.DocDAO;
import kr.go.nssp.inv.service.PrsctService;
import kr.go.nssp.sanctn.service.SanctnService;
import kr.go.nssp.utl.InvUtil;

@Service
public class PrsctServiceImpl implements PrsctService {

	@Resource(name = "prsctDAO")
	private PrsctDAO prsctDAO;

	@Autowired
	private DocService docService;

	@Autowired
	private SanctnService sanctnService;

	@Override
	public List selectPrsctList(Map<String, Object> param) throws Exception {
		return prsctDAO.selectPrsctList (param);
	}

	@Override
	public Map selectAdltPrsctList(Map<String, Object> param) throws Exception {
		return prsctDAO.selectAdltPrsctList (param);
	}

	@Override
	public List selectRcPrsctList(Map<String, Object> param) throws Exception {
		return prsctDAO.selectRcPrsctList (param);
	}

	@Override
	public List selectRcTmprTrgterList(Map<String, Object> param) throws Exception {
		return prsctDAO.selectRcTmprTrgterList (param);
	}

	@Override
	public String prsctProgrsChk(Map<String, Object> param) throws Exception {
		return prsctDAO.prsctProgrsChk (param);
	}

	@Override
	public Map savePrsct(Map<String, Object> param) throws Exception {
		int returnVal = 0;
		Map rtnMap = new HashMap();
		InvUtil commonUtil = InvUtil.getInstance();
		//범죄인지서 및 범죄 인지 보고서가 작성되어 있는지 확인
		/*Map chkDoc = prsctDAO.selectDocChk (param);
		int chkRowCnt = chkDoc.get("CHK_CNT")==null?1:Integer.parseInt(chkDoc.get("CHK_CNT").toString().trim()); 강제 체크
		int chkDocCnt = chkDoc.get("DOC_CNT")==null?0:Integer.parseInt(chkDoc.get("DOC_CNT").toString().trim());
		if(chkDoc != null && chkRowCnt > 0 && chkDocCnt < 2) {
			rtnMap.put("ERROR","입건 전 범죄인지서와 범죄인지 보고서를 작성하여 주십시오.\n\n(고소, 고발을 제외한 사건 접수 건에 한함)");
			return rtnMap;
		}*/
		String strSanctnId = param.get("sanctn_id")==null?"":param.get("sanctn_id").toString().trim();
		if(strSanctnId.equals("") || strSanctnId.equals("undefined")) {
			strSanctnId = "";
		}
		HashMap mm = new HashMap();
		mm.put("sanctn_id", strSanctnId);
		mm.put("esntl_id", param.get("esntl_id"));
		mm.put("dept_cd", param.get("dept_cd"));
		mm.put("regist_path", "입건승인");
		param.put("sanctn_id", sanctnService.insertSanctn(mm));
		
		param.put("progrs_sttus_cd","00222"); //입건승인요청
		param.put("case_no","");
		returnVal = prsctDAO.updateRcTempSanctn (param);
		rtnMap.put("sanctnId", param.get("sanctn_id"));
		return rtnMap;
	}

	@Override
	public String savePrsctCmpl(Map<String, Object> param) throws Exception {
		// 승인처리
		//RC_TMPR 상태 값, caseNo;
		List rtnLst = prsctDAO.selectProgsToTmpr (param);  /*입건승인요청이 들어온 데이터에 한해 승인처리 param:sLst[SANCTN_ID]*/
		int returnVal = 0;
		String rtnCaseNo = "";
		if(rtnLst != null && rtnLst.size() > 0) {
			for(Object o : rtnLst) {
				Map rtnMap = (HashMap) o;
				rtnCaseNo = prsctDAO.selectCaseNo();
				param.put("progrs_sttus_cd","00223"); //입건승인처리
				param.put("case_no",rtnCaseNo);
				param.put("rc_no",rtnMap.get("RC_NO"));
				returnVal = prsctDAO.updateRcTempSanctn (param);
			}
		}
		return rtnCaseNo;
	}
	@Override
	public List selectPrsctAditTrgterList(Map<String, Object> param) throws Exception {
		return prsctDAO.selectPrsctAditTrgterList(param);
	}

	@Override
	public Map cancelPrsct(Map<String, Object> param) throws Exception {
		Map rtnMap = new HashMap();
		int rtnVal = 0;
		//입건 취소 요청
		//테이블 이동
		String strCaseNo = param.get("case_no")==null?"":param.get("case_no").toString().trim();
		if(!strCaseNo.equals("")) {
			//입건취소시...상태코드가 입건 취소 요청이고 SN가 있을 경우... update
			String strCanclSn = param.get("cancl_sn")==null?"":param.get("cancl_sn").toString().trim();
			Map chkProc = prsctDAO.selectRcTmprChk (param);
			int strProc = chkProc.get("PROGRS_STTUS_CD")==null?999:Integer.parseInt(chkProc.get("PROGRS_STTUS_CD").toString().trim());
			if(strProc > 229) {
				rtnMap.put("ERROR","수사지휘 건의 및 송치 진행단계입니다.\n\n위 내용을 먼저 취소 후 사건 승인 취소를 진행하여 주십시오.");
				return rtnMap;
			} else {
				//결재 번호
				String strSanctnId = param.get("sanctn_id")==null?"":param.get("sanctn_id").toString().trim();
				/*신청상태가 아니면*/
				if( strProc != 225 || strSanctnId.equals("") ){
					HashMap mm = new HashMap();
					mm.put( "sanctn_id", strSanctnId);
					mm.put(  "esntl_id",  param.get("esntl_id"));
					mm.put(   "dept_cd",   param.get("dept_cd"));
					mm.put("regist_path", "입건취소");
					param.put("sanctn_id", sanctnService.insertSanctn(mm));
				}
				if(!strCanclSn.equals("")) {
					rtnVal = prsctDAO.updatePrsctCancl  (param);
				} else {
					rtnVal = prsctDAO.insertPrsctCancl  (param);
				}
			}
			rtnVal = prsctDAO.updatePrsctProgrs (param);
			//rtnVal = prsctDAO.updateRcTempToAdit(param);
		} else {
			rtnMap.put("ERROR","사건번호가 확인되지 않습니다.\n\n다시 확인하여 주십시오.");
		}

		return rtnMap;
	}

	@Override
	public List selectCaseList(Map<String, Object> param) throws Exception {
		return prsctDAO.selectCaseList (param);
	}

	@Override
	public Map selectCaseRpt(HashMap param) throws Exception {
		// 조회
		Map rMap = new HashMap ();
		
		if( param.get("fm_type")!=null ){	
			param.put("format_id", String.format("%020d", Integer.parseInt(param.get("fm_type").toString())) );
		} 
		
		/*
		if(param.get("fm_type")!=null && param.get("fm_type").toString().equals("7")) {			//범죄인지서
			param.put("format_id", "00000000000000000007");
		} else if(param.get("fm_type")!=null && param.get("fm_type").toString().equals("8")) {	//범죄인지보고서
			param.put("format_id", "00000000000000000008");
		} else if(param.get("fm_type")!=null && param.get("fm_type").toString().equals("5") ){	//내사사건 기록 표지
			param.put("format_id", "00000000000000000005");
		} else if(param.get("fm_type")!=null && param.get("fm_type").toString().equals("201") ){//임시사건 기록 표지
			param.put("format_id", "00000000000000000201");
		} else if(param.get("fm_type")!=null && param.get("fm_type").toString().equals("202") ){//임시사건 사결 결과보고
			param.put("format_id", "00000000000000000202");
		}
		*/
		
		HashMap rutMap = prsctDAO.selectCaseDocPblicteDetail(param);
		
		if( rutMap == null || rutMap.size() < 1 ){
			param.put("doc_cl_cd", "");
			param.put("input_param", "P_RC_NO="+param.get("rc_no"));
			int rn = docService.addDocPblicte(param);
			rMap.put("pblicteSn", rn);
		} else {
			rMap.put("pblicteSn",rutMap.get("PBLICTE_SN"));
		}
		rMap.put("docId",param.get("doc_id"));
		return rMap;
	}
}
