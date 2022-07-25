package kr.go.nssp.utl;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.net.UnknownHostException;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.MessageDigest;
import java.util.*;
import java.util.Base64.Decoder;
import java.util.Base64.Encoder;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.springframework.web.multipart.MultipartFile;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.go.nssp.utl.SimpleUtils;
import kr.go.nssp.utl.egov.EgovProperties;


@SuppressWarnings({ "rawtypes", "unchecked" })
public class Utility {

	private static Utility instance;
	private String RESOURCE_PATH = EgovProperties.getProperty("Globals.fileStorage");
	public static final String HWP_FILE_PATH = EgovProperties.getProperty("Globals.hwpFileStorage");

    //확장자 제한
	private ArrayList<String> imageFormatList = new ArrayList<String>();
	private ArrayList<String> videoFormatList = new ArrayList<String>();

	private static String SEED_CHARSET = "utf-8";
	private static String SEED_KEY_STR = EgovProperties.getProperty("Globals.seedKeyStr");
	private static String SEED_VECTOR_STR = EgovProperties.getProperty("Globals.seedVectorStr");

	public Utility(){
		imageFormatList.add("jpg");
		imageFormatList.add("jpeg");
		imageFormatList.add("bmp");
		imageFormatList.add("gif");
		imageFormatList.add("png");
		videoFormatList.add("avi");
		videoFormatList.add("mp4");
		videoFormatList.add("mkv");
		videoFormatList.add("mpeg");
		videoFormatList.add("wmv");
		videoFormatList.add("flv");
		videoFormatList.add("mov");
	}

	static {
		instance = new Utility();
	}

	public static Utility getInstance() {
		return instance;
	}

    public HashMap parseFileInfo(List<MultipartFile> files, String file_id, ArrayList<String> formatList, String esntl_id, String fileTitle) throws Exception {
    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("esntl_id", esntl_id);
	    List fileList = new ArrayList();
		int i = 1;
		if (!files.isEmpty()) {
			String filePath = RESOURCE_PATH + file_id + File.separator;
	        File pathCheck = new File(filePath);
	        if(!pathCheck.exists() || !pathCheck.isDirectory())
	            pathCheck.mkdirs();
			for (MultipartFile mFile : files) {
				if (mFile.isEmpty()) continue;

				String fOrgName = mFile.getOriginalFilename();
				String fFormat = "";
				if(fOrgName.length() > 0){
					fFormat = fOrgName.substring(fOrgName.lastIndexOf(".")+1).toLowerCase();
				}

				//format validation
				if(fFormat != null && formatList.contains(fFormat)) {
					HashMap fMap = new HashMap();
					fMap.put("file_id", file_id);
					String fileName = file_id + "_" + i + "." + fFormat;
			        String fileTitleName = fileTitle + "_" + i + "." + fFormat;
			        File fileCheck = new File(filePath + fileName);
			        while(fileCheck.exists() && fileCheck.isFile()){
			            i++;
			            fileName = file_id + "_" + i + "." + fFormat;
				        fileTitleName = fileTitle + "_" + i + "." + fFormat;
			            fileCheck = new File(filePath + fileName);
			        }

					long fSize = fileSave(mFile, filePath + fileName);

					fMap.put("file_dc", fileTitleName);
					fMap.put("file_nm", fOrgName);
					fMap.put("file_size", fSize);
					fMap.put("sys_file_path", filePath + fileName);
					fMap.put("sys_file_nm", fileName);
					fMap.put("esntl_id", esntl_id);
					fMap.put("hash_at", "N");

					fileList.add(fMap);
					i++;
				}
			}
		}
		map.put("fileList", fileList);
		map.put("fileCount", fileList.size());
		return map;
    }

