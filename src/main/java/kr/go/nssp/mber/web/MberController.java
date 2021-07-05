package kr.go.nssp.mber.web;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.sql.Blob;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.cmmn.service.DeptService;
import kr.go.nssp.face.web.FaceLgMatcher;
import kr.go.nssp.face.web.FaceTmpMatcher;
import kr.go.nssp.finger.web.FingerMatcher;
import kr.go.nssp.mber.service.MberService;
import kr.go.nssp.menu.service.MenuService;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.LoginManager;
import kr.go.nssp.utl.BioData;
import kr.go.nssp.utl.ObjectLock;
import kr.go.nssp.utl.Utility;
import kr.go.nssp.utl.egov.EgovProperties;

import org.apache.commons.io.FileUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.gpki.gpkiapi.cert.X509Certificate;
import com.gpki.gpkiapi.exception.GpkiApiException;
import com.gpki.servlet.GPKIHttpServletRequest;
import com.gpki.servlet.GPKIHttpServletResponse;

import twitter4j.internal.org.json.JSONObject;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.co.siione.dist.utils.SimpleUtils;
import kr.go.nssp.cmmn.service.CdService;
import kr.go.nssp.cmmn.service.DeptService;
import kr.go.nssp.face.web.FaceLgMatcher;
import kr.go.nssp.face.web.FaceTmpMatcher;
import kr.go.nssp.finger.web.FingerMatcher;
import kr.go.nssp.mber.service.MberService;
import kr.go.nssp.menu.service.MenuService;
import kr.go.nssp.utl.BioData;
import kr.go.nssp.utl.InvUtil;
import kr.go.nssp.utl.LoginManager;
import kr.go.nssp.utl.ObjectLock;
import kr.go.nssp.utl.Utility;
import kr.go.nssp.utl.egov.EgovProperties;
import twitter4j.internal.org.json.JSONObject;

@Controller
@RequestMapping(value = "/member/")
public class MberController {

	// 초기화 비밀번호
	private String RESET_PASSWORD = EgovProperties.getProperty("Globals.resetPassword");

	@Resource
	private MberService mberService;

	@Resource
	private CdService cdService;

	@Resource
	private DeptService deptService;

	@Resource
	private MenuService menuService;

	ArrayList<String> formatList = new ArrayList<String>();

	public MberController() {
		formatList.add("jpg");
		formatList.add("jpeg");
		formatList.add("bmp");
		formatList.add("gif");
		formatList.add("png");
	}

	@RequestMapping(value = "/login/")
	public String login(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		// LoginManager loginManager = LoginManager.getInstance();
		// model.addAttribute("userCnt",
		// Integer.valueOf(loginManager.getUserCount()));

		//실서버 적용시 주석 해제
		GPKIHttpServletResponse gpkiresponse = null;
	    GPKIHttpServletRequest gpkirequest = null;

	    try{

	    	gpkiresponse=new GPKIHttpServletResponse(response);
		    gpkirequest= new GPKIHttpServletRequest(request);
	        gpkiresponse.setRequest(gpkirequest);
	        model.addAttribute("challenge", gpkiresponse.getChallenge());
	        model.addAttribute("sessionid", gpkirequest.getSession().getId());

	    }catch(Exception e){
	    	System.out.println("GPKIHttpServletResponse ERROR");
	    }
	    //end 실서버 적용시 주석 해제

		return "mber/login";
	}

	@RequestMapping(value = "/faceTest/")
	public String faceTest(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		LoginManager loginManager = LoginManager.getInstance();
		model.addAttribute("userCnt", Integer.valueOf(loginManager.getUserCount()));
		return "mber/http";
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/fingerLogin/")
	public void fingerLogin(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>> fingerLogin 호출");
		String txtCookie = Utility.nvl(request.getParameter("txtCookie"));
		String txtType = Utility.nvl(request.getParameter("txtType"));
		String txtFile = Utility.nvl(request.getParameter("txtFile"));
		String txtEsntlId = Utility.nvl(request.getParameter("txtEsntlId"));
		String txtWidth = Utility.nvl(request.getParameter("txtWidth"));
		String txtHeight = Utility.nvl(request.getParameter("txtHeight"));

		String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
		txtCookie = txtCookie.replaceAll(match, "").substring(0, 55);
		response.setStatus(999);

		byte[] binary = null;

		if (!txtFile.equals("") && !txtCookie.equals("")) {
			try {
				txtFile = txtFile.replace("-", "+");
				//binary = Base64.getMimeDecoder().decode(txtFile.getBytes(StandardCharsets.UTF_8));
				String version = System.getProperty("java.version");
		        System.out.println("JAVA Version : " + version);
		        
		        if(version.contains("1.7")) {//java version이 1.7이면
		        	binary = org.apache.commons.codec.binary.Base64.decodeBase64(txtFile.getBytes(StandardCharsets.UTF_8));
		        }else if(version.contains("1.8")) {//java version이 1.8이면
		        	binary = Base64.getMimeDecoder().decode(txtFile.getBytes(StandardCharsets.UTF_8));
		        }
			} catch (Exception e) {
				e.printStackTrace();
			}
			response.setStatus(700);
		}
		response.setStatus(800);
		// lock 해제
		ObjectLock obj = ObjectLock.getInstance();
		BioData bd = obj.getMap(txtCookie);
		if (bd != null) {
			bd.setMessage(txtCookie + "님의 finger Login 이미지 도착");
			bd.setBchk(true);
			bd.setBy(binary);
			bd.setWidth(txtWidth);
			bd.setHeight(txtHeight);
			obj.stopLock(txtCookie);
			// System.out.println("---------------------lock 해제------------------");
			response.setStatus(700);
		} else {
			response.setStatus(-999);
		}
		String filePath = EgovProperties.getProperty("Globals.fileFaceStorage") + "finger" + File.separator + txtCookie
				+ File.separator;

		File pathCheck = new File(filePath);
		if (!pathCheck.exists() || !pathCheck.isDirectory())
			pathCheck.mkdirs();

		File f = new File(filePath + "fingertmp.raw");
		if (!f.getParentFile().exists())
			f.getParentFile().mkdirs();

		OutputStream os = null;
		try {
			os = new FileOutputStream(f);
			os.write(binary);
			os.close();
			response.setStatus(700);
		} catch (IOException e) {
			System.out.println("Error(file write) : Utility.fileSave(" + filePath + ")");
			response.setStatus(-999);
		} finally {
			if (os != null)
				os.close();
		}
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/faceLogin/")
	public ResponseEntity<Map> faceLogin(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println(this.getClass().getName() + " : " + request.getRequestURL());
		int rstSt = 1;
		String resultMsg = "접속";
		
		//img 변환 
		String cvrstmsg = "변환 전";
		int cvrsti = -999;		
		
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>> faceLogin 호출");
		String txtCookie = Utility.nvl(request.getParameter("txtCookie"));
		String txtType = Utility.nvl(request.getParameter("txtType"));
		String txtFile = Utility.nvl(request.getParameter("txtFile"));
		String txtEsntlId = Utility.nvl(request.getParameter("txtEsntlId"));
		
		ResponseEntity entity = null;
		Map rmap = new HashMap();
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.setContentType(new MediaType("application", "json", Charset.forName("UTF-8")));
		//responseHeaders.add("Content-Type", "application/json");
		
		String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]"; // "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
		txtCookie = txtCookie.replaceAll(match, "").substring(0, 55);
		
		rstSt = 999;
		resultMsg = "파라미터 확인";
		response.setStatus(rstSt);

		byte[] binary = null;
		
		try {
			if ((!txtFile.equals("")) && (!txtCookie.equals(""))) {
		        txtFile = txtFile.replace("-", "+");
		        System.out.println("txtFile : " + txtFile);
		        System.out.println("binary : " + binary);
		        System.out.println("txtFile.getBytes(StandardCharsets.UTF_8) : " + txtFile.getBytes(StandardCharsets.UTF_8));
		        
		        String version = System.getProperty("java.version");
		        System.out.println("JAVA Version : " + version);
		        
		        if(version.contains("1.7")) {//java version이 1.7이면
		        	binary = org.apache.commons.codec.binary.Base64.decodeBase64(txtFile.getBytes(StandardCharsets.UTF_8));System.out.println("binary2 : " + binary);
		        }else if(version.contains("1.8")) {//java version이 1.8이면
		        	binary = Base64.getMimeDecoder().decode(txtFile.getBytes(StandardCharsets.UTF_8));System.out.println("binary2 : " + binary);
		        }
		      }

		      byte[] cvby = null;
		      
		      if ((binary != null) && (binary.length > 0)) {
		        FaceTmpMatcher fm = new FaceTmpMatcher();
		        HashMap rstm = fm.setTemplateToByte(binary);
		        System.out.println("rstm : " + rstm.toString());
		        cvby = (byte[])rstm.get("imgbyte");
		        cvrstmsg = (String)rstm.get("rstmsg");
		        cvrsti = ((Integer)rstm.get("rstcode")).intValue();
		        System.out.println("cvby : " + cvby);
		        System.out.println("cvrstmsg : " + cvrstmsg);
		        System.out.println("cvrsti : " + cvrsti);
		      }
		      if (cvrsti == 1)
		      {
		        ObjectLock obj = ObjectLock.getInstance();
		        BioData bd = obj.getMap(txtCookie);
		        if (bd != null) {
		          bd.setMessage(txtCookie + "님의 face Login 이미지 도착");
		          bd.setBchk(true);
		          bd.setBy(cvby);
		          bd.setByEncode(txtFile);///
		          System.out.println(">>>>> " + bd.getMessage());
		          obj.stopLock(txtCookie);
		          System.out.println("---------------------lock 해제------------------");
		          rstSt = 700;
		          resultMsg = "완료";
		          response.setStatus(rstSt);
		        } else {
		          rstSt = -9;
		          resultMsg = "락 해제 오류";
		          response.setStatus(rstSt);
		        }
		        
		        System.out.println("bd : " + bd.toString());
		      } else {
		        rstSt = 500;
		        resultMsg = "이미지 부적합";
		        response.setStatus(rstSt);
		      }
		} catch (Exception e) {
			e.printStackTrace();
			rstSt = -11;
			resultMsg = "Exception";
			response.setStatus(rstSt);
		}
		rmap.put("result", rstSt);
		rmap.put("resultMsg", resultMsg);
		rmap.put("cvresultMsg", cvrstmsg);
		rmap.put("cvresultCode", cvrsti);
		System.out.println("rmap : " + rmap.toString());
		entity = new ResponseEntity<Map>(rmap, HttpStatus.CREATED);
		return entity;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/fingerLoginAjax/")
	public ModelAndView fingerLoginAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String result = "-1";
		boolean rstans = false;
		String txtID = Utility.nvl(request.getParameter("txtID"));
		String strCoo = Utility.nvl(request.getParameter("strCoo"));
		String chkBiostep = Utility.nvl(request.getParameter("chkBiostep"));
		String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]"; // "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
		strCoo = strCoo.replaceAll(match, "").substring(0, 55);
		System.out.println("==============================================");
		System.out.println("txtID : " + txtID + ", strCoo : " + strCoo + ", chkBiostep : " + chkBiostep);
		
		if (!strCoo.equals("")) {
			ObjectLock obj = ObjectLock.getInstance();
			BioData bd = new BioData();
			bd.setId(strCoo);
			bd.setMessage(strCoo + "님의 finger Login 시작");
			bd.setBchk(false);
			obj.setMap(strCoo, bd);
			obj.startLock(strCoo);
			// data get
			byte[] by = bd.getBy();
			rstans = bd.isBchk ();

			if (by != null && by.length > 0) {
				HashMap rtnmap = new HashMap();
				HashMap tmpl = new HashMap();
				tmpl.put("user_id", txtID);
				tmpl.put("file_ty", "finger");

				List<HashMap> tmp_list = mberService.selectFaceTemplate(tmpl);
				if (tmp_list != null) {
					FingerMatcher _fp = new FingerMatcher();
					_fp.printMessage();
					// 지문 확인
					for (HashMap m : tmp_list) {
						Blob b = m.get("FNGPRT_FILE_INFO") != null ? (Blob) m.get("FNGPRT_FILE_INFO") : null;
						if (b != null) {
							byte[] dby = b.getBytes(1L, (int)b.length());
							// rm.put(dby.length, by.length);
							int width = bd.getWidth() == null ? 0 : Integer.parseInt(bd.getWidth());
							int height = bd.getHeight() == null ? 0 : Integer.parseInt(bd.getHeight());
							Object[] resp2 = _fp.Verify(dby, 248, 292, by, 248, 292);
							Integer resCode = (Integer) resp2[0];
							Integer msg = (Integer) resp2[1];

							System.out.println(">>>>>>>>>> 점수 :" + resCode);
							System.out.println(">>>>>>>>>> 결과 메시지 :" + msg);

							if ((resCode != null) && (resCode.intValue() > 2500)) {
								rtnmap.put("esntl_id", m.get("ESNTL_ID"));
								break;
							}
						}
					}
				}
				String esntl_id = rtnmap.get("esntl_id") == null ? "" : rtnmap.get("esntl_id").toString();
				
				if (esntl_id != null && !esntl_id.trim().equals("")) {
					HashMap map = new HashMap();
					map.put("esntl_id", esntl_id);
					HashMap data = mberService.userInfo(map);
					if(chkBiostep.equals("1")) data.put("LOGIN_TY", "1");
					result = LoginManager.getInstance().setBioSession(request.getSession(), data);
					if (result.equals("1")) {
						// 접속로그
						HashMap log = new HashMap();
						log.put("esntl_id", esntl_id);
						log.put("connect_ip", request.getRemoteAddr());
						mberService.userLog(log);
					}
				}
			}
		}
		HashMap ret = new HashMap();
		ret.put("result", result);
		ret.put("rstans", rstans);
		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/faceLoginAjax/")
	public ModelAndView faceLoginAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println(this.getClass().getName() + " : " + request.getRequestURL());//System.out.println("faceLoginAjaxfaceLoginAjaxfaceLoginAjaxfaceLoginAjaxfaceLoginAjaxfaceLoginAjax");
		String result = "-1";
		boolean rstans = false;

		String txtID = Utility.nvl(request.getParameter("txtID"));
		String strCoo = Utility.nvl(request.getParameter("strCoo"));
		String chkBiostep = Utility.nvl(request.getParameter("chkBiostep"));
		System.out.println("==============================================");
		System.out.println("txtID : " + txtID + ", strCoo : " + strCoo + ", chkBiostep : " + chkBiostep);

		String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]"; // "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
		strCoo = strCoo.replaceAll(match, "").substring(0, 55);

