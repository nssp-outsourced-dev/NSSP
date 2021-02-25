<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ page import="kr.co.siione.dist.utils.SimpleUtils" %>
<%@ page import="kr.go.nssp.utl.LoginManager" %>
<%@ page import="kr.go.nssp.utl.AuthorManager" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	LoginManager loginManager = LoginManager.getInstance();
	String esntl_id = SimpleUtils.default_set((String)session.getAttribute("esntl_id"));
	String user_id = SimpleUtils.default_set((String)session.getAttribute("user_id"));
	String user_nm = SimpleUtils.default_set((String)session.getAttribute("user_nm"));
	String dept_nm = SimpleUtils.default_set((String)session.getAttribute("dept_nm"));
	String author_cd = SimpleUtils.default_set((String)session.getAttribute("author_cd"));
	String result = SimpleUtils.default_set(request.getParameter("result"));

	String uri = request.getServletPath();
	AuthorManager authorManager = AuthorManager.getInstance();
	HashMap urlInfo = authorManager.getUrl(author_cd, uri);
	List<HashMap> clInfoList = authorManager.getMENU_CL_INFO(author_cd);
	HashMap menuList = authorManager.getMENU_INFO (author_cd);

	String menuNm = "";
	String menuCd = "";
	String menuClCd = "";
	String menuClNm = "";
	String menuClIcon = "icon1";

	if(urlInfo != null){
		menuNm = (String) urlInfo.get("MENU_NM");
		menuCd = (String) urlInfo.get("MENU_CD");
		menuClCd = (String) urlInfo.get("MENU_CL_CD");
		menuClNm = (String) urlInfo.get("MENU_CL_NM");
		pageContext.setAttribute("LayoutMenuName", menuNm);
		pageContext.setAttribute("LayoutMenuClName", menuClNm);
		pageContext.setAttribute("LayoutMenuClCd", menuClCd);
		pageContext.setAttribute("LayoutMenuCd", menuCd);
	}
	pageContext.setAttribute("ClInfoList", 		clInfoList);
	pageContext.setAttribute("LayoutMenuList",  menuList);

//MENU_CD=00029, MENU_CL_CD=00002, MENU_CL_NM=입건/조사, MENU_URL=/file/traceNoticeList/, MENU_NM=압수수색검증영장 관리, RELATE_URL=/file/traceNoticeDetail/}, 00004_/bbs/noticeList/={MENU_CD=00018, MENU_CL_CD=00005, MENU_CL_NM=송치/종결, MENU_URL=/bbs/noticeList/

	//현재위치
	List<HashMap> menuLeftList = authorManager.getMenu(author_cd, menuClCd);
	pageContext.setAttribute("LayoutMenuLeftList", menuLeftList);

	//현재일자
	SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd", Locale.KOREA );
	SimpleDateFormat tSimpleDateFormat = new SimpleDateFormat ( "HH:mm:ss", Locale.KOREA );
	Date nowDate = new Date();
	String strDate = mSimpleDateFormat.format (nowDate);
	String strTime = tSimpleDateFormat.format (nowDate);
	pageContext.setAttribute("LayoutNowDate", strDate);
	pageContext.setAttribute("LayoutNowTime", strTime);


%>

<jsp:include page="/inc/header.jsp"/>
<link rel="stylesheet" type="text/css" href="/css/main_menu.css" media="all">
<style type="text/css">
body span {
    display: block;
}
.mainOverflow {
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	width: 180px;
	height: 30px;
	text-align: left;
	padding-top: 4px;
	font-size:15px;
}

/* 메인상단 */
.logo {
	background-color: honeydew;
}

.main_box {
	padding: 100px 0px 20px 0px;
}
.main_box .ininbox{
	margin: 10px auto 10px;
}

/* 사건조회 */
.main_search_box, .main_search_box .tx {
	background-color: lavender !important;
}

/* 공지사항 및 문의사항 */
.main_notice_box .title_box {
	height: 50px;
	background-color: antiquewhite;
}
.main_notice_box .title_box .title_t {
	font-size: 14px;
}
.main_notice_box{
	padding: 0px 0px 10px 0px;
}
.main_notice_box .list_box ul li .tx {
	width: 100%;
}

