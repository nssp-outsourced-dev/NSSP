package kr.go.nssp.utl;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public class RequestUtil {

	public static Map getParameterMap(HttpServletRequest request){

		Map parameterMap = new HashMap();
		Enumeration enums = request.getParameterNames();
		
		while(enums.hasMoreElements()){
			
			String paramName = (String)enums.nextElement();
			String[] parameters = request.getParameterValues(paramName);
	
			// Parameter가 배열일 경우
			if (parameters.length > 1){
				parameterMap.put(paramName, parameters);
			
				// Parameter가 배열이 아닌 경우
			} else {
				parameterMap.put(paramName, parameters[0]);
			}
		}

		return parameterMap;
	}
}