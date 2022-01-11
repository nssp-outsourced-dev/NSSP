package kr.go.nssp.inv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.egov.EgovComAbstractDAO;

@Repository
public class RcdMgtDAO extends EgovComAbstractDAO {

	/** 
	 * @methodName : saveVdoRec
	 * @date : 2021.12.23
	 * @author : dgkim
	 * @description : 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int saveVdoRec(Map<String, Object> param) throws Exception {
		return update("inv.saveVdoRec", param);
	}
	
	/** 
	 * @methodName : selectVidoTrplant
	 * @date : 2021.12.23
	 * @author : dgkim
	 * @description : 영상 녹화 동의서의 별도 메뉴 구현으로 인한 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> selectVidoTrplant(Map<String, Object> param) throws Exception {
		return list("inv.selectVidoTrplant", param);
	}
	
	/** 
	 * @methodName : selectVidoTrplantDetail
	 * @date : 2021.12.23
	 * @author : dgkim
	 * @description : 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public HashMap selectVidoTrplantDetail(Map<String, Object> param) throws Exception {
		Object o = selectByPk("inv.selectVidoTrplantDetail", param);
		if (o != null) {
			return (HashMap) o;
		} else {
			return new HashMap();
		}
	}
}
