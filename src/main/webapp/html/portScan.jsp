<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*, java.io.*, java.net.*, java.util.*" %>
<%@ page import="java.net.Socket" %>
<%@ page import="java.net.SocketException" %>
<%@ page import="java.net.UnknownHostException" %>
<%@ page import="java.net.UnknownServiceException" %>
<%@ page import="java.net.NoRouteToHostException" %>
<%@ page import="java.net.ConnectException" %>
<%@ page import="java.io.IOException" %>
<%
	String[] _host = {"10.1.7.140", "152.99.56.86 ", "cen.dir.go.kr"};
	String rtnStr = "";
	int _port = 389;//389;
	int i =0;

	for(i =0; i < _host.length; i++) {
		Socket s = null;
		try {
			s = new Socket(_host[i].trim(), _port);
			//s.setSoLinger(true, 3);
			s.setSoTimeout(1000*3);
			// 이 옵션이 무효 (타임 아웃이 무한)의 경우는 0 을 돌려줍니다.
			//System.out.println( "각 LDAP 연결최대대기 시간: " + s.getSoTimeout());
			boolean b = s.isConnected();
			if(b) {
				System.out.println( "OPEN\t:\t" + _host[i] +":"+_port + "\t==>\t" + _host[i]);
				rtnStr += "OPEN\t:\t" + _host[i] +":"+_port + "\t==>\t" + _host[i] + "<br/>";
			} else {
				System.out.println( "CLOSED\t:\t" + _host[i] +":"+_port + "\t==>\t" + _host[i]);
				rtnStr += "CLOSED\t:\t" + _host[i] +":"+_port + "\t==>\t" + _host[i] + "<br/>";
			}

			s.close();
		}
		// 에러 - UnknownHost
		catch(UnknownHostException e) {
			System.out.println( "UnknownHostException CLOSED\t:\t" + _host[i]+":"+_port);
			System.out.println( e.toString()+"<br>");
			rtnStr += "UnknownHostException CLOSED\t:\t" + _host[i]+":"+_port + "<br/>";
		}
		// 에러 - UnknownService
		catch(UnknownServiceException e) {
			System.out.println( "UnknownServiceException CLOSED\t:\t" + _host[i] +":"+_port);
			System.out.println( e.toString()+"<br>");
			rtnStr += "UnknownServiceException CLOSED\t:\t" + _host[i]+":"+_port + "<br/>";
		}
		// 에러 - NoRouteToHost
		catch(NoRouteToHostException e) {
			System.out.println( "NoRouteToHostException CLOSED\t:\t" + _host[i] +":"+_port);
			System.out.println( e.toString()+"<br>");
			rtnStr += "NoRouteToHostException CLOSED\t:\t" + _host[i]+":"+_port + "<br/>";
		}
		// 에러 - Connect
		catch(ConnectException e) {
			System.out.println( "ConnectException CLOSED\t:\t" + _host[i] +":"+_port);
			System.out.println( e.toString()+"<br>");
			rtnStr += "ConnectException CLOSED\t:\t" + _host[i]+":"+_port + "<br/>";
		}
		// 에러 - Socket
		catch (SocketException e) {
			System.out.println( "SocketException CLOSED\t:\t" + _host[i] +":"+_port);
			System.out.println( e.toString()+"<br>");
			rtnStr += "SocketException CLOSED\t:\t" + _host[i]+":"+_port + "<br/>";
		}
		catch (IOException e) {
			System.out.println( "IOException CLOSED\t:\t" + _host[i] +":"+_port);
			System.out.println( e.toString()+"<br>");
			rtnStr += "IOException CLOSED\t:\t" + _host[i]+":"+_port + "<br/>";
		}
		catch(Exception e) {
			System.out.println( "Exception CLOSED\t:\t" + _host[i] +":"+_port);
			System.out.println( e.toString()+"<br>");
			rtnStr += "Exception CLOSED\t:\t" + _host[i]+":"+_port + "<br/>";
		} finally {
			if(s != null) {
				try {
					s.close();
				} catch (IOException e) {
					s = null;
				}
			}
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
	<title>GPKI 사용자용 표준보안API</title>
</head>

<body>
	<div class="wrap">
		<div class="list_01">
			<div class="form">
				결과 <br/> <%=rtnStr%>
			</div>
		</div>
	</div>
</body>
</html>

