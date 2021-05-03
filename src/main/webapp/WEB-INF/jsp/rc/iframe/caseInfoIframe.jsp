<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/inc/header.jsp" />
<style>
	.trHeight {
		height: 35px;
	}
</style>
<script type="text/javascript">

var myGridID = "#grid_wrap";

	$(function() {
		
		$(document).ready(function(){
		
		});

	});	// jQuery
	
</script>

<!--테이블 시작 -->
<div class="contents marginbot">  
	<form id="caseForm" name="caseForm" method="post" enctype="multipart/form-data">
		<input type="hidden"	id="hidRcNo"	name="hidRcNo" 		value="${rcNo}"> 			<!-- 접수번호 -->
		<input type="hidden"	id="hidItivNo" 	name="hidItivNo" 	value="${caseInfo.ITIV_NO}"><!-- 내사번호 -->
		<input type="hidden"	id="hidCaseNo" 	name="hidCaseNo" 	value="${caseNo}">			<!-- 사건번호 -->
		<input type="hidden"	id="hidDocId" 	name="hidDocId" 	value="${caseInfo.DOC_ID}" ><!-- 문서번호 -->
		<input type="hidden"	id="hidProgrsSttusCd"	name="hidProgrsSttusCd" 	value="${caseInfo.PROGRS_STTUS_CD}"> <!-- 진행상태 -->
		<input type="hidden" 	id="hidGridRowStatus"	name="hidGridRowStatus" 	value=""   ><!-- 그리드 로우 상태 -->

		<!-- tab1 사건정보 -->
		<div id="content1" >
			<div class="tb_01_box">
	 			<table class="tb_01">
				    <colgroup>
				    	<col width="150px">
					    <col width="400px" style="min-width: 500px; max-width: 700px;">
					    <col width="150px">
					    <col width="">
				    </colgroup>
				    <tbody>
		     			<tr class="trHeight">
					        <th>접수번호 </th>
					        <td colspan="3" class="t_left">
					        	<c:if test="${caseInfo.RC_NO != null}">
									${caseInfo.TRIM_RC_NO}
								</c:if>
								<c:if test="${caseInfo.RC_NO == null}">
									접수번호가 존재하지 않습니다.
								</c:if>
							</td>
							
							<%-- 2021.04.19 --%>
							<%-- 사건접수일시는 불필요하기에 안보이게 처리 --%>
					        <%-- <th>접수일시 </th>
					        <td class="t_left ">			
								${caseInfo.RC_DT}
			  				</td> --%>
						</tr>
						
						<tr class="trHeight">
							<th>임시사건<br>결과보고일시</th>
							<td colspan="3" class="t_left">
								${caseInfo.TMPR_CASE_RESULT_REPORT_DT}
							</td>
						</tr>
						
						<tr>
							<th>내사착수일자</th>
							<td class="t_left">
								${caseInfo.OUTSET_REPORT_DT}
							</td>
							
							<th>내사결과보고일자</th>
							<td class="t_left">
								${caseInfo.ITIV_RESULT_REPORT_DT}
							</td>
						</tr>
						
						<tr class="trHeight">
							<th>입건일자</th>
							<td colspan="3" class="t_left">
								<c:choose>
									<c:when test="${caseInfo.PRSCT_DE ne null}">
										<fmt:formatDate value="${caseInfo.PRSCT_DE}" pattern="yyyy-MM-dd" />
									</c:when>
									<c:otherwise>입건일자가 존재하지 않습니다.</c:otherwise>
								</c:choose>
							</td>
						</tr>
						
						<tr class="trHeight">
							<th>수사재개일시</th>
							<td colspan="3" class="t_left">
								${caseInfo.INV_RESMPT_DE}
							</td>
						</tr>
						
						<tr class="trHeight">
							<th>내사번호 </th>
						  	<td class="t_left">
						  		<c:if test="${caseInfo.ITIV_NO != null}">
									${caseInfo.TRIM_ITIV_NO}
								</c:if>
								<c:if test="${caseInfo.ITIV_NO == null}">
									내사번호가 존재하지 않습니다.
								</c:if>
							</td>
						  	<th>사건번호 </th>
						  	<td class="t_left">
						  		<c:if test="${caseInfo.CASE_NO != null}">
									${caseInfo.TRIM_CASE_NO}
								</c:if>
								<c:if test="${caseInfo.CASE_NO == null}">
									사건입건 후 확인 가능합니다
								</c:if>
							</td>
						</tr>
		    			<tr class="trHeight">
							<th>수사단서</th>
					        <td class="t_left">
				            	<c:forEach var="cd" items="${invProvisoList}">
									<c:if test="${cd.cd == caseInfo.INV_PROVIS_CD}">${cd.cdNm}</c:if>	
								</c:forEach>
					        </td>
					        <th>사건구분</th>
					        <td class="t_left">
								${caseInfo.RC_SE_NM}								
					        </td>
					    </tr>
		     			<tr class="trHeight">
		       				<th>발생일시</th>
							<td class="t_left">
						   		${caseInfo.OCCRRNC_BEGIN_DT}
						   		<c:if test="${NULL != caseInfo.OCCRRNC_BEGIN_DT}">
									&nbsp;~&nbsp;
								</c:if>  
								${caseInfo.OCCRRNC_END_DT}
							</td>
							<th>접수형태 </th>
						   	<td class="t_left">
					            <c:forEach var="cd" items="${rcFormList}">
									<c:if test="${cd.cd == caseInfo.RC_STLE_CD}">${cd.cdNm}</c:if>	
								</c:forEach>
		        			</td>
		     			</tr>
						<tr class="trHeight">
		      				<th>발생장소</th>
		     				<td colspan="3" class="t_left">
								<c:if test="${NULL != caseInfo.OCCRRNC_ZIP}">
									우편번호 :  ${caseInfo.OCCRRNC_ZIP}
								</c:if>
								<c:if test="${NULL != caseInfo.OCCRRNC_ADDR}">
									&nbsp;&nbsp;&nbsp;&nbsp;
									주소 :  ${caseInfo.OCCRRNC_ADDR}
								</c:if>
							</td>
		     			</tr>
						<tr class="trHeight">
		       				<th>민원인연락처</th>
		       				<td class="t_left">
		       					${caseInfo.CPTTR_HP_NO}
		       				</td>
		       				<th>담당자</th>
				        	<td class="t_left">
				        		${userInfo.USER_NM}( ${userInfo.DEPT_NM} )
				        	</td>
		     			</tr>
						<tr class="trHeight">
							<th>상담방법</th>
							<td class="t_left">
								<c:forEach var="cd" items="${cnsltMthCdList}">
									<c:if test="${cd.cd == caseInfo.CNSLT_MTH_CD}">${cd.cdNm}</c:if>	
								</c:forEach>
							</td>
							<th>상담일시</th>
							<td class="t_left">
								${caseInfo.CNSLT_DT} 
							</td>
						</tr>
						<tr class="trHeight">
				        	<th>관할검찰</th>
				        	<td colspan="3" class="t_left">
				        		${caseInfo.CMPTNC_EXMN_NM}
				        	</td>
				     	</tr>
						<tr class="trHeight">
		       				<th>위반죄명 </th>
		       				<td colspan="3" class="t_left">
		       					${caseInfo.VIOLT_NM} 
		       				</td>
				        </tr>
						<tr class="trHeight">
			  				<th>범죄사실<br>
								(혐의사실) 
							</th>
			  				<td class="t_left">
			  					<c:out value="${caseInfo.CRMNL_FACT}" escapeXml="false"/>
			  				</td>
			  				<th>기타 </th>
			  				<td class="t_left">
			  					<c:out value="${caseInfo.ETC_CN}" escapeXml="false"/>
			  				</td>
			  			</tr>
						<tr class="trHeight">
			  				<th>사건개요<br>(수사의뢰 경위) 
			    			</th>
			  				<td class="t_left">
			  					<c:out value="${caseInfo.CASE_SUMRY}" escapeXml="false"/> 
			  				</td>
			  				<th>입증자료</th>
		  					<td class="t_left">
		  						<c:out value="${caseInfo.PRF_DTA}" escapeXml="false"/>
		  					</td>
			  			</tr> 
						
					<c:if test="${ NULL != caseInfo.TRNSF_SN && '' != caseInfo.TRNSF_SN }">
						<tr class="trHeight">
							<th>이송관서</th>
							<td class="t_left">
								${caseInfo.TRNSF_INSTT_NM}&nbsp;${caseInfo.TRNSF_INSTT_DEPT}
							</td>
							<th>이송일자</th>
							<td class="t_left">
								${caseInfo.TRNSF_DE}
							</td>
						</tr>
						<tr class="trHeight">
							<th>이송사유</th>
							<td colspan="3" class="t_left">
								${caseInfo.TRNSF_RESN_DC}
							</td>
						</tr>
					</c:if>
						<tr class="trHeight">
							<th>첨부파일</th>
							<td colspan="3" class="t_left">
								<iframe id="ifrFile" src="<c:url value='/file/fileListIframe/'/>?ifr_id=ifrFile&file_id=${caseInfo.FILE_ID}" scrolling="no" frameborder="0" width="100%" style="height: 20px;"></iframe>
							</td>
						</tr>
	   				</tbody>
				</table>
			</div>
		</div>
	</form>
</div>
	