/* 업무알림 */
.main_alarm_box .title_box{
	height: 50px;
	background-color: antiquewhite;
}
.main_alarm_box .title_box .title_t{
	font-size: 14px;
}
.main_alarm_box {
	height: 180px;
}

.main_alarm_box .list_box ul li div {
	width: 100%;
}

/* 통계 */
.main_status_box .timebox .tx1 {
	font-size: 21px;
}

.main_status_box .iconbox {
	padding-left: 74px;
    padding-top: 47px;
}
.main_status_box .iconbox ul li .icon_r1 {
	height: 80px !important;
	background-color: darkgoldenrod;
	font-size: 30px;
}

.main_status_box .iconbox ul li .icon_r2 {
	height: 95px !important;
	background-color: saddlebrown;
	font-size: 30px;
}

/* 내사건 */
.main_case_box .title_box {
    background-color: navy; /* teal */
}

.tb_07 tbody td .ing_box .ing4 {
	background-color: crimson;
}

/* 내사건 하단 */
.main_case_box {
	height: 563px; 
}
</style>
<script type="text/javascript">
	$(function() {
		$(document).ready(function(){
			/* $("#txtSearchText").keyup(function(event) {
				if(event.keyCode == 13) {
					fnInputCaseDetail();
				}
			}); */ /*최초 실행시 오류 발생*/
			$("#selSearchType").change(function (event){
				if($(this).val() == "Nm") {
					$("#txtSearchText").prop("placeholder","");
				} else {
					$("#txtSearchText").prop("placeholder","ex) 900101");
				}
			});
		});
	})

	function fnLayoutLogout(){
	    location.href = "<c:url value='/member/logoutAction/'/>";
	}
	function fnLayoutUserInfo(){
	    location.href = "<c:url value='/member/updateSelf/'/>";
	}
	function fnLayoutLogin(){
	    location.href = "<c:url value='/member/login/'/>";
	}

	function fnCaseSelect(sArg){
		if(sArg == "A"){
			$("#divCaseA").show();
			$("#divCaseF").hide();
			$("#divCaseT").hide();
			$("#divCaseI").hide();
			$("#tabCaseA").attr("class","on");
			$("#tabCaseF").attr("class","");
			$("#tabCaseT").attr("class","");
			$("#tabCaseI").attr("class","");
			$("input:hidden[id=hidCaseSe]").val(sArg);
		}else if(sArg == "F"){
			$("#divCaseA").hide();
			$("#divCaseF").show();
			$("#divCaseT").hide();
			$("#divCaseI").hide();
			$("#tabCaseA").attr("class","");
			$("#tabCaseF").attr("class","on");
			$("#tabCaseT").attr("class","");
			$("#tabCaseI").attr("class","");
			$("input:hidden[id=hidCaseSe]").val(sArg);
		}else if(sArg == "T"){
			$("#divCaseA").hide();
			$("#divCaseF").hide();
			$("#divCaseT").show();
			$("#divCaseI").hide();
			$("#tabCaseA").attr("class","");
			$("#tabCaseF").attr("class","");
			$("#tabCaseT").attr("class","on");
			$("#tabCaseI").attr("class","");
			$("input:hidden[id=hidCaseSe]").val(sArg);
		}else if(sArg == "I"){
			$("#divCaseA").hide();
			$("#divCaseF").hide();
			$("#divCaseT").hide();
			$("#divCaseI").show();
			$("#tabCaseA").attr("class","");
			$("#tabCaseF").attr("class","");
			$("#tabCaseT").attr("class","");
			$("#tabCaseI").attr("class","on");
			$("input:hidden[id=hidCaseSe]").val(sArg);
		}else{
			$("#divCaseA").show();
			$("#divCaseF").hide();
			$("#divCaseT").hide();
			$("#divCaseI").hide();
			$("#tabCaseA").attr("class","on");
			$("#tabCaseF").attr("class","");
			$("#tabCaseT").attr("class","");
			$("#tabCaseI").attr("class","");
			$("input:hidden[id=hidCaseSe]").val("A");
		}
	}

	function fnInputCaseDetail() {
		var searchType = $("#selSearchType").val();
		var searchText = $("#txtSearchText").val();
		if(fnIsEmpty(searchType) || fnIsEmpty(searchText)){
			alert("사건정보를 입력하세요.")
			return;
		}
		fnCaseInfoPopup(searchType, searchText); //사건 정보 팝업
	}

	function fnRdoCaseDetail() {
		if($('input:radio[name="rdoCaseNo"]').is(':checked') == false){
			alert("조회할 사건을 선택하세요.")
			return;
		}
		var sSe = $("input:hidden[id=hidCaseSe]").val();
		var sVal = $('input:radio[name="rdoCaseNo"]:checked').val();
		fnCaseDetailPopup(sVal, "");
	}

	function fnBbsDetail(bbs_id, bbs_sn) {
		var form = $("form[id=frmList]");
		$("input:hidden[id=bbsId]").val(bbs_id);
		$("input:hidden[id=hidBbsSn]").val(bbs_sn);
		form.attr({"method":"post","action":"/bbs/"+ bbs_id +"/detail/"});
		form.submit();
	}
