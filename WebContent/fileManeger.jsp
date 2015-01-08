<%@page import="java.text.DecimalFormat"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.File"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="tools.util.sql.SQLWrapper"%>
<%@page import="java.io.*"%>
<!DOCTYPE HTML>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="./css/bootstrap.css" rel="stylesheet" />
		<script type="text/javascript" src="./jquery.js"></script>
		<script type="text/javascript" src="./js/bootstrap.js"></script>
		<script type="text/javascript" src="./js/Chart.js"></script>
		<title>文件管理</title>
	</head>

	<body>

		<div id="wrapper">
			<%@ include file="header.jsp"%>
			<%!double size = 0;
	DecimalFormat df = new DecimalFormat("#.00");

	ArrayList<Boolean> isend = new ArrayList<Boolean>();

	void dfs(JspWriter writer, String path, int level, boolean lastChild)
			throws IOException {
		File cur = new File(path);

		writer.println("<tr>");
		writer.println("<td>");
		for (int i = 0; i < level; i++) {
			if (i == level - 1) {
				if (lastChild)
					writer.println("&nbsp&nbsp&nbsp└");
				else {
					if (isend.get(i) == true)
						writer.println("&nbsp&nbsp&nbsp");
					else
						writer.println("&nbsp&nbsp&nbsp├");
				}
			} else {
				if (isend.get(i) == true)
					writer.println("&nbsp&nbsp&nbsp");
				else
					writer.println("&nbsp&nbsp&nbsp│");
			}
		}

		writer.println(cur.getName());
		writer.println("</td>");
		writer.println("<td>");
		size += ((double) cur.length()) / 1024;
		if (!cur.isDirectory())
			writer.println(df.format(((double) cur.length()) / 1024) + "KB");
		else
			writer.println(" ");

		writer.println("</td>");
		writer.println("</tr>");
		if (!cur.isDirectory())
			return;

		String[] child = cur.list();
		for (int i = 0; i < child.length; i++) {
			if (i != child.length - 1) {
				isend.add(false);
				dfs(writer, cur.getAbsolutePath() + "/" + child[i], level + 1,
						false);
				isend.remove(isend.size() - 1);
			} else {
				isend.add(true);
				dfs(writer, cur.getAbsolutePath() + "/" + child[i], level + 1,
						true);
				isend.remove(isend.size() - 1);
			}
		}
	}%>

			<div class="container">
				<div class="table-responsive">
					<table class="table table-striped table-bordered table-condensed">
						<tr>
							<th>
								路径
							</th>
							<th>
								大小
							</th>
						</tr>
						<%
							String path = "G:\\无障碍培训班视频";
							int level = 0;
							size = 0;
							dfs(out, path, level, true);
						%>


					</table>


					<h2>
						文件夹总大小：<%=df.format(size / 1000 / 1000) + "GB"%>
					</h2>
				</div>
			</div>
		</div>
	</body>
</html>