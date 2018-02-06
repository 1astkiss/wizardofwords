package words.question;

public class Question {

	// 문제 id
	private int question_id;
	
	// 문제 생성일
	private String date;
	
	// 문제 생성자
	private String creator_id;
	
	// 문제의 단어
	private String word;
	
	// 1번 예문
	private String selection1;
	
	// 2번 예문
	private String selection2;
	
	// 3번 예문
	private String selection3;
	
	// 4번 예문
	private String selection4;
	
	// 정답
	private int answer;
	
	// 가중치
	private double weight;
	
	// 상태 (active/inactive)
	private int status;

	public int getQuestion_id() {
		return question_id;
	}

	public void setQuestion_id(int question_id) {
		this.question_id = question_id;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getCreator_id() {
		return creator_id;
	}

	public void setCreator_id(String creator_id) {
		this.creator_id = creator_id;
	}

	public String getWord() {
		return word;
	}

	public void setWord(String word) {
		this.word = word;
	}

	public String getSelection1() {
		return selection1;
	}

	public void setSelection1(String selection1) {
		this.selection1 = selection1;
	}

	public String getSelection2() {
		return selection2;
	}

	public void setSelection2(String selection2) {
		this.selection2 = selection2;
	}

	public String getSelection3() {
		return selection3;
	}

	public void setSelection3(String selection3) {
		this.selection3 = selection3;
	}

	public String getSelection4() {
		return selection4;
	}

	public void setSelection4(String selection4) {
		this.selection4 = selection4;
	}

	public int getAnswer() {
		return answer;
	}

	public void setAnswer(int answer) {
		this.answer = answer;
	}

	public double getWeight() {
		return weight;
	}

	public void setWeight(double weight) {
		this.weight = weight;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}
		
}
