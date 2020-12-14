package kr.go.nssp.face.web;

import java.lang.reflect.Field;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class FaceMatcher {
	static {
		System.out.println("Load");
		try{
			// 라이브러리 패스를 추가
			String libraryPath = "D:\\NSSP\\wrks\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp1\\wtpwebapps\\NSSP\\resources";
			addLibrarayPath(libraryPath);
		    System.loadLibrary("FaceMatcher_JNI");
		    //System.load("D:\\NSSP\\wrks\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp1\\wtpwebapps\\NSSP\\resources\\FaceMatcher_JNI.dll");
		}catch(Exception e) {
			e.printStackTrace();
		}
		System.out.println("Load OK!");
	}
	public FaceMatcher () {}
	public native Object[] verifyTmplBuffers(byte[] auth, byte[] test );
	public native Object[] verifyTmplFiles(String auth, String test );

	public native Object[] verifyImgBuffers(byte[] auth, byte[] test );
	public native Object[] verifyImgFiles(String auth, String test );

	//1:N 매칭용
	public native Object[] identifyImgBuffers(byte[] face1, byte[][] gallery );

	private static void addLibrarayPath(String libraryPath) throws Exception {

		if (libraryPath == null) {
			return;
		}
		if (libraryPath.equals("")) {
			return;
		}

		Field usrPathsField;
		// ClassLoader의 String[] usr_paths 필드를 구하고
		// usr_paths의 값은 시스템 속성 java.library.path의 값으로 초기에 한번만 설정된다.
		try {
			usrPathsField = getField(ClassLoader.class, "usr_paths");
		} catch (Exception e) {
			throw new Exception("library loading failed.", e);
		}

		if (usrPathsField == null) {
			throw new Exception("library loading failed. invalid attribute usr_paths");
		}

		// private으로 선언된 것을 접근 가능하게 바꿔주고.
		usrPathsField.setAccessible(true);

		String[] userPaths;
		try {
			// 실제 설정된 값을 구하고
			userPaths = (String[]) usrPathsField.get(null);
		} catch (IllegalArgumentException e) {
			throw new Exception("library loading failed.", e);
		} catch (IllegalAccessException e) {
			throw new Exception("library loading failed.", e);
		}

		// 만약 추가할 패스가 이미 있다면 더 할일이 없다. 나간다.
		for (int i = 0; i < userPaths.length; i++) {
			if (libraryPath.equalsIgnoreCase(userPaths[i])) {
				return;
			}
		}

		// 새로운 패스를 추가하고
		String[] newUserPaths = new String[userPaths.length + 1];
		for (int i = 0; i < userPaths.length; i++) {
			newUserPaths[i] = userPaths[i];
		}
		newUserPaths[newUserPaths.length - 1] = libraryPath;

		// 추가된 패스가 포함된 새로운 값을 설정한다.
		try {
			usrPathsField.set(null, newUserPaths);
		} catch (IllegalArgumentException e) {
			throw new Exception("library loading failed.", e);
		} catch (IllegalAccessException e) {
			throw new Exception("library loading failed.", e);
		}

	}

	public static Field getField(Class clazz, String fieldName) throws Exception {

		if (clazz == null) {
			return null;
		}
		if (fieldName == null) {
			return null;
		}

		Field field = null;

		Exception rootException = null;
		try {
			field = clazz.getDeclaredField(fieldName);
			return field;
		} catch (SecurityException e) {
			rootException = e;
		} catch (NoSuchFieldException e) {
			rootException = e;
		}

		Class superClass = clazz.getSuperclass();
		while (superClass != null) {
			try {
				field = superClass.getDeclaredField(fieldName);
				return field;
			} catch (SecurityException e) {
			} catch (NoSuchFieldException e) {
			}
			superClass = superClass.getSuperclass();
		}
		throw new Exception("getting field " + fieldName + " failed.", rootException);
	}

}