		if (!strCoo.equals("")) {
			
			ObjectLock obj = ObjectLock.getInstance();
			BioData bd = new BioData();
			bd.setId(strCoo);
			bd.setMessage(strCoo + "님의 face Login 시작");
			bd.setBchk(false);
			obj.setMap(strCoo, bd);
			System.out.println(">>>>>> " + obj.getMap(strCoo).getMessage());
			System.out.println("----------lock 설정-------------");
			obj.startLock(strCoo);
			System.out.println("----------lock 해제 2-------------");
			
			boolean chkTout = bd.isChkTimeout();
			rstans = bd.isBchk();
			
			if(chkTout == true) {
				result = "99999";				
			} else {
				// data get
				byte[] by = bd.getBy();				
				if (by != null && by.length > 0) {						
					// 매처 txtID
					HashMap rtnmap = new HashMap();
					HashMap<String, String> tmpl = new HashMap<String, String>();
					tmpl.put("user_id", txtID);
					tmpl.put("file_ty", "face");
					List<HashMap> tmp_list = mberService.selectFaceTemplate(tmpl);

					if (tmp_list != null) {
						System.out.println("face matcher 시작");
						FaceLgMatcher fclogin2 = new FaceLgMatcher();
						rtnmap = fclogin2.startIdentify(tmp_list, by);	//변환 된 템플릿을 확인
					}

					String esntl_id = rtnmap.get("esntl_id") == null ? "" : rtnmap.get("esntl_id").toString();

					if (esntl_id != null && !esntl_id.trim().equals("")) {
						HashMap map = new HashMap();
						map.put("esntl_id", esntl_id);
						HashMap data = mberService.userInfo(map);
						if(chkBiostep.equals("1")) data.put("LOGIN_TY", "1");
						result = LoginManager.getInstance().setBioSession(request.getSession(), data);

						if (result.equals("1")) {
							// 접속로그
							HashMap log = new HashMap();
							log.put("esntl_id", esntl_id);
							log.put("connect_ip", request.getRemoteAddr());
							mberService.userLog(log);
						}

					}
				}
			}
		}
		HashMap ret = new HashMap();
		ret.put("result", result);
		ret.put("rstans", rstans);
		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping(value = "/sessionCheckAjax/")
	public ModelAndView sessionCheckAjax(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String result = "1";
		String esntl_id = Utility.nvl(request.getSession().getAttribute("temp_esntl_id"));
		String txtId = Utility.nvl(request.getParameter("txtID"));

		boolean userAt = false;
		HashMap map = new HashMap();

		if (esntl_id == null || esntl_id.trim().equals("")) {
			result = "-1";
			if (txtId != null && !txtId.trim().equals("")) {
				map.put("user_id", txtId);
				userAt = true;
			}
		} else {
			// 2차 로그인 확인
			map.put("esntl_id", esntl_id);
			userAt = true;
		}
		if (userAt) {
			HashMap data = mberService.userInfo(map);
			if (data != null) {
				String login_ty = Utility.nvl(data.get("LOGIN_TY"));
				if (login_ty.equals("2")) {
					String login_cnt1 = Utility.nvl(request.getSession().getAttribute("login_cnt1"));
					if (!login_cnt1.equals("1")) {
						result = "-2";
					}
				}
			} else {
				result = "-1";
			}
		}

		HashMap ret = new HashMap();
		ret.put("result", result);
		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping(value = "/loginAjax/")
	public ModelAndView loginAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model)
			throws Exception {
		Utility utl = Utility.getInstance();
		LoginManager loginManager = LoginManager.getInstance();
		HttpSession session = request.getSession();

		String result = "1";
		String clientIP = request.getRemoteAddr();
		String user_id = SimpleUtils.default_set(request.getParameter("txtID"));
		String txtPw = SimpleUtils.default_set(request.getParameter("txtPw"));

		try {
			HashMap map = new HashMap();
			map.put("user_id", user_id);
			HashMap data = mberService.userInfo(map);
			if (data != null) {
				String esntl_id = (String) data.get("ESNTL_ID");
				String use_yn = (String) data.get("USE_YN");
				String confm_yn = (String) data.get("CONFM_YN");
				String userPw = (String) data.get("USER_PW");
				String login_ty = (String) data.get("LOGIN_TY");
				String character_table = (String) data.get("CHARACTER_TABLE");

				// 접속로그 찍기 전??? 후???
				if (!"Y".equals(use_yn)) {
					// 사용불가
					result = "-4";
				} else if (!"Y".equals(confm_yn)) {
					// 미승인
					result = "-5";
				} else {
					// 비밀번호 불일치
					if (userPw.equals(utl.getSha256Encrypt(txtPw)) || ("faceLogin" + esntl_id).equals(txtPw)) { // face_login
						session.setAttribute("login_cnt1", "1"); // 카운트
						session.setAttribute("temp_esntl_id", esntl_id);

						if (login_ty.equals("2")) {
							// 2차 로그인 추가
							result = "-7";
						} else {
							session.setAttribute("user_id", data.get("USER_ID"));
							session.setAttribute("user_nm", data.get("USER_NM"));

							if (data.get("DEPT_CD") != null) {
								session.setAttribute("dept_cd", data.get("DEPT_CD"));
								session.setAttribute("dept_nm", data.get("DEPT_NM"));
								session.setAttribute("dept_single_nm", data.get("DEPT_SINGLE_NM"));

							} else {
								session.setAttribute("dept_cd", "");
								session.setAttribute("dept_nm", "");
								session.setAttribute("dept_single_nm", "");
							}

							if (data.get("DEPT_ROOT_CD") != null) {
								session.setAttribute("dept_root_cd", data.get("DEPT_ROOT_CD"));
								session.setAttribute("dept_root_nm", data.get("DEPT_ROOT_NM"));
							} else {
								session.setAttribute("dept_root_cd", "");
								session.setAttribute("dept_root_nm", "");
							}

							// 관리자여부 확인
							String author_cd = (String) data.get("AUTHOR_CD");
							String mngr_yn = "N";
							session.setAttribute("author_cd", author_cd);
							if ("00001".equals(author_cd) || "00002".equals(author_cd)) {
								mngr_yn = "Y";
							}
							session.setAttribute("mngr_yn", mngr_yn);
							session.setAttribute("character_table", character_table);
							session.setAttribute("esntl_id", esntl_id);

							// timeout 30분
							session.setMaxInactiveInterval(3600);
							// 새로운 접속(세션) 생성
							loginManager.setSession(session, esntl_id);

							// 접속로그
							HashMap log = new HashMap();
							log.put("esntl_id", esntl_id);
							log.put("connect_ip", clientIP);
							mberService.userLog(log);
						}
					} else {
						// pwd 불일치, 로그인 실패횟수 +1
						result = "-3";
					}
				}
			} else {
				// id 존재x
				result = "-2";
			}
		} catch (Exception e) {
			result = "-1";
		}
		HashMap ret = new HashMap();
		ret.put("result", result);
		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping(value = "/joinPopup/")
	public String join(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

		HashMap cMap = new HashMap();
		// 직책
		cMap.put("upper_cd", "00655");
		List<HashMap> rspofcList = cdService.getCdList(cMap);
		model.addAttribute("rspofcList", rspofcList);

		// 직급
		cMap.put("upper_cd", "00652");
		List<HashMap> clsfList = cdService.getCdList(cMap);
		model.addAttribute("clsfList", clsfList);

		// 비밀번호 질문
		cMap.put("upper_cd", "00754");
		List<HashMap> qestnList = cdService.getCdList(cMap);
		model.addAttribute("qestnList", qestnList);

		// 연락처 국번
		cMap.put("upper_cd", "00470");
		List<HashMap> telList = cdService.getCdList(cMap);
		model.addAttribute("telList", telList);

		// 휴대폰 앞자리
		cMap.put("upper_cd", "00939");
		List<HashMap> hpList = cdService.getCdList(cMap);
		model.addAttribute("hpList", hpList);

		return "mber/join";
	}

	@RequestMapping(value = "/joinAjax/")
	public ModelAndView joinAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model)
			throws Exception {
		Utility utl = Utility.getInstance();
		String txtUserId = SimpleUtils.default_set(request.getParameter("txtUserId"));
		String txtUserNm = SimpleUtils.default_set(request.getParameter("txtUserNm"));
		String hidDeptCd = SimpleUtils.default_set(request.getParameter("hidDeptCd"));
		String selClsfCd = SimpleUtils.default_set(request.getParameter("selClsfCd"));
		String selRspofcCd = SimpleUtils.default_set(request.getParameter("selRspofcCd"));
		String txtChrgJob = SimpleUtils.default_set(request.getParameter("txtChrgJob"));
		String txtResdncZip = SimpleUtils.default_set(request.getParameter("txtResdncZip"));
		String txtResdncAddr = SimpleUtils.default_set(request.getParameter("txtResdncAddr"));
		String txtEmail = SimpleUtils.default_set(request.getParameter("txtEmail"));
		String txtHpNo = SimpleUtils.default_set(request.getParameter("txtHpNo"));
		String txtTelNo = SimpleUtils.default_set(request.getParameter("txtTelNo"));
		String selpwQestnCd = SimpleUtils.default_set(request.getParameter("selpwQestnCd"));
		String txtpwQestnAnswer = SimpleUtils.default_set(request.getParameter("txtpwQestnAnswer"));
		String txtUserPw = SimpleUtils.default_set(request.getParameter("txtUserPw"));

		String result = "1";
		// byte validation
		if (txtUserNm.getBytes().length < 1 || txtUserNm.getBytes().length > 20 || hidDeptCd.getBytes().length != 5
				|| selClsfCd.getBytes().length != 5 || selRspofcCd.getBytes().length != 5) {
			result = "-2";
		} else {
			try {
				HashMap map = new HashMap();
				map.put("user_id", txtUserId);
				HashMap data = mberService.userInfo(map);
				if (data == null) {
					map.put("user_nm", txtUserNm);
					map.put("dept_cd", hidDeptCd);
					map.put("clsf_cd", selClsfCd);
					map.put("rspofc_cd", selRspofcCd);
					map.put("chrg_job", txtChrgJob);
					map.put("resdnc_zip", txtResdncZip);
					map.put("resdnc_addr", txtResdncAddr);
					map.put("email", txtEmail);
					map.put("hp_no", txtHpNo);
					map.put("tel_no", txtTelNo);
					map.put("pw_qestn_cd", selpwQestnCd);
					map.put("pw_qestn_answer", txtpwQestnAnswer);
					map.put("author_cd", "");
					map.put("use_yn", "Y");
					map.put("updt_id", "");

					map.put("confm_yn", "N");
					map.put("user_pw", txtUserPw==null||txtUserPw.equals("")?utl.getSha256Encrypt(RESET_PASSWORD):utl.getSha256Encrypt(txtUserPw));
					mberService.joinUser(map);
				} else {
					// id 존재
					result = "-3";
				}

			} catch (Exception e) {
				result = "-1";
			}
		}

		HashMap ret = new HashMap();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping(value = "/findPopup/")
	public String find(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HashMap cMap = new HashMap();
		// 비밀번호 질문
		cMap.put("upper_cd", "00754");
		List<HashMap> findList = cdService.getCdList(cMap);
		model.addAttribute("findList", findList);

		// 휴대폰 앞자리
		cMap.put("upper_cd", "00939");
		List<HashMap> hpList = cdService.getCdList(cMap);
		model.addAttribute("hpList", hpList);

		return "mber/find";
	}

	@RequestMapping(value = "/findAjax/")
	public ModelAndView findAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model)
			throws Exception {
		Utility utl = Utility.getInstance();

		String hidFindNo = SimpleUtils.default_set(request.getParameter("hidFindNo"));
		HashMap ret = new HashMap();
		String result = "1";

		if ("A".equals(hidFindNo)) {
			// 아이디찾기
			String txtUserNm = SimpleUtils.default_set(request.getParameter("txtUserNm"));
			String txtEmail = SimpleUtils.default_set(request.getParameter("txtEmail"));
			String txtHpNo = SimpleUtils.default_set(request.getParameter("txtHpNo"));
			HashMap map = new HashMap();
			map.put("user_nm", txtUserNm);
			map.put("email", txtEmail);
			map.put("hp_no", txtHpNo);
			HashMap data = mberService.userInfo(map);
			if (data != null) {
				ret.put("USER_ID", data.get("USER_ID"));
				ret.put("WRITNG_DE", data.get("WRITNG_DE"));
			} else {
				ret.put("USER_ID", "");
				ret.put("WRITNG_DE", "");
				result = "-2";
			}
		} else if ("B".equals(hidFindNo)) {
			// 비밀번호찾기
			String txtUserId = SimpleUtils.default_set(request.getParameter("txtUserId"));
			String selpwQestnCd = SimpleUtils.default_set(request.getParameter("selpwQestnCd"));
			String txtpwQestnAnswer = SimpleUtils.default_set(request.getParameter("txtpwQestnAnswer")).trim();

			HashMap map = new HashMap();
			map.put("user_id", txtUserId);
			HashMap data = mberService.userInfo(map);
			if (data != null) {
				String qestn_cd = (String) data.get("PW_QESTN_CD");
				String pw_qestn_answer = ((String) data.get("PW_QESTN_ANSWER")).trim();
				if (selpwQestnCd.equals(qestn_cd) && txtpwQestnAnswer.equals(pw_qestn_answer)) {
					result = "1";
				} else {
					result = "-3";
				}
			} else {
				result = "-2";
			}
		} else if ("C".equals(hidFindNo)) {
			// 비밀번호변경
			String txtUserId = SimpleUtils.default_set(request.getParameter("txtUserId"));
			String selpwQestnCd = SimpleUtils.default_set(request.getParameter("selpwQestnCd"));
			String txtpwQestnAnswer = SimpleUtils.default_set(request.getParameter("txtpwQestnAnswer")).trim();
			String txtUserPw = SimpleUtils.default_set(request.getParameter("txtUserPw"));

			HashMap map = new HashMap();
			map.put("user_id", txtUserId);
			HashMap data = mberService.userInfo(map);
			if (data != null) {
				String qestn_cd = (String) data.get("PW_QESTN_CD");
				String pw_qestn_answer = ((String) data.get("PW_QESTN_ANSWER")).trim();
				if (selpwQestnCd.equals(qestn_cd) && txtpwQestnAnswer.equals(pw_qestn_answer)) {
					map.put("esntl_id", data.get("ESNTL_ID"));
					map.put("updt_id", data.get("ESNTL_ID"));
					map.put("user_pw", utl.getSha256Encrypt(txtUserPw));
					mberService.updateEtc(map);
					result = "1";
				} else {
					result = "-3";
				}
			} else {
				result = "-2";
			}
		} else {
			result = "-1";
		}
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping(value = "/logoutAction/")
	public String logout(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		session.invalidate();
		return "redirect:/main/intro/";
	}

	@RequestMapping(value = "/list/")
	public String list(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		String author_cd = SimpleUtils.default_set(session.getAttribute("author_cd").toString());

		int pageBlock = 10;
		model.addAttribute("hidPageBlock", pageBlock);

		HashMap aMap = new HashMap();
		aMap.put("use_yn", "Y");
		List<HashMap> authorList = menuService.getAuthorClList(aMap);
		model.addAttribute("authorList", authorList);

		HashMap cMap = new HashMap();
		// 직책
		cMap.put("upper_cd", "00655");
		List<HashMap> rspofcList = cdService.getCdList(cMap);
		model.addAttribute("rspofcList", rspofcList);

		// 직급
		cMap.put("upper_cd", "00652");
		List<HashMap> clsfList = cdService.getCdList(cMap);
		model.addAttribute("clsfList", clsfList);

		// 비밀번호 질문
		cMap.put("upper_cd", "00754");
		List<HashMap> qestnList = cdService.getCdList(cMap);
		model.addAttribute("qestnList", qestnList);

		// 연락처 국번
		cMap.put("upper_cd", "00470");
		List<HashMap> telList = cdService.getCdList(cMap);
		model.addAttribute("telList", telList);

		// 휴대폰 앞자리
		cMap.put("upper_cd", "00939");
		List<HashMap> hpList = cdService.getCdList(cMap);
		model.addAttribute("hpList", hpList);

		//얼굴 라이센스
		List<HashMap> faceLicense = cdService.getFaceLicenseList(cMap);
		model.addAttribute("faceLicense", faceLicense);

		return "mber/list";
	}

	@RequestMapping(value = "/listAjax/")
	public ModelAndView listAjax(HttpServletRequest request) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		String searchUserID = SimpleUtils.default_set(request.getParameter("searchUserID"));
		String searchUserNm = SimpleUtils.default_set(request.getParameter("searchUserNm"));
		String searchAuthorCd = SimpleUtils.default_set(request.getParameter("searchAuthorCd"));

		// 현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if (!"".equals(hidPage))
			intPage = Integer.parseInt((String) hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));
		if (hidPageBlock == null || hidPageBlock.equals("")) {
			hidPageBlock = "10";
		}
		int pageBlock = Integer.parseInt((String) hidPageBlock);

