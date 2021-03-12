
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

		/**
		00001	접수/배당
		00002	입건/조사
		00003	승인관리
		00005	송치/종결
		00007	대장/통계
		00008	정보검색
		00004	관리자
		*/
		if(menuClCd.equals("00001")){
			menuClIcon = "icon1";
		}else if(menuClCd.equals("00002")){
			menuClIcon = "icon2";
		}else if(menuClCd.equals("00003")){
			menuClIcon = "icon3";
		}else if(menuClCd.equals("00005")){
			menuClIcon = "icon4";
		}else if(menuClCd.equals("00007") || menuClCd.equals("00011")){
			menuClIcon = "icon5";
		}else if(menuClCd.equals("00008")){
			menuClIcon = "icon6";
		}else if(menuClCd.equals("00006")){
			menuClIcon = "icon7";
		}else if(menuClCd.equals("00004")){
			menuClIcon = "icon8";
		}
		pageContext.setAttribute("LayoutMenuIcon", menuClIcon);
	}
	pageContext.setAttribute("ClInfoList", 		clInfoList);
	pageContext.setAttribute("LayoutMenuList",  menuList);

//MENU_CD=00029, MENU_CL_CD=00002, MENU_CL_NM=입건/조사, MENU_URL=/file/traceNoticeList/, MENU_NM=압수수색검증영장 관리, RELATE_URL=/file/traceNoticeDetail/}, 00004_/bbs/noticeList/={MENU_CD=00018, MENU_CL_CD=00005, MENU_CL_NM=송치/종결, MENU_URL=/bbs/noticeList/

	//현재위치
	List<HashMap> menuLeftList = authorManager.getMenu(author_cd, menuClCd);
	pageContext.setAttribute("LayoutMenuLeftList", menuLeftList);

	//현재일자
	SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd", Locale.KOREA );
	Date nowDate = new Date();
	String strDate = mSimpleDateFormat.format (nowDate);
	pageContext.setAttribute("LayoutNowDate", strDate);


%>

<jsp:include page="/inc/header.jsp"/>

<style>
	/* 메인상단 */
	.logo {
		background-color: honeydew;
	}
</style>

<script type="text/javascript">
	function fnLayoutLogout(){
	    location.href = "<c:url value='/member/logoutAction/'/>";
	}
	function fnLayoutUserInfo(){
	    location.href = "<c:url value='/member/updateSelf/'/>";
	}
	function fnLayoutLogin(){
	    location.href = "<c:url value='/member/login/'/>";
	}
</script>

<body>
<!--상단영역 공통  -->
<header>
	<div class="logo">
		<a href="/"><img src="/img/logo.png" style="width: 205px;" alt="특사경 수사시스템"/></a>
	</div>

	<div class="topicon_menu" style="left:220px;">
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
			<a href="http://law.go.kr"  target="_blank"> 국가법령정보</a>
		</div>
		<c:choose>
		 <c:when test="${fn:length(esntl_id) > 0}">
    		<div class="member" style="margin-right: 0px;">
    			<img src="/img/icon_member.png" width="30" height="29" alt="" style="margin-right: 0px;margin-left: 20px;"/>
      				<p>${user_nm}</p>
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
<!--//상단영역 공통  -->
<input type="checkbox" id="menu_state" checked>
<nav>
	<label for="menu_state"><i class="fa"></i></label>
	<div class="left_title">
		<c:choose>
			<c:when test="${LayoutMenuClCd eq '00001'}"><c:set var="iconImg" value="icon01"/></c:when>
			<c:when test="${LayoutMenuClCd eq '00002'}"><c:set var="iconImg" value="icon02"/></c:when>
			<c:when test="${LayoutMenuClCd eq '00003'}"><c:set var="iconImg" value="icon03"/></c:when>
			<c:when test="${LayoutMenuClCd eq '00005'}"><c:set var="iconImg" value="icon04"/></c:when>
			<c:when test="${LayoutMenuClCd eq '00007'}"><c:set var="iconImg" value="icon05"/></c:when>
			<c:when test="${LayoutMenuClCd eq '00011'}"><c:set var="iconImg" value="icon05"/></c:when>
			<c:when test="${LayoutMenuClCd eq '00008'}"><c:set var="iconImg" value="icon06"/></c:when>
			<c:when test="${LayoutMenuClCd eq '00004'}"><c:set var="iconImg" value="icon08"/></c:when>
			<c:otherwise><c:set var="iconImg" value="icon01"/></c:otherwise>
		</c:choose>
	    <div class="icon"><img src="/img/menu_${iconImg}.png"  alt=""/></div>
	    <div class="title">${LayoutMenuClName}</div>
	</div>
	<ul class="nav" id="demo1" >
	<c:forEach var="resultDtl" items="${LayoutMenuLeftList}" varStatus="statusDtl">
		<li <c:if test="${LayoutMenuCd eq resultDtl.MENU_CD}">class="active open"</c:if>><a href="${resultDtl.MENU_URL}">${resultDtl.MENU_NM}</a></li>
	</c:forEach>
	</ul>
</nav>
<main>
<div class="sub_box">
<!--타이틀 공통 -->
<div class="title_box">
	<div class="title_tx">${LayoutMenuName}</div>
	<div class="title_time"><em>${LayoutNowDate}</em> 기준 </div>
	<div class="route">
    <div class="icon"><img src="/img/icon_home.png" alt=""/></div>
    HOME  > ${LayoutMenuClName} > <em>${LayoutMenuName}</em> </div>
</div>
<!--//타이틀 공통 -->

<decorator:body />

</div>
</main>
</body>
</html>
