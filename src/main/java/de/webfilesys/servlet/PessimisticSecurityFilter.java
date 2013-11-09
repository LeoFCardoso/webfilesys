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

import org.apache.log4j.Logger;

/**
 * This filter modifies some functions of WebFileSys to prevent some features to be used.
 * 
 * It should be complemented by user interface maintenance to hide these options
 * 
 * @author leonardo
 * 
 */
public final class PessimisticSecurityFilter implements Filter {

	/**
	 * All but these commands will be redirected to "forbidden" command
	 */
	private static final String[] allowedCommands = { "admin", "ajaxCollapse", "ajaxExp", "exp",
			"findFileTree", "fmfindfile", "forbidden", "getFile", "getResourceBundle", "listFiles", "login",
			"logout", "menuBar", "multiDownload", "multiFileDownloadPrompt", "refresh", "search",
			"setScreenSize" };

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

		if (valueCommand != null && !Arrays.asList(allowedCommands).contains(valueCommand)) {
			HttpServletResponse responseHttp = (HttpServletResponse) response;
			responseHttp.sendRedirect(requestHttp.getContextPath() + "/servlet?command=forbidden");

			String loggedInUser = (String) ((requestHttp.getSession().getAttribute("userid") != null) ? requestHttp
					.getSession().getAttribute("userid") : "no user logged on");

			Logger.getLogger(getClass()).warn(
					loggedInUser + " tried not allowed command: " + valueCommand
							+ ". Redirecting to forbidden page.");
			return;
		}

		chain.doFilter(request, response);

	}

	public void destroy() {
	}

	public void init(FilterConfig filterConfig) {
	}
}
