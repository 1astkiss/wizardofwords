<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" 
content="width=device-width, initial-scale=1, maximum-scale=1, 
minimum-scale=1, user-scalable=no, target-densitydpi=medium-dpi">
<link rel="stylesheet" href="css/styles.css" type="text/css"
	media="screen" />
<title>Add a new word</title>
<style>
h2 {
	text-align:center;
	width: 100%;
	/*line-height: 50px;
	background: #333;
	color: #fff;
	*/
}

table {
	margin: auto;
}
</style>
</head>
<body>
	<header>
		<h1>W<span class="tiny_font">izard </span>O<span class="tiny_font">f &nbsp;</span> W<span class="tiny_font">ords</span></h1>
	</header>

	<div>
		<hr>
		<h2>Add a new word here</h2>
		<hr>
		<form name="add_question" method="post"	action="words_control.jsp">
			<input type="hidden" name="action" value="add">
			<table id="question_table">
				<tr>
					<td id="table_head" colspan="2"><textarea class="ta_word" name="word"
							placeholder="new word here...." required></textarea></td>
				</tr>
				<tr>
					<td class="select 1">( 1 )</td>
					<td><textarea name="selection1" class="ta_selection"
							placeholder="first selection here..." required></textarea>
					</td>
				</tr>
				<tr>
					<td class="select 2">( 2 )</td>
					<td><textarea name="selection2" class="ta_selection"
							placeholder="second selection here..." required></textarea></td>
				</tr>
				<tr>
					<td class="select 3">( 3 )</td>
					<td><textarea name="selection3" class="ta_selection"
							placeholder="third selection here..." required></textarea></td>
				</tr>
				<tr>
					<td class="select 4">( 4 )</td>
					<td><textarea name="selection4" class="ta_selection"
							placeholder="fourth selection here..." required></textarea></td>
				</tr>
				<tr>
					<td style="font-size:1.2em">Answer</td>
					<td><input id="radio1" type="radio" name="answer" value="1" checked><label for="radio1">(1)&nbsp; </label>
					<input id="radio2" type="radio" name="answer" value="2"><label for="radio2">(2)&nbsp;</label> 
					<input id="radio3" type="radio" name="answer" value="3"><label for="radio3">(3)&nbsp;</label> 
					<input id="radio4" type="radio" name="answer" value="4"><label for="radio4">(4)</label> </td>
				</tr>
				<tr>
					<td colspan="2" align="center"><input type="submit"
						value="Add"> <input type="button"
						value="Home" onclick="document.location.href='words_main.jsp'" ></td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>