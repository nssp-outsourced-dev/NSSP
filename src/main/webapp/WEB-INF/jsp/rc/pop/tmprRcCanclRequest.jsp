<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp"/>

<script type="text/javascript">	
	$(function() {

	})
	
	function fnClose(){
		self.close();
	}

	function fnSave(){
		
		if(fnFormValueCheck("addForm")){
			$('#addForm').attr('action', '<c:url value='/doc/reportAddAction/'/>');
			$('#addForm').submit();
		}
	}

</script>

<form id="addForm" name="addForm" method="post">
<input type="hidden" id="docId" name="docId" value="${docId}">
<input type="hidden" id="formatClCd" name="formatClCd" value="${formatClCd}">
<input type="hidden" id="inputParam" name="inputParam" value="${inputParam}">

<div class="popup_body">
	 <div class="search_box mb_10">
	 <div class="inbox03 mb_10">
   	     <div class="tl_box3">
		   <div class="tt3">접수번호  </div>
			 <div class="td6">  
			 <input type="text" class="w_100p input_com_s" value="2009-000046"></div>
		 </div>
		</div>
	 </div>
      <div class="title_s_st2 w_50p fl"><img src="../img/title_icon1.png" alt="">사건정보</div>	
	<!--테이블 시작 -->
    <div class="com_box mb_10">  
      <div class="tb_01_box">
	  <table class="tb_03">
		<colgroup><col width="150px">
		<col width="">
		<col width="150px">
		<col width="">
		  </colgroup><tbody>
			  <tr>
				  <th>접수일시</th>
				  <td>2009-07-06 14:21 (월)</td>
				  <th rowspan="9">사건개요(2000자)</th>
				  <td rowspan="9" class="h100"><textarea>&nbsp;</textarea></td>
			  </tr>
			  <tr>
				  <th>입건일시</th>
				  <td>2009-07-09 16:34 (목)</td>
			  </tr>
			  <tr>
				  <th>진행상태</th>
				  <td>임시접수취소요청</td>
			  </tr>
			  <tr>
				  <th>수사단서</th>
				  <td>고소</td>
			  </tr>
			  <tr>
				  <th>접수형태</th>
				  <td>기타</td>
			  </tr>
			  <tr>
				  <th>사건구분</th>
				  <td>일반</td>
			  </tr>
			  <tr>
				  <th>민원인</th>
				  <td>김의동(불상)</td>
			  </tr>
			  <tr>
				  <th>대상자</th>
				  <td>&nbsp;</td>
			  </tr>
			  <tr>
				  <th>위반사항</th>
				  <td>&nbsp;</td>
			  </tr>
		  </tbody>
		  </table>
		</div>
		</div>
	 <div class="com_box"> 
	<div class="title_s_st3 "><img src="../img/icon_error.png" alt="">반려내용(2000자 이내) 민원인의 동의를 받지 않은 상태에서 일방적으로 반려하지 마십시오!
</div>
	<!--버튼 -->
    <div class="com_box mt_20">
      <div class="title_s_st2 w_50p fl"><img src="../img/title_icon1.png" alt="">임시접수취소정보</div>	
      <div class="fr t_right">
        <input type="submit" name="input_button" value="임시접수취소요청" class="btn_st4 icon_n">
        </div>
      </div>
    <!--//버튼  -->
	 <!--테이블 시작 -->
    <div class="com_box mb_20">  
      <div class="tb_01_box">
	  <table class="tb_03">
		<colgroup><col width="150px">
		<col width="">
		<col width="150px">
		<col width="">
		<col width="150px">
		<col width="">
		  </colgroup><tbody>
			  <tr>
				  <th>상담방법</th>
				  <td><select name="" size="1" class="w_100p input_com_s">
            <option value="" selected="">전화 </option>
            <option value=""></option>
          </select></td>
				  <th>접수취소사유</th>
				  <td><select name="" size="1" class="w_100p input_com_s">
            <option value="" selected="">각하사안</option>
            <option value=""></option>
          </select></td>
				  <th>접수취소에 대한 <br>원인 동의방법</th>
				  <td><select name="" size="1" class="w_100p input_com_s">
            <option value="" selected="">기타</option>
            <option value=""></option>
          </select></td>
			  </tr>
			  <tr>
				  <th>취소내용<br>(2000자 이내)</th>
				  <td colspan="5"><textarea name="textarea2" class="textarea_com w_100p">&nbsp;</textarea></td>
			  </tr>
		  </tbody>
		  </table>
		</div>
		</div> 
		</div>
</div>
