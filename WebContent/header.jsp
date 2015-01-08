<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%@ include file="css.jsp"%>
<!-- begin of nav -->
<div id="top" class="container">
	<ul class="l">
		<!-- 	<li class="acce">
			<a title="无障碍浏览" accesskey="Z" href="#" id="accessible"></a>
		</li>
	-->
	</ul>
	<ul class="r">
		<!-- 
		<li>
			<a href="http://www.cdpf.org.cn/" target="_blank"></a>|
			<a title="加入收藏" href="#" id="addFavorite"></a>
		</li>
	-->
	</ul>
</div>

<div class="container-top container">
	<div class="navbar navbar-default">
		<div class="navbar-header">
			<div class="logo">
				<a href="/dbutil" title="点击进入首页"><img src="_images/logo3.png">
				</a>
			</div>
		</div>
		<ul class="topul">

			<%
				int pageNum = 0;
				if (session.getAttribute("pageNum") != null) {
					pageNum = (Integer) session.getAttribute("pageNum");
				}
			%>
			<li
				<%if (pageNum == 1) {
				out.println("class=\"activ\"");
			}%>>
				<a href="duplicate.jsp">数据库去重</a>
			</li>
			<li
				<%if (pageNum == 2) {
				out.println("class=\"activ\"");
			}%>>
				<a href="clean.jsp">数据库清洗</a>
			</li>
			<li
				<%if (pageNum == 3) {
				out.println("class=\"activ\"");
			}%>>
				<a href="update.jsp">康复机构地址拆分</a>
			</li>

			<li>
				<a href="fileManeger.jsp">文件管理</a>
			</li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
			<!-- 
			<li class="dropdown">
				<a href="#" class="dropdown-toggle" data-toggle="dropdown">设置<b
					class="caret"></b> </a>
				<ul class="dropdown-menu">
					<li>
						<a href="setting.jsp">设置</a>
					</li>
					<li class="divider"></li>

				</ul>
			</li>
			 -->
			<li>
				<a href="setting.jsp">设置</a>
			</li>
			<li>
				<a href="http://kf.infoacc.cn/" target="_blank">关于</a>
			</li>
		</ul>
	</div>
</div>
<!-- end of nav -->