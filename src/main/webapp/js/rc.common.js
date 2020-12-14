var   caseUpdatePopSize = 'width=1050px,height=610px,center=1,resize=0,scrolling=0';
var trgterUpdatePopSize = 'width=910px,height=680px,center=1,resize=0,scrolling=0';

$(function() {
	 $('#txtCaseSumry').keyup(function (e){
         var content = $(this).val();
         $(this).height(((content.split('\n').length + 1) * 1.5) + 'em');
         $('#txtCaseSumryCounter').html(content.length + '/2000');
     });

     $('#txtCaseSumry').keyup();

	 $('#txtCrmnlFact').keyup(function (e){
         var content = $(this).val();
         $(this).height(((content.split('\n').length + 1) * 1.5) + 'em');
         $('#txtCrmnlFactCounter').html(content.length + '/2000');
     });

     $('#txtCrmnlFact').keyup();

	 $('#txtPrfDta').keyup(function (e){
         var content = $(this).val();
         $(this).height(((content.split('\n').length + 1) * 1.5) + 'em');
         $('#txtPrfDtaCounter').html(content.length + '/2000');
     });

     $('#txtPrfDta').keyup();

	 $('#txtEtcCn').keyup(function (e){
         var content = $(this).val();
         $(this).height(((content.split('\n').length + 1) * 1.5) + 'em');
         $('#txtEtcCnCounter').html(content.length + '/2000');
     });

     $('#txtEtcCn').keyup();

});


//검색 조건 validate
function fnSearchValidate(){

	if( "stdrNo" == $(":input:radio[name=radioSearchStdr]:checked").val() ){

		if( $("#textSearchYear").val().length != 4 ){
			alert("검색년도를 확인해주세요");
			$("#textSearchYear").focus();
			return false;
		}

		if( fnIsEmpty($("#textSearchNoStart").val()) == true   ){

			alert("검색번호를 입력해주세요");
			$("#textSearchNoStart").focus();
			return false;
		}

		if( fnIsEmpty($("#textSearchNoStart").val()) == false && fnIsEmpty($("#textSearchNoEnd").val()) == false  ){
			if( $("#textSearchNoStart").val() > $("#textSearchNoEnd").val() ){

				alert("검색 번호를 확인해주세요");
				$("#textSearchNoStart").focus();
				return false;
			}
		}

	}

	if( "stdrDe" == $(":input:radio[name=radioSearchStdr]:checked").val() ){
		if( ($("#textReceiptDeStart").val() == null || $("#textReceiptDeStart").val() == "") && ($("#textReceiptDeEnd").val() == null || $("#textReceiptDeEnd").val() == "" ) ){
			alert("접수 일자가 유효하지 않습니다.");
			return false;
		}

		if( !fnCompareDate($("#textReceiptDeStart"), $("#textReceiptDeEnd")) ) {
			return false;
		}
	}

	return true;
}

//검색 조건 validate
function fnSearchAllValidate(){

	if( fnIsEmpty($("#textSearchNoStart").val()) == false || fnIsEmpty($("#textSearchNoEnd").val()) != false ){
		if( $("#textSearchYear").val().length > 0 && $("#textSearchYear").val().length < 4 ){
			alert("검색년도를 확인해주세요");
			$("#textSearchYear").focus();
			return false;
		}
	}


	if( $("#textSearchYear").val().length > 0 ){

		if( $("#textSearchYear").val().length != 4 ){
			alert("검색년도를 확인해주세요");
			$("#textSearchYear").focus();
			return false;
		}

		if( fnIsEmpty($("#textSearchNoStart").val()) == true && fnIsEmpty($("#textSearchNoEnd").val()) == true ){
			alert("검색번호를 입력해주세요");
			$("#textSearchNoStart").focus();
			return false;
		}

		if( fnIsEmpty($("#textSearchNoStart").val()) == false && fnIsEmpty($("#textSearchNoEnd").val()) == false ){
			if( $("#textSearchNoStart").val() > $("#textSearchNoEnd").val() ){
				alert("검색 번호를 확인해주세요");
				$("#textSearchNoStart").focus();
				return false;
			}
		}
	}


	if( ($("#textReceiptDeStart").val() == null || $("#textReceiptDeStart").val() == "") && ($("#textReceiptDeEnd").val() == null || $("#textReceiptDeEnd").val() == "" ) ){
		alert("접수 일자가 유효하지 않습니다.");
		return false;
	}

	if( !fnCompareDate($("#textReceiptDeStart"), $("#textReceiptDeEnd")) ) {
		alert("접수 일자가 유효하지 않습니다.");
		return false;
	}

	return true;
}

//다중 주소값 호출 function
function fnZipPopConnect(val){

	$("#hidSelectAddress").val(val.id)
	fnZipPop();
}

//주소값 리턴
function jusoReturnValue (returnValue) {

	var returnId = $("#hidSelectAddress").val();

	$("#txt"+returnId+"Addr").val(returnValue.addr);
	$("#txt"+returnId+"Zip").val(returnValue.zipCd);
}


//위반사항결과 리턴
function fnSelectViolt(upcd, cd, nm){

	//위반사항 코드를 서버에 올려 위반죄명을 다시 리턴
	var processAfterGet = function(data) {

		$("#txtVioltNm").val(data);
	};

	Ajax.getJson('/rc/selectVioltNmRemarkAjax/', {violtCd : cd}, processAfterGet);

	$("#hidVioltCd").val(cd);
}

//주민번호 입력시 나이 계산
function fnTargetAgeCalculation(){

	Now = new Date(); //현재 날짜
	NowYear = Now.getFullYear(); //현재 연도

	var j1 = $("#txtTrgterRrnFront").val(); //앞 6자리
	var j2 = $("#txtTrgterRrnEnd").val(); 	//뒤 7자리

	if( (j1+j2).length == 13 ) {

		var n1 = j1.substr(0, 2); //앞 6자리에 입력한 값중 앞에서 두글자
		var n2 = j2.substr(0, 1); //뒤 7자리에 입력한 값중 맨앞의 글자
		if ((n2 == 1) || (n2 == 2)) { //뒤 첫째값이 1, 2일 경우(1900년대에 출생한 남녀)
			$("#txtTrgterAge").val(NowYear - (1900 + Number(n1)));
		}
		if ((n2 == 3) || (n2 == 4)) { //뒤 첫째값이 3, 4일 경우
			$("#txtTrgterAge").val(NowYear - (2000 + Number(n1)));
		}
	}
}

//다중 주소값 호출 function
function fnZipPopConnect(val){

	$("#hidSelectAddress").val(val.id)
	fnZipPop();
}

//주소값 리턴
function jusoReturnValue (returnValue) {

	var returnId = $("#hidSelectAddress").val();

	$("#txt"+returnId+"Addr").val(returnValue.addr);
	$("#txt"+returnId+"Zip").val(returnValue.zipCd);
}

//공통코드 결과값 리턴
function fnSelectCd(upcd, cd, nm){

	if( "00300" == upcd ){	//직업 코드

		$("#txtOccpNm").val(nm);
		$("#hidOccpCd").val(cd);
	}

	if( "01117" == upcd ){	//국적 코드

		$("#txtNltyNm").val(nm);
		$("#hidNltyCd").val(cd);
	}
}
