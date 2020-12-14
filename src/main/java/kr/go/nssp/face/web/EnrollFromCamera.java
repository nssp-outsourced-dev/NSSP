package kr.go.nssp.face.web;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.ComponentOrientation;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.io.IOException;
import java.util.Collections;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.SwingUtilities;

import com.neurotec.biometrics.NBiometricCaptureOption;
import com.neurotec.biometrics.NBiometricStatus;
import com.neurotec.biometrics.NFace;
import com.neurotec.biometrics.NLivenessMode;
import com.neurotec.biometrics.NSubject;
import com.neurotec.biometrics.client.NBiometricClient;
import com.neurotec.biometrics.swing.NFaceView;
import com.neurotec.devices.NCamera;
import com.neurotec.devices.NDevice;
import com.neurotec.devices.NDeviceManager;
import com.neurotec.devices.NDeviceType;
import com.neurotec.util.concurrent.CompletionHandler;

public final class EnrollFromCamera extends BasePanel implements ActionListener {

	// ===========================================================
	// Nested classes
	// ===========================================================

	private static class CameraSelectionListener implements ItemListener {
		@Override
		public void itemStateChanged(ItemEvent e) {
			FaceTools.getInstance().getClient().setFaceCaptureDevice((NCamera) e.getItem());
		}

	}

	// ===========================================================
	// Private static fields
	// ===========================================================

	private static final long serialVersionUID = 1L;

	private static final String PANEL_TITLE = "Enroll from camera";
	private static final String START_CAPTIRIN_BUTTON_TEXT = "캡처 시작";
	private static final String STOP_CAPTURING_BUTTON_TEXT = "캡처 중지";
	private static final String SAVE_TEMPLATE_BUTTON_TEXT = "이미지 저장";

	private int cpurCnt = 0;

	// ===========================================================
	// Private fields
	// ===========================================================

	private final JFileChooser fc;
	private NFaceView view;
	private JPanel panelToolbar;
	private JPanel panelControls;
	private JPanel panelCameras;
	private JPanel panelCameraControls;
	private JButton btnSaveTemplate;
	private JButton btnStartCapturing;
	private JButton btnStopCapturing;
	private JComboBox comboBoxCameras;
	private JScrollPane scrollPane;
	private JLabel lblStatus;
	private JPanel panelSouthPanel;

	private NSubject subject;
	private boolean capturing;
	private final NDeviceManager deviceManager;

	private final CaptureCompletionHandler captureCompletionHandler = new CaptureCompletionHandler();

	// ===========================================================
	// Public constructor
	// ===========================================================

	public EnrollFromCamera() {
		super();
		this.setName(PANEL_TITLE);

		requiredLicenses.add("Biometrics.FaceSegmentation"); //for liveness checking
		requiredLicenses.add("Biometrics.FaceExtraction");
		requiredLicenses.add("Devices.Cameras");

		FaceTools.getInstance().getClient().setUseDeviceManager(true);
		deviceManager = FaceTools.getInstance().getClient().getDeviceManager();
		deviceManager.setDeviceTypes(EnumSet.of(NDeviceType.CAMERA));
		deviceManager.initialize();
		fc = new JFileChooser();
	}

	// ===========================================================
	// Private methods
	// ===========================================================

	private void updateCamerasList() {
		DefaultComboBoxModel model = (DefaultComboBoxModel) comboBoxCameras.getModel();
		model.setSelectedItem(null);
		model.removeAllElements();
		for (NDevice device : deviceManager.getDevices()) {
			model.addElement(device);
		}
		NCamera camera = FaceTools.getInstance().getClient().getFaceCaptureDevice();
		if ((camera == null) && (model.getSize() > 0)) {
			comboBoxCameras.setSelectedIndex(0);
		} else if (camera != null) {
			model.setSelectedItem(camera);
		}
	}

	@Override
	protected void startCapturing() {
		if (FaceTools.getInstance().getClient().getFaceCaptureDevice() == null) {
			JOptionPane.showMessageDialog(this, "Please select camera from the list.", "No camera selected", JOptionPane.PLAIN_MESSAGE);

			/*
			 * 메세지창 확인 위해 잠시 대기
			 * */
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}

			myDispose();
			return;
		}
		// Set face capture from stream.
		NFace face = new NFace();
		EnumSet<NBiometricCaptureOption> options = EnumSet.of(NBiometricCaptureOption.STREAM);
		FaceTools.getInstance().getClient().setFacesLivenessMode(NLivenessMode.NONE);
		face.setCaptureOptions(options);
		subject = new NSubject();
		subject.getFaces().add(face);
		view.setFace(face);

		// Begin capturing.
		capturing = true;
		FaceTools.getInstance().getClient().capture(subject, null, captureCompletionHandler);

