package kr.go.nssp.inv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.DocService;
import kr.go.nssp.cmmn.service.FileService;
import kr.go.nssp.cmmn.service.impl.DocDAO;
import kr.go.nssp.inv.service.AtendService;

@Service
public class AtendServiceImpl implements AtendService {

	@Autowired
	private AtendDAO atendDAO;

	@Autowired
	private DocService docService;

	@Autowired
	private FileService fileService;

	@Override
	public List selectTrgterList(Map<String, Object> param) throws Exception {
		return atendDAO.selectTrgterList(param);
	}

	@Override
	public List selectAtendList(Map<String, Object> param) throws Exception {
		return atendDAO.selectAtendList(param);
	}

	@Override
	public Map saveAtend(Map<String, Object> param) throws Exception {
		int rst = 0;
		Map rtnMap = new HashMap();
		if(param.get("cud_type")!=null) {
    		if(param.get("cud_type").toString().equals("C")) {
    			//doc_id
    			param.put("doc_id", docService.getDocID());
    			param.put("file_id", fileService.getFileID());
    			rst = atendDAO.insertAtend(param);
    		} else if (param.get("cud_type").toString().equals("U")||param.get("cud_type").toString().equals("D")){
    			if(param.get("demand_sn")!=null && !param.get("demand_sn").toString().trim().equals("")){
    				rst = atendDAO.updateAtend(param);
    				if(rst>0) {
    					rst = Integer.parseInt(param.get("demand_sn").toString());
    				}
    			}
    		}
    		rtnMap.put("demandSn", 	rst);
    		rtnMap.put("rcNo", 		param.get("rc_no"));
    		rtnMap.put("trgterSn", 	param.get("trgter_sn"));
    		rtnMap.put("docId", 	param.get("doc_id"));
    	}
		return rtnMap;
	}

	@Override
	public HashMap selectAtendDetail(Map<String, Object> param) throws Exception {
		return atendDAO.selectAtendDetail(param);
	}

	@Override
	public List<HashMap> selectRcTrgterList(Map<String, Object> param) throws Exception {
		return atendDAO.selectRcTrgterList(param);
	}

	@Override
	public List<HashMap> selectRcTrgterDocList(Map<String, Object> param) throws Exception {
		return atendDAO.selectRcTrgterDocList(param);
	}

}
