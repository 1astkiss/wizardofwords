package words.question;

public class Reply {
	
	// 답글 id
	private int rid;
	
	// 게시문 id
	private int mid;
	
	// 답글 작성자
	private String uid;
	
	// 답글 내용
	private String rmsg;
	
	// 답글 작설일시
	private String date;

	public int getRid() {
		return rid;
	}

	public void setRid(int rid) {
		this.rid = rid;
	}

	public int getMid() {
		return mid;
	}

	public void setMid(int mid) {
		this.mid = mid;
	}

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getRmsg() {
		return rmsg;
	}

	public void setRmsg(String rmsg) {
		this.rmsg = rmsg;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

}
