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
		<title>康复机构地址拆分</title>
	</head>
	<body>
		<!-- begin of nav -->
		<%
			session.setAttribute("pageNum", 3);
		%>
		<%@include file="header.jsp"%>
		<!-- end of nav -->

		<div class="container">
			<%
				boolean set = true;
				ArrayList<String> colList;
				if (session.getAttribute("sqlwrapper") == null) {
					set = false;
					colList = null;
					response.sendRedirect("/dbutil/index.jsp");
				} else {
					SQLWrapper sqlWrapper = (SQLWrapper) session
							.getAttribute("sqlwrapper");
					colList = sqlWrapper.getColumnList(sqlWrapper.dbname);
				}
			%>

			<%
				if (set) {
			%>
			<form action="update.jsp" method="post" role="form"
				onsubmit="window.open('/dbutil/updateProgress.jsp','','height=100, width=250,toolbar=no,scrollbars=no,menubar=no,location=no')">
				<table class="table table-striped table-bordered">
					<tbody>
						<tr>
							<th colspan="2">
								设置更新条件
							</th>
						</tr>
						<tr>
							<td>
								请选择更新的列：
								<br />
								被选择的列将作为地址使用，以获得省市信息，经纬度等
								<br />
								按住ctrl键多选
							</td>
							<td>
								<select multiple class="form-control" size="5"
									name="UpdateColumn">
									<%
										for (int i = 0; i < colList.size(); i++) {
												out.println("<option value=\"" + colList.get(i) + "\">"
														+ colList.get(i) + "</option>");
											}
									%>
								</select>
							</td>
						</tr>
						<tr>
							<td>
								是否更新省市？
							</td>
							<td>
								<div class="radio">
									<label>
										<input type="radio" name="UpdateProCity" value="YES"
											checked="checked">
										Yes
									</label>
								</div>

								<div class="radio">
									<label>
										<input type="radio" name="UpdateProCity" value="NO">
										No
									</label>
								</div>
							</td>
						</tr>

						<tr>
							<td>
								是否更新经纬度？
							</td>
							<td>
								<div class="radio">
									<label>
										<input type="radio" name="UpdateLngLat" value="YES"
											checked="checked">
										Yes
									</label>
								</div>

								<div class="radio">
									<label>
										<input type="radio" name="UpdateLngLat" value="NO">
										No
									</label>
								</div>
							</td>
						</tr>

						<tr>
							<td></td>
							<!-- submit button -->
							<td>
								<input type="submit" class="btn btn-primary" value="提交"
									onclick="(function(){return false;})">
							</td>
						</tr>
					</tbody>
				</table>
			</form>
			<%
				}
			%>
			<%
				if (request.getMethod().equals("POST")) {
					String[] usecol = request.getParameterValues("UpdateColumn");
					if (session.getAttribute("sqlwrapper") == null) {
						out.println("<a class=\"btn btn-primary btn-lg\" role=\"button\" href=\"setting.jsp\">开始前，请先设置数据库参数</a>");
					} else if (usecol == null) {
						out.println("<p class=\"text-danger\">请选择地址对应的列</p>");
					} else {
						SQLWrapper sqlWrapper = (SQLWrapper) session
								.getAttribute("sqlwrapper");
						boolean procity = request.getParameter("UpdateProCity")
								.equals("YES");
						boolean longlat = request.getParameter("UpdateLngLat")
								.equals("YES");
						RetValue<Integer, Integer, String> ret = sqlWrapper
								.updateProCityLongLat(sqlWrapper.dbname, usecol,
										procity, longlat);
						String sql;
						if (procity)
							sql = "select * from " + sqlWrapper.dbname
									+ " where Province is null";
						else
							sql = "select * from " + sqlWrapper.dbname
									+ " where longitude is null";
						ArrayList<ArrayList<String>> table = sqlWrapper
								.executeQuery(sql, sqlWrapper.nbline);
			%>
			<h3 class="bg-success">
				总条目为<%=ret.v1%>，更新了<%=ret.v2%>条目，数据库名称为：<%=ret.v3%></h3>
			<p class="bg-primary">
				未成功更新的行如下：
			</p>
			<table class="table table-striped">
				<tr>
					<%
						for (int i = 0; i < table.get(0).size(); i++) {
									out.println("<th>" + table.get(0).get(i) + "</th> ");
								}
					%>
				</tr>
				<%
					for (int i = 1; i < table.size(); i++) {
								out.println("<tr>");
								for (int j = 0; j < table.get(0).size(); j++) {
									out.println("<td>" + table.get(i).get(j) + "</td>");
								}
								out.println("</tr>");
							}
				%>
			</table>

			<%
				}
				}
			%>
		</div>

	</body>

</html>