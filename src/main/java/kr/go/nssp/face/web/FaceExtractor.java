package kr.go.nssp.face.web;

public class FaceExtractor {
	 static {
		 System.load("C:\\FaceDLL\\FaceExtractor_JNI.dll");
	 }
	 
	   //콜백(dll에서 받아온 리스폰을 main으로 넘겨주기 위함)
	   public interface OnResultCB{
		   void onTakePicCB(int resCode);
	   }
	   static private OnResultCB picCallBack;
	   public void setOnResultCB(OnResultCB callback) {
		   picCallBack = callback;
	   }
	 
	 
	 public native Object[] Init();

	 public native void StatusDescription();

	 //사진과 템플릿 값이 getFaceData로 리턴된다.
	 public native void GetFaceResults();
	// public native void GetCreatedTemplate();
	 
	 //사진찍을 카메라 번호, 얼굴 확인 화면창의 x,y좌표
	 public native void TakePic(int nCamIdx, int nXpos, int nYpos);

	 public native int CancelCapture();
	 
	 public static native void ListenMessages();
	 
	   /**
	    * BioProcessor.dll메세지 계속 불러옴
	    * 
	    */
	 public void ListenMessagesWrapper() {
	       Thread t = new Thread(new Runnable() {
	           public void run() {
	               ListenMessages();
	           }
	       }); 
	       t.start();
	 }
	   
	    /**
	    * 얼굴인식관련 모든 결과
	    * @param str //결과 상세내용
	    * @param i //결과 코드
	    * 
	    * -500 라이선스 미인식
	    * -600 얼굴 인식 에러(각도, 밝기, 얼굴 가림 등)
	    * -700 기타 에러(파일 누락 등)
	    * 101 얼굴 검색 성공
	    * 102 취소
	    */
	   public static void getTakePicResult(String msg, int resCode){
		   System.out.println("*onTakePicFinished");
		   System.out.println("결과 상세 내용"+msg);
		   System.out.println("결과 코드"+resCode);
		   
		   picCallBack.onTakePicCB(resCode);
	   }
	   
	   //템플릿 점수, 템플릿 버퍼어레이, 이미지 버퍼어레이
	   public static void getFaceData(int score, byte[] tplbytes, byte[] imgbytes){
	
		   System.out.println("*CreatedTemplateFinished");
		   System.out.println(score);
		   System.out.println("-------------------------------");
	   }
	   
	   /**
	    * 템플릿/ 이미지 추출 실패 코드
	    * @param str //에러 상세내용
	    * @param i //에러 코드
	    * -800 인식된 얼굴 없음
	    * -900 템플릿 추출 실패
	    */
	   public static void getErrorMsg(String str, int i){
		   System.out.println("*onErrorMsg");
		   System.out.println(str);
		   System.out.println(i);
		   System.out.println("-------------------------------");
	    
	   }
	   
	  
}
