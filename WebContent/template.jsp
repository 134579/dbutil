<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="zh-CN">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="Keywords" content="残疾人康复服务平台">
			<meta name="Description" content="残疾人康复服务平台">
				<title>残疾人康复信息采集与交换系统</title>
				<link rel="shortcut icon" href="_images/logo.ico"
					type="image/x-icon" />
				<script type="text/javascript" src="_js/Tag.js"></script>
				<!--[if IE 6]>
        <script type="text/javascript" src="http://www.cdpsn.org.cn/_js/belatedPNG.js"></script>
    <![endif]-->
				<script type="text/javascript" src="_js/jquery.min.js"></script>
				<script type="text/javascript" src="_js/common.js"></script>
				<link rel="stylesheet" type="text/css" href="_css/total.css" />
				<link rel="stylesheet" type="text/css" href="_css/home.css" />
				<link rel="stylesheet" type="text/css" href="_css/accessible.css" />
				<script type="text/javascript" src="_js/product/trsCp.js"></script>
				<script type="text/javascript" src="_js/tabs.js"></script>
				<script type="text/javascript">
	$(document).ready(function() {
		$(".topnav").click(function() {
			$(".navarea").slideToggle(300);
		});
	});
</script>
	</head>
	<body class="body2">
		<div id="skiptomain">
			<a href="#skip" title="跳转到主要内容区域" accesskey="b">skip to main</a>
		</div>
		<div id="wrapper">
			<!--顶部BAR-->
			<!-- top begin -->
			<div id="top">
				<ul class="l">
					<li class="acce">
						<a title="无障碍浏览" accesskey="Z" href="#" id="accessible">无障碍浏览</a>
					</li>
					<li>
						<a
							href="http://www.cdpsn.org.cn/static/yzmdownload20120517/yzmdownload.html"
							target="_blank">邦邦听图客户端下载</a>
					</li>
					<li class="listen">
						<a title="语音版" accesskey="Z"
							href="http://voice.cdpsn.org.cn/cdpsn.htm" target="_blank">语音版</a>
					</li>
				</ul>
				<ul class="r">
					<li>
						<a href="http://www.cdpf.org.cn/" target="_blank">中国残疾人联合会</a>|
						<a title="加入收藏" href="#" id="addFavorite">加入收藏</a>|
						<a title="设为首页" href="#" id="setHomepage">设为首页</a>
					</li>
				</ul>
			</div>
			<!-- top end -->
			<!--header-->
			<!-- head begin -->
			<div id="head" style="background: none">
				<div id="logo">
					<a href="http://www.cdpsn.org.cn/index.htm" title="点击进入中国残疾人服务网首页"><img
							src="_images/logo3.png" /> </a>
				</div>
				<div style="float: right; margin-top: 40px;">
					<a class="topnav" href="#" style="margin: 0 10px 0 0">设置 <img
							src="_images/img12.png" /> </a>
					<a href="#">关于</a>

					<div class="navarea"
						style="position: absolute; z-index: 300; background: rgba(51, 51, 51, .1); padding: 8px; width: 100px; display: none;">
						<ul>
							<li>
								<a href="#">链接一</a>
							</li>
							<li>
								<a href="#">链接一</a>
							</li>
							<li>
								<a href="#">链接一</a>
							</li>
							<li>
								<a href="#">链接一</a>
							</li>
						</ul>
					</div>

				</div>

				<ul class="topul">
					<li class="activ">
						<a href="#">数据库去重</a>
					</li>
					<li>
						<a href="#">数据库清洗</a>
					</li>
					<li>
						<a href="#">康复机构地址拆分</a>
					</li>
				</ul>

			</div>
			<!-- head end -->
			<!-- location begin -->
			<div>
				<a id="skip" href="#" title="服务网主要内容区域" accesskey="b"></a>
			</div>
			<!-- content begin -->

			<div class="area1">
				<h1>
					残疾人康复信息采集与交换系统
				</h1>
				<p>
					一个跨平台的轻量级数据库管理系统，提供了去重，更新，增删等数据库常用功能。
				</p>
				<div>
					<input name="" class="bnt" type="button" value="开始前，请先设置数据库参数" />
				</div>
			</div>
			<!-- concent end -->

			﻿
			<!-- Piwik -->
			<script type="text/javascript">
	var pkBaseURL = (("https:" == document.location.protocol) ? "https://tj.cdpsn.org.cn/"
			: "http://tj.cdpsn.org.cn/");
	document.write(unescape("%3Cscript src='" + pkBaseURL
			+ "piwik.js' type='text/javascript'%3E%3C/script%3E"));
</script>
			<script type="text/javascript">
	try {
		var piwikTracker = Piwik.getTracker(pkBaseURL + "piwik.php", 1);
		piwikTracker.trackPageView();
		piwikTracker.enableLinkTracking();
	} catch (err) {
	}
</script>
			<noscript>
				<p>
					<img src="http://tj.cdpsn.org.cn/piwik.php?idsite=1"
						style="border: 0" alt="" />
				</p>
			</noscript>
			<!-- End Piwik Tracking Code -->
			<script type="text/javascript">
	var _bdhmProtocol = (("https:" == document.location.protocol) ? " https://"
			: " http://");
	document
			.write(unescape("%3Cscript src='"
					+ _bdhmProtocol
					+ "hm.baidu.com/h.js%3F51e70b9d8bffacd961bf86d379f68e5e' type='text/javascript'%3E%3C/script%3E"));
</script>
		</div>
		<script type="text/javascript">
	jQuery(document).ready(

			function() {

				getCategory('101', 'category');
				getCategory('100', 'appPeople', '');
				getCategory('118', 'disCategory', '');
				$("#category").change(
						function() {
							$("#subCategory").empty();
							document.getElementById("subCategory").options
									.add(new Option("二级分类", ""));
							$("#thirdCategory").empty();
							document.getElementById("thirdCategory").options
									.add(new Option("三级分类", ""));
							getCategory($(this).val(), 'subCategory');
						});

				$("#subCategory").change(

						function() {
							$("#thirdCategory").empty();
							document.getElementById("thirdCategory").options
									.add(new Option("三级分类", ""));
							getCategory($(this).val(), 'thirdCategory');
						});
			});
</script>
		<script type="text/javascript">
	function subForm(type, i) {
		var f = document.getElementById('form_' + type + '_' + i);
		f.submit();
	}
</script>
	</body>
</html>
