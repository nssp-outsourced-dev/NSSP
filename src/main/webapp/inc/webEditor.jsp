<%--
 * 업  무  명  : WEB-EDI 웹에디터 부분
 * 프로그램 ID : webEditor.jsp
 * 프로그램 명 : WEB-EDI 웹에디터 부분
 * 개       요 : WEB-EDI 웹에디터 부분을 위한 JSP
 * 작  성  자  : 이승환
 * 작  성  일  : 2018. 5. 3
 * 
 * 수정일              수정자             수정내용 
 * --------  ------      --------------------------- 
 * 2018. 5. 3  이승환           최초작성 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript" src="/html/se2/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

var oEditors = [];
var noConts  = "<p>&nbsp;</p>";

//추가 글꼴 목록
//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];


$(document).ready(function(){
    
    nhn.husky.EZCreator.createInIFrame({
        oAppRef: oEditors,
        elPlaceHolder: "txtWebEditor",
        sSkinURI: "/html/se2/SmartEditor2Skin.html",  
        htParams : {
            bUseToolbar : true,             // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseVerticalResizer : true,     // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseModeChanger : true,         // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
            //bSkipXssFilter : true,        // client-side xss filter 무시 여부 (true:사용하지 않음 / 그외:사용)
            //aAdditionalFontList : aAdditionalFontSet,     // 추가 글꼴 목록
            fOnBeforeUnload : function(){
                //alert("완료!");
            }
        }, //boolean
        fOnAppLoad : function(){
            //예제 코드
            //oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
        },
        fCreator: "createSEditor2"
    });
});

function pasteHTML() {
    var sHTML = "<span style='color:#FF0000;'>이미지도 같은 방식으로 삽입합니다.<\/span>";
    oEditors.getById["txtWebEditor"].exec("PASTE_HTML", [sHTML]);
}

function showHTML() {
    var sHTML = oEditors.getById["txtWebEditor"].getIR();
    alert(sHTML);
}
    
function submitContents(elClickedObj) {
    oEditors.getById["txtWebEditor"].exec("UPDATE_CONTENTS_FIELD", []);  // 에디터의 내용이 textarea에 적용됩니다.
    
    // 에디터의 내용에 대한 값 검증은 이곳에서 document.getElementById("ir1").value를 이용해서 처리하면 됩니다.
    
    try {
        elClickedObj.form.submit();
    } catch(e) {}
}

function setDefaultFont() {
    var sDefaultFont = '궁서';
    var nFontSize = 24;
    oEditors.getById["txtWebEditor"].setDefaultFont(sDefaultFont, nFontSize);
}

</script>