		System.out.println("das54d5a3d1sa21d2a1d2a::::" + subject);
		updateControls();
	}

	private void stopCapturing() {
		FaceTools.getInstance().getClient().cancel();
	}

	private void saveTemplate() throws IOException {
		if (subject != null) {
			//setImage(subject.getFaces().get(0).getImage().save().toByteArray());
			setImage(subject.getTemplateBuffer().toByteArray());

			/*
			 * 캡처사진 잠시 확인 - 1초 후 닫기
			 * */
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}

			myDispose();
		}
	}

	// ===========================================================
		// Package private methods
		// ===========================================================

	void updateStatus(String status) {
		lblStatus.setText(status);

		//"Quality: %d", (subject.getFaces().get(0).getObjects().get(0).getQuality() & 0xFF)
		//점수가 몇점 이상일 경우에만 저장??

		if (status.equals("OK")){
			try {
				saveTemplate ();
			} catch (Exception e) {
				e.printStackTrace();
				JOptionPane.showMessageDialog(this, e.toString(), "Error", JOptionPane.ERROR_MESSAGE);
			}

		} else {
			if(cpurCnt == 10) {
				myDispose();
			}
			cpurCnt ++;
		}
	}

	// ===========================================================
	// Protected methods
	// ===========================================================

	@Override
	protected void initGUI() {
		setLayout(new BorderLayout());
		{
			panelToolbar = new JPanel();
			panelToolbar.setLayout(new BoxLayout(panelToolbar, BoxLayout.Y_AXIS));
			add(panelToolbar, BorderLayout.PAGE_START);
			{
				//licensing = new LicensingPanel(requiredLicenses, Collections.<String>emptyList());
				//panelToolbar.add(licensing);
			}
			{
				panelControls = new JPanel();
				panelControls.setLayout(new FlowLayout(FlowLayout.LEFT));
				panelControls.setBorder(BorderFactory.createLineBorder(Color.BLACK));
				panelControls.setComponentOrientation(ComponentOrientation.LEFT_TO_RIGHT);
				panelToolbar.add(panelControls);
				{
					panelCameras = new JPanel();
					panelCameras.setLayout(new BorderLayout());
					panelCameras.setPreferredSize(new Dimension(560, 75));
					panelCameras.setBorder(BorderFactory.createTitledBorder("Cameras"));
					panelControls.add(panelCameras);
					{
						comboBoxCameras = new JComboBox();
						comboBoxCameras.addItemListener(new CameraSelectionListener());
						panelCameras.add(comboBoxCameras, BorderLayout.PAGE_START);
					}
					{
						panelCameraControls = new JPanel(new FlowLayout(FlowLayout.LEADING));
						panelCameras.add(panelCameraControls, BorderLayout.CENTER);
						{
							btnStartCapturing = new JButton(START_CAPTIRIN_BUTTON_TEXT);
							btnStartCapturing.addActionListener(this);
							panelCameraControls.add(btnStartCapturing);
						}
						{
							btnStopCapturing = new JButton(STOP_CAPTURING_BUTTON_TEXT);
							//btnStopCapturing.addActionListener(this);
							//panelCameraControls.add(btnStopCapturing);
						}
						{
							btnSaveTemplate = new JButton(SAVE_TEMPLATE_BUTTON_TEXT);
							//btnSaveTemplate.addActionListener(this);
							//panelCameraControls.add(btnSaveTemplate);
						}
					}
				}
			}
		}
		{
			view = new NFaceView();
			view.setAutofit(true);
			scrollPane = new JScrollPane();
			scrollPane.setViewportView(view);
			add(scrollPane, BorderLayout.CENTER);
		}
		{
			panelSouthPanel = new JPanel();
			panelSouthPanel.setLayout(new BorderLayout());
			add(panelSouthPanel, BorderLayout.PAGE_END);
				{
					lblStatus = new JLabel();
					lblStatus.setPreferredSize(new Dimension(100, 20));
					panelSouthPanel.add(lblStatus);
				}
		}

		updateCamerasList();
	}

	@Override
	protected void updateControls() {
		comboBoxCameras.setEnabled(!capturing);
		btnStartCapturing.setEnabled(!capturing);
		btnStopCapturing.setEnabled(capturing);
	}

	@Override
	protected void updateFacesTools() {
		NBiometricClient client = FaceTools.getInstance().getClient();
		client.setUseDeviceManager(true);
	}

	// ===========================================================
	// Package private methods
	// ===========================================================
	NSubject getSubject() {
		return subject;
	}

	// ===========================================================
	// Public methods
	// ===========================================================

	@Override
	public void actionPerformed(ActionEvent ev) {
		try {
			if (ev.getSource().equals(btnStartCapturing)) {
				startCapturing();
			} else if (ev.getSource().equals(btnStopCapturing)) {
				stopCapturing();
			} else if (ev.getSource().equals(btnSaveTemplate)) {
				saveTemplate();
			}
		} catch (Exception e) {
			e.printStackTrace();
			JOptionPane.showMessageDialog(this, e.toString(), "Error", JOptionPane.ERROR_MESSAGE);
		}
	}

	@Override
	public void onDestroy() {
		deviceManager.dispose();
	}

	@Override
	public void onClose() {
		stopCapturing();
	}

	// ===========================================================
	// Inner classes
	// ===========================================================


	private class CaptureCompletionHandler implements CompletionHandler<NBiometricStatus, Object> {

		@Override
		public void completed(final NBiometricStatus result, final Object attachment) {
			SwingUtilities.invokeLater(new Runnable() {

				@Override
				public void run() {
					capturing = false;
					updateStatus (result.toString());
					if ((result == NBiometricStatus.OK) || (result == NBiometricStatus.CANCELED)) { // Finished successfully or stop button was pressed.
						updateControls();
					} else {
						// Template creation failed, so start capturing again.
						getSubject().getFaces().get(0).setImage(null);
						FaceTools.getInstance().getClient().capture(getSubject(), null, captureCompletionHandler);
					}
				}

			});
		}

		@Override
		public void failed(final Throwable th, final Object attachment) {
			SwingUtilities.invokeLater(new Runnable() {

				@Override
				public void run() {
					capturing = false;
					showError(th);
					updateControls();
				}

			});
		}

	}

	@Override
	protected void setDefaultValues() {
		// TODO Auto-generated method stub

	}

}
