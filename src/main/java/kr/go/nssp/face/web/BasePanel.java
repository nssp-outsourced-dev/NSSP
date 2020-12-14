package kr.go.nssp.face.web;

import java.util.ArrayList;
import java.util.List;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

import com.neurotec.lang.NCore;
import com.neurotec.util.concurrent.AggregateExecutionException;

public abstract class BasePanel extends JPanel {

	// ===========================================================
	// Private static fields
	// ===========================================================

	private static final long serialVersionUID = 1L;

	// ===========================================================
	// Protected fields
	// ===========================================================

	//protected LicensingPanel licensing;
	protected final List<String> requiredLicenses = new ArrayList<String>();
	protected final List<String> optionalLicenses = new ArrayList<String>();
	protected boolean obtained;
	private byte[] by;
	private JFrame frame;

	public byte[] getByteImg () {
		return this.by;
	}
	public void setByteImg () {
		this.by = new byte[0];
	}

	// ===========================================================
	// Public methods
	// ===========================================================

	public void init(JFrame frame) {
		this.frame = frame;
		initGUI();
		setDefaultValues();
		updateControls();
	}
	/*public void startCapturingBs () {
		startCapturing ();
	}*/

	public final List<String> getRequiredLicenses() {
		return requiredLicenses;
	}

	public final List<String> getOptionalLicenses() {
		return optionalLicenses;
	}

	//public final LicensingPanel getLicensing() {
	//	return licensing;
	//}

	public final void updateLicensing(boolean status) {
		//licensing.setComponentObtainingStatus(status);
		obtained = status;
	}

	public boolean isObtained() {
		return obtained;
	}

	public void setImage (byte[] by) {
		System.out.println("dasjkdjaskdjsadkas::::"+by.length);
		this.by = by;
	}

	public void showError(Throwable e) {
		e.printStackTrace();
		if (e instanceof AggregateExecutionException) {
			StringBuilder sb = new StringBuilder(64);
			sb.append("Execution resulted in one or more errors:\n");
			for (Throwable cause : ((AggregateExecutionException) e).getCauses()) {
				sb.append(cause.toString()).append('\n');
			}
			JOptionPane.showMessageDialog(this, sb.toString(), "Execution failed", JOptionPane.ERROR_MESSAGE);
		} else {
			JOptionPane.showMessageDialog(this, e, "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	public void showError(String message) {
		if (message == null) throw new NullPointerException("message");
		JOptionPane.showMessageDialog(this, message);
	}

	public void myDispose () {
		if(this != null) this.onDestroy();
		if(getByteImg() == null) setByteImg ();
		if(this.frame != null) this.frame.dispose();
		//NCore.shutdown();  - 하고 나면 재시작이 안됨
	}

	// ===========================================================
	// Abstract methods
	// ===========================================================

	protected abstract void initGUI();
	protected abstract void setDefaultValues();
	protected abstract void updateControls();
	protected abstract void updateFacesTools();
	protected abstract void startCapturing();

	public abstract void onDestroy();
	public abstract void onClose();
}
