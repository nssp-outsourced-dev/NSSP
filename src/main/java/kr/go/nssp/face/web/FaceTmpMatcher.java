package kr.go.nssp.face.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.swing.SwingUtilities;

import com.neurotec.biometrics.NBiometricStatus;
import com.neurotec.biometrics.NFace;
import com.neurotec.biometrics.NSubject;
import com.neurotec.images.NImage;
import com.neurotec.licensing.NLicenseManager;
import com.neurotec.plugins.NDataFileManager;
import com.neurotec.samples.util.Utils;
import com.neurotec.util.concurrent.AggregateExecutionException;
import com.neurotec.util.concurrent.CompletionHandler;


import java.io.File;
import java.io.IOException;
import java.nio.ByteBuffer;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class FaceTmpMatcher {
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

	private NSubject subject;
	protected final List<String> requiredLicenses = new ArrayList<String>();
	protected final List<String> optionalLicenses = new ArrayList<String>();
	private boolean chkval;
	private boolean chkTmpl;

	private final TemplateCreationHandler templateCreationHandler = new TemplateCreationHandler();

	public FaceTmpMatcher () {
		try {
			//OS 확인
			String os = System.getProperty("os.name").toLowerCase();
			System.out.println("os : " + os);
			if("win".equals(os)) {//윈도우 OS
				NDataFileManager.getInstance().addFromDirectory("C:/DEV/Neurotechnology/Data/", false);
			}else {//기타
				NDataFileManager.getInstance().addFromDirectory("/usr/local/Neurotechnology/Data/", false);
			}
		} catch (Exception e) {
			System.out.println("TESTTESTSETSTS:::path setting");
			e.printStackTrace();
		}

		this.chkval = false;
		this.chkTmpl = false;
		this.subject = new NSubject();
		requiredLicenses.add("Biometrics.FaceExtraction");

		try {
			boolean status = FaceTools.getInstance().obtainLicenses(requiredLicenses);
			obtained = status;
		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}
	
	//img byte[] > setTemplate
	public HashMap setTemplateToByte (byte[] by) {		
		ByteBuffer buf = ByteBuffer.wrap(by);
		if(buf != null) {
			System.out.println("setTemplateToByte >>>> ");
			try {
				NFace face = new NFace();
				face.setImage(NImage.fromMemory(buf));
				face.setSessionId(1);
				subject.getFaces().add(face);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		//System.out.println("subject != null::::"+ subject != null);
		//System.out.println("subject.getStatus()::::"+ subject.getStatus());
		//System.out.println("NBiometricStatus.OK::::"+ NBiometricStatus.OK);

		byte[] b = new byte[0];
		String rsts = "대기";
		int rsti = -1;
		if(subject != null) {						
			updateFacesTools();
			FaceTools.getInstance().getClient().createTemplate(subject, null, templateCreationHandler);

			/*답변대기*/
			for(int i=0; i<30; i++) {
				if(this.chkval) break;
				else {
					try {
						Thread.sleep(200);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				System.out.println("setTemplateToByte i >>>>> "+i);
			}
			/*System.out.println("subject.getStatus() >>> "+ subject.getStatus());
			System.out.println("subject.getStatus() >>> "+ subject.getStatus().getValue());
			System.out.println("subject.getStatus() >>> "+ NBiometricStatus.OK);*/
			
			if(this.chkTmpl && subject != null && subject.getStatus() != null && subject.getStatus() == NBiometricStatus.OK) { //subject.getStatus() == NBiometricStatus.OK
				b = subject.getTemplateBuffer().toByteArray();
			}
			rsts = subject.getStatus().name();
			rsti = subject.getStatus().getValue();
		}
		HashMap m = new HashMap();
		m.put("rstmsg", rsts);
		m.put("rstcode", rsti);
		m.put("imgbyte", b);
		return m;
	}

	protected void updateFacesTools() {
		FaceTools.getInstance().getClient().reset();
		FaceTools.getInstance().getClient().setFacesQualityThreshold((byte) 0);	//기본이 50
		//FaceTools.getInstance().getClient().setFacesLivenessMode(NLivenessMode.PASSIVE_AND_ACTIVE);
	}

	// ===========================================================
	// Inner classes
	// ===========================================================

	private class TemplateCreationHandler implements CompletionHandler<NBiometricStatus, Object> {

		@Override
		public synchronized void completed(final NBiometricStatus status, final Object attachment) {
			if (status == NBiometricStatus.OK) {
				chkval = true;
				chkTmpl = true;
				//faceView.setFace(subject.getFaces().get(subject.getFaces().size() - 1));
			} else {
				chkval = true;
				chkTmpl = true;
				//lblStatus.setText(String.format("Status: %s", status));
			}
		}

		@Override
		public synchronized void failed(final Throwable th, final Object attachment) {
			System.out.println("Status: Error occurred");
			showError(th);
		}
	}

	public void showError(Throwable e) {
		this.chkTmpl = false;
		this.chkval = true;

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

