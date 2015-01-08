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
		<link rel="stylesheet" href="./css/bootstrap.css">
		<script type="text/javascript" src="./js/jquery.js"></script>
		<script type="text/javascript" src="./js/bootstrap.js"></script>

		<link href="css/app.css" rel="stylesheet">
		<title>数据库去重</title>
	</head>
	<body>
		<!-- begin of nav -->
		<%
			session.setAttribute("pageNum", 1);
		%>
		<%@include file="header.jsp"%>
		<!-- end of nav -->

		<div class="container">
			<div class="row">
				<div class="col-md-0"></div>
				<!-- begin of left pane -->
				<div class="col-md-12">
					<!-- start here -->
					<%
						/*ArrayList<String> colList = SQLWrapper
																		.getColumnList(SQLWrapper.dbname);*/
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
					<form action="duplicate.jsp" method="post" role="form"  onsubmit="window.open('/dbutil/updateProgress.jsp','','height=100, width=250,toolbar=no,scrollbars=no,menubar=no,location=no')">
						<table class="table table-striped table-bordered">
							<tbody>
								<tr>
									<th colspan="2">
										设置去重条件
									</th>
								</tr>
								<tr>
									<td>
										请选择去重的列：
										<br />
										按住ctrl键多选
									</td>
									<td>
										<select multiple class="form-control" size="5"
											name="DupRemColumn">
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
										请选择去重逻辑：
										<br />
										“与”表示所选列都相同时认为两行数据相同
										<br />
										“或”表示所选列有一个相同即认为两行数据相同
									</td>
									<td>
										<div class="radio">
											<label>
												<input type="radio" name="DupRemLogic" value="and"
													checked="checked">
												与
											</label>
										</div>

										<div class="radio">
											<label>
												<input type="radio" name="DupRemLogic" value="or">
												或
											</label>
										</div>
									</td>
								</tr>

								<tr>
									<td>
										请选择更新逻辑：
										<br />
										“删除”表示删除重复数据
										<br />
										“合并”表示合并相同数据
									</td>
									<td>
										<div class="radio">
											<label>
												<input type="radio" name="UpdateLogic" value="delete"
													checked="checked">
												删除
											</label>
										</div>

										<div class="radio">
											<label>
												<input type="radio" name="UpdateLogic" value="merge">
												合并
											</label>
										</div>
									</td>
								</tr>



								<tr>
									<td></td>
									<td>
										<input type="submit" class="btn btn-primary" value="提交">
									</td>
								</tr>
							</tbody>
						</table>
					</form>
					<%
						}
					%>

					<%
						//显示去重结果
						if (request.getMethod().equals("POST")) {
							String[] dupcol = request.getParameterValues("DupRemColumn");
							if (session.getAttribute("sqlwrapper") == null) {
								out.println("<a class=\"btn btn-primary btn-lg\" role=\"button\" href=\"setting.jsp\">开始前，请先设置数据库参数</a>");
							} else if (dupcol == null) {
								out.println("<p class=\"text-danger\">请选择去重的列</p>");
							} else {
								// do dup remove
								SQLWrapper sqlWrapper = (SQLWrapper) session
										.getAttribute("sqlwrapper");
								RetValue<Integer, Integer, String> ret = null;
								boolean merge;
								if (request.getParameter("UpdateLogic").equals("merge")) {
									merge = true;
									if (request.getParameter("DupRemLogic").equals("and"))
										ret = sqlWrapper.dupRemMergeAnd(sqlWrapper.dbname,
												dupcol);
									else
										ret = sqlWrapper.dupRemMergeOrDisjointSet(
												sqlWrapper.dbname, dupcol);
								} else {
									merge = false;
									if (request.getParameter("DupRemLogic").equals("or"))
										ret = sqlWrapper.dupRemDeleteOr(sqlWrapper.dbname,
												dupcol);
									else
										ret = sqlWrapper.dupRemDeleteAnd(sqlWrapper.dbname,
												dupcol);
								}
								//display  result
								int total = ret.v1;
								int dup = ret.v2;
								String dbname = ret.v3;
								ArrayList<ArrayList<String>> table = sqlWrapper
										.executeQuery("select * from " + dbname,
												sqlWrapper.nbline);
					%>
					<%
						if (merge) {
					%>
					<h3 class="bg-success">
						总条目为<%=total%>，合并了<%=dup%>条目，数据库名称为：<%=dbname%></h3>
					<%
						} else {
					%>
					<h3 class="bg-success">
						总条目为<%=total%>，删除了<%=dup%>条目，删除数据备份数据库名称为：<%=dbname%></h3>
					<%
						}
					%>
					<p>
						合并或删除的数据列表如下：
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
				<!-- end of leftpane -->
			</div>
		</div>
	</body>

</html>