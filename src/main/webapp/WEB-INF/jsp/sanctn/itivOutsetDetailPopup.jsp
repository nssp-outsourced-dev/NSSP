<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>
<script type="text/javascript">	

	$(function() {		
		$(document).ready(function(){
			fnReportListView('ifrReport', '${docId}');
		});

	});

</script>

<div class="popup_body">
	<!--//버튼  -->	
	<!--테이블 시작 -->
   	<div class="com_box mb_30">  
     		<div class="tb_01_box">
  			<table class="tb_03">
				<colgroup>
					<col width="150px">
					<col width="">
	  			</colgroup>
	  			<tbody>
		  			<tr>
			  			<th>${jobNoTitle}</th>
			  			<td>${jobNo}</td>
		  			</tr>	
		  			<c:if test="${jobResn != '' && jobResn ne null}">
		  			<tr>
			  			<th>사유</th>
			  			<td>${jobResn}</td>
		  			</tr>
		  			</c:if>
	  			</tbody>
		  	</table>
		</div>
	</div>
	
	<!-- report관련 iframe -->
	<iframe name="ifrReport" id="ifrReport" scrolling="no" frameborder="0" width="100%;" height="250px"></iframe>
</div>
