<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<jsp:include page="/inc/header.jsp" />
<script type="text/javascript">
	$(function() {

	});
</script>
<style type="text/css">
.my_font_style {
	font-size: 16px;
	font-weight: normal;
	margin-left: 5px;
	letter-spacing: 0.5px;
}
</style>
</head>
<body>
	<div class="popup_body" style="height: 400px;">
		<!--테이블 시작 -->
		<div class="com_box mb_10">
		<div class="tb_01_box">
		<table class="tb_03">
			<colgroup>
			<col width="" />
			</colgroup>
			<tbody>
				<tr class="h_40px">
					<td>
						<div class="title_s_st2" style="float: none; font-size: 23px; text-align: center; letter-spacing: 0.5px;">영상녹화시 필요적 고지사항</div>
						<br/>
						<div class="title_s_st2" style="letter-spacing: 0.5px;">1. 피의자인 경우</div><br/>
						<span class="title_s_st2 my_font_style">1) 조사자 및 참여자의 성명과 직책</span><br/>
						<span class="title_s_st2 my_font_style">2) 영상녹화 사실 및 장소,&nbsp;&nbsp;시작 및 종료 시각</span><br/>
						<span class="title_s_st2 my_font_style">3) 「형사소송법」 제244조의3에 따른 진술거부권 등</span><br/>
						<span class="title_s_st2 my_font_style">4) 조사를 중단ㆍ재개하는 경우 중단 이유와 중단 시각,&nbsp;&nbsp;중단 후 재개하는 시각</span><br/>
						<div class="title_s_st2" style="letter-spacing: 0.5px;">2. 참고인의 경우</div><br/>
						<span class="title_s_st2 my_font_style">1) 조사자 및 참여자의 성명과 직책</span><br/>
						<span class="title_s_st2 my_font_style">2) 영상녹화 사실 및 장소,&nbsp;&nbsp;시작 및 종료 시각</span><br/>
						<span class="title_s_st2 my_font_style">3) 조사를 중단ㆍ재개하는 경우 중단 이유와 중단 시각,&nbsp;&nbsp;중단 후 재개하는 시각</span>
					</td>
				</tr>
			</tbody>
		</table>
		</div>
		</div>
	</div>
</body>