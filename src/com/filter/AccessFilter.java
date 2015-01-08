package com.filter;

import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Time;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.Timer;

import org.apache.commons.codec.binary.Base64;

public class AccessFilter implements Filter {
	private static String SECRET_STRING = "geij34ifmeiio!#";
	private static String NOT_LOGIN = "http://kf.infoacc.cn/sso/login?url=http%3A%2F%2Fkangfu.cdpsn.org.cn%2Fdbutil";
	private static String LOGOUT = "http://kf.infoacc.cn/sso/logout?url=http%3A%2F%2Fkangfu.cdpsn.org.cn%2F";

	public static Cookie getCookieByName(HttpServletRequest request, String name) {
		Map<String, Cookie> cookieMap = readCookieMap(request);
		if (cookieMap.containsKey(name)) {
			Cookie cookie = (Cookie) cookieMap.get(name);
			return cookie;
		} else {
			return null;
		}
	}

	private static Map<String, Cookie> readCookieMap(HttpServletRequest request) {
		Map<String, Cookie> cookieMap = new HashMap<String, Cookie>();
		Cookie[] cookies = request.getCookies();
		if (null != cookies) {
			for (Cookie cookie : cookies) {
				cookieMap.put(cookie.getName(), cookie);
			}
		}
		return cookieMap;
	}

	public String hashInBase64(String val, String secret) {
		try {
			Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
			SecretKeySpec secret_key = new SecretKeySpec(secret.getBytes(),
					"HmacSHA256");
			sha256_HMAC.init(secret_key);

			String hash = Base64.encodeBase64String(sha256_HMAC.doFinal(val
					.getBytes()));
			return hash.replaceAll("\\=+$", ""); // remove trailing '='
		} catch (Exception e) {
			return "";
		}

	}

	// 验证逻辑
	public void blabla() {

	}

	public void destroy() {
	}

	public void doFilter(ServletRequest arg0, ServletResponse arg1,
			FilterChain filterChain) throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) arg0;
		HttpServletResponse response = (HttpServletResponse) arg1;
		HttpSession session = request.getSession();

		// accept all user
		 filterChain.doFilter(arg0, arg1); return;

		// Cookie cookie = getCookieByName(request, "username");
		// if (cookie == null) {
		// response.sendRedirect(NOT_LOGIN);
		//
		// return;
		// } else {
		// String cookieValue = cookie.getValue();
		// String[] usernameAndSig = URLDecoder.decode(cookieValue, "utf8")
		// .split("\\.");
		// String username = usernameAndSig[0].substring(2);
		// String signature = usernameAndSig[1];
		//
		// String hashValue = hashInBase64(username, SECRET_STRING);
		//
		// if (!hashValue.equals(signature)) {
		// response.sendRedirect(NOT_LOGIN);
		// return;
		// } else {
		// filterChain.doFilter(arg0, arg1);
		// return;
		// }
		// }

	}

	public void init(FilterConfig arg0) throws ServletException {
	}
}