package kr.go.nssp.cmmn.web;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import kr.co.siione.dist.ffmpeg.StreamView;
import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.FileService;
import kr.go.nssp.stats.service.StatsService;

@Controller
@RequestMapping(value = "/file/")
public class FileController {
    private String NO_IMAGE_NAME = "no_img.gif";
    private String NO_IMAGE_PATH = "/images/" + NO_IMAGE_NAME;

	@Resource
	private FileService fileService;

    @RequestMapping(value="/imageListPopup/")
    public String imageList(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

    	String file_id = SimpleUtils.default_set(request.getParameter("file_id"));

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	List<HashMap> result = fileService.getFileList(map);

        model.addAttribute("result", result);
        return "file/imageList";
    }

    @RequestMapping(value="/fileListIframe/")
    public String fileListIframe(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
    	String ifr_id = SimpleUtils.default_set(request.getParameter("ifr_id"));

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);

    	List<HashMap> result = fileService.getFileList(map);

        model.addAttribute("ifr_id", ifr_id);
        model.addAttribute("owner", "N");
        model.addAttribute("result", result);
        return "file/fileList";
    }

    @RequestMapping(value="/fileListOwnerIframe/")
    public String fileListOwnerIframe(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
    	String ifr_id = SimpleUtils.default_set(request.getParameter("ifr_id"));

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);

    	//본인여부
    	HashMap rMap = fileService.getFileManage(map);
    	if(rMap != null){
        	String writng_id = rMap.get("WRITNG_ID").toString();
        	if(esntl_id.equals(writng_id)){
                model.addAttribute("owner", "Y");
        	}
    	}

    	List<HashMap> result = fileService.getFileList(map);

        model.addAttribute("ifr_id", ifr_id);
        model.addAttribute("result", result);
        return "file/fileList";
    }


    @RequestMapping(value="/fileDetailPopup/")
    public String fileDetailPopup(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        HttpSession session = request.getSession();
    	String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
    	String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
    	String file_sn = SimpleUtils.default_set(request.getParameter("file_sn"));

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("file_sn", file_sn);
    	HashMap result = fileService.getFileDetail(map);

        model.addAttribute("result", result);
        return "file/fileDetailPopup";
    }


	@RequestMapping("/deleteAjax/")
    public ModelAndView deleteAjax(HttpServletRequest request) throws Exception {
    	String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
    	String file_sn = SimpleUtils.default_set(request.getParameter("file_sn"));
        String result = "1";

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("file_sn", file_sn);
    	HashMap rMap = fileService.getFileDetail(map);
    	if(rMap != null){
    		String sys_file_path = (String) rMap.get("SYS_FILE_PATH");
	        File fileCheck = new File(sys_file_path);
			if(fileCheck.exists() ){
				if(fileCheck.delete()){
					//삭제성공
				}else{
					//삭제실패
				}
			}else{
				//파일없음
			}
        	map.put("use_at", "N");
        	fileService.updateFileDetail(map);
    	}else{
        	result = "-1";
    	}

    	HashMap ret = new HashMap();
    	ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
    }

    @RequestMapping(value="/getFileBinary/")
    public void getFileBinary(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_sn = SimpleUtils.default_set(request.getParameter("file_sn"));

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
        map.put("file_sn", file_sn);
    	HashMap result = fileService.getFileDetail(map);

		if(result == null){
            response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('파일정보를 찾을 수 없습니다.');");
			writer.println("history.back();");
			writer.println("</script>");
			writer.flush();
		}else{
			String realPath = SimpleUtils.default_set((String) result.get("SYS_FILE_PATH"));
			//String fileName = SimpleUtils.default_set((String) result.get("FILE_DC"));  ??? 왜?? 2019-07-01
			String fileName = SimpleUtils.default_set((String) result.get("FILE_NM"));

			try{

	    		File uFile = new File(realPath);

	    		boolean fileCheck = true;
	    		if (!uFile.exists())
					fileCheck = false;

	    		if (!uFile.isFile())
					fileCheck = false;

	    		if(fileCheck){

	    			String browser = request.getHeader("User-Agent");
	    			if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")){
	    				fileName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20");
	    			} else {
	    				fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
	    			}

	    			response.setContentType("application/octer-stream");
	    			response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName +"\"");
	    			response.setHeader("Content-Transfer-Encoding", "binary;");

		    		byte b[] = new byte[(int)uFile.length()];

	    			BufferedInputStream in = null;
					BufferedOutputStream out = null;
					// 응답객체생성
					int read = 0;

					in = new BufferedInputStream(new FileInputStream(uFile));
					out = new BufferedOutputStream(response.getOutputStream());

					while ((read = in.read(b)) != -1)
						out.write(b,0,read);

					if(out!=null)
						out.close();
					if(in!=null)
						in.close();
	    		}else{
	                response.setContentType("text/html; charset=UTF-8");
	    			PrintWriter writer = response.getWriter();
					writer.println("<script type='text/javascript'>");
					writer.println("alert('해당 파일이 존재하지 않습니다.');");
					writer.println("history.back();");
					writer.println("</script>");
					writer.flush();
	    			writer.close();
	    		}

			}catch(Exception e){
				System.out.println("download error : " + e.getMessage());

                response.setContentType("text/html; charset=UTF-8");
    			PrintWriter writer = response.getWriter();
				writer.println("<script type='text/javascript'>");
				writer.println("alert('다운로드중 오류가 발생했습니다.');");
				writer.println("history.back();");
				writer.println("</script>");
				writer.flush();
    			writer.close();
    		}
		}
	   	System.out.println("GetFile End");
    }
    
    @RequestMapping(value="/getBioFileBinary/")
    public ModelAndView getBioFileBinary(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String esntl_id = SimpleUtils.default_set(request.getParameter("esntl_id"));
        String file_ty = SimpleUtils.default_set(request.getParameter("file_ty"));
        
        int rtn = 0;
        String image = "";
        
        HashMap map = new HashMap();
    	map.put("esntl_id", esntl_id);
        map.put("file_ty", file_ty);
    	HashMap result = fileService.getBioFileDetail(map);
    	
    	if(result == null){
            response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('파일정보를 찾을 수 없습니다.');");
			writer.println("history.back();");
			writer.println("</script>");
			writer.flush();
		}else {
	    	try {
	    		File file = new File(esntl_id + ".txt");
		    	
		    	if(file.exists() && file.canRead()) {
		    		//파일 내용 읽기
					//파일 내용담을 리스트
					List<String> list = new ArrayList<String>();
					try{
						list = Files.readAllLines(file.toPath(), StandardCharsets.UTF_8);
					}catch(IOException e){
						e.printStackTrace();
					}
					
					for(String readLine : list){
						image += readLine;
					}
					
					rtn = 1;
		    	}else {
		    		response.setContentType("text/html; charset=UTF-8");
					PrintWriter writer = response.getWriter();
					writer.println("<script type='text/javascript'>");
					writer.println("alert('해당 파일이 존재하지 않습니다.');");
					writer.println("history.back();");
					writer.println("</script>");
					writer.flush();
					writer.close();
		    	}
	    	}catch (Exception e) {
	    		System.out.println("download error : " + e.getMessage());

                response.setContentType("text/html; charset=UTF-8");
    			PrintWriter writer = response.getWriter();
				writer.println("<script type='text/javascript'>");
				writer.println("alert('다운로드중 오류가 발생했습니다.');");
				writer.println("history.back();");
				writer.println("</script>");
				writer.flush();
    			writer.close();
			}
		}
    	
    	HashMap cMap = new HashMap();
		cMap.put("result", rtn);
		cMap.put("image", image);
		
		System.out.println("GetFile End");
		
		return new ModelAndView("ajaxView", "ajaxData", cMap);
    }
    
    /* @RequestMapping(value="/getBioFileBinary/")
    public void getBioFileBinary(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String esntl_id = SimpleUtils.default_set(request.getParameter("esntl_id"));
        String file_ty = SimpleUtils.default_set(request.getParameter("file_ty"));

    	HashMap map = new HashMap();
    	map.put("esntl_id", esntl_id);
        map.put("file_ty", file_ty);
    	HashMap result = fileService.getBioFileDetail(map);

		if(result == null){
            response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = response.getWriter();
			writer.println("<script type='text/javascript'>");
			writer.println("alert('파일정보를 찾을 수 없습니다.');");
			writer.println("history.back();");
			writer.println("</script>");
			writer.flush();
		}else{
			BufferedInputStream in = null;
			BufferedOutputStream out = null;			
			try{
				Blob bfileInfo = (Blob) result.get("FILE_INFO");
				String fileName = SimpleUtils.default_set((String) result.get("ESNTL_ID"));	
				
	    		boolean fileCheck = true;

	    		if (bfileInfo == null || bfileInfo.length() < 10)
					fileCheck = false;

	    		if(fileCheck) {

	    			String browser = request.getHeader("User-Agent");
	    			if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")){
	    				fileName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20");
	    			} else {
	    				fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
	    			}
	    			
	    			fileName += ".jpg";

	    			response.setContentType("application/octer-stream");
	    			response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName +"\"");
	    			response.setHeader("Content-Transfer-Encoding", "binary;");

	    			int blength = (int) bfileInfo.length();
		    		byte b[] = new byte[blength];
	    			
					// 응답객체생성
					int read = 0;

					in = new BufferedInputStream(bfileInfo.getBinaryStream());
					out = new BufferedOutputStream(response.getOutputStream());

					while ((read = in.read(b)) != -1) out.write(b,0,read);
	    		}else{
	                response.setContentType("text/html; charset=UTF-8");
	    			PrintWriter writer = response.getWriter();
					writer.println("<script type='text/javascript'>");
					writer.println("alert('해당 파일이 존재하지 않습니다.');");
					writer.println("history.back();");
					writer.println("</script>");
					writer.flush();
	    			writer.close();
	    		}

			}catch(Exception e){
				System.out.println("download error : " + e.getMessage());

                response.setContentType("text/html; charset=UTF-8");
    			PrintWriter writer = response.getWriter();
				writer.println("<script type='text/javascript'>");
				writer.println("alert('다운로드중 오류가 발생했습니다.');");
				writer.println("history.back();");
				writer.println("</script>");
				writer.flush();
    			writer.close();
    		} finally {
    			if(out!=null) out.close();
				if(in!=null)in.close();
			}
		}
	   	System.out.println("GetFile End");
    }
	
    @RequestMapping(value="/getFileBinary/")
    public ResponseEntity<byte[]> getFileBinary(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ResponseEntity entity = null;
        HttpHeaders responseHeaders = new HttpHeaders();
        entity = new ResponseEntity(HttpStatus.BAD_REQUEST);

        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_sn = SimpleUtils.default_set(request.getParameter("file_sn"));

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
        map.put("file_sn", file_sn);
    	HashMap result = fileService.getFileDetail(map);

    	String realPath = "";
    	String fileName = "";
    	if(result != null){
        	realPath = SimpleUtils.default_set((String) result.get("SYS_FILE_PATH"));
        	fileName = SimpleUtils.default_set((String) result.get("FILE_NM"));
    	}

        FileInputStream fileStream = null;

        try {
            File getResource = new File(realPath);
            if(getResource.exists()){
                byte byteStream[] = new byte[(int)getResource.length()];
                fileStream = new FileInputStream(getResource);
                int i = 0;
                for(int j = 0; (i = fileStream.read()) != -1; j++)
                    byteStream[j] = (byte)i;

                responseHeaders.setContentType(new MediaType("application", "octet-stream"));
                responseHeaders.set("Content-Disposition", "attatchment; filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO-8859-1") +"\"");
                entity = new ResponseEntity(byteStream, responseHeaders, HttpStatus.OK);
            }
    	} catch(Exception e) {
    		e.printStackTrace();
            fileStream.close();
        } finally {
            fileStream.close();
    	}
        return entity;
    }
	*/


    @RequestMapping(value="/getImageBinary/")
    public ResponseEntity<byte[]> getImageBinary(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
        ResponseEntity entity = null;
        HttpHeaders responseHeaders = new HttpHeaders();
        entity = new ResponseEntity(HttpStatus.BAD_REQUEST);

        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_sn = SimpleUtils.default_set(request.getParameter("file_sn"));

    	String noImagePath = request.getSession().getServletContext().getRealPath("/") + NO_IMAGE_PATH;
    	String realPath = noImagePath;
    	String fileName = NO_IMAGE_NAME;

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
        map.put("file_sn", file_sn);
    	HashMap result = fileService.getFileDetail(map);

    	if(result != null){
        	realPath = SimpleUtils.default_set((String) result.get("SYS_FILE_PATH"));
        	fileName = SimpleUtils.default_set((String) result.get("FILE_NM"));
    	}

        FileInputStream fileStream = null;

        try {
            File getResource = new File(realPath);
            if(!getResource.exists()){
    	    	realPath = noImagePath;
    	        getResource = new File(realPath);
            }
            byte byteStream[] = new byte[(int)getResource.length()];
            fileStream = new FileInputStream(getResource);
            int i = 0;
            for(int j = 0; (i = fileStream.read()) != -1; j++)
                byteStream[j] = (byte)i;

            responseHeaders.setContentType(MediaType.IMAGE_JPEG);
            responseHeaders.set("Content-Disposition", "attatchment; filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO-8859-1") +"\"");
            entity = new ResponseEntity(byteStream, responseHeaders, HttpStatus.OK);
    	} catch(Exception e) {
            fileStream.close();
        } finally {
            fileStream.close();
    	}
        return entity;
    }

    @RequestMapping(value="/getStreamBinary/")
    public void streamView(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        //대상 동영상 파일명
        String file_id = SimpleUtils.default_set(request.getParameter("file_id"));
        String file_sn = SimpleUtils.default_set(request.getParameter("file_sn"));

    	HashMap map = new HashMap();
    	map.put("file_id", file_id);
    	map.put("file_sn", file_sn);
    	HashMap result = fileService.getFileDetail(map);

    	StreamView sv = new StreamView();
    	if(result != null){
    		String realPath = (String) result.get("SYS_FILE_PATH");
        	String fileName = (String) result.get("FILE_NM");
			//스트리밍 시작
    		sv.makeStream(realPath, request, response);
    	}
    }

    @Resource private StatsService statsService;
    
    @RequestMapping(value = "/excel/")
    public ModelAndView getExcel(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	Map<String, Object> result = new HashMap<String, Object>();
    	
    	try {
        	String menuCd = SimpleUtils.default_set(request.getParameter("menuCd"));
        	List<HashMap> data = statsService.getCrimeCaseList(null);
        	
        	result.put("menuCd", menuCd);
        	result.put("data", data);
        }catch (Exception e) {
        	System.out.println(e.getMessage());
          }
        
        return new ModelAndView("excelView", "result", result);
    }
}