    public HashMap parseVideoFileInfo(List<MultipartFile> files, String file_id, ArrayList<String> formatList, String esntl_id, String fileTitle) throws Exception {


    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("esntl_id", esntl_id);
	    List fileList = new ArrayList();
		int i = 1;
		if (!files.isEmpty()) {
			String filePath = RESOURCE_PATH + file_id + File.separator;
	        File pathCheck = new File(filePath);
	        if(!pathCheck.exists() || !pathCheck.isDirectory())
	            pathCheck.mkdirs();
			for (MultipartFile mFile : files) {
				if (mFile.isEmpty()) continue;

				String fOrgName = mFile.getOriginalFilename();
				String fFormat = "";
				if(fOrgName.length() > 0){
					fFormat = fOrgName.substring(fOrgName.lastIndexOf(".")+1).toLowerCase();
				}

				//format validation
				if(fFormat != null && formatList.contains(fFormat)) {
					HashMap fMap = new HashMap();
					fMap.put("file_id", file_id);
					String fileName = file_id + "_" + i + "." + fFormat;
			        String fileTitleName = fileTitle + "_" + i + "." + fFormat;
			        File fileCheck = new File(filePath + fileName);
			        while(fileCheck.exists() && fileCheck.isFile()){
			            i++;
			            fileName = file_id + "_" + i + "." + fFormat;
				        fileTitleName = fileTitle + "_" + i + "." + fFormat;
			            fileCheck = new File(filePath + fileName);
			        }

					long fSize = fileSave(mFile, filePath + fileName);

					fMap.put("file_dc", fileTitleName);
					fMap.put("file_nm", fOrgName);
					fMap.put("file_size", fSize);
					fMap.put("sys_file_path", filePath + fileName);
					fMap.put("sys_file_nm", fileName);
					fMap.put("esntl_id", esntl_id);

					//동영상 해시추출
					if(imageFormatList.contains(fFormat)) {
						fMap.put("file_ty", "I");
					}else if(videoFormatList.contains(fFormat)) {
						fMap.put("file_ty", "V");
					}else{
						fMap.put("file_ty", "");
					}
					HashMap<String, String> hMap = getFileHash(filePath + fileName);
					fMap.putAll(hMap);

					fileList.add(fMap);
					i++;
				}
			}
		}
		map.put("fileList", fileList);
		map.put("fileCount", fileList.size());
		return map;
    }



    public long fileSave(MultipartFile file, String filePath) throws Exception {
    	File f = new File(filePath);

		if(!f.getParentFile().exists())
			f.getParentFile().mkdirs();

		OutputStream os = null;
		InputStream is = null;
		final int BUFFER_SIZE = 8192;
		long size = 0;

		try {
			os = new FileOutputStream(f);

			int bytesRead = 0;
			byte[] buffer = new byte[BUFFER_SIZE];
			is = file.getInputStream();

			while ((bytesRead = is.read(buffer, 0, BUFFER_SIZE)) != -1) {
				size += bytesRead;
				os.write(buffer, 0, bytesRead);
			}
		} catch (IOException e) {
			System.out.println("Error(file write) : Utility.fileSave(" + filePath + ")");
		} finally {
			if (is != null)
				is.close();
			if (os != null)
				os.close();
		}
		return size;
    }

	public void fileCopy(String inFileName, String outFileName) throws Exception {
    	File f = new File(outFileName);

		if(!f.getParentFile().exists())
			f.getParentFile().mkdirs();

		try {
			FileInputStream fis = new FileInputStream(inFileName);
			FileOutputStream fos = new FileOutputStream(outFileName);

			int data = 0;
			while((data=fis.read())!=-1) {
				fos.write(data);
			}
			fis.close();
			fos.close();

		} catch (IOException e) {
			System.out.println("Error(file write) : Utility.fileCopy(" + outFileName + ")");
		}
	}

    public void fileCheckMake(String filePath, String fileName) {
		String fileStr = "";
		if(fileName.length() > 0){
			fileStr = fileName.substring(0, fileName.lastIndexOf("."));
		}

        File f1 = new File(filePath + fileStr + ".check");
        try {
            f1.createNewFile();
        } catch (IOException e) {
        	fileStr = "";
        }
    }

	public boolean nioFileCopy(String inFileName, String outFileName) {
    	File f = new File(outFileName);
		if(!f.getParentFile().exists())
			f.getParentFile().mkdirs();

		Path source = Paths.get(inFileName);
		Path target = Paths.get(outFileName);

		if (source == null) {
			throw new IllegalArgumentException("source must be specified");
		}
		if (target == null) {
			throw new IllegalArgumentException("target must be specified");
		}

		if (!Files.exists(source, new LinkOption[] {})) {
			throw new IllegalArgumentException("Source file doesn't exist: " + source.toString());
		}

		try {
			Files.copy(source, target, StandardCopyOption.REPLACE_EXISTING);    // 파일 이동

		} catch (IOException e) {
			// TODO Auto-generated catch block
			return false;
		}

		if(Files.exists(target, new LinkOption[]{})){
			// System.out.println("File Moved");
			return true;
		} else {
			System.out.println("File Copy Failed");
		    return false;
		}
	}

