package words.question;

import java.util.ArrayList;

public class MessageSet {

	// 게시문 내용
	private Question message;
	
	// 게시문의 댓글 목록
	private ArrayList<Reply> rlist = new ArrayList<Reply>();

	public Question getMessage() {
		return message;
	}

	public void setMessage(Question message) {
		this.message = message;
	}

	public ArrayList<Reply> getRlist() {
		return rlist;
	}

	public void setRlist(ArrayList<Reply> rlist) {
		this.rlist = rlist;
	}
	
}
