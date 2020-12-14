package kr.go.nssp.face.web;

import java.awt.Component;
import java.awt.Dimension;
import java.awt.Frame;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;

import com.neurotec.licensing.NLicenseManager;
import com.neurotec.samples.util.LibraryManager;
import com.neurotec.samples.util.Utils;

@SuppressWarnings("serial")
public class FaceLogin {

	// ===========================================================
	// Static constructor
	// ===========================================================

	static {
		try {
			javax.swing.UIManager.setLookAndFeel(javax.swing.UIManager.getSystemLookAndFeelClassName());

			boolean trialMode = Utils.getTrialModeFlag();
			NLicenseManager.setTrialMode(trialMode);
			System.out.println("\tTrial mode: " + trialMode);

		} catch (Exception e) {
			Logger.getLogger(Logger.getLogger("global").getName()).log(Level.FINE, e.getMessage(), e);
		}
	}

	public interface CallBack{
	   void onTakePicCB(int val);
    }
	private CallBack picCallBack;
	public void setCallBack(CallBack callback) {
	   picCallBack = callback;
	}

	// ===========================================================
	// Private fields
	// ===========================================================

	private BasePanel panelEnrollFromCamera;

	// ===========================================================
	// Private constructor
	// ===========================================================

	public FaceLogin () {
		picCallBack = null;
		System.out.println("dsadklaskdlskadlksl");

		//=========================================================================
		// TRIAL MODE
		//=========================================================================
		// Below code line determines whether TRIAL is enabled or not. To use purchased licenses, don't use below code line.
		// GetTrialModeFlag() method takes value from "Bin/Licenses/TrialFlag.txt" file. So to easily change mode for all our examples, modify that file.
		// Also you can just set TRUE to "TrialMode" property in code.
		//=========================================================================
		LibraryManager.initLibraryPath();
	}

	public byte[] getByteImg () {
		return panelEnrollFromCamera.getByteImg();
	}

	public synchronized void TackPic () {
		SwingUtilities.invokeLater(new Runnable() {
			JFrame frame = new JFrame();
			@Override
			public void run() {
				try {
					panelEnrollFromCamera = new EnrollFromCamera();
					panelEnrollFromCamera.init(frame);
					obtainLicenses(panelEnrollFromCamera);
					FaceTools.getInstance().resetParameters();
					Dimension d = new Dimension(800, 600);
					frame.setSize(d);
					frame.add(panelEnrollFromCamera);
					frame.addWindowListener(new WindowAdapter() {
						@Override
						public void windowClosing(WindowEvent e) {
							myDispose ();
						}
					});
					frame.setLocationRelativeTo(null);
					frame.setVisible(true);
					panelEnrollFromCamera.startCapturing ();
				} catch (Throwable e) {
					showError(null, e);
				}
			}
		});
		/*JFrame frame = new JFrame();
		panelEnrollFromCamera = new EnrollFromCamera();
		panelEnrollFromCamera.init(frame);
		obtainLicenses(panelEnrollFromCamera);
		FaceTools.getInstance().resetParameters();
		Dimension d = new Dimension(800, 600);
		frame.setSize(d);
		frame.add(panelEnrollFromCamera);
		frame.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				myDispose ();
			}
		});
		frame.setLocationRelativeTo(null);
		frame.setVisible(true);
		panelEnrollFromCamera.startCapturing ();*/
	}

	/*@Override
	public void run() {
		synchronized (this) {
			JFrame frame = new JFrame();
			try {
				//panelEnrollFromCamera = new IdentifyFace ();
				panelEnrollFromCamera = new EnrollFromCamera();
				panelEnrollFromCamera.init(frame);
				obtainLicenses(panelEnrollFromCamera);
				FaceTools.getInstance().resetParameters();
				Dimension d = new Dimension(800, 600);
				frame.setSize(d);
				frame.add(panelEnrollFromCamera);
				frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

				frame.addWindowListener(new WindowAdapter() {
					@Override
					public void windowClosing(WindowEvent e) {
						myDispose ();
					}
				});
				frame.setLocationRelativeTo(null);
				frame.setVisible(true);
				panelEnrollFromCamera.startCapturing ();
			} catch (Throwable e) {
				showError(null, e);
			}
			notify();
		}
	}*/

	public void myDispose () {
		if(panelEnrollFromCamera != null) panelEnrollFromCamera.myDispose();
	}

	private void showError(Component parentComponent, Throwable e) {
		e.printStackTrace();
		String message;
		if (e.getMessage() != null) {
			message = e.getMessage();
		} else if (e.getCause() != null) {
			message = e.getCause().getMessage();
		} else {
			message = "An error occurred. Please see log for more details.";
		}
		JOptionPane.showMessageDialog(parentComponent, message, "Error", JOptionPane.ERROR_MESSAGE);
	}

	public void obtainLicenses(BasePanel panel) {
		try {
			if (!panel.isObtained()) {
				boolean status = FaceTools.getInstance().obtainLicenses(panel.getRequiredLicenses());
				//System.out.println("dasdjaskdjkasjkdjasd::::11???"+status);
				boolean status2 = FaceTools.getInstance().obtainLicenses(panel.getOptionalLicenses());
				//System.out.println("dasdjaskdjkasjkdjasd::::22???"+status2);
				//System.out.println("dasdjaskdjkasjkdjasd::::33???"+panel.getOptionalLicenses().size());
				//panel.getLicensing().setRequiredComponents(panel.getRequiredLicenses());
				//System.out.println("dasdjaskdjkasjkdjasd::::44???"+panel.getRequiredLicenses().size());
				//panel.getLicensing().setOptionalComponents(panel.getOptionalLicenses());
				//System.out.println("dasdjaskdjkasjkdjasd::::55???"+panel.getOptionalLicenses().size());
				panel.updateLicensing(status);
			}
		} catch (Exception e) {
			showError(null, e);
		}
	}
}
