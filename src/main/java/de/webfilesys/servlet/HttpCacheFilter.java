package de.webfilesys.servlet;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

/**
 * Simple http cache filter. Based on
 * http://www.javablog.fr/javaweb-set-cache-control-in-reponse-with-http-filter-httpcachefilter.html
 * 
 * @author leonardo
 */
public class HttpCacheFilter implements Filter {

	private final static String HEADER_GET_KEY = "Cache-Control";
	private final static String HEADER_PRAGMA = "Pragma";
	private final static String HEADER_EXPIRES = "Expires";

	private String cacheLifeTimeInstruction = null;

	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		if (null != cacheLifeTimeInstruction) {
			((HttpServletResponse) res).setHeader(HEADER_GET_KEY, cacheLifeTimeInstruction);
			((HttpServletResponse) res).setHeader(HEADER_PRAGMA, null);
			final int CACHE_DURATION_IN_SECOND = 60 * 60 * 24 * 5; // 5 days
			final long CACHE_DURATION_IN_MS = CACHE_DURATION_IN_SECOND * 1000;
			long now = System.currentTimeMillis();
			((HttpServletResponse) res).setDateHeader(HEADER_EXPIRES, now + CACHE_DURATION_IN_MS);
			Logger.getLogger(getClass())
					.debug("Resource filtered for browse http cache: " + ((HttpServletRequest) req).getRequestURI());
		}
		chain.doFilter(req, res);
	}

	public void init(FilterConfig config) throws ServletException {
		cacheLifeTimeInstruction = config.getInitParameter(HEADER_GET_KEY);
	}

	public void destroy() {
		cacheLifeTimeInstruction = null;
	}
}
