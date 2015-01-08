<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="tools.util.sql.SQLWrapper"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>数据库清洗结果</title>
</head>
<body>
	<%@include file="header.jsp"%>
	<div class="container">
		<div class="row">
			<div class="col-md-0"></div>
			<!-- begin of left pane -->
			<div class="col-md-12"></div>
			<%
				if (request.getMethod().equals("POST")) {
					String[] rowSelect = request.getParameterValues("rowSelect");
					if (rowSelect == null) {
						out.println("<p class=\"bg-danger\">未选择要删除的行！</p>");
					} else {
						SQLWrapper sqlWrapper = (SQLWrapper) session
								.getAttribute("sqlwrapper");
						ArrayList<ArrayList<String>> dirty = sqlWrapper.findDirty(
								sqlWrapper.dbname, 10);
						for (int i = 0; i < rowSelect.length; i++) {
							sqlWrapper.deleteRow(sqlWrapper.dbname, dirty.get(i));
						}
			%>
			<p class="bg-success">删除了如下行：</p>
			<table class="table table-striped table-bordered table-condensed">
				<%
					for (int i = 0; i < rowSelect.length; i++) {
				%>
				<tr>
					<%
						for (int j = 0; j < dirty.get(0).size(); j++) {
					%>
					<td><%=dirty.get(i).get(j)%></td>
					<%
						}
					%>
				</tr>
				<%
					}
						}
				%>
			</table>
			<%
				}
			%>
		</div>
	</div>

</body>
</html>