	public boolean nioFileMove(String inFileName, String outFileName) {
    	File f = new File(outFileName);
		if(!f.getParentFile().exists())
			f.getParentFile().mkdirs();

		Path source = Paths.get(inFileName);
		Path target = Paths.get(outFileName);

		if (source == null) {
			throw new IllegalArgumentException("source must be specified");
		}
		if (target == null) {
			throw new IllegalArgumentException("target must be specified");
		}

		if (!Files.exists(source, new LinkOption[] {})) {
			throw new IllegalArgumentException("Source file doesn't exist: " + source.toString());
		}

		try {
			Files.move(source, target, StandardCopyOption.REPLACE_EXISTING);    // 파일 이동

		} catch (IOException e) {
			// TODO Auto-generated catch block
			return false;
		}

		if(Files.exists(target, new LinkOption[]{})){
			// System.out.println("File Moved");
			return true;
		} else {
			System.out.println("File Move Failed");
		    return false;
		}
	}

    public HashMap<String, String> getFileHash(String filePath) throws Exception {
        HashMap<String, String> map = new HashMap();
        map.put("hash_at", "N");
        int buff = 16384;
        try {
            RandomAccessFile file = new RandomAccessFile(filePath, "r");

            MessageDigest hashSum_md5 = MessageDigest.getInstance("MD5");
            MessageDigest hashSum_sha256 = MessageDigest.getInstance("SHA-256");
            MessageDigest hashSum_sha1 = MessageDigest.getInstance("SHA1");

            MessageDigest hashSum_md5_prttn = MessageDigest.getInstance("MD5");
            MessageDigest hashSum_sha256_prttn = MessageDigest.getInstance("SHA-256");
            MessageDigest hashSum_sha1_prttn = MessageDigest.getInstance("SHA1");

            byte[] buffer = new byte[buff];

            long read = 0;

            long offset = file.length();
            long offset_prttn = 1024*1024;

            int unitsize;
            while (read < offset) {
                unitsize = (int) (((offset - read) >= buff) ? buff : (offset - read));
                file.read(buffer, 0, unitsize);

                if(read < offset_prttn) {
                	hashSum_md5_prttn.update(buffer, 0, unitsize);
                	hashSum_sha256_prttn.update(buffer, 0, unitsize);
                	hashSum_sha1_prttn.update(buffer, 0, unitsize);
                }

                hashSum_md5.update(buffer, 0, unitsize);
                hashSum_sha256.update(buffer, 0, unitsize);
                hashSum_sha1.update(buffer, 0, unitsize);

                read += unitsize;
            }

            file.close();

            map.put("md5_hash", getPartialHash(hashSum_md5));
            map.put("sha256_hash", getPartialHash(hashSum_sha256));
            map.put("sha1_hash", getPartialHash(hashSum_sha1));

            map.put("md5_prttn_hash", getPartialHash(hashSum_md5_prttn));
            map.put("sha256_prttn_hash", getPartialHash(hashSum_sha256_prttn));
            map.put("sha1_prttn_hash", getPartialHash(hashSum_sha1_prttn));

            map.put("hash_at", "Y");

        } catch (FileNotFoundException e) {
            map.put("hash_at", "N");
        }

        return map;
    }

    public String getPartialHash(MessageDigest hashSum){
        byte[] partialHash = new byte[hashSum.getDigestLength()];
        partialHash = hashSum.digest();
        StringBuffer sb = new StringBuffer();
        for(int i = 0 ; i < partialHash.length ; i++){
            sb.append(Integer.toString((partialHash[i]&0xff) + 0x100, 16).substring(1));
        }
    	return sb.toString();
    }


	public String getTraceIP(String s) {
		InetAddress thisComputer;
		byte[] address;
		String ip = "";

		try {
			thisComputer = InetAddress.getByName(s);
			address = thisComputer.getAddress();

			if (isHostname(s)) {
				// Print the IP address
				for (int i = 0; i < address.length; i++) {
					int unsignedByte = address[i] < 0 ? address[i] + 256 : address[i];
					ip += unsignedByte + ".";
				}
				ip = ip.substring(0, ip.length()-1);
			} else { // this is an IP address
				ip = s;
			}
		} catch (Exception e) {
			//e.printStackTrace();
			ip = "";
		}
		return ip;
	}

	public boolean isHostname(String s) {
		char[] ca = s.toCharArray();
		for (int i = 0; i < ca.length; i++) {
			if (!Character.isDigit(ca[i])) {
				if (ca[i] != '.') {
					return true;
				}
			}
		}
		return false;
	}

