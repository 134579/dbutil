﻿/**
 * common script file.
 * @version 1.0
 */
jQuery(document).ready(function(){

	//page tools
    $('#setHomepage').click(function(){
        if (document.all) {
            document.body.style.behavior = 'url(#default#homepage)';
            document.body.setHomePage(location.href);
            
        }
        else 
            if (window.sidebar) {
                if (window.netscape) {
                    try {
                        netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
                    } 
                    catch (e) {
                        alert("该操作被浏览器拒绝，如果想启用该功能，请在地址栏内输入 about:config,然后将项 signed.applets.codebase_principal_support 值该为true");
                   		 return false;
					}
                }
                var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components.interfaces.nsIPrefBranch);
                prefs.setCharPref('browser.startup.homepage', 'http://www.cdpsn.org.cn');
            }
		 return false;
    });
    $('#addFavorite').click(function(){
        if (document.all) {
            window.external.addFavorite(location.href, document.title);
        }
        else 
            if (window.sidebar) {
                window.sidebar.addPanel(document.title, location.href, "");
            }
        return false;
    });
    
	//cookie fucntions
    function setCookie(name, value, days){
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            var expires = "; expires=" + date.toGMTString();
        }
        else 
            var expires = "";
        document.cookie = name + "=" + value + expires + "; path=/";
    }
    function getCookie(name){
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') 
                c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) == 0) 
                return c.substring(nameEQ.length, c.length);
        }
        return null;
    }
    function eraseCookie(name){
        setCookie(name, "", -1);
    }
  
	/**
	 * accessible tools by huangwenping
	 */
	var accessible_enable = false;
	//text mode
	function acc_textmode(){
        if (accessible_enable == false || $('#textmode').hasClass('visual')) {
            eraseCookie('accessible_textmode');
            for (var i = 0; i < document.styleSheets.length; i++) {
				if(document.styleSheets[i].href != null && document.styleSheets[i].href.indexOf('accessible.css')<0){
					document.styleSheets[i].disabled = false;
				}
            }
            $('#textmode').removeClass('visual').text('纯文本通道');
        }
        else {
            setCookie('accessible_textmode', 1, 360);
            for (var i = 0; i < document.styleSheets.length; i++) {
                if(document.styleSheets[i].href != null && document.styleSheets[i].href.indexOf('accessible.css')<0){
					document.styleSheets[i].disabled = true;
				}
            }
            $('#textmode').addClass('visual').text('切为可视模式');
        }
    }
	//high contrast
	function acc_highcontrast(){
	
        if (accessible_enable == false || $('#highcontrast').hasClass('high')) {
			eraseCookie('accessible_highcontrast');
            $('body,#header').css('background', '#FFFFFF');
            $('body').css('color', '#333333');
            $('a').css('color', '#000000');
            $('#site_links a').css('color', '#008138');
            $('#navigation a.top').css('color', '#008138');
            $('#highcontrast').removeClass('high').text('高对比度');
			$('.topnews').css('background', 'url("http://www.cdpsn.org.cn/_images/bg_newslist.png") no-repeat scroll 0 0 transparent;');
			$('.title_notice').css('background', '#ffffff');
			$('.cont_notice').css('background', '#ffffff');
			$('#head #menu ul li').css('color', '#ffffff');
			$('.menuOn').css('background', '#ffffff');
			$('.menuOff').css('background', '#ffffff');
			$('.news_cont1').css('background', '#ffffff');
			$('.news_cont2').css('background', '#ffffff');
			$('.contbox').css('background', '#ffffff');
        }
        else {
			setCookie('accessible_highcontrast', 1, 360);
            $('body,#header').css('background', '#000000');
            $('a,body').css('color', '#FFFFFF');
            $('#site_links a,.misc_logout,div.misc_logout a.message').css('color', '#000000');
			$('.topnews').css('background', '#000000');
			$('.title_notice').css('background', '#000000');
			$('.cont_notice').css('background', '#000000');
			$('.menuOn').css('background', '#999999');
			$('.menuOff').css('background', '#555455');
			$('.news_cont1').css('background', '#000000');
			$('.news_cont2').css('background', '#000000');
			$('.contbox').css('background', '#000000');
            $('#highcontrast').addClass('high').text('还原对比度');
        }
	}
  
    if (getCookie('accessible') == 1) {
        accessible();
    }
	
    if (getCookie('accessible_textmode') == 1) {
        accessible();
		acc_textmode();
    }
	if (getCookie('accessible_highcontrast') == 1) {
		accessible();
		acc_highcontrast();
    }
	
	//attach  shortcut event
	// ctrl + shirt + A  text mode
    $(document).keydown(function(event){
        if (event.ctrlKey && event.shiftKey && event.keyCode == '65') {
			accessible();
			acc_textmode();
        }
    });
	// ctrl + shirt + S  high contrast
	$(document).keydown(function(event){
        if (event.ctrlKey && event.shiftKey && event.keyCode == '83') {
            accessible();
			acc_highcontrast();
        }
    });
    
	//attach click event accessible 
	$('#accessible').click(accessible);
	
    function accessible(){
        if (!$('#acctoolbar')[0]) {
			accessible_enable = true;
			
		    var link = document.createElement('LINK');
		    link.setAttribute('rel','stylesheet');
		    link.setAttribute('type','text/css');
		    link.setAttribute('href','${homeModule}/css/accessible.css');
		    document.getElementsByTagName('head')[0].appendChild(link);
			
			//initial buttons
            $('body').prepend('<div id="acctoolbar"><button class="first" id="textmode">纯文本通道</button><button id="textin">文字放大</button><button id="textout">文字缩小</button><button id="highcontrast">高度对比</button><button id="guides">辅助线</button><button id="viewin">界面放大</button><button id="viewout">界面缩小</button><button id="acchelp">无障碍说明</button><button id="accclose" class="last" >关闭</button></div>');
            $('#acctoolbar').css('left', $('#wrapper').offset().left + 1);
            $('#wrapper').css('padding-top', '31px');
			//ie6 style hack
            if ($.browser.msie && $.browser.version.substr(0, 1) < 7) {
                $('#acctoolbar').css('position', 'absolute');
                $(window).scroll(function(){
                    $('#acctoolbar').css('top', $(window).scrollTop());
                })
            }
            
            //text mode 
            $('#textmode').click(acc_textmode);
			
			//high contrast
			$('#highcontrast').click(acc_highcontrast);
			
			//text zoom in
            $('#textin').click(function(){
                var s = parseInt($('body').css('font-size').replace('px', ''), 10);
                if (s <= 14) {
                    s = s + 2;
                }
                $('body').css('font-size', s + 'px');
            });
			//text zoom out
            $('#textout').click(function(){
                var s = parseInt($('body').css('font-size').replace('px', ''), 10);
                if (s >= 12) {
                    s = s - 2;
                }
                $('body').css('font-size', s + 'px');
            });
			
			//guide lines
            $('#guides').click(function(){
                if ($('#guides_horiz')[0]) {
                    $('#guides_horiz,#guides_verti').remove();
                    $('body').unbind("mousemove");
                    if ($.browser.msie && $.browser.version.substr(0, 1) < 7) {
                        $(window).unbind("resize");
                    }
                }
                else {
                    $('body').append('<div id="guides_horiz"></div><div id="guides_verti"></div>').mousemove(function(pos){
                        //console.info($(document).scrollTop());
                        $('#guides_horiz').css('top', pos.clientY + 10 + $(document).scrollTop());
                        $('#guides_verti').css('left', pos.clientX + 10).css('top', $(document).scrollTop());
                    });
                    if ($.browser.msie && $.browser.version.substr(0, 1) < 7) {
                        $('#guides_verti').css('height', $(window).height());
                        $(window).resize(function(){
                            ('#guides_verti').css('height', $(window).height());
                        });
                    }
                }
            });
            
			//view zoom in
            $('#viewin').click(function(){
                var s = $('#wrapper').css('zoom');
                if (s == 'normal') {
                    $('#wrapper').css('zoom', 1.2);
                }
                else {
                    s = parseFloat(s, 10);
                    if (s <= 2) {
                        s = s + 0.2;
                    }
                    $('#wrapper').css('zoom', s);
                }
            });
			//view zoom out
            $('#viewout').click(function(){
                var s = $('#wrapper').css('zoom');
                if (s != 'normal') {
                    s = parseFloat(s, 10);
                    if (s > 1) {
                        s = s - 0.2;
                    }
                    $('#wrapper').css('zoom', s);
                }
            });
            
            $('#acchelp').click(function(){
                window.location.href="http://www.cdpsn.org.cn/static/accessibility.htm";
            });
            
			//close button
            $('#accclose').click(function(){
				accessible_enable = false;
				
                acc_textmode();
                acc_highcontrast();  
				          
                if (parseInt($('body').css('font-size').replace('px', ''), 10) != 12) {
                    $('body').css('font-size', '12px');
                }
                
                if ($('#wrapper').css('zoom') != 'normal') {
                    $('#wrapper').css('zoom', 'normal');
                }
                
				if ($.browser.msie && $.browser.version.substr(0, 1) < 7) {
                    $(window).unbind("scroll");
                }
                
                if ($('#guides_horiz')[0]) {
                    $('#guides_horiz,#guides_verti').remove();
                    $('body').unbind("mousemove");
                    if ($.browser.msie && $.browser.version.substr(0, 1) < 7) {
                        $(window).unbind("resize");
                    }
                }
				
                $('#acctoolbar').remove();
                $('#wrapper').css('padding-top', 0);
				
				//remove cookie
                eraseCookie('accessible');
            });
			
			//save cookie
			setCookie('accessible', 1, 360);
        }
        return false;
    }
});
