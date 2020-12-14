package kr.go.nssp.face.web;

import java.nio.ByteBuffer;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.neurotec.biometrics.NBiometricOperation;
import com.neurotec.biometrics.NBiometricStatus;
import com.neurotec.biometrics.NBiometricTask;
import com.neurotec.biometrics.NMatchingResult;
import com.neurotec.biometrics.NSubject;
import com.neurotec.biometrics.NSubject.FaceCollection;
import com.neurotec.biometrics.swing.NFaceView;
import com.neurotec.licensing.NLicenseManager;
import com.neurotec.samples.util.Utils;
import com.neurotec.util.concurrent.AggregateExecutionException;
import com.neurotec.util.concurrent.CompletionHandler;

import kr.go.nssp.utl.Utility;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class FaceLgMatcher {
	static {
		try {
			javax.swing.UIManager.setLookAndFeel(javax.swing.UIManager.getSystemLookAndFeelClassName());
			boolean trialMode = Utils.getTrialModeFlag();
			NLicenseManager.setTrialMode(true);
			System.out.println("\tTrial mode: " + trialMode);
			
		} catch (Exception e) {
			Logger.getLogger(Logger.getLogger("global").getName()).log(Level.FINE, e.getMessage(), e);
		}
	}

	protected boolean obtained;
	private final EnrollHandler enrollHandler = new EnrollHandler();
	private final IdentificationHandler identificationHandler = new IdentificationHandler();
	private final TemplateCreationHandler templateCreationHandler = new TemplateCreationHandler();

	private NSubject subject;
	private final List<NSubject> subjects;
	protected final List<String> requiredLicenses = new ArrayList<String>();
	protected final List<String> optionalLicenses = new ArrayList<String>();
	private NFaceView view;
	private List<String> scmf= new ArrayList<String>();
	private boolean chkcntr;
	private boolean chkval;
	private boolean identchk;
	private List<HashMap> tmplList;
	private byte[] cby;
	private HashMap rtnmap;

	public FaceLgMatcher () {
		try {
			//NDataFileManager.getInstance().addFromDirectory("/usr/local/Neurotechnology/Data/", false);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		this.subjects = new ArrayList<NSubject>();
		this.identchk = false;
		this.chkval = false;
		this.chkcntr = false;
		this.rtnmap = new HashMap();
		this.tmplList = new ArrayList<HashMap> ();
		this.cby = new byte[0];

		requiredLicenses.add("Biometrics.FaceExtraction");
		requiredLicenses.add("Biometrics.FaceMatching");

		try {
			boolean status = FaceTools.getInstance().obtainLicenses(requiredLicenses);
			boolean status2 = FaceTools.getInstance().obtainLicenses(optionalLicenses);
			obtained = status;
		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}

	public HashMap startIdentify (List<HashMap> tmplList, byte[] cby) {
		this.tmplList = tmplList;
		this.cby = cby;

		openTemplates ();	//db에 저장되어 있는 파일들
		openProbe (); 		//카메라로 캡처된 사진
		identify (); 		//비교
		return this.rtnmap;
	}

	private synchronized void openTemplates () {
		try {
			/**********템플릿 파일 가져 옴 (DB에 저장된 파일)***********/
			for(HashMap m : this.tmplList) {
				Blob b = m.get("FILE_INFO")!=null?(Blob)m.get("FILE_INFO"):null;
				if(b != null) {
					try {
						byte[] yt = b.getBytes(1, (int) b.length());
						ByteBuffer buf = ByteBuffer.wrap(yt);
						NSubject s = NSubject.fromMemory(buf);
						s.setId(Utility.nvl(m.get("ESNTL_ID")));  // 이름을 ID 로 바꾸자
						subjects.add(s);
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			/**********end 템플릿 파일 가져 옴 (DB에 저장된 파일)***********/

		} catch (UnsupportedOperationException e) {
			e.printStackTrace();
			// Ignore. UnsupportedOperationException means file is not a valid template.
		}
	}

	private synchronized void openProbe () {
		/**********카메라에서 딴 템플릿 파일***********/
		subject = null;
		ByteBuffer buf = ByteBuffer.wrap(this.cby);
		if(buf != null) {
			try {
				subject = NSubject.fromMemory(buf);
				subject.setId("loginimg");
				if(subject != null) {
					FaceCollection faces = subject.getFaces();
					if (faces.isEmpty()) {
						subject = null;
						throw new IllegalArgumentException("Template contains no face records.");
					}
					//NFace face = faces.get(0);
					templateCreationHandler.completed(NBiometricStatus.OK, null);
				} 
				
			} catch (UnsupportedOperationException e) {
				subject = null;
				System.out.println("UnsupportedOperationException >>> ");
				e.printStackTrace();
			} catch (Exception e) {
				subject = null;
				e.printStackTrace();
			}
		}
	}

	private synchronized void identify () {
		//System.out.println("this.chkcntr >>> "+this.chkcntr);
		//System.out.println("subject >>> "+subject);
		//System.out.println("subjects.isEmpty() >>> "+subjects.isEmpty());
		//비교
		if(this.chkcntr) {
			//MatchingFar :: 기본 값 (0.01%) Utils.matchingThresholdToString(FaceTools.getInstance().getDefaultClient().getMatchingThreshold())
			if ((subject != null) && !subjects.isEmpty()) {
				FaceTools.getInstance().getClient().clear();
				NBiometricTask enrollmentTask = new NBiometricTask(EnumSet.of(NBiometricOperation.ENROLL));
				for (NSubject s : subjects) {
					enrollmentTask.getSubjects().add(s);
				}
				FaceTools.getInstance().getClient().performTask(enrollmentTask, null, enrollHandler);

				/*답변대기*/
				for(int i=0; i<50; i++) {
					if(this.identchk) break;
					else {
						try {
							Thread.sleep(100);
						} catch (InterruptedException e) {
							e.printStackTrace();
						}
					}
				}
			}
		} else {
		}
	}

	protected void updateControls() {
		//사진 비교시 사용
		this.chkcntr = !subjects.isEmpty() && (subject != null) && ((subject.getStatus() == NBiometricStatus.OK) || (subject.getStatus() == NBiometricStatus.NONE));
		
		//템플릿에 대한 회신 확인
		this.chkval = true;	
		System.out.println("subject.getStatus() >>>" + (subject.getStatus()));
		
		//System.out.println("!subjects.isEmpty() >>>" + (!subjects.isEmpty()));
		//System.out.println("subject != null >>>" + (subject != null));
		//System.out.println("daskdjasdsakdjsa:::subject.getStatus() == NBiometricStatus.OK::"+(subject.getStatus() == NBiometricStatus.OK));
		//System.out.println("daskdjasdsakdjsa:::subject.getStatus() == NBiometricStatus.NONE::"+(subject.getStatus() == NBiometricStatus.NONE));
	}

	// ===========================================================
	// Package private methods
	// ===========================================================

	NSubject getSubject() {
		return subject;
	}

	void setSubject(NSubject subject) {
		this.subject = subject;
	}

	List<NSubject> getSubjects() {
		return subjects;
	}

	void appendIdentifyResult(String name, int score) {
		//일지하지 않는 결과 점수는 0으로 통일
		//System.out.println("appendIdentifyResult >>> "+name+":::::"+score);
	}

	void prependIdentifyResult(String name, int score) {
		//System.out.println("name >>>" + name);
		//System.out.println("score >>>" + score);
		if(score > 30) {  //30점 이상일 경우에만..
			if(rtnmap.get("score")!=null) {
				int mapscore = (int) rtnmap.get("score");
				if(score > mapscore) {
					rtnmap.put("id",    name);
					rtnmap.put("score", score);
					rtnmap.put("pw",    "faceLogin"+name);
				}
			} else {
				rtnmap.put("esntl_id",    name);
				rtnmap.put("score", score);
				rtnmap.put("pw",    "faceLogin"+name);
			}
		}
		System.out.println("prependIdentifyResult >>> "+name+":::::"+score);
	}

	// ===========================================================
	// Inner classes
	// ===========================================================
	private class EnrollHandler implements CompletionHandler<NBiometricTask, Object> {

		@Override
		public synchronized void completed(NBiometricTask task, Object attachment) {
			if (task.getStatus() == NBiometricStatus.OK) {
				// Identify current subject in enrolled ones.
				FaceTools.getInstance().getClient().identify(getSubject(), null, identificationHandler);
			} else {
				System.out.println(">>>>>> 자료가 정확하지 않음");
				identchk = true;
			}
		}

		@Override
		public synchronized void failed(final Throwable th, final Object attachment) {
			updateControls();
			showError(th);
		}

	}

	private class TemplateCreationHandler implements CompletionHandler<NBiometricStatus, Object> {

		@Override
		public void completed(final NBiometricStatus status, final Object attachment) {
			synchronized (TemplateCreationHandler.class) {
				updateControls();
			}
		}

		@Override
		public void failed(final Throwable th, final Object attachment) {
			synchronized (TemplateCreationHandler.class) {
				System.out.println(":::에러 확인:::");
				updateControls();
				showError(th);
			}
		}
	}

	private class IdentificationHandler implements CompletionHandler<NBiometricStatus, Object> {

		@Override
		public synchronized void completed(final NBiometricStatus status, final Object attachment) {
			if ((status == NBiometricStatus.OK) || (status == NBiometricStatus.MATCH_NOT_FOUND)) {
				// Match subjects.
				for (NSubject s : getSubjects()) {
					boolean match = false;
					for (NMatchingResult result : getSubject().getMatchingResults()) {
						if (s.getId().equals(result.getId())) {
							match = true;
							prependIdentifyResult(result.getId(), result.getScore());
							break;
						}
					}
					if (!match) {
						appendIdentifyResult(s.getId(), 0);
					}
				}
			} else {
				System.out.println(">>>>>>>>> Identification failed: " + status);
			}
			identchk = true;
		}

		@Override
		public synchronized void failed(final Throwable th, final Object attachment) {
			updateControls();
			showError(th);
		}
	}

	public void showError(Throwable e) {
		this.identchk = true;
		e.printStackTrace();
		if (e instanceof AggregateExecutionException) {
			StringBuilder sb = new StringBuilder(64);
			sb.append("Execution resulted in one or more errors:\n");
			for (Throwable cause : ((AggregateExecutionException) e).getCauses()) {
				sb.append(cause.toString()).append('\n');
			}
			System.out.println(">>>>>>Execution failed>>>>>>"+sb.toString());
		} else {
			System.out.println(">>>>>>Error>>>>>>");
		}
	}
}

