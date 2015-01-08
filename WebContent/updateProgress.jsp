<%@page import="tools.util.RetValue"%>
<%@page import="java.util.Enumeration"%>
<%@page import="tools.util.sql.SQLWrapper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="tools.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="./css/bootstrap.css" rel="stylesheet" />
		<script type="text/javascript" src="./js/jquery.js"></script>
		<script type="text/javascript" src="./js/bootstrap.js"></script>
		<title>数据库更新进度</title>

	</head>
	<body onload="loop()">

		<%
			boolean set = false;
			int rowCount = 0;
			if (session.getAttribute("sqlwrapper") == null) {
				response.sendRedirect("/dbutil/index.jsp");
			} else {
				SQLWrapper sqlWrapper = (SQLWrapper) session
						.getAttribute("sqlwrapper");
				rowCount = sqlWrapper.getRowCount();
				set = true;
			}
		%>

		<div class="container">
			<div class="progress progress-striped active">
				<div class="progress-bar progress-bar-success" role="progressbar"
					aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"
					style="width: 0%;" id="progressBar">
					<span class="sr-only"></span>
				</div>
			</div>
			<div id="progressValue">
			</div>
		</div>
	</body>
	<script type="text/javascript">
	var bar = document.getElementById("progressBar");
	var xmlhttp;
	var url;
	function cfun() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
			var resp = xmlhttp.responseText.split(" ", 2);
			var progress = resp[0];
			var total = resp[1];

			bar.style.width = parseFloat(progress) / parseFloat(total) * 100
					+ "%";
			document.getElementById("progressValue").innerHTML = progress + "/"
					+ total;
		}
	}
	function loop() {

		xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange = cfun;

		url = "/dbutil/servlet/UpdateProgress?timestamp="
				+ new Date().getTime();
		//url = "/dbutil/servlet/UpdateProgress";
		xmlhttp.open("GET", url, true);
		xmlhttp.send(null);
	}

	setInterval(loop, 500);
</script>



</html>