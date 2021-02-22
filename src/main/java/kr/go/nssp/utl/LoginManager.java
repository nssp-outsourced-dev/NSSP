package kr.go.nssp.utl;

import java.io.PrintStream;
import java.util.*;
import javax.servlet.http.*;

public class LoginManager implements HttpSessionBindingListener{

	private static LoginManager loginManager = null;

	//로그인한 접속자를 담기위한 해시테이블
	private static Hashtable loginUsers = new Hashtable();

	/*
	* 싱글톤 패턴 사용
	*/
	public static synchronized LoginManager getInstance(){
		if(loginManager == null){
			loginManager = new LoginManager();
		}
		return loginManager;
	}


	/*
	* 이 메소드는 세션이 연결되을때 호출된다.(session.setAttribute("login", this))
	* Hashtable에 세션과 접속자 아이디를 저장한다.
	*/
	public void valueBound(HttpSessionBindingEvent event) {
		//session값을 put한다.
		loginUsers.put(event.getSession(), event.getName());
		System.out.println(event.getName() + "님이 로그인 하셨습니다.");
		System.out.println("현재 접속자 수 : " + getUserCount());
	}


	/*
	* 이 메소드는 세션이 끊겼을때 호출된다.(invalidate)
	* Hashtable에 저장된 로그인한 정보를 제거해 준다.
	*/
	public void valueUnbound(HttpSessionBindingEvent event) {
		//session값을 찾아서 없애준다.
		loginUsers.remove(event.getSession());
		System.out.println(" " + event.getName() + "님이 로그아웃 하셨습니다.");
		System.out.println("현재 접속자 수 : " + getUserCount());
	}


	/*
	* 입력받은 아이디를 해시테이블에서 삭제.
	* @param esntlID 사용자 아이디
	* @return void
	*/
	public void removeSession(String esntlID){
		Enumeration e = loginUsers.keys();
		HttpSession session = null;
		while(e.hasMoreElements()){
			session = (HttpSession)e.nextElement();
			if(loginUsers.get(session).equals(esntlID)){
				//세션이 invalidate될때 HttpSessionBindingListener를
				//구현하는 클레스의 valueUnbound()함수가 호출된다.
				session.invalidate();
			}
		}
	}

	/*
	* 해당 아이디의 동시 사용을 막기위해서
	* 이미 사용중인 아이디인지를 확인한다.
	* @param esntlID 사용자 아이디
	* @return boolean 이미 사용 중인 경우 true, 사용중이 아니면 false
	*/
	public boolean isUsing(String esntlID){
		return loginUsers.containsValue(esntlID);
	}


	/*
	* 로그인을 완료한 사용자의 아이디를 세션에 저장하는 메소드
	* @param session 세션 객체
	* @param esntlID 사용자 아이디
	*/
	public void setSession(HttpSession session, String esntlID){
		//이순간에 Session Binding이벤트가 일어나는 시점
		//name값으로 esntlID, value값으로 자기자신(HttpSessionBindingListener를 구현하는 Object)
		session.setAttribute(esntlID, this);//login에 자기자신을 집어넣는다.
	}


	/*
	* 입력받은 세션Object로 아이디를 리턴한다.
	* @param session : 접속한 사용자의 session Object
	* @return String : 접속자 아이디
	*/
	public String getEsntlID(HttpSession session){
		return (String)loginUsers.get(session);
	}


	/*
	* 현재 접속한 총 사용자 수
	* @return int 현재 접속자 수
	*/
	public int getUserCount(){
		return loginUsers.size();
	}


	/*
	* 현재 접속중인 모든 사용자 아이디를 출력
	* @return void
	*/
	public void printloginUsers(){
		Enumeration e = loginUsers.keys();
		HttpSession session = null;
		System.out.println("===========================================");
		int i = 0;
		while(e.hasMoreElements()){
			session = (HttpSession)e.nextElement();
			System.out.println((++i) + ". 접속자 : " + loginUsers.get(session));
		}
		System.out.println("===========================================");
	}

	/*
	* 현재 접속중인 모든 사용자리스트를 리턴
	* @return list
	*/
	public Collection getUsers(){
		Collection collection = loginUsers.values();
		return collection;
	}


	/*
	* 2차 로그인 session 생성
	* @return list
	*/
	public String setBioSession (HttpSession session, HashMap data) throws Exception {
		String result = "-1";
		try{
	        if(data != null){
	        	String use_yn = (String) data.get("USE_YN");
	        	String confm_yn = (String) data.get("CONFM_YN");
	        	String login_ty = (String) data.get("LOGIN_TY");
	        	String esntl_id = (String) data.get("ESNTL_ID");

	        	if("Y".equals(use_yn) && "Y".equals(confm_yn)) {
	        		session.setAttribute("login_cnt2", "1");

	        		String login_cnt1 = Utility.nvl(session.getAttribute("login_cnt1"));

	        		//2단계 로그인
	        		if (login_ty.equals("1") || (login_ty.equals("2") && login_cnt1.equals("1")) ) {

	        			boolean b = true;
	        			if(login_ty.equals("2")) {
	        				String strTempId = Utility.nvl(session.getAttribute("temp_esntl_id"));
	        				if(!esntl_id.equals(strTempId)) {
	        					result = "-3";
		        				b = false;
	        				} else {
	        					session.setAttribute("temp_esntl_id", esntl_id);
	        				}
	        			}

	        			if(b) {
	        				session.setAttribute("user_id", data.get("USER_ID"));
							session.setAttribute("user_nm", data.get("USER_NM"));

							if(data.get("DEPT_CD") != null){
								session.setAttribute("dept_cd", data.get("DEPT_CD"));
								session.setAttribute("dept_nm", data.get("DEPT_NM"));
								session.setAttribute("dept_single_nm", data.get("DEPT_SINGLE_NM"));

							}else{
								session.setAttribute("dept_cd", "");
								session.setAttribute("dept_nm", "");
								session.setAttribute("dept_single_nm", "");
							}

							if(data.get("DEPT_ROOT_CD") != null){
								session.setAttribute("dept_root_cd", data.get("DEPT_ROOT_CD"));
								session.setAttribute("dept_root_nm", data.get("DEPT_ROOT_NM"));
							}else{
								session.setAttribute("dept_root_cd", "");
								session.setAttribute("dept_root_nm", "");
							}

							//관리자여부 확인
							String author_cd = (String) data.get("AUTHOR_CD");
							String mngr_yn = "N";
							session.setAttribute("author_cd", author_cd);
							if("00001".equals(author_cd) || "00002".equals(author_cd)){
								mngr_yn = "Y";
							}
							session.setAttribute("mngr_yn", mngr_yn);
							session.setAttribute("esntl_id", esntl_id);

							//timeout 60분
							session.setMaxInactiveInterval(3600);

							//새로운 접속(세션) 생성
							setSession(session, esntl_id);

							result = "1";
	        			}
	        		} else {
	        			result = "-2";  //2단계 로그인 안됨, 1단계 부터 시작 요망
	        		}
	        	}
	        }
		}catch(Exception e){
			System.out.println("오류 발생~~!!!");
			result = "-1";
		}
		return result;
	}
}
