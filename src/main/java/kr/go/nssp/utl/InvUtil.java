package kr.go.nssp.utl;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

import org.springframework.jdbc.support.JdbcUtils;

import kr.go.nssp.utl.SimpleUtils;

public class InvUtil {

	private static InvUtil commonUtil;

	static {
		commonUtil = new InvUtil();
	}

	public static InvUtil getInstance() {
		return commonUtil;
	}

	public Map getParameterMap(HttpServletRequest request) throws Exception {
		Enumeration paramNames = request.getParameterNames();
		Map paramMap = new HashMap();

		while (paramNames.hasMoreElements()) {
			String name = paramNames.nextElement().toString();
			String value = SimpleUtils.default_set(request.getParameter(name));
			paramMap.put(name, value);
		}
		return paramMap;
	}
	public HashMap getParameterMapConvert(HttpServletRequest request) throws Exception {
		Enumeration paramNames = request.getParameterNames();
		HashMap paramMap = new HashMap();
		while (paramNames.hasMoreElements()) {
			String name = paramNames.nextElement().toString();
			String con_name = convert (name);
			con_name = con_name.substring(con_name.indexOf('_')+1);
			paramMap.put(con_name, SimpleUtils.default_set(request.getParameter(name)));
		}
		return paramMap;
	}
	public List getConvertUnderscoreNameGrid (List<HashMap> list) throws Exception {
		List<HashMap> returnList = new ArrayList<HashMap>();
		for(HashMap m : list) {
			HashMap rtnMap = new HashMap();
			for( Object key : m.keySet() ){
				String strKey = key!=null?key.toString():"";
				if(!"TOT_CNT".equals(strKey)) {
					strKey = ("GRD_" + strKey);
				}
				strKey = JdbcUtils.convertUnderscoreNameToPropertyName(strKey);
				rtnMap.put(strKey, m.get(key));
			}
			returnList.add(rtnMap);
    	}
		return returnList;
	}
	public List getConvertUnderscoreNameList (List<HashMap> list) throws Exception {
		List<HashMap> returnList = new ArrayList<HashMap>();
		for(HashMap m : list) {
			HashMap rtnMap = new HashMap();
			for( Object key : m.keySet() ){
				String strKey = key!=null?key.toString():"";
				strKey = JdbcUtils.convertUnderscoreNameToPropertyName(strKey);
				rtnMap.put(strKey, m.get(key));
			}
			returnList.add(rtnMap);
    	}
		return returnList;
	}
	public HashMap getConvertUnderscoreName(Map detail) throws Exception {
		HashMap rtnMap = new HashMap();
		for( Object key : detail.keySet() ){
			String strKey = key!=null?key.toString():"";
			strKey = JdbcUtils.convertUnderscoreNameToPropertyName(strKey);
			rtnMap.put(strKey, detail.get(key));
		}
		return rtnMap;
	}
	public String convert (String str){
		String regex = "([a-z])([A-Z])";
		String replacement = "$1_$2";
		return str.replaceAll(regex, replacement).toLowerCase();
	}

	public HashMap getMapToMapConvert(Map map) throws Exception  {
		HashMap paramMap = new HashMap();
		for( Object key : map.keySet() ){
			String strKey = key!=null?key.toString():"";
			String con_name = convert (strKey);
			con_name = con_name.substring(con_name.indexOf('_')+1);
			paramMap.put(con_name, map.get(strKey));
		}
		return paramMap;
	}
}
