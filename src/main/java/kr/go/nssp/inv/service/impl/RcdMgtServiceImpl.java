package kr.go.nssp.inv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.impl.DocDAO;
import kr.go.nssp.cmmn.service.impl.FileDAO;
import kr.go.nssp.inv.service.RcdMgtService;

@Service
public class RcdMgtServiceImpl implements RcdMgtService {

	@Autowired
	private RcdMgtDAO rcdMgtDAO;
	
	@Autowired private FileDAO fileDAO;
	
	@Autowired private DocDAO docDAO;

	/* (non-Javadoc)
	 * @see kr.go.nssp.inv.service.RcdMgtService#saveVdoRec(java.util.Map)
	 */
	@Override
	public int saveVdoRec(Map<String, Object> param) throws Exception {
		if( "null".equals(String.valueOf(param.get("file_id"))) ||
				"".equals(String.valueOf(param.get("file_id"))) ) {
			param.put("file_id", fileDAO.selectFileID());
		}
		
		if( "null".equals(String.valueOf(param.get("doc_id"))) ||
				"".equals(String.valueOf(param.get("doc_id"))) ) {
			param.put("doc_id", docDAO.selectDocID());
		}
		
		return rcdMgtDAO.saveVdoRec (param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.inv.service.RcdMgtService#selectVidoTrplant(java.util.Map)
	 */
	@Override
	public List<HashMap> selectVidoTrplant(Map<String, Object> param) throws Exception {
		return rcdMgtDAO.selectVidoTrplant(param);
	}

	/* (non-Javadoc)
	 * @see kr.go.nssp.inv.service.RcdMgtService#selectVidoTrplantDetail(java.util.Map)
	 */
	@Override
	public HashMap selectVidoTrplantDetail(Map<String, Object> param) throws Exception {
		return rcdMgtDAO.selectVidoTrplantDetail(param);
	}
}
