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
			System.load ("/usr/lib64/libFingerMatcher.so");
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