	public List<String> getTraceURL(String strUrl){
		List<String> arrUrl = new ArrayList<String>();
		arrUrl.add(strUrl);
	    while(true){
		    HttpURLConnection connection = null;
		    try {
				URL url = new URL(strUrl);
		        connection = (HttpURLConnection) url.openConnection();
		        connection.setInstanceFollowRedirects(false);
		        connection.connect();
		        int responseCode = connection.getResponseCode();

		        if (responseCode == HttpURLConnection.HTTP_SEE_OTHER
		                || responseCode == HttpURLConnection.HTTP_MOVED_PERM
		                || responseCode == HttpURLConnection.HTTP_MOVED_TEMP) {
		            String locationUrl = connection.getHeaderField("Location");

		            if (locationUrl != null && locationUrl.trim().length() > 0) {
		                IOUtils.close(connection);
			            if (locationUrl.startsWith("/")) {
			            	locationUrl = url.getProtocol() + "://" + url.getHost() +":"+ url.getPort() + locationUrl;
			            }
		            }
		            strUrl = locationUrl;
		            arrUrl.add(locationUrl);
	            }else{
	            	break;
	            }
		    } catch (Exception e) {
				System.out.println("Error(Connection) : Utility.getTraceURL(" + strUrl + ")");
            	break;
		    } finally {
		        IOUtils.close(connection);
		    }
	    }
	    return arrUrl;
	}

	public String getFinalURL(String strUrl){
	    HttpURLConnection connection = null;
	    try {
			URL url = new URL(strUrl);
	        connection = (HttpURLConnection) url.openConnection();
	        connection.setInstanceFollowRedirects(false);
	        connection.connect();
	        int responseCode = connection.getResponseCode();

	        if (responseCode == HttpURLConnection.HTTP_SEE_OTHER
	                || responseCode == HttpURLConnection.HTTP_MOVED_PERM
	                || responseCode == HttpURLConnection.HTTP_MOVED_TEMP) {
	            String locationUrl = connection.getHeaderField("Location");

	            if (locationUrl != null && locationUrl.trim().length() > 0) {
	                IOUtils.close(connection);
		            if (locationUrl.startsWith("/")) {
		            	locationUrl = url.getProtocol() + "://" + url.getHost() +":"+ url.getPort() + locationUrl;
		            }
	                strUrl = getFinalURL(locationUrl);
	            }
	        }
	    } catch (Exception e) {
			System.out.println("Error(Connection) : Utility.getFinalURL(" + strUrl + ")");
	    } finally {
	        IOUtils.close(connection);
	    }
	    return strUrl;
	}


