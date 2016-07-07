package de.webfilesys.servlet;

import java.io.IOException;
import java.util.Arrays;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * This filter is a bugfix for an unexpected behaviour when a link (view file) is bookmarked and the session
 * is not open.
 * 
 * Give a little bit more security also
 * 
 * @author leonardo
 * 
 */
public final class ValidateLogonFilter implements Filter {

	private static final String[] allowedCommands = { "versionInfo", "login", "loginForm" };

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse,
	 * javax.servlet.FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		String valueCommand = request.getParameter("command");
		HttpServletRequest requestHttp = (HttpServletRequest) request;

		if (!(Arrays.asList(allowedCommands).contains(valueCommand))
				&& (requestHttp.getSession().getAttribute("userid") == null)) {
			// Redirect to logon
			((HttpServletResponse) response).sendRedirect(requestHttp.getContextPath()
					+ "/servlet?command=loginForm");
		} else {
			chain.doFilter(request, response);
		}

	}

	public void destroy() {
	}

	public void init(FilterConfig filterConfig) {
	}
}
