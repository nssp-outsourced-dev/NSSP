package kr.go.nssp.finger.web;

public class FingerMatcher {
	static {
		try {
			/*
			 * System.out.println(">>>>> resourcePathresourcePath확인확인확인>>>>resourcePath>>>:::"); String
			 * resourcePath = FingerMatcher.class.getResource("/").getPath(); resourcePath =
			 * resourcePath.substring(0, resourcePath.lastIndexOf("classes"));
			 */
			//System.loadLibrary("FingerMatcher");			
			//System.load ("/usr/sbin/Face/libFingerMatcher.so");
			
			//OS 확인
			String os = System.getProperty("os.name").toLowerCase();
			System.out.println("os : " + os);
			if("win".equals(os)) {//윈도우 OS
				System.load ("C:\\DEV\\Finger\\libFingerMatcher.so");
			}else {//기타
				System.load ("/usr/lib64/libFingerMatcher.so");
			}
		} catch (UnsatisfiedLinkError e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	//jni 함수
	public native Object[] Verify (byte[]img1, int width1, int height1, byte[] img2, int width2, int height2);

	//log 확인
	public native void printMessage();

}
