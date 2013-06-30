package de.webfilesys.servlet;

import java.io.IOException;
import java.security.Principal;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

/**
 * Filter to get JAAS auth user (if exists) and bypass webfilesys native auth system
 * 
 * @author Leonardo F. Cardoso
 * 
 */
public final class JAASSecurityFilter implements Filter {

	public void doFilter(ServletRequest sreq, ServletResponse sres, FilterChain chain) throws IOException,
			ServletException {

		HttpServletResponse response = (HttpServletResponse) sres;
		HttpServletRequest request = (HttpServletRequest) sreq;

		HttpSession session = request.getSession(true);

		String webfilesysLoggedOnUser = (String) session.getAttribute("userid");

		Principal userPrincipal = request.getUserPrincipal();

		if ((webfilesysLoggedOnUser == null) && (userPrincipal != null)) {
			// Login is done!
			Logger.getLogger(getClass()).info(
					"User " + userPrincipal.getName()
							+ " has logged in through JAAS. I will setup webfilesys auth scheme.");
			WebFileSysServlet.configureSessionAfterLogin(request, userPrincipal.getName());
		}

		chain.doFilter(request, response);
	}

	public void destroy() {
	}

	public void init(FilterConfig filterConfig) {
	}
}
