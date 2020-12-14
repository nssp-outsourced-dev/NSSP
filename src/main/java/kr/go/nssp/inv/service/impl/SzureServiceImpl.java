package kr.go.nssp.inv.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.cmmn.service.FileService;
import kr.go.nssp.inv.service.SzureService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.Utility;

@Service
public class SzureServiceImpl implements SzureService {

	@Autowired
	private SzureDAO szureDAO;

	@Autowired
	private DocService docService;

	@Autowired
	private FileService fileService;

	@Autowired
	private ArrstDAO arrstDAO;

	@Override
	public List selectSzureList(Map<String, Object> param) throws Exception {
		return szureDAO.selectSzureList(param);
	}

	@Override
	public Map selectSzureDtl(Map<String, Object> param) throws Exception {
		return szureDAO.selectSzureDtl(param);
	}

	@Override
	public Map saveSzureReq(Map<String, Object> param) throws Exception {
		String rst = "";
		Map rtnMap = new HashMap();
		String strCudType = param.get("cud_type")==null?"":param.get("cud_type").toString().trim();
		if(strCudType.length() > 0) {
    		if(strCudType.equals("C")) {
    			//doc_id
    			param.put("doc_id", docService.getDocID());
    			param.put("file_id", fileService.getFileID());
    			rst = szureDAO.insertSzureReq (param);
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

    				int uptrst = szureDAO.updateSzureReq(param);
    				if(uptrst > 0) {
    					rst = param.get("zrlong_reqst_no").toString();
    				}
    			}
    		}
    		if(rst != null && !rst.equals("")) {
    			//피의자
    			Object ot = param.get("trgter_data");
    			if(ot != null) {
    				String strO = (String) ot;
    				JSONParser jsonParser  	= new JSONParser();
			        JSONArray jsonObj = (JSONArray) jsonParser.parse(strO);
			        List gLst = Utility.getInstance().getListMapFromJsonArray(jsonObj);

			        if(gLst.size() > 0) {
			        	param.put("zrlong_reqst_no",rst);
    					param.put("trgter_data",gLst);
    					if(!strCudType.equals("C")) {
    						szureDAO.deleteSzureTrgter (param);
    					}
    					szureDAO.insertSzureTrgter (param);
			        }
    			}
    			//계좌
    			Object o = param.get("acnut_data");
    			if(o != null) {
    				String strO = (String) o;
	    			JSONParser jsonParser  	= new JSONParser();
			        JSONArray jsonObj = (JSONArray) jsonParser.parse(strO);
			        List gLst = Utility.getInstance().getListMapFromJsonArray(jsonObj);

    				//삭제, 저장
    				if(gLst.size() > 0) {
    					param.put("zrlong_reqst_no",rst);
    					param.put("acnut_data",gLst);
    					if(!strCudType.equals("C")) {
    						szureDAO.deleteSzureAcnut (param);
    					}
    					szureDAO.insertSzureAcnut (param);
    				}
    			}
    			arrstDAO.updateChngPbYnToRcTmpr (param); //사건 정보 테이블 변경여부 N
    		}
    		rtnMap.put("rtnZrlongReqNo", rst);
    	}
		return rtnMap;
	}
	public List checkSzureNo(Object po) throws Exception {
		String strO = (String) po;
		JSONParser jsonParser  	= new JSONParser();
        JSONArray jsonObj = (JSONArray) jsonParser.parse(strO);
        List gLst = Utility.getInstance().getListMapFromJsonArray(jsonObj);
        List<HashMap> rtnLst = new ArrayList<HashMap> ();

		if(gLst.size() > 0) {
        	//해당 결과 삭제
        	for(Object o : gLst) {
        		if(o != null) {
        			HashMap mm = InvUtil.getInstance().getMapToMapConvert((HashMap) o);
        			System.out.println("dksjafdosivocxzvcvkzcx:::"+mm);
        			String strZrNo 		= mm.get("zrlong_no")!=null?mm.get("zrlong_no").toString().trim():"";
        			String strZrReqNo  	= mm.get("zrlong_reqst_no")!=null?mm.get("zrlong_reqst_no").toString().trim():"";
        			if(!strZrNo.equals("") && !strZrReqNo.equals("")) {
        				rtnLst.add (mm);
        			}
        		}
        	}
        }
		return rtnLst;
	}

	@Override
	public Map saveSzureRst(Map<String, Object> param) throws Exception {
		int uptrst = 0;
		String strZrNo = "";
		String strZrReqNo = "";
		Map rtnMap = new HashMap();
		List<String> errNoLst = new ArrayList<String>();

		Object od = param.get("rst_del");
		if(od != null) {
			List<HashMap> rtnLst = checkSzureNo (od);
			//완전삭제 - 단, 송치 이후는 삭제 안됨
			List chkCmplLst =  new ArrayList();
			//List chkCmplLst = arrstDAO.select (rtnLst);
			if(chkCmplLst != null && chkCmplLst.size() > 0) {
				rtnMap.put("ERROR", "송치된 이력이 있습니다. 삭제가 불가능한 영장입니다.");
				return rtnMap;
			} else {
				for(HashMap mm : rtnLst) {
		    	  	uptrst = szureDAO.deleteSzureRst(mm);
				}
			}
		}
		//수정
		Object oe = param.get("rst_edit");
		if(oe != null) {
			List<HashMap> rtnLst = checkSzureNo (oe);
			for(HashMap mm : rtnLst) {
			   int chklst = szureDAO.selectSzureZlNoChk (mm);
			   if(chklst > 0) {
				   errNoLst.add(mm.get("zrlong_no").toString());
			   } else {
				   mm.put("upt_type", "main");
				   uptrst = szureDAO.updateSzureRst(mm);
			   }
			}
		}
		//추가
		Object oa = param.get("rst_add");
		if(oa != null) {
			List<HashMap> rtnLst = checkSzureNo (oa);
			for(HashMap mm : rtnLst) {
			   int chklst = szureDAO.selectSzureZlNoChk (mm);
			   if(chklst > 0) {
				   errNoLst.add(mm.get("zrlong_no").toString());
			   } else {
				   uptrst = szureDAO.insertSzureRst(mm);
			   }
			}
		}
		//집행점보 update
		String strNo = Utility.nvl(param.get("zrlong_no"));
		if(errNoLst.contains(strNo)) {
			strNo = Utility.nvl(param.get("zrlong_no_org"));
		}
		if(!strNo.equals("")) {
			param.put("upt_type", "sub");
			param.put("zrlong_no_org", strNo);
			uptrst = szureDAO.updateSzureRst(param);
		}
		String errMsg = "";
		if(errNoLst != null && errNoLst.size() > 0) {
			for(String s : errNoLst) {
				errMsg += ("[" + s + "]\n" );
			}
			errMsg += "\n위 영장번호는 이미 사용 된 영장번호입니다.\n\n영장번호를 다시 확인하여 주십시오.";
		}
		rtnMap.put("rtnZrlongReqNo", param.get("zrlong_reqst_no")!=null?param.get("zrlong_reqst_no").toString().trim():"");
		rtnMap.put("CHK", errMsg);
		return rtnMap;
	}

	@Override
	public List selectSzureAcnutList(Map<String, Object> param) throws Exception {
		return szureDAO.selectSzureAcnutList(param);
	}

	@Override
	public List selectSzureTrgterList(Map<String, Object> param) throws Exception {
		return szureDAO.selectSzureTrgterList(param);
	}

	@Override
	public List selectSzureRstList(Map<String, Object> param) throws Exception {
		return szureDAO.selectSzureRstList(param);
	}
}
