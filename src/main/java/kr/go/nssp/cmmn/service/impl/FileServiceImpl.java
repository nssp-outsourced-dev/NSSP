package kr.go.nssp.cmmn.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.nssp.cmmn.service.FileService;

@Service("FileService")
public class FileServiceImpl implements FileService {

	@Resource(name = "fileDAO")
	private FileDAO fileDAO;

    public List<HashMap> getFileList(HashMap map) throws Exception {
        return fileDAO.selectFileList(map);
    }

    public HashMap getFileDetail(HashMap map) throws Exception {
        return fileDAO.selectFileDetail(map);
    }

    public HashMap getFileManage(HashMap map) throws Exception {
        return fileDAO.selectFileManage(map);
    }

	public String getFileID() throws Exception{
		return fileDAO.selectFileID();
	}

	public String getFileSn(HashMap map) throws Exception{
		return fileDAO.selectFileSn(map);
	}

    public void insertFile(HashMap map) throws Exception {
        HashMap result = fileDAO.selectFileManage(map);
        if(result == null){
        	fileDAO.insertFileManage(map);
        }

		List<HashMap> fileList = (List) map.get("fileList");
		for(HashMap sMap:fileList) {
			String file_sn = fileDAO.selectFileSn(map);
			sMap.put("file_sn", file_sn);
			sMap.put("format_id", map.get("format_id")==null?"":map.get("format_id").toString());
			fileDAO.insertFileDetail(sMap);
		}
    }

    public void updateFileDetail(HashMap map) throws Exception {
    	fileDAO.updateFileDetail(map);
    }

    public String getUserTitle(HashMap map) throws Exception {
        return fileDAO.selectUserTitle(map);
    }

	@Override
	public HashMap getBioFileDetail(HashMap map) throws Exception {
		return fileDAO.selectBioFileDetail(map);
	}

}
