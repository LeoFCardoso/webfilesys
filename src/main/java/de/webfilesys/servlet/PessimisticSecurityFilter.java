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
 * It should be complemented by user interface maintenance to hide these options forbidden
 * 
 * @author leonardo
 * 
 */
public final class PessimisticSecurityFilter implements Filter {

	/**
	 * All but these commands will be redirected to "forbidden" command
	 */
	private static final String[] allowedCommands = { "admin", "ajaxCollapse", "ajaxExp", "exp",
			"findFileTree", "fmfindfile", "forbidden", "getResourceBundle", "listFiles", "login", "logout",
			"menuBar", "mobile", "multiDownload", "multiFileDownloadPrompt", "refresh", "search",
			"setScreenSize" };

	/**
	 * All but these cmds will be redirected to "forbidden" command. CMD are somethig like a complementary
	 * command. Each entry must have this form: command(cmd)
	 */
	private static final String[] allowedCmds = { "mobile(folderFileList)", "multiFileDownloadPrompt(download)" };

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse,
	 * javax.servlet.FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		String valueCommand = request.getParameter("command");
		String valueCommandStr = (valueCommand == null) ? "null" : valueCommand;

		String valueCmd = request.getParameter("cmd");
		String valueCmdStr = (valueCmd == null) ? "null" : valueCmd;

		String completeCommandCmdStr = valueCommandStr + '(' + valueCmdStr + ')';

		boolean allowedCommand = Arrays.asList(allowedCommands).contains(valueCommand);
		boolean allowedCmd = Arrays.asList(allowedCmds).contains(completeCommandCmdStr);

		if ((valueCommand == null) || (valueCommand != null && allowedCommand)) {
			if ((valueCmd == null) || (valueCmd != null && allowedCmd)) {
				chain.doFilter(request, response);
				return;
			} else {
				// Fail cmd
				handleRequestFail(request, response, valueCommand, valueCmd);
				return;
			}
		} else {
			// Fail command
			handleRequestFail(request, response, valueCommand, valueCmd);
		}
	}

	private void handleRequestFail(ServletRequest request, ServletResponse response, String valueCommand,
			String valueCmd) throws IOException {

		HttpServletRequest requestHttp = (HttpServletRequest) request;

		HttpServletResponse responseHttp = (HttpServletResponse) response;
		responseHttp.sendRedirect(requestHttp.getContextPath() + "/servlet?command=forbidden");

		String loggedInUser = (String) ((requestHttp.getSession().getAttribute("userid") != null) ? requestHttp
				.getSession().getAttribute("userid") : "no user logged on");

		Logger.getLogger(getClass()).warn(
				loggedInUser + " tried not allowed command (cmd): " + valueCommand + " (" + valueCmd
						+ "). Redirecting to forbidden page.");
	}

	public void destroy() {
	}

	public void init(FilterConfig filterConfig) {
	}
}
