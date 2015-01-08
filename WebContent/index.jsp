<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="tools.util.sql.SQLWrapper"%>
<%@page import="java.net.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>残疾人康复信息采集与交换系统</title>
	</head>
	<body>
		<div id="wrapper">
			<!--顶部BAR-->
			<!-- top begin -->
			<%
				boolean set = true;
				if (session.getAttribute("sqlwrapper") == null)
					set = false;
				session.setAttribute("pageNum", 0);
				// don't set active, 1 for duplicate.jsp, 2 for clean.jsp,
			%>

			<%@ include file="header.jsp"%>




			<div class="container">
				<div class="jumbotron">
					<h2>
						残疾人康复信息采集与交换系统
					</h2>
					<h4>
						一个跨平台的轻量级数据库管理系统，提供了去重，更新，增删等数据库常用功能。
					</h4>
					<%
						if (!set) {
					%>
					<p>
						<a class="btn btn-primary btn-lg" href="setting.jsp">开始前，请先设置数据库参数</a>
					</p>
					<%
						}
					%>
				</div>
			</div>
		</div>
	</body>
	<%
		String remoteIP;
		if (request.getHeader("x-forwarded-for") == null)
			remoteIP = request.getRemoteAddr();
		else
			remoteIP = request.getHeader("x-forwarded-for");

		URLConnection connection = new URL(
				"http://10.214.51.14:8089/stats/count?type=dbutil_visit&ip="
						+ remoteIP).openConnection();
		InputStream input = connection.getInputStream();
		InputStreamReader reader = new InputStreamReader(input);
		char[] buf = new char[1024];
		reader.read(buf);
		/*out.write("http://10.214.51.14:8089/stats/count?type=dbutil_visit&ip="
				+ remoteIP);
		out.write(buf);*/
	%>
</html>