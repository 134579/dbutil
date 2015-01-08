<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">

		<title>发生了一些错误</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

	</head>

	<%
		String error = "";
		if (exception != null) {
			String message = exception.getMessage();
			String[] mess = message.split(":", 2);
			if (mess.length == 2) {
				error = mess[1];
			} else {
				error = message;
			}
		}
	%>
	<body>
		<div id="wrapper">
			<%@ include file="header.jsp"%>
			<div class="container" class="alert alert-danger">
				<h3>
					错误
				</h3>
				<h4>
					<%=error%>
				</h4>
				<a class="btn btn-primary btn-lg" href="javascript: history.back();">返回</a>
			</div>
		</div>
	</body>
</html>
