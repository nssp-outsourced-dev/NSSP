package kr.go.nssp.inv.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.cmmn.service.FileService;
import kr.go.nssp.inv.service.ArrstService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;

@Service
public class ArrstServiceImpl implements ArrstService {

	@Autowired
	private ArrstDAO arrstDAO;

	@Autowired
	private DocService docService;

	@Autowired
	private FileService fileService;

	@Override
	public List selectSuspectList(Map<String, Object> param) throws Exception {
		return arrstDAO.selectSuspectList(param);
	}

	@Override
	public List selectArrstList(Map<String, Object> param) throws Exception {
		return arrstDAO.selectArrstList(param);
	}

	@Override
	public Map selectArrstDtl(Map<String, Object> param) throws Exception {
		return arrstDAO.selectArrstDtl(param);
	}

	@Override
	public Map saveEmgcArrst(Map<String, Object> param) throws Exception {
		int rst = 0;
		Map rtnMap = new HashMap();
		if(param.get("cud_type")!=null) {
    		if(param.get("cud_type").toString().equals("C")) {
    			//doc_id
    			param.put("doc_id", docService.getDocID());
    			param.put("file_id", fileService.getFileID());
    			rst = arrstDAO.insertEmgcArrst(param);
    		} else if (param.get("cud_type").toString().equals("U")||param.get("cud_type").toString().equals("D")){
    			if(param.get("arrst_sn")!=null && !param.get("arrst_sn").toString().trim().equals("")){
    				rst = arrstDAO.updateEmgcArrst(param);
    				if(rst>0) {
    					rst = Integer.parseInt(param.get("arrst_sn").toString());
    				}
    			}
    		}
    		if(rst > 0) {
    			arrstDAO.updateChngPbYnToRcTmpr (param); //사건 정보 테이블 변경여부 N
    		}
    		rtnMap.put("arrstSn", 	rst);
    		rtnMap.put("rcNo", 	param.get("rc_no"));
    		rtnMap.put("trgterSn", 	param.get("trgter_sn"));
    		rtnMap.put("docId", 	param.get("doc_id"));
    	}
		return rtnMap;
	}
	@Override
	public List selectZrlongList(Map<String, Object> param) throws Exception {
		return arrstDAO.selectZrlongList(param);
	}
	@Override
	public Map selectZrlongDtl(Map<String, Object> param) throws Exception {
		return arrstDAO.selectZrlongDtl(param);
	}
	@Override
	public Map saveZrlong(Map<String, Object> param) throws Exception {
		String rst = "";
		Map rtnMap = new HashMap();
		String strCudType = param.get("cud_type")==null?"":param.get("cud_type").toString().trim();
		if(strCudType.length() > 0) {
    		if(strCudType.equals("C")) {
    			//doc_id
    			param.put("doc_id", docService.getDocID());
    			param.put("file_id", fileService.getFileID());
    			rst = arrstDAO.insertZrlong(param);
    		} else if (strCudType.equals("U")||strCudType.equals("D")){
    			if(param.get("zrlong_reqst_no")!=null && !param.get("zrlong_reqst_no").toString().trim().equals("")){

    				//단, 송치 이후는 삭제 안됨
    				if(strCudType.equals("D")) {
    					List chkCmplLst =  new ArrayList();
        				//List chkCmplLst = arrstDAO.select (param);
    					if(chkCmplLst != null && chkCmplLst.size() > 0) {
	        				rtnMap.put("ERROR", "송치된 이력이 있습니다. 삭제가 불가능한 영장입니다.");
	        				return rtnMap;
    					}
    				}
    				//송치 check

    				int uptrst = arrstDAO.updateZrlong(param);
    				if(uptrst > 0) {
    					rst = param.get("zrlong_reqst_no").toString();
    				}
    			}
    		}
    		//필요고려사항, RC_TMPR 수정가능 여부
    		if(rst != null && !rst.equals("")) {
    			param.put("zrlong_reqst_no",rst);
    			arrstDAO.deleteZrlongNeed(param);
    			String strNeed = param.get("need_cnsdr_cd")==null?"":param.get("need_cnsdr_cd").toString();
    			if( strNeed != null && strNeed.trim().length() > 0 ) {
    				String arrNeed[] = strNeed.split(",");
    				if(arrNeed.length > 0) {
    					param.put("arrNeed",arrNeed);
    					arrstDAO.insertZrlongNeed(param);
    				}
    			}
        		arrstDAO.updateChngPbYnToRcTmpr (param); //사건 정보 테이블 변경여부 N
    		}
    		rtnMap.put("rtnZrlongReqNo", rst);
    	}
		return rtnMap;
	}

