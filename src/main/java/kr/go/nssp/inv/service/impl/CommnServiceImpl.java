package kr.go.nssp.inv.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.nssp.cmmn.service.FileService;
import kr.go.nssp.cmmn.service.impl.DocDAO;
import kr.go.nssp.inv.service.CommnService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("CommnService")
public class CommnServiceImpl implements CommnService {

	@Resource(name = "CommnDAO")
	private CommnDAO commnDAO;

	@Resource(name = "docDAO")
	private DocDAO docDAO;

	@Autowired
	private FileService fileService;

	@Override
	public List selectMyCaseList(Map<String, String> param) throws Exception {
		return commnDAO.selectMyCaseList(param);
	}

	@Override
	public List selectCommnList(Map<String, String> param) throws Exception {
		return commnDAO.selectCommnList(param);
	}

	@Override
	public Map selectCommnInfo(Map<String, String> param) throws Exception {
		return commnDAO.selectCommnInfo(param);
	}

	@Override
	public String insertCommn(Map<String, String> param) throws Exception {
		param.put("DOC_ID",  docDAO.selectDocID());
		param.put("FILE_ID", fileService.getFileID());
		return commnDAO.insertCommn(param);
	}

	@Override
	public String insertCommnRe(Map<String, String> param) throws Exception {
		int cnt = commnDAO.updateCommnRe(param);
		if(cnt == 1) {
			String key = commnDAO.insertCommnRe(param);

			param.put("PRMISN_PROGRS_NO", key);
			Map map = commnDAO.selectCommnInfo(param);
			if(map == null) {
				throw new Exception();
			}

			return key;
		} else {
			return "";
		}
	}

	@Override
	public int updateCommn(Map<String, String> param) throws Exception {
		return commnDAO.updateCommn(param);
	}

	@Override
	public int updateCommnResult(Map<String, String> param) throws Exception {
		return commnDAO.updateCommnResult(param);
	}

	@Override
	public int deleteCommn(Map<String, String>  param) throws Exception {
		return commnDAO.deleteCommn(param);
	}
}