		// 페이지 기본설정
		int pageArea = 10;

		// page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put("endRow", paginationInfo.getLastRecordIndex());
		map.put("user_id", searchUserID);
		map.put("user_nm", searchUserNm);
		map.put("author_cd", searchAuthorCd);

		int list_cnt = 0;
		List<HashMap> list = mberService.getUserList(map);

		if (list.size() > 0) {
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	@RequestMapping(value = "/detailAjax/")
	public ModelAndView detailAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model)
			throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String hidEsntlID = SimpleUtils.default_set(request.getParameter("hidEsntlID"));

		HashMap map = new HashMap();
		map.put("esntl_id", hidEsntlID);
		HashMap result = mberService.userInfo(map);

		return new ModelAndView("ajaxView", "ajaxData", result);
	}

	@RequestMapping("/addAjax/")
	public ModelAndView addAjax(HttpServletRequest request) throws Exception {
		Utility utl = Utility.getInstance();
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

		String hidEsntlID = SimpleUtils.default_set(request.getParameter("hidEsntlID"));

		String txtUserId = SimpleUtils.default_set(request.getParameter("txtUserId"));
		String txtUserNm = SimpleUtils.default_set(request.getParameter("txtUserNm"));
		String hidDeptCd = SimpleUtils.default_set(request.getParameter("hidDeptCd"));
		String selClsfCd = SimpleUtils.default_set(request.getParameter("selClsfCd"));
		String selRspofcCd = SimpleUtils.default_set(request.getParameter("selRspofcCd"));
		String txtChrgJob = SimpleUtils.default_set(request.getParameter("txtChrgJob"));
		String txtResdncZip = SimpleUtils.default_set(request.getParameter("txtResdncZip"));
		String txtResdncAddr = SimpleUtils.default_set(request.getParameter("txtResdncAddr"));
		String txtEmail = SimpleUtils.default_set(request.getParameter("txtEmail"));
		String txtHpNo = SimpleUtils.default_set(request.getParameter("txtHpNo"));
		String txtTelNo = SimpleUtils.default_set(request.getParameter("txtTelNo"));
		String selAuthorCd = SimpleUtils.default_set(request.getParameter("selAuthorCd"));
		String selUseYn = SimpleUtils.default_set(request.getParameter("selUseYn"));
		String selpwQestnCd = SimpleUtils.default_set(request.getParameter("selpwQestnCd"));
		String txtpwQestnAnswer = SimpleUtils.default_set(request.getParameter("txtpwQestnAnswer"));
		String txtUserPw = SimpleUtils.default_set(request.getParameter("txtUserPw"));
		String selFaceLicense = SimpleUtils.default_set(request.getParameter("selFaceLicense"));

		String result = "1";
		// byte validation
		if (txtUserNm.getBytes().length < 1 || txtUserNm.getBytes().length > 20 || hidDeptCd.getBytes().length != 5
				|| selClsfCd.getBytes().length != 5 || selRspofcCd.getBytes().length != 5
				|| selAuthorCd.getBytes().length != 5 || selUseYn.getBytes().length != 1) {
			result = "-3";
		} else {
			try {
				HashMap map = new HashMap();
				map.put("user_id", txtUserId);
				map.put("user_nm", txtUserNm);
				map.put("dept_cd", hidDeptCd);
				map.put("clsf_cd", selClsfCd);
				map.put("rspofc_cd", selRspofcCd);
				map.put("chrg_job", txtChrgJob);
				map.put("resdnc_zip", txtResdncZip);
				map.put("resdnc_addr", txtResdncAddr);
				map.put("email", txtEmail);
				map.put("hp_no", txtHpNo);
				map.put("tel_no", txtTelNo);
				map.put("author_cd", selAuthorCd);
				map.put("use_yn", selUseYn);
				map.put("updt_id", esntl_id);
				map.put("pw_qestn_cd", selpwQestnCd);
				map.put("pw_qestn_answer", txtpwQestnAnswer);

				//권한부여이력 저장
				HashMap logMap = new HashMap();
				logMap.put("esntl_id", esntl_id);//권한부여자(고유 ID)
				logMap.put("author_ip", request.getRemoteAddr());//부여자 IP
				logMap.put("author_trgter", hidEsntlID);//부여대상
				
				if (hidEsntlID == null || hidEsntlID.equals("")) {
					map.put("confm_yn", "Y");
					map.put("user_pw", txtUserPw==null||txtUserPw.equals("")?utl.getSha256Encrypt(RESET_PASSWORD):utl.getSha256Encrypt(txtUserPw));
					mberService.joinUser(map);
					
					logMap.put("author_job", "C");//권한부여
					logMap.put("now_author_cd", selAuthorCd);//현재 권한 코드
					mberService.insertAuthorizationLog(logMap);//권한부여이력 저장
				} else {
					HashMap qMap = new HashMap();
					qMap.put("esntl_id", hidEsntlID);
					HashMap data = mberService.userInfo(qMap);
					if (data != null) {
						map.put("esntl_id", hidEsntlID);
						mberService.updateUser(map);

						if(selFaceLicense != null && !selFaceLicense.equals("")) {
							map.put("face_license",selFaceLicense);
							mberService.updateFaceLicense (map);
						}
						
						//System.out.println("author_cd : " + String.valueOf(data.get("AUTHOR_CD")));
						//System.out.println("selAuthorCd : " + selAuthorCd);
						if(!"null".equals(String.valueOf(data.get("AUTHOR_CD"))) && //권한코드가 null아니고
								!String.valueOf(data.get("AUTHOR_CD")).equals(selAuthorCd) && //권한코드가 비어있지 않고
								"Y".equals(String.valueOf(data.get("CONFM_YN")))) {//승인완료상태이면
							logMap.put("author_job", "U");//권한변경
							logMap.put("prev_author_cd", String.valueOf(data.get("AUTHOR_CD")));//이전 권한 코드
							logMap.put("now_author_cd", selAuthorCd);//현재 권한 코드
							mberService.insertAuthorizationLog(logMap);//권한부여이력 저장
						}
						
						if("N".equals(selUseYn)) {//사용여부를 사용안함으로 변경할때
							logMap.put("author_job", "D");//권한삭제
							mberService.insertAuthorizationLog(logMap);//권한부여이력 저장
						}else if("Y".equals(selUseYn)){//사용여부를 사용안함에서 사용으로 변경할때
							logMap.put("author_job", "C");//권한부여
							logMap.put("now_author_cd", selAuthorCd);//현재 권한 코드
							mberService.insertAuthorizationLog(logMap);//권한부여이력 저장
						}
					} else {
						result = "-2";
					}
				}
			} catch (Exception e) {
				result = "-1";
			}
		}

		HashMap ret = new HashMap();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping(value = "/getIdDplctAjax/")
	public ModelAndView getIdDplctAjax(HttpServletRequest request, HttpServletResponse response, ModelMap model)
			throws Exception {
		String txtUserId = SimpleUtils.default_set(request.getParameter("txtUserId"));

		String result = "1";
		HashMap map = new HashMap();
		map.put("user_id", txtUserId);
		int cnt = mberService.getUserIdCnt(map);
		if (cnt > 0) {
			result = "-1";
		}
		HashMap ret = new HashMap();
		ret.put("result", result);
		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping("/confmUserAjax/")
	public ModelAndView confmUserAjax(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

		String hidEsntlID = SimpleUtils.default_set(request.getParameter("hidEsntlID"));
		String result = "1";
		try {
			HashMap map = new HashMap();
			map.put("esntl_id", hidEsntlID);
			HashMap data = mberService.userInfo(map);
			if (data != null) {
				if (data.get("AUTHOR_CD") == null) {
					result = "-3";
				} else {
					map.put("updt_id", esntl_id);
					map.put("confm_yn", "Y");
					mberService.updateEtc(map);
					
					//권한부여이력 저장
					HashMap logMap = new HashMap();
					logMap.put("esntl_id", esntl_id);//권한부여자(고유 ID)
					logMap.put("author_ip", request.getRemoteAddr());//부여자 IP
					logMap.put("author_trgter", hidEsntlID);//부여대상
					logMap.put("now_author_cd", String.valueOf(data.get("AUTHOR_CD")));//현재 권한 코드
					logMap.put("author_job", "C");//권한부여
					mberService.insertAuthorizationLog(logMap);//권한부여이력 저장
				}
			} else {
				result = "-2";
			}
		} catch (Exception e) {
			result = "-1";
		}

		HashMap ret = new HashMap();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping("/resetPwAjax/")
	public ModelAndView resetPwAjax(HttpServletRequest request) throws Exception {
		Utility utl = Utility.getInstance();
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

		String hidEsntlID = SimpleUtils.default_set(request.getParameter("hidEsntlID"));

		String result = "1";
		try {
			HashMap map = new HashMap();
			map.put("esntl_id", hidEsntlID);
			HashMap data = mberService.userInfo(map);
			if (data != null) {
				map.put("updt_id", esntl_id);
				map.put("user_pw", utl.getSha256Encrypt(RESET_PASSWORD));
				mberService.updateEtc(map);
			} else {
				result = "-2";
			}
		} catch (Exception e) {
			result = "-1";
		}

		HashMap ret = new HashMap();
		ret.put("result", result);
		ret.put("resetPw", RESET_PASSWORD);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping(value = "/changePwPopup/")
	public String changePw(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		return "mber/changePwPopup";
	}

	@RequestMapping("/changePwAjax/")
	public ModelAndView changePwAjax(HttpServletRequest request) throws Exception {
		Utility utl = Utility.getInstance();
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String txtUserExPw = SimpleUtils.default_set(request.getParameter("txtUserExPw"));
		String txtUserPw = SimpleUtils.default_set(request.getParameter("txtUserPw"));
		String result = "1";
		try {
			HashMap map = new HashMap();
			map.put("esntl_id", esntl_id);
			HashMap data = mberService.userInfo(map);
			if (data != null) {
				String userPw = (String) data.get("USER_PW");
				// 이전 비밀번호 불일치
				if (!userPw.equals(utl.getSha256Encrypt(txtUserExPw))) {
					result = "-3";
					// 이전, 변경 비밀번호 동일
				} else if (userPw.equals(utl.getSha256Encrypt(txtUserPw))) {
					result = "-4";
				} else {
					map.put("updt_id", esntl_id);
					map.put("user_pw", utl.getSha256Encrypt(txtUserPw));
					mberService.updateEtc(map);
				}
			} else {
				result = "-2";
			}
		} catch (Exception e) {
			result = "-1";
		}

		HashMap ret = new HashMap();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping(value = "/updateSelf/")
	public String updateSelf(HttpServletRequest request, HttpServletResponse response, ModelMap model)
			throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String gpki_reg = Utility.nvl(request.getParameter("gpkiReg"));

		HashMap map = new HashMap();
		map.put("esntl_id", esntl_id);
		HashMap result = mberService.userInfo(map);
		model.addAttribute("result", result);

		HashMap cMap = new HashMap();
		// 직책
		cMap.put("upper_cd", "00655");
		List<HashMap> rspofcList = cdService.getCdList(cMap);
		model.addAttribute("rspofcList", rspofcList);

		// 직급
		cMap.put("upper_cd", "00652");
		List<HashMap> clsfList = cdService.getCdList(cMap);
		model.addAttribute("clsfList", clsfList);

		// 비밀번호 질문
		cMap.put("upper_cd", "00754");
		List<HashMap> qestnList = cdService.getCdList(cMap);
		model.addAttribute("qestnList", qestnList);

		// 연락처 국번
		cMap.put("upper_cd", "00470");
		List<HashMap> telList = cdService.getCdList(cMap);
		model.addAttribute("telList", telList);

		// 휴대폰 앞자리
		cMap.put("upper_cd", "00939");
		List<HashMap> hpList = cdService.getCdList(cMap);
		model.addAttribute("hpList", hpList);

		// 파일 get
		if (result != null) {
			if (!esntl_id.equals("")) {
				HashMap fMap = new HashMap();
				fMap.put("esntl_id", esntl_id);
				fMap.put("file_ty", "face");
				model.addAttribute("faceFileList", mberService.selectFaceTemplate(fMap));
				fMap.put("file_ty", "finger");
				model.addAttribute("fingerFileList", mberService.selectFaceTemplate(fMap));
			}
		}

		model.addAttribute("formatList", formatList);
		model.addAttribute("rntimg", Utility.nvl(request.getParameter("rntimg")));
		model.addAttribute("cvrstcode", Utility.nvl(request.getParameter("cvrstcode")));
		model.addAttribute("gpkiReg",gpki_reg);		
		
		return "mber/updateSelf";
	}

	@RequestMapping("/updateSelfAjax/")
	public ModelAndView updateSelfAjax(HttpServletRequest request) throws Exception {
		Utility utl = Utility.getInstance();
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());

		String txtUserNm = SimpleUtils.default_set(request.getParameter("txtUserNm"));
		String selClsfCd = SimpleUtils.default_set(request.getParameter("selClsfCd"));
		String selRspofcCd = SimpleUtils.default_set(request.getParameter("selRspofcCd"));
		String txtChrgJob = SimpleUtils.default_set(request.getParameter("txtChrgJob"));
		String txtResdncZip = SimpleUtils.default_set(request.getParameter("txtResdncZip"));
		String txtResdncAddr = SimpleUtils.default_set(request.getParameter("txtResdncAddr"));
		String txtEmail = SimpleUtils.default_set(request.getParameter("txtEmail"));
		String txtHpNo = SimpleUtils.default_set(request.getParameter("txtHpNo"));
		String txtTelNo = SimpleUtils.default_set(request.getParameter("txtTelNo"));
		String txtFaxNo = SimpleUtils.default_set(request.getParameter("txtFaxNo"));
		String selpwQestnCd = SimpleUtils.default_set(request.getParameter("selpwQestnCd"));
		String txtpwQestnAnswer = SimpleUtils.default_set(request.getParameter("txtpwQestnAnswer"));
		String selLoginTy = SimpleUtils.default_set(request.getParameter("selLoginTy"));
		String txtCharacterTable = SimpleUtils.default_set(request.getParameter("hidCharacterTable"));

		String result = "1";

		// byte validation
		if (txtUserNm.getBytes().length < 1 || txtUserNm.getBytes().length > 20 || selClsfCd.getBytes().length != 5
				|| selRspofcCd.getBytes().length != 5) {
			result = "-3";
		} else {
			try {
				HashMap map = new HashMap();
				map.put("esntl_id", esntl_id);
				HashMap data = mberService.userInfo(map);
				if (data != null) {
					map.put("user_nm", txtUserNm);
					map.put("clsf_cd", selClsfCd);
					map.put("rspofc_cd", selRspofcCd);
					map.put("chrg_job", txtChrgJob);
					map.put("resdnc_zip", txtResdncZip);
					map.put("resdnc_addr", txtResdncAddr);
					map.put("email", txtEmail);
					map.put("hp_no", txtHpNo);
					map.put("tel_no", txtTelNo);
					map.put("fax_no", txtFaxNo);
					map.put("updt_id", esntl_id);

					map.put("pw_qestn_cd", selpwQestnCd);
					map.put("pw_qestn_answer", txtpwQestnAnswer);

					map.put("login_ty", selLoginTy);
					
					if(txtCharacterTable !=null && txtCharacterTable.length()>0) {
						txtCharacterTable.replaceAll(" ", "");
					}
					map.put("character_table", txtCharacterTable);
					mberService.updateUser(map);
				} else {
					result = "-2";
				}
			} catch (Exception e) {
				result = "-1";
			}
		}

		HashMap ret = new HashMap();
		ret.put("result", result);

		return new ModelAndView("ajaxView", "ajaxData", ret);
	}

	@RequestMapping(value = "/aliveJson/")
	public ResponseEntity sessionAlive(HttpServletRequest request, HttpServletResponse response, ModelMap model)
			throws Exception {
		ResponseEntity entity = null;
		JSONObject obj = new JSONObject();
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/plain; charset=utf-8");
		HttpSession session = request.getSession();
		String user_id = SimpleUtils.default_set(session.getAttribute("user_id").toString());

		if (user_id == null || user_id.isEmpty()) {
			obj.put("RESULT", -1);
		} else {
			obj.put("RESULT", 0);
		}
		entity = new ResponseEntity(obj.toString(), responseHeaders, HttpStatus.CREATED);
		return entity;
	}

	@RequestMapping(value = "/accesHistlist/")
	public String accesHistlist(HttpServletRequest request, HttpServletResponse response, ModelMap model)
			throws Exception {
		HttpSession session = request.getSession();
		int pageBlock = 10;
		model.addAttribute("hidPageBlock", pageBlock);

		return "mber/accesHistlist";
	}

	@RequestMapping(value = "/accesHistlistAjax/")
	public ModelAndView accesHistlistAjax(HttpServletRequest request) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		String searchUserID = SimpleUtils.default_set(request.getParameter("searchUserID"));
		String searchUserNm = SimpleUtils.default_set(request.getParameter("searchUserNm"));
		String searchAccesIp = SimpleUtils.default_set(request.getParameter("searchAccesIp"));

		// 현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if (!"".equals(hidPage))
			intPage = Integer.parseInt((String) hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));
		if (hidPageBlock == null || hidPageBlock.equals("")) {
			hidPageBlock = "10";
		}
		int pageBlock = Integer.parseInt((String) hidPageBlock);

		// 페이지 기본설정
		int pageArea = 10;

		// page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put("endRow", paginationInfo.getLastRecordIndex());
		map.put("user_id", searchUserID);
		map.put("user_nm", searchUserNm);
		map.put("acces_ip", searchAccesIp);

		int list_cnt = 0;
		List<HashMap> list = mberService.getAccesHistList(map);

		if (list.size() > 0) {
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	@RequestMapping(value = "/userListComboAjax/")
	public ModelAndView comboListAjax(HttpServletRequest request) throws Exception {
		String dept_cd = SimpleUtils.default_set(request.getParameter("dept_cd"));

		HashMap map = new HashMap();
		map.put("dept_cd", dept_cd);
		List<HashMap> result = mberService.getUserListCombo(map);

		return new ModelAndView("ajaxView", "ajaxData", result);
	}

	/**
	 * 사용자 검색 팝업
	 *
	 * @return "/mber/selectPopup/"
	 * @exception Exception
	 */
	@RequestMapping(value = "/selectPopup/")
	public String arrst(HttpServletRequest request, HttpServletResponse response, ModelMap map) throws Exception {
		map.addAttribute("pId", SimpleUtils.default_set(request.getParameter("pId")));
		return "mber/selectPopup";
	}

	@RequestMapping(value = "/userFullListAjax/")
	public ModelAndView userFullListAjax(HttpServletRequest request) throws Exception {
		// 현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		String userNm = SimpleUtils.default_set(request.getParameter("txtUserNm"));
		int intPage = 1;
		if (!"".equals(hidPage))
			intPage = Integer.parseInt((String) hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));
		if (hidPageBlock == null || hidPageBlock.equals("")) {
			hidPageBlock = "10";
		}
		int pageBlock = Integer.parseInt((String) hidPageBlock);
		// 페이지 기본설정
		int pageArea = 10;
		// page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put("endRow", paginationInfo.getLastRecordIndex());
		map.put("user_nm", userNm);

		int list_cnt = 0;
		List<HashMap> list = mberService.getUserList(map);

		if (list.size() > 0) {
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list = InvUtil.getInstance().getConvertUnderscoreNameGrid(list));
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	@RequestMapping(value = "/addFaceImg/")
	public String addFaceImg(MultipartHttpServletRequest request, HttpServletResponse response, ModelMap model)
			throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		MultipartFile file = request.getFile("txtFile");
		int rnt = 0;
		int rsti = -999;

		if (file != null) {	
			try {
				// 템플릿 변경
				FaceTmpMatcher fm = new FaceTmpMatcher();
				HashMap rstm = fm.setTemplateToByte(file.getBytes());
				byte[] cvby = (byte[]) rstm.get("imgbyte");
				String rstmsg = (String) rstm.get("rstmsg");
				rsti = (int) rstm.get("rstcode");
				
				if (cvby != null && cvby.length > 0) {
					HashMap map = new HashMap();
					map.put("esntl_id", esntl_id);
					map.put("file_ty", "face");
					map.put("file_info", cvby);
					rnt = mberService.setFaceTemplate(map);
					
//					StringBuilder byEncode = new StringBuilder().toString();
//					byEncode.append(org.apache.commons.codec.binary.StringUtils.newStringUtf8(org.apache.commons.codec.binary.Base64.encodeBase64(file.getBytes(), false)));
					
					this.saveFileInfo(esntl_id
							, new StringBuilder(
									org.apache.commons.codec.binary.StringUtils.newStringUtf8(
											org.apache.commons.codec.binary.Base64.encodeBase64(
													file.getBytes()
													, false
					))).toString());
				}
			} catch (Exception e) {
				System.out.println("오류 >>> ");
				e.printStackTrace();
			}
		}
		return "redirect:/member/updateSelf/?rntimg="+rnt+"&cvrstcode="+rsti;
	}

	@RequestMapping(value = "/deleteBioTmpFile/")
	public ModelAndView deleteBioTmpFile(HttpServletRequest request) throws Exception {
		// 현재 페이지 파라메타
		String fileId = Utility.nvl(request.getParameter("fileId"));
		String fileTy = Utility.nvl(request.getParameter("fileTy"));
		int rtn = 0;

		HashMap map = new HashMap();
		map.put("fileId", fileId);
		map.put("fileTy", fileTy);

		rtn = mberService.deleteBioTmpFile(map);

		HashMap cMap = new HashMap();
		cMap.put("result", rtn);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	//
	@RequestMapping(value = "/bioDtSaveAjax/")
	public ModelAndView bioDtSaveAjax(HttpServletRequest request) throws Exception {
		System.out.println(this.getClass().getName() + " : " + request.getRequestURL());
		// 현재 페이지 파라메타
		String txtID = Utility.nvl(request.getParameter("txtID"));
		String strCoo = Utility.nvl(request.getParameter("strCoo"));
		String strType = Utility.nvl(request.getParameter("strType"));
		
		System.out.println("strCoo >>>>> " + strCoo);

		String match = "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]"; // "[^\uAC00-\uD7A3xfe0-9a-zA-Z\\s]";
		strCoo = strCoo.replaceAll(match, "").substring(0, 55);
		
		System.out.println("strCoo >>>>> " + strCoo);

		int rtn = 0;
		boolean rstans = false;

		if (!strCoo.equals("")) {
			ObjectLock obj = ObjectLock.getInstance();
			BioData bd = new BioData();
			bd.setId(strCoo);
			bd.setMessage(strCoo + "님의 " + strType + " file 저장 시작");
			obj.setMap(strCoo, bd);
			System.out.println(">>>>>> " + obj.getMap(strCoo).getMessage());
			System.out.println("----------lock 설정-------------");
			obj.startLock(strCoo);
			System.out.println("----------lock 해제 2-------------");

			// data get
			byte[] by = bd.getBy();
			rstans = bd.isBchk();
			//System.out.println("djkasjdkajsdkajsd::::" + by);

			if (by != null && by.length > 0 && !txtID.equals("") && !strType.equals("")) {
				HashMap map = new HashMap();
				map.put("esntl_id", txtID); // 보낼 것
				map.put("file_ty", strType);
				if (strType.equals("finger")) {
					map.put("fg_file_info", by);
					map.put("fngprt_width", bd.getWidth() == null ? 0 : Integer.parseInt(bd.getWidth()));
					map.put("fngprt_height", bd.getHeight() == null ? 0 : Integer.parseInt(bd.getHeight()));
					rtn = mberService.setFaceTemplate(map);
				} else if (strType.equals("face")) {
					// img 파일 > 템플릿 변경	
					System.out.println("cvby >>> "+Arrays.toString(by));					
					if(by != null) {
						map.put("file_info", by);
						System.out.println(this.getClass().getName() + " map : " + map);
						rtn = mberService.setFaceTemplate(map);
						
						this.saveFileInfo(txtID, bd.getByEncode());
					}									
				}				
			}
		}

		HashMap cMap = new HashMap();
		cMap.put("result", rtn);
		cMap.put("rstans", rstans);
		System.out.println(this.getClass().getName() + " cMap : " + cMap);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 인증서 로그인을 처리한다
	 * @param vo - 주민번호가 담긴 LoginVO
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
	@RequestMapping(value = "/actionCrtfctLogin/")
	public String actionCrtfctLogin (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		System.out.println(">>>>>>>>>>>>>>>>>>> actionCrtfctLogin actionCrtfctLogin actionCrtfctLogin actionCrtfctLogin");

		GPKIHttpServletResponse gpkiresponse = null;
		GPKIHttpServletRequest gpkirequest   = null;

		try {
			gpkiresponse = new GPKIHttpServletResponse(response);
			gpkirequest  = new GPKIHttpServletRequest(request);
			gpkiresponse.setRequest(gpkirequest);

			//out = new GPKIJspWriter(out,(GPKIKeyInfo)session.getAttribute("GPKISession"));
		} catch (NullPointerException e) {
			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			StringBuffer sb = new StringBuffer(1500);
			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			sb.append("?errmsg=");
			sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
			System.out.println(">>>>>>error1>>>"+sb.toString());
			//response.sendRedirect(sb.toString());
			return "mber/login";
		}catch (Exception e) {
			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			StringBuffer sb = new StringBuffer(1500);
			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			sb.append("?errmsg=");
			sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
			System.out.println(">>>>>>error2>>>"+sb.toString());
			//response.sendRedirect(sb.toString());
			return "mber/login";
		}

		try {
			X509Certificate cert      = null;
			byte[]  signData          = null;
			byte[]  privatekey_random = null;
			String  signType          = null;
			String  subDN             = null;
			String  queryString       = "";
			boolean checkPrivateNum   = false;

			java.math.BigInteger b = new java.math.BigInteger("-1".getBytes());
			int message_type =  gpkirequest.getRequestMessageType();

			System.out.println("message_typemessage_type>>>>"+message_type);   //23

			if( message_type == gpkirequest.ENCRYPTED_SIGNDATA || message_type == gpkirequest.LOGIN_ENVELOP_SIGN_DATA ||
				message_type == gpkirequest.ENVELOP_SIGNDATA || message_type == gpkirequest.SIGNED_DATA) {
				cert              = gpkirequest.getSignerCert();
				subDN             = cert.getSubjectDN();
				b                 = cert.getSerialNumber();
				signData          = gpkirequest.getSignedData();
				privatekey_random = gpkirequest.getSignerRValue();
				signType          = gpkirequest.getSignType();
			}

			//queryString = gpkirequest.getQueryString();

			//Enumeration params = gpkirequest.getParameterNames();
			//while (params.hasMoreElements()) {
			//	String paramName = (String)params.nextElement();
			//	String paramValue = gpkirequest.getParameter(paramName);

			//	if(paramName.trim().equalsIgnoreCase("ssn") && (null != paramValue) && (!"".equals(paramValue)) && privatekey_random != null) {
			//		try {
			//			cert.verifyVID(paramValue,privatekey_random);
			//			checkPrivateNum = true;
			//		} catch (GpkiApiException ex) {
			//			// 개인 식별 번호가 다른경우 예외처리
			//			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			//			StringBuffer sb = new StringBuffer(1500);
			//			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			//			sb.append("?errmsg=");
			//			sb.append(URLEncoder.encode("ssn parameter is different in certificate ! check ssn number","UTF-8"));
			//			System.out.println(">>>>>>error3>>>"+sb.toString());
						//response.sendRedirect(sb.toString());
			//			return "mber/login";
			//		}
			//	}
			//}

			System.out.println("message_type>>"+message_type);
			System.out.println("인증서 시리얼 넘버>>"+b);
			System.out.println("인증서 명칭>>"+subDN);
			System.out.println("인증서 식별번호 확인>>"+ (checkPrivateNum?"확인 완료":"확인되지 않음"));
			System.out.println("signType>>"+signType);

			//String subDN = "testGpki";

			String strGpkiId = Utility.nvl(request.getParameter("hidGpkiID"));
			if(subDN != null && !subDN.equals("") && subDN.toLowerCase().indexOf("korea")!=-1) {
				System.out.println(">>>> login 처리");
				HashMap map = new HashMap();
				map.put("gpki_dn", subDN);
				map.put("userId", strGpkiId);
				HashMap data = mberService.gpkiUserInfo(map);

				if(data == null || data.size() == 0) {
					model.addAttribute("gpkiResult", "999");
					return "mber/login";
				}
				data.put("strGpkiId", strGpkiId);
				if(!strGpkiId.equals("")) data.put("LOGIN_TY", "1");
				String result = LoginManager.getInstance().setBioSession(request.getSession(), data);

				if (result.equals("1")) {
					// 접속로그
					HashMap log = new HashMap();
					log.put("esntl_id", data.get("ESNTL_ID"));
					log.put("connect_ip", request.getRemoteAddr());
					mberService.userLog(log);

					return "redirect:/main/intro/";
				} else {
					System.out.println(">>>>>>error5 로그인 매칭 오류>>>"+result);
					model.addAttribute("gpkiResult", result);
					return "mber/login";
				}
			}

		} catch (Exception e) {
			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			StringBuffer sb = new StringBuffer(1500);
			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			sb.append("?errmsg=");
			sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
			System.out.println(">>>>>>error4>>>"+sb.toString());
			//response.sendRedirect(sb.toString());
			return "mber/login";
		}
		return "mber/login";
	}

	/**
	 * 인증서 등록
	 * @param vo - 주민번호가 담긴 LoginVO
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
	@RequestMapping(value = "/actionGPKIreg/")
	public String actionGPKIreg (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		System.out.println(">>>>>>>>>>>>>> actionGPKIreg actionGPKIreg actionGPKIreg");

		GPKIHttpServletResponse gpkiresponse = null;
		GPKIHttpServletRequest gpkirequest   = null;

		try {
			gpkiresponse = new GPKIHttpServletResponse(response);
			gpkirequest  = new GPKIHttpServletRequest(request);
			gpkiresponse.setRequest(gpkirequest);
			//out = new GPKIJspWriter(out,(GPKIKeyInfo)session.getAttribute("GPKISession"));
		} catch (NullPointerException e) {
			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			StringBuffer sb = new StringBuffer(1500);
			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			sb.append("?errmsg=");
			sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
			System.out.println(">>>>>>error1>>>"+sb.toString());
			return "mber/login";
		}catch (Exception e) {
			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			StringBuffer sb = new StringBuffer(1500);
			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			sb.append("?errmsg=");
			sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
			System.out.println(">>>>>>error2>>>"+sb.toString());
			return "mber/login";
		}

		try {
			X509Certificate cert      = null;
			byte[]  signData          = null;
			byte[]  privatekey_random = null;
			String  signType          = null;
			String  subDN             = null;
			String  queryString       = "";
			boolean checkPrivateNum   = false;

			java.math.BigInteger b = new java.math.BigInteger("-1".getBytes());

			int message_type =  gpkirequest.getRequestMessageType();

			if( message_type == gpkirequest.ENCRYPTED_SIGNDATA || message_type == gpkirequest.LOGIN_ENVELOP_SIGN_DATA ||
				message_type == gpkirequest.ENVELOP_SIGNDATA || message_type == gpkirequest.SIGNED_DATA){

				cert              = gpkirequest.getSignerCert();
				subDN             = cert.getSubjectDN();
				b                 = cert.getSerialNumber();
				signData          = gpkirequest.getSignedData();
				privatekey_random = gpkirequest.getSignerRValue();
				signType          = gpkirequest.getSignType();
			}

			/*queryString = gpkirequest.getQueryString();

			Enumeration params = gpkirequest.getParameterNames();
			while (params.hasMoreElements()) {
				String paramName = (String)params.nextElement();
				String paramValue = gpkirequest.getParameter(paramName);

				if(paramName.trim().equalsIgnoreCase("ssn") && (null != paramValue) && (!"".equals(paramValue)) && privatekey_random != null) {
					try {
						cert.verifyVID(paramValue,privatekey_random);
						checkPrivateNum = true;
					} catch (GpkiApiException ex) {
						// 개인 식별 번호가 다른경우 예외처리
						com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
						StringBuffer sb = new StringBuffer(1500);
						sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
						sb.append("?errmsg=");
						sb.append(URLEncoder.encode("ssn parameter is different in certificate ! check ssn number","UTF-8"));
						System.out.println(">>>>>>error3>>>"+sb.toString());
						return "mber/login";
					}
				}
			}*/

			System.out.println("message_type>>"+message_type);
			System.out.println("인증서 시리얼 넘버>>"+b);
			System.out.println("인증서 명칭>>"+subDN);
			System.out.println("인증서 식별번호 확인>>"+ (checkPrivateNum?"확인 완료":"확인되지 않음"));
			System.out.println("signType>>"+signType);

			//String subDN = "gpkiTest";

			if(subDN != null && !subDN.equals("") && subDN.toLowerCase().indexOf("korea")!=-1) {
				System.out.println(">>>> dn 저장");
				HashMap map = new HashMap ();
				map.put("gpkiDn", subDN);
				map.put("userId", request.getParameter("hidGpkiID"));
				map.put("userPw", request.getParameter("hidGpkiPw"));
				map.put("confmYn", "Y");
				int rtnVal = mberService.updateUserGpkiDn(map);
				if(rtnVal > 0) model.addAttribute("gpkiReg", "888");
				else model.addAttribute("gpkiReg", "999");
				return "redirect:/member/updateSelf/";
			}

		} catch (Exception e) {
			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			StringBuffer sb = new StringBuffer(1500);
			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			sb.append("?errmsg=");
			sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
			System.out.println(">>>>>>error4>>>"+sb.toString());
			model.addAttribute("gpkiReg", "999");
			return "mber/updateSelf";
		}
		model.addAttribute("gpkiReg", "999");
		return "mber/updateSelf";
	}

	@RequestMapping(value = "/updateAllLoginType/")
	public ModelAndView updateAllLoginType(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		// 현재 페이지 파라메타
		String loginType = Utility.nvl(request.getParameter("loginType"));
		int rtn = 0;

		HashMap map = new HashMap();
		map.put("login_type", loginType);
		map.put("esntl_id", esntl_id);

		rtn = mberService.updateAllLoginType(map);

		HashMap cMap = new HashMap();
		cMap.put("result", rtn);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}

	/**
	 * 인증서 등록
	 * @param vo - 주민번호가 담긴 LoginVO
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
	@RequestMapping(value = "/actionGPKIjoinDN/")
	public String actionGPKIjoinDN (HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		System.out.println(">>>>>>>>>>>>>> actionGPKIjoinDN actionGPKIjoinDN actionGPKIjoinDN");

		GPKIHttpServletResponse gpkiresponse = null;
		GPKIHttpServletRequest gpkirequest   = null;

		try {
			gpkiresponse = new GPKIHttpServletResponse(response);
			gpkirequest  = new GPKIHttpServletRequest(request);
			gpkiresponse.setRequest(gpkirequest);
		} catch (NullPointerException e) {
			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			StringBuffer sb = new StringBuffer(1500);
			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			sb.append("?errmsg=");
			sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
			System.out.println(">>>>>>error1>>>"+sb.toString());
			return "mber/login";
		}catch (Exception e) {
			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			StringBuffer sb = new StringBuffer(1500);
			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			sb.append("?errmsg=");
			sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
			System.out.println(">>>>>>error2>>>"+sb.toString());
			return "mber/login";
		}

		try {
			X509Certificate cert      = null;
			byte[]  signData          = null;
			byte[]  privatekey_random = null;
			String  signType          = null;
			String  subDN             = null;
			String  queryString       = "";
			boolean checkPrivateNum   = false;

			java.math.BigInteger b = new java.math.BigInteger("-1".getBytes());

			int message_type =  gpkirequest.getRequestMessageType();

			if( message_type == gpkirequest.ENCRYPTED_SIGNDATA || message_type == gpkirequest.LOGIN_ENVELOP_SIGN_DATA ||
				message_type == gpkirequest.ENVELOP_SIGNDATA || message_type == gpkirequest.SIGNED_DATA){

				cert              = gpkirequest.getSignerCert();
				subDN             = cert.getSubjectDN();
				b                 = cert.getSerialNumber();
				signData          = gpkirequest.getSignedData();
				privatekey_random = gpkirequest.getSignerRValue();
				signType          = gpkirequest.getSignType();
			}

			System.out.println("message_type>>"+message_type);
			System.out.println("인증서 시리얼 넘버>>"+b);
			System.out.println("인증서 명칭>>"+subDN);
			System.out.println("인증서 식별번호 확인>>"+ (checkPrivateNum?"확인 완료":"확인되지 않음"));
			System.out.println("signType>>"+signType);

			if(subDN != null && !subDN.equals("") && subDN.toLowerCase().indexOf("korea")!=-1) {
				System.out.println(">>>> dn 저장");
				HashMap map = new HashMap ();
				map.put("gpkiDn", subDN);
				map.put("userId", request.getParameter("hidGpkiID"));
				map.put("userPw", Utility.getInstance().getSha256Encrypt(request.getParameter("hidGpkiPw")));
				map.put("confmYn", "N");
				int rtnVal = mberService.updateUserGpkiDn(map);
				if(rtnVal > 0) model.addAttribute("gpkiJoinMsg", "888");
				else model.addAttribute("gpkiJoinMsg", "999");

				return "mber/join";
			} else {
				model.addAttribute("gpkiJoinMsg", "999");
			}

		} catch (Exception e) {
			com.dsjdf.jdf.Config dsjdf_config = new com.dsjdf.jdf.Configuration();
			StringBuffer sb = new StringBuffer(1500);
			sb.append(dsjdf_config.get("GPKISecureWeb.errorPage"));
			sb.append("?errmsg=");
			sb.append(URLEncoder.encode(e.getMessage(), "euc-kr"));
			System.out.println(">>>>>>error4>>>"+sb.toString());
			model.addAttribute("gpkiJoinMsg", "999");
			return "mber/join";
		}

		model.addAttribute("gpkiJoinMsg", "999");

		return "mber/join";
	}

	/** 
	 * @methodName : saveFileInfo
	 * @date : 2021.05.25
	 * @author : dgkim
	 * @description : 기존 NSSP에서는 동작하지 않아 새로운 로직으로 재구현.<br>
	 * 클라이언트(웹캠, 지문스캐너) encoding되어서 들어오는 문자열을 계정과 일치하는 파일명에 텍스트파일로 저장.
	 * @param fileName
	 * @param byEncode
	 * @return
	 * @throws Exception
	 */
	public int saveFileInfo(String fileName, String byEncode) throws Exception {
		int result = 0;
		try {
			File file = new File(fileName + ".txt");
			System.out.println("file.getAbsolutePath() : " + file.getAbsolutePath());
			BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(file));
            
            if(file.isFile() && file.canWrite()){
            	bufferedWriter.write(byEncode);//쓰기
            	bufferedWriter.close();
            }
            
            result = 1;
		}catch (Exception e) {
			result = 0;
			System.out.println(e.getMessage());
		}
		
		return result;
	}
	
	/** 
	 * @methodName : authorizationLog
	 * @date : 2021.06.24
	 * @author : dgkim
	 * @description : 권한부여이력 저장
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/authorizationLog/")
	public String authorizationLog(HttpSession session, ModelMap model) throws Exception {
		int pageBlock = 10;
		model.addAttribute("hidPageBlock", pageBlock);

		return "mber/authorizationLog";
	}
	
	/** 
	 * @methodName : authorizationLogAjax
	 * @date : 2021.06.24
	 * @author : dgkim
	 * @description : 권한부여이력 조회
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/authorizationLogAjax/")
	public ModelAndView authorizationLogAjax(HttpServletRequest request) throws Exception {

		HttpSession session = request.getSession();
		String esntl_id = SimpleUtils.default_set(session.getAttribute("esntl_id").toString());
		String dept_cd = SimpleUtils.default_set(session.getAttribute("dept_cd").toString());

		String searchUserID = SimpleUtils.default_set(request.getParameter("searchUserID"));
		String searchUserNm = SimpleUtils.default_set(request.getParameter("searchUserNm"));
		String searchAccesIp = SimpleUtils.default_set(request.getParameter("searchAccesIp"));
		String searchDe1 = SimpleUtils.default_set(request.getParameter("searchDe1"));
		String searchDe2 = SimpleUtils.default_set(request.getParameter("searchDe2"));

		// 현재 페이지 파라메타
		String hidPage = SimpleUtils.default_set(request.getParameter("hidPage"));
		int intPage = 1;
		if (!"".equals(hidPage))
			intPage = Integer.parseInt((String) hidPage);

		String hidPageBlock = SimpleUtils.default_set(request.getParameter("hidPageBlock"));
		if (hidPageBlock == null || hidPageBlock.equals("")) {
			hidPageBlock = "10";
		}
		int pageBlock = Integer.parseInt((String) hidPageBlock);

		// 페이지 기본설정
		int pageArea = 10;

		// page
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(intPage);
		paginationInfo.setRecordCountPerPage(pageBlock);
		paginationInfo.setPageSize(pageArea);

		HashMap map = new HashMap();
		map.put("startRow", paginationInfo.getFirstRecordIndex());
		map.put("endRow", paginationInfo.getLastRecordIndex());
		map.put("searchUserID", searchUserID);
		map.put("searchUserNm", searchUserNm);
		map.put("searchAccesIp", searchAccesIp);
		map.put("searchDe1", searchDe1);
		map.put("searchDe2", searchDe2);

		int list_cnt = 0;
		List<HashMap> list = mberService.selectAuthorizationLog(map);

		if (list.size() > 0) {
			list_cnt = Integer.parseInt(list.get(0).get("TOT_CNT").toString());
		}

		HashMap cMap = new HashMap();
		cMap.put("list", list);
		cMap.put("cnt", list_cnt);
		return new ModelAndView("ajaxView", "ajaxData", cMap);
	}
}