	@Override
	public Map saveZrlongRst(Map<String, Object> param) throws Exception {
		String strZrNo = "";
		String strZrReqNo = "";
		Map rtnMap = new HashMap();
		if( param.get("cud_type")!=null ) {
			strZrNo 	= param.get("zrlong_no")!=null?param.get("zrlong_no").toString().trim():"";
			strZrReqNo 	= param.get("zrlong_reqst_no")!=null?param.get("zrlong_reqst_no").toString().trim():"";
			if(strZrReqNo.equals("")){
				rtnMap.put("ERROR", "영장신청번호가 올바르지 않습니다. \n\n 다시 확인해 주세요.");
				return rtnMap;
			}
			if(strZrNo.equals("")){
				rtnMap.put("ERROR", "영장번호가 올바르지 않습니다. \n\n 다시 확인해 주세요.");
				return rtnMap;
			} else {
				List chklst = arrstDAO.selectZrlongNoChk(param);
				int[] chkarr = new int[3];
				if(chklst.size() == 3) {
					for(int i=0; i<3; i++) {
						Map m = (HashMap) chklst.get(i);
						if(m.get("CHK_CNT") == null) {
							rtnMap.put("ERROR", "영장번호의 확인 중 오류가 발생되었습니다.");
		    				return rtnMap;
						}
						chkarr [i] = Integer.parseInt(m.get("CHK_CNT").toString());
					}
				} else {
					rtnMap.put("ERROR", "영장번호의 확인 중 오류가 발생되었습니다.");
    				return rtnMap;
				}
	    		if( param.get("cud_type").toString().equals("C") || param.get("cud_type").toString().equals("U") ) {
	    			int uptrst = 0;
	    			if (chkarr[0] == 0 && chkarr[1] == 0 && chkarr[2] == 0) {
		    			uptrst = arrstDAO.insertZrlongRst(param);
	    			} else if (chkarr[0] == 1 && chkarr[1] == 1 && chkarr[2] == 1) {
	    				uptrst = arrstDAO.updateZrlongRst(param);
	    			} else if (chkarr[0] == 1 && chkarr[1] == 0 && chkarr[2] == 0) {  //다른곳에서 사용중인 영장번호가 없으므로 ok
	    				uptrst = arrstDAO.updateZrlongRst(param);
	    			} else {
	    				rtnMap.put("ERROR", "저장하려는 영장번호가 이미 사용 중 입니다. \n\n 다시 확인해 주세요.");
	    				return rtnMap;
	    			}
	    			//request에 영장번호 update
	    			if(uptrst > 0) {
	    				uptrst = arrstDAO.updateZrlongReqZlNo (param);
	    			}

	    		} else if (param.get("cud_type").toString().equals("D")){
	    			if (chkarr[0] != 1 || chkarr[1] != 1 || chkarr[2] != 1) {
	    				rtnMap.put("ERROR", "삭제하려는 영장번호가 올바르지 않습니다. \n\n 다시 확인하여 주십시오.");
	    				return rtnMap;
	    			}
    				//완전삭제 - 단, 송치 이후는 삭제 안됨
    				List chkCmplLst =  new ArrayList();
    				//List chkCmplLst = arrstDAO.select (param);
    				if(chkCmplLst != null && chkCmplLst.size() > 0) {
    					rtnMap.put("ERROR", "송치된 이력이 있습니다. 삭제가 불가능한 영장입니다.");
    					return rtnMap;
    				} else {
    					int uptrst = arrstDAO.deleteZrlongRst(param);
    					param.put("zrlong_no","");
    					uptrst = arrstDAO.updateZrlongReqZlNo(param);
    				}
	    		}
	    		rtnMap.put("rtnZrlongReqNo", strZrReqNo);
			}
		}
		return rtnMap;
	}

	@Override
	public Map selectStprscDtl(Map<String, Object> param) throws Exception {
		return arrstDAO.selectStprscDtl (param);
	}

	@Override
	public List selectStprscSuspectList(Map<String, Object> param) throws Exception {
		return arrstDAO.selectStprscSuspectList (param);
	}

