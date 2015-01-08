<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="tools.util.sql.SQLWrapper"%>
<!DOCTYPE HTML>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="./css/bootstrap.css" rel="stylesheet" />
		<script type="text/javascript" src="./jquery.js"></script>
		<script type="text/javascript" src="./js/bootstrap.js"></script>
		<script type="text/javascript" src="./js/Chart.js"></script>
		<title>数据库清洗</title>
	</head>
	<body>
		<%
	session.setAttribute("pageNum",2);
	%>
		<%@include file="header.jsp"%>

		<div class="container">
			<div class="row">
				<div class="col-md-0"></div>
				<!-- begin of left pane -->
				<div class="col-md-12">
					<!-- body here -->
					<%
					boolean set = true;
																	ArrayList<ArrayList<String>> dirty = null;
																	ArrayList<String> colList = null;
																	ArrayList<Integer> nullSum = null;
																	SQLWrapper sqlWrapper = null;
																	int nrow = -1;
																	if (session.getAttribute("sqlwrapper") == null) {
																		set = false;
																		response.sendRedirect("/dbutil/index.jsp");
																	} else {
																		sqlWrapper = (SQLWrapper) session.getAttribute("sqlwrapper");
																		colList = sqlWrapper.getColumnList(sqlWrapper.dbname);
																		dirty = sqlWrapper.findDirty(sqlWrapper.dbname, 10);
																		nullSum = sqlWrapper.findNullSum();
																		nrow = sqlWrapper
																				.executeQuery("select * from " + sqlWrapper.dbname,
																						Integer.MAX_VALUE).size() - 1;
																	}
				%>


					<%
					
					if (set) {
						
						
				%>

					<h3>
						数据库名称：<%=sqlWrapper.dbname%>
						总列数：<%=colList.size() %>
						总行数：<%=nrow%>
					</h3>



					<canvas id="myChart" width="800" height="400">
					</canvas>

					<%
						// for column < 30
						String labels = "";
						String data = "";
						int mincol = 10;
						int maxcol = 20;
						if(nullSum.size() <= maxcol)
						{
							labels = labels.concat("[ ");
							data = data.concat("[ ");
							for(int i =0;i<nullSum.size();i++)
							{
								labels = labels.concat("\""+ Integer.toString(i)+"\",");
								data = data.concat(nullSum.get(i).toString()+",");
							}
							labels = labels.concat(" ]");
							data = data.concat(" ]");
						}
						else
						{
							int nRealCol = nullSum.size();
							int nCol = mincol;
							// make to last column "almost" as wide as other columns 
							for(int i = mincol + 1; i <= maxcol; i++)
							{
								
								if( Math.abs(nRealCol % i -nRealCol / i) < Math.abs(nRealCol % nCol - nRealCol / nCol))
									nCol = i;
								else if(Math.abs(nRealCol % i -nRealCol / i) == Math.abs(nRealCol % nCol - nRealCol / nCol) && nRealCol % i < nRealCol % nCol)
									nCol = i;
								
								
							}
							labels = labels.concat("[ ");
							data = data.concat("[ ");
							// nRealCol = nCol * step + rem;
							int step = nRealCol / nCol;
							for(int i = 0; i < nCol; i++)
							{
								int begin = i * step;
								int end = (i + 1)  * step - 1;
								labels = labels.concat("\"" + Integer.toString(begin) +"-" + Integer.toString(end) + "\",");
								int sum = 0;
								for(int j = begin; j <= end; j++)
									sum += nullSum.get(j);
								data = data.concat(Integer.toString(sum) + ",");
							}
							if(nRealCol % nCol == 0)
							{
								labels = labels.concat(" ]");
								data = data.concat(" ]");
							}
							else
							{
								int begin = nRealCol - nRealCol % nCol;
								int end = nRealCol - 1;
								if(begin != end)
									labels = labels.concat("\"" + Integer.toString(begin) +"-" + Integer.toString(end) + "\",");
								else
									labels = labels.concat("\"" + Integer.toString(begin) + "\",");
								int sum = 0;
								for(int j = begin; j <= end; j++)
									sum += nullSum.get(j);
								data = data.concat(Integer.toString(sum) + ",");
								labels = labels.concat(" ]");
								data = data.concat(" ]");
							}
							
						}
						
					%>
					<script type="text/javascript">
	var ctx = document.getElementById("myChart").getContext("2d");
	var myNewChart = new Chart(ctx);
	var data = {
		labels :
<%=labels %>
	,
		datasets : [ {
			fillColor : "rgba(151,187,205,0.5)",
			strokeColor : "rgba(151,187,205,1)",
			data :
<%=data %>
	} ]
	};

	myNewChart.Bar(data);
</script>
					<h3>
						下面是其中空值最多的行：
					</h3>
					<form action="cleanResult.jsp" method="post" target="_blank"
						class="form-inline">
						<div class="table-responsive">
							<table class="table table-striped table-bordered table-condensed">
								<tr>
									<th>
										全选？
										<div class="checkbox">
											<input type="checkbox" onclick="selectAll()">
										</div>
									</th>
									<%
									for (int i = 0; i < colList.size(); i++) {
								%>
									<th><%=colList.get(i)%></th>
									<%
									}
								%>
								</tr>

								<%
								for (int i = 0; i < dirty.size(); i++) {
							%>
								<tr>
									<td>
										<div class="checkbox">
											<input type="checkbox" name="rowSelect" value="<%=i%>">
										</div>
									</td>
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
							%>
							</table>
						</div>
						<input type="submit" class="btn btn-primary" value="删除选定行">
					</form>

					<%
					}
				%>
				</div>
			</div>
		</div>
	</body>
	<script type="text/javascript">
	selected = true;
	function selectAll() {
		var checkBoxes = document.getElementsByName("rowSelect");
		for ( var i = 0; i < checkBoxes.length; i++) {
			if (selected == true)
				checkBoxes[i].checked = true;
			else
				checkBoxes[i].checked = false;
		}
		selected = !selected;
	}
</script>
</html>