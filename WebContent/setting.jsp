<%@page import="tools.util.sql.SQLWrapper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<title>设置</title>
	</head>
	<body>
		<!-- begin of nav -->
		<%
			session.setAttribute("pageNum", 0);
		%>
		<%@include file="header.jsp"%>
		<!-- end of nav -->

		<!-- begin of container -->
		<div class="container">
			<div class="row">
				<!-- begin of sidebar -->
				<div class="col-md-3">
					<div class="list-group">
						<ul class="nav nav-stacked">
							<li class="active">
								<a href="#dbparamform">数据库参数</a>
							</li>
							<li>
								<a href="#nbline">显示设置</a>
						</ul>
					</div>
				</div>
				<!-- end of sidebar -->

				<!-- begin of right -->
				<div class="col-md-9">
					<%
						boolean submitsuccess = false;
						if (request.getMethod().equals("POST")) {
							String dbType = request.getParameter("dbType");
							String dburl_ip = request.getParameter("dburl_ip");
							String dburl_port = request.getParameter("dburl_port");
							String dburl_schema = request.getParameter("dburl_schema");
							String dbname = request.getParameter("dbname");
							String username = request.getParameter("username");
							String password = request.getParameter("password");
							String nbline = request.getParameter("nbline");

							SQLWrapper sqlWrapper = new SQLWrapper(dbType, dburl_ip,
									dburl_port, dburl_schema, dbname, username, password,
									Integer.parseInt(nbline));
							sqlWrapper.testConnection();
							session.setAttribute("sqlwrapper", sqlWrapper);

							submitsuccess = true;
						}
					%>
					<form action="setting.jsp" method="post" role="form"
						id="dbparamform">
						<%
							String dbType_form, dburl_ip_form, dburl_port_form, dburl_schema_form, username_form, password_form, dbname_form;
							int nbline_form;
							if (session.getAttribute("sqlwrapper") != null) {
								SQLWrapper sqlWrapper = (SQLWrapper) session
										.getAttribute("sqlwrapper");
								dbType_form = sqlWrapper.dbTypeString;
								dburl_ip_form = sqlWrapper.dburl_ip;
								dburl_port_form = sqlWrapper.dburl_port;
								dburl_schema_form = sqlWrapper.dburl_schema;
								username_form = sqlWrapper.username;
								password_form = sqlWrapper.password;
								dbname_form = sqlWrapper.dbname;
								nbline_form = sqlWrapper.nbline;
							} else {
								dbType_form = "";
								dburl_ip_form = "";
								dburl_port_form = "";
								dburl_schema_form = "";
								username_form = "";
								password_form = "";
								dbname_form = "";
								nbline_form = 10;
							}
						%>


						<div class="form-group" onclick="setDefault()">
							<h4>
								数据库类型：
							</h4>
							<label class="radio-inline" for="sqlserver">
								<input type="radio" name="dbType" id="sqlserver"
									value="sqlserver"
									<%=dbType_form.equals("sqlserver") ? "checked" : ""%>>
								SQL Server
							</label>

							<label class="radio-inline" for="mysql">
								<input type="radio" name="dbType" id="mysql" value="mysql"
									<%=dbType_form.equals("mysql") ? "checked" : ""%>>
								MySQL
							</label>

							<label class="radio-inline" for="oracle">
								<input type="radio" name="dbType" id="oracle" value="oracle"
									<%=dbType_form.equals("oracle") ? "checked" : ""%>>
								Oracle
							</label>
						</div>

						<div class="form-group">
							<label for="dburl_ip">
								数据库IP地址：
							</label>
							<input type="text" class="form-control"
								value="<%=dburl_ip_form%>" id="dburl_ip" name="dburl_ip" />
						</div>

						<div class="form-group">
							<label for="dburl_port">
								数据库端口：
							</label>
							<input type="text" class="form-control"
								value="<%=dburl_port_form%>" id="dburl_port" name="dburl_port" />
						</div>

						<div class="form-group">
							<label for="schema">
								schema:
							</label>
							<input type="text" class="form-control"
								value="<%=dburl_schema_form%>" id="dburl_schema"
								name="dburl_schema" />
						</div>


						<div class="form-group">
							<label for="dbname">
								表名称：
							</label>
							<input class="form-control" type="text" value="<%=dbname_form%>"
								id="dbname" name="dbname" />
						</div>

						<div class="form-group">
							<label for="username">
								用户名：
							</label>
							<input class="form-control" type="text"
								value="<%=username_form%>" id="username" name="username" />
						</div>

						<div class="form-group">
							<label for="password">
								密码：
							</label>
							<input class="form-control" type="password"
								value="<%=password_form%>" id="password" name="password" />
						</div>

						<div class="form-group">
							<label for="nbline">
								输出行数：
							</label>
							<input class="form-control" type="text" value="<%=nbline_form%>"
								id="nbline" name="nbline" />
						</div>

						<div class="form-group">
							<input type="submit" class="btn btn-primary" value="提交">
						</div>
					</form>

					<%
						if (submitsuccess) {
							out.println("<p class=\"text-success\">提交成功</p>");
						}
					%>
				</div>
				<!-- end of right -->
			</div>
		</div>
		<!-- end of container -->

		<script type="text/javascript">
	function setDefault() {
		if (document.getElementById("sqlserver").checked == true) {
			document.getElementById("dburl_ip").value = "10.214.52.132";
			document.getElementById("dburl_port").value = "1433";
			document.getElementById("dburl_schema").value = "test";
			document.getElementById("dbname").value = "WCMMetaTablejgml";
			document.getElementById("username").value = "canlian";
			document.getElementById("password").value = "canlian";
		}
		if (document.getElementById("mysql").checked == true) {
			document.getElementById("dburl_ip").value = "10.214.52.132";
			document.getElementById("dburl_port").value = "3306";
			document.getElementById("dburl_schema").value = "test";
			document.getElementById("dbname").value = "WCMMetaTablejgml";
			document.getElementById("username").value = "zhouyu";
			document.getElementById("password").value = "zhouyu";
		}
		if (document.getElementById("oracle").checked == true) {
			document.getElementById("dburl_ip").value = "10.214.52.132";
			document.getElementById("dburl_port").value = "1521";
			document.getElementById("dburl_schema").value = "orcl";
			document.getElementById("dbname").value = "WCMMetaTablejgml";
			document.getElementById("username").value = "canlian";
			document.getElementById("password").value = "canlian";
		}
	}
</script>

	</body>
</html>