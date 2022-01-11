package kr.go.nssp.inv.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface RcdMgtService {

	/** 
	 * @methodName : saveVdoRec
	 * @date : 2021.12.23
	 * @author : dgkim
	 * @description : 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int saveVdoRec(Map<String, Object> param) throws Exception;

	/** 
	 * @methodName : selectVidoTrplant
	 * @date : 2021.12.23
	 * @author : dgkim
	 * @description : 영상 녹화 동의서의 별도 메뉴 구현으로 인한 추가 
	 * 					김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectVidoTrplant(Map<String, Object> param) throws Exception;
	
	/** 
	 * @methodName : selectVidoTrplantDetail
	 * @date : 2021.12.23
	 * @author : dgkim
	 * @description : 영상 녹화 동의서의 별도 메뉴 구현으로 인한 상세 추가
						김지만 수사관 요청
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public HashMap selectVidoTrplantDetail(Map<String, Object> param) throws Exception;
}
