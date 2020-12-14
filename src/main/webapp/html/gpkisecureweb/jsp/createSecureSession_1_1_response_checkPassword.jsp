<%@ page import="com.gpki.gpkiapi.exception.GpkiApiException"%>
<%@ page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.gpki.gpkiapi.cert.*" %>
<%@ page import="com.gpki.gpkiapi.cms.*" %>
<%@ page import="com.gpki.gpkiapi.util.*" %>
<%@ page import="com.dsjdf.jdf.Logger" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.gpki.io.GPKIJspWriter" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletRequest" %>
<%@ page import="com.gpki.servlet.GPKIHttpServletResponse" %>
<%@ page import="com.gpki.secureweb.GPKIKeyInfo" %>
<%@ page import="com.dsjdf.jdf.*" %>
<%@ page import="java.net.*"%>
<%
	GPKIHttpServletResponse gpkiresponse = null;
	GPKIHttpServletRequest gpkirequest   = null;
	if(request.getParameter("pwCheckCode").equals("0")){
		try {
			
			gpkiresponse = new GPKIHttpServletResponse(response); 
			gpkirequest  = new GPKIHttpServletRequest(request);
			gpkiresponse.setRequest(gpkirequest);

			out = new GPKIJspWriter(out,(GPKIKeyInfo)session.getAttribute("GPKISession"));
			Logger.debug.println(this, "[current_thread]["+Thread.currentThread()+"] gpkisecureweb ref= " + out.toString());
		} catch (NullPointerException e) {
			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			StringBuffer sb = new StringBuffer(1500);
			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			sb.append("?errmsg=");
			sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
			response.sendRedirect(sb.toString());
			return;
		}catch (Exception e) {
			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			StringBuffer sb = new StringBuffer(1500);
			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			sb.append("?errmsg=");
			sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
			response.sendRedirect(sb.toString());
			return;
		}
		X509Certificate cert      = null; 
		byte[]  signData          = null;
		byte[]  privatekey_random = null;
		String  signType          = null;
		String  subDN             = null;
		String  queryString       = "";
		boolean checkPrivateNum   = false;
		
		java.math.BigInteger b = new java.math.BigInteger("-1".getBytes()); 

		int message_type =  gpkirequest.getRequestMessageType();

		if( message_type == gpkirequest.ENCRYPTED_SIGNDATA || message_type == gpkirequest.LOGIN_ENVELOP_SIGN_DATA ||
			message_type == gpkirequest.ENVELOP_SIGNDATA || message_type == gpkirequest.SIGNED_DATA){

			cert              = gpkirequest.getSignerCert(); 
			subDN             = cert.getSubjectDN();
			b                 = cert.getSerialNumber();
			signData          = gpkirequest.getSignedData();
			privatekey_random = gpkirequest.getSignerRValue();
			signType          = gpkirequest.getSignType();
			
			out.println("cert :  " + cert + "<BR>" );
			out.println("subDN :  " + subDN + "<BR>" );
			out.println("b :  " + b + "<BR>" );
			out.println("privatekey_random :  " + privatekey_random + "<BR>" );
			out.println("signType :  " + signType + "<BR>" );
			
		}

		queryString = gpkirequest.getQueryString();
		Enumeration params = gpkirequest.getParameterNames(); 
		while (params.hasMoreElements()) {
			String paramName = (String)params.nextElement(); 
			String paramValue = gpkirequest.getParameter(paramName);
			
			if(paramName.trim().equalsIgnoreCase("ssn") && (null != paramValue) && (!"".equals(paramValue)) && privatekey_random != null) {
				try {
					cert.verifyVID(paramValue,privatekey_random);
					checkPrivateNum = true;
				} catch (GpkiApiException ex) {
					// 개인 식별 번호가 다른경우 예외처리
					com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
					StringBuffer sb = new StringBuffer(1500);
					sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
					sb.append("?errmsg=");
					sb.append(URLEncoder.encode("ssn parameter is different in certificate ! check ssn number","UTF-8"));
					response.sendRedirect(sb.toString());
				}
			}
			out.println(paramName+"="+((paramName.equals("challenge"))?paramValue:URLDecoder.decode(paramValue,"UTF-8"))+"<br>");
		}
	}else{
		out.println("result Code : " + request.getParameter("pwCheckCode")+ "<BR>");
		out.println("result userDN : " + URLDecoder.decode( request.getParameter("userDN"), "utf-8"));
	}

%>
</body>
</html>