	public HashMap getXMLValue(String xml_url, String[] tagList) {

		HashMap result = new HashMap();
		for(String tag:tagList) {
			result.put(tag, "");
		}

		try {
			HttpClient httpClient = new DefaultHttpClient();
			HttpGet httpGet = new HttpGet(xml_url);
			HttpResponse response = httpClient.execute(httpGet);
			int code = response.getStatusLine().getStatusCode();
			if(code == 200) {
				HttpEntity entity = response.getEntity();

		        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		        factory.setValidating(false);
		        factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);

		        DocumentBuilder builder = factory.newDocumentBuilder();
		        Document doc = builder.parse(entity.getContent());

				doc.getDocumentElement().normalize();
			    NodeList nl = doc.getElementsByTagName("whois");
				for (int i = 0; i < nl.getLength(); ++i) {
				    Node nNode = nl.item(i);
					if (nNode.getNodeType() == Node.ELEMENT_NODE) {
						Element eElement = (Element) nNode;
						for(String tag:tagList) {
							String temp = getTagValue(tag, eElement);
							if(temp != null && !temp.isEmpty()){
								result.put(tag, temp);
							}
						}
					}
				}
	            result.put("result", "0");
			}else{
	            result.put("result", "-1");
				System.out.println("Error(Connection) : Recieved invalid status code(" + code + ")");
			}
		} catch (Exception e) {
			//커넥션 오류
			System.out.println("Error(Connection) : Utility.getXMLValue(" + xml_url + ")");
            result.put("result", "-1");
		}
		return result;
	}

	public String getTagValue(String sTag, Element eElement) {
		String value = "";
		try{
			NodeList nlList = eElement.getElementsByTagName(sTag).item(0).getChildNodes();
			Node nValue = (Node) nlList.item(0);
			value = nValue.getNodeValue();
		} catch (Exception e) {
			value = "";
		}
		return value;
	}

	public String[] removeDuplicateValue(String[] arrList) {
		if(arrList == null){
			return null;
		}else{
			//duplicate remove
	        TreeSet ts = new TreeSet();
	        for(int i=0;i < arrList.length;i++){
	        	ts.add( arrList[i] );
	        }

			String newArrList[] = new String[ts.size()];
			int cnt = 0;
	        Iterator it = ts.iterator();
			while(it.hasNext()){
				newArrList[cnt++] = (String)it.next();
			}
			return newArrList;
		}
	}

    public String getMainDomain(String str){
		StringBuilder sb = new StringBuilder();
		String regex = "[a-z]+\\.([a-z]|(co|or|go|pe|ac|ne|re)\\.kr)+$";
		Pattern pattern  =  Pattern.compile(regex,Pattern.MULTILINE|Pattern.CASE_INSENSITIVE);
		Matcher match = pattern.matcher(str);

		String strMatch = null;

		while(match.find()){
			strMatch = match.group();
			sb.append(strMatch);
		}
		return sb.toString();
    }



    /**
     * Map을 json으로 변환한다.
     *
     * @param map Map<String, Object>.
     * @return JSONObject.
     */
    public static JSONObject getJsonStringFromMap( Map<String, Object> map )
    {
        JSONObject jsonObject = new JSONObject();
        for( Map.Entry<String, Object> entry : map.entrySet() ) {
            String key = entry.getKey();
            Object value = entry.getValue();
            jsonObject.put(key, value);
        }

        return jsonObject;
    }

    /**
     * List<Map>을 jsonArray로 변환한다.
     *
     * @param list List<Map<String, Object>>.
     * @return JSONArray.
     */
    public static JSONArray getJsonArrayFromList( List<Map<String, Object>> list )
    {
        JSONArray jsonArray = new JSONArray();
        for( Map<String, Object> map : list ) {
            jsonArray.add( getJsonStringFromMap( map ) );
        }

        return jsonArray;
    }

    public static JSONArray getJsonArrayFromList2( List<HashMap> list )
    {
        JSONArray jsonArray = new JSONArray();
        for( HashMap map : list ) {
            jsonArray.add( getJsonStringFromMap( map ) );
        }

        return jsonArray;
    }

    /**
     * List<Map>을 jsonString으로 변환한다.
     *
     * @param list List<Map<String, Object>>.
     * @return String.
     */
    public static String getJsonStringFromList( List<Map<String, Object>> list )
    {
        JSONArray jsonArray = getJsonArrayFromList( list );
        return jsonArray.toJSONString();
    }

    /**
     * JsonObject를 Map<String, String>으로 변환한다.
     *
     * @param jsonObj JSONObject.
     * @return Map<String, Object>.
     */
    @SuppressWarnings("unchecked")
    public static Map<String, Object> getMapFromJsonObject( JSONObject jsonObj )
    {
        Map<String, Object> map = null;

        try {

            map = new ObjectMapper().readValue(jsonObj.toJSONString(), Map.class) ;

        } catch (JsonParseException e) {
        	map = null;
        } catch (JsonMappingException e) {
        	map = null;
        } catch (IOException e) {
        	map = null;
        }

        return map;
    }

    /**
     * JsonArray를 List<Map<String, String>>으로 변환한다.
     *
     * @param jsonArray JSONArray.
     * @return List<Map<String, Object>>.
     */
    public static List<Map<String, Object>> getListMapFromJsonArray( JSONArray jsonArray )
    {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

        if( jsonArray != null )
        {
            int jsonSize = jsonArray.size();
            for( int i = 0; i < jsonSize; i++ )
            {
                Map<String, Object> map = getMapFromJsonObject( ( JSONObject ) jsonArray.get(i) );
                list.add( map );
            }
        }

        return list;
    }




    /**
     *
     * <pre>
     * getSeedEncrypt
     * </pre>
     *
     * @desc : getSeedEncrypt
     * @param str
     * @return
     */
    public static String getSeedEncrypt(String str) {
        byte[] enc = null;
        String result = "";
        try {
            enc = KISA_SEED_CBC.SEED_CBC_Encrypt(SEED_KEY_STR.getBytes(SEED_CHARSET), SEED_VECTOR_STR.getBytes(SEED_CHARSET), str.getBytes(SEED_CHARSET), 0, str.getBytes(SEED_CHARSET).length);
        } catch (UnsupportedEncodingException e) {
        	result = "";
        }

        Encoder encoder = Base64.getEncoder();
        byte[] encArray = encoder.encode(enc);
        try {
        	result = new String(encArray, SEED_CHARSET);
        } catch (UnsupportedEncodingException e) {
        	result = "";
        }
        return result;
    }

    /**
     *
     * <pre>
     * getSeedDecrypt
     * </pre>
     *
     * @desc : getSeedDecrypt
     * @param str
     * @return
     */
    public static String getSeedDecrypt(String str) {
        Decoder decoder = Base64.getDecoder();
        byte[] enc = decoder.decode(str);

        String result = "";
        byte[] dec = null;

        try {
            //복호화 함수 호출
            dec = KISA_SEED_CBC.SEED_CBC_Decrypt(SEED_KEY_STR.getBytes(SEED_CHARSET), SEED_VECTOR_STR.getBytes(SEED_CHARSET), enc, 0, enc.length);
            result = new String(dec, SEED_CHARSET);
        } catch (UnsupportedEncodingException e) {
        	result = "";
        }

        return result;
    }

	public static String nvl(String str) {
		if (str == null || str.toString().length() == 0 || str.toString().equals(" ") || str.toString().equals("null")) {
			return "";
		}
		return str;
	}

	public static String nvl(String srcstr, String retstr) {
		if (srcstr == null || srcstr.toString().length() == 0 || srcstr.toString().equals(" ")) {
			return retstr;
		}
		return srcstr;
	}

	public static String nvl(Object obj) {
		if (obj == null || obj.toString().length() == 0 || obj.toString().equals(" ") || obj.toString().equals("null")) {
			return "";
		}
		return obj.toString();
	}

	public static String nvl(Object obj, String str) {
		if (obj == null || obj.toString().length() == 0 || obj.toString().equals(" ")) {
			return str;
		}
		return obj.toString();
	}


    /**
     * <pre>
     * getSha256Encrypt
     * </pre>
     *
     * @desc : getSha256Encrypt
     * @param str
     * @return
     */
    public static String getSha256Encrypt(String str) {
    	String result = "";
        try{
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(str.getBytes("UTF-8"));
            StringBuffer hexString = new StringBuffer();

            for (int i = 0; i < hash.length; i++) {
                String hex = Integer.toHexString(0xff & hash[i]);
                if(hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
        	result = hexString.toString();
        } catch(Exception ex){
        	result = "";
        }
        return result;
    }

    public static byte[] fileToByte(String filePath) {
    	File file2 = new File(filePath);
        byte[] data2 = new byte[(int) file2.length()];
        DataInputStream stream2;
		try {
			stream2 = new DataInputStream(new FileInputStream(file2));
	        stream2.readFully(data2);
	        stream2.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return data2;
    }
    
    public static Map<String, Object> getGridSortList(String sortingFields) {
    	Map<String, Object> sortField = null;
    	JSONParser parser = new JSONParser();
    	Object obj;
		try {
			obj = parser.parse( sortingFields );
			JSONArray jsonArray = (JSONArray) obj;			
			List<Map<String, Object>> lst = getListMapFromJsonArray (jsonArray);
			if(lst != null && lst.size() > 0) {
				sortField = lst.get(0);
								
				String[] flst = {"DELETE", "SELECT", "DROP", "CREATE", "UPDATE", ";"};				
				String dataField = nvl(sortField.get("dataField"));
				
				if(dataField.startsWith("grd")) {
					String con_name = InvUtil.getInstance().convert (dataField);
					dataField = con_name.substring(con_name.indexOf('_')+1);
					
					System.out.println("dataField >>>>>> "+dataField);
				}
				
				for(String s : flst) {
					if(dataField.toUpperCase().contains(s))  dataField = "";
				}								
				if(!dataField.equals("") && !Pattern.compile("^(([A-Za-z0-9])+[_]?)+$").matcher(dataField).matches()) dataField = "";	
								
				String sortType = nvl(sortField.get("sortType"));
				if(sortType.equals("-1")) sortType = "DESC";	//NULLS LAST
				else if(sortType.equals("1")) sortType = "ASC";	//NULLS FIRST
				else sortType = "";
				
				//System.out.println("sortType >>>>> "+sortType);
				//System.out.println("dataField >>>>> "+dataField);
				
				sortField.put("sortType", sortType);
				sortField.put("dataField", dataField);				
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	return sortField;  	    	
    }

}