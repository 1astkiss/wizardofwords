package words.question;

public class MemberWordHistory {
	
	private int history_id;
	private String member_id;
	private int member_level;
	private int question_id;
	private String date_created;
	private int count_tried;
	private double weight;
	private double score;
	public double getScore() {
		return score;
	}
	public void setScore(double score) {
		this.score = score;
	}
	public double getWeight() {
		return weight;
	}
	public void setWeight(double weight) {
		this.weight = weight;
	}
	public int getHistory_id() {
		return history_id;
	}
	public void setHistory_id(int history_id) {
		this.history_id = history_id;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public int getMember_level() {
		return member_level;
	}
	public void setMember_level(int member_level) {
		this.member_level = member_level;
	}
	public int getQuestion_id() {
		return question_id;
	}
	public void setQuestion_id(int question_id) {
		this.question_id = question_id;
	}
	public String getDate_created() {
		return date_created;
	}
	public void setDate_created(String date_created) {
		this.date_created = date_created;
	}
	public int getCount_tried() {
		return count_tried;
	}
	public void setCount_tried(int count_tried) {
		this.count_tried = count_tried;
	}
	
}
