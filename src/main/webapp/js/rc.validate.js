
$(function() {	
	
	//사건정보 form
	$('#caseForm').validate({
		
					onclick : false 	//클릭시 발생됨 꺼놓음
			   , onfocusout : false 	//포커스가 아웃되면 발생됨 꺼놓음
			 , focusInvalid : false		//유효성 검사후 포커스를 무효필드에 둠 꺼놓음
			 , focusCleanup : true 		//true이면 잘못된 필드에 포커스가 가면 에러를 지움
		      	  , onkeyup : false 	//키보드 키가 올라가면 발생됨 꺼놓음
			       , ignore : '*:not([name])'
				 // , debug : true		//submit action 유무
				    , rules : {
					 			   txtRcDe : { required : true	
											 , dateArrangement : true 
											 }						//접수일시
							   , rdoRcSeCd : { required : true	}	//사건구분 = 접수구분
						  , selInvProvisCd : { required : true	}	//수사단서
						  	  , txtCnsltDe : { required : false	
						  		  			 , dateArrangement : true 
						  		  			 }						//상담일시
					      	  , txtVioltNm : { required : true 	}	//위반죄명
					   , txtOccrrncBeginDe : { required : false	
						   					 , dateArrangement : true 
						   					 }						//발생 시작 일시
					     , txtOccrrncEndDe : { required : false	
					    	 				 , dateArrangement : true	 
					    	 				 , dateChk : true	
					    	 				 } 						//발생 종료 일시
					       , txtOccrrncZip : { required : false	}	//발생장소 우편번호
					      , txtOccrrncAddr : { required : false }	//발생장소 주소
					      	, txtCaseSumry : { required : false	}	//사건개요
					        , txtCrmnlFact : { required : false	}	//범죄사실
						   }
			     , messages : {
			    				   txtRcDe : { required : "접수일시를 입력해주세요."	}	    
							   , rdoRcSeCd : { required : "사건구분을 선택해주세요."	}
						  , selInvProvisCd : { required : "수사단서를 선택해주세요."	}
					   , txtOccrrncBeginDe : { required : "발생 시작 일시를 입력해주세요."	}
					     , txtOccrrncEndDe : { required : "발생 종료 일시를 입력해주세요."
					    	 				 ,  dateChk : "발생 시작일과 종료일이 올바르지 않습니다."	} 	 
					       , txtOccrrncZip : { required : "발생장소를 입력해주세요."	}	
						  , txtOccrrncAddr : { required : "발생장소를 입력해주세요."	}	
						      , txtCnsltDe : { dateArrangement : "상담일시를 확인해주세요."		}	
					      	  , txtVioltNm : { required : "위반죄명을 선택해주세요."	}	
					        , txtCaseSumry : { required : "사건개요를 선택해주세요."	}	
					        , txtCrmnlFact : { required : "범죄사실을 입력해주세요."	}	   
			  			
			  		}
		   , errorPlacement : function(){ //validator는 기본적으로 validation 실패시 메세지를 우측에 표시하게 되어있다 원치않으면 입력해놓을것 ★안쓰면 에러표시됨★
											console.log("실패");
									    }
		    , submitHandler : function(){ //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
		    	
		    								//fnNumberArrangement("C");
				
		    								if( $("#screenClassification").val() == "U" ) {
								    			fnUpdate();
											} else {
												fnCaseSaveProcess();
											}
									  	}
		   , invalidHandler : function( form, validator ){ //입력값이 잘못된 상태에서 submit 할때 호출
								
			   						var errors = validator.numberOfInvalids();
				
									console.log("errors");
									
									if( errors ){
										alert(validator.errorList[0].message);
										validator.errorList[0].element.focus();
									} else {
										alert("성공");
									}
		   					}
		});//validate end
		
	//대상자 form
	$('#targetForm').validate({
			     onclick : false 	//클릭시 발생됨 꺼놓음
			, onfocusout : false 	//포커스가 아웃되면 발생됨 꺼놓음
		  , focusInvalid : false	//유효성 검사후 포커스를 무효필드에 둠 꺼놓음
		  ,	focusCleanup : true 	//true이면 잘못된 필드에 포커스가 가면 에러를 지움
		       , onkeyup : false 	//키보드 키가 올라가면 발생됨 꺼놓음
			    , ignore : '*:not([name])'
				// , debug : true
				 , rules : { // bizIdChk
					    
					 	     selTrgterSeCd : {  required : true  }
						     , txtTrgterNm : {  required : true  , minlength : 2 , maxlength : 19 }
					   , txtTrgterRrnFront : {  required : false , minlength : 6 , maxlength : 6, rrnChk : true	}
					     , txtTrgterRrnEnd : {  required : false , minlength : 7 , maxlength : 7, rrnChk : true	}
					     		  , txtAge : {  required : false }
					        , rdoSexdstnCd : {  required : false }
					       , selTrgterClCd : {  required : false }
						        , selHpNo1 : {  required : false }
						        , txtHpNo2 : {  required : false , minlength : 3	}
						        , txtHpNo3 : {  required : false , minlength : 4	}
						   , selOwnhomTel1 : {  required : false }
						   , txtOwnhomTel2 : {  required : false , minlength : 3	}
						   , txtOwnhomTel3 : {  required : false , minlength : 4	}
						   	  , selWrcTel1 : {  required : false }
						   	  , txtWrcTel2 : {  required : false , minlength : 3	}
						   	  , txtWrcTel3 : {  required : false , minlength : 4	}
						   	  , selEtcTel1 : {  required : false }
						   	  , txtEtcTel2 : {  required : false , minlength : 3 	}
						   	  , txtEtcTel3 : {  required : false , minlength : 4 	}
					        , txtPasportNo : {  required : false , pasportNoChk : true }		//여권번호 
			  			, txtTrgterJurirno : {jurirnoChk : true  }	
			  			    , txtTrgterCrn : {  bizIdChk : false }		
			  			    , txtTrgterCrn : {  bizIdChk : false }		
			  			        , txtEmail : {  emailChk : true  }		
			  			    , selAgentTel1 : {  required : false }
			  			    , txtAgentTel2 : {  required : false , minlength : 3	}
			  			    , txtAgentTel3 : {  required : false , minlength : 4 	}
						   }
			  , messages : {
				  			 selTrgterSeCd : {  required : "대상자 구분을 선택해주세요."		}	    
			  			     , txtTrgterNm : {  required : "대상자 성명(한글)을 입력해주세요."
						  			    	 , minlength : "대상자 성명(한글) {0}자리 이상 입력해주세요."	 
						  			    	 , maxlength : "대상자 성명(한글) {0}자리 이하로 입력해주세요."	 
			  			     				 }	    
			  		   , txtTrgterRrnFront : {  required : "대상자 주민번호 앞자리를 입력해주세요."
			  				   				 , minlength : "대상자 주민번호 앞자리를 다시 확인해주세요"
			  				   				    , rrnChk : "주민번호 형식이 올바르지 않습니다."
			  				  			     }	    
			  			 , txtTrgterRrnEnd : {  required : "대상자 주민번호 뒷자리를 입력해주세요."
			  				 				 , minlength : "대상자 주민번호 뒷자리를 다시 확인해주세요"
			  				 					, rrnChk : "주민번호 형식이 올바르지 않습니다."
			  			  				     }	    
			  			  		  , txtAge : {  required : "대상자 나이를 입력해주세요."			}	    
			  			    , rdoSexdstnCd : {  required : "대상자 성별을 선택해주세요."			}		    
			  		  	   , selTrgterClCd : {  required : "대상자 분류를 선택해주세요."			}	    
			  		  	   		, txtHpNo2 : { minlength : "휴대전화 가운데 번호를 확인해주세요." 	}	    
			  		  	   		, txtHpNo3 : { minlength : "휴대전화 마지막 번호를 확인해주세요." 	}	    
			  			   , txtOwnhomTel2 : { minlength : "자택전화 가운데 번호를 확인해주세요." 	}	    
			  			   , txtOwnhomTel3 : { minlength : "자택전화 마지막 번호를 확인해주세요."	}
			  			      , txtEtcTel2 : { minlength : "기타전화 가운데 번호를 확인해주세요." 	}	    
			  			      , txtEtcTel3 : { minlength : "직장전화 마지막 번호를 확인해주세요." 	}	    
			  			    , txtAgentTel2 : { minlength : "대리인 가운데 번호를  확인해주세요."		}
			  			    , txtAgentTel3 : { minlength : "대리인 마지막 번호를  확인해주세요."	  	}	    
			  			      , txtVioltNm : {  required : "위반죄명을 선택해주세요."		  	}	
			  			       , txtOccpCd : {  required : "대상자 직업을 선택해주세요."			}	
			  			    , txtTrgterCrn : {  bizIdChk : "사업자번호 형식이 올바르지 않습니다."	}		
			  	        , txtTrgterJurirno : {jurirnoChk : "법인번호 형식이 올바르지 않습니다." 	}	
			  	        		, txtEmail : {  emailChk : "이메일 형식이 올바르지 않습니다."		}	
			  			    , txtPasportNo : {pasportNoChk : "여권번호 형식이 올바르지 않습니다." 	}	
			   			 }
		, errorPlacement : function (){ //validator는 기본적으로 validation 실패시 메세지를 우측에 표시하게 되어있다 원치않으면 입력해놓을것 ★안쓰면 에러표시됨★
										console.log("실패");
									  }
		 , submitHandler : function() { //모든 항목이 통과되면 호출됨 ★showError 와 함께 쓰면 실행하지않는다★
											
			 								if(!fnNumberArrangement("T")){
			 									return false;
			 								}
			 								
			 								if( $("#screenClassification").val() == "U" ) {
			 									fnTrgterUpdate();
			 									
			 								} else {
			 									/*if( "" != $("#hidRcNo").val() &&  $("#hidRcNo").val().length > 0 ){
			 										fnTrgterAdd();
			 									} else {
			 										forceUpdatingRow();				//폼의 입력값을 로우에 Update
			 										$("#hidGridRowStatus").val(""); //로우 에디트 상태 완료(Completion)
			 									}*/
			 									forceUpdatingRow();					//폼의 입력값을 로우에 Update
			 									$("#hidGridRowStatus").val(""); 	//로우 에디트 상태 완료(Completion)
			 									
			 								}
			 
									  }
		, invalidHandler : function( form, validator ){ //입력값이 잘못된 상태에서 submit 할때 호출
								var errors = validator.numberOfInvalids();
			
								console.log("대상자 errors");
								
								if( errors ){
									alert(validator.errorList[0].message);
									validator.errorList[0].element.focus();
								} else {
									//alert("성공");
								}
							}
		})//validate end
		
		
		//번화번호 배치 확인
		function fnNumberArrangement(val){
			
			//C : 사건
			if( "C" == val ){
				var errorCnt = 0;
				if( $('#selCpttrHpNo1').val() != null && $('#selCpttrHpNo1').val() != "" ){
					if( $('#txtCpttrHpNo2').val().length == 0 || $('#txtCpttrHpNo3').val().length == 0 ){
						errorCnt++;
					}
				}
				
				if( $('#selCpttrHpNo1').val() == null ){
					if( ($('#txtCpttrHpNo2').val().length + $('#txtCpttrHpNo3').val().length ) > 0 ){
						errorCnt++;
					}
				}
				
				if( errorCnt > 0 ){
					alert( "민원인 전화 번호 형식이 올바르지 않습니다 ");
					$('#txtCpttr3').focus();
					return false;
				} 
				
				if( $('#selCpttrHpNo1').val().length > 0  && $('#txtCpttrHpNo2').val().length > 0 && $('#txtCpttrHpNo3').val().length > 0 ){
					$('#hidCpttrHpNo').val($('#selCpttrHpNo1').val()+"-"+$('#txtCpttrHpNo2').val()+"-"+$('#txtCpttrHpNo3').val());
				}
				
				return true;
				
			} else if( "T" == val ){ //T :대상자
				
				var telAry = ["HpNo","OwnhomTel","WrcTel","EtcTel","AgentTel"];
				var telNm="";
				for ( var i = 0; i < telAry.length; i++ ) {
					var strTel = telAry[i];
					
					var errorCnt = 0;
					if( null != $('#sel'+strTel+'1').val() && "" != $('#sel'+strTel+'1').val() ){
						if( $('#txt'+strTel+'2').val().length == 0 || $('#txt'+strTel+'3').val().length == 0){
							errorCnt++;
							telNm = strTel;
							break;
						}
					}
					if( null == $('#sel'+strTel+'1').val() || "" == $('#sel'+strTel+'1').val() ){
						if( ($('#txt'+strTel+'2').val().length + $('#txt'+strTel+'3').val().length ) > 0){
							errorCnt++;
							telNm = strTel;
							break;
						}
					
					} else {
						if( $('#sel'+strTel+'1').val().length > 0  && $('#txt'+strTel+'2').val().length > 0 && $('#txt'+strTel+'3').val().length > 0 ){
							$('#hid'+strTel+'').val($('#sel'+strTel+'1').val()+"-"+$('#txt'+strTel+'2').val()+"-"+$('#txt'+strTel+'3').val());
						}
					}
					
				}
				
				if( errorCnt > 0 ){
					var telNmK="";
					if( telNm =="HpNo" 	   ){ telNmK = "휴대";  }
					if( telNm =="OwnhomTel"){ telNmK = "자택";  }
					if( telNm =="WrcTel"   ){ telNmK = "직장";  }
					if( telNm =="EtcTel"   ){ telNmK = "기타";  }
					if( telNm =="AgentTel" ){ telNmK = "대리인"; }
					
					alert( telNmK+"전화 번호 형식이 올바르지 않습니다 ");
					
					$('#txt'+telNm+'3').focus();
					return false;
				} 
				return true;
			}
		}
		
		function btnSaveSend (pProgrsSttusCd) {
		//대표 접수 건 확인
		if( !prscrKeyCheck("저장해 주세요.") ) return;
		var activeItems = AUIGrid.getItemsByValue("#grid_wrap", "grdReprsntYn", "Y");
		if( activeItems.length != 1 ) {
			alert("대표 접수번호를 지정하여 주십시오.");
			return;
		}
		//대표번호 set
		$('#dtlForm').find('#hidRcNo').val( activeItems[0].grdRcNo );

		//접수전체목록
		var data = {};
		var arrCaseNo = [];
		var mainLst = AUIGrid.getCheckedRowItems("#grid_wrap");
		var mainFullLst = AUIGrid.getGridData("#grid_wrap");
		if( mainLst.length < 1 ) {
			alert("저장하려는 접수번호를 체크하여 주십시오.");
			return;
		}
		var mList = [];
		for(var i in mainLst) {
			mList.push(mainLst[i].item);
			if(!fnIsEmpty(mainLst[i].item.grdCaseNo)) {
				arrCaseNo.push(mainLst[i].item.grdCaseNo);
			}
		}
		
		//중복제거
		var uniqueCaseNo = [];
		$.each(arrCaseNo, function(i, el){
			if($.inArray(el, uniqueCaseNo) === -1) uniqueCaseNo.push(el);
		});
		if( uniqueCaseNo.length > 1 ) {
			alert("사건번호의 병합은 불가능 합니다.\n\n하나의 사건번호만 체크해 주세요.");
			return;
		}
		data.grdMainList = mList;
		data.grdMainFullList = mainFullLst;
		//대상
		var trgterG = AUIGrid.getGridData("#gridR_wrap");
		if(trgterG.length < 1) {
			alert("대상자를 지정하여 주십시오.");
			return;
		}

		//상세보기 내용
		data.dtl = $('#dtlForm').serializeFormJSON();
		data.dtl["hidRcNo"] = activeItems[0].grdRcNo;

		/*진행상태*/
		data.dtl["hidProgrsSttusCd"] = pProgrsSttusCd;

		/*대상*/
		if( trgterG.length > 0 ) {
			var fTrgter = [];
			for( var i in trgterG ) {
				if( fnIsEmpty(trgterG[i].grdCaseNo) ){
					fTrgter.push(trgterG[i]);
				}
			}
			if( fTrgter.length > 0 ){
				data.grdTrgter = trgterG;
			}
		}
		var rSave = fnAjaxAction('/inv/savePrsct/', JSON.stringify (data));
		if( !fnIsEmpty(rSave) ) {
			if( !fnIsEmpty(rSave["ERROR"]) ) {
				alert( rSave["ERROR"] );
				return;
			}
			if( pProgrsSttusCd=="00222" ) {
				alert("승인요청되었습니다.");
			} else {
				alert("저장되었습니다.")
			}
			//alert(JSON.stringify (rSave))
			if( !fnIsEmpty(rSave["caseNo"]) ){
				var arrCaseNo = rSave["caseNo"].split("-");
				if( arrCaseNo.length > 1 ){
					$("#searchForm").find("#searchCaseNo1").val(arrCaseNo[0]);
					$("#searchForm").find("#searchCaseNo2").val(arrCaseNo[1]);
					fnSearch( 2 );
				}
			} else if( !fnIsEmpty(rSave["rcNo"]) ){
				var arrRcNo = rSave["rcNo"].split("-");
				if( arrRcNo.length > 1 ) {
					$("#searchForm").find("#searchRcNo1").val(arrRcNo[0]);
					$("#searchForm").find("#searchRcNo2").val(arrRcNo[1]);
					fnSearch (2);
				}
			}
			fnReset ();
		}
	}
		
		
	//emailCheck 
    $.validator.addMethod("emailChk", function (value, element, param) {

    	if( "" == value ){
    		return true;
    	}
    	
    	var email = value;
        var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
            if(exptext.test(email)==false){
                //이메일 형식이 알파벳+숫자@알파벳+숫자.알파벳+숫자 형식이 아닐경우            
                return false;
            };
            return true;
		
    });
	
	// 날짜 비교
    $.validator.addMethod("dateChk", function (value, element, param) {
 
        var result = new Date($("#hidOccrrncBeginDt").val()) > new Date($("#hidOccrrncEndDt").val()) ? false : true;
 
        return result;
    });
    
    //사업자번호 유효성체크 
    $.validator.addMethod("bizIdChk", function (value, element, param) {
    	
    	var valueMap = value.replace(/-/gi, '').split('').map(function(item) {
    		return parseInt( item, 10 );
    	});

    	if( valueMap.length === 10 ){
    		var multiply = new Array(1, 3, 7, 1, 3, 7, 1, 3, 5);
    		var checkSum = 0;

    		for( var i = 0; i < multiply.length; ++i ) {
    			checkSum += multiply[i] * valueMap[i];
    		}

    		checkSum += parseInt((multiply[8] * valueMap[8]) / 10, 10);
    		
    		return Math.floor(valueMap[9]) === (10 - (checkSum % 10));
    	}

    	return false;
    });
    
    
    //여권번호 
    $.validator.addMethod("pasportNoChk", function (value, element, param) {
    	
    	if( 0 == value.length ){
    		return true;
    	} else if( 0 < value.length ){
	    	nA = new Array(9);
	        nA[1] = value.substring(0,1);
	        nA[2] = parseFloat(value.substring(1,2));
	        nA[3] = parseFloat(value.substring(2,3));
	        nA[4] = parseFloat(value.substring(3,4));
	        nA[5] = parseFloat(value.substring(4,5));
	        nA[6] = parseFloat(value.substring(5,6));
	        nA[7] = parseFloat(value.substring(6,7));
	        nA[8] = parseFloat(value.substring(7,8));
	        nA[9] = parseFloat(value.substring(8,9));
	        
	        if( value.length != 9 ){
	        	return false;
	        }
	        
	        if( nA[1] < 'A' || nA[1] > 'Z' ){
	        	//alert("첫번째 자리는 영문입니다. \n\n대문자로 입력하세요!");
	            return false;
	         }
	      
	         nSum = nA[2] * 1000000 + nA[3] * 1000000 + nA[4] * 100000 + nA[5] * 10000 + nA[6] * 1000 + nA[7] * 100 + nA[8] * 10 + nA[9];
	         
	         if( nSum < 0 || nSum > 9999999 ){
	             return false;
	         }
	         
	         return true;
    	}
    });
    
    //법인번호
    $.validator.addMethod("jurirnoChk", function (value, element, param) {
    	
    	if ( 0 == value.length ){
    		return true;
    	} else if (  0 < value.length ){
	    
	    	var re = /-/g;
	        sRegNo = value.replace('-','');
	
	        if (sRegNo.length != 13){
	         return false;
	        }
	
	        var arr_regno  = sRegNo.split("");
	        var arr_wt   = new Array(1,2,1,2,1,2,1,2,1,2,1,2);
	        var iSum_regno  = 0;
	        var iCheck_digit = 0;
	
	        for (i = 0; i < 12; i++){
	          iSum_regno +=  eval(arr_regno[i]) * eval(arr_wt[i]);
	        }
	
	        iCheck_digit = 10 - (iSum_regno % 10);
	
	        iCheck_digit = iCheck_digit % 10;
	
	        if (iCheck_digit != arr_regno[12]){
	          return false;
	        }
	        return true;
	    }
    });
    
    //달력 일시 정리 
    $.validator.addMethod("dateArrangement", function (value, element, param) {
    	
    	//접수 일시
    	var hh = $("#"+element.name+"Hh").val();
    	var mi = $("#"+element.name+"Mi").val();

    	if( "" != value){
	    	
	    	if( "" == hh){
	    		hh = "00";
	    	} else {
	    		hh = fnLpad( hh, 2 );
	    	}
	    	
	    	if( "" == mi){
	    		mi = "00";
	    	} else {
	    		mi = fnLpad( mi, 2 );
	    	}
	    	$("#"+element.name+"Hh").val(hh);
	    	$("#"+element.name+"Mi").val(mi);
	    	
	    	var dt = element.name.replace("txt","hid").replace("De","Dt");
	    	
	    	$("#"+dt).val( $("#"+element.name).val()+" "+hh+":"+mi );
	    	return true;
    	} else {
    		
    		if( hh.length > 0 || mi.length > 0){
    			return false;
    		} else {
    			return true;
    		}
    	}
    	
    });
    
    //주민번호 검증
    $.validator.addMethod("rrnChk", function (value, element, param) {
    	
    	rrn = $("#txtTrgterRrnFront").val()+"-"+$("#txtTrgterRrnEnd").val();
    	
    	if( rrn != null && rrn.replace("-","").length > 1 ){
    		
    		var str = /^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}$/;
    		if( !str.test(rrn) ) {
    			$("#hidTrgterRrn").val("");
    			return false;
    		}
    		
    		var sexdstnCd = $(":input:radio[name=rdoSexdstnCd]:checked").val();
    		var rrnEnd = $("#txtTrgterRrnEnd").val().substr(0,1);
    		
    		if( sexdstnCd == "M" ){
    			 if( "1" == rrnEnd || "3" == rrnEnd ){
    				 $("#hidTrgterRrn").val( rrn );
    				 return true;
    			 } else {
    				 $("#hidTrgterRrn").val("");
    				 return false;
    			 }
    		}
    		
    		if( sexdstnCd == "F" ){
    			if( "2" == rrnEnd || "4" == rrnEnd ){
    				 $("#hidTrgterRrn").val( rrn );
    				 return true;
   			 	} else {
   			 		$("#hidTrgterRrn").val("");
   			 		return false;
   			 	}
    		}
    	}

		return true;
    });

});	