	@Override
	public int saveStprsc(Map<String, Object> param) throws Exception {
		int t_cnt = arrstDAO.selectStprscCnt (param);
		if(t_cnt == 0) {
			param.put("doc_id", docService.getDocID());
			param.put("file_id", fileService.getFileID());
		}
		return arrstDAO.saveStprsc (param);
	}

	@Override
	public int saveRefestpge(Map<String, Object> param) throws Exception {
		int t_cnt = arrstDAO.selectRefeCnt (param);
		if(t_cnt == 0) {
			param.put("doc_id", docService.getDocID());
			param.put("file_id", fileService.getFileID());
		}
		return arrstDAO.saveRefestpge (param);
	}

	@Override
	public int saveStprscReport(Map<String, Object> param) throws Exception {
		int rVal = 0;
		InvUtil commonUtil = InvUtil.getInstance();
		String selTabId = Utility.nvl(param.get("hidSelTabId"));

		Object od = param.get("grdDel");
		if(od != null) {
			List rtnLst = (ArrayList) od;
			for(Object o : rtnLst) {
				if(o != null) {
					Map rtnMap = commonUtil.getMapToMapConvert((HashMap) o);
					if(selTabId.equals("refe")) rVal += arrstDAO.deleteRefeReport (rtnMap);
					else rVal += arrstDAO.deleteStprscReport (rtnMap);
				}
			}
		}
		Object oa = param.get("grdAdd");
		if(oa != null) {
			List rtnLst = (ArrayList) oa;
			for(Object o : rtnLst) {
				if(o != null) {
					Map rtnMap = commonUtil.getMapToMapConvert((HashMap) o);
					if(selTabId.equals("refe")) rVal += arrstDAO.saveRefeReport (rtnMap);
					else rVal += arrstDAO.saveStprscReport (rtnMap);
				}
			}
		}
		Object oe = param.get("grdEdit");
		if(oe != null) {
			List rtnLst = (ArrayList) oe;
			for(Object o : rtnLst) {
				if(o != null) {
					Map rtnMap = commonUtil.getMapToMapConvert((HashMap) o);
					if(selTabId.equals("refe")) rVal += arrstDAO.saveRefeReport (rtnMap);
					else rVal += arrstDAO.saveStprscReport (rtnMap);
				}
			}
		}
		return rVal;
	}

	@Override
	public List selectStprscReportList(Map<String, Object> param) throws Exception {
		return arrstDAO.selectStprscReportList (param);
	}

	@Override
	public String saveStprscDscvry(Map<String, Object> param) throws Exception {
		return arrstDAO.saveStprscDscvry (param);
	}

	@Override
	public String saveRefeDscvry(Map<String, Object> param) throws Exception {
		return arrstDAO.saveRefeDscvry (param);
	}

	@Override
	public Map selectStprscDscvryDtl(Map<String, Object> param) throws Exception {
		return arrstDAO.selectStprscDscvryDtl (param);
	}

	@Override
	public int deleteStprscDscvry(Map<String, Object> param) throws Exception {
		return arrstDAO.deleteStprscDscvry (param);
	}

	@Override
	public int deleteRefeDscvry(Map<String, Object> param) throws Exception {
		return arrstDAO.deleteRefeDscvry (param);
	}

	@Override
	public int saveResmpt(Map<String, Object> param) throws Exception {
		//rc_tmpr 수정, 사건 송치 사용안함으로 변경 - 사건송치시 기소중지 할 경우 송치 완료 여부도 업데이트 됨
		return arrstDAO.updateResmptToRcTmpr (param);
	}

	@Override
	public List selectRefeSuspectList(Map<String, Object> param) throws Exception {
		return arrstDAO.selectRefeSuspectList (param);
	}

	@Override
	public Map selectRefeDtl(Map<String, Object> param) throws Exception {
		return arrstDAO.selectRefeDtl (param);
	}

	@Override
	public List selectRefeReportList(Map<String, Object> param) throws Exception {
		return arrstDAO.selectRefeReportList (param);
	}

	@Override
	public Map selectRefeDscvryDtl(Map<String, Object> param) throws Exception {
		return arrstDAO.selectRefeDscvryDtl (param);
	}

	@Override
	public Map getStpDocChkAjax(HashMap map) throws Exception {
		return arrstDAO.selectStpDocChkAjax(map);
	}
}
