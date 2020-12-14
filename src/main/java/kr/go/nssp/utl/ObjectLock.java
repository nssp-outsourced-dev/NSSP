package kr.go.nssp.utl;

import java.util.HashMap;
import java.util.Timer;
import java.util.TimerTask;

public class ObjectLock {

	private static ObjectLock instance;
	private HashMap<String, BioData> map;

	public BioData getMap(String key) {
		return map.get(key);
	}

	public void setMap(String key, BioData value) {
		//해당 쿠키로 생성된 data가 있는지 확인
		if(getMap(key) != null) stopLock (key);
		this.map.put(key, value);
	}

	static {
		if(instance == null) instance = new ObjectLock ();
	}

	public ObjectLock () {
		map = new HashMap<String, BioData>();
	}

	public static ObjectLock getInstance() {
		return instance;
	}

	public void startLock (String key) {
		final String strKey = key;
		synchronized (map.get(key)) {
			try {
				Timer mtm = new Timer ();
				mtm.schedule(new TimerTask() {
					@Override
					public void run() {
						if(map.get(strKey) != null) {
							System.out.println(">>> 여기에서는 LOCK을 자동으로 풀어줍니다 >>>> timeout 100초 >>>>");
							stopLock (strKey);
						}
					}
				}, 100000);
				map.get(key).wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

	public void stopLock(String key) {
		BioData bd = map.get(key);
		synchronized (bd) {
			map.remove(key);
			bd.notify();
		}
	}
}
