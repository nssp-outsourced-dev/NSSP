<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.gpki.gpkiapi.cert.*" %>
<%@ page import="com.gpki.gpkiapi.cms.*" %>
<%@ page import="com.gpki.gpkiapi.util.*" %>
<%@ page import="com.dsjdf.jdf.Logger" %>
<%@ page import="com.gpki.secureweb.SecureKeyboard" %>
<%@include file="./gpkisecureweb.jsp"%>
<%
	String url = (String)session.getAttribute("currentpage");
%>
<script type="text/javascript">
	location.href = "<%=url%>";
</script>
