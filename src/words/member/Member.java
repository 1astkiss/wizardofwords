package words.member;

import java.util.Date;

public class Member {

	// 회원 아이디(로그인용)
	private String member_id;

	private String passwd;
	
	// 회원명
	private String nickname;
	
	
	private String email;
	
	// 가입일
	private Date date;
	
	// 출생년도
	private int birth_year;
	
	// 회원의 현재 수준
	private int member_level;
	
	// 회원의 현재 상태(active/inactive)
	private int status;
	
	// 문제 출제권한 여부(1:yes, 0:no)
	private int can_make_question;

	public String getMember_id() {
		return member_id;
	}

	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}

	public String getPasswd() {
		return passwd;
	}

	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public int getBirth_year() {
		return birth_year;
	}

	public void setBirth_year(int birth_year) {
		this.birth_year = birth_year;
	}

	public int getMember_level() {
		return member_level;
	}

	public void setMember_level(int member_level) {
		this.member_level = member_level;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getCan_make_question() {
		return can_make_question;
	}

	public void setCan_make_question(int can_make_question) {
		this.can_make_question = can_make_question;
	}

	
}
