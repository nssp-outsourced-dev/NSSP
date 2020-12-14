package kr.go.nssp.stats.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface InvstsService {

	public List<HashMap> selectStsZrlongList(HashMap map) throws Exception;
	public List<HashMap> selectStsArrstList(HashMap map) throws Exception;
	public List<HashMap> selectStsSzureList(HashMap map) throws Exception;
	public List<HashMap> selectStsAtendList(HashMap map) throws Exception;
	public List<HashMap> selectStsCcdrcList(HashMap map) throws Exception;
	public List<HashMap> selectStsSugestList(HashMap map) throws Exception;
	public List<HashMap> selectStprscList(HashMap map) throws Exception;
	public List<HashMap> selectRefeList(HashMap map) throws Exception;
	public List<HashMap> selectVidoTrplant(HashMap map) throws Exception;

}