</script>
<link rel="stylesheet" type="text/css" href="/css/main_menu.css" media="all">
</head>

<body>
<form id="frmList" name="frmList" method="post">
<input type="hidden" id="bbsId" name="bbsId" value="">
<input type="hidden" id="hidBbsSn" name="hidBbsSn" value="">
<input type="hidden" id="hidCaseSe" name="hidCaseSe" value="A">
</form>
	<!--상단영역 공통  -->
	<header>
		<div class="logo">
			<a href="/"><img src="/img/logo.png" style="width: 240px;" alt="특사경 수사시스템"/></a>
		</div>

		<div class="topicon_menu" style="left:250px">
		    <ul class="sf-menu" id="example">
			<c:forEach var="result" items="${ClInfoList}" varStatus="status">
				<c:if test="${result.MENU_CL_CD ne '00010'}">
					<c:choose>
						<c:when test="${result.MENU_CL_CD eq '00001'}"><c:set var="icon" value="icon1"/></c:when>
						<c:when test="${result.MENU_CL_CD eq '00002'}"><c:set var="icon" value="icon2"/></c:when>
						<c:when test="${result.MENU_CL_CD eq '00003'}"><c:set var="icon" value="icon3"/></c:when>
						<c:when test="${result.MENU_CL_CD eq '00005'}"><c:set var="icon" value="icon4"/></c:when>
						<c:when test="${result.MENU_CL_CD eq '00007'}"><c:set var="icon" value="icon5"/></c:when>
						<c:when test="${result.MENU_CL_CD eq '00011'}"><c:set var="icon" value="icon5"/></c:when>
						<c:when test="${result.MENU_CL_CD eq '00008'}"><c:set var="icon" value="icon6"/></c:when>
						<c:when test="${result.MENU_CL_CD eq '00006'}"><c:set var="icon" value="icon7"/></c:when>
						<c:when test="${result.MENU_CL_CD eq '00004'}"><c:set var="icon" value="icon8"/></c:when>
						<c:otherwise><c:set var="icon" value="icon1"/></c:otherwise>
					</c:choose>
					<li class="${icon} <c:if test="${LayoutMenuClCd eq result.MENU_CL_CD}">on</c:if>"> <a href="${result.MENU_URL}">${result.MENU_CL_NM}</a>
						<ul class="w200"> <div class="triangle"></div>
						<c:forEach var="resultDtl" items="${LayoutMenuList[result.AUTHOR]}" varStatus="statusDtl">
							<li class=""><a href="${resultDtl.MENU_URL}">${resultDtl.MENU_NM}</a></li>
						</c:forEach>
						</ul>
					</li>
				</c:if>
			</c:forEach>
		    </ul>
		</div>

		<div class="login_in_iconbox">
			<div class="topbtn">
				<a href="#" onclick="btnUserPop('fnd')">담당자검색</a>
				<a href="http://ecris.police.go.kr" target="_blank">전자수사자료표</a>
				<a href="http://law.go.kr"  target="_blank">국가법령정보</a>
			</div>
			<c:choose>
			 <c:when test="${fn:length(esntl_id) > 0}">
	    		<div class="member" style="margin-right: 0px;">
	    			<img src="/img/icon_member.png" width="30" height="29" alt="" style="margin-right: 0px;margin-left: 20px;"/>
	      				<p style="font-size: 14px; font-weight: bold;">${user_nm}</p>
	    		</div>
	    		<div class="admin_icon" style="margin-left: 0px;">
		    		<div class="topbtn">
			    		<a href="javascript:fnLayoutUserInfo();" title="관리자">개인정보 수정</a>
		    		</div>
	    		</div>
	    		<div class="logout"><a href="javascript:fnLayoutLogout();">로그아웃</a> </div>
			 </c:when>
			 <c:otherwise></c:otherwise>
			</c:choose>
		</div>
	</header>

	<main> <!--메인 -->
	<div class="main_box">
		<div class="ininbox">
			<div class="main_search_box">
				<div class="icon">
					<img src="/img/main_searchicon.png" alt="" />
				</div>
				<div class="title">
					<div class="tx1">
						<em>사건조회</em>
					</div>
					<div class="tx2">Case inquiry</div>
				</div>

				<div class="stitle">
					<div class="tx">사건정보&nbsp;</div>

				</div>
				<div class="input_div" style="width: 300px;">
					<select name="selSearchType" id="selSearchType" size="1" class="input_com mr_5" style="width: 120px;">
						<option value="Nm"><c:out value="성명/법인명"/></option>
						<option value="Dt"><c:out value="생년월일" /></option>
					</select>
					<!-- <input type="text" id="txtCaseNo1" name="txtCaseNo1" class="w_80px input_com2 mr_5 onlyNumber" maxlength="4"> -->
					<input type="text" id="txtSearchText" name="txtSearchText" class="w_100px input_com" maxlength="200">
					<input type="button" value="검색" class="btn_st2 icon_n" onclick="fnInputCaseDetail();">
				</div>
			</div>

			<div class="main_status_box">
				<div class="timebox">
					<div class="tx1">
						나의 현황 <em>My Status</em>
					</div>
					<div class="todey">
						<div class="ttx1">TODAY</div>
						<div class="ttx2">${LayoutNowDate}</div>
						<div class="ttx3">${LayoutNowTime}</div>
					</div>
				</div>
				<div class="iconbox" style="width: 775px;">
					<ul>
						<li style="width: 130px;padding-top: 20px;margin-right: 0px">
							<div class="icon_r1" style="width: 80px;height: 120px;">
								${caseSttus.ST_CNT0}
								<div class="umbox" style="width: 45px;height: 45px;border-radius: 10px;right: -20px; bottom: -20px;">
									<img src="/img/main_status03.png" alt="" style="padding-bottom: 10px;"/>
								</div>
							</div>
							<div class="tx_box" style="margin-top: 20px;margin-left: 10px;">사건접수</div>
						</li>
						<li style="width: 130px;">
							<div class="icon_r2" style="width: 95px;height: 140px;">
								${caseSttus.ST_CNT1}
								<div class="umbox" style="width: 45px;height: 45px;border-radius: 10px;right: -20px; bottom: -20px;">
									<img src="/img/main_status04.png" alt="" style="padding-bottom: 10px;"/>
								</div>
							</div>
							<div class="tx_box" style="margin-top: 20px;margin-left: 23px;">수사중</div>
						</li>
						<li style="width: 130px;padding-top: 20px;margin-right: 0px;"">
							<div class="icon_r1" style="width: 80px;height: 120px;" >
								${caseSttus.ST_CNT2}
								<div class="umbox" style="width: 45px;height: 45px;border-radius: 10px;right: -20px; bottom: -20px;">
									<img src="/img/main_status07.png" alt="" style="width: 41px;padding-bottom: 10px;" />
								</div>
							</div>
							<div class="tx_box" style="margin-top: 20px;margin-left: 10px;">수사지휘건의</div>
						</li>
						<li style="width: 130px;">
							<div class="icon_r2" style="width: 95px;height: 140px;">
								${caseSttus.ST_CNT3}
								<div class="umbox" style="width: 45px;height: 45px;border-radius: 10px;right: -20px; bottom: -20px;">
									<img src="/img/main_status05.png" alt="" style="padding-bottom: 10px;"/>
								</div>
							</div>
							<div class="tx_box" style="margin-top: 20px;margin-left: 23px;">송치준비중</div>
						</li>
						<li style="width: 130px;padding-top: 20px;">
							<div class="icon_r1" style="width: 80px;height: 120px;">
								${caseSttus.ST_CNT4}
								<div class="umbox" style="width: 45px;height: 45px;border-radius: 10px;right: -20px; bottom: -20px;">
									<img src="/img/main_status06.png" alt="" style="padding-bottom: 10px;"/>
								</div>
							</div>
							<div class="tx_box" style="margin-top: 20px;margin-left: 10px;">송치완료</div>
						</li>
					</ul>
				</div>
			</div>
		</div>

		<div class="ininbox">
			<div class="main_l_box">
				<div class="main_notice_box mb_10">
					<div class="title_box">
						<div class="title_t">
							공지사항<em>NOTICE</em>
						</div>
						<div class="title_more"><a href="/bbs/00000000000000000001/list/"><b>+</b></a></div>
					</div>
					<div class="list_box">
						<ul>
						<c:if test="${fn:length(noticeList) == 0}">
						</c:if>
						<c:forEach var="result" items="${noticeList}" varStatus="status">
						<li>
							<c:choose>
								<c:when test="${result.NOTICE_YN eq 'Y'}">
									<div class="icon"><img src="/img/notice_icon1.png" alt="" /></div>
								</c:when>
								<c:otherwise>
									<div class="icon"><img src="/img/notice_icon2.png" alt="" /></div>
								</c:otherwise>
							</c:choose>
							<div class="tx" style="font-size:12px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"><a href="javascript:fnBbsDetail('00000000000000000001', '${result.BBS_SN}');">${result.NTT_SJ}</a></div>
							<%-- <div class="date">${result.WRITNG_DE}</div> --%>
						</li>
						</c:forEach>

						</ul>
					</div>
				</div>
				<div class="main_alarm_box mb_10">
					<div class="title_box">
						<div class="title_t">업무알림</div>
						<div class="al_icon" style="left:90px; top:20px;width: 23px">
							<img src="/img/icon_new1.png" alt="" />
						</div>
						<div class="title_more" style="margin-left: 259px;"><a href="/bbs/00000000000000000002/list/"><b>+</b></a></div>
					</div>
					<div class="list_box">
						<ul>
							<c:if test="${fn:length(workList) == 0}">
							</c:if>
							<c:forEach var="result" items="${workList}" varStatus="status">
							<li >
								<div style="font-size:12px; width: 100%; float: left; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
								<a href="javascript:fnBbsDetail('00000000000000000002', '${result.BBS_SN}');"><c:if test="${result.NOTICE_YN eq 'Y'}">[공지]</c:if> ${result.NTT_SJ}</a>
								</div>
								<%-- <div style="font-size:12px; width: 30%; float: right;    text-align: right; ">${result.WRITNG_DE}</div> --%>
								<c:if test="${result.NEW_YN eq 'Y'}">
								<div class="icon">
									<img src="/img/icon_new2.png" alt="" />
								</div>
								</c:if>
							</li>
							</c:forEach>
						</ul>
					</div>
				</div>
				
				<div class="main_notice_box">
					<div class="title_box">
						<div class="title_t">
							문의사항<em>Q&A</em>
						</div>
						<div class="title_more"><a href="/bbs/00000000000000000003/list/"><b>+</b></a></div>
					</div>
					<div class="list_box">
						<ul>
						<c:if test="${fn:length(qnaList) == 0}">
						</c:if>
						<c:forEach var="result" items="${qnaList}" varStatus="status">
						<li>
							<c:choose>
								<c:when test="${result.NOTICE_YN eq 'Y'}">
									<div class="icon"><img src="/img/notice_icon1.png" alt="" /></div>
								</c:when>
								<c:otherwise>
									<div class="icon"><img src="/img/notice_icon2.png" alt="" /></div>
								</c:otherwise>
							</c:choose>
							<div class="tx" style="font-size:12px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"><a href="javascript:fnBbsDetail('00000000000000000003', '${result.BBS_SN}');">${result.NTT_SJ}</a></div>
							<%-- <div class="date">${result.WRITNG_DE}</div> --%>
						</li>
						</c:forEach>

						</ul>
					</div>
				</div>
			</div>

			<div class="main_r_box ">
				<div class="main_case_box">
					<div class="title_box">
						<div class="title_t">
							내사건<em>My case</em>
						</div>
						<div class="title_tab">
							<a href="javascript:fnCaseSelect('A');" id="tabCaseA" class="on">전체사건</a>
							<a href="javascript:fnCaseSelect('F');" id="tabCaseF">정식사건</a>
							<a href="javascript:fnCaseSelect('I');" id="tabCaseI">내사사건</a>
							<a href="javascript:fnCaseSelect('T');" id="tabCaseT">임시사건</a>
						</div>
						<div class="title_more">
							<a href="javascript:fnRdoCaseDetail();">사건상세보기</a>
						</div>
					</div>

					<div class="list_box" id="divCaseA">
						<table class="tb_07">
							<thead>
								<tr>
									<th>선택</th>
									<th>접수번호</th>
									<th>사건번호</th>
									<th>수사단서</th>
									<th>사건구분</th>
									<th>위반죄명</th>
									<th>진행상태</th>
									<th>경과일</th>
								</tr>
							</thead>
							<tbody>

							<c:if test="${fn:length(caseAList) == 0}">
								<tr><td colspan="8">조회된 결과가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="result" items="${caseAList}" varStatus="status">
								<tr>
									<td><input type="radio" name="rdoCaseNo" value="${result.RC_NO}" class='to-labelauty-icon'></td>
									<td><a href="javascript:fnCaseDetailPopup('${result.RC_NO}', '');">${result.RC_NO}</a></td>
									<td>${result.CASE_NO}</td>
									<td>${result.INV_PROVIS_NM}</td>
									<td>${result.RC_SE_NM}</td>
									<td style="width:200px;"><div class="mainOverflow">${result.VIOLT_NM}</div></td>
									<td>
										<c:if test="${result.PROGRS_STTUS_NM != null}">
											<c:choose>
												<c:when test="${result.PROGRS_STTUS_CD == '02124'}">
													<div class="ing_box">
														<div class="ing4" style="width:120px;">${result.PROGRS_STTUS_NM}</div>
													</div>
												</c:when>
												<c:when test="${result.PROGRS_STTUS_CD == '02125'}">
													<div class="ing_box">
														<div class="ing5" style="width:120px;">${result.PROGRS_STTUS_NM}</div>
													</div>
												</c:when>
												<c:otherwise>
													<div class="ing_box">
														<div class="ing1" style="width:120px;">${result.PROGRS_STTUS_NM}</div>
													</div>
												</c:otherwise>
											</c:choose>
										</c:if>
									</td>
									<td>${result.DELAY_PD}</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="list_box" id="divCaseF" style="display:none;">
						<table class="tb_07">
							<thead>
								<tr>
									<th>선택</th>
									<th>접수번호</th>
									<th>사건번호</th>
									<th>수사단서</th>
									<th>사건구분</th>
									<th>위반죄명</th>
									<th>진행상태</th>
									<th>경과일</th>
								</tr>
							</thead>
							<tbody>

							<c:if test="${fn:length(caseFList) == 0}">
								<tr><td colspan="8">조회된 결과가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="result" items="${caseFList}" varStatus="status">
								<tr>
									<td><input type="radio" name="rdoCaseNo" value="${result.RC_NO}" class='to-labelauty-icon'></td>
									<td><a href="javascript:fnCaseDetailPopup('${result.RC_NO}', '');">${result.RC_NO}</a></td>
									<td>${result.CASE_NO}</td>
									<td>${result.INV_PROVIS_NM}</td>
									<td>${result.RC_SE_NM}</td>
									<td style="width:200px;"><div class="mainOverflow">${result.VIOLT_NM}</div></td>
									<td>
										<c:if test="${result.PROGRS_STTUS_NM != null}">
											<c:choose>
												<c:when test="${result.PROGRS_STTUS_CD == '02124'}">
													<div class="ing_box">
														<div class="ing4" style="width:120px;">${result.PROGRS_STTUS_NM}</div>
													</div>
												</c:when>
												<c:when test="${result.PROGRS_STTUS_CD == '02125'}">
													<div class="ing_box">
														<div class="ing5" style="width:120px;">${result.PROGRS_STTUS_NM}</div>
													</div>
												</c:when>
												<c:otherwise>
													<div class="ing_box">
														<div class="ing1" style="width:120px;">${result.PROGRS_STTUS_NM}</div>
													</div>
												</c:otherwise>
											</c:choose>
										</c:if>
									</td>
									<td>${result.DELAY_PD}</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="list_box" id="divCaseT" style="display:none;">
						<table class="tb_07">
							<thead>
								<tr>
									<th>선택</th>
									<th>접수번호</th>
									<th>수사단서</th>
									<th>사건구분</th>
									<th>위반죄명</th>
									<th>진행상태</th>
									<th>경과일</th>
								</tr>
							</thead>
							<tbody>

							<c:if test="${fn:length(caseTList) == 0}">
								<tr><td colspan="8">조회된 결과가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="result" items="${caseTList}" varStatus="status">
								<tr>
									<td><input type="radio" name="rdoCaseNo" value="${result.RC_NO}" class='to-labelauty-icon'></td>
									<td><a href="javascript:fnCaseDetailPopup('${result.RC_NO}', '');">${result.RC_NO}</a></td>
									<td>${result.INV_PROVIS_NM}</td>
									<td>${result.RC_SE_NM}</td>
									<td style="width:200px;"><div class="mainOverflow">${result.VIOLT_NM}</div></td>
									<td>
										<c:if test="${result.PROGRS_STTUS_NM != null}">
										<div class="ing_box">
											<div class="ing2" style="width:120px;">${result.PROGRS_STTUS_NM}</div>
										</div>
										</c:if>
									</td>
									<td>${result.DELAY_PD}</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="list_box" id="divCaseI" style="display:none;">
						<table class="tb_07">
							<thead>
								<tr>
									<th>선택</th>
									<th>접수번호</th>
									<th>내사번호</th>
									<th>수사단서</th>
									<th>사건구분</th>
									<th>위반죄명</th>
									<th>진행상태</th>
									<th>경과일</th>
								</tr>
							</thead>
							<tbody>

							<c:if test="${fn:length(caseIList) == 0}">
								<tr><td colspan="8">조회된 결과가 없습니다.</td></tr>
							</c:if>
							<c:forEach var="result" items="${caseIList}" varStatus="status">
								<tr>
									<td><input type="radio" name="rdoCaseNo" value="${result.RC_NO}" class='to-labelauty-icon'></td>
									<td><a href="javascript:fnCaseDetailPopup('${result.RC_NO}', '');">${result.RC_NO}</a></td>
									<td>${result.ITIV_NO}</td>
									<td>${result.INV_PROVIS_NM}</td>
									<td>${result.RC_SE_NM}</td>
									<td style="width:200px;"><div class="mainOverflow">${result.VIOLT_NM}</div></td>
									<td>
										<c:if test="${result.PROGRS_STTUS_NM != null}">
										<div class="ing_box">
											<div class="ing2" style="width:120px;">${result.PROGRS_STTUS_NM}</div>
										</div>
										</c:if>
									</td>
									<td>${result.DELAY_PD}</td>
								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>