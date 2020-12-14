package kr.go.nssp.utl;

public class BioData {

	private String id;				//클라이언트와의 통신 id
    private String message;			//메세지
    private byte[] by;				//bio 정보
    private String height;			//finger 사진 높이
    private String width;			//finger 사진 넓이
    private boolean bchk;			//bio 정보 여부
    private boolean chkTimeout;		//클라이언트 timeout

	public boolean isChkTimeout() {
		return chkTimeout;
	}

	public void setChkTimeout(boolean chkTimeout) {
		this.chkTimeout = chkTimeout;
	}

	public boolean isBchk() {
		return bchk;
	}

	public void setBchk(boolean bchk) {
		this.bchk = bchk;
	}

	public String getHeight() {
		return height;
	}

	public void setHeight(String height) {
		this.height = height;
	}

	public String getWidth() {
		return width;
	}

	public void setWidth(String width) {
		this.width = width;
	}

	public byte[] getBy() {
		return by;
	}

	public void setBy(byte[] by) {
		this.by = by;
	}

	public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    @Override
    public String toString () {
        return "Message [Id= " + id + ", Message= " + message + "]";
    }